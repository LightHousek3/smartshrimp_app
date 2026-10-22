import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/widgets/app_notice.dart';
import 'package:smartshrimp_app/features/inventory/domain/entities/inventory.dart';
import 'package:smartshrimp_app/features/inventory/domain/entities/inventory_supplier.dart';
import 'package:smartshrimp_app/features/inventory/domain/inventory_rules.dart';
import 'package:smartshrimp_app/features/inventory/presentation/inventory_view_data.dart';
import 'package:smartshrimp_app/features/inventory/presentation/view_models/inventory_controller.dart';
import 'package:smartshrimp_app/features/inventory/presentation/view_models/supplier_controller.dart';
import 'package:smartshrimp_app/features/inventory/presentation/widgets/inventory_compliance_editor.dart';
import 'package:smartshrimp_app/features/inventory/presentation/widgets/inventory_product_image.dart';
import 'package:smartshrimp_app/features/inventory/presentation/widgets/inventory_ui.dart';

typedef _MaterialPhoto = ({String? url, Uint8List? bytes, String? fileName});
const _emptyPhoto = (url: null, bytes: null, fileName: null);
bool _hasPhoto(_MaterialPhoto photo) =>
    photo.url != null || photo.bytes != null;

/// Create or edit a product with conversion and three-image validation.
/// Keep successful uploads available when a failed save is retried.
class InventoryProductFormPage extends ConsumerStatefulWidget {
  const InventoryProductFormPage.create({required this.farmId, super.key})
    : productId = null;

  const InventoryProductFormPage.edit({
    required this.farmId,
    required String this.productId,
    super.key,
  });

  final String farmId;
  final String? productId;

  @override
  ConsumerState<InventoryProductFormPage> createState() =>
      _InventoryProductFormPageState();
}

