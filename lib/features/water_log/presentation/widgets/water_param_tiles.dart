import 'package:flutter/material.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/features/water_log/domain/entities/water_log.dart';
import 'package:smartshrimp_app/features/water_log/domain/entities/water_log_metadata.dart';

/// Định dạng số gọn: 18.0 -> '18', 29.4 -> '29.4'.
String formatWaterValue(double? value) {
  if (value == null) return '—';
  if (value == value.roundToDouble()) return value.toInt().toString();
  // Giữ đủ độ chính xác lưu trữ của NH3, NO2 và H2S (5 chữ số).
  final text = value.toStringAsFixed(5);
  return text.replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '');
}

/// Chỉ số đo nước, với biến thể ô nền dùng trong card danh sách.
class WaterParamTiles extends StatelessWidget {
  const WaterParamTiles({
    required this.log,
    this.metadata,
    this.showThresholds = false,
    this.boxed = false,
    this.includeH2s = false,
    this.roomy = false,
    super.key,
  });

  final WaterLog log;
  final WaterLogMetadata? metadata;
  final bool showThresholds;
  final bool boxed;
  final bool includeH2s;
  final bool roomy;

  @override
  Widget build(BuildContext context) {
    final params = includeH2s ? waterLogFormParams : waterLogCardParams;
    if (boxed) {
      return Column(
        children: <Widget>[
          for (var row = 0; row < 2; row++) ...<Widget>[
            if (row > 0) const SizedBox(height: 8),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  for (var column = 0; column < 4; column++) ...<Widget>[
                    if (column > 0) const SizedBox(width: 8),
                    Expanded(
                      child: row * 4 + column < params.length
                          ? _BoxedParamTile(
                              log: log,
                              param: params[row * 4 + column],
                              showThresholds: showThresholds,
                              metric: metadata?.metrics
                                  .where(
                                    (metric) =>
                                        metric.field ==
                                        params[row * 4 + column].field,
                                  )
                                  .firstOrNull,
                              roomy: roomy,
                            )
                          : const SizedBox.shrink(),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      );
    }
    final first = waterLogCardParams.take(4).toList(growable: false);
    final second = waterLogCardParams.skip(4).toList(growable: false);
    return Column(
      children: <Widget>[
        _TileRow(log: log, params: first),
        const Divider(height: 24),
        _TileRow(log: log, params: second),
      ],
    );
  }
}

class _BoxedParamTile extends StatelessWidget {
  const _BoxedParamTile({
    required this.log,
    required this.param,
    required this.showThresholds,
    this.metric,
    this.roomy = false,
  });

  final WaterLog log;
  final WaterLogParam param;
  final bool showThresholds;
  final WaterMetricMetadata? metric;
  final bool roomy;

  @override
  Widget build(BuildContext context) {
    final exceeded = log.exceededParameters.contains(param.field);
    return Container(
      padding: EdgeInsets.all(roomy ? 10 : 8),
      decoration: BoxDecoration(
        color: exceeded ? const Color(0xFFFBE6EA) : const Color(0xB3EEF1F6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            param.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.inkMuted,
              fontSize: 10,
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 2),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              formatWaterValue(log.valueOf(param.field)),
              style: AppTypography.mono(
                color: exceeded ? AppColors.error : AppColors.ink,
                fontSize: roomy ? 14 : 13,
                fontWeight: FontWeight.w600,
              ).copyWith(height: 1.5),
            ),
          ),
          Text(
            param.unit,
            style: const TextStyle(
              color: AppColors.inkMuted,
              fontSize: 9,
              fontWeight: FontWeight.w400,
              height: 1.5,
            ),
          ),
          if (showThresholds) ...[
            const SizedBox(height: 4),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final bound in [
                  (label: 'Min', value: metric?.warningMin),
                  (label: 'Max', value: metric?.warningMax),
                ])
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      '${bound.label}: ${metric == null ? '…' : formatWaterValue(bound.value)}',
                      key: Key(
                        'water_threshold_${param.field}_${bound.label.toLowerCase()}',
                      ),
                      style: const TextStyle(
                        color: AppColors.inkMuted,
                        fontSize: 9,
                        height: 1.5,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _TileRow extends StatelessWidget {
  const _TileRow({required this.log, required this.params});

  final WaterLog log;
  final List<WaterLogParam> params;

  @override
  Widget build(BuildContext context) => IntrinsicHeight(
    child: Row(
      children: <Widget>[
        for (var index = 0; index < params.length; index++) ...<Widget>[
          Expanded(
            child: _ParamTile(log: log, param: params[index]),
          ),
          if (index < params.length - 1)
            const VerticalDivider(width: 1, color: AppColors.line),
        ],
      ],
    ),
  );
}

class _ParamTile extends StatelessWidget {
  const _ParamTile({required this.log, required this.param});

  final WaterLog log;
  final WaterLogParam param;

  @override
  Widget build(BuildContext context) {
    final exceeded = log.exceededParameters.contains(param.field);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        children: <Widget>[
          Text(
            param.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: AppColors.inkMuted, fontSize: 9.5),
          ),
          const SizedBox(height: 5),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: RichText(
              text: TextSpan(
                style: const TextStyle(color: AppColors.ink),
                children: <InlineSpan>[
                  TextSpan(
                    text: formatWaterValue(log.valueOf(param.field)),
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: exceeded ? AppColors.error : AppColors.ink,
                    ),
                  ),
                  if (param.unit.isNotEmpty)
                    TextSpan(
                      text: ' ${param.unit}',
                      style: const TextStyle(
                        color: AppColors.inkMuted,
                        fontSize: 8.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
