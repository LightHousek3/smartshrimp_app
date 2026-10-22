import 'package:smartshrimp_app/features/inventory/presentation/widgets/inventory_directory_ui.dart';
import 'package:smartshrimp_app/features/inventory/presentation/widgets/inventory_empty_state.dart';
import 'package:flutter/material.dart';
import 'package:smartshrimp_app/features/inventory/domain/inventory_rules.dart';
import 'package:smartshrimp_app/features/inventory/presentation/widgets/inventory_product_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/widgets/app_notice.dart';
import 'package:smartshrimp_app/core/widgets/app_dialog.dart';
import 'package:smartshrimp_app/features/inventory/domain/entities/inventory.dart';
import 'package:smartshrimp_app/features/inventory/presentation/inventory_view_data.dart';
import 'package:smartshrimp_app/features/inventory/presentation/view_models/inventory_controller.dart';
import 'package:smartshrimp_app/features/inventory/presentation/widgets/inventory_ui.dart';
import 'package:smartshrimp_app/features/inventory/presentation/widgets/inventory_stock_out_lot_picker.dart';

/// Show product lots and expose actions allowed by the loaded product state.
/// Pause eligibility is a UI hint; the backend rechecks stock and planned use.
class _ProductInfoRow extends StatelessWidget {
  const _ProductInfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 130,
          child: Text(
            '$label:',
            style: const TextStyle(
              color: AppColors.inkMuted,
              fontSize: 13,
              height: 1.5,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: AppColors.inkSoft,
              fontSize: 13,
              height: 1.5,
            ),
          ),
        ),
      ],
    ),
  );
}

class InventoryDetailPage extends ConsumerWidget {
  const InventoryDetailPage({
    required this.farmId,
    required this.productId,
    super.key,
  });

  final String farmId;
  final String productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final key = (farmId: farmId, productId: productId);
    final productState = ref.watch(inventoryDetailControllerProvider(key));
    final mutation = ref.watch(inventoryMutationControllerProvider(farmId));
    final product = productState.value;

    return InventoryPageFrame(
      title: product?.name ?? 'Chi tiết vật tư',
      headerHeight: 60,
      onBack: context.pop,
      trailing: product != null && !product.isArchived && !product.readOnly
          ? Semantics(
              button: true,
              label: 'Chỉnh sửa vật tư',
              child: InkResponse(
                onTap: () =>
                    context.push('/farms/$farmId/inventory/$productId/edit'),
                radius: 22,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF8FAFC),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: InventorySvgIcon(
                      InventoryAssets.edit,
                      size: 20,
                      colorFilter: ColorFilter.mode(
                        AppColors.inkSoft,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              ),
            )
          : null,
      child: product == null
          ? Center(
              child: productState.hasError
                  ? _DetailError(
                      message: _errorMessage(productState.error),
                      onRetry: () => ref
                          .read(inventoryDetailControllerProvider(key).notifier)
                          .refresh(),
                    )
                  : const CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: () => ref
                  .read(inventoryDetailControllerProvider(key).notifier)
                  .refresh(),
              child: _DetailContent(
                product: product,
                farmId: farmId,
                onPause: (mutation.isLoading || product.readOnly)
                    ? null
                    : () => _pause(context, ref, product),
                onRestore: (mutation.isLoading || product.readOnly)
                    ? null
                    : () => _restore(context, ref, product),
                onDelete:
                    product.canDelete &&
                        !(mutation.isLoading || product.readOnly)
                    ? () => _delete(context, ref, product)
                    : null,
                onSetExpiry: (mutation.isLoading || product.readOnly)
                    ? null
                    : (lot) => _setExpiry(context, ref, product.id, lot),
              ),
            ),
    );
  }

