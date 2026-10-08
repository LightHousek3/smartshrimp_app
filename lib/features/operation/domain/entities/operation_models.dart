enum OperationType {
  feeding,
  mineral,
  chemical,
  medicine,
  other;

  String get displayName => switch (this) {
    feeding => 'Cho ăn',
    mineral => 'Khoáng',
    chemical => 'Hóa chất',
    medicine => 'Thuốc điều trị',
    other => 'Khác',
  };

  static OperationType parse(String? value) => switch (value?.toUpperCase()) {
    'FEEDING' => OperationType.feeding,
    'MINERAL' => OperationType.mineral,
    'CHEMICAL' => OperationType.chemical,
    'MEDICINE' => OperationType.medicine,
    _ => OperationType.other,
  };
}

enum OperationStatus {
  planned,
  completed,
  cancelled;

  String get displayName => switch (this) {
    planned => 'Đã lên lịch',
    completed => 'Đã thực hiện',
    cancelled => 'Đã hủy',
  };

  static OperationStatus parse(String? value) => switch (value?.toUpperCase()) {
    'COMPLETED' => OperationStatus.completed,
    'CANCELLED' => OperationStatus.cancelled,
    _ => OperationStatus.planned,
  };
}

double _asDouble(dynamic value, [double defaultValue = 0.0]) {
  if (value == null) return defaultValue;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? defaultValue;
  return defaultValue;
}

double? _asNullableDouble(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}

int _asInt(dynamic value, [int defaultValue = 0]) {
  if (value == null) return defaultValue;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value) ?? defaultValue;
  return defaultValue;
}

int? _asNullableInt(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}

class OperationProduct {
  const OperationProduct({
    required this.id,
    required this.name,
    this.category,
    this.unit,
  });

  final String id;
  final String name;
  final String? category;
  final String? unit;

  factory OperationProduct.fromJson(Map<String, dynamic> json) =>
      OperationProduct(
        id: json['id'] as String,
        name: json['name'] as String,
        category: json['category'] as String?,
        unit: json['unit'] as String?,
      );
}

class OperationProtocol {
  const OperationProtocol({
    required this.id,
    required this.title,
    this.versionNo,
    this.allowedVariancePct,
    this.protocolType,
  });

  final String id;
  final String title;
  final int? versionNo;
  final double? allowedVariancePct;
  final String? protocolType;

  factory OperationProtocol.fromJson(Map<String, dynamic> json) =>
      OperationProtocol(
        id: json['id'] as String,
        title: json['title'] as String,
        versionNo: _asNullableInt(json['versionNo']),
        allowedVariancePct: _asNullableDouble(json['allowedVariancePct']),
        protocolType: json['protocolType'] as String?,
      );
}

class OperationProtocolItem {
  const OperationProtocolItem({
    required this.id,
    this.mealNumber,
    this.plannedTime,
    this.instructions,
    this.recommendedProductName,
    this.protocol,
  });

  final String id;
  final int? mealNumber;
  final String? plannedTime;
  final String? instructions;
  final String? recommendedProductName;
  final OperationProtocol? protocol;

  factory OperationProtocolItem.fromJson(Map<String, dynamic> json) =>
      OperationProtocolItem(
        id: json['id'] as String,
        mealNumber: _asNullableInt(json['mealNumber']),
        plannedTime: json['plannedTime'] as String?,
        instructions: json['instructions'] as String?,
        recommendedProductName: json['recommendedProductName'] as String?,
        protocol: json['protocol'] is Map<String, dynamic>
            ? OperationProtocol.fromJson(
                json['protocol'] as Map<String, dynamic>,
              )
            : null,
      );
}

class OperationExecution {
  const OperationExecution({
    required this.id,
    required this.actualQuantity,
    required this.executedAt,
    this.actualProductId,
    this.note,
    this.varianceReason,
    this.actualProduct,
  });

  final String id;
  final double actualQuantity;
  final DateTime executedAt;
  final String? actualProductId;
  final String? note;
  final String? varianceReason;
  final OperationProduct? actualProduct;

