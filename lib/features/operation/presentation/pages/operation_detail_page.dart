import 'package:smartshrimp_app/core/utils/vietnamese_number.dart';
import 'package:flutter/material.dart';
import 'package:smartshrimp_app/core/widgets/app_error_state.dart';
import 'package:smartshrimp_app/features/assigned_season/presentation/view_models/assigned_season_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/widgets/app_gradient_background.dart';
import 'package:smartshrimp_app/core/widgets/app_notice.dart';
import 'package:smartshrimp_app/core/widgets/app_svg_icon.dart';
import 'package:smartshrimp_app/core/widgets/gradient_button.dart';
import 'package:smartshrimp_app/core/widgets/sticky_page_header.dart';
import 'package:smartshrimp_app/features/inventory/presentation/inventory_view_data.dart';
import 'package:smartshrimp_app/features/operation/domain/entities/operation_execution_explanation.dart';
import 'package:smartshrimp_app/features/operation/domain/entities/operation_models.dart';
import 'package:smartshrimp_app/features/operation/presentation/view_models/operation_controller.dart';
import 'package:smartshrimp_app/features/operation/presentation/widgets/operation_execute_sheet.dart';
import 'package:smartshrimp_app/features/operation/presentation/widgets/operation_product_thumbnail.dart';
import 'package:smartshrimp_app/features/operation/presentation/widgets/operation_type_badge.dart';
import 'package:smartshrimp_app/features/protocol/presentation/widgets/protocol_ui.dart'
    show protocolUnit;

class OperationDetailPage extends ConsumerStatefulWidget {
  const OperationDetailPage({
    required this.seasonId,
    required this.scheduleId,
    this.mealGroup,
    this.occurrenceDate,
    super.key,
  });

  final String seasonId;
  final String scheduleId;
  final FeedingMedicineMealGroup? mealGroup;
  final String? occurrenceDate;

  @override
  ConsumerState<OperationDetailPage> createState() =>
      _OperationDetailPageState();
}

class _OperationDetailPageState extends ConsumerState<OperationDetailPage> {
  static const Color _blueBg = Color(0xFFDEEDFD);
  static const Color _blueFg = Color(0xFF1D7AD6);
  static const _batchLimit = 20;

  final Set<String> _expandedScheduleIds = <String>{};

  String? get _linkedDate {
    final date = widget.occurrenceDate;
    if (date == null || !RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(date)) {
      return null;
    }
    final parsed = DateTime.tryParse('${date}T00:00:00Z');
    return parsed?.toIso8601String().startsWith('${date}T') == true
        ? date
        : null;
  }

  @override
  void initState() {
    super.initState();
    // Mặc định mở scheduleId hiện tại
    _expandedScheduleIds.add(widget.scheduleId);
  }

