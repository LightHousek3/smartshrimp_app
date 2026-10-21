import 'package:smartshrimp_app/features/inventory/presentation/widgets/inventory_empty_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/widgets/app_dialog.dart';
import 'package:smartshrimp_app/core/widgets/app_notice.dart';
import 'package:smartshrimp_app/features/inventory/domain/entities/inventory_supplier.dart';
import 'package:smartshrimp_app/features/inventory/presentation/view_models/supplier_controller.dart';
import 'package:smartshrimp_app/features/inventory/presentation/widgets/inventory_supplier_dialog.dart';
import 'package:smartshrimp_app/features/inventory/presentation/widgets/inventory_ui.dart';

class InventorySuppliersPage extends ConsumerStatefulWidget {
  const InventorySuppliersPage({required this.farmId, super.key});
  final String farmId;

  @override
  ConsumerState<InventorySuppliersPage> createState() =>
      _InventorySuppliersPageState();
}

class _InventorySuppliersPageState
    extends ConsumerState<InventorySuppliersPage> {
  String _search = '';
  bool _deleting = false;

  Future<void> _showDetails(InventorySupplier supplier) async {
    if (_deleting) return;
    final action = await showDialog<InventorySupplierAction>(
      context: context,
      barrierColor: AppColors.ink.withValues(alpha: 0.35),
      builder: (_) => InventorySupplierDialog(supplier: supplier),
    );
    if (!mounted) return;
    if (action == InventorySupplierAction.edit) {
      context.push(
        '/farms/${widget.farmId}/inventory/suppliers/${supplier.id}/edit',
        extra: supplier,
      );
    } else if (action == InventorySupplierAction.delete) {
      await _delete(supplier);
    }
  }

  Future<void> _delete(InventorySupplier supplier) async {
    final confirmed = await showAppConfirmDialog(
      context,
      entityLabel: 'nhà cung cấp',
      entityName: supplier.name,
      retentionMessage:
          'Thông tin nhà cung cấp trên các lô đã nhập vẫn được giữ lại.',
      confirmLabel: 'Xóa nhà cung cấp',
    );
    if (!confirmed || !mounted) return;
    setState(() => _deleting = true);
    try {
      await ref
          .read(supplierListControllerProvider(widget.farmId).notifier)
          .delete(supplier.id);
      if (mounted) AppNoticeService.success(context, 'Đã xóa nhà cung cấp.');
    } on AppException catch (error) {
      if (mounted) AppNoticeService.danger(context, error.message);
    } finally {
      if (mounted) setState(() => _deleting = false);
    }
  }

  void _addSupplier() =>
      context.push('/farms/${widget.farmId}/inventory/suppliers/new');

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(supplierListControllerProvider(widget.farmId));
    final items = (state.value ?? <InventorySupplier>[])
        .where(
          (supplier) => [
            supplier.name,
            supplier.contactName,
            supplier.phone,
            supplier.email,
            supplier.address,
          ].any((value) => value?.toLowerCase().contains(_search) == true),
        )
        .toList();
    return InventoryPageFrame(
      title: 'Nhà cung cấp',
      onBack: context.pop,
      trailing: TextButton.icon(
        onPressed: _deleting ? null : _addSupplier,
        icon: const Icon(Icons.add_rounded, size: 18),
        label: const Text('Thêm mới'),
        style: TextButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: AppColors.ink,
          minimumSize: const Size(0, 40),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: TextField(
              maxLength: 255,
              style: inventoryInputTextStyle,
              textInputAction: TextInputAction.search,
              decoration:
                  inventoryInputDecoration(
                    hintText: 'Tìm tên, điện thoại, địa chỉ…',
                  ).copyWith(
                    counterText: '',
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      size: 20,
                      color: AppColors.inkMuted,
                    ),
                  ),
              onChanged: (value) =>
                  setState(() => _search = value.trim().toLowerCase()),
            ),
          ),
          Expanded(
            child: state.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        error is AppException
                            ? error.message
                            : 'Không thể tải nhà cung cấp.',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    TextButton(
                      onPressed: () => ref.invalidate(
                        supplierListControllerProvider(widget.farmId),
                      ),
                      child: const Text('Thử lại'),
                    ),
                  ],
                ),
              ),
              data: (_) => RefreshIndicator(
                onRefresh: () => ref
                    .read(
                      supplierListControllerProvider(widget.farmId).notifier,
                    )
                    .refresh(),
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(2, 2, 2, 12),
                      child: Text(
                        '${items.length} cửa hàng phân phối',
                        style: AppTypography.display(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.ink,
                        ),
                      ),
                    ),
                    if (items.isEmpty)
                      InventoryEmptyState(
                        title: _search.isEmpty
                            ? 'Chưa có nhà cung cấp'
                            : 'Không tìm thấy nhà cung cấp',
                        message: _search.isEmpty
                            ? 'Thêm nhà cung cấp để dùng chung cho các trang trại của bạn.'
                            : 'Hãy thử tên hoặc thông tin liên hệ khác.',
                        icon: Icons.storefront_outlined,
                      ),
                    for (final supplier in items)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _SupplierCard(
                          supplier: supplier,
                          onTap: _deleting
                              ? null
                              : () => _showDetails(supplier),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SupplierCard extends StatelessWidget {
  const _SupplierCard({required this.supplier, required this.onTap});

  final InventorySupplier supplier;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => InventorySurface(
    padding: EdgeInsets.zero,
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        key: ValueKey('supplier-card-${supplier.id}'),
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF4FF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.storefront_outlined,
                  size: 21,
                  color: AppColors.inkSoft,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      supplier.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.ink,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      supplier.isActive ? 'Đang hoạt động' : 'Tạm ngưng',
                      style: TextStyle(
                        color: supplier.isActive
                            ? const Color(0xFF0F9B8E)
                            : AppColors.inkMuted,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (supplier.contactName?.trim().isNotEmpty == true) ...[
                      const SizedBox(height: 4),
                      Text(
                        supplier.contactName!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.inkMuted,
                          fontSize: 12,
                        ),
                      ),
                    ],
                    const SizedBox(height: 8),
                    Text(
                      supplier.phone?.trim().isNotEmpty == true
                          ? supplier.phone!
                          : supplier.email?.trim().isNotEmpty == true
                          ? supplier.email!
                          : 'Chưa có thông tin liên hệ',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.inkSoft,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (supplier.address?.trim().isNotEmpty == true) ...[
                      const SizedBox(height: 4),
                      Text(
                        supplier.address!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.inkMuted,
                          fontSize: 11,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 6),
              const Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: AppColors.inkMuted,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
