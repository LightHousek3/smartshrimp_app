import 'package:flutter/material.dart';

enum HealthStatus {
  excellent,
  good,
  warning,
  critical;

  String get displayName => switch (this) {
    excellent => 'Rất tốt',
    good => 'Bình thường',
    warning => 'Cảnh báo',
    critical => 'Nguy cấp',
  };

  Color get color => switch (this) {
    excellent => const Color(0xFF10B981),
    good => const Color(0xFF0284C7),
    warning => const Color(0xFFF59E0B),
    critical => const Color(0xFFEF4444),
  };

  Color get backgroundColor => switch (this) {
    excellent => const Color(0xFFE8F8F0),
    good => const Color(0xFFE0F2FE),
    warning => const Color(0xFFFEF3C7),
    critical => const Color(0xFFFEE2E2),
  };

  IconData get icon => switch (this) {
    excellent => Icons.sentiment_very_satisfied_rounded,
    good => Icons.sentiment_satisfied_rounded,
    warning => Icons.sentiment_neutral_rounded,
    critical => Icons.sentiment_very_dissatisfied_rounded,
  };

  static HealthStatus parse(String? value) => switch (value?.toUpperCase()) {
    'EXCELLENT' => HealthStatus.excellent,
    'WARNING' => HealthStatus.warning,
    'CRITICAL' => HealthStatus.critical,
    _ => HealthStatus.good,
  };

  String toApiValue() => switch (this) {
    excellent => 'EXCELLENT',
    good => 'GOOD',
    warning => 'WARNING',
    critical => 'CRITICAL',
  };
}

double? _asNullableDouble(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}

int? _asNullableInt(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}

int _asInt(dynamic value, [int defaultValue = 0]) {
  if (value == null) return defaultValue;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value) ?? defaultValue;
  return defaultValue;
}

DateTime? _asNullableDate(dynamic value) {
  if (value == null) return null;
  if (value is DateTime) return value;
  if (value is String) return DateTime.tryParse(value);
  return null;
}

class ShrimpHealthLog {
  const ShrimpHealthLog({
    required this.id,
    required this.seasonId,
    required this.recordedBy,
    this.recordedByName,
    this.recordedByEmail,
    required this.recordedAt,
    this.dayOfCulture,
    this.sampleSize,
    this.avgWeightG,
    this.avgLengthCm,
    this.mortalityCount = 0,
    this.estimatedPopulation,
    this.estimatedBiomassKg,
    this.healthStatus = HealthStatus.good,
    this.note,
    this.isVoided = false,
    this.voidedBy,
    this.voidedByName,
    this.voidedByEmail,
    this.voidedAt,
    this.voidReason,
    required this.createdAt,
  });

  final String id;
  final String seasonId;
  final String recordedBy;
  final String? recordedByName;
  final String? recordedByEmail;
  final DateTime recordedAt;
  final int? dayOfCulture;
  final int? sampleSize;
  final double? avgWeightG;
  final double? avgLengthCm;
  final int mortalityCount;
  final int? estimatedPopulation;
  final double? estimatedBiomassKg;
  final HealthStatus healthStatus;
  final String? note;
  final bool isVoided;
  final String? voidedBy;
  final String? voidedByName;
  final String? voidedByEmail;
  final DateTime? voidedAt;
  final String? voidReason;
  final DateTime createdAt;

  factory ShrimpHealthLog.fromJson(Map<String, dynamic> json) =>
      ShrimpHealthLog(
        id: json['id'] as String,
        seasonId: json['seasonId'] as String,
        recordedBy: json['recordedBy'] as String,
        recordedByName: json['recordedByName'] as String?,
        recordedByEmail: json['recordedByEmail'] as String?,
        recordedAt:
            _asNullableDate(json['recordedAt']) ?? DateTime.now(),
        dayOfCulture: _asNullableInt(json['dayOfCulture']),
        sampleSize: _asNullableInt(json['sampleSize']),
        avgWeightG: _asNullableDouble(json['avgWeightG']),
        avgLengthCm: _asNullableDouble(json['avgLengthCm']),
        mortalityCount: _asInt(json['mortalityCount'], 0),
        estimatedPopulation: _asNullableInt(json['estimatedPopulation']),
        estimatedBiomassKg: _asNullableDouble(json['estimatedBiomassKg']),
        healthStatus: HealthStatus.parse(json['healthStatus'] as String?),
        note: json['note'] as String?,
        isVoided: json['isVoided'] == true,
        voidedBy: json['voidedBy'] as String?,
        voidedByName: json['voidedByName'] as String?,
        voidedByEmail: json['voidedByEmail'] as String?,
        voidedAt: _asNullableDate(json['voidedAt']),
        voidReason: json['voidReason'] as String?,
        createdAt:
            _asNullableDate(json['createdAt']) ?? DateTime.now(),
      );
}