  Future<void> _pause(
    BuildContext context,
    WidgetRef ref,
    InventoryProduct product,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AppConfirmDialog(
        title: 'Tạm ngưng vật tư?',
        description:
            'Tạm ngưng sử dụng “${product.name}” cho nghiệp vụ mới? Tồn kho và lịch sử vẫn được giữ nguyên.',
        confirmLabel: 'Tạm ngưng',
        onConfirm: () => Navigator.pop(dialogContext, true),
        onCancel: () => Navigator.pop(dialogContext, false),
      ),
    );
    if (confirmed != true || !context.mounted) return;
    try {
      await ref
          .read(inventoryMutationControllerProvider(farmId).notifier)
          .archive(product.id);
      if (context.mounted) {
        AppNoticeService.success(context, 'Đã tạm ngưng vật tư.');
      }
    } on AppException catch (error) {
      if (context.mounted) AppNoticeService.danger(context, error.message);
    }
  }

  Future<void> _setExpiry(
    BuildContext context,
    WidgetRef ref,
    String productId,
    InventoryLot lot,
  ) async {
    final form = GlobalKey<FormState>();
    var value = '';
    final dateText = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Hạn dùng lô ${lot.lotNumber}'),
        content: Form(
          key: form,
          child: TextFormField(
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'Hạn sử dụng (yyyy-MM-dd)',
            ),
            onChanged: (text) => value = text.trim(),
            validator: (text) {
              final date = DateTime.tryParse(text?.trim() ?? '');
              if (date == null ||
                  InventoryRules.dateText(date) != text?.trim()) {
                return 'Nhập ngày hợp lệ theo yyyy-MM-dd';
              }
              return InventoryRules.expiryDateError(date);
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Hủy'),
          ),
          FilledButton(
            onPressed: () {
              if (form.currentState!.validate()) {
                Navigator.pop(dialogContext, value);
              }
            },
            child: const Text('Lưu'),
          ),
        ],
      ),
    );
    if (dateText == null || !context.mounted) return;
    try {
      await ref
          .read(inventoryMutationControllerProvider(farmId).notifier)
          .updateLotExpiry(productId, lot, DateTime.parse(dateText));
      if (context.mounted) {
        AppNoticeService.success(context, 'Đã bổ sung hạn sử dụng.');
      }
    } on AppException catch (error) {
      if (context.mounted) AppNoticeService.danger(context, error.message);
    }
  }

  Future<void> _delete(
    BuildContext context,
    WidgetRef ref,
    InventoryProduct product,
  ) async {
    final confirmed = await showAppConfirmDialog(
      context,
      entityLabel: 'vật tư',
      entityName: product.name,
      retentionMessage: 'Chỉ xóa vật tư chưa có phát sinh hoặc tham chiếu.',
      confirmLabel: 'Xóa vật tư',
    );
    if (!confirmed || !context.mounted) return;
    try {
      await ref
          .read(inventoryMutationControllerProvider(farmId).notifier)
          .delete(product.id);
      if (context.mounted) {
        AppNoticeService.success(context, 'Đã xóa vật tư.');
        context.pop();
      }
    } on AppException catch (error) {
      if (context.mounted) AppNoticeService.danger(context, error.message);
    }
  }

  Future<void> _restore(
    BuildContext context,
    WidgetRef ref,
    InventoryProduct product,
  ) async {
    try {
      await ref
          .read(inventoryMutationControllerProvider(farmId).notifier)
          .restore(product.id);
      if (context.mounted) {
        AppNoticeService.success(
          context,
          'Đã chuyển vật tư sang đang sử dụng.',
        );
      }
    } on Object catch (error) {
      if (context.mounted) {
        AppNoticeService.danger(context, _errorMessage(error));
      }
    }
  }
}

class _DetailContent extends StatelessWidget {
  const _DetailContent({
    required this.product,
    required this.farmId,
    required this.onPause,
    required this.onRestore,
    this.onDelete,
    this.onSetExpiry,
  });
  final InventoryProduct product;
  final String farmId;
  final VoidCallback? onPause;
  final VoidCallback? onRestore;
  final VoidCallback? onDelete;
  final Future<void> Function(InventoryLot)? onSetExpiry;

