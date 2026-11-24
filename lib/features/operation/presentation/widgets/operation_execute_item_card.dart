import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/widgets/app_notice.dart';
import 'package:smartshrimp_app/features/operation/domain/entities/operation_models.dart';
import 'package:smartshrimp_app/features/operation/presentation/widgets/operation_product_thumbnail.dart';
import 'package:smartshrimp_app/features/operation/presentation/widgets/operation_type_badge.dart';

/// Parse số thực hỗ trợ cả dấu `.` và dấu `,` trên bàn phím tiếng Việt.
double? parseOperationQuantity(String raw) {
  final normalized = raw.trim().replaceAll(',', '.');
  if (!RegExp(r'^(?:\d{1,11}(?:\.\d{0,9})?|\.\d{1,9})$').hasMatch(normalized)) {
    return null;
  }
  final parsed = double.tryParse(normalized);
  if (parsed == null || !parsed.isFinite) return null;
  return parsed;
}

/// Định dạng số gọn đẹp, bỏ số 0 thừa ở phần thập phân.
String formatOperationCompact(double value, {int maxDecimals = 2}) {
  if (!value.isFinite) return '0';
  final formatted = value.toStringAsFixed(maxDecimals);
  if (!formatted.contains('.') || formatted.contains('e')) return formatted;
  return formatted.replaceFirst(RegExp(r'\.?0+$'), '');
}

/// Preview the same quantity threshold used when saving an execution.
@immutable
class OperationVarianceEvaluation {
  const OperationVarianceEvaluation({
    required this.planned,
    required this.actual,
    required this.allowedPct,
  });

  final double planned;
  final double? actual;
  final double allowedPct;

  static const _quantityDecimals = 9;
  static const _percentageDecimals = 2;

  static BigInt _decimalUnits(double value, int decimals) {
    final [mantissa, exponent] = value.toStringAsExponential().split('e');
    final fractionalDigits = mantissa.contains('.') ? mantissa.length - 2 : 0;
    final digits = BigInt.parse(mantissa.replaceFirst('.', ''));
    final shift = decimals + int.parse(exponent) - fractionalDigits;
    final factor = BigInt.from(10).pow(shift.abs());
    return shift < 0 ? digits ~/ factor : digits * factor;
  }

  double get minAllowed {
    final raw = planned * (1 - allowedPct / 100);
    return raw < 0 ? 0 : raw;
  }

  double get maxAllowed => planned * (1 + allowedPct / 100);

  bool get isValidPositive => actual != null && actual!.isFinite && actual! > 0;

  double get variancePct {
    if (!isValidPositive || planned <= 0) return 0;
    return ((actual! - planned).abs() / planned) * 100;
  }

  bool get exceedsAllowed {
    if (!hasAnyDeviation ||
        !allowedPct.isFinite ||
        allowedPct < 0 ||
        allowedPct > 100) {
      return false;
    }
    final plannedUnits = _decimalUnits(planned, _quantityDecimals);
    final difference =
        (_decimalUnits(actual!, _quantityDecimals) - plannedUnits).abs();
    final thresholdUnits = _decimalUnits(allowedPct, _percentageDecimals);
    // Compare before division so an exact boundary stays within tolerance.
    return difference * BigInt.from(10000) > plannedUnits * thresholdUnits;
  }

  /// Distinguish an in-range adjustment from the threshold that requires a reason.
  bool get hasAnyDeviation =>
      isValidPositive && planned.isFinite && planned > 0 && actual != planned;

  bool get isDeviatedWithinAllowed => hasAnyDeviation && !exceedsAllowed;

  String get varianceLabel {
    final sign = actual! > planned ? '+' : '−';
    final pct = variancePct;
    final formatted = formatOperationCompact(pct, maxDecimals: 2);
    return formatted == '0'
        ? 'Chênh lệch $sign<0,01%'
        : 'Chênh lệch $sign$formatted%';
  }

  String warningMessage(String unit) {
    final unitSuffix = unit.trim().isEmpty ? '' : ' ${unit.trim()}';
    final actualText =
        '${formatOperationCompact(actual!, maxDecimals: _quantityDecimals)}$unitSuffix';
    final plannedText =
        '${formatOperationCompact(planned, maxDecimals: _quantityDecimals)}$unitSuffix';
    return 'Lượng nhập $actualText, kế hoạch $plannedText. Cần nhập lý do khi lệch quá ±${formatOperationCompact(allowedPct)}%.';
  }
}

/// Section nhập liệu cho từng vật tư theo phong cách thoáng, tối giản
/// đồng bộ với modal "Ghi nhận sức khỏe tôm".
class OperationExecuteItemCard extends StatelessWidget {
  const OperationExecuteItemCard({
    required this.schedule,
    required this.quantityController,
    required this.varianceReasonController,
    this.showDivider = false,
    this.checkCurrentStock = true,
    super.key,
  });

  final OperationSchedule schedule;
  final TextEditingController quantityController;
  final TextEditingController varianceReasonController;
  final bool showDivider;
  final bool checkCurrentStock;

  static const Color _borderColor = Color(0xFFDDE3EA);
  static const Color _focusColor = Color(0xFF1D7AD6);

