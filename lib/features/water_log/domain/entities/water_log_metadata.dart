import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/season/domain/entities/aquaculture_season.dart';
import 'package:smartshrimp_app/features/water_log/domain/entities/water_log.dart';
import 'package:smartshrimp_app/features/water_log/domain/entities/water_log_threshold.dart';

part 'water_log_metadata.freezed.dart';
part 'water_log_metadata.g.dart';

@freezed
abstract class WaterMetricMetadata with _$WaterMetricMetadata {
  const WaterMetricMetadata._();
  const factory WaterMetricMetadata({
    required String field,
    required String unit,
    required double inputMin,
    required double? inputMax,
    required int scale,
    required double? warningMin,
    required double? warningMax,
  }) = _WaterMetricMetadata;
  factory WaterMetricMetadata.fromJson(Map<String, dynamic> json) =>
      _$WaterMetricMetadataFromJson(json);

  /// Match NUMERIC's decimal half-away-from-zero rounding, without binary ties.
  double canonicalValue(double value) {
    if (!value.isFinite) throw const InvalidResponseException();
    final parts = value.abs().toString().toLowerCase().split('e');
    final mantissa = parts.first.split('.');
    final fraction = mantissa.length == 2 ? mantissa[1] : '';
    final coefficient = BigInt.parse('${mantissa[0]}$fraction');
    final shift =
        (parts.length == 2 ? int.parse(parts[1]) : 0) - fraction.length + scale;
    BigInt rounded;
    if (shift >= 0) {
      rounded = coefficient * BigInt.from(10).pow(shift);
    } else {
      final divisor = BigInt.from(10).pow(-shift);
      rounded = coefficient ~/ divisor;
      if ((coefficient % divisor) * BigInt.two >= divisor) {
        rounded += BigInt.one;
      }
    }
    return double.parse('${value < 0 ? '-' : ''}${rounded}e-$scale');
  }
}

@freezed
abstract class WaterLogMetadata with _$WaterLogMetadata {
  const WaterLogMetadata._();
  const factory WaterLogMetadata({
    required int schemaVersion,
    required String policyVersion,
    required String shrimpType,
    required int recordedAtFutureToleranceSeconds,
    required int noteMaxLength,
    required List<WaterMetricMetadata> metrics,
  }) = _WaterLogMetadata;
  factory WaterLogMetadata.fromJson(Map<String, dynamic> json) =>
      _$WaterLogMetadataFromJson(json);

  static WaterLogMetadata parse(Map<String, dynamic> json) {
    try {
      for (final field in [
        'schemaVersion',
        'recordedAtFutureToleranceSeconds',
        'noteMaxLength',
      ]) {
        if (json[field] is! int) throw const InvalidResponseException();
      }
      for (final raw in json['metrics'] as List) {
        if (raw['scale'] is! int) throw const InvalidResponseException();
      }
      final metadata = WaterLogMetadata.fromJson(json);
      final fields = waterLogFormParams.map((param) => param.field).toSet();
      if (metadata.schemaVersion != 1 ||
          metadata.policyVersion.trim().isEmpty ||
          shrimpTypeFromJson(metadata.shrimpType) == ShrimpType.unknown ||
          metadata.recordedAtFutureToleranceSeconds < 0 ||
          metadata.noteMaxLength < 1 ||
          metadata.metrics.length != fields.length) {
        throw const InvalidResponseException();
      }
      for (final metric in metadata.metrics) {
        if (!fields.remove(metric.field) ||
            !metric.inputMin.isFinite ||
            metric.scale < 0 ||
            metric.scale > 5 ||
            (metric.inputMax != null &&
                (!metric.inputMax!.isFinite ||
                    metric.inputMax! < metric.inputMin)) ||
            (metric.warningMin != null && !metric.warningMin!.isFinite) ||
            (metric.warningMax != null && !metric.warningMax!.isFinite) ||
            (metric.warningMin != null &&
                metric.warningMax != null &&
                metric.warningMin! > metric.warningMax!)) {
          throw const InvalidResponseException();
        }
        // Missing nullable bounds are a malformed contract, not unbounded values.
        final raw =
            (json['metrics'] as List).firstWhere(
                  (entry) => entry['field'] == metric.field,
                )
                as Map;
        if (!raw.containsKey('inputMax') ||
            !raw.containsKey('warningMin') ||
            !raw.containsKey('warningMax')) {
          throw const InvalidResponseException();
        }
      }
      return metadata;
    } on Object catch (_, stackTrace) {
      Error.throwWithStackTrace(const InvalidResponseException(), stackTrace);
    }
  }

  static WaterLogMetadata legacy(ShrimpType species) => WaterLogMetadata(
    schemaVersion: 1,
    policyVersion: 'water-v1-legacy',
    shrimpType: species == ShrimpType.blackTiger ? 'BLACK_TIGER' : 'WHITELEG',
    recordedAtFutureToleranceSeconds: 300,
    noteMaxLength: 2000,
    metrics: [
      for (final threshold in legacyWaterLogThresholds(species))
        WaterMetricMetadata(
          field: threshold.param.field,
          unit: threshold.param.unit,
          inputMin: 0,
          inputMax: switch (threshold.param.field) {
            'temperatureC' => 50,
            'ph' => 14,
            _ => null,
          },
          scale: switch (threshold.param.field) {
            'dissolvedOxygenMgL' || 'salinityPpt' => 3,
            'nh3MgL' || 'no2MgL' || 'h2sMgL' => 5,
            _ => 2,
          },
          warningMin: threshold.min,
          warningMax: threshold.max,
        ),
    ],
  );

  List<WaterLogWarning> warnings(Map<String, double> values) => [
    for (final metric in metrics)
      if (values[metric.field] case final value?)
        if ((metric.warningMin != null && value < metric.warningMin!) ||
            (metric.warningMax != null && value > metric.warningMax!))
          WaterLogWarning(
            threshold: WaterLogThreshold(
              WaterLogParam(
                metric.field,
                waterLogParamLabel(metric.field),
                metric.unit,
              ),
              min: metric.warningMin,
              max: metric.warningMax,
            ),
            value: value,
          ),
  ];
}
