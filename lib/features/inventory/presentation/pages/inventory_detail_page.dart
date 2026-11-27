import 'package:smartshrimp_app/core/errors/error_mapper.dart';
import 'package:smartshrimp_app/core/widgets/app_error_state.dart';
import 'package:smartshrimp_app/features/inventory/presentation/widgets/inventory_directory_ui.dart';
import 'package:smartshrimp_app/features/inventory/presentation/widgets/inventory_empty_state.dart';
import 'package:smartshrimp_app/features/inventory/presentation/widgets/inventory_product_details.dart';
import 'package:smartshrimp_app/features/inventory/presentation/widgets/inventory_receipt_card.dart';
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
import 'package:smartshrimp_app/features/inventory/presentation/pages/inventory_supplier_detail_page.dart';
import 'package:smartshrimp_app/features/inventory/presentation/inventory_view_data.dart';
import 'package:smartshrimp_app/features/inventory/presentation/view_models/inventory_controller.dart';
import 'package:smartshrimp_app/features/inventory/presentation/widgets/inventory_ui.dart';
import 'package:smartshrimp_app/features/inventory/presentation/widgets/inventory_stock_out_lot_picker.dart';
import 'package:smartshrimp_app/features/inventory/presentation/widgets/inventory_supplier_dialog.dart';

class InventoryDetailPage extends ConsumerWidget {
  const InventoryDetailPage({
    required this.farmId,
    required this.productId,
    super.key,
  });

  final String farmId;
  final String productId;