  factory OperationExecution.fromJson(Map<String, dynamic> json) =>
      OperationExecution(
        id: json['id'] as String,
        actualQuantity: _asDouble(json['actualQuantity']),
        executedAt: DateTime.parse(json['executedAt'] as String),
        actualProductId: json['actualProductId'] as String?,
        note: json['note'] as String?,
        varianceReason: json['varianceReason'] as String?,
        actualProduct: json['actualProduct'] is Map<String, dynamic>
            ? OperationProduct.fromJson(
                json['actualProduct'] as Map<String, dynamic>,
              )
            : null,
      );
}

class OperationSchedule {
  const OperationSchedule({
    required this.id,
    required this.seasonId,
    required this.protocolItemId,
    required this.operationType,
    required this.scheduledAt,
    required this.plannedQuantity,
    required this.unit,
    required this.doseBasisSnapshot,
    required this.doseValueSnapshot,
    required this.calculationVersion,
    required this.status,
    this.basisQuantity,
    this.basisUnit,
    this.cancellationType,
    this.cancellationReason,
    this.cancelledAt,
    this.product,
    this.protocolItem,
    this.execution,
    this.seasonName,
    this.pondName,
  });

  final String id;
  final String seasonId;
  final String protocolItemId;
  final OperationType operationType;
  final DateTime scheduledAt;
  final double plannedQuantity;
  final String unit;
  final String doseBasisSnapshot;
  final double doseValueSnapshot;
  final String calculationVersion;
  final OperationStatus status;
  final double? basisQuantity;
  final String? basisUnit;
  final String? cancellationType;
  final String? cancellationReason;
  final DateTime? cancelledAt;
  final OperationProduct? product;
  final OperationProtocolItem? protocolItem;
  final OperationExecution? execution;
  final String? seasonName;
  final String? pondName;

  String get productName =>
      product?.name ??
      protocolItem?.recommendedProductName ??
      'Sản phẩm vận hành';

  String get doseBasisDescription => switch (doseBasisSnapshot.toUpperCase()) {
    'PERCENT_BIOMASS' => 'Theo % sinh khối',
    'PER_KG_BIOMASS' => 'Theo kg sinh khối',
    'PER_M3_WATER' => 'Theo m³ nước',
    _ => 'Số lượng cố định',
  };

  factory OperationSchedule.fromJson(
    Map<String, dynamic> json,
  ) {
    final season = json['season'] as Map<String, dynamic>?;
    final pond = season?['pond'] as Map<String, dynamic>?;

    return OperationSchedule(
      id: json['id'] as String,
      seasonId: json['seasonId'] as String,
      protocolItemId: json['protocolItemId'] as String,
      operationType: OperationType.parse(json['operationType'] as String?),
      scheduledAt: DateTime.parse(json['scheduledAt'] as String),
      plannedQuantity: _asDouble(json['plannedQuantity']),
      unit: json['unit'] as String? ?? '',
      doseBasisSnapshot: json['doseBasisSnapshot'] as String? ?? 'FIXED_QUANTITY',
      doseValueSnapshot: _asDouble(json['doseValueSnapshot']),
      calculationVersion: json['calculationVersion'] as String? ?? 'v1',
      status: OperationStatus.parse(json['status'] as String?),
      basisQuantity: _asNullableDouble(json['basisQuantity']),
      basisUnit: json['basisUnit'] as String?,
      cancellationType: json['cancellationType'] as String?,
      cancellationReason: json['cancellationReason'] as String?,
      cancelledAt: json['cancelledAt'] != null
          ? DateTime.parse(json['cancelledAt'] as String)
          : null,
      product: json['product'] is Map<String, dynamic>
          ? OperationProduct.fromJson(json['product'] as Map<String, dynamic>)
          : null,
      protocolItem: json['protocolItem'] is Map<String, dynamic>
          ? OperationProtocolItem.fromJson(
              json['protocolItem'] as Map<String, dynamic>,
            )
          : null,
      execution: json['execution'] is Map<String, dynamic>
          ? OperationExecution.fromJson(json['execution'] as Map<String, dynamic>)
          : null,
      seasonName: (season?['name'] ?? json['seasonName']) as String?,
      pondName: (pond?['name'] ?? json['pondName']) as String?,
    );
  }
}

