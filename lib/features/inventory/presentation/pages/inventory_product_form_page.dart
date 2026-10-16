import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smartshrimp_app/features/inventory/presentation/widgets/inventory_product_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/widgets/app_notice.dart';
import 'package:smartshrimp_app/features/inventory/domain/entities/inventory.dart';
import 'package:smartshrimp_app/features/inventory/domain/inventory_rules.dart';
import 'package:smartshrimp_app/features/inventory/presentation/inventory_view_data.dart';
import 'package:smartshrimp_app/features/inventory/presentation/view_models/inventory_controller.dart';
import 'package:smartshrimp_app/features/inventory/presentation/widgets/inventory_ui.dart';

typedef _MaterialPhoto = ({String? url, Uint8List? bytes, String? fileName});
const _emptyPhoto = (url: null, bytes: null, fileName: null);
bool _hasPhoto(_MaterialPhoto photo) =>
    photo.url != null || photo.bytes != null;

class InventoryProductFormPage extends ConsumerStatefulWidget {
  const InventoryProductFormPage.create({required this.farmId, super.key})
    : productId = null,
      photoReplacement = null;

  const InventoryProductFormPage.edit({
    required this.farmId,
    required String this.productId,
    this.photoReplacement,
    super.key,
  });

  final String farmId;
  final String? productId;
  final InventoryPhotoReplacement? photoReplacement;

  @override
  ConsumerState<InventoryProductFormPage> createState() =>
      _InventoryProductFormPageState();
}