class ShrimpHealthCounts {
  const ShrimpHealthCounts({
    required this.total,
    required this.valid,
    required this.voided,
    required this.warningOrCritical,
  });

  final int total;
  final int valid;
  final int voided;
  final int warningOrCritical;

  factory ShrimpHealthCounts.fromJson(Map<String, dynamic> json) =>
      ShrimpHealthCounts(
        total: _asInt(json['total']),
        valid: _asInt(json['valid']),
        voided: _asInt(json['voided']),
        warningOrCritical: _asInt(json['warningOrCritical']),
      );
}

class ShrimpHealthListResult {
  const ShrimpHealthListResult({
    required this.logs,
    this.nextCursor,
    this.hasNext = false,
    this.counts,
  });

  final List<ShrimpHealthLog> logs;
  final String? nextCursor;
  final bool hasNext;
  final ShrimpHealthCounts? counts;

  factory ShrimpHealthListResult.fromJson(
    List<dynamic> logsJson,
    Map<String, dynamic>? meta,
  ) => ShrimpHealthListResult(
    logs: logsJson
        .map((e) => ShrimpHealthLog.fromJson(e as Map<String, dynamic>))
        .toList(),
    nextCursor: meta?['nextCursor'] as String?,
    hasNext: meta?['hasNext'] == true,
    counts: meta?['counts'] != null
        ? ShrimpHealthCounts.fromJson(meta!['counts'] as Map<String, dynamic>)
        : null,
  );
}

class ShrimpHealthSummary {
  const ShrimpHealthSummary({
    this.currentBiomassKg,
    this.currentAvgWeightG,
    this.currentAvgLengthCm,
    this.currentPopulation,
    this.currentHealthStatus,
    this.survivalRatePercent,
    this.totalMortalityInRange = 0,
    this.totalLogsInRange = 0,
    this.lastRecordedAt,
  });

  final double? currentBiomassKg;
  final double? currentAvgWeightG;
  final double? currentAvgLengthCm;
  final int? currentPopulation;
  final HealthStatus? currentHealthStatus;
  final double? survivalRatePercent;
  final int totalMortalityInRange;
  final int totalLogsInRange;
  final DateTime? lastRecordedAt;

  factory ShrimpHealthSummary.fromJson(Map<String, dynamic> json) =>
      ShrimpHealthSummary(
        currentBiomassKg: _asNullableDouble(json['currentBiomassKg']),
        currentAvgWeightG: _asNullableDouble(json['currentAvgWeightG']),
        currentAvgLengthCm: _asNullableDouble(json['currentAvgLengthCm']),
        currentPopulation: _asNullableInt(json['currentPopulation']),
        currentHealthStatus: json['currentHealthStatus'] != null
            ? HealthStatus.parse(json['currentHealthStatus'] as String)
            : null,
        survivalRatePercent: _asNullableDouble(json['survivalRatePercent']),
        totalMortalityInRange: _asInt(json['totalMortalityInRange'], 0),
        totalLogsInRange: _asInt(json['totalLogsInRange'], 0),
        lastRecordedAt: _asNullableDate(json['lastRecordedAt']),
      );
}

class ShrimpHealthDistributionItem {
  const ShrimpHealthDistributionItem({
    required this.count,
    required this.percent,
  });

  final int count;
  final double percent;

