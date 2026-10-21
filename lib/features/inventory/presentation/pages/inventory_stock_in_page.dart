import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/widgets/app_notice.dart';
import 'package:smartshrimp_app/features/inventory/domain/entities/inventory_supplier.dart';
import 'package:smartshrimp_app/features/inventory/domain/inventory_rules.dart';
import 'package:smartshrimp_app/features/inventory/presentation/inventory_view_data.dart';
import 'package:smartshrimp_app/features/inventory/presentation/view_models/inventory_controller.dart';
import 'package:smartshrimp_app/features/inventory/presentation/widgets/inventory_supplier_picker.dart';
import 'package:smartshrimp_app/features/inventory/presentation/widgets/inventory_ui.dart';

/// Create a receipt lot using an active supplier or quick supplier creation.
/// Delegate movement retries and cache refreshes to the inventory layers.
class InventoryStockInPage extends ConsumerStatefulWidget {
  const InventoryStockInPage({
    required this.farmId,
    required this.productId,
    super.key,
  });

  final String farmId;
  final String productId;

  @override
  ConsumerState<InventoryStockInPage> createState() =>
      _InventoryStockInPageState();
}

class _InventoryStockInPageState extends ConsumerState<InventoryStockInPage> {
  final _formKey = GlobalKey<FormState>();
  final _lotController = TextEditingController();
  final _quantityController = TextEditingController();
  final _priceController = TextEditingController();
  final _dateController = TextEditingController();
  final _supplierController = TextEditingController();
  final _reasonController = TextEditingController();
  final _expiryController = TextEditingController();
  DateTime _receivedAt = DateTime.now();
  DateTime? _expiryDate;
  String? _supplierId;

  Future<void> _selectSupplier() async {
    final supplier = await showModalBottomSheet<InventorySupplier>(
      context: context,
      isScrollControlled: true,
      builder: (_) => InventorySupplierPicker(farmId: widget.farmId),
    );
    if (supplier == null || !mounted) return;
    setState(() {
      _supplierId = supplier.id;
      _supplierController.text = supplier.name;
    });
  }

  Future<void> _createSupplier() async {
    final supplier = await context.push<InventorySupplier>(
      '/farms/${widget.farmId}/inventory/suppliers/new',
    );
    if (supplier == null || !mounted) return;
    setState(() {
      _supplierId = supplier.id;
      _supplierController.text = supplier.name;
    });
  }

  @override
  void initState() {
    super.initState();
    _dateController.text = _formatDate(_receivedAt);
  }

