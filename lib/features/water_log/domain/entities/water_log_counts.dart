import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';

part 'water_log_counts.freezed.dart';
part 'water_log_counts.g.dart';

@freezed
abstract class WaterLogCounts with _$WaterLogCounts {
  const WaterLogCounts._();
  const factory WaterLogCounts({
    required int all,
    required int valid,
    required int warning,
    required int voided,
  }) = _WaterLogCounts;
  factory WaterLogCounts.fromJson(Map<String, dynamic> json) =>
      _$WaterLogCountsFromJson(json);

  static WaterLogCounts parse(Object? raw) {
    try {
      if (raw is! Map<String, dynamic> ||
          [
            'all',
            'valid',
            'warning',
            'voided',
          ].any((key) => raw[key] is! int || (raw[key] as int) < 0)) {
        throw const InvalidResponseException();
      }
      final counts = WaterLogCounts.fromJson(raw);
      if (counts.all != counts.valid + counts.voided ||
          counts.warning > counts.valid) {
        throw const InvalidResponseException();
      }
      return counts;
    } on Object catch (_, stackTrace) {
      Error.throwWithStackTrace(const InvalidResponseException(), stackTrace);
    }
  }
}
