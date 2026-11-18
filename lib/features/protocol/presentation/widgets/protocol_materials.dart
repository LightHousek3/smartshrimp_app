import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/widgets/app_image_viewer.dart';
import 'package:smartshrimp_app/features/inventory/presentation/widgets/inventory_product_image.dart';
import 'package:smartshrimp_app/features/protocol/domain/entities/protocol.dart';
import 'package:smartshrimp_app/features/protocol/presentation/view_models/protocol_controller.dart';
import 'package:smartshrimp_app/features/protocol/presentation/widgets/protocol_ui.dart';

/// Show this submission's Expert proposals, including those created during its review.
/// Catalogue selections remain in the timeline, even when meals share a product.
List<List<ProtocolMaterialReview>> protocolMaterialGroups(
  ProtocolDetail detail,
) {
  final groups = <Object, List<ProtocolMaterialReview>>{};
  for (final row in detail.materialReviews) {
    final proposed = row.proposed;
    if (proposed == null) continue;
    final manufacturer = proposed.manufacturer;
    final identity = proposed.copyWith(
      name: proposed.name.trim().toLowerCase(),
      category: proposed.category.toUpperCase(),
      unit: proposed.unit.toUpperCase(),
      description: null,
      recommendationReason: null,
      imageUrls: const [],
      minAlertQuantity: null,
      manufacturer: manufacturer == null
          ? null
          : ProtocolManufacturer(
              name: manufacturer.name.trim().toLowerCase(),
              address: manufacturer.address?.trim().toLowerCase(),
            ),
      productCompliance: proposed.productCompliance?.copyWith(
        checkedAt: null,
        checkedBy: null,
        evidenceUrls: const [],
      ),
    );
    final Object key =
        row.productId ?? (identity, row.recommendedManufacturerId);
    groups.putIfAbsent(key, () => []).add(row);
  }
  return groups.values.toList(growable: false);
}

/// Keep material creation separate from the Owner's approval decision.
class ProtocolMaterials extends ConsumerStatefulWidget {
  const ProtocolMaterials({required this.detail, this.busy = false, super.key});
  final ProtocolDetail detail;
  final bool busy;
  @override
  ConsumerState<ProtocolMaterials> createState() => _ProtocolMaterialsState();
}

class _ProtocolMaterialsState extends ConsumerState<ProtocolMaterials> {
  int _page = 0;
  String? _opening;
  static const _pageSize = 10;