  factory ShrimpHealthDistributionItem.fromJson(Map<String, dynamic> json) =>
      ShrimpHealthDistributionItem(
        count: _asInt(json['count']),
        percent: _asNullableDouble(json['percent']) ?? 0.0,
      );
}

class ShrimpHealthDistribution {
  const ShrimpHealthDistribution({
    required this.totalLogs,
    required this.excellent,
    required this.good,
    required this.warning,
    required this.critical,
  });

  final int totalLogs;
  final ShrimpHealthDistributionItem excellent;
  final ShrimpHealthDistributionItem good;
  final ShrimpHealthDistributionItem warning;
  final ShrimpHealthDistributionItem critical;

  factory ShrimpHealthDistribution.fromJson(Map<String, dynamic> json) =>
      ShrimpHealthDistribution(
        totalLogs: _asInt(json['totalLogs']),
        excellent: ShrimpHealthDistributionItem.fromJson(
          json['excellent'] as Map<String, dynamic>? ?? {},
        ),
        good: ShrimpHealthDistributionItem.fromJson(
          json['good'] as Map<String, dynamic>? ?? {},
        ),
        warning: ShrimpHealthDistributionItem.fromJson(
          json['warning'] as Map<String, dynamic>? ?? {},
        ),
        critical: ShrimpHealthDistributionItem.fromJson(
          json['critical'] as Map<String, dynamic>? ?? {},
        ),
      );
}

class ShrimpGrowthPoint {
  const ShrimpGrowthPoint({
    required this.date,
    required this.recordedAt,
    this.dayOfCulture,
    this.avgWeightG,
    this.avgLengthCm,
    this.estimatedBiomassKg,
    this.estimatedPopulation,
    this.mortalityCount = 0,
    this.healthStatus = HealthStatus.good,
  });

  final String date;
  final DateTime recordedAt;
  final int? dayOfCulture;
  final double? avgWeightG;
  final double? avgLengthCm;
  final double? estimatedBiomassKg;
  final int? estimatedPopulation;
  final int mortalityCount;
  final HealthStatus healthStatus;

  factory ShrimpGrowthPoint.fromJson(Map<String, dynamic> json) =>
      ShrimpGrowthPoint(
        date: json['date'] as String? ?? '',
        recordedAt:
            _asNullableDate(json['recordedAt']) ?? DateTime.now(),
        dayOfCulture: _asNullableInt(json['dayOfCulture']),
        avgWeightG: _asNullableDouble(json['avgWeightG']),
        avgLengthCm: _asNullableDouble(json['avgLengthCm']),
        estimatedBiomassKg: _asNullableDouble(json['estimatedBiomassKg']),
        estimatedPopulation: _asNullableInt(json['estimatedPopulation']),
        mortalityCount: _asInt(json['mortalityCount'], 0),
        healthStatus: HealthStatus.parse(json['healthStatus'] as String?),
      );
}

class ShrimpHealthStatsResult {
  const ShrimpHealthStatsResult({
    required this.seasonId,
    required this.shrimpType,
    this.stockingDate,
    this.initialQuantity,
    required this.summary,
    required this.healthDistribution,
    required this.growthSeries,
  });

  final String seasonId;
  final String shrimpType;
  final String? stockingDate;
  final int? initialQuantity;
  final ShrimpHealthSummary summary;
  final ShrimpHealthDistribution healthDistribution;
  final List<ShrimpGrowthPoint> growthSeries;

  factory ShrimpHealthStatsResult.fromJson(Map<String, dynamic> json) =>
      ShrimpHealthStatsResult(
        seasonId: json['seasonId'] as String? ?? '',
        shrimpType: json['shrimpType'] as String? ?? '',
        stockingDate: json['stockingDate'] as String?,
        initialQuantity: _asNullableInt(json['initialQuantity']),
        summary: ShrimpHealthSummary.fromJson(
          json['summary'] as Map<String, dynamic>? ?? {},
        ),
        healthDistribution: ShrimpHealthDistribution.fromJson(
          json['healthDistribution'] as Map<String, dynamic>? ?? {},
        ),
        growthSeries: (json['growthSeries'] as List<dynamic>? ?? [])
            .map((e) => ShrimpGrowthPoint.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}
