import 'package:flutter/material.dart';
import 'package:smartshrimp_app/features/assigned_season/presentation/view_models/assigned_season_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/widgets/app_gradient_background.dart';
import 'package:smartshrimp_app/core/widgets/app_notice.dart';
import 'package:smartshrimp_app/core/widgets/app_svg_icon.dart';
import 'package:smartshrimp_app/core/widgets/gradient_button.dart';
import 'package:smartshrimp_app/core/widgets/sticky_page_header.dart';
import 'package:smartshrimp_app/features/operation/domain/entities/operation_models.dart';
import 'package:smartshrimp_app/features/operation/presentation/view_models/operation_controller.dart';
import 'package:smartshrimp_app/features/operation/presentation/widgets/operation_execute_item_card.dart';
import 'package:smartshrimp_app/features/operation/presentation/widgets/operation_execute_sheet.dart';
import 'package:smartshrimp_app/features/operation/presentation/widgets/operation_meal_execute_sheet.dart';
import 'package:smartshrimp_app/features/operation/presentation/widgets/operation_product_thumbnail.dart';
import 'package:smartshrimp_app/features/operation/presentation/widgets/operation_type_badge.dart';

class OperationDetailPage extends ConsumerStatefulWidget {
  const OperationDetailPage({
    required this.seasonId,
    required this.scheduleId,
    this.mealGroup,
    super.key,
  });

  final String seasonId;
  final String scheduleId;
  final FeedingMedicineMealGroup? mealGroup;

  @override
  ConsumerState<OperationDetailPage> createState() =>
      _OperationDetailPageState();
}

class _OperationDetailPageState extends ConsumerState<OperationDetailPage> {
  static const Color _blueBg = Color(0xFFDEEDFD);
  static const Color _blueFg = Color(0xFF1D7AD6);

  final Set<String> _expandedScheduleIds = <String>{};

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

  String _formatLocation(OperationSchedule schedule) {
    final pond = schedule.pondName?.trim();
    final season = schedule.seasonName?.trim();

    final formattedSeason = season != null && season.isNotEmpty
        ? (season.toLowerCase().startsWith('vụ') ? season : 'Vụ $season')
        : null;

    final parts = <String>[
      if (pond != null && pond.isNotEmpty) pond,
      ?formattedSeason,
    ];

    if (parts.isNotEmpty) {
      return parts.join(' · ');
    }
    return 'Vụ nuôi: ${widget.seasonId}';
  }

  String _formatCompactNumber(double val) {
    if (val == val.roundToDouble()) {
      return val.toInt().toString();
    }
    return val.toStringAsFixed(1);
  }

