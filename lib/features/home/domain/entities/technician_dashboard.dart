import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/task/domain/entities/task_models.dart';

part 'technician_dashboard.freezed.dart';
part 'technician_dashboard.g.dart';

enum TechnicianAlertKind {
  @JsonValue('WATER')
  water,
  @JsonValue('OVERDUE_OPERATIONS')
  overdueOperations,
  @JsonValue('SCHEDULE_BLOCKED')
  scheduleBlocked,
  unknown,
}

enum BiomassSnapshotState {
  @JsonValue('MISSING')
  missing,
  @JsonValue('RECORDED')
  recorded,
  @JsonValue('STALE')
  stale,
  @JsonValue('AFTER_HARVEST')
  afterHarvest,
  @JsonValue('POPULATION_CHANGED')
  populationChanged,
  unknown,
}

@freezed
abstract class TechnicianSummary with _$TechnicianSummary {
  @JsonSerializable(checked: true)
  const factory TechnicianSummary({
    required int activeSeasonCount,
    required int openTaskCount,
    required int unresolvedActiveSeasonCaseCount,
  }) = _TechnicianSummary;
  factory TechnicianSummary.fromJson(Map<String, dynamic> json) =>
      _$TechnicianSummaryFromJson(json);
}

@freezed
abstract class TechnicianWaterMetric with _$TechnicianWaterMetric {
  @JsonSerializable(checked: true)
  const factory TechnicianWaterMetric({
    required String field,
    required double value,
    required String unit,
    required DateTime recordedAt,
    double? min,
    double? max,
  }) = _TechnicianWaterMetric;
  factory TechnicianWaterMetric.fromJson(Map<String, dynamic> json) =>
      _$TechnicianWaterMetricFromJson(json);
}

@freezed
abstract class TechnicianAlert with _$TechnicianAlert {
  @JsonSerializable(checked: true)
  const factory TechnicianAlert({
    required String id,
    @JsonKey(unknownEnumValue: TechnicianAlertKind.unknown)
    required TechnicianAlertKind kind,
    required String seasonId,
    required String seasonName,
    required String pondName,
    required String farmName,
    required int count,
    required DateTime observedAt,
    @Default([]) List<TechnicianWaterMetric> metrics,
    @Default([]) List<String> reasonCodes,
  }) = _TechnicianAlert;
  factory TechnicianAlert.fromJson(Map<String, dynamic> json) =>
      _$TechnicianAlertFromJson(json);
}

@freezed
abstract class TechnicianOperation with _$TechnicianOperation {
  @JsonSerializable(checked: true)
  const factory TechnicianOperation({
    required String id,
    required String operationType,
    required DateTime scheduledAt,
    required double plannedQuantity,
    required String unit,
    String? productName,
  }) = _TechnicianOperation;
  factory TechnicianOperation.fromJson(Map<String, dynamic> json) =>
      _$TechnicianOperationFromJson(json);
}

@freezed
abstract class TechnicianOperationGroup with _$TechnicianOperationGroup {
  @JsonSerializable(checked: true)
  const factory TechnicianOperationGroup({
    required String seasonId,
    required String seasonName,
    required String pondName,
    required String farmName,
    required List<TechnicianOperation> items,
  }) = _TechnicianOperationGroup;
  factory TechnicianOperationGroup.fromJson(Map<String, dynamic> json) =>
      _$TechnicianOperationGroupFromJson(json);
}

@freezed
abstract class TechnicianSeasonSnapshot with _$TechnicianSeasonSnapshot {
  @JsonSerializable(checked: true)
  const factory TechnicianSeasonSnapshot({
    required String seasonId,
    required String seasonName,
    required String pondName,
    required String farmName,
    @JsonKey(unknownEnumValue: BiomassSnapshotState.unknown)
    required BiomassSnapshotState biomassState,
    int? cultureDay,
    double? biomassKg,
    DateTime? biomassRecordedAt,
  }) = _TechnicianSeasonSnapshot;
  factory TechnicianSeasonSnapshot.fromJson(Map<String, dynamic> json) =>
      _$TechnicianSeasonSnapshotFromJson(json);
}