  @override
  void dispose() {
    _lotController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    _dateController.dispose();
    _supplierController.dispose();
    _reasonController.dispose();
    _expiryController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _receivedAt,
      firstDate: DateTime(now.year - 10),
      lastDate: now,
    );
    if (picked == null || !mounted) return;
    setState(() {
      _receivedAt = DateTime(picked.year, picked.month, picked.day);
      _dateController.text = _formatDate(picked);
    });
  }

  Future<void> _pickExpiryDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _expiryDate ?? _receivedAt,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100, 12, 31),
    );
    if (picked == null || !mounted) return;
    setState(() {
      _expiryDate = DateTime(picked.year, picked.month, picked.day);
      _expiryController.text = _formatDate(picked);
    });
  }

  Future<void> _submit() async {
    if (_formKey.currentState?.validate() != true) return;
    try {
      await ref
          .read(inventoryMutationControllerProvider(widget.farmId).notifier)
          .stockIn(
            productId: widget.productId,
            lotNumber: _lotController.text,
            receivedAt: _receivedAt,
            expiryDate: _expiryDate,
            quantity: InventoryRules.parseNumber(_quantityController.text)!,
            quantityExact: InventoryRules.normalizedQuantity(
              _quantityController.text,
            ),
            unitPrice: InventoryRules.parseNumber(_priceController.text)!,
            supplierName: _supplierController.text,
            supplierId: _supplierId,
            reason: _nullableText(_reasonController.text),
          );
      if (!mounted) return;
      AppNoticeService.success(context, 'Đã nhập kho thành công.');
      context.pop();
    } on AppException catch (error) {
      if (!mounted) return;
      AppNoticeService.show(
        context,
        message: error.message,
        level: AppNoticeLevel.danger,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final detail = ref.watch(
      inventoryDetailControllerProvider((
        farmId: widget.farmId,
        productId: widget.productId,
      )),
    );
    final mutation = ref.watch(
      inventoryMutationControllerProvider(widget.farmId),
    );

    return InventoryPageFrame(
      title: 'Nhập kho',
      onBack: context.pop,
      child: detail.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => _LoadError(
          message: _errorMessage(error),
          onRetry: () => ref
              .read(
                inventoryDetailControllerProvider((
                  farmId: widget.farmId,
                  productId: widget.productId,
                )).notifier,
              )
              .refresh(),
        ),
        data: (product) => product.isArchived
            ? const Center(child: Text('Khôi phục vật tư trước khi nhập kho.'))
            : Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                  children: <Widget>[
                    InventorySurface(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          InventoryField(
                            label: 'Vật tư',
                            child: _ReadOnlyValue(value: product.name),
                          ),
                          const SizedBox(height: 14),
                          InventoryField(
                            label: 'Mã lô *',
                            child: TextFormField(
                              controller: _lotController,
                              style: inventoryInputTextStyle,
                              maxLength: InventoryRules.maxLotLength,
                              textCapitalization: TextCapitalization.characters,
                              decoration: inventoryInputDecoration(
                                hintText: 'VD: LO-2026-001',
                              ).copyWith(counterText: ''),
                              validator: _requiredText('Vui lòng nhập mã lô'),
                            ),
                          ),
                          const SizedBox(height: 14),
                          InventoryField(
                            label: 'Số lượng nhập *',
                            child: TextFormField(
                              controller: _quantityController,
                              style: inventoryInputTextStyle,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              decoration:
                                  inventoryInputDecoration(
                                    hintText: 'VD: 100',
                                    suffixIcon: _UnitSuffix(product.unit.label),
                                  ).copyWith(
                                    suffixIconConstraints: const BoxConstraints(
                                      minHeight: 0,
                                    ),
                                  ),
                              validator: InventoryRules.quantityError,
                            ),
                          ),
                          const SizedBox(height: 14),
                          InventoryField(
                            label: 'Đơn giá (₫/${product.unit.label}) *',
                            child: TextFormField(
                              controller: _priceController,
                              style: inventoryInputTextStyle,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              decoration: inventoryInputDecoration(
                                hintText: 'VD: 35000',
                              ),
                              validator: InventoryRules.unitPriceError,
                            ),
                          ),
                          const SizedBox(height: 14),
                          InventoryField(
                            label: 'Ngày nhập *',
                            child: TextFormField(
                              controller: _dateController,
                              style: inventoryInputTextStyle,
                              readOnly: true,
                              onTap: _pickDate,
                              decoration: inventoryInputDecoration(
                                suffixIcon: const Icon(
                                  Icons.calendar_today_outlined,
                                  size: 19,
                                  color: AppColors.inkMuted,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          InventoryField(
                            label: 'Hạn sử dụng',
                            child: TextFormField(
                              controller: _expiryController,
                              style: inventoryInputTextStyle,
                              readOnly: true,
                              onTap: _pickExpiryDate,
                              decoration:
                                  inventoryInputDecoration(
                                    hintText: 'dd/MM/yyyy',
                                    suffixIcon: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        if (_expiryDate != null)
                                          IconButton(
                                            tooltip: 'Xóa hạn sử dụng',
                                            icon: const Icon(
                                              Icons.close,
                                              size: 19,
                                            ),
                                            color: AppColors.inkMuted,
                                            onPressed: () => setState(() {
                                              _expiryDate = null;
                                              _expiryController.clear();
                                            }),
                                          ),
                                        const Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 12,
                                          ),
                                          child: Icon(
                                            Icons.calendar_today_outlined,
                                            size: 19,
                                            color: AppColors.inkMuted,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ).copyWith(
                                    helperText:
                                        'Có thể bổ sung sau; lô chưa rõ hạn dùng chưa được dùng cho vận hành.',
                                    helperMaxLines: 3,
                                  ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          InventoryField(
                            label: 'Nhà cung cấp *',
                            child: TextFormField(
                              controller: _supplierController,
                              readOnly: true,
                              onTap: mutation.isLoading
                                  ? null
                                  : _selectSupplier,
                              style: inventoryInputTextStyle,
                              maxLength: InventoryRules.maxSupplierLength,
                              textCapitalization: TextCapitalization.words,
                              decoration: inventoryInputDecoration(
                                hintText: 'Chọn từ danh bạ nhà cung cấp',
                                suffixIcon: const Icon(Icons.expand_more),
                              ).copyWith(counterText: ''),
                              validator: (_) => _supplierId == null
                                  ? 'Vui lòng chọn nhà cung cấp'
                                  : null,
                            ),
                          ),
                          TextButton.icon(
                            onPressed: mutation.isLoading
                                ? null
                                : _createSupplier,
                            icon: const Icon(Icons.add, size: 18),
                            label: const Text('Thêm nhà cung cấp'),
                          ),
                          const SizedBox(height: 14),
                          InventoryField(
                            label: 'Ghi chú (tùy chọn)',
                            child: TextFormField(
                              controller: _reasonController,
                              style: inventoryInputTextStyle,
                              maxLength: InventoryRules.maxReasonLength,
                              maxLines: 3,
                              decoration: inventoryInputDecoration(
                                hintText: 'Thông tin bổ sung cho lần nhập kho',
                              ).copyWith(counterText: ''),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 22),
                    InventoryGradientButton(
                      label: mutation.isLoading
                          ? 'Đang xử lý…'
                          : 'Xác nhận nhập kho',
                      iconAsset: InventoryAssets.stockIn,
                      onPressed: mutation.isLoading ? null : _submit,
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

class _ReadOnlyValue extends StatelessWidget {
  const _ReadOnlyValue({required this.value});

  final String value;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    decoration: BoxDecoration(
      color: const Color(0xFFF6F8FB),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: AppColors.line),
    ),
    child: Text(value, style: inventoryInputTextStyle),
  );
}

class _UnitSuffix extends StatelessWidget {
  const _UnitSuffix(this.unit);

  final String unit;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(right: 12),
    child: Center(
      widthFactor: 1,
      child: Text(
        unit,
        style: const TextStyle(color: AppColors.inkMuted, fontSize: 13),
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

FormFieldValidator<String> _requiredText(String message) {
  return (value) => value == null || value.trim().isEmpty ? message : null;
}

String? _nullableText(String value) {
  final normalized = InventoryRules.normalizeText(value);
  return normalized.isEmpty ? null : normalized;
}

String _errorMessage(Object error) {
  return error is AppException
      ? error.message
      : 'Không thể tải thông tin vật tư. Vui lòng thử lại.';
}

String _formatDate(DateTime value) {
  return '${value.day.toString().padLeft(2, '0')}/'
      '${value.month.toString().padLeft(2, '0')}/${value.year}';
}
