import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
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
      trailing: product != null && !product.isArchived
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
                onReplace: product.isArchived || mutation.isLoading
                    ? null
                    : (index) => _replacePhoto(context, ref, product, index),
                onDelete: mutation.isLoading
                    ? null
                    : () => _delete(context, ref, product),
                onRestore: mutation.isLoading
                    ? null
                    : () => _restore(context, ref, product),
              ),
            ),
    );
  }

  Future<void> _replacePhoto(
    BuildContext context,
    WidgetRef ref,
    InventoryProduct product,
    int index,
  ) async {
    try {
      final file = await ref
          .read(inventoryImagePickerProvider)
          .pickImage(source: ImageSource.gallery, requestFullMetadata: false);
      if (file == null || !context.mounted) return;
      if (await file.length() > InventoryRules.maxImageBytes) {
        throw const ApiException('Ảnh vật tư không được vượt quá 5 MB.');
      }
      final bytes = await file.readAsBytes();
      InventoryRules.validateImage(bytes);
      if (!context.mounted) return;
      final InventoryPhotoReplacement replacement = (
        index: index,
        bytes: bytes,
        fileName: file.name,
      );
      await context.push<void>(
        '/farms/$farmId/inventory/${product.id}/edit',
        extra: replacement,
      );
    } on AppException catch (error) {
      if (context.mounted) AppNoticeService.danger(context, error.message);
    } on PlatformException {
      if (context.mounted) {
        AppNoticeService.danger(
          context,
          'Không thể mở trình chọn tệp ảnh. Vui lòng thử lại.',
        );
      }
    }
  }

  Future<void> _delete(
    BuildContext context,
    WidgetRef ref,
    InventoryProduct product,
  ) async {
    final canDelete =
        product.currentStock == 0 &&
        (product.plannedUseCount ?? 0) == 0 &&
        product.canArchive != false;
    if (!canDelete) {
      final blockers = <String>[
        if (product.currentStock > 0)
          'Kho vẫn còn ${formatInventoryQuantity(product.currentStock)} ${product.unit.label}',
        if ((product.plannedUseCount ?? 0) > 0)
          'Vật tư đang được dùng trong ${product.plannedUseCount} lịch vận hành dự kiến',
      ];
      if (blockers.isEmpty) blockers.add('Vật tư chưa đủ điều kiện xóa.');
      await showDialog<void>(
        context: context,
        builder: (dialogContext) => AppDialog(
          title: 'Chưa thể xóa vật tư',
          description: 'Hoàn tất các mục bên dưới rồi thử lại.',
          level: AppNoticeLevel.warning,
          icon: Icons.warning_amber_rounded,
          verticalHeader: true,
          separatedActions: true,
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final blocker in blockers)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF2DD),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.warning_amber_rounded,
                            size: 14,
                            color: Color(0xFFEA580C),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              blocker,
                              style: const TextStyle(
                                fontSize: 11,
                                height: 1.4,
                                color: Color(0xFFB45309),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              height: 44,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(dialogContext),
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.inkSoft,
                  side: const BorderSide(color: AppColors.line),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Đã hiểu',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      );
      return;
    }
    final message =
        'Xóa vật tư “${product.name}” khỏi kho? Lịch sử giao dịch vẫn được giữ lại.';
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Xóa vật tư?'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Hủy'),
          ),
          FilledButton(
            onPressed: canDelete
                ? () => Navigator.pop(dialogContext, true)
                : null,
            child: const Text('Xóa vật tư'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    try {
      await ref
          .read(inventoryMutationControllerProvider(farmId).notifier)
          .deleteProduct(product.id);
      if (!context.mounted) return;
      AppNoticeService.success(context, 'Đã xóa vật tư.');
      context.pop();
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
        AppNoticeService.success(context, 'Đã khôi phục vật tư.');
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
    this.onReplace,
    required this.onDelete,
    required this.onRestore,
  });
  final InventoryProduct product;
  final String farmId;
  final Future<void> Function(int)? onReplace;
  final VoidCallback? onDelete;
  final VoidCallback? onRestore;

  @override
  Widget build(BuildContext context) {
    final lots = [...product.lots]
      ..sort((a, b) {
        final date = a.receivedAt.compareTo(b.receivedAt);
        return date == 0 ? a.id.compareTo(b.id) : date;
      });
    final available = lots.where((lot) => lot.quantity > 0).toList();
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 32),
      children: [
        InventorySurface(
          radius: 18,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
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
                  const SizedBox(width: 8),
                  InventoryCategoryBadge(category: product.category),
                  const Spacer(),
                  if (product.isArchived)
                    const Text(
                      'Đã lưu trữ',
                      style: TextStyle(fontSize: 11, color: AppColors.inkMuted),
                    )
                  else if (product.isLowStock)
                    const LowStockBadge(),
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
        if (product.effectiveImageUrls.isNotEmpty) ...[
          const SizedBox(height: 16),
          _ProductGallery(
            key: ValueKey(product.id),
            urls: product.effectiveImageUrls,
            onReplace: onReplace,
          ),
        ],
        const SizedBox(height: 16),
        if (!product.isArchived)
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
                    'Ưu tiên xuất lô nhập trước',
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
          const InventorySurface(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(child: Text('Chưa có lô hàng nào.')),
            ),
          )
        else
          ...lots.map(
            (lot) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _LotCard(
                lot: lot,
                unit: product.unit,
                firstOut: available.isNotEmpty && lot.id == available.first.id,
              ),
            ),
          ),
        const SizedBox(height: 18),
        if (product.isArchived)
          InventoryGradientButton(
            label: 'Khôi phục vật tư',
            iconAsset: InventoryAssets.save,
            onPressed: onRestore,
          )
        else
          SizedBox(
            height: 46,
            child: OutlinedButton.icon(
              onPressed: onDelete,
              icon: const Icon(Icons.delete_outline, size: 17),
              label: const Text(
                'Xóa vật tư',
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
  const _ProductGallery({required this.urls, this.onReplace, super.key});
  final Future<void> Function(int)? onReplace;
  final List<String> urls;
  @override
  State<_ProductGallery> createState() => _ProductGalleryState();
}

class _ProductGalleryState extends State<_ProductGallery> {
  int selected = 0;
  bool replacing = false;
  @override
  void didUpdateWidget(covariant _ProductGallery oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (selected >= widget.urls.length) {
      selected = widget.urls.isEmpty ? 0 : widget.urls.length - 1;
    }
  }

  Future<void> _replace() async {
    if (replacing || widget.onReplace == null) return;
    setState(() => replacing = true);
    try {
      await widget.onReplace!(selected);
    } finally {
      if (mounted) setState(() => replacing = false);
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
                    size: 50,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
        ),
        if (widget.onReplace != null)
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: replacing ? null : _replace,
              icon: const Icon(Icons.edit_outlined, size: 16),
              label: Text(replacing ? 'Đang chọn ảnh…' : 'Đổi ảnh'),
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF0F62B4),
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
  });
  final InventoryLot lot;
  final InventoryProductUnit unit;
  final bool firstOut;
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