  Future<void> _create(ProtocolMaterialReview row) async {
    if (_opening != null || widget.busy || row.proposed == null) return;
    setState(() => _opening = row.itemId);
    try {
      await context.push<bool>(
        '/farms/${Uri.encodeComponent(widget.detail.farmId)}/inventory/new',
        extra: ProtocolMaterialCreation(
          farmId: widget.detail.farmId,
          protocolId: widget.detail.card.id,
          itemId: row.itemId,
          updatedAt: widget.detail.updatedAt,
          submittedAt: widget.detail.card.submittedAt,
          material: row.proposed!,
          manufacturerId:
              row.recommendedManufacturerId ?? row.proposed!.manufacturerId,
        ),
      );
      // A save may have committed even if its response was lost before returning.
      if (mounted) {
        ref.invalidate(protocolDetailProvider(widget.detail.card.id));
        ref.invalidate(protocolDayProvider);
      }
    } finally {
      if (mounted) setState(() => _opening = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final groups = protocolMaterialGroups(widget.detail);
    if (groups.isEmpty) return const SizedBox.shrink();
    final unresolved = groups
        .where(
          (group) => group.any(
            (row) => row.productId == null || row.requiresResolution,
          ),
        )
        .length;
    final page = _page.clamp(0, (groups.length - 1) ~/ _pageSize);
    return ProtocolSurface(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Expanded(
                  child: Text(
                    'Vật tư đề xuất bởi chuyên gia',
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.4,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ProtocolBadge(
                  '$unresolved/${groups.length} cần xử lý',
                  color: unresolved == 0
                      ? protocolTeal
                      : const Color(0xFFBB4D00),
                  background: unresolved == 0
                      ? protocolTealPanel
                      : protocolAmberPanel,
                ),
              ],
            ),
          ),
          for (final group
              in groups.skip(page * _pageSize).take(_pageSize)) ...[
            const Divider(height: 1, color: AppColors.line),
            _ProposalRow(
              rows: group,
              canCreate:
                  widget.detail.canReview && widget.detail.farmId.isNotEmpty,
              busy: widget.busy || _opening != null,
              onCreate: () => _create(group.first),
            ),
          ],
          if (groups.length > _pageSize)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: page == 0
                        ? null
                        : () => setState(() => _page = page - 1),
                    child: const Text('Trước'),
                  ),
                  Text(
                    '${page + 1}/${(groups.length / _pageSize).ceil()}',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.inkMuted,
                    ),
                  ),
                  TextButton(
                    onPressed: (page + 1) * _pageSize >= groups.length
                        ? null
                        : () => setState(() => _page = page + 1),
                    child: const Text('Tiếp'),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _ProposalRow extends StatelessWidget {
  const _ProposalRow({
    required this.rows,
    required this.canCreate,
    required this.busy,
    required this.onCreate,
  });
  final List<ProtocolMaterialReview> rows;
  final bool canCreate, busy;
  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    const photoGap = 10.0;
    const columnGap = 8.0;
    final row = rows.first;
    final material = row.proposed!;
    final photos = material.imageUrls.isNotEmpty
        ? material.imageUrls
        : row.catalog?.imageUrls ?? const <String>[];
    final unresolved = rows.any((entry) => entry.requiresResolution);
    final needsCreation = row.productId == null;
    final color = needsCreation || unresolved
        ? const Color(0xFFBB4D00)
        : protocolTeal;
    final status = needsCreation
        ? 'Chưa tạo vật tư'
        : unresolved
        ? 'Cần kiểm tra vật tư'
        : 'Đã tạo vật tư';
    const metadataStyle = TextStyle(
      fontSize: 10.5,
      height: 1.5,
      color: AppColors.inkMuted,
    );
    final categoryLabel =
        '${_category(material.category)} · ${protocolUnit(material.unit)}';
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _MaterialPhoto(
                key: ValueKey('protocol_material_photo_${row.itemId}'),
                urls: photos,
                name: material.name,
              ),
              const SizedBox(width: photoGap),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) => Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Table(
                        columnWidths: {
                          0: FixedColumnWidth(
                            // Start status and manufacturer at the card midpoint,
                            // accounting for the photo and the two column gaps.
                            ((constraints.maxWidth -
                                            _MaterialPhoto.extent -
                                            photoGap) /
                                        2 -
                                    columnGap)
                                .clamp(0, constraints.maxWidth / 2)
                                .toDouble(),
                          ),
                          1: const FlexColumnWidth(),
                        },
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.top,
                        children: [
                          TableRow(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Text(
                                  material.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    height: 1.4,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.ink,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: columnGap,
                                  bottom: 4,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 3),
                                        child: Text(
                                          status,
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 10.5,
                                            height: 1.5,
                                            color: color,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                    if (needsCreation && canCreate) ...[
                                      const SizedBox(width: 6),
                                      TextButton(
                                        key: ValueKey(
                                          'create-proposal-${row.itemId}',
                                        ),
                                        style: TextButton.styleFrom(
                                          backgroundColor: const Color(
                                            0xFFEAF4FF,
                                          ),
                                          foregroundColor: AppColors.ocean,
                                          minimumSize: const Size(0, 28),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 5,
                                          ),
                                          tapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .labelLarge
                                              ?.copyWith(
                                                fontSize: 10.5,
                                                fontWeight: FontWeight.w700,
                                              ),
                                        ),
                                        onPressed: busy ? null : onCreate,
                                        child: const Text('Tạo vật tư'),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              Text(
                                categoryLabel,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: metadataStyle,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: columnGap),
                                child: Text(
                                  material.manufacturer == null
                                      ? ''
                                      : 'NSX: ${material.manufacturer!.name}',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 10.5,
                                    height: 1.5,
                                    color: AppColors.inkMuted,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      if (material.recommendationReason case final reason?
                          when reason.trim().isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            reason,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 10.5,
                              height: 1.5,
                              color: AppColors.inkSoft,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (unresolved && !needsCreation && row.resolutionMessage != null)
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text(
                row.resolutionMessage!,
                style: const TextStyle(
                  fontSize: 10.5,
                  height: 1.5,
                  color: AppColors.error,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Use the Expert's label photo and the shared gallery, without a material icon fallback.
class _MaterialPhoto extends StatelessWidget {
  const _MaterialPhoto({required this.urls, required this.name, super.key});
  static const extent = 58.0;
  final List<String> urls;
  final String name;

  Widget get _placeholder => ColoredBox(
    color: protocolPanel,
    child: Center(
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Text(
          urls.isEmpty ? 'Chưa có ảnh' : 'Ảnh vật tư',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 9,
            height: 1.4,
            color: AppColors.inkMuted,
          ),
        ),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) => Semantics(
    label: urls.isEmpty ? 'Chưa có ảnh $name' : 'Xem ảnh $name',
    button: urls.isNotEmpty,
    child: Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(color: AppColors.line),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: urls.isEmpty
            ? null
            : () => showAppImageViewer(
                context,
                builder: (_) => AppImageViewer(
                  itemCount: urls.length,
                  initialIndex: 0,
                  imageBuilder: (index, fit) => InventoryProductImage(
                    url: urls[index],
                    width: double.infinity,
                    height: double.infinity,
                    fit: fit,
                    placeholder: _placeholder,
                  ),
                ),
              ),
        child: InventoryProductImage(
          url: urls.isEmpty ? null : urls.first,
          size: extent,
          fit: BoxFit.contain,
          placeholder: _placeholder,
        ),
      ),
    ),
  );
}

String _category(String value) => switch (value.toUpperCase()) {
  'FEED' || 'FEEDING' => 'Thức ăn',
  'MEDICINE' => 'Thuốc',
  'MINERAL' => 'Khoáng chất',
  'CHEMICAL' => 'Xử lý môi trường',
  _ => 'Vật tư khác',
};