  Future<void> _openManufacturer(
    BuildContext context,
    String manufacturerId,
  ) async {
    final result = await Navigator.of(context)
        .push<InventorySupplierDetailResult>(
          MaterialPageRoute(
            builder: (_) => InventorySupplierDetailPage(
              farmId: farmId,
              supplierId: manufacturerId,
              allowDelete: false,
            ),
          ),
        );
    if (!context.mounted ||
        result == null ||
        result.action != InventorySupplierAction.edit) {
      return;
    }
    final supplier = result.supplier;
    await context.push(
      '/farms/$farmId/inventory/suppliers/${supplier.id}/edit',
      extra: supplier,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final key = (farmId: farmId, productId: productId);
    final productState = ref.watch(inventoryDetailControllerProvider(key));
    final mutation = ref.watch(inventoryMutationControllerProvider(farmId));
    final product = productState.value;
    final manufacturerId = product?.manufacturerId.trim();

    return InventoryPageFrame(
      title: 'Chi tiết vật tư',
      subtitle: product?.name,
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
                  ? AppErrorState(
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
                onOpenManufacturer:
                    manufacturerId == null || manufacturerId.isEmpty
                    ? null
                    : () => _openManufacturer(context, manufacturerId),
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
    } on Object catch (error) {
      if (context.mounted) {
        AppNoticeService.danger(context, ErrorMapper.displayMessage(error));
      }
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
            style: TextButton.styleFrom(
              textStyle: inventoryTextButtonTextStyle,
            ),
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
    } on Object catch (error) {
      if (context.mounted) {
        AppNoticeService.danger(context, ErrorMapper.displayMessage(error));
      }
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
      retentionMessage:
          product.deletionConfirmationMessage ??
          'Chỉ xóa vật tư chưa phát sinh kho, lịch vận hành hoặc phác đồ đã duyệt.',
      confirmLabel: 'Xóa vật tư',
    );
    if (!confirmed || !context.mounted) return;
    try {
      await ref
          .read(inventoryMutationControllerProvider(farmId).notifier)
          .delete(
            product.id,
            confirmationToken: product.deletionConfirmationToken,
          );
      if (context.mounted) {
        AppNoticeService.success(
          context,
          product.deletionConfirmationToken == null
              ? 'Đã xóa vật tư.'
              : 'Đã xóa vật tư. Vui lòng cập nhật các mẫu/phác đồ bị ảnh hưởng.',
        );
        context.pop();
      }
    } on Object catch (error) {
      if (context.mounted) {
        if (error is AppException && error.statusCode == 409) {
          ref.invalidate(
            inventoryDetailControllerProvider((
              farmId: farmId,
              productId: product.id,
            )),
          );
        }
        AppNoticeService.danger(context, ErrorMapper.displayMessage(error));
      }
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
    this.onOpenManufacturer,
    required this.onPause,
    required this.onRestore,
    this.onDelete,
    this.onSetExpiry,
  });
  final InventoryProduct product;
  final String farmId;
  final VoidCallback? onOpenManufacturer;
  final VoidCallback? onPause;
  final VoidCallback? onRestore;
  final VoidCallback? onDelete;
  final Future<void> Function(InventoryLot)? onSetExpiry;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
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
    final priorityLot = product.isArchived
        ? null
        : available.where((lot) {
            final expiry = lot.expiryDate;
            return expiry != null &&
                !InventoryRules.isExpiredOn(expiry, at: now) &&
                !lot.receivedAt.isAfter(now);
          }).firstOrNull;
    final photos = product.effectiveImageUrls;
    final actionHeight =
        45.0 * MediaQuery.textScalerOf(context).scale(1).clamp(1, 1.6);
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
      children: [
        if (product.readOnly) const InventoryReadOnlyNotice(),
        if (!product.readOnly &&
            !product.isArchived &&
            product.manufacturerId.isEmpty)
          const Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: Text('Chưa có nhà sản xuất. Chọn chỉnh sửa để bổ sung.'),
          ),
        InventoryProductSummary(
          product: product,
          onOpenManufacturer: onOpenManufacturer,
        ),
        const SizedBox(height: 16),
        InventoryComplianceDetails(
          compliance: product.compliance,
          productImages: photos,
        ),
        if (photos.isNotEmpty) ...[
          const SizedBox(height: 16),
          _ProductGallery(
            key: ValueKey(product.id),
            urls: photos,
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
                  height: actionHeight,
                  radius: 12,
                  fitContent: true,
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
                  height: actionHeight,
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
                    label: const FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text('Xuất kho', style: TextStyle(fontSize: 14)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      'Tồn kho theo lần nhập',
                      style: AppTypography.display(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: AppColors.ink,
                      ).copyWith(fontFamilyFallback: const ['PlusJakartaSans']),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    flex: 2,
                    child: Align(
                      alignment: Alignment.topRight,
                      child: InventoryStatusBadge(
                        label:
                            '${formatInventoryQuantity(available.length)} lô còn hàng',
                        foreground: AppColors.ocean,
                        background: const Color(0xFFEAF4FF),
                        showDot: false,
                      ),
                    ),
                  ),
                ],
              ),
              if (!product.isArchived && lots.isNotEmpty) ...[
                const SizedBox(height: 4),
                const Text(
                  'Vận hành ưu tiên lô hợp lệ có hạn dùng sớm nhất.',
                  style: TextStyle(color: AppColors.inkMuted, fontSize: 11),
                ),
              ],
            ],
          ),
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
              child: InventoryReceiptCard(
                lot: lot,
                unit: product.unit,
                now: now,
                hasPriority: lot.id == priorityLot?.id,
                onSetExpiry: onSetExpiry == null
                    ? null
                    : () => onSetExpiry!(lot),
              ),
            ),
          ),
        const SizedBox(height: 18),
        if (!product.readOnly && product.canDelete) ...[
          InventoryDangerButton(label: 'Xóa vật tư', onPressed: onDelete),
          const SizedBox(height: 10),
        ],
        if (product.isArchived)
          InventoryGradientButton(
            height: actionHeight,
            fitContent: true,
            label: 'Sử dụng lại vật tư',
            iconAsset: InventoryAssets.save,
            onPressed: onRestore,
          )
        else
          SizedBox(
            height: actionHeight,
            child: OutlinedButton.icon(
              onPressed: onPause,
              icon: const Icon(Icons.block_outlined, size: 18),
              label: const FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  'Tạm ngưng vật tư',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.inkSoft,
                backgroundColor: Colors.white,
                side: const BorderSide(color: AppColors.line),
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
    final byReceipt = [...lots]
      ..sort((a, b) {
        final date = a.receivedAt.compareTo(b.receivedAt);
        return date == 0 ? a.id.compareTo(b.id) : date;
      });
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
              lots: byReceipt,
            ),
          );
    if (lot != null && context.mounted) {
      context.push(
        '/farms/$farmId/inventory/${product.id}/stock-out/${lot.id}',
      );
    }
  }
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
        if (widget.urls.length > 1) ...[
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
      ],
    ),
  );
}

String _errorMessage(Object? error) => error is AppException
    ? error.message
    : 'Không thể tải hoặc cập nhật vật tư. Vui lòng thử lại.';
