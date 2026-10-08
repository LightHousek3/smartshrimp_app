import 'package:smartshrimp_app/core/errors/app_exception.dart';

/// Metadata hiển thị cho từng chỉ số đo nước (đúng nhãn/đơn vị theo Figma).
class WaterLogParam {
  const WaterLogParam(this.field, this.label, this.unit);

  /// Khớp key JSON của API và entry trong `exceededParameters`.
  final String field;
  final String label;
  final String unit;
}

/// Thứ tự hiển thị trên card (7 ô): H2S chỉ có trong form nhập.
const List<WaterLogParam> waterLogCardParams = <WaterLogParam>[
  WaterLogParam('temperatureC', 'Nhiệt độ', '°C'),
  WaterLogParam('ph', 'pH', ''),
  WaterLogParam('dissolvedOxygenMgL', 'DO', 'mg/L'),
  WaterLogParam('salinityPpt', 'Độ mặn', '‰'),
  WaterLogParam('nh3MgL', 'NH3', 'mg/L'),
  WaterLogParam('no2MgL', 'NO2', 'mg/L'),
  WaterLogParam('alkalinityMgLCaCO3', 'Kiềm', 'mg/L'),
];

/// Thứ tự 8 ô trong form nhập (thêm H2S).
const List<WaterLogParam> waterLogFormParams = <WaterLogParam>[
  ...waterLogCardParams,
  WaterLogParam('h2sMgL', 'H2S', 'mg/L'),
];

String waterLogParamLabel(String field) {
  for (final param in waterLogFormParams) {
    if (param.field == field) return param.label;
  }
  return field;
}

class WaterLog {
  const WaterLog({
    required this.id,
    required this.seasonId,
    required this.recordedAt,
    required this.createdAt,
    required this.isVoided,
    required this.exceededParameters,
    this.recordedBy,
    this.temperatureC,
    this.ph,
    this.dissolvedOxygenMgL,
    this.salinityPpt,
    this.nh3MgL,
    this.no2MgL,
    this.alkalinityMgLCaCO3,
    this.h2sMgL,
    this.note,
    this.voidedBy,
    this.voidedAt,
    this.voidReason,
  });

  final String id;
  final String seasonId;
  final String? recordedBy;
  final DateTime recordedAt;
  final double? temperatureC;
  final double? ph;
  final double? dissolvedOxygenMgL;
  final double? salinityPpt;
  final double? nh3MgL;
  final double? no2MgL;
  final double? alkalinityMgLCaCO3;
  final double? h2sMgL;
  final String? note;
  final bool isVoided;
  final String? voidedBy;
  final DateTime? voidedAt;
  final String? voidReason;
  final DateTime createdAt;

  /// Key camelCase các chỉ số vượt ngưỡng do backend tính sẵn.
  final List<String> exceededParameters;

  double? valueOf(String field) => switch (field) {
    'temperatureC' => temperatureC,
    'ph' => ph,
    'dissolvedOxygenMgL' => dissolvedOxygenMgL,
    'salinityPpt' => salinityPpt,
    'nh3MgL' => nh3MgL,
    'no2MgL' => no2MgL,
    'alkalinityMgLCaCO3' => alkalinityMgLCaCO3,
    'h2sMgL' => h2sMgL,
    _ => null,
  };

  static WaterLog parse(Map<String, dynamic> json) {
    try {
      final rawExceeded = json['exceededParameters'];
      return WaterLog(
        id: json['id'] as String,
        seasonId: json['seasonId'] as String,
        recordedBy: json['recordedBy'] as String?,
        recordedAt: DateTime.parse(json['recordedAt'] as String),
        temperatureC: (json['temperatureC'] as num?)?.toDouble(),
        ph: (json['ph'] as num?)?.toDouble(),
        dissolvedOxygenMgL: (json['dissolvedOxygenMgL'] as num?)?.toDouble(),
        salinityPpt: (json['salinityPpt'] as num?)?.toDouble(),
        nh3MgL: (json['nh3MgL'] as num?)?.toDouble(),
        no2MgL: (json['no2MgL'] as num?)?.toDouble(),
        alkalinityMgLCaCO3: (json['alkalinityMgLCaCO3'] as num?)?.toDouble(),
        h2sMgL: (json['h2sMgL'] as num?)?.toDouble(),
        note: json['note'] as String?,
        isVoided: json['isVoided'] as bool,
        voidedBy: json['voidedBy'] as String?,
        voidedAt: json['voidedAt'] == null
            ? null
            : DateTime.parse(json['voidedAt'] as String),
        voidReason: json['voidReason'] as String?,
        createdAt: DateTime.parse(json['createdAt'] as String),
        exceededParameters: rawExceeded == null
            ? const <String>[]
            : (rawExceeded as List<dynamic>).map((e) => e as String).toList(),
      );
    } on Object catch (_, stackTrace) {
      Error.throwWithStackTrace(const InvalidResponseException(), stackTrace);
    }
  }
}