class _InventoryProductFormPageState
    extends ConsumerState<InventoryProductFormPage> {
  final _formKey = GlobalKey<FormState>();
  int? _selectedPhotoIndex;
  final _nameController = TextEditingController();
  final _thresholdController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _conversionQuantityController = TextEditingController();

  InventoryProductCategory? _category;
  InventoryProductUnit? _unit;
  InventoryConversionUnit? _conversionUnit;
  InventoryProduct? _product;
  String? _manufacturerId;
  String _manufacturerName = '';
  InventoryCompliance _compliance = const InventoryCompliance();
  bool _complianceChanged = false;
  bool _initialized = false;
  bool _saving = false;
  bool _picking = false;
  final _images = List<_MaterialPhoto>.filled(
    InventoryRules.maxProductImages,
    _emptyPhoto,
    growable: true,
  );
  int get _imageCount => _images.where(_hasPhoto).length;

  bool get _isEdit => widget.productId != null;

  String get _alertUnitLabel =>
      _unit != null && InventoryRules.isPackaged(_unit!)
      ? _conversionUnit?.label ?? 'đơn vị quy đổi'
      : _unit?.label ?? 'đơn vị';

  @override
  void dispose() {
    _nameController.dispose();
    _thresholdController.dispose();
    _descriptionController.dispose();
    _conversionQuantityController.dispose();
    super.dispose();
  }

  void _initialize(InventoryProduct product) {
    if (_initialized) return;
    _initialized = true;
    _product = product;
    _manufacturerId = product.manufacturerId;
    _manufacturerName = product.manufacturer['name'] as String? ?? '';
    _compliance = product.compliance ?? const InventoryCompliance();
    _images.clear();
    _images.addAll(
      product.effectiveImageUrls.map(
        (url) => (url: url, bytes: null, fileName: null),
      ),
    );
    while (_images.length < InventoryRules.maxProductImages) {
      _images.add(_emptyPhoto);
    }
    _nameController.text = product.name;
    _thresholdController.text = _numberText(product.minAlertQuantity);
    _descriptionController.text = product.description ?? '';
    _conversionQuantityController.text = product.conversionQuantity == null
        ? ''
        : _numberText(product.conversionQuantity!);
    _category = product.category;
    _unit = product.unit;
    _conversionUnit = product.conversionUnit;
  }

  Future<void> _pickImage({int? slot}) async {
    if (_saving || _picking) return;
    if (slot != null &&
        (slot < 0 || slot >= _images.length || _hasPhoto(_images[slot]))) {
      return;
    }
    if (slot == null && _imageCount >= InventoryRules.maxProductImages) {
      AppNoticeService.danger(context, 'Mỗi vật tư có tối đa 3 ảnh.');
      return;
    }
    setState(() => _picking = true);
    try {
      final picker = ref.read(inventoryImagePickerProvider);
      final List<XFile> files;
      if (slot == null) {
        files = await picker.pickMultiImage(requestFullMetadata: false);
      } else {
        final file = await picker.pickImage(
          source: ImageSource.gallery,
          requestFullMetadata: false,
        );
        files = file == null ? [] : [file];
      }
      if (files.isEmpty || !mounted) return;
      if (slot == null &&
          _imageCount + files.length > InventoryRules.maxProductImages) {
        throw const ApiException('Mỗi vật tư có tối đa 3 ảnh.');
      }
      final selected = <({String? url, Uint8List? bytes, String? fileName})>[];
      for (final file in files) {
        if (await file.length() > InventoryRules.maxImageBytes) {
          throw const ApiException('Ảnh vật tư không được vượt quá 5 MB.');
        }
        final bytes = await file.readAsBytes();
        InventoryRules.validateImage(bytes);
        selected.add((url: null, bytes: bytes, fileName: file.name));
      }
      if (mounted) {
        setState(() {
          if (slot != null) {
            _images[slot] = selected.single;
            _selectedPhotoIndex = slot;
          } else {
            for (final photo in selected) {
              final photoIndex = _images.indexWhere(
                (image) => !_hasPhoto(image),
              );
              _images[photoIndex] = photo;
              _selectedPhotoIndex = photoIndex;
            }
          }
        });
      }
    } on AppException catch (error) {
      if (mounted) AppNoticeService.danger(context, error.message);
    } on PlatformException {
      if (mounted) {
        AppNoticeService.danger(
          context,
          'Không thể mở trình chọn tệp ảnh. Vui lòng thử lại.',
        );
      }
    } finally {
      if (mounted) setState(() => _picking = false);
    }
  }

  Future<void> _submit() async {
    if (_saving || _picking) return;
    if (_formKey.currentState?.validate() != true) return;
    if (_product?.metadataLocked != true &&
        (_manufacturerId == null || _manufacturerId!.isEmpty)) {
      AppNoticeService.danger(
        context,
        'Vui lòng chọn nhà sản xuất đang hoạt động.',
      );
      return;
    }
    if (_imageCount > InventoryRules.maxProductImages) {
      AppNoticeService.danger(context, 'Mỗi vật tư có tối đa 3 ảnh.');
      return;
    }
    if (!_hasPhoto(_images[0]) && _hasPhoto(_images[1])) {
      AppNoticeService.danger(
        context,
        'Vui lòng thêm ảnh mặt trước hoặc gỡ ảnh mặt sau trước khi lưu.',
      );
      return;
    }
    final category = _category;
    final unit = _unit;
    if (category == null) {
      AppNoticeService.show(
        context,
        message: 'Vui lòng chọn danh mục vật tư.',
        level: AppNoticeLevel.warning,
      );
      return;
    }
    if (unit == null) {
      AppNoticeService.show(
        context,
        message: 'Vui lòng chọn đơn vị.',
        level: AppNoticeLevel.warning,
      );
      return;
    }

    setState(() => _saving = true);
    final conversionQuantity = InventoryRules.isPackaged(unit)
        ? InventoryRules.parseNumber(_conversionQuantityController.text)
        : null;
    try {
      InventoryRules.validateConversion(
        unit: unit,
        conversionQuantity: conversionQuantity,
        conversionUnit: InventoryRules.isPackaged(unit)
            ? _conversionUnit
            : null,
      );
      final notifier = ref.read(
        inventoryMutationControllerProvider(widget.farmId).notifier,
      );
      for (var index = 0; index < _images.length; index++) {
        final image = _images[index];
        if (image.bytes == null) continue;
        final uploaded = await notifier.uploadImage(
          bytes: image.bytes!,
          fileName: image.fileName!,
        );
        if (!mounted) return;
        // Retain completed uploads when the request fails and the user retries.
        setState(
          () => _images[index] = (url: uploaded, bytes: null, fileName: null),
        );
      }
      final imageUrls = _images
          .where(_hasPhoto)
          .map((image) => image.url!)
          .toList(growable: false);
      if (_isEdit) {
        await notifier.updateProduct(
          product: _product!,
          name: _nameController.text,
          category: category,
          manufacturerId: _manufacturerId ?? '',
          compliance: _complianceChanged ? _compliance.toDraftJson() : null,
          unit: unit,
          conversionQuantity: conversionQuantity,
          conversionUnit: InventoryRules.isPackaged(unit)
              ? _conversionUnit
              : null,
          minAlertQuantity:
              InventoryRules.parseNumber(_thresholdController.text) ?? 0,
          description: _nullableText(_descriptionController.text),
          imageUrls: imageUrls,
        );
      } else {
        await notifier.create(
          name: _nameController.text,
          category: category,
          manufacturerId: _manufacturerId!,
          compliance: _compliance.toDraftJson(),
          unit: unit,
          conversionQuantity: conversionQuantity,
          conversionUnit: InventoryRules.isPackaged(unit)
              ? _conversionUnit
              : null,
          minAlertQuantity:
              InventoryRules.parseNumber(_thresholdController.text) ?? 0,
          description: _nullableText(_descriptionController.text),
          imageUrls: imageUrls,
        );
      }
      if (!mounted) return;
      AppNoticeService.success(
        context,
        _isEdit ? 'Đã lưu thay đổi vật tư.' : 'Đã thêm vật tư vào kho.',
      );
      context.pop();
    } on FormatException catch (error) {
      if (!mounted) return;
      AppNoticeService.show(
        context,
        message: error.message,
        level: AppNoticeLevel.warning,
      );
    } on AppException catch (error) {
      if (!mounted) return;
      AppNoticeService.show(
        context,
        message: error.message,
        level: AppNoticeLevel.danger,
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isEdit) {
      final detail = ref.watch(
        inventoryDetailControllerProvider((
          farmId: widget.farmId,
          productId: widget.productId!,
        )),
      );
      if (detail.isLoading && detail.value == null) {
        return _frame(const Center(child: CircularProgressIndicator()));
      }
      if (detail.hasError && detail.value == null) {
        return _frame(
          _LoadError(
            message: _errorMessage(detail.error),
            onRetry: () => ref
                .read(
                  inventoryDetailControllerProvider((
                    farmId: widget.farmId,
                    productId: widget.productId!,
                  )).notifier,
                )
                .refresh(),
          ),
        );
      }
      if (detail.requireValue.isArchived) {
        return _frame(
          const Center(child: Text('Khôi phục vật tư trước khi chỉnh sửa.')),
        );
      }
      _initialize(detail.requireValue);
    }

    final mutation = ref.watch(
      inventoryMutationControllerProvider(widget.farmId),
    );
    if (_product?.metadataLocked == true) {
      return _frame(
        Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text(
                'Vật tư đã có đơn hoặc giao dịch. Chỉ được sửa ngưỡng cảnh báo và mô tả.',
              ),
              const SizedBox(height: 16),
              _buildThresholdField(),
              const SizedBox(height: 16),
              InventoryField(
                label: 'Mô tả (tùy chọn)',
                child: TextFormField(
                  controller: _descriptionController,
                  enabled: !_saving,
                  maxLength: InventoryRules.maxDescriptionLength,
                  minLines: 2,
                  maxLines: 4,
                  style: inventoryInputTextStyle,
                  decoration: inventoryInputDecoration(
                    hintText: 'Ghi chú thêm về vật tư…',
                  ).copyWith(counterText: ''),
                ),
              ),
              const SizedBox(height: 16),
              InventoryGradientButton(
                label: 'Lưu thay đổi',
                iconAsset: InventoryAssets.save,
                onPressed: _saving ? null : _submit,
              ),
            ],
          ),
        ),
      );
    }
    return _frame(
      Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
          children: <Widget>[
            AbsorbPointer(
              absorbing: _saving || _picking,
              child: Padding(
                padding: EdgeInsets.zero,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    InventoryField(
                      labelSize: 12,
                      spacing: 6,
                      label: 'Tên vật tư *',
                      child: TextFormField(
                        controller: _nameController,
                        style: inventoryInputTextStyle,
                        maxLength: InventoryRules.maxNameLength,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: inventoryInputDecoration(
                          hintText: 'VD: Thức ăn CP 9004',
                        ).copyWith(counterText: ''),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Tên vật tư không được để trống';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    InventoryField(
                      labelSize: 12,
                      spacing: 6,
                      label: 'Danh mục *',
                      child: _CategorySelector(
                        selected: _category,
                        onChanged: (value) => setState(() => _category = value),
                      ),
                    ),
                    const SizedBox(height: 16),
                    InventoryField(
                      labelSize: 12,
                      spacing: 6,
                      label: 'Đơn vị *',
                      child: _UnitSelector(
                        selected: _unit,
                        onChanged: (value) => setState(() {
                          _unit = value;
                          if (!InventoryRules.isPackaged(value)) {
                            _conversionQuantityController.clear();
                            _conversionUnit = null;
                          }
                        }),
                      ),
                    ),
                    if (_unit != null &&
                        InventoryRules.isPackaged(_unit!)) ...<Widget>[
                      const SizedBox(height: 16),
                      InventoryField(
                        labelSize: 12,
                        spacing: 6,
                        label: 'Quy đổi mỗi ${_unit!.label.toLowerCase()} *',
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: TextFormField(
                                controller: _conversionQuantityController,
                                style: AppTypography.mono(
                                  fontSize: 14,
                                  color: AppColors.ink,
                                ),
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                      decimal: true,
                                    ),
                                decoration: inventoryInputDecoration(
                                  hintText: 'VD: 500',
                                ),
                                validator: InventoryRules.conversionError,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _ConversionUnitDropdown(
                                value: _conversionUnit,
                                onChanged: (value) =>
                                    setState(() => _conversionUnit = value),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    InventoryField(
                      labelSize: 12,
                      spacing: 6,
                      label: 'Nhà sản xuất *',
                      child: _buildManufacturerDropdown(),
                    ),
                    TextButton.icon(
                      icon: const Icon(Icons.add_business_outlined, size: 16),
                      label: const Text(
                        'Thêm nhà sản xuất',
                        style: TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onPressed: () async {
                        final supplier = await context.push<InventorySupplier>(
                          '/farms/${widget.farmId}/inventory/suppliers/new',
                        );
                        if (supplier != null &&
                            supplier.isActive &&
                            supplier.isManufacturer &&
                            mounted) {
                          setState(() {
                            _manufacturerId = supplier.id;
                            _manufacturerName = supplier.name;
                          });
                        }
                      },
                    ),
                    const Text(
                      'Đơn vị in trên nhãn. Bên bán được ghi riêng ở từng lần nhập kho.',
                      style: TextStyle(
                        fontSize: 10,
                        height: 1.6,
                        color: AppColors.inkMuted,
                      ),
                    ),
                    const SizedBox(height: 16),
                    InventoryComplianceEditor(
                      value: _compliance,
                      imageSection: _buildPhotoSection(),
                      onChanged: (value) => setState(() {
                        _compliance = value;
                        _complianceChanged = true;
                      }),
                    ),
                    const SizedBox(height: 16),
                    _buildThresholdField(),
                    const SizedBox(height: 16),
                    ValueListenableBuilder<TextEditingValue>(
                      valueListenable: _descriptionController,
                      builder: (context, value, _) => InventoryField(
                        labelSize: 12,
                        spacing: 6,
                        label:
                            'Mô tả (tùy chọn · ${value.text.characters.length}/${InventoryRules.maxDescriptionLength})',
                        child: TextFormField(
                          controller: _descriptionController,
                          style: inventoryInputTextStyle,
                          maxLength: InventoryRules.maxDescriptionLength,
                          maxLines: 4,
                          minLines: 2,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: inventoryInputDecoration(
                            hintText: 'Ghi chú thêm về vật tư…',
                          ).copyWith(counterText: ''),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            InventoryGradientButton(
              radius: 12,
              label: _saving || mutation.isLoading
                  ? 'Đang lưu…'
                  : _isEdit
                  ? 'Lưu thay đổi'
                  : 'Thêm vào kho',
              iconAsset: InventoryAssets.formSubmit,
              onPressed: _saving || _picking || mutation.isLoading
                  ? null
                  : _submit,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThresholdField() => InventoryField(
    label: 'Ngưỡng cảnh báo tồn kho tối thiểu *',
    labelSize: 12,
    spacing: 6,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: TextFormField(
            key: const ValueKey('inventory-threshold-quantity'),
            controller: _thresholdController,
            style: AppTypography.mono(fontSize: 14, color: AppColors.ink),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: inventoryInputDecoration(hintText: '0'),
            enabled: !_saving,
            validator: (value) =>
                InventoryRules.quantityError(value, allowZero: true),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: TextFormField(
            key: ValueKey('inventory-threshold-unit-$_alertUnitLabel'),
            initialValue: _alertUnitLabel,
            readOnly: true,
            style: AppTypography.mono(fontSize: 14, color: AppColors.ink),
            decoration: inventoryInputDecoration(),
          ),
        ),
      ],
    ),
  );

  Widget _buildPhotoSection() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (_imageCount > 0) ...[
        _buildPhotoPreview(),
        const SizedBox(height: 16),
      ],
      Row(
        children: [
          Expanded(
            child: InventoryGradientButton(
              label: _picking
                  ? 'Đang mở tệp…'
                  : _imageCount >= InventoryRules.maxProductImages
                  ? 'Đã đủ 3 ảnh'
                  : _imageCount == 0
                  ? 'Thêm ảnh'
                  : 'Thêm ảnh khác',
              iconAsset: InventoryAssets.formImage,
              radius: 12,
              fitContent: true,
              onPressed:
                  _saving ||
                      _picking ||
                      _imageCount >= InventoryRules.maxProductImages
                  ? null
                  : () => _imageCount == 0
                        ? _pickImage()
                        : _pickImage(
                            slot: _images.indexWhere(
                              (image) => !_hasPhoto(image),
                            ),
                          ),
            ),
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: Tooltip(
              message:
                  'Đọc nhãn OCR chưa khả dụng. Bạn có thể nhập thông tin theo nhãn bên dưới.',
              child: Opacity(
                opacity: .45,
                child: InventoryGradientButton(
                  label: 'Đọc nhãn OCR',
                  iconAsset: InventoryAssets.formOcr,
                  radius: 12,
                  fitContent: true,
                  disabledGradientColors: [
                    AppColors.oceanLight,
                    AppColors.tealLight,
                    AppColors.oceanLight,
                  ],
                  onPressed: null,
                ),
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 16),
      Text(
        '$_imageCount/${InventoryRules.maxProductImages} ảnh · JPG, PNG, WebP · tối đa ${InventoryRules.maxImageBytes ~/ (1024 * 1024)} MB/ảnh.',
        style: const TextStyle(
          fontSize: 12,
          height: 1.6,
          color: AppColors.inkMuted,
        ),
      ),
    ],
  );

  Widget _buildPhotoPreview() {
    final selected =
        _selectedPhotoIndex != null &&
            _selectedPhotoIndex! < _images.length &&
            _hasPhoto(_images[_selectedPhotoIndex!])
        ? _selectedPhotoIndex!
        : _images.indexWhere(_hasPhoto);
    final photo = _images[selected];
    final last = _images.lastIndexWhere(_hasPhoto);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          key: const ValueKey('inventory-photo-preview'),
          height: 192,
          width: double.infinity,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: const Color(0xFFEEF1F6),
            borderRadius: BorderRadius.circular(12),
          ),
          child: photo.bytes != null
              ? Image.memory(photo.bytes!, fit: BoxFit.contain)
              : InventoryProductImage(
                  category: _category ?? InventoryProductCategory.other,
                  url: photo.url,
                  fit: BoxFit.contain,
                  width: double.infinity,
                  height: 192,
                ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            for (var index = 0; index <= last; index++) ...[
              if (index > 0) const SizedBox(width: 6),
              Expanded(
                child: SizedBox(
                  height: 36,
                  child: OutlinedButton(
                    key: ValueKey('inventory-photo-$index'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      backgroundColor: selected == index
                          ? const Color(0xFFEAF4FF)
                          : Colors.white,
                      foregroundColor: const Color(0xFF0C4E8F),
                      side: BorderSide(
                        color: selected == index
                            ? const Color(0xFF3F97E8)
                            : AppColors.line,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      textStyle: const TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onPressed: () {
                      if (_hasPhoto(_images[index])) {
                        setState(() => _selectedPhotoIndex = index);
                      } else {
                        _pickImage(slot: index);
                      }
                    },
                    child: Text('Ảnh ${index + 1}'),
                  ),
                ),
              ),
            ],
            const SizedBox(width: 8),
            SizedBox.square(
              dimension: 36,
              child: IconButton(
                tooltip: 'Gỡ ảnh ${selected + 1}',
                style: IconButton.styleFrom(
                  backgroundColor: const Color(0xFFFBE6EA),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: const InventorySvgIcon(
                  InventoryAssets.formDelete,
                  size: 17,
                ),
                onPressed: () => setState(() {
                  if (selected < InventoryRules.maxProductImages) {
                    _images[selected] = _emptyPhoto;
                  } else {
                    _images.removeAt(selected);
                  }
                  _selectedPhotoIndex = null;
                }),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Đã chọn: ${inventoryPhotoLabel(selected)}',
          style: const TextStyle(fontSize: 10, color: AppColors.inkMuted),
        ),
      ],
    );
  }

  Widget _buildManufacturerDropdown() {
    final suppliers = ref.watch(supplierListControllerProvider(widget.farmId));
    return suppliers.when(
      loading: () => InputDecorator(
        decoration: inventoryInputDecoration(),
        child: const Row(
          children: [
            SizedBox.square(
              dimension: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            SizedBox(width: 10),
            Text('Đang tải nhà sản xuất…', style: inventoryInputTextStyle),
          ],
        ),
      ),
      error: (error, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            error is AppException
                ? error.message
                : 'Không thể tải nhà sản xuất.',
            style: const TextStyle(color: AppColors.error, fontSize: 12),
          ),
          TextButton(
            onPressed: () =>
                ref.invalidate(supplierListControllerProvider(widget.farmId)),
            child: const Text('Thử lại'),
          ),
        ],
      ),
      data: (all) {
        final items = all
            .where((item) => item.isActive && item.isManufacturer)
            .toList();
        final listed = items.any((item) => item.id == _manufacturerId);
        // Keep the saved manufacturer when editing an existing material, even
        // if that manufacturer is no longer offered for new selections.
        final retainCurrent =
            _isEdit && (_manufacturerId?.isNotEmpty ?? false) && !listed;
        final selected = listed || retainCurrent ? _manufacturerId : null;
        return DropdownButtonFormField<String>(
          key: ValueKey(_manufacturerId),
          initialValue: selected,
          isExpanded: true,
          menuMaxHeight: 300,
          style: AppTypography.mono(fontSize: 14, color: AppColors.ink),
          icon: const Center(
            widthFactor: 1,
            heightFactor: 1,
            child: SizedBox(
              width: 10,
              height: 6,
              child: InventorySvgIcon(InventoryAssets.formDropdown, size: 10),
            ),
          ),
          hint: Text(
            items.isEmpty
                ? 'Chưa có nhà sản xuất đang hoạt động'
                : 'Chọn nhà sản xuất',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 14, color: AppColors.inkMuted),
          ),
          decoration: inventoryInputDecoration().copyWith(
            prefixIcon: const Center(
              widthFactor: 1,
              heightFactor: 1,
              child: InventorySvgIcon(
                InventoryAssets.formManufacturer,
                size: 17,
              ),
            ),
          ),
          items: [
            if (retainCurrent)
              DropdownMenuItem(
                value: _manufacturerId,
                enabled: false,
                child: Text(
                  _manufacturerName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ...items.map(
              (item) => DropdownMenuItem(
                value: item.id,
                child: Text(
                  item.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
          onChanged: (id) {
            if (id == null) return;
            final item = items.firstWhere((item) => item.id == id);
            setState(() {
              _manufacturerId = item.id;
              _manufacturerName = item.name;
            });
          },
          validator: (id) => id == null ? 'Vui lòng chọn nhà sản xuất' : null,
        );
      },
    );
  }

  Widget _frame(Widget child) => PopScope(
    canPop: !_saving,
    child: InventoryPageFrame(
      title: _isEdit ? 'Chỉnh sửa vật tư' : 'Thêm vật tư mới',
      backIconAsset: InventoryAssets.formBack,
      headerHeight: 60,
      onBack: () {
        if (!_saving) context.pop();
      },
      child: child,
    ),
  );
}

class _CategorySelector extends StatelessWidget {
  const _CategorySelector({required this.selected, required this.onChanged});

  final InventoryProductCategory? selected;
  final ValueChanged<InventoryProductCategory> onChanged;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) => Wrap(
      spacing: 6,
      runSpacing: 6,
      children: InventoryProductCategory.values
          .where((item) => item != InventoryProductCategory.unknown)
          .map(
            (category) => SizedBox(
              width: (constraints.maxWidth - 12) / 3,
              child: _SelectionChip(
                label: category.label,
                selected: selected == category,
                onTap: () => onChanged(category),
              ),
            ),
          )
          .toList(growable: false),
    ),
  );
}

class _UnitSelector extends StatelessWidget {
  const _UnitSelector({required this.selected, required this.onChanged});

  final InventoryProductUnit? selected;
  final ValueChanged<InventoryProductUnit> onChanged;

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: 8,
    runSpacing: 8,
    children: InventoryProductUnit.values
        .where(
          (item) =>
              item != InventoryProductUnit.unknown &&
              item != InventoryProductUnit.pcs,
        )
        .map(
          (unit) => _SelectionChip(
            label: unit.label,
            selected: selected == unit,
            onTap: () => onChanged(unit),
          ),
        )
        .toList(growable: false),
  );
}

class _ConversionUnitDropdown extends StatelessWidget {
  const _ConversionUnitDropdown({required this.value, required this.onChanged});

  final InventoryConversionUnit? value;
  final ValueChanged<InventoryConversionUnit?> onChanged;

  @override
  Widget build(BuildContext context) => DropdownButtonFormField(
    initialValue: value,
    style: AppTypography.mono(fontSize: 14, color: AppColors.ink),
    decoration: inventoryInputDecoration(hintText: 'Đơn vị'),
    items: InventoryConversionUnit.values
        .where((item) => item != InventoryConversionUnit.unknown)
        .map((unit) => DropdownMenuItem(value: unit, child: Text(unit.label)))
        .toList(growable: false),
    onChanged: onChanged,
    validator: (value) => value == null ? 'Chọn đơn vị' : null,
  );
}

class _SelectionChip extends StatelessWidget {
  const _SelectionChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  static const selectedColor = Color(0xFFEAF4FF);
  static const selectedTextColor = Color(0xFF1D7AD6);

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(12),
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: selected ? selectedColor : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: selected
              ? selectedTextColor.withValues(alpha: 0.5)
              : AppColors.line,
        ),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: selected ? selectedTextColor : AppColors.inkMuted,
            fontSize: 11,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    ),
  );
}

class _LoadError extends StatelessWidget {
  const _LoadError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 12),
          FilledButton(onPressed: onRetry, child: const Text('Thử lại')),
        ],
      ),
    ),
  );
}

String? _nullableText(String value) {
  final normalized = InventoryRules.normalizeText(value);
  return normalized.isEmpty ? null : normalized;
}

String _numberText(double value) {
  return value == value.truncateToDouble()
      ? value.toInt().toString()
      : value.toString();
}

String _errorMessage(Object? error) {
  return error is AppException
      ? error.message
      : 'Không thể tải dữ liệu kho. Vui lòng thử lại.';
}