@freezed
abstract class TechnicianDashboard with _$TechnicianDashboard {
  @JsonSerializable(checked: true)
  const factory TechnicianDashboard({
    required String date,
    required DateTime serverNow,
    required DateTime dayEndExclusive,
    required TechnicianSummary summary,
    required List<TechnicianAlert> alerts,
    required List<TaskItem> tasks,
    required List<TechnicianOperationGroup> operationGroups,
    required List<TechnicianSeasonSnapshot> seasons,
  }) = _TechnicianDashboard;
  factory TechnicianDashboard.fromJson(Map<String, dynamic> json) =>
      _$TechnicianDashboardFromJson(json);

  static TechnicianDashboard parse(Map<String, dynamic> json) {
    try {
      final value = TechnicianDashboard.fromJson(json);
      final day = DateTime.tryParse('${value.date}T00:00:00+07:00');
      if (!RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(value.date) ||
          day == null ||
          vietnamDate(day) != value.date ||
          vietnamDate(value.serverNow) != value.date ||
          value.dayEndExclusive != day.add(const Duration(days: 1))) {
        throw const InvalidResponseException();
      }
      _counts([
        value.summary.activeSeasonCount,
        value.summary.openTaskCount,
        value.summary.unresolvedActiveSeasonCaseCount,
      ]);
      if (value.tasks.length > 3 ||
          value.seasons.length > 3 ||
          value.summary.openTaskCount < value.tasks.length ||
          value.summary.activeSeasonCount < value.seasons.length) {
        throw const InvalidResponseException();
      }
      for (final alert in value.alerts) {
        _validateAlert(alert);
      }
      final seasonIds = <String>{};
      for (final group in value.operationGroups) {
        _strings([
          group.seasonId,
          group.seasonName,
          group.pondName,
          group.farmName,
        ]);
        if (!seasonIds.add(group.seasonId) || group.items.isEmpty) {
          throw const InvalidResponseException();
        }
        final ids = <String>{};
        DateTime? previous;
        for (final item in group.items) {
          _strings([item.id, item.operationType, item.unit]);
          if (!ids.add(item.id) ||
              !item.plannedQuantity.isFinite ||
              item.plannedQuantity <= 0 ||
              item.scheduledAt.isBefore(value.serverNow) ||
              !item.scheduledAt.isBefore(value.dayEndExclusive) ||
              (previous != null && item.scheduledAt.isBefore(previous))) {
            throw const InvalidResponseException();
          }
          previous = item.scheduledAt;
        }
      }
      for (final season in value.seasons) {
        _strings([
          season.seasonId,
          season.seasonName,
          season.pondName,
          season.farmName,
        ]);
        if ((season.cultureDay != null && season.cultureDay! < 1) ||
            (season.biomassKg != null &&
                (!season.biomassKg!.isFinite || season.biomassKg! < 0)) ||
            (season.biomassRecordedAt?.isAfter(value.serverNow) ?? false) ||
            ([
                  BiomassSnapshotState.recorded,
                  BiomassSnapshotState.stale,
                ].contains(season.biomassState) &&
                (season.biomassKg == null ||
                    season.biomassRecordedAt == null))) {
          throw const InvalidResponseException();
        }
      }
      return value;
    } on Object catch (_, stack) {
      Error.throwWithStackTrace(const InvalidResponseException(), stack);
    }
  }
}

void _validateAlert(TechnicianAlert alert) {
  _strings([
    alert.id,
    alert.seasonId,
    alert.seasonName,
    alert.pondName,
    alert.farmName,
  ]);
  if (alert.count < 1 ||
      (alert.kind == TechnicianAlertKind.water && alert.metrics.isEmpty) ||
      (alert.kind == TechnicianAlertKind.scheduleBlocked &&
          alert.reasonCodes.isEmpty)) {
    throw const InvalidResponseException();
  }
  for (final metric in alert.metrics) {
    _strings([metric.field, metric.unit]);
    if (!metric.value.isFinite ||
        (metric.min != null && !metric.min!.isFinite) ||
        (metric.max != null && !metric.max!.isFinite)) {
      throw const InvalidResponseException();
    }
  }
}

void _strings(List<String> values) {
  if (values.any((value) => value.trim().isEmpty)) {
    throw const InvalidResponseException();
  }
}

void _counts(List<int> values) {
  if (values.any((value) => value < 0)) throw const InvalidResponseException();
}

/// Operation dates follow Vietnam time even when the handset uses another timezone.
DateTime vietnamTime(DateTime at) => at.toUtc().add(const Duration(hours: 7));
String vietnamDate(DateTime at) =>
    vietnamTime(at).toIso8601String().substring(0, 10);