  OutlineInputBorder _inputBorder(Color color, {double width = 1}) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: color, width: width),
      );

  @override
  Widget build(BuildContext context) {
    final visuals = OperationTypeVisuals.of(schedule.operationType);
    final allowedPct =
        schedule.protocolItem?.protocol?.allowedVariancePct ?? 10.0;
    final unit = schedule.unit.toLowerCase();

    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: quantityController,
      builder: (_, qtyValue, _) {
        final actual = parseOperationQuantity(qtyValue.text);
        final eval = OperationVarianceEvaluation(
          planned: schedule.plannedQuantity,
          actual: actual,
          allowedPct: allowedPct,
        );
        final isStockInsufficient =
            checkCurrentStock &&
            (eval.isValidPositive
                ? schedule.isStockInsufficientFor(eval.actual!)
                : schedule.isStockInsufficientForPlanned);
        final dangerVisual = appNoticeVisualFor(AppNoticeLevel.danger);
        final hasAlertBorder = eval.exceedsAllowed || isStockInsufficient;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // 1. Ảnh vật tư + Pill loại + Tên vật tư
            Row(
              children: <Widget>[
                OperationProductThumbnail(
                  imageUrl: schedule.productImageUrl,
                  fallbackIcon: visuals.icon,
                  fallbackBg: visuals.bg,
                  fallbackFg: visuals.fg,
                  size: 38,
                  borderRadius: 10,
                  iconSize: 19,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      OperationTypeBadge(
                        type: schedule.operationType,
                        compact: true,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        schedule.productName,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.ink,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // 2. Nhãn + đơn vị bên phải & sub-label kế hoạch / khoảng cho phép
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text(
                  'Lượng thực tế',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.ink,
                  ),
                ),
                Text(
                  unit,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.inkMuted,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              'Kế hoạch: ${formatOperationCompact(schedule.plannedQuantity, maxDecimals: 3)} $unit · Cho phép: ${formatOperationCompact(eval.minAllowed, maxDecimals: 3)} – ${formatOperationCompact(eval.maxAllowed, maxDecimals: 3)} $unit (±${formatOperationCompact(allowedPct)}%)',
              style: const TextStyle(fontSize: 11, color: AppColors.inkMuted),
            ),
            const SizedBox(height: 6),

            // 3. Ô nhập số lượng kiểu tối giản giống Ghi nhận sức khỏe tôm
            TextFormField(
              controller: quantityController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
              ],
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.ink,
              ),
              decoration: InputDecoration(
                hintText: formatOperationCompact(
                  schedule.plannedQuantity,
                  maxDecimals: 3,
                ),
                hintStyle: const TextStyle(
                  color: Color(0xFF94A3B8),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                border: _inputBorder(
                  hasAlertBorder ? dangerVisual.border : _borderColor,
                ),
                enabledBorder: _inputBorder(
                  hasAlertBorder ? dangerVisual.border : _borderColor,
                ),
                focusedBorder: _inputBorder(
                  hasAlertBorder ? dangerVisual.foreground : _focusColor,
                  width: 1.5,
                ),
                errorBorder: _inputBorder(dangerVisual.foreground),
                focusedErrorBorder: _inputBorder(
                  dangerVisual.foreground,
                  width: 1.5,
                ),
              ),
              validator: (raw) {
                final parsed = parseOperationQuantity(raw ?? '');
                if (parsed == null || parsed <= 0) {
                  return 'Nhập lượng lớn hơn 0, tối đa 9 chữ số thập phân.';
                }
                return null;
              },
            ),

            // 4. Thông báo trong khoảng cho phép (nếu lệch nhẹ và kho vẫn đủ)
            if (eval.isDeviatedWithinAllowed &&
                !isStockInsufficient) ...<Widget>[
              const SizedBox(height: 6),
              Row(
                children: <Widget>[
                  const Icon(
                    Icons.check_circle_outline_rounded,
                    size: 14,
                    color: Color(0xFF0C857A),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      eval.varianceLabel,
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0C857A),
                      ),
                    ),
                  ),
                ],
              ),
            ],

            // 4b. Box cảnh báo đỏ khi tồn kho không đủ cho lượng nhập
            if (isStockInsufficient) ...<Widget>[
              const SizedBox(height: 10),
              AppFormMessageBanner(
                level: AppNoticeLevel.danger,
                title: 'Không đủ vật tư trong kho',
                message:
                    'Tồn kho hiện tại của ${schedule.productName} chỉ còn ${formatOperationCompact(schedule.availableStock ?? 0, maxDecimals: 3)} $unit, không đủ cho lượng ${formatOperationCompact(eval.actual ?? schedule.plannedQuantity, maxDecimals: 3)} $unit. Không thể ghi nhận.',
              ),
            ],

            if (eval.exceedsAllowed) ...<Widget>[
              const SizedBox(height: 10),
              AppFormMessageBanner(
                level: AppNoticeLevel.danger,
                title: eval.varianceLabel,
                message: eval.warningMessage(unit),
              ),
            ],

            if (eval.exceedsAllowed && !isStockInsufficient) ...<Widget>[
              const SizedBox(height: 10),
              const Text(
                'Lý do chênh lệch *',
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.ink,
                ),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: varianceReasonController,
                maxLength: 500,
                maxLines: 2,
                minLines: 2,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.ink,
                ),
                decoration: InputDecoration(
                  hintText: 'Nhập lý do chênh lệch để tiếp tục ghi nhận...',
                  hintStyle: const TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 13.5,
                    fontWeight: FontWeight.w400,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 11,
                  ),
                  border: _inputBorder(_borderColor),
                  enabledBorder: _inputBorder(_borderColor),
                  focusedBorder: _inputBorder(_focusColor, width: 1.5),
                  errorBorder: _inputBorder(dangerVisual.foreground),
                  focusedErrorBorder: _inputBorder(
                    dangerVisual.foreground,
                    width: 1.5,
                  ),
                ),
                validator: (raw) {
                  if (raw == null || raw.trim().isEmpty) {
                    return 'Bắt buộc nhập lý do chênh lệch';
                  }
                  return null;
                },
              ),
            ],

            if (showDivider) ...<Widget>[
              const SizedBox(height: 16),
              const Divider(height: 1, color: Color(0xFFEEF1F6)),
              const SizedBox(height: 16),
            ],
          ],
        );
      },
    );
  }
}
