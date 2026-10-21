import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/widgets/app_notice.dart';
import 'package:smartshrimp_app/features/inventory/domain/entities/inventory_supplier.dart';
import 'package:smartshrimp_app/features/inventory/presentation/view_models/supplier_controller.dart';
import 'package:smartshrimp_app/features/inventory/presentation/widgets/inventory_ui.dart';

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
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'Vui lòng nhập tên nhà cung cấp'
                        : null,
                  ),
                  _field('contactName', 'Người liên hệ', 255),
                  _field(
                    'phone',
                    'Điện thoại',
                    20,
                    keyboardType: TextInputType.phone,
                    validator: (value) =>
                        value != null &&
                            value.trim().isNotEmpty &&
                            !RegExp(
                              r'^\+?[0-9 ()\-.]{6,20}$',
                            ).hasMatch(value.trim())
                        ? 'Số điện thoại không hợp lệ'
                        : null,
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
                  _field('address', 'Địa chỉ', 1000, lines: 2),
                  _field('note', 'Ghi chú', 2000, lines: 3),
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
    TextInputType? keyboardType,
    FormFieldValidator<String>? validator,
  }) => Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: InventoryField(
      label: label,
      child: TextFormField(
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
