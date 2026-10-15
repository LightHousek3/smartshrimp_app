import 'package:smartshrimp_app/features/season/domain/entities/aquaculture_season.dart';
import 'package:smartshrimp_app/features/water_log/domain/entities/water_log.dart';

/// Pinned legacy policy, used only after confirming an older server can read this season.
class WaterLogThreshold {
  const WaterLogThreshold(this.param, {this.min, this.max});

  final WaterLogParam param;
  final double? min;
  final double? max;

  bool exceeds(double value) =>
      (min != null && value < min!) || (max != null && value > max!);
}

class WaterLogWarning {
  const WaterLogWarning({required this.threshold, required this.value});

  final WaterLogThreshold threshold;
  final double value;

  bool get isBelowMinimum => threshold.min != null && value < threshold.min!;
}

List<WaterLogThreshold> legacyWaterLogThresholds(ShrimpType shrimpType) {
  if (shrimpType == ShrimpType.unknown) {
    throw ArgumentError.value(shrimpType, 'shrimpType');
  }
  return <WaterLogThreshold>[
    WaterLogThreshold(
      waterLogFormParams[0],
      min: shrimpType == ShrimpType.blackTiger ? 26 : 25,
      max: shrimpType == ShrimpType.blackTiger ? 32 : 33,
    ),
    const WaterLogThreshold(
      WaterLogParam('ph', 'pH', 'pH'),
      min: 7.5,
      max: 8.5,
    ),
    WaterLogThreshold(waterLogFormParams[2], min: 4),
    const WaterLogThreshold(
      WaterLogParam('salinityPpt', 'Độ mặn', 'ppt'),
      min: 10,
      max: 30,
    ),
    WaterLogThreshold(waterLogFormParams[4], max: 0.1),
    WaterLogThreshold(waterLogFormParams[5], max: 0.5),
    const WaterLogThreshold(
      WaterLogParam('alkalinityMgLCaCO3', 'Độ kiềm', 'mg/L CaCO3'),
      min: 100,
      max: 250,
    ),
    WaterLogThreshold(waterLogFormParams[7], max: 0.05),
  ];
}

List<WaterLogWarning> checkWaterLogThresholds(
  ShrimpType shrimpType,
  Map<String, double> values,
) => <WaterLogWarning>[
  for (final threshold in legacyWaterLogThresholds(shrimpType))
    if (values[threshold.param.field] case final value?)
      if (threshold.exceeds(value))
        WaterLogWarning(threshold: threshold, value: value),
];