  String _formatBasisQuantity(double val) {
    if (val == val.roundToDouble()) {
      final intVal = val.toInt();
      if (intVal >= 1000) {
        final str = intVal.toString();
        final buffer = StringBuffer();
        for (var i = 0; i < str.length; i++) {
          if (i > 0 && (str.length - i) % 3 == 0) {
            buffer.write('.');
          }
          buffer.write(str[i]);
        }
        return buffer.toString();
      }
      return intVal.toString();
    }
    return val.toStringAsFixed(1);
  }

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
  }) => Expanded(
    child: Container(
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
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w800,
              color: valueColor ?? AppColors.ink,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          if (sub != null) ...<Widget>[
            const SizedBox(height: 2),
            Text(
              sub,
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: subColor != null
                    ? FontWeight.w700
                    : FontWeight.w500,
                color: subColor ?? AppColors.inkMuted,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    ),
  );

  /// Box nhỏ cho từng thành phần bên trong Box Lớn (Thức ăn, Thuốc,...)
  Widget _buildSubComponentBox(OperationSchedule item, {bool isLast = false}) {
    final isExpanded = _expandedScheduleIds.contains(item.id);
    final visuals = OperationTypeVisuals.of(item.operationType);

    final isMedicine = item.operationType == OperationType.medicine;

    final pillBg = visuals.bg;
    final pillFg = visuals.fg;

    final itemTimeStr = item.timeRangeText;
    final quantityStr = '${item.plannedQuantity} ${item.unit.toLowerCase()}';
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

    final actualQuantitySub = isCompleted && item.execution != null
        ? 'Thực tế: ${item.execution!.actualQuantity} ${item.unit.toLowerCase()}'
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
          ? '${_formatBasisQuantity(item.basisQuantity!)} $basisUnit'
          : _formatBasisQuantity(item.basisQuantity!);
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
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
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              OperationTypeBadge(
                                type: item.operationType,
                                compact: true,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item.productName,
                                style: const TextStyle(
                                  fontSize: 13.5,
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
                        // Pill số lượng
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8.5,
                            vertical: 3.5,
                          ),
                          decoration: BoxDecoration(
                            color: pillBg,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            quantityStr,
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w800,
                              color: pillFg,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        // Icon mũi tên sổ xuống / đóng lên
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
                      padding: const EdgeInsets.only(left: 48),
                      child: Row(
                        children: <Widget>[
                          const Icon(
                            Icons.access_time_rounded,
                            size: 12.5,
                            color: AppColors.inkMuted,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '$itemTimeStr  ·  $quantityStr',
                            style: const TextStyle(
                              fontSize: 11.5,
                              color: AppColors.inkMuted,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
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

                    // Lưới thông số 2x2 chuẩn theo DB
                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          _buildParamBox(
                            label: 'Giờ dự kiến',
                            value: itemTimeStr,
                          ),
                          const SizedBox(width: 8),
                          _buildParamBox(
                            label: quantityLabel,
                            value: quantityStr,
                            valueColor: _blueFg,
                            sub: actualQuantitySub,
                            subColor: const Color(0xFF0D9488),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          _buildParamBox(
                            label: 'Cách tính liều',
                            value: item.doseBasisDescription,
                          ),
                          const SizedBox(width: 8),
                          _buildParamBox(
                            label: fourthLabel,
                            value: fourthValue,
                          ),
                        ],
                      ),
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

                    // Lý do chênh lệch (nếu có)
                    if (isCompleted &&
                        item.execution?.varianceReason != null &&
                        item.execution!.varianceReason!.isNotEmpty) ...<Widget>[
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFDE8EC),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'Lý do chênh lệch: ${item.execution!.varianceReason}',
                          style: const TextStyle(
                            fontSize: 11.5,
                            color: AppColors.error,
                            fontWeight: FontWeight.w600,
                          ),
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

  /// Card tóm tắt "✓ Đã ghi nhận thực hiện" (thiết kế cao cấp, đồng bộ, hiện đại)
  /// Card tóm tắt "✓ Đã ghi nhận thực hiện" (thiết kế tinh tế, gọn gàng, không lặp lại component)
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

    final reasons = itemsWithExec
        .where((s) => (s.execution?.varianceReason?.trim().isNotEmpty ?? false))
        .toList(growable: false);

    final notes = itemsWithExec
        .where((s) => (s.execution?.note?.trim().isNotEmpty ?? false))
        .toList(growable: false);

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
          // Header: Icon tròn tick xanh + Tiêu đề + Thời gian + Badge đúng giờ/trễ hạn
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
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
                  children: <Widget>[
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
                      children: <Widget>[
                        const Icon(
                          Icons.access_time_rounded,
                          size: 11.5,
                          color: AppColors.inkMuted,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Thực hiện lúc ${_formatExecutedAt(latestExecutedAt)}',
                          style: const TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w500,
                            color: AppColors.inkMuted,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (hasDeadline)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.5,
                    vertical: 3.5,
                  ),
                  decoration: BoxDecoration(
                    color: isLate
                        ? OperationOverdueBadge.bg
                        : const Color(0xFFE6FFFA),
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
                    children: <Widget>[
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
                      Text(
                        isLate ? 'Trễ hạn' : 'Đúng giờ',
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                          color: isLate
                              ? OperationOverdueBadge.fg
                              : const Color(0xFF047857),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),

          const SizedBox(height: 10),
          Divider(
            height: 1,
            color: AppColors.line.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 10),

          // Danh sách số lượng thực tế ghi nhận (gọn gàng, tinh tế, không lặp lại ảnh/badge)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 9,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFFE2E8F0),
                width: 0.8,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                for (var i = 0; i < itemsWithExec.length; i++) ...<Widget>[
                  Builder(
                    builder: (_) {
                      final item = itemsWithExec[i];
                      final unit = item.unit.toLowerCase();
                      final actualVal = item.execution!.actualQuantity;
                      final actualStr = formatOperationCompact(
                        actualVal,
                        maxDecimals: 3,
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
                            Text(
                              '$actualStr $unit',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF0D9488),
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

          // Lý do chênh lệch (nếu có - đóng khung màu hồng nhạt viền mềm trang nhã)
          if (reasons.isNotEmpty) ...<Widget>[
            const SizedBox(height: 8),
            for (var i = 0; i < reasons.length; i++) ...<Widget>[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF1F2),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: const Color(0xFFFECDD3),
                    width: 0.8,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.only(top: 1.5),
                      child: Icon(
                        Icons.info_outline_rounded,
                        size: 14,
                        color: Color(0xFFE11D48),
                      ),
                    ),
                    const SizedBox(width: 7),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF9F1239),
                            height: 1.35,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: reasons.length == 1
                                  ? 'Lý do chênh lệch: '
                                  : 'Lý do chênh lệch (${reasons[i].productName}): ',
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            TextSpan(
                              text: reasons[i].execution!.varianceReason!.trim(),
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (i < reasons.length - 1) const SizedBox(height: 5),
            ],
          ],

          // Ghi chú đính kèm (nếu có - đóng khung xám nhạt đồng bộ)
          if (notes.isNotEmpty) ...<Widget>[
            const SizedBox(height: 6),
            for (var i = 0; i < notes.length; i++) ...<Widget>[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 7.5,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.only(top: 1.5),
                      child: Icon(
                        Icons.notes_rounded,
                        size: 14,
                        color: AppColors.inkMuted,
                      ),
                    ),
                    const SizedBox(width: 7),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.inkSoft,
                            height: 1.35,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: notes.length == 1
                                  ? 'Ghi chú: '
                                  : 'Ghi chú (${notes[i].productName}): ',
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            TextSpan(
                              text: notes[i].execution!.note!.trim(),
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (i < notes.length - 1) const SizedBox(height: 5),
            ],
          ],
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
    final isTreatment = schedule.isTreatment ||
        (mealGroup?.isTreatment ?? false) ||
        allItems.any((e) => e.isTreatment);
    final mealNumber =
        schedule.protocolItem?.mealNumber ?? mealGroup?.mealNumber;
    final headerTitle = isTreatment
        ? 'Điều trị'
        : (mealNumber != null
            ? 'Cữ $mealNumber'
            : schedule.operationType.displayName);

    final (iconBg, iconFg, svgName) = isTreatment
        ? (
            const Color(0xFFFBE6EA),
            const Color(0xFFD43B57),
            AppSvgIconName.medicine,
          )
        : (
            _blueBg,
            _blueFg,
            AppSvgIconName.calendarDays,
          );

    // Khoảng giờ thực hiện của cữ (bao gồm deadline nếu có dueAtMinutes)
    final mealTimeStr = mealGroup?.timeRangeText ?? schedule.timeRangeText;
    final hasAnyOverdue = allItems.any((e) => e.isOverdue);

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
                      svgName,
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
                          Text(
                            '$mealTimeStr · ${allItems.length} thành phần',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.inkSoft,
                              fontWeight: FontWeight.w600,
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

  @override
  Widget build(BuildContext context) {
    final canWrite = ref.watch(assignedSeasonCanWriteProvider(widget.seasonId));
    final state = ref.watch(operationDetailProvider(widget.scheduleId));

    // Luôn ưu tiên lấy cữ mới nhất từ operationListProvider để phản ánh đúng trạng thái sau khi ghi nhận,
    // chỉ fallback về widget.mealGroup (snapshot từ route) khi danh sách chưa kịp tải.
    final listAsync = ref.watch(operationListProvider(widget.seasonId));
    FeedingMedicineMealGroup? effectiveMealGroup;
    if (listAsync.hasValue) {
      final allMealGroups = listAsync.value!.mealGroups;
      for (final g in allMealGroups) {
        if (g.allSchedules.any((s) => s.id == widget.scheduleId)) {
          effectiveMealGroup = g;
          break;
        }
      }
    }
    effectiveMealGroup ??= widget.mealGroup;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppGradientBackground(
        child: SafeArea(
          bottom: false,
          child: state.when(
            loading: () =>
                const Center(child: CircularProgressIndicator(color: _blueFg)),
            error: (err, _) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Lỗi: $err',
                    style: const TextStyle(color: AppColors.error),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => ref
                        .read(
                          operationDetailProvider(widget.scheduleId).notifier,
                        )
                        .refresh(),
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            ),
            data: (schedule) {
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
                    subtitle: _formatLocation(schedule),
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
                          Text(
                            displayStatus.displayName,
                            style: TextStyle(
                              color: statusText,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
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

                          // 2. Action button ghi nhận cữ (chỉ cho phép khi đã đến giờ dự kiến)
                          if (hasAnyPlanned && canWrite) ...<Widget>[
                            const SizedBox(height: 14),
                            Builder(
                              builder: (_) {
                                final isMultiPlanned = plannedItems.length > 1;
                                final executableMealGroup =
                                    isMultiPlanned && effectiveMealGroup != null
                                    ? FeedingMedicineMealGroup(
                                        key: effectiveMealGroup.key,
                                        mealNumber:
                                            effectiveMealGroup.mealNumber,
                                        time: effectiveMealGroup.time,
                                        scheduledAt:
                                            effectiveMealGroup.scheduledAt,
                                        feedings: plannedItems
                                            .where(
                                              (s) =>
                                                  s.operationType ==
                                                  OperationType.feeding,
                                            )
                                            .toList(growable: false),
                                        medicines: plannedItems
                                            .where(
                                              (s) =>
                                                  s.operationType ==
                                                  OperationType.medicine,
                                            )
                                            .toList(growable: false),
                                      )
                                    : null;
                                final singleTarget = plannedItems.first;
                                final isBeforeScheduled =
                                    executableMealGroup != null
                                    ? executableMealGroup.isBeforeScheduled
                                    : singleTarget.isBeforeScheduled;
                                final insufficientItems = plannedItems
                                    .where(
                                      (s) => s.isStockInsufficientForPlanned,
                                    )
                                    .toList(growable: false);
                                final hasInsufficientStock =
                                    insufficientItems.isNotEmpty;
                                final canTap =
                                    !isBeforeScheduled && !hasInsufficientStock;

                                final shortageDetails = insufficientItems
                                    .map((s) {
                                      final unit = s.unit.toLowerCase();
                                      final stockText = formatOperationCompact(
                                        s.availableStock ?? 0,
                                        maxDecimals: 3,
                                      );
                                      final needText = formatOperationCompact(
                                        s.plannedQuantity,
                                        maxDecimals: 3,
                                      );
                                      return '${s.productName} (còn $stockText $unit, cần $needText $unit)';
                                    })
                                    .join('; ');

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    if (hasInsufficientStock) ...<Widget>[
                                      AppFormMessageBanner(
                                        level: AppNoticeLevel.danger,
                                        title: 'Không đủ vật tư trong kho',
                                        message:
                                            '$shortageDetails. Vui lòng nhập thêm kho trước khi ghi nhận.',
                                      ),
                                      const SizedBox(height: 12),
                                    ],
                                    GradientButton(
                                      label: hasInsufficientStock
                                          ? 'Không đủ vật tư trong kho'
                                          : (isBeforeScheduled
                                                ? 'Chưa đến giờ thực hiện'
                                                : 'Ghi nhận thực hiện'),
                                      compact: true,
                                      height: 48,
                                      borderRadius: 16,
                                      leading: Icon(
                                        hasInsufficientStock
                                            ? Icons.inventory_2_outlined
                                            : (isBeforeScheduled
                                                  ? Icons.schedule_rounded
                                                  : Icons.check_rounded),
                                        color: Colors.white,
                                        size: 19,
                                      ),
                                      onPressed: canTap
                                          ? () {
                                              if (executableMealGroup != null) {
                                                OperationMealExecuteSheet.show(
                                                  context,
                                                  group: executableMealGroup,
                                                  onSuccess: () {
                                                    ref
                                                        .read(
                                                          operationDetailProvider(
                                                            widget.scheduleId,
                                                          ).notifier,
                                                        )
                                                        .refresh();
                                                    ref
                                                        .read(
                                                          operationListProvider(
                                                            widget.seasonId,
                                                          ).notifier,
                                                        )
                                                        .refresh();
                                                  },
                                                );
                                              } else {
                                                OperationExecuteSheet.show(
                                                  context,
                                                  schedule: singleTarget,
                                                  onSuccess: () {
                                                    ref
                                                        .read(
                                                          operationDetailProvider(
                                                            widget.scheduleId,
                                                          ).notifier,
                                                        )
                                                        .refresh();
                                                    ref
                                                        .read(
                                                          operationListProvider(
                                                            widget.seasonId,
                                                          ).notifier,
                                                        )
                                                        .refresh();
                                                  },
                                                );
                                              }
                                            }
                                          : null,
                                    ),
                                  ],
                                );
                              },
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