  @override
  Widget build(BuildContext context) {
    final lots = [...product.lots]
      ..sort((a, b) {
        final expiry = a.expiryDate == null
            ? (b.expiryDate == null ? 0 : 1)
            : (b.expiryDate == null
                  ? -1
                  : a.expiryDate!.compareTo(b.expiryDate!));
        if (expiry != 0) return expiry;
        final date = a.receivedAt.compareTo(b.receivedAt);
        return date == 0 ? a.id.compareTo(b.id) : date;
      });
    final available = lots.where((lot) => lot.quantity > 0).toList();
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 32),
      children: [
        if (product.readOnly) const InventoryReadOnlyNotice(),
        if (!product.readOnly && product.manufacturerId.isEmpty)
          const Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: Text(
              'Vật tư cũ chưa có nhà cung cấp. Chọn chỉnh sửa để bổ sung.',
            ),
          ),
        InventorySurface(
          radius: 18,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 6,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAF4FF),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: InventorySvgIcon(
                        InventoryAssets.inventoryBox,
                        size: 20,
                      ),
                    ),
                  ),
                  InventoryCategoryBadge(category: product.category),
                  if (product.isArchived)
                    const Text(
                      'Tạm ngưng',
                      style: TextStyle(fontSize: 11, color: AppColors.inkMuted),
                    )
                  else
                    const Text(
                      'Đang sử dụng',
                      style: TextStyle(fontSize: 11, color: AppColors.inkMuted),
                    ),
                  if (product.isLowStock) const LowStockBadge(),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _StatCell(
                      label: 'TỒN KHO HIỆN TẠI',
                      value: formatInventoryQuantity(product.currentStock),
                      caption: product.unit.label,
                      color: product.isLowStock
                          ? AppColors.error
                          : const Color(0xFF0F9B8E),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _StatCell(
                      label: 'NGƯỠNG CẢNH BÁO',
                      value: formatInventoryQuantity(product.minAlertQuantity),
                      caption: product.alertUnitLabel,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _StatCell(
                      label: 'GIÁ TRỊ TỒN',
                      value: _compactMoney(product.inventoryValue),
                      caption: 'Theo giá nhập',
                      color: const Color(0xFF0F62B4),
                      valueSize: 16,
                    ),
                  ),
                ],
              ),
              const Divider(height: 20, color: AppColors.line),
              Text.rich(
                TextSpan(
                  text: 'Đơn vị: ',
                  children: [
                    TextSpan(
                      text: product.unit.label,
                      style: const TextStyle(
                        color: Color(0xFF0C4E8F),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                style: const TextStyle(color: AppColors.inkMuted, fontSize: 11),
              ),
              if (product.conversionQuantity != null &&
                  product.conversionUnit != null) ...[
                const SizedBox(height: 4),
                Text(
                  '1 ${product.unit.label} = ${formatInventoryQuantity(product.conversionQuantity!)} ${product.conversionUnit!.label}',
                  style: const TextStyle(
                    color: AppColors.inkMuted,
                    fontSize: 11,
                  ),
                ),
              ],
              if ((product.description ?? '').isNotEmpty) ...[
                const SizedBox(height: 5),
                Text(
                  product.description!,
                  style: const TextStyle(
                    color: AppColors.inkSoft,
                    fontSize: 11,
                    height: 1.5,
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 12),
        InventorySurface(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _ProductInfoRow(
                label: 'Nhà cung cấp',
                value: '${product.manufacturer['name'] ?? 'Chưa cập nhật'}',
              ),
              _ProductInfoRow(
                label: 'Hồ sơ',
                value: switch (product.compliance?.complianceStatus) {
                  'reviewed' => 'Đã đối chiếu',
                  'blocked' => 'Đang chặn sử dụng',
                  _ => product.readOnly ? 'Chưa được đối chiếu' : 'Bản nháp',
                },
              ),
              if (product.compliance?.registrationNumber != null)
                _ProductInfoRow(
                  label: 'Mã số tiếp nhận',
                  value: product.compliance!.registrationNumber!,
                ),
              if (product.compliance?.withdrawalDays != null)
                _ProductInfoRow(
                  label: 'Thời gian ngừng',
                  value:
                      '${formatInventoryQuantity(product.compliance!.withdrawalDays!)} ngày',
                ),
              if (product.compliance?.reviewNote != null)
                Text(product.compliance!.reviewNote!),
            ],
          ),
        ),
        if (!product.readOnly && product.canDelete) ...[
          const SizedBox(height: 12),
          InventoryDangerButton(label: 'Xóa vật tư', onPressed: onDelete),
        ],
        if (product.effectiveImageUrls.isNotEmpty) ...[
          const SizedBox(height: 16),
          _ProductGallery(
            key: ValueKey(product.id),
            urls: product.effectiveImageUrls,
            category: product.category,
          ),
        ],
        const SizedBox(height: 16),
        if (!product.readOnly && product.isArchived && available.isNotEmpty)
          OutlinedButton.icon(
            onPressed: () => _chooseStockOut(context, available),
            icon: const Icon(Icons.assignment_return_outlined),
            label: const Text('Xuất kho'),
          ),
        if (!product.readOnly && !product.isArchived)
          Row(
            children: [
              Expanded(
                child: InventoryGradientButton(
                  radius: 12,
                  gradientColors: const [
                    AppColors.oceanLight,
                    AppColors.tealLight,
                  ],
                  label: 'Nhập kho',
                  iconAsset: InventoryAssets.plusWhite,
                  onPressed: () => context.push(
                    '/farms/$farmId/inventory/${product.id}/stock-in',
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: SizedBox(
                  height: 45,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.inkSoft,
                      side: const BorderSide(color: AppColors.line),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: available.isEmpty
                        ? null
                        : () => _chooseStockOut(context, available),
                    icon: const InventorySvgIcon(
                      InventoryAssets.closeDark,
                      size: 18,
                      colorFilter: ColorFilter.mode(
                        AppColors.inkSoft,
                        BlendMode.srcIn,
                      ),
                    ),
                    label: const Text(
                      'Xuất kho',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ),
              ),
            ],
          ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tồn kho theo lô',
                    style: AppTypography.display(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: 3),
                  const Text(
                    'Ưu tiên hạn dùng sớm, nhập trước khi cùng hạn',
                    style: TextStyle(color: AppColors.inkMuted, fontSize: 10),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFFEAF4FF),
                borderRadius: BorderRadius.circular(99),
              ),
              child: Text(
                '${available.length} lô còn hàng',
                style: const TextStyle(
                  color: Color(0xFF0F62B4),
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (lots.isEmpty)
          const InventoryEmptyState(
            title: 'Chưa có lô hàng',
            message: 'Nhập kho vật tư để theo dõi các lô hàng tại đây.',
          )
        else
          ...lots.map(
            (lot) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _LotCard(
                lot: lot,
                unit: product.unit,
                firstOut: available.isNotEmpty && lot.id == available.first.id,
                onSetExpiry: onSetExpiry == null
                    ? null
                    : () => onSetExpiry!(lot),
              ),
            ),
          ),
        const SizedBox(height: 18),
        if (product.isArchived)
          InventoryGradientButton(
            label: 'Sử dụng lại vật tư',
            iconAsset: InventoryAssets.save,
            onPressed: onRestore,
          )
        else
          SizedBox(
            height: 46,
            child: OutlinedButton.icon(
              onPressed: onPause,
              icon: const Icon(Icons.pause_circle_outline, size: 17),
              label: const Text(
                'Tạm ngưng vật tư',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFFEA580C),
                backgroundColor: const Color(0xFFFFF7E8),
                side: const BorderSide(color: Color(0xFFFCD34D)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Future<void> _chooseStockOut(
    BuildContext context,
    List<InventoryLot> lots,
  ) async {
    final lot = lots.length == 1
        ? lots.first
        : await showModalBottomSheet<InventoryLot>(
            context: context,
            isScrollControlled: true,
            useSafeArea: true,
            backgroundColor: Colors.white,
            barrierColor: AppColors.ink.withValues(alpha: 0.35),
            constraints: const BoxConstraints(maxWidth: 560),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            clipBehavior: Clip.antiAlias,
            builder: (_) => InventoryStockOutLotPicker(
              productName: product.name,
              unit: product.unit,
              lots: lots,
            ),
          );
    if (lot != null && context.mounted) {
      context.push(
        '/farms/$farmId/inventory/${product.id}/stock-out/${lot.id}',
      );
    }
  }
}

class _StatCell extends StatelessWidget {
  const _StatCell({
    required this.label,
    required this.value,
    required this.caption,
    this.color = AppColors.ink,
    this.valueSize = 20,
  });
  final String label;
  final String value;
  final String caption;
  final Color color;
  final double valueSize;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        maxLines: 1,
        style: const TextStyle(
          color: AppColors.inkMuted,
          fontSize: 9,
          letterSpacing: 0.15,
        ),
      ),
      const SizedBox(height: 4),
      SizedBox(
        height: 27,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            value,
            style: AppTypography.display(
              color: color,
              fontSize: valueSize,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
      const SizedBox(height: 2),
      Text(
        caption,
        style: const TextStyle(color: AppColors.inkMuted, fontSize: 10),
      ),
    ],
  );
}

class _ProductGallery extends StatefulWidget {
  const _ProductGallery({
    required this.urls,
    required this.category,
    super.key,
  });
  final InventoryCategory category;
  final List<String> urls;
  @override
  State<_ProductGallery> createState() => _ProductGalleryState();
}

class _ProductGalleryState extends State<_ProductGallery> {
  int selected = 0;
  @override
  void didUpdateWidget(covariant _ProductGallery oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (selected >= widget.urls.length) {
      selected = widget.urls.isEmpty ? 0 : widget.urls.length - 1;
    }
  }

  @override
  Widget build(BuildContext context) => InventorySurface(
    radius: 18,
    padding: const EdgeInsets.all(14),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'Hình ảnh vật tư',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.ink,
                ),
              ),
            ),
            Text(
              '${selected + 1}/${widget.urls.length}',
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: AppColors.inkMuted,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        InventoryProductImage(
          url: widget.urls[selected],
          category: widget.category,
          width: double.infinity,
          height: 176,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 6),
        Text(
          inventoryPhotoLabel(selected),
          style: const TextStyle(fontSize: 11, color: AppColors.inkSoft),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 58,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: widget.urls.length,
            separatorBuilder: (_, index) => const SizedBox(width: 8),
            itemBuilder: (_, index) => Semantics(
              button: true,
              selected: selected == index,
              label: 'Xem ảnh vật tư ${index + 1}',
              child: InkWell(
                onTap: () => setState(() => selected = index),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 58,
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: selected == index
                          ? const Color(0xFF3F97E8)
                          : Colors.transparent,
                    ),
                  ),
                  child: InventoryProductImage(
                    url: widget.urls[index],
                    category: widget.category,
                    size: 50,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

class _LotCard extends StatelessWidget {
  const _LotCard({
    required this.lot,
    required this.unit,
    required this.firstOut,
    this.onSetExpiry,
  });
  final InventoryLot lot;
  final InventoryProductUnit unit;
  final bool firstOut;
  final VoidCallback? onSetExpiry;
  @override
  Widget build(BuildContext context) => InventorySurface(
    radius: 18,
    padding: const EdgeInsets.all(14),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Lô ${lot.lotNumber}',
                style: AppTypography.mono(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.ink,
                ),
              ),
            ),
            if (firstOut)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFE2F6F3),
                  borderRadius: BorderRadius.circular(99),
                ),
                child: const Text(
                  '● Xuất trước',
                  style: TextStyle(
                    color: Color(0xFF0F9B8E),
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 3),
        Text(
          'Nhập ${formatInventoryDate(lot.receivedAt)}',
          style: const TextStyle(color: AppColors.inkMuted, fontSize: 10),
        ),
        Text(
          lot.expiryDate == null
              ? 'Chưa rõ hạn sử dụng — chưa dùng cho vận hành'
              : 'Hạn sử dụng: ${formatInventoryDate(lot.expiryDate!)}',
          style: const TextStyle(color: AppColors.inkMuted, fontSize: 10),
        ),
        if (lot.expiryDate == null)
          TextButton(
            onPressed: onSetExpiry,
            child: const Text('Bổ sung hạn dùng'),
          ),
        const SizedBox(height: 4),
        Text(
          'Nhà cung cấp: ${lot.supplierName}',
          style: const TextStyle(color: AppColors.inkSoft, fontSize: 10),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _lotMetric(
              'Đã nhập',
              lot.receivedQuantity == null
                  ? '—'
                  : '${formatInventoryQuantity(lot.receivedQuantity!)} ${unit.label}',
            ),
            const SizedBox(width: 6),
            _lotMetric(
              'Còn lại',
              '${formatInventoryQuantity(lot.quantity)} ${unit.label}',
              accent: true,
            ),
            const SizedBox(width: 6),
            _lotMetric(
              'Đơn giá',
              '${formatInventoryMoney(lot.unitPrice)}/${unit.label}',
            ),
          ],
        ),
        const SizedBox(height: 12),
        ExcludeSemantics(
          excluding: lot.usageRatio == null,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: lot.usageRatio ?? 0,
              minHeight: 5,
              color: const Color(0xFF1D7AD6),
              backgroundColor: const Color(0xFFF1F5F9),
              semanticsLabel: 'Tỷ lệ đã sử dụng (%)',
              semanticsValue: lot.usageRatio == null
                  ? null
                  : '${(lot.usageRatio! * 100).round()}',
            ),
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: Text(
                lot.usageRatio == null
                    ? 'Chưa có dữ liệu nhập'
                    : 'Đã sử dụng ${(lot.usageRatio! * 100).round()}%',
                style: const TextStyle(fontSize: 9, color: AppColors.inkMuted),
              ),
            ),
            Text(
              'Giá trị còn ${formatInventoryMoney(lot.inventoryValue)}',
              style: const TextStyle(fontSize: 9, color: Color(0xFF0F62B4)),
            ),
          ],
        ),
      ],
    ),
  );
  Widget _lotMetric(String label, String value, {bool accent = false}) =>
      Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 9, color: AppColors.inkMuted),
              ),
              const SizedBox(height: 3),
              Text(
                value,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: accent ? const Color(0xFF0F9B8E) : AppColors.ink,
                ),
              ),
            ],
          ),
        ),
      );
}

String _compactMoney(double value) => value >= 1000000
    ? '${formatInventoryQuantity((value / 1000000 * 10).round() / 10)} tr ₫'
    : formatInventoryMoney(value);

class _DetailError extends StatelessWidget {
  const _DetailError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(24),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(message, textAlign: TextAlign.center),
        const SizedBox(height: 12),
        FilledButton(onPressed: onRetry, child: const Text('Thử lại')),
      ],
    ),
  );
}

String _errorMessage(Object? error) => error is AppException
    ? error.message
    : 'Không thể tải hoặc cập nhật vật tư. Vui lòng thử lại.';