class OperationSummary {
  const OperationSummary({
    required this.planned,
    required this.completed,
    required this.cancelled,
    required this.total,
  });

  final int planned;
  final int completed;
  final int cancelled;
  final int total;

  factory OperationSummary.fromJson(Map<String, dynamic> json) =>
      OperationSummary(
        planned: _asInt(json['planned']),
        completed: _asInt(json['completed']),
        cancelled: _asInt(json['cancelled']),
        total: _asInt(json['total']),
      );
}

class OperationBanner {
  const OperationBanner({required this.hasBiomassWarning, this.message});

  final bool hasBiomassWarning;
  final String? message;

  factory OperationBanner.fromJson(Map<String, dynamic> json) =>
      OperationBanner(
        hasBiomassWarning: json['hasBiomassWarning'] as bool? ?? false,
        message: json['message'] as String?,
      );
}

class OperationListResult {
  const OperationListResult({
    required this.summary,
    required this.banner,
    required this.schedules,
    this.seasonName,
    this.pondName,
  });

  final OperationSummary summary;
  final OperationBanner banner;
  final List<OperationSchedule> schedules;
  final String? seasonName;
  final String? pondName;

  factory OperationListResult.fromJson(Map<String, dynamic> json) {
    final season = json['season'] as Map<String, dynamic>?;
    final pond = season?['pond'] as Map<String, dynamic>?;

    return OperationListResult(
      summary: json['summary'] is Map<String, dynamic>
          ? OperationSummary.fromJson(json['summary'] as Map<String, dynamic>)
          : const OperationSummary(
              planned: 0,
              completed: 0,
              cancelled: 0,
              total: 0,
            ),
      banner: json['banner'] is Map<String, dynamic>
          ? OperationBanner.fromJson(json['banner'] as Map<String, dynamic>)
          : const OperationBanner(hasBiomassWarning: false),
      schedules: (json['schedules'] as List<dynamic>? ?? <dynamic>[])
          .map((e) {
            final sMap = e as Map<String, dynamic>;
            if (!sMap.containsKey('season') && season != null) {
              return OperationSchedule.fromJson({
                ...sMap,
                'season': season,
              });
            }
            return OperationSchedule.fromJson(sMap);
          })
          .toList(growable: false),
      seasonName: season?['name'] as String?,
      pondName: pond?['name'] as String?,
    );
  }
}

class OperationTypeStats {
  const OperationTypeStats({
    required this.total,
    required this.planned,
    required this.completed,
    required this.cancelled,
  });

  final int total;
  final int planned;
  final int completed;
  final int cancelled;

  factory OperationTypeStats.fromJson(Map<String, dynamic> json) =>
      OperationTypeStats(
        total: _asInt(json['total']),
        planned: _asInt(json['planned']),
        completed: _asInt(json['completed']),
        cancelled: _asInt(json['cancelled']),
      );
}

class OperationStats {
  const OperationStats({
    required this.total,
    required this.planned,
    required this.completed,
    required this.cancelled,
    required this.overdue,
    required this.completionRate,
    required this.byType,
  });

  final int total;
  final int planned;
  final int completed;
  final int cancelled;
  final int overdue;
  final double completionRate;
  final Map<String, OperationTypeStats> byType;

  factory OperationStats.fromJson(Map<String, dynamic> json) {
    final rawByType =
        json['byType'] as Map<String, dynamic>? ?? <String, dynamic>{};
    final byType = <String, OperationTypeStats>{};
    for (final entry in rawByType.entries) {
      if (entry.value is Map<String, dynamic>) {
        byType[entry.key] = OperationTypeStats.fromJson(
          entry.value as Map<String, dynamic>,
        );
      }
    }

    return OperationStats(
      total: _asInt(json['total']),
      planned: _asInt(json['planned']),
      completed: _asInt(json['completed']),
      cancelled: _asInt(json['cancelled']),
      overdue: _asInt(json['overdue']),
      completionRate: _asDouble(json['completionRate']),
      byType: byType,
    );
  }
}
