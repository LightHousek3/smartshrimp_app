import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/widgets/app_dialog.dart';
import 'package:smartshrimp_app/core/widgets/app_notice.dart';
import 'package:smartshrimp_app/features/inventory/domain/entities/inventory_supplier.dart';
import 'package:smartshrimp_app/features/inventory/domain/entities/inventory.dart'
    show InventoryProductUnit;
import 'package:smartshrimp_app/features/inventory/presentation/inventory_view_data.dart';
import 'package:smartshrimp_app/features/inventory/presentation/view_models/supplier_controller.dart';
import 'package:smartshrimp_app/features/inventory/presentation/widgets/inventory_directory_ui.dart';
import 'package:smartshrimp_app/features/inventory/presentation/widgets/inventory_supplier_dialog.dart';
import 'package:smartshrimp_app/features/inventory/presentation/widgets/inventory_ui.dart';

typedef InventorySupplierDetailResult = ({
  InventorySupplierAction action,
  InventorySupplier supplier,
});

/// Show a directory snapshot immediately, then load current owner-wide references.
class InventorySupplierDetailPage extends ConsumerStatefulWidget {
  const InventorySupplierDetailPage({
    required this.farmId,
    required this.supplier,
    super.key,
  });
  final String farmId;
  final InventorySupplier supplier;

  @override
  ConsumerState<InventorySupplierDetailPage> createState() =>
      _InventorySupplierDetailPageState();
}