class _InventoryProductFormPageState
    extends ConsumerState<InventoryProductFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _imageFieldKey = GlobalKey();
  int? _selectedPhotoIndex;
  final _nameController = TextEditingController();
  final _thresholdController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _conversionQuantityController = TextEditingController();

  InventoryProductCategory? _category;
  InventoryProductUnit? _unit;
  InventoryConversionUnit? _conversionUnit;
  InventoryProduct? _product;
  bool _initialized = false;
  bool _saving = false;
  bool _picking = false;
  final _images = <_MaterialPhoto>[_emptyPhoto, _emptyPhoto];
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
    _images.clear();
    _images.addAll(
      product.effectiveImageUrls.map(
        (url) => (url: url, bytes: null, fileName: null),
      ),
    );
    while (_images.length < 2) {
      _images.add(_emptyPhoto);
    }
    final replacement = widget.photoReplacement;
    if (replacement != null &&
        replacement.index >= 0 &&
        replacement.index < _images.length) {
      _selectedPhotoIndex = replacement.index;
      _images[replacement.index] = (
        url: null,
        bytes: replacement.bytes,
        fileName: replacement.fileName,
      );
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        final fieldContext = _imageFieldKey.currentContext;
        if (fieldContext != null) {
          Scrollable.ensureVisible(
            fieldContext,
            alignment: 0.15,
            duration: const Duration(milliseconds: 250),
          );
        }
      });
    }
    _nameController.text = product.name;
    _thresholdController.text = product.minAlertQuantity == 0
        ? ''
        : _numberText(product.minAlertQuantity);
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
    if (slot == null && _imageCount >= InventoryRules.maxProductImages) {
      AppNoticeService.danger(
        context,
        'Mỗi vật tư có tối đa 2 ảnh: mặt trước và mặt sau.',
      );
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
        throw const ApiException(
          'Mỗi vật tư có tối đa 2 ảnh: mặt trước và mặt sau.',
        );
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
          } else {
            for (final photo in selected) {
              _images[_images.indexWhere((image) => !_hasPhoto(image))] = photo;
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
    if (_imageCount > InventoryRules.maxProductImages) {
      AppNoticeService.danger(
        context,
        'Mỗi vật tư có tối đa 2 ảnh: mặt trước và mặt sau.',
      );
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
    return _frame(
      Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(10, 12, 10, 32),
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
                        style: AppTypography.mono(
                          fontSize: 14,
                          color: AppColors.ink,
                        ),
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
                      key: _imageFieldKey,
                      label: 'Hình ảnh vật tư (tối đa 2 ảnh)',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 8,
                                  mainAxisSpacing: 8,
                                ),
                            itemCount: _images.length,
                            itemBuilder: (context, index) {
                              final image = _images[index];
                              final label = inventoryPhotoLabel(index);
                              return Stack(
                                fit: StackFit.expand,
                                children: [
                                  Material(
                                    color: const Color(0xFFEAF4FF),
                                    borderRadius: BorderRadius.circular(12),
                                    child: InkWell(
                                      key: ValueKey('inventory-photo-$index'),
                                      onTap: () {
                                        setState(
                                          () => _selectedPhotoIndex = index,
                                        );
                                        if (!_hasPhoto(image)) {
                                          _pickImage(slot: index);
                                        }
                                      },
                                      borderRadius: BorderRadius.circular(12),
                                      child: Semantics(
                                        button: true,
                                        selected: _selectedPhotoIndex == index,
                                        label:
                                            'Chọn ảnh ${label.toLowerCase()}',
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          child: image.bytes != null
                                              ? Image.memory(
                                                  image.bytes!,
                                                  fit: BoxFit.contain,
                                                )
                                              : image.url != null
                                              ? InventoryProductImage(
                                                  url: image.url,
                                                  fit: BoxFit.contain,
                                                  width: double.infinity,
                                                  height: double.infinity,
                                                )
                                              : const Center(
                                                  child: InventorySvgIcon(
                                                    InventoryAssets.camera,
                                                    size: 16,
                                                  ),
                                                ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 0,
                                    right: 0,
                                    bottom: 0,
                                    child: IgnorePointer(
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 5,
                                        ),
                                        decoration: const BoxDecoration(
                                          color: Color(0xEFFFFFFF),
                                          borderRadius: BorderRadius.vertical(
                                            bottom: Radius.circular(12),
                                          ),
                                        ),
                                        child: Text(
                                          label,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontSize: 10,
                                            color: AppColors.inkSoft,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (_selectedPhotoIndex == index)
                                    Positioned.fill(
                                      child: IgnorePointer(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            border: Border.all(
                                              color: const Color(0xFF3F97E8),
                                              width: 2,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  if (_hasPhoto(image))
                                    Positioned(
                                      top: 6,
                                      right: 6,
                                      child: SizedBox.square(
                                        dimension: 24,
                                        child: IconButton(
                                          tooltip: 'Gỡ ảnh ${index + 1}',
                                          padding: EdgeInsets.zero,
                                          style: IconButton.styleFrom(
                                            backgroundColor: const Color(
                                              0xB30F1C2E,
                                            ),
                                            foregroundColor: Colors.white,
                                          ),
                                          icon: const InventorySvgIcon(
                                            InventoryAssets.removeImage,
                                            size: 12,
                                          ),
                                          onPressed: () => setState(() {
                                            if (_selectedPhotoIndex == index) {
                                              _selectedPhotoIndex = null;
                                            } else if (index >= 2 &&
                                                _selectedPhotoIndex != null &&
                                                _selectedPhotoIndex! > index) {
                                              _selectedPhotoIndex =
                                                  _selectedPhotoIndex! - 1;
                                            }
                                            if (index < 2) {
                                              _images[index] = _emptyPhoto;
                                            } else {
                                              _images.removeAt(index);
                                            }
                                          }),
                                        ),
                                      ),
                                    ),
                                ],
                              );
                            },
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  _selectedPhotoIndex == null
                                      ? 'Chọn ảnh cần đổi'
                                      : 'Đã chọn: ${inventoryPhotoLabel(_selectedPhotoIndex!)}',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: AppColors.inkMuted,
                                  ),
                                ),
                              ),
                              OutlinedButton.icon(
                                onPressed:
                                    _selectedPhotoIndex != null &&
                                        _hasPhoto(_images[_selectedPhotoIndex!])
                                    ? () =>
                                          _pickImage(slot: _selectedPhotoIndex)
                                    : null,
                                icon: const Icon(Icons.edit_outlined, size: 16),
                                label: const Text('Đổi ảnh'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: const Color(0xFF0F62B4),
                                  backgroundColor: Colors.white,
                                  side: const BorderSide(
                                    color: Color(0xFFD3E8FF),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          CustomPaint(
                            foregroundPainter: const _DashedOutline(),
                            child: SizedBox(
                              width: double.infinity,
                              height: 44,
                              child: Material(
                                color: const Color(0xFFEAF4FF),
                                borderRadius: BorderRadius.circular(12),
                                child: InkWell(
                                  onTap: _imageCount >= 2
                                      ? null
                                      : () => _pickImage(),
                                  borderRadius: BorderRadius.circular(12),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const InventorySvgIcon(
                                        InventoryAssets.camera,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        _picking
                                            ? 'Đang mở tệp…'
                                            : _imageCount >= 2
                                            ? 'Đã đủ 2 ảnh'
                                            : _imageCount == 0
                                            ? 'Chọn nhiều ảnh'
                                            : 'Thêm ảnh khác',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF0C4E8F),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Ảnh 1: mặt trước · Ảnh 2: mặt sau.\nJPG, PNG, WebP · Tối đa 5 MB/ảnh, 2 ảnh/vật tư.',
                            style: TextStyle(
                              fontSize: 10,
                              color: AppColors.inkMuted,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),
                    InventoryField(
                      labelSize: 12,
                      spacing: 6,
                      label:
                          'Ngưỡng cảnh báo tồn kho tối thiểu ($_alertUnitLabel)',
                      child: TextFormField(
                        controller: _thresholdController,
                        style: AppTypography.mono(
                          fontSize: 14,
                          color: AppColors.ink,
                        ),
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: inventoryInputDecoration(
                          hintText: 'VD: 100',
                        ),
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                            ? null
                            : InventoryRules.quantityError(
                                value,
                                allowZero: true,
                              ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    InventoryField(
                      labelSize: 12,
                      spacing: 6,
                      label: 'Mô tả (tùy chọn)',
                      child: TextFormField(
                        controller: _descriptionController,
                        style: AppTypography.mono(
                          fontSize: 14,
                          color: AppColors.ink,
                        ),
                        maxLength: InventoryRules.maxDescriptionLength,
                        maxLines: 4,
                        minLines: 2,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: inventoryInputDecoration(
                          hintText: 'Mô tả ngắn về vật tư…',
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                        ).copyWith(counterText: ''),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            InventoryGradientButton(
              radius: 12,
              gradientColors: const [AppColors.oceanLight, AppColors.tealLight],
              label: _saving || mutation.isLoading
                  ? 'Đang lưu…'
                  : _isEdit
                  ? 'Lưu thay đổi'
                  : 'Lưu vật tư',
              iconAsset: InventoryAssets.save,
              onPressed: _saving || _picking || mutation.isLoading
                  ? null
                  : _submit,
            ),
          ],
        ),
      ),
    );
  }

  Widget _frame(Widget child) => PopScope(
    canPop: !_saving,
    child: InventoryPageFrame(
      title: _isEdit ? 'Chỉnh sửa vật tư' : 'Thêm vật tư',
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
        .where((item) => item != InventoryProductUnit.unknown)
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

class _DashedOutline extends CustomPainter {
  const _DashedOutline();
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(12)),
      );
    final paint = Paint()
      ..color = const Color(0xFF3F97E8)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    for (final metric in path.computeMetrics()) {
      for (double distance = 0; distance < metric.length; distance += 6) {
        canvas.drawPath(metric.extractPath(distance, distance + 3), paint);
      }
    }
  }

  @override
  bool shouldRepaint(_DashedOutline oldDelegate) => false;
}
