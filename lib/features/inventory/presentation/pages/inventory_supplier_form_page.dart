import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/widgets/app_notice.dart';
import 'package:smartshrimp_app/features/inventory/domain/entities/inventory_supplier.dart';
import 'package:smartshrimp_app/features/inventory/presentation/view_models/supplier_controller.dart';
import 'package:smartshrimp_app/features/inventory/presentation/widgets/inventory_ui.dart';

/// Create or edit supplier details and activity in the shared owner directory.
/// Pass the existing record so updates include its version token.
class InventorySupplierFormPage extends ConsumerStatefulWidget {
  const InventorySupplierFormPage({
    required this.farmId,
    this.supplierId,
    this.initialSupplier,
    super.key,
  });
  final String farmId;
  final String? supplierId;
  final InventorySupplier? initialSupplier;

  @override
  ConsumerState<InventorySupplierFormPage> createState() =>
      _InventorySupplierFormPageState();
}

class _InventorySupplierFormPageState
    extends ConsumerState<InventorySupplierFormPage> {
  final _form = GlobalKey<FormState>();
  final _fields = {
    for (final key in [
      'name',
      'contactName',
      'phone',
      'email',
      'address',
      'note',
    ])
      key: TextEditingController(),
  };
  InventorySupplier? _existing;
  bool _saving = false;
  bool _conflict = false;
  bool _reloadLatest = false;
  bool _isActive = true;
  String _supplierType = 'MANUFACTURER';

  @override
  void dispose() {
    for (final controller in _fields.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    if (_saving || _form.currentState?.validate() != true) return;
    setState(() => _saving = true);
    try {
      final supplier = await ref
          .read(supplierListControllerProvider(widget.farmId).notifier)
          .save(
            existing: _existing,
            name: _fields['name']!.text,
            contactName: _fields['contactName']!.text,
            phone: _fields['phone']!.text,
            email: _fields['email']!.text,
            address: _fields['address']!.text,
            note: _fields['note']!.text,
            isActive: _isActive,
            supplierType: _supplierType,
          );
      if (!mounted) return;
      AppNoticeService.success(
        context,
        _existing == null
            ? 'Đã thêm nhà cung cấp.'
            : 'Đã cập nhật nhà cung cấp.',
      );
      context.pop(supplier);
    } on AppException catch (error) {
      if (mounted) {
        AppNoticeService.danger(context, error.message);
        if (error is ApiException &&
            error.statusCode == 409 &&
            widget.supplierId != null) {
          setState(() => _conflict = true);
        }
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Keep the directory alive while saving, including quick creation from a receipt.
    ref.watch(supplierListControllerProvider(widget.farmId));
    Widget content;
    if (widget.supplierId != null) {
      final initial = widget.initialSupplier;
      InventorySupplier? supplier =
          !_reloadLatest && initial?.id == widget.supplierId ? initial : null;
      if (supplier == null) {
        final state = ref.watch(
          supplierDetailProvider((
            farmId: widget.farmId,
            supplierId: widget.supplierId!,
          )),
        );
        if (state.value == null) {
          content = state.isLoading
              ? const Center(child: CircularProgressIndicator())
              : Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        state.error is AppException
                            ? (state.error as AppException).message
                            : 'Không thể tải nhà cung cấp.',
                      ),
                      TextButton(
                        onPressed: () => ref.invalidate(
                          supplierDetailProvider((
                            farmId: widget.farmId,
                            supplierId: widget.supplierId!,
                          )),
                        ),
                        child: const Text('Thử lại'),
                      ),
                    ],
                  ),
                );
          return _frame(content);
        }
        supplier = state.requireValue;
      }
      if (_existing == null) {
        _existing = supplier;
        _isActive = supplier.isActive;
        _supplierType = supplier.supplierType;
        final values = {
          'name': _existing!.name,
          'contactName': _existing!.contactName,
          'phone': _existing!.phone,
          'email': _existing!.email,
          'address': _existing!.address,
          'note': _existing!.note,
        };
        for (final entry in values.entries) {
          _fields[entry.key]!.text = entry.value ?? '';
        }
      }
    }
    content = Form(
      key: _form,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
        children: [
          const Text('Nhà cung cấp dùng chung cho tất cả trang trại của bạn.'),
          const SizedBox(height: 12),
          AbsorbPointer(
            absorbing: _saving,
            child: InventorySurface(
              child: Column(
                children: [
                  _field(
                    'name',
                    'Tên nhà cung cấp *',
                    255,
                    enabled: _existing?.metadataLocked != true,
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'Vui lòng nhập tên nhà cung cấp'
                        : null,
                  ),
                  InventoryField(
                    label: 'Vai trò cung ứng *',
                    child: DropdownButtonFormField<String>(
                      initialValue: _supplierType == 'UNKNOWN'
                          ? null
                          : _supplierType,
                      isExpanded: true,
                      style: inventoryInputTextStyle,
                      decoration: inventoryInputDecoration(),
                      validator: (value) => value == null
                          ? 'Vui lòng xác nhận vai trò cung ứng'
                          : null,
                      items: const [
                        DropdownMenuItem(
                          value: 'MANUFACTURER',
                          child: Text('Nhà sản xuất'),
                        ),
                        DropdownMenuItem(
                          value: 'DISTRIBUTOR',
                          child: Text('Nhà phân phối'),
                        ),
                        DropdownMenuItem(
                          value: 'BOTH',
                          child: Text('Sản xuất và phân phối'),
                        ),
                      ],
                      onChanged: _existing?.metadataLocked == true
                          ? null
                          : (type) => setState(() => _supplierType = type!),
                    ),
                  ),
                  const SizedBox(height: 14),
                  if (_existing?.metadataLocked == true) ...[
                    const Text(
                      'Nhà cung cấp đã có đơn hoặc giao dịch nên không thể đổi tên và vai trò.',
                    ),
                    const SizedBox(height: 14),
                  ],
                  _field('contactName', 'Người liên hệ', 255),
                  _field(
                    'phone',
                    'Số điện thoại *',
                    20,
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Vui lòng nhập số điện thoại';
                      }
                      return !RegExp(
                            r'^\+?[0-9 ()\-.]{6,20}$',
                          ).hasMatch(value.trim())
                          ? 'Số điện thoại không hợp lệ'
                          : null;
                    },
                  ),
                  _field(
                    'email',
                    'Email',
                    320,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) =>
                        value != null &&
                            value.trim().isNotEmpty &&
                            !RegExp(
                              r'^[^\s@]+@[^\s@]+\.[^\s@]+$',
                            ).hasMatch(value.trim())
                        ? 'Email không hợp lệ'
                        : null,
                  ),
                  _field(
                    'address',
                    'Địa chỉ *',
                    1000,
                    lines: 2,
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'Vui lòng nhập địa chỉ'
                        : null,
                  ),
                  _field('note', 'Ghi chú', 2000, lines: 3),
                  if (widget.supplierId != null)
                    InventoryField(
                      label: 'Trạng thái',
                      child: DropdownButtonFormField<bool>(
                        initialValue: _isActive,
                        isExpanded: true,
                        style: inventoryInputTextStyle,
                        decoration: inventoryInputDecoration(),
                        items: const [
                          DropdownMenuItem(
                            value: true,
                            child: Text('Đang hoạt động'),
                          ),
                          DropdownMenuItem(
                            value: false,
                            child: Text('Tạm ngưng'),
                          ),
                        ],
                        onChanged: (value) =>
                            setState(() => _isActive = value ?? true),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          if (_conflict)
            TextButton(
              onPressed: _saving
                  ? null
                  : () {
                      setState(() {
                        _existing = null;
                        _conflict = false;
                        _reloadLatest = true;
                      });
                      ref.invalidate(
                        supplierDetailProvider((
                          farmId: widget.farmId,
                          supplierId: widget.supplierId!,
                        )),
                      );
                    },
              child: const Text('Tải lại dữ liệu mới nhất'),
            ),
          InventoryGradientButton(
            label: _saving ? 'Đang lưu…' : 'Lưu nhà cung cấp',
            iconAsset: InventoryAssets.save,
            onPressed: _saving ? null : _save,
          ),
        ],
      ),
    );
    return _frame(content);
  }

  Widget _frame(Widget child) => PopScope(
    canPop: !_saving,
    child: InventoryPageFrame(
      title: widget.supplierId == null
          ? 'Thêm nhà cung cấp'
          : 'Chỉnh sửa nhà cung cấp',
      onBack: () {
        if (!_saving) context.pop();
      },
      child: child,
    ),
  );

  Widget _field(
    String key,
    String label,
    int limit, {
    int lines = 1,
    bool enabled = true,
    TextInputType? keyboardType,
    FormFieldValidator<String>? validator,
  }) => Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: InventoryField(
      label: label,
      child: TextFormField(
        enabled: enabled,
        controller: _fields[key],
        maxLength: limit,
        maxLines: lines,
        keyboardType: keyboardType,
        style: inventoryInputTextStyle,
        validator: validator,
        decoration: inventoryInputDecoration(
          hintText: label.replaceAll(' *', ''),
        ).copyWith(counterText: ''),
      ),
    ),
  );
}
