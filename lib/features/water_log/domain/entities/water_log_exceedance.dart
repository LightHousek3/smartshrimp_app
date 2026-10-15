import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';

part 'water_log_exceedance.freezed.dart';
part 'water_log_exceedance.g.dart';

enum WaterLogWarningDirection {
  @JsonValue('below_min')
  belowMin,
  @JsonValue('above_max')
  aboveMax,
  unknown,
}

@freezed
abstract class WaterLogExceedance with _$WaterLogExceedance {
  const WaterLogExceedance._();
  const factory WaterLogExceedance({
    required String field,
    @JsonKey(unknownEnumValue: WaterLogWarningDirection.unknown)
    required WaterLogWarningDirection direction,
    required double value,
    required double? min,
    required double? max,
    required String unit,
  }) = _WaterLogExceedance;

  factory WaterLogExceedance.fromJson(Map<String, dynamic> json) =>
      _$WaterLogExceedanceFromJson(json);

  static WaterLogExceedance parse(Object? raw) {
    try {
      if (raw is! Map<String, dynamic> ||
          raw['direction'] is! String ||
          !raw.containsKey('min') ||
          !raw.containsKey('max')) {
        throw const InvalidResponseException();
      }
      final detail = WaterLogExceedance.fromJson(raw);
      if (detail.field.trim().isEmpty ||
          !detail.value.isFinite ||
          (detail.min != null && !detail.min!.isFinite) ||
          (detail.max != null && !detail.max!.isFinite) ||
          (detail.min != null &&
              detail.max != null &&
              detail.min! > detail.max!) ||
          (detail.direction == WaterLogWarningDirection.belowMin &&
              (detail.min == null || detail.value >= detail.min!)) ||
          (detail.direction == WaterLogWarningDirection.aboveMax &&
              (detail.max == null || detail.value <= detail.max!))) {
        throw const InvalidResponseException();
      }
      return detail;
    } on Object catch (_, stackTrace) {
      Error.throwWithStackTrace(const InvalidResponseException(), stackTrace);
    }
  }
}
