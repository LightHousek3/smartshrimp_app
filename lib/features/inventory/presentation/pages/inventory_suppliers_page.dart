import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/widgets/app_dialog.dart';
import 'package:smartshrimp_app/core/widgets/app_notice.dart';
import 'package:smartshrimp_app/features/inventory/domain/entities/inventory_supplier.dart';
import 'package:smartshrimp_app/features/inventory/presentation/pages/inventory_supplier_detail_page.dart';
import 'package:smartshrimp_app/features/inventory/presentation/view_models/supplier_controller.dart';
import 'package:smartshrimp_app/features/inventory/presentation/widgets/inventory_directory_ui.dart';
import 'package:smartshrimp_app/features/inventory/presentation/widgets/inventory_empty_state.dart';
import 'package:smartshrimp_app/features/inventory/presentation/widgets/inventory_supplier_dialog.dart';
import 'package:smartshrimp_app/features/inventory/presentation/widgets/inventory_ui.dart';

/// Manage the owner-wide directory with local search and combined role/status filters.
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
  String _status = 'all';
  String _role = 'all';
  bool _deleting = false;

  Future<void> _showDetails(InventorySupplier supplier) async {
    if (_deleting) return;
    final result = await Navigator.of(context)
        .push<InventorySupplierDetailResult>(
          MaterialPageRoute(
            builder: (_) => InventorySupplierDetailPage(
              farmId: widget.farmId,
              supplier: supplier,
            ),
          ),
        );
    if (!mounted || result == null) return;
    if (result.action == InventorySupplierAction.edit) {
      context.push(
        '/farms/${widget.farmId}/inventory/suppliers/${supplier.id}/edit',
        extra: result.supplier,
      );
    } else if (result.action == InventorySupplierAction.delete) {
      await _delete(result.supplier);
    }
  }

  Future<void> _delete(InventorySupplier supplier) async {
    final confirmed = await showAppConfirmDialog(
      context,
      entityLabel: 'nhà cung cấp',
      entityName: supplier.name,
      retentionMessage:
          'Chỉ xóa được nhà cung cấp chưa có vật tư hoặc lịch sử liên quan.',
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

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(supplierListControllerProvider(widget.farmId));
    final all = state.value ?? <InventorySupplier>[];
    final readOnly = all.any((supplier) => supplier.readOnly);
    final activeCount = all.where((s) => s.isActive).length;
    final items = all
        .where(
          (supplier) =>
              (_status == 'all' || supplier.status == _status) &&
              (_role == 'all' || supplier.supplierType == _role) &&
              (_search.isEmpty ||
                  [
                    supplier.name,
                    supplier.contactName,
                    supplier.phone,
                    supplier.email,
                    supplier.address,
                  ].any(
                    (value) => value?.toLowerCase().contains(_search) == true,
                  )),
        )
        .toList();
    return InventoryPageFrame(
      title: 'Nhà cung cấp',
      subtitle: 'Dùng chung cho mọi trang trại',
      onBack: context.pop,
      child: RefreshIndicator(
        onRefresh: () => ref
            .read(supplierListControllerProvider(widget.farmId).notifier)
            .refresh(),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            if (readOnly) const InventoryReadOnlyNotice(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: InventorySummaryCard(
                    value: state.value == null ? '—' : '${all.length}',
                    label: 'Nhà cung cấp',
                    minHeight: 75,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: InventorySummaryCard(
                    value: state.value == null ? '—' : '$activeCount',
                    label: 'Đang giao dịch',
                    minHeight: 75,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: InventorySummaryCard(
                    value: state.value == null
                        ? '—'
                        : '${all.length - activeCount}',
                    label: 'Ngừng giao dịch',
                    minHeight: 75,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            InventoryDirectorySearch(
              hint: 'Tìm tên, người liên hệ, số điện thoại…',
              onChanged: (value) =>
                  setState(() => _search = value.trim().toLowerCase()),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: InventoryDirectoryFilter<String>(
                    label: switch (_status) {
                      'ACTIVE' => 'Đang giao dịch',
                      'INACTIVE' => 'Ngừng giao dịch',
                      _ => 'Trạng thái',
                    },
                    tooltip: 'Lọc trạng thái nhà cung cấp',
                    value: _status,
                    active: _status != 'all',
                    onSelected: (value) => setState(() => _status = value),
                    items: const [
                      PopupMenuItem(
                        value: 'all',
                        child: Text('Tất cả trạng thái'),
                      ),
                      PopupMenuItem(
                        value: 'ACTIVE',
                        child: Text('Đang giao dịch'),
                      ),
                      PopupMenuItem(
                        value: 'INACTIVE',
                        child: Text('Ngừng giao dịch'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: InventoryDirectoryFilter<String>(
                    label: switch (_role) {
                      'MANUFACTURER' => 'Nhà sản xuất',
                      'DISTRIBUTOR' => 'Nhà phân phối',
                      'BOTH' => 'Sản xuất & phân phối',
                      _ => 'Vai trò',
                    },
                    tooltip: 'Lọc vai trò nhà cung cấp',
                    value: _role,
                    active: _role != 'all',
                    onSelected: (value) => setState(() => _role = value),
                    items: const [
                      PopupMenuItem(
                        value: 'all',
                        child: Text('Tất cả vai trò'),
                      ),
                      PopupMenuItem(
                        value: 'MANUFACTURER',
                        child: Text('Nhà sản xuất'),
                      ),
                      PopupMenuItem(
                        value: 'DISTRIBUTOR',
                        child: Text('Nhà phân phối'),
                      ),
                      PopupMenuItem(
                        value: 'BOTH',
                        child: Text('Sản xuất & phân phối'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (_status != 'all' || _role != 'all')
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => setState(() {
                    _status = 'all';
                    _role = 'all';
                  }),
                  child: const Text('Xóa bộ lọc'),
                ),
              ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Text(
                      '${items.length} nhà cung cấp',
                      style: AppTypography.display(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                      ).copyWith(fontFamilyFallback: const ['PlusJakartaSans']),
                    ),
                  ),
                ),
                InventorySoftButton(
                  label: 'Thêm nhà cung cấp',
                  asset: InventoryAssets.catalogAdd,
                  onPressed: _deleting || readOnly
                      ? null
                      : () => context.push(
                          '/farms/${widget.farmId}/inventory/suppliers/new',
                        ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (state.isLoading)
              const Padding(
                padding: EdgeInsets.all(32),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (state.hasError)
              InventorySurface(
                child: Column(
                  children: [
                    Text(
                      state.error is AppException
                          ? (state.error as AppException).message
                          : 'Không thể tải nhà cung cấp.',
                      textAlign: TextAlign.center,
                    ),
                    TextButton(
                      onPressed: () => ref.invalidate(
                        supplierListControllerProvider(widget.farmId),
                      ),
                      child: const Text('Thử lại'),
                    ),
                  ],
                ),
              )
            else if (items.isEmpty)
              InventoryEmptyState(
                title: all.isEmpty
                    ? 'Chưa có nhà cung cấp'
                    : 'Không tìm thấy nhà cung cấp',
                message: all.isEmpty
                    ? 'Thêm nhà cung cấp để dùng chung cho các trang trại của bạn.'
                    : 'Hãy thử thông tin tìm kiếm hoặc bộ lọc khác.',
                icon: Icons.local_shipping_outlined,
              )
            else
              for (final supplier in items)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _SupplierCard(
                    supplier: supplier,
                    onTap: _deleting ? null : () => _showDetails(supplier),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}

class _SupplierCard extends StatelessWidget {
  const _SupplierCard({required this.supplier, required this.onTap});
  final InventorySupplier supplier;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    final contact = [
      supplier.contactName,
      supplier.phone ?? supplier.email,
    ].whereType<String>().where((s) => s.trim().isNotEmpty).join(' · ');
    return Opacity(
      opacity: supplier.isActive ? 1 : .75,
      child: InventorySurface(
        padding: EdgeInsets.zero,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            key: ValueKey('supplier-card-${supplier.id}'),
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: supplier.isActive
                          ? const Color(0xFFEAF4FF)
                          : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: InventorySvgIcon(
                        supplier.isActive
                            ? InventoryAssets.supplierTruck
                            : InventoryAssets.supplierInactive,
                        size: 22,
                      ),
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
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          children: [
                            InventoryLabelBadge(
                              label: supplier.roleLabel,
                              foreground: supplier.roleForeground,
                              background: supplier.roleBackground,
                            ),
                            if (!supplier.isActive)
                              const InventoryLabelBadge(
                                label: 'Ngừng giao dịch',
                              ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          contact.isEmpty
                              ? 'Chưa có thông tin liên hệ'
                              : contact,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.inkMuted,
                            fontSize: 11,
                            height: 1.5,
                          ),
                        ),
                        if (supplier.manufacturedProductCount != null &&
                            supplier.receiptCount != null)
                          Text(
                            '${supplier.manufacturedProductCount} vật tư cung cấp · ${supplier.receiptCount} lần nhập hàng',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AppColors.inkMuted,
                              fontSize: 10,
                              height: 1.5,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
