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
  if (normalized.isEmpty) return null;
  final parsed = double.tryParse(normalized);
  if (parsed == null || !parsed.isFinite) return null;
  return parsed;
}

/// Định dạng số gọn đẹp, bỏ số 0 thừa ở phần thập phân.
String formatOperationCompact(double value, {int maxDecimals = 2}) {
  if (!value.isFinite) return '0';
  final rounded = double.parse(value.toStringAsFixed(maxDecimals));
  if (rounded == rounded.roundToDouble()) {
    return rounded.toInt().toString();
  }
  return rounded
      .toStringAsFixed(maxDecimals)
      .replaceFirst(RegExp(r'0+$'), '')
      .replaceFirst(RegExp(r'\.$'), '');
}

/// Định dạng tỷ lệ gấp bao nhiêu lần dễ đọc (vd: 2, 1.5, 0.25, < 0.01).
String formatOperationRatio(double ratio) {
  if (!ratio.isFinite || ratio <= 0) return '0';
  if (ratio < 0.01) return '< 0.01';
  if (ratio >= 10) return formatOperationCompact(ratio, maxDecimals: 1);
  return formatOperationCompact(ratio, maxDecimals: 2);
}

/// Format thời điểm ghi nhận đồng bộ phong cách "09:18 • Hôm nay (18/11)".
String formatOperationRecordedTime(DateTime dt) {
  final local = dt.toLocal();
  final hh = local.hour.toString().padLeft(2, '0');
  final mm = local.minute.toString().padLeft(2, '0');
  final dd = local.day.toString().padLeft(2, '0');
  final mo = local.month.toString().padLeft(2, '0');
  return '$hh:$mm • Hôm nay ($dd/$mo)';
}

/// Kết quả kiểm tra sai số cho một mục vật tư khi ghi nhận vận hành.
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

  static const double _epsilon = 1e-9;

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

  bool get isAboveAllowed =>
      isValidPositive && planned > 0 && actual! > maxAllowed + _epsilon;

  bool get isBelowAllowed =>
      isValidPositive && planned > 0 && actual! < minAllowed - _epsilon;

  bool get exceedsAllowed => isAboveAllowed || isBelowAllowed;

  /// Theo BR-57: mọi chênh lệch khác 0 (kể cả trong ngưỡng) đều cần lý do.
  bool get hasAnyDeviation =>
      isValidPositive && planned > 0 && variancePct > _epsilon;

  bool get isDeviatedWithinAllowed =>
      hasAnyDeviation && !exceedsAllowed;

  double get ratio =>
      isValidPositive && planned > 0 ? actual! / planned : 1.0;

  double get inverseRatio =>
      isValidPositive && planned > 0 ? planned / actual! : 1.0;

  String get warningTitle => isAboveAllowed
      ? 'Vượt khoảng sai số cho phép (±${formatOperationCompact(allowedPct)}%)'
      : 'Thấp hơn khoảng sai số cho phép (±${formatOperationCompact(allowedPct)}%)';

  String warningMessage(String unit) {
    final unitSuffix = unit.trim().isEmpty ? '' : ' ${unit.trim()}';
    final actualText =
        '${formatOperationCompact(actual!, maxDecimals: 3)}$unitSuffix';
    final plannedText =
        '${formatOperationCompact(planned, maxDecimals: 3)}$unitSuffix';
    final pctText = formatOperationCompact(variancePct, maxDecimals: 1);

    if (isAboveAllowed) {
      return 'Lượng nhập ($actualText) cao gấp ${formatOperationRatio(ratio)} lần so với lượng ban đầu ($plannedText, lệch +$pctText%). Bắt buộc nhập lý do mới được ghi nhận.';
    }
    return 'Lượng nhập ($actualText) chỉ bằng ${formatOperationRatio(ratio)} lần (nhỏ hơn ${formatOperationRatio(inverseRatio)} lần, lệch -$pctText%) so với lượng ban đầu ($plannedText). Bắt buộc nhập lý do mới được ghi nhận.';
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
    super.key,
  });

  final OperationSchedule schedule;
  final TextEditingController quantityController;
  final TextEditingController varianceReasonController;
  final bool showDivider;

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
        final isStockInsufficient = eval.isValidPositive
            ? schedule.isStockInsufficientFor(eval.actual!)
            : schedule.isStockInsufficientForPlanned;
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
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.inkMuted,
              ),
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
                  return 'Vui lòng nhập số lượng lớn hơn 0';
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
                      'Chênh lệch ${eval.actual! > eval.planned ? '+' : '-'}${formatOperationCompact(eval.variancePct, maxDecimals: 1)}% — trong khoảng cho phép (vẫn cần nhập lý do theo quy định).',
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

            // 5. Box cảnh báo đỏ chuẩn AppFormMessageBanner khi vượt khoảng sai số
            if (eval.exceedsAllowed && !isStockInsufficient) ...<Widget>[
              const SizedBox(height: 10),
              AppFormMessageBanner(
                level: AppNoticeLevel.danger,
                title: eval.warningTitle,
                message: eval.warningMessage(unit),
              ),
            ],

            // 6. Ô Lý do chênh lệch bắt buộc cho mọi chênh lệch khác 0 (BR-57)
            if (eval.hasAnyDeviation && !isStockInsufficient) ...<Widget>[
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
                  if (eval.hasAnyDeviation &&
                      (raw == null || raw.trim().isEmpty)) {
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

/// Header + thanh Thời điểm ghi nhận đồng bộ phong cách "Ghi nhận sức khỏe tôm".
class OperationExecuteSheetHeader extends StatelessWidget {
  const OperationExecuteSheetHeader({
    required this.title,
    required this.recordedAt,
    required this.onClose,
    super.key,
  });

  final String title;
  final DateTime recordedAt;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.ink,
              ),
            ),
          ),
          const SizedBox(width: 8),
          InkWell(
            onTap: onClose,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: Color(0xFFEEF1F6),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close_rounded,
                size: 18,
                color: AppColors.inkMuted,
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 14),
      Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        decoration: BoxDecoration(
          color: const Color(0xFFEEF1F6),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.inkMuted,
                    fontFamily: 'PlusJakartaSans',
                  ),
                  children: <TextSpan>[
                    const TextSpan(text: 'Thời điểm ghi nhận: '),
                    TextSpan(
                      text: formatOperationRecordedTime(recordedAt),
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        color: AppColors.ink,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Icon(
              Icons.schedule_rounded,
              size: 16,
              color: AppColors.inkMuted,
            ),
          ],
        ),
      ),
    ],
  );
}