  (Color dot, Color text, Color bg) _statusVisuals(OperationStatus status) =>
      switch (status) {
        OperationStatus.planned => (_blueFg, _blueFg, _blueBg),
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

  String? _formatLocation(
    OperationSchedule schedule,
    OperationListResult? list,
  ) {
    final pond = (schedule.pondName ?? list?.pondName)?.trim();
    final season = (schedule.seasonName ?? list?.seasonName)?.trim();

    final formattedSeason = season != null && season.isNotEmpty
        ? (season.toLowerCase().startsWith('vụ') ? season : 'Vụ $season')
        : null;

    final parts = <String>[
      if (pond != null && pond.isNotEmpty) pond,
      ?formattedSeason,
    ];

    return parts.isEmpty ? null : parts.join(' · ');
  }

  String _formatCompactNumber(double value) =>
      formatVietnameseNumber(value, decimalPlaces: 1);

  String _formatBasisUnit(String? unit) {
    if (unit == null || unit.isEmpty) return '';
    final lower = unit.toLowerCase();
    if (lower == 'kg_biomass' || lower == 'percent_biomass') {
      return 'kg sinh khối';
    }
    if (lower == 'm3_water') return 'm³ nước';
    return lower;
  }

  Widget _buildParamBox({
    required String label,
    required String value,
    String? sub,
    Color? valueColor,
    Color? subColor,
  }) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: AppColors.inkMuted,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w800,
            color: valueColor ?? AppColors.ink,
          ),
        ),
        if (sub != null) ...<Widget>[
          const SizedBox(height: 2),
          Text(
            sub,
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: subColor != null ? FontWeight.w700 : FontWeight.w500,
              color: subColor ?? AppColors.inkMuted,
            ),
          ),
        ],
      ],
    ),
  );

  Widget _buildParamPair(Widget first, Widget second) => LayoutBuilder(
    builder: (context, constraints) {
      if (constraints.maxWidth < MediaQuery.textScalerOf(context).scale(192)) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [first, const SizedBox(height: 8), second],
        );
      }

      return IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: first),
            const SizedBox(width: 8),
            Expanded(child: second),
          ],
        ),
      );
    },
  );

  Widget _buildMaterialHeading(
    OperationSchedule item,
    String quantity,
    bool isExpanded,
  ) => LayoutBuilder(
    builder: (context, constraints) {
      final textScaler = MediaQuery.textScalerOf(context);
      final showThumbnail = constraints.maxWidth >= textScaler.scale(132);
      final showQuantityBadge = constraints.maxWidth >= textScaler.scale(220);
      final visuals = OperationTypeVisuals.of(item.operationType);

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (showThumbnail) ...[
                OperationProductThumbnail(
                  imageUrl: item.productImageUrl,
                  fallbackIcon: visuals.icon,
                  fallbackBg: visuals.bg,
                  fallbackFg: visuals.fg,
                  size: 38,
                  borderRadius: 10,
                  iconSize: 18,
                ),
                const SizedBox(width: 10),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OperationTypeBadge(type: item.operationType, compact: true),
                    const SizedBox(height: 4),
                    Text(
                      item.productName,
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                      ),
                      maxLines: showQuantityBadge ? 1 : 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (showQuantityBadge) ...[
                const SizedBox(width: 8),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: constraints.maxWidth / 3,
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.5,
                      vertical: 3.5,
                    ),
                    decoration: BoxDecoration(
                      color: visuals.bg,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      quantity,
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w800,
                        color: visuals.fg,
                      ),
                    ),
                  ),
                ),
              ],
              const SizedBox(width: 6),
              AnimatedRotation(
                turns: isExpanded ? 0.5 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.inkMuted,
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Padding(
            padding: EdgeInsets.only(left: showThumbnail ? 48 : 0),
            child: Row(
              children: [
                const Icon(
                  Icons.access_time_rounded,
                  size: 12.5,
                  color: AppColors.inkMuted,
                ),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    '${item.timeRangeText}  ·  $quantity',
                    style: const TextStyle(
                      fontSize: 11.5,
                      color: AppColors.inkMuted,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    },
  );

  /// Box nhỏ cho từng thành phần bên trong Box Lớn (Thức ăn, Thuốc,...)
  Widget _buildSubComponentBox(OperationSchedule item, {bool isLast = false}) {
    final isExpanded = _expandedScheduleIds.contains(item.id);

    final isMedicine = item.operationType == OperationType.medicine;

    final itemTimeStr = item.timeRangeText;
    final unit = protocolUnit(item.unit);
    final quantityStr =
        '${formatInventoryExactQuantity(item.plannedQuantity)} $unit';
    final instructions = item.protocolItem?.instructions?.trim();
    final productUsage = item.product?.usageInstructions?.trim();
    final showProductUsage =
        productUsage != null &&
        productUsage.isNotEmpty &&
        productUsage != instructions;
    final isCompleted = item.status == OperationStatus.completed;
    final isCancelled = item.status == OperationStatus.cancelled;

    final quantityLabel = switch (item.operationType) {
      OperationType.feeding => 'Lượng thức ăn',
      OperationType.mineral || OperationType.chemical => 'Liều tạt',
      _ => 'Liều kế hoạch',
    };

    final actualQuantity = item.execution?.actualQuantity;
    final actualQuantitySub = isCompleted && actualQuantity != null
        ? 'Đã dùng ${formatInventoryExactQuantity(actualQuantity)} $unit'
        : null;

    // Ô 4 theo đúng nghiệp vụ từng loại & 100% từ DB
    final allowedVariance = item.protocolItem?.protocol?.allowedVariancePct;
    final varianceText = allowedVariance != null
        ? '± ${_formatCompactNumber(allowedVariance)}%'
        : null;

    final String fourthLabel;
    final String fourthValue;

    if (isMedicine && item.product?.withdrawalDays != null) {
      fourthLabel = 'Ngưng thuốc';
      fourthValue =
          '${_formatCompactNumber(item.product!.withdrawalDays!)} ngày';
    } else if (!isMedicine && item.basisQuantity != null) {
      final basisUnit = _formatBasisUnit(item.basisUnit);
      fourthLabel = 'Dữ liệu tính liều';
      fourthValue = basisUnit.isNotEmpty
          ? '${_formatCompactNumber(item.basisQuantity!)} $basisUnit'
          : _formatCompactNumber(item.basisQuantity!);
    } else if (varianceText != null) {
      fourthLabel = 'Sai số cho phép';
      fourthValue = varianceText;
    } else {
      fourthLabel = 'Phiên bản tính';
      fourthValue = item.calculationVersion;
    }

    final instructionLabel = switch (item.operationType) {
      OperationType.feeding => 'Hướng dẫn cho ăn:',
      OperationType.medicine => 'Hướng dẫn phối trộn & cách dùng:',
      OperationType.mineral ||
      OperationType.chemical => 'Hướng dẫn tạt & xử lý ao:',
      _ => 'Hướng dẫn thực hiện:',
    };

    return Container(
      margin: isLast ? EdgeInsets.zero : const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F7FC),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // 1. Header Box Nhỏ (Bấm vào để sổ xuống / thu lại)
            InkWell(
              onTap: () {
                setState(() {
                  if (_expandedScheduleIds.contains(item.id)) {
                    _expandedScheduleIds.remove(item.id);
                  } else {
                    _expandedScheduleIds.add(item.id);
                  }
                });
              },
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                child: _buildMaterialHeading(item, quantityStr, isExpanded),
              ),
            ),

            // 2. Nội dung chi tiết sổ xuống ngay tại chỗ (phù hợp với từng loại)
            if (isExpanded) ...<Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Divider(
                      height: 1,
                      color: AppColors.line.withValues(alpha: 0.6),
                    ),
                    const SizedBox(height: 12),

                    _buildParamPair(
                      _buildParamBox(label: 'Giờ dự kiến', value: itemTimeStr),
                      _buildParamBox(
                        label: quantityLabel,
                        value: quantityStr,
                        valueColor: _blueFg,
                        sub: actualQuantitySub,
                        subColor: const Color(0xFF0D9488),
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildParamPair(
                      _buildParamBox(
                        label: 'Cách tính liều',
                        value: item.doseBasisDescription,
                      ),
                      _buildParamBox(label: fourthLabel, value: fourthValue),
                    ),

                    // Hướng dẫn chi tiết từ phác đồ
                    if (instructions != null &&
                        instructions.isNotEmpty) ...<Widget>[
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              instructionLabel,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: AppColors.inkMuted,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              instructions,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.inkSoft,
                                height: 1.35,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    // Hướng dẫn sử dụng của vật tư (từ product_compliance.usage_instructions)
                    if (showProductUsage) ...<Widget>[
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Text(
                              'Hướng dẫn sử dụng vật tư:',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: AppColors.inkMuted,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              productUsage,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.inkSoft,
                                height: 1.35,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    // Lý do hủy (nếu lịch đã hủy)
                    if (isCancelled &&
                        item.cancellationReason != null &&
                        item.cancellationReason!.isNotEmpty) ...<Widget>[
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'Lý do hủy: ${item.cancellationReason}',
                          style: const TextStyle(
                            fontSize: 11.5,
                            color: AppColors.inkSoft,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
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

  String _formatExecutedAt(DateTime dt) {
    final local = dt.toLocal();
    final hh = local.hour.toString().padLeft(2, '0');
    final mm = local.minute.toString().padLeft(2, '0');
    final dd = local.day.toString().padLeft(2, '0');
    final mo = local.month.toString().padLeft(2, '0');
    return '$hh:$mm · $dd/$mo/${local.year}';
  }

  Widget _buildCompletedSummaryHeader(
    DateTime executedAt, {
    required bool hasDeadline,
    required bool isLate,
  }) {
    final heading = Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: const Color(0xFFE6FFFA),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Center(
            child: Icon(
              Icons.check_circle_rounded,
              size: 18,
              color: Color(0xFF0D9488),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Đã ghi nhận thực hiện',
                style: TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0F766E),
                ),
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  const Icon(
                    Icons.access_time_rounded,
                    size: 11.5,
                    color: AppColors.inkMuted,
                  ),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      'Thực hiện lúc ${_formatExecutedAt(executedAt)}',
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w500,
                        color: AppColors.inkMuted,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
    if (!hasDeadline) return heading;

    final timingBadge = Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.5, vertical: 3.5),
      decoration: BoxDecoration(
        color: isLate ? OperationOverdueBadge.bg : const Color(0xFFE6FFFA),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: isLate
              ? OperationOverdueBadge.cardBorder
              : const Color(0xFFA7F3D0),
          width: 0.8,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 5.5,
            height: 5.5,
            decoration: BoxDecoration(
              color: isLate
                  ? OperationOverdueBadge.fg
                  : const Color(0xFF059669),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 4.5),
          Flexible(
            child: Text(
              isLate ? 'Trễ hạn' : 'Đúng giờ',
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
                color: isLate
                    ? OperationOverdueBadge.fg
                    : const Color(0xFF047857),
              ),
            ),
          ),
        ],
      ),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth <
            MediaQuery.textScalerOf(context).scale(280)) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [heading, const SizedBox(height: 8), timingBadge],
          );
        }
        return Row(
          children: [
            Expanded(child: heading),
            const SizedBox(width: 8),
            timingBadge,
          ],
        );
      },
    );
  }

  Widget _buildCompletedSummaryCard(List<OperationSchedule> completedItems) {
    final itemsWithExec = completedItems
        .where((s) => s.execution != null)
        .toList(growable: false);
    if (itemsWithExec.isEmpty) return const SizedBox.shrink();

    DateTime latestExecutedAt = itemsWithExec.first.execution!.executedAt;
    for (final item in itemsWithExec) {
      if (item.execution!.executedAt.isAfter(latestExecutedAt)) {
        latestExecutedAt = item.execution!.executedAt;
      }
    }

    final hasDeadline = itemsWithExec.any((s) => s.deadlineAt != null);
    final isLate = itemsWithExec.any((s) => s.wasExecutedLate);

    final explanations = OperationExecutionExplanation.forOccurrence(
      itemsWithExec.map(
        (item) => (
          id: item.id,
          material: item.productName,
          executedAt: item.execution!.executedAt,
          recordedAt: item.execution!.createdAt,
          executor: item.execution!.executedBy,
          note: item.execution!.note,
          varianceReason: item.execution!.varianceReason,
        ),
      ),
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFF0D9488).withValues(alpha: 0.16),
          width: 1,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: const Color(0xFF0D9488).withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildCompletedSummaryHeader(
            latestExecutedAt,
            hasDeadline: hasDeadline,
            isLate: isLate,
          ),

          const SizedBox(height: 10),
          Divider(height: 1, color: AppColors.line.withValues(alpha: 0.5)),
          const SizedBox(height: 10),

          // Danh sách số lượng thực tế ghi nhận (gọn gàng, tinh tế, không lặp lại ảnh/badge)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0), width: 0.8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                for (var i = 0; i < itemsWithExec.length; i++) ...<Widget>[
                  LayoutBuilder(
                    builder: (_, constraints) {
                      final item = itemsWithExec[i];
                      final unit = protocolUnit(item.unit);
                      final actual = formatInventoryExactQuantity(
                        item.execution!.actualQuantity,
                      );

                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: i < itemsWithExec.length - 1 ? 6.0 : 0.0,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: 5,
                              height: 5,
                              decoration: const BoxDecoration(
                                color: Color(0xFF0D9488),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 7),
                            Expanded(
                              child: Text(
                                item.productName,
                                style: const TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.ink,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: constraints.maxWidth * .5,
                              ),
                              child: Text(
                                '$actual $unit',
                                textAlign: TextAlign.right,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF0D9488),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ],
            ),
          ),

          for (final explanation in explanations)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    explanation.title,
                    style: const TextStyle(
                      color: AppColors.inkSoft,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (explanation.itemCount < itemsWithExec.length)
                    Text(
                      explanation.materials,
                      style: const TextStyle(
                        color: AppColors.inkMuted,
                        fontSize: 11,
                      ),
                    ),
                  Text(
                    explanation.text,
                    style: const TextStyle(
                      color: AppColors.inkSoft,
                      fontSize: 12,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  /// Box Lớn (Cữ vận hành / Box Điều trị) chứa toàn bộ các box nhỏ thành phần & box descrip bên trong
  Widget _buildMainMealBox({
    required OperationSchedule schedule,
    required List<OperationSchedule> allItems,
    FeedingMedicineMealGroup? mealGroup,
  }) {
    final isTreatment =
        schedule.isTreatment ||
        (mealGroup?.isTreatment ?? false) ||
        allItems.any((e) => e.isTreatment);
    final mealNumber =
        schedule.protocolItem?.mealNumber ?? mealGroup?.mealNumber;
    final belongsToMeal = mealGroup?.belongsToMeal ?? schedule.belongsToMeal;
    final headerTitle = belongsToMeal
        ? operationMealTitle(mealNumber: mealNumber, isTreatment: isTreatment)
        : allItems.length == 1
        ? materialCategoryLabel(schedule.operationType)
        : 'Xử lý môi trường';

    final (iconBg, iconFg) = isTreatment
        ? (AppColors.treatmentSurface, AppColors.treatmentAccent)
        : (_blueBg, _blueFg);

    // Khoảng giờ thực hiện của cữ (bao gồm deadline nếu có dueAtMinutes)
    final mealTimeStr = mealGroup?.timeRangeText ?? schedule.timeRangeText;
    final hasAnyOverdue = allItems.any((e) => e.isOverdue);
    final hasUnrecorded = allItems.any((e) => e.activatedAt != null);
    final materialCount = allItems
        .map((item) => item.protocolItemId)
        .toSet()
        .length;

    return Container(
      decoration: BoxDecoration(
        color: hasAnyOverdue ? OperationOverdueBadge.cardSurface : Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: hasAnyOverdue
            ? Border.all(
                color: OperationOverdueBadge.cardBorder.withValues(alpha: 0.85),
              )
            : null,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // 1. Header Box Lớn (Cố định, không thu gọn trong màn hình chi tiết)
            Row(
              children: <Widget>[
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: iconBg,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: AppSvgIcon(
                      AppSvgIconName.calendarDays,
                      color: iconFg,
                      size: 22,
                    ),
                  ),
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
                            headerTitle,
                            style: TextStyle(
                              fontSize: 15.5,
                              fontWeight: FontWeight.w800,
                              color: isTreatment
                                  ? const Color(0xFF9F1239)
                                  : AppColors.ink,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (isTreatment)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 7.5,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFBE6EA),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                'Phác đồ điều trị',
                                style: TextStyle(
                                  color: Color(0xFFD43B57),
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          if (hasUnrecorded) const OperationUnrecordedBadge(),
                          if (hasAnyOverdue)
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
                          Flexible(
                            child: Text(
                              '$mealTimeStr · $materialCount vật tư',
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.inkSoft,
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

            // 2. Nội dung bên trong Box Lớn (luôn hiển thị trong màn chi tiết)
            const SizedBox(height: 16),

            // Danh sách các box nhỏ thành phần theo thứ tự phác đồ (box nhỏ thức ăn, box nhỏ thuốc...)
            for (var i = 0; i < allItems.length; i++)
              _buildSubComponentBox(
                allItems[i],
                isLast: i == allItems.length - 1,
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _openExecution(
    List<OperationSchedule> rows, {
    required bool previewRoute,
  }) async {
    final saved = await OperationExecuteSheet.show(context, schedules: rows);
    if (!mounted || saved != true) return;
    AppNoticeService.success(context, 'Đã ghi nhận thực hiện.');
    if (_linkedDate case final date?) {
      ref.invalidate(
        operationSchedulesOnDateProvider((
          seasonId: widget.seasonId,
          date: date,
        )),
      );
    }
    await Future.wait([
      ref.read(operationListProvider(widget.seasonId).notifier).refresh(),
      if (!previewRoute)
        ref.read(operationDetailProvider(widget.scheduleId).notifier).refresh(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final canWrite = ref.watch(assignedSeasonCanWriteProvider(widget.seasonId));
    final date = _linkedDate;
    final selected = date == null
        ? null
        : ref.watch(operationDateFilterProvider);
    final linkedProvider =
        date != null &&
            selected?.toIso8601String().startsWith('${date}T') != true
        ? operationSchedulesOnDateProvider((
            seasonId: widget.seasonId,
            date: date,
          ))
        : null;
    final listAsync = linkedProvider == null
        ? ref.watch(operationListProvider(widget.seasonId))
        : ref.watch(linkedProvider);
    final preview = widget.mealGroup?.allSchedules
        .where((row) => row.id == widget.scheduleId && row.activatedAt != null)
        .firstOrNull;
    bool matchesTarget(OperationSchedule row) => preview == null
        ? row.id == widget.scheduleId
        : row.protocolItemId == preview.protocolItemId &&
              row.scheduledAt.isAtSameMomentAs(preview.scheduledAt);

    final list = listAsync.asData?.value;
    final fromList = list == null
        ? null
        : [...list.schedules, ...list.historicalSchedules];
    final effectiveMealGroup =
        (fromList == null
            ? null
            : FeedingMedicineMealGroup.group(
                    fromList,
                    includeEnvironmental: true,
                  )
                  .where((group) => group.allSchedules.any(matchesTarget))
                  .firstOrNull) ??
        (preview == null ? widget.mealGroup : null);
    // Preview IDs refer to prescription items. A saved occurrence has its own schedule ID.
    final AsyncValue<OperationSchedule?> detail = preview == null
        ? ref.watch(operationDetailProvider(widget.scheduleId))
        : listAsync.whenData((_) => fromList?.where(matchesTarget).firstOrNull);
    // A dashboard link needs the whole occurrence, even if another date is selected in the list.
    final state = date == null || detail.hasError
        ? detail
        : listAsync.when(
            data: (_) => detail,
            loading: () => const AsyncLoading<OperationSchedule?>(),
            error: (error, stack) =>
                AsyncError<OperationSchedule?>(error, stack),
          );

    void retry() {
      if (date != null && listAsync.hasError) {
        if (linkedProvider == null) {
          ref.read(operationListProvider(widget.seasonId).notifier).refresh();
        } else {
          ref.invalidate(linkedProvider);
        }
      }
      if (preview == null) {
        ref.read(operationDetailProvider(widget.scheduleId).notifier).refresh();
      } else {
        ref.read(operationListProvider(widget.seasonId).notifier).refresh();
      }
    }

    Widget withBack(Widget child) => Column(
      children: [
        PageHeaderBar(title: 'Chi tiết vận hành', onBack: context.pop),
        Expanded(child: child),
      ],
    );

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppGradientBackground(
        child: SafeArea(
          bottom: false,
          child: state.when(
            loading: () => withBack(
              const Center(child: CircularProgressIndicator(color: _blueFg)),
            ),
            error: (err, _) =>
                withBack(AppErrorState(error: err, onRetry: retry)),
            data: (schedule) {
              if (schedule == null) {
                return withBack(
                  const Center(
                    child: Text('Cữ này không còn khả dụng để ghi bổ sung.'),
                  ),
                );
              }
              // Toàn bộ các thành phần trong cữ (thay schedule mới nhất từ API detail vào danh sách)
              final allItems = effectiveMealGroup != null
                  ? effectiveMealGroup.allSchedules
                        .map((s) => s.id == schedule.id ? schedule : s)
                        .toList()
                  : <OperationSchedule>[schedule];

              final plannedItems = allItems
                  .where((s) => s.status == OperationStatus.planned)
                  .toList(growable: false);
              final completedItems = allItems
                  .where(
                    (s) =>
                        s.status == OperationStatus.completed &&
                        s.execution != null,
                  )
                  .toList(growable: false);
              final hasAnyPlanned = plannedItems.isNotEmpty;
              final scheduledItems = plannedItems
                  .where((item) => item.activatedAt == null)
                  .toList();
              final recordTogether =
                  scheduledItems.isNotEmpty &&
                  scheduledItems.length <= _batchLimit;
              final supplements = plannedItems
                  .where((item) => item.activatedAt != null)
                  .toList();
              final individualItems = recordTogether
                  ? const <OperationSchedule>[]
                  : scheduledItems;
              final displayStatus = hasAnyPlanned
                  ? OperationStatus.planned
                  : (allItems.every(
                          (s) => s.status == OperationStatus.completed,
                        )
                        ? OperationStatus.completed
                        : (allItems.every(
                                (s) => s.status == OperationStatus.cancelled,
                              )
                              ? OperationStatus.cancelled
                              : schedule.status));
              final (statusDot, statusText, statusBg) = _statusVisuals(
                displayStatus,
              );

              return CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: <Widget>[
                  // Top App Bar
                  StickyPageHeader(
                    title: 'Chi tiết vận hành',
                    subtitle: _formatLocation(schedule, list),
                    onBack: context.pop,
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: statusBg,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: statusDot,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Flexible(
                            child: Text(
                              displayStatus.displayName,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: statusText,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 36),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          // 1. BOX LỚN: Bao trùm toàn bộ các thành phần trong cữ
                          _buildMainMealBox(
                            schedule: schedule,
                            allItems: allItems,
                            mealGroup: effectiveMealGroup,
                          ),

                          // 1b. Card tóm tắt đã ghi nhận thực hiện (nếu có mục đã hoàn thành)
                          if (completedItems.isNotEmpty) ...<Widget>[
                            const SizedBox(height: 14),
                            _buildCompletedSummaryCard(completedItems),
                          ],

                          if (canWrite && recordTogether) ...[
                            const SizedBox(height: 14),
                            GradientButton(
                              label:
                                  scheduledItems.every(
                                    (item) => item.canExecute,
                                  )
                                  ? 'Ghi nhận thực hiện'
                                  : 'Chưa đến giờ thực hiện',
                              height: 48,
                              icon: Icons.check_rounded,
                              onPressed:
                                  scheduledItems.every(
                                    (item) => item.canExecute,
                                  )
                                  ? () => _openExecution(
                                      scheduledItems,
                                      previewRoute: preview != null,
                                    )
                                  : null,
                            ),
                          ],
                          if (canWrite && supplements.isNotEmpty) ...[
                            const SizedBox(height: 12),
                            if (supplements.length > _batchLimit)
                              const Text('Mỗi lần ghi nhận tối đa 20 vật tư.'),
                            GradientButton(
                              label: 'Ghi nhận bổ sung',
                              height: 48,
                              icon: Icons.history_rounded,
                              onPressed: () => _openExecution(
                                supplements.take(_batchLimit).toList(),
                                previewRoute: preview != null,
                              ),
                            ),
                          ],
                          if (canWrite)
                            for (final item in individualItems) ...[
                              const SizedBox(height: 12),
                              GradientButton(
                                label: 'Ghi nhận ${item.productName}',
                                height: 48,
                                icon: Icons.history_rounded,
                                onPressed: item.canExecute
                                    ? () => _openExecution([
                                        item,
                                      ], previewRoute: preview != null)
                                    : null,
                              ),
                            ],
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