class _InventorySupplierDetailPageState
    extends ConsumerState<InventorySupplierDetailPage> {
  bool _saving = false;

  Future<void> _openContact(Uri uri) async {
    try {
      if (await launchUrl(uri)) return;
    } on Object {
      // Some platforms have no phone or mail handler; keep the contact visible.
    }
    if (mounted) {
      AppNoticeService.warning(
        context,
        'Thiết bị chưa có ứng dụng để mở liên hệ này.',
      );
    }
  }

  Future<void> _toggleStatus(InventorySupplier supplier) async {
    final label = supplier.isActive ? 'Ngừng giao dịch' : 'Tiếp tục giao dịch';
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AppConfirmDialog(
        title: '$label?',
        description: supplier.isActive
            ? 'Nhà cung cấp sẽ không xuất hiện khi chọn cho lần nhập hoặc vật tư mới. Lịch sử vẫn được giữ lại.'
            : 'Cho phép chọn nhà cung cấp cho các lần nhập và vật tư mới.',
        confirmLabel: label,
        onConfirm: () => Navigator.pop(dialogContext, true),
        onCancel: () => Navigator.pop(dialogContext, false),
      ),
    );
    if (confirmed != true || !mounted) return;
    setState(() => _saving = true);
    try {
      await ref
          .read(supplierListControllerProvider(widget.farmId).notifier)
          .save(
            existing: supplier,
            name: supplier.name,
            supplierType: supplier.supplierType,
            contactName: supplier.contactName,
            phone: supplier.phone,
            email: supplier.email,
            address: supplier.address,
            note: supplier.note,
            isActive: !supplier.isActive,
          );
      if (mounted) {
        AppNoticeService.success(
          context,
          'Đã cập nhật trạng thái nhà cung cấp.',
        );
      }
    } on AppException catch (error) {
      if (mounted) AppNoticeService.danger(context, error.message);
      if (mounted) {
        ref.invalidate(
          supplierDetailProvider((
            farmId: widget.farmId,
            supplierId: supplier.id,
          )),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final key = (farmId: widget.farmId, supplierId: widget.supplier.id);
    final detail = ref.watch(supplierDetailProvider(key));
    final supplier = detail.value ?? widget.supplier;
    void finish(InventorySupplierAction action) =>
        Navigator.pop(context, (action: action, supplier: supplier));
    return PopScope(
      canPop: !_saving,
      child: InventoryPageFrame(
        title: supplier.name,
        subtitle: 'Nhà cung cấp',
        onBack: () {
          if (!_saving) Navigator.pop(context);
        },
        trailing: IconButton(
          tooltip: 'Chỉnh sửa',
          onPressed: _saving || supplier.readOnly
              ? null
              : () => finish(InventorySupplierAction.edit),
          style: IconButton.styleFrom(
            backgroundColor: Colors.white.withValues(alpha: .65),
          ),
          icon: const InventorySvgIcon(InventoryAssets.supplierEdit, size: 17),
        ),
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(supplierDetailProvider(key));
            await ref.read(supplierDetailProvider(key).future);
          },
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              if (supplier.readOnly) const InventoryReadOnlyNotice(),
              if (!supplier.readOnly && supplier.supplierType == 'UNKNOWN')
                const Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: Text(
                    'Chưa xác định vai trò cung ứng. Chọn chỉnh sửa để xác nhận nhà sản xuất hoặc nhà phân phối.',
                  ),
                ),
              InventorySurface(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: const Color(0xFFEAF4FF),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Center(
                            child: InventorySvgIcon(
                              InventoryAssets.supplierDetailTruck,
                              size: 26,
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
                                style: const TextStyle(
                                  color: AppColors.ink,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  height: 1.4,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Wrap(
                                spacing: 6,
                                runSpacing: 6,
                                children: [
                                  InventoryLabelBadge(
                                    label: supplier.roleLabel,
                                    foreground: supplier.roleForeground,
                                    background: supplier.roleBackground,
                                  ),
                                  InventoryLabelBadge(
                                    label: supplier.isActive
                                        ? 'Đang giao dịch'
                                        : 'Ngừng giao dịch',
                                    foreground: supplier.isActive
                                        ? const Color(0xFF0F9B8E)
                                        : AppColors.inkMuted,
                                    background: supplier.isActive
                                        ? const Color(0xFFE2F6F3)
                                        : const Color(0xFFEEF1F6),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(vertical: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEEF1F6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Ghi chú',
                            style: TextStyle(
                              color: AppColors.inkMuted,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 6),
                          SelectableText(
                            supplier.note?.trim().isNotEmpty == true
                                ? supplier.note!
                                : 'Chưa cập nhật',
                            style: const TextStyle(
                              color: AppColors.inkSoft,
                              fontSize: 11,
                              height: 1.6,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    _SupplierInfo(
                      label: 'Người liên hệ',
                      value: supplier.contactName,
                    ),
                    _SupplierInfo(label: 'Điện thoại', value: supplier.phone),
                    _SupplierInfo(label: 'Email', value: supplier.email),
                    _SupplierInfo(label: 'Địa chỉ', value: supplier.address),
                    _SupplierInfo(
                      label: 'Ngày tạo',
                      value: formatInventoryDate(
                        supplier.createdAt,
                        includeTime: true,
                      ),
                    ),
                    _SupplierInfo(
                      label: 'Cập nhật gần nhất',
                      value: formatInventoryDate(
                        supplier.updatedAt,
                        includeTime: true,
                      ),
                      last: true,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: InventorySoftButton(
                            label: 'Gọi',
                            asset: InventoryAssets.supplierPhone,
                            onPressed: supplier.phone?.trim().isNotEmpty == true
                                ? () => _openContact(
                                    Uri(
                                      scheme: 'tel',
                                      path: supplier.phone!.replaceAll(
                                        RegExp(r'[^+0-9]'),
                                        '',
                                      ),
                                    ),
                                  )
                                : null,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: InventorySoftButton(
                            label: 'Email',
                            asset: InventoryAssets.supplierEmail,
                            onPressed: supplier.email?.trim().isNotEmpty == true
                                ? () => _openContact(
                                    Uri(
                                      scheme: 'mailto',
                                      path: supplier.email!,
                                    ),
                                  )
                                : null,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (detail.isLoading)
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: LinearProgressIndicator(),
                ),
              if (detail.hasError)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: InventorySurface(
                    child: Column(
                      children: [
                        Text(
                          detail.error is AppException
                              ? (detail.error as AppException).message
                              : 'Không thể tải thông tin liên quan. Kéo xuống để thử lại.',
                        ),
                        TextButton(
                          onPressed: () =>
                              ref.invalidate(supplierDetailProvider(key)),
                          child: const Text('Thử lại'),
                        ),
                      ],
                    ),
                  ),
                ),
              if (!supplier.readOnly)
                _SupplierSection(
                  title: 'Vật tư của nhà cung cấp',
                  count: supplier.manufacturedProductCount?.toString(),
                  children: [
                    for (final product
                        in supplier.manufacturedProducts ??
                            <Map<String, dynamic>>[])
                      ListTile(
                        dense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        title: Text(
                          product['name'] as String,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.ink,
                          ),
                        ),
                        subtitle: Text(
                          product['farmName'] as String,
                          style: const TextStyle(
                            fontSize: 10,
                            color: AppColors.inkMuted,
                          ),
                        ),
                        trailing: const InventorySvgIcon(
                          InventoryAssets.supplierChevron,
                          size: 15,
                        ),
                        onTap: () => context.push(
                          '/farms/${product['farmId']}/inventory/${product['id']}',
                        ),
                      ),
                    if (supplier.manufacturedProducts?.isEmpty == true)
                      const _SupplierEmptyRelated(
                        'Chưa có vật tư gắn nhà cung cấp này.',
                      ),
                    if ((supplier.manufacturedProductCount ?? 0) > 20)
                      const _SupplierEmptyRelated(
                        'Hiển thị 20 vật tư cập nhật gần nhất.',
                      ),
                  ],
                ),
              _SupplierSection(
                title: 'Lịch sử nhập hàng',
                count: supplier.receiptCount == null
                    ? null
                    : '${supplier.receiptCount} lần',
                children: [
                  for (final receipt
                      in supplier.receipts ?? <Map<String, dynamic>>[])
                    _SupplierReceipt(receipt: receipt),
                  if (supplier.receipts?.isEmpty == true)
                    const _SupplierEmptyRelated(
                      'Chưa có lần nhập từ nhà cung cấp này.',
                    ),
                  if ((supplier.receiptCount ?? 0) > 20)
                    const _SupplierEmptyRelated(
                      'Hiển thị 20 lần nhập gần nhất.',
                    ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 46,
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed:
                      _saving ||
                          supplier.readOnly ||
                          supplier.supplierType == 'UNKNOWN'
                      ? null
                      : () => _toggleStatus(supplier),
                  icon: const InventorySvgIcon(
                    InventoryAssets.supplierPause,
                    size: 18,
                  ),
                  label: Text(
                    _saving
                        ? 'Đang cập nhật…'
                        : supplier.isActive
                        ? 'Ngừng giao dịch'
                        : 'Tiếp tục giao dịch',
                  ),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.inkSoft,
                    minimumSize: const Size(double.infinity, 46),
                    side: const BorderSide(color: AppColors.line),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              if (supplier.canDelete)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: SizedBox(
                    height: 46,
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _saving
                          ? null
                          : () => finish(InventorySupplierAction.delete),
                      icon: const Icon(Icons.delete_outline_rounded, size: 18),
                      label: const Text('Xóa nhà cung cấp'),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.error,
                        minimumSize: const Size(double.infinity, 46),
                        side: const BorderSide(color: AppColors.line),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                )
              else if (!supplier.readOnly)
                const Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InventorySvgIcon(InventoryAssets.supplierInfo, size: 14),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Nhà cung cấp đã có vật tư, lần nhập kho hoặc đề xuất liên quan nên không thể xóa. Có thể ngừng giao dịch để không chọn cho lần mới.',
                          style: TextStyle(
                            color: AppColors.inkMuted,
                            fontSize: 11,
                            height: 1.6,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SupplierInfo extends StatelessWidget {
  const _SupplierInfo({required this.label, this.value, this.last = false});
  final String label;
  final String? value;
  final bool last;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(vertical: 9),
    decoration: BoxDecoration(
      border: last
          ? null
          : const Border(bottom: BorderSide(color: AppColors.line)),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: const TextStyle(
              color: AppColors.inkMuted,
              fontSize: 12,
              height: 1.5,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 3,
          child: SelectableText(
            value?.trim().isNotEmpty == true ? value! : 'Chưa cập nhật',
            textAlign: TextAlign.right,
            style: const TextStyle(
              color: AppColors.ink,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              height: 1.5,
            ),
          ),
        ),
      ],
    ),
  );
}

class _SupplierSection extends StatelessWidget {
  const _SupplierSection({
    required this.title,
    this.count,
    required this.children,
  });
  final String title;
  final String? count;
  final List<Widget> children;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: AppTypography.display(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                  ).copyWith(fontFamilyFallback: const ['PlusJakartaSans']),
                ),
              ),
              if (count != null)
                InventoryLabelBadge(
                  label: count!,
                  foreground: AppColors.ocean,
                  background: const Color(0xFFEAF4FF),
                ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        if (children.isNotEmpty)
          InventorySurface(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                for (var i = 0; i < children.length; i++) ...[
                  if (i > 0)
                    const Divider(
                      height: 1,
                      indent: 16,
                      endIndent: 16,
                      color: AppColors.line,
                    ),
                  children[i],
                ],
              ],
            ),
          ),
      ],
    ),
  );
}

class _SupplierEmptyRelated extends StatelessWidget {
  const _SupplierEmptyRelated(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(16),
    child: Text(
      text,
      style: const TextStyle(
        color: AppColors.inkMuted,
        fontSize: 12,
        height: 1.5,
      ),
    ),
  );
}

class _SupplierReceipt extends StatelessWidget {
  const _SupplierReceipt({required this.receipt});
  final Map<String, dynamic> receipt;
  @override
  Widget build(BuildContext context) {
    final date = DateTime.tryParse(receipt['receivedAt'] as String? ?? '');
    final rawUnit = receipt['unit'] as String?;
    final unit = InventoryProductUnit.values
        .where((value) => value.name.toUpperCase() == rawUnit?.toUpperCase())
        .firstOrNull;
    final unitLabel = unit?.label ?? rawUnit;
    final quantity =
        '${receipt['quantityExact']}${unitLabel == null || unitLabel.isEmpty ? '' : ' $unitLabel'}';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  receipt['productName'] as String,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.ink,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              if (date != null)
                Text(
                  formatInventoryDate(date),
                  style: const TextStyle(
                    color: AppColors.inkMuted,
                    fontSize: 10,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            '${receipt['lotNumber']} · ${receipt['farmName']} · còn $quantity',
            style: const TextStyle(
              color: AppColors.inkMuted,
              fontSize: 10,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
