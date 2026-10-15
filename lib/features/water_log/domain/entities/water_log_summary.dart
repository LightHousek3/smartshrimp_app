import 'package:smartshrimp_app/features/water_log/domain/entities/water_log.dart';
import 'package:smartshrimp_app/features/water_log/domain/entities/water_log_exceedance.dart';
import 'package:smartshrimp_app/features/water_log/domain/entities/water_log_metadata.dart';

typedef WaterMetricSummary = ({
  int measured,
  int above,
  int below,
  int within,
  double? min,
  double? max,
  double? average,
});

WaterMetricSummary summarizeWaterMetric(
  Iterable<WaterLog> logs,
  WaterMetricMetadata metric,
) {
  var measured = 0, above = 0, below = 0, within = 0;
  var sum = 0.0;
  double? min, max;
  for (final log in logs) {
    final value = log.valueOf(metric.field);
    if (log.isVoided || value == null) continue;
    measured++;
    sum += value;
    min = min == null || value < min ? value : min;
    max = max == null || value > max ? value : max;
    final direction = log.exceededParameterDetails
        .where((detail) => detail.field == metric.field)
        .firstOrNull
        ?.direction;
    switch (direction) {
      case WaterLogWarningDirection.aboveMax:
        above++;
      case WaterLogWarningDirection.belowMin:
        below++;
      default:
        // Older BE responses have no direction: use its metadata policy.
        if (metric.warningMin != null && value < metric.warningMin!) {
          below++;
        } else if (metric.warningMax != null && value > metric.warningMax!) {
          above++;
        } else {
          within++;
        }
    }
  }
  return (
    measured: measured,
    above: above,
    below: below,
    within: within,
    min: min,
    max: max,
    average: measured == 0 ? null : sum / measured,
  );
}
