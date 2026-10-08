import 'package:flutter/material.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/features/water_log/domain/entities/water_log.dart';

/// Định dạng số gọn: 18.0 -> '18', 29.4 -> '29.4'.
String formatWaterValue(double? value) {
  if (value == null) return '—';
  if (value == value.roundToDouble()) return value.toInt().toString();
  // Giới hạn chữ số thập phân để không tràn ô.
  final text = value.toStringAsFixed(3);
  return text.replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '');
}

/// Lưới 4 + 3 ô chỉ số theo Figma (dùng cho card danh sách và "Đo nước gần nhất").
class WaterParamTiles extends StatelessWidget {
  const WaterParamTiles({required this.log, super.key});

  final WaterLog log;

  @override
  Widget build(BuildContext context) {
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
