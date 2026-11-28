import 'package:smartshrimp_app/core/utils/vietnamese_number.dart';
import 'package:flutter/material.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/widgets/app_svg_icon.dart';
import 'package:smartshrimp_app/features/operation/domain/entities/operation_models.dart';
import 'package:smartshrimp_app/features/operation/presentation/widgets/operation_product_thumbnail.dart';
import 'package:smartshrimp_app/features/operation/presentation/widgets/operation_type_badge.dart';

const operationMealSectionTitle = 'Cữ ăn & thuốc theo cữ';
String operationEnvironmentSectionTitle(Iterable<OperationType> types) =>
    types.every(
      (type) => type == OperationType.mineral || type == OperationType.chemical,
    )
    ? 'Xử lý khoáng / hóa chất'
    : 'Xử lý môi trường';

class OperationOccurrenceIcon extends StatelessWidget {
  const OperationOccurrenceIcon({
    required this.isTreatment,
    this.environmental = false,
    this.size = 36,
    super.key,
  });

  final bool isTreatment;
  final bool environmental;
  final double size;

  static Color foreground(bool isTreatment, {bool environmental = false}) =>
      isTreatment
      ? AppColors.treatmentAccent
      : environmental
      ? const Color(0xFF0D9488)
      : const Color(0xFF1D7AD6);

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: isTreatment
          ? AppColors.treatmentSurface
          : environmental
          ? const Color(0xFFE6FFFA)
          : const Color(0xFFDEEDFD),
      borderRadius: BorderRadius.circular(12),
    ),
    child: AppSvgIcon(
      environmental ? AppSvgIconName.chemical : AppSvgIconName.calendarDays,
      color: foreground(isTreatment, environmental: environmental),
      size: size * 0.53,
    ),
  );
}

class OperationMealGroupCard extends StatefulWidget {
  const OperationMealGroupCard({
    required this.group,
    this.onTapDetail,
    this.initiallyExpanded,
    super.key,
  });

  final FeedingMedicineMealGroup group;
  final void Function(OperationSchedule schedule)? onTapDetail;
  final bool? initiallyExpanded;

  @override
  State<OperationMealGroupCard> createState() => _OperationMealGroupCardState();
}

class _OperationMealGroupCardState extends State<OperationMealGroupCard> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded ?? widget.group.hasBoth;
  }

  @override
  Widget build(BuildContext context) {
    final group = widget.group;
    final isTreatment = group.isTreatment;
    final title = group.cardTitle;

    final environmental = !group.belongsToMeal;
    final headerFg = OperationOccurrenceIcon.foreground(
      isTreatment,
      environmental: environmental,
    );

    final primaryFeeding = group.primaryFeeding;
    final primarySchedule = group.activeSchedules.isNotEmpty
        ? group.activeSchedules.first
        : (primaryFeeding ??
              (group.allSchedules.isNotEmpty
                  ? group.allSchedules.first
                  : null));
    final isGroupOverdue = group.isOverdue;

    return Container(
      decoration: BoxDecoration(
        color: isGroupOverdue
            ? OperationOverdueBadge.cardSurface
            : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: isGroupOverdue
            ? Border.all(
                color: OperationOverdueBadge.cardBorder.withValues(alpha: 0.85),
              )
            : null,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: Column(
          children: <Widget>[
            InkWell(
              onTap: () {
                if (widget.onTapDetail != null && primarySchedule != null) {
                  widget.onTapDetail!(primarySchedule);
                }
              },
              borderRadius: BorderRadius.circular(20),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 7, 14, 14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    OperationOccurrenceIcon(
                      isTreatment: isTreatment,
                      environmental: environmental,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Text(
                                  title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                    color: isTreatment
                                        ? const Color(0xFF9F1239)
                                        : AppColors.ink,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                flex: 7,
                                child: OperationStatusLine(
                                  badge: OperationStatusBadge(
                                    status: group.overallStatus,
                                  ),
                                  label:
                                      group.activeSchedules.any(
                                        (row) => row.activatedAt != null,
                                      )
                                      ? const OperationUnrecordedBadge()
                                      : isGroupOverdue &&
                                            group.overallStatus ==
                                                OperationStatus.planned
                                      ? const OperationOverdueBadge(
                                          compact: true,
                                        )
                                      : null,
                                ),
                              ),
                              const SizedBox(width: 4),
                              SizedBox(
                                width: 32,
                                height: 36,
                                child: IconButton(
                                  tooltip: _isExpanded
                                      ? environmental
                                            ? 'Thu gọn danh sách vật tư'
                                            : 'Thu gọn cữ'
                                      : 'Mở danh sách vật tư',
                                  style: IconButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  onPressed: () => setState(
                                    () => _isExpanded = !_isExpanded,
                                  ),
                                  icon: Icon(
                                    _isExpanded
                                        ? Icons.keyboard_arrow_up_rounded
                                        : Icons.keyboard_arrow_down_rounded,
                                    color: headerFg,
                                    size: 22,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.access_time_rounded,
                                size: 13,
                                color: AppColors.inkMuted,
                              ),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  group.timeRangeText,
                                  style: const TextStyle(
                                    color: AppColors.inkSoft,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            if (_isExpanded && group.allSchedules.isNotEmpty) ...<Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
                child: Column(
                  children: <Widget>[
                    for (final s in group.allSchedules) ...<Widget>[
                      _buildScheduleItemRow(context, s),
                      if (s != group.allSchedules.last)
                        const SizedBox(height: 6),
                    ],
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleItemRow(BuildContext context, OperationSchedule s) {
    final visuals = OperationTypeVisuals.of(s.operationType);
    final quantityStr =
        '${formatVietnameseNumber(s.plannedQuantity, decimalPlaces: 9)} ${s.unit.toLowerCase()}';

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF3F7FC),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: () {
            if (widget.onTapDetail != null) {
              widget.onTapDetail!(s);
            }
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
            child: Row(
              children: <Widget>[
                OperationProductThumbnail(
                  imageUrl: s.productImageUrl,
                  fallbackIcon: visuals.icon,
                  fallbackBg: visuals.bg,
                  fallbackFg: visuals.fg,
                  size: 36,
                  borderRadius: 10,
                  iconSize: 18,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      OperationTypeBadge(type: s.operationType, compact: true),
                      const SizedBox(height: 4),
                      Text(
                        s.productName,
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.ink,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  quantityStr,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.inkSoft,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
