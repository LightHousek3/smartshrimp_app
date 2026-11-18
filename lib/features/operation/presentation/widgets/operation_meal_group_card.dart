import 'package:flutter/material.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/features/operation/domain/entities/operation_models.dart';
import 'package:smartshrimp_app/features/operation/presentation/widgets/operation_product_thumbnail.dart';
import 'package:smartshrimp_app/features/operation/presentation/widgets/operation_type_badge.dart';

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
  static const Color _blueBg = Color(0xFFDEEDFD);
  static const Color _blueFg = Color(0xFF1D7AD6);

  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    // Mặc định mở nếu cữ có nhiều hơn 1 thành phần (ví dụ có cả thức ăn và thuốc) hoặc được chỉ định
    _isExpanded = widget.initiallyExpanded ?? widget.group.hasBoth;
  }

  (Color dot, Color text, Color bg) _statusVisuals(OperationStatus status) =>
      switch (status) {
        OperationStatus.planned => (
          _blueFg,
          _blueFg,
          _blueBg,
        ),
        OperationStatus.completed => (
          const Color(0xFF10B981),
          const Color(0xFF047857),
          const Color(0xFFECFDF5),
        ),
        OperationStatus.cancelled => (
          AppColors.inkMuted,
          AppColors.inkMuted,
          const Color(0xFFF1F5F9),
        ),
      };

  Widget _buildStatusBadge(OperationStatus status) {
    final (dot, text, bg) = _statusVisuals(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.5, vertical: 3.5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: dot,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            status.displayName,
            style: TextStyle(
              color: text,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final group = widget.group;
    final title = group.mealNumber != null ? 'Cữ ${group.mealNumber}' : 'Cữ ăn';

    // Header icon: Cữ vận hành dùng icon lịch trình với nền #DEEDFD và màu #319AE7
    const headerBg = _blueBg;
    const headerFg = _blueFg;
    const headerIcon = Icons.event_note_rounded;

    final primaryFeeding = group.primaryFeeding;
    final primarySchedule = group.activeSchedules.isNotEmpty
        ? group.activeSchedules.first
        : (primaryFeeding ??
              (group.allSchedules.isNotEmpty ? group.allSchedules.first : null));
    final isGroupOverdue = group.isOverdue;

    return Container(
      decoration: BoxDecoration(
        color: isGroupOverdue
            ? OperationOverdueBadge.cardSurface
            : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isGroupOverdue
              ? OperationOverdueBadge.cardBorder.withValues(alpha: 0.85)
              : AppColors.line.withValues(alpha: 0.6),
        ),
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
            // 1. Header accordion: Nhấn vào toàn bộ header để xem chi tiết cữ
            InkWell(
              onTap: () {
                if (widget.onTapDetail != null && primarySchedule != null) {
                  widget.onTapDetail!(primarySchedule);
                }
              },
              borderRadius: BorderRadius.circular(20),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: headerBg,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(headerIcon, color: headerFg, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Wrap(
                            spacing: 6,
                            runSpacing: 4,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: <Widget>[
                              Text(
                                title,
                                style: const TextStyle(
                                  fontSize: 15.5,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.ink,
                                ),
                              ),
                              if (isGroupOverdue)
                                const OperationOverdueBadge(compact: true),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: <Widget>[
                              const Icon(
                                Icons.access_time_rounded,
                                size: 13,
                                color: AppColors.inkMuted,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                group.timeRangeText,
                                style: const TextStyle(
                                  color: AppColors.inkSoft,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    _buildStatusBadge(group.overallStatus),
                    const SizedBox(width: 4),
                    // Nhấn vào icon mũi tên để mở / đóng cữ
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => setState(() => _isExpanded = !_isExpanded),
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Icon(
                          _isExpanded
                              ? Icons.keyboard_arrow_up_rounded
                              : Icons.keyboard_arrow_down_rounded,
                          color: _blueFg,
                          size: 22,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 2. Nội dung mở rộng: Danh sách chi tiết các thành phần trong cữ
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
    final quantityStr = '${s.plannedQuantity} ${s.unit.toLowerCase()}';

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
                      OperationTypeBadge(
                        type: s.operationType,
                        compact: true,
                      ),
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