class WaterLogPage {
  const WaterLogPage({
    required this.items,
    required this.totalResults,
    required this.hasNextPage,
    this.nextCursor,
  });

  final List<WaterLog> items;
  final int totalResults;
  final bool hasNextPage;
  final String? nextCursor;

  WaterLogPage append(WaterLogPage next) => WaterLogPage(
    items: <WaterLog>[...items, ...next.items],
    totalResults: next.totalResults,
    hasNextPage: next.hasNextPage,
    nextCursor: next.nextCursor,
  );
}

class WaterLogParamStat {
  const WaterLogParamStat({
    required this.count,
    this.min,
    this.max,
    this.avg,
    this.exceedanceRate,
  });

  final int count;
  final double? min;
  final double? max;
  final double? avg;

  /// Tỉ lệ mẫu vượt ngưỡng (0.0 – 1.0).
  final double? exceedanceRate;

  static WaterLogParamStat parse(Map<String, dynamic> json) {
    try {
      return WaterLogParamStat(
        count: json['count'] as int,
        min: (json['min'] as num?)?.toDouble(),
        max: (json['max'] as num?)?.toDouble(),
        avg: (json['avg'] as num?)?.toDouble(),
        exceedanceRate: (json['exceedanceRate'] as num?)?.toDouble(),
      );
    } on Object catch (_, stackTrace) {
      Error.throwWithStackTrace(const InvalidResponseException(), stackTrace);
    }
  }
}

class WaterLogStatPoint {
  const WaterLogStatPoint({required this.bucket, required this.values});

  /// Nhãn bucket, vd '2026-10-01' (ngày) hoặc tuần.
  final String bucket;

  /// field -> {count, avg, min, max}.
  final Map<String, WaterLogParamStat> values;

  static WaterLogStatPoint parse(Map<String, dynamic> json) {
    try {
      final values = <String, WaterLogParamStat>{};
      json.forEach((key, value) {
        if (key == 'bucket' || value == null) return;
        values[key] = WaterLogParamStat.parse(value as Map<String, dynamic>);
      });
      return WaterLogStatPoint(
        bucket: json['bucket'] as String,
        values: values,
      );
    } on Object catch (_, stackTrace) {
      Error.throwWithStackTrace(const InvalidResponseException(), stackTrace);
    }
  }
}

class WaterLogStatistics {
  const WaterLogStatistics({
    required this.seasonId,
    required this.from,
    required this.to,
    required this.granularity,
    required this.totalRecords,
    required this.validRecords,
    required this.voidedRecords,
    required this.parameters,
    required this.series,
  });

  final String seasonId;
  final DateTime from;
  final DateTime to;
  final String granularity;
  final int totalRecords;
  final int validRecords;
  final int voidedRecords;

  /// field -> thống kê.
  final Map<String, WaterLogParamStat> parameters;
  final List<WaterLogStatPoint> series;

  static WaterLogStatistics parse(Map<String, dynamic> json) {
    try {
      final summary = json['summary'] as Map<String, dynamic>;
      final rawParams = summary['parameters'] as Map<String, dynamic>;
      final parameters = <String, WaterLogParamStat>{};
      rawParams.forEach((key, value) {
        parameters[key] = WaterLogParamStat.parse(
          value as Map<String, dynamic>,
        );
      });
      final rawSeries = json['series'] as List<dynamic>;
      return WaterLogStatistics(
        seasonId: json['seasonId'] as String,
        from: DateTime.parse(json['from'] as String),
        to: DateTime.parse(json['to'] as String),
        granularity: json['granularity'] as String,
        totalRecords: summary['totalRecords'] as int,
        validRecords: summary['validRecords'] as int,
        voidedRecords: summary['voidedRecords'] as int,
        parameters: parameters,
        series: rawSeries
            .map((e) => WaterLogStatPoint.parse(e as Map<String, dynamic>))
            .toList(growable: false),
      );
    } on Object catch (_, stackTrace) {
      Error.throwWithStackTrace(const InvalidResponseException(), stackTrace);
    }
  }
}
