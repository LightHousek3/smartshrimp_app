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
    this.description,
    this.withdrawalDays,
    this.usageInstructions,
    this.imageUrls = const <String>[],
  });

  final String id;
  final String name;
  final String? category;
  final String? unit;
  final String? description;
  final double? withdrawalDays;
  final String? usageInstructions;
  final List<String>? imageUrls;

  String? get primaryImageUrl {
    final urls = imageUrls;
    if (urls == null) return null;
    for (final url in urls) {
      final trimmed = url.trim();
      if (trimmed.isNotEmpty) return trimmed;
    }
    return null;
  }

  factory OperationProduct.fromJson(Map<String, dynamic> json) {
    final compliance = json['compliance'] as Map<String, dynamic>?;
    final rawUrls = json['imageUrls'];
    final urls = rawUrls is List
        ? rawUrls
              .whereType<String>()
              .map((u) => u.trim())
              .where((u) => u.isNotEmpty)
              .toList(growable: false)
        : (json['imageUrl'] is String &&
              (json['imageUrl'] as String).trim().isNotEmpty)
        ? <String>[(json['imageUrl'] as String).trim()]
        : const <String>[];
    return OperationProduct(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String?,
      unit: json['unit'] as String?,
      description: json['description'] as String?,
      withdrawalDays: _asNullableDouble(
        compliance?['withdrawalDays'] ?? json['withdrawalDays'],
      ),
      usageInstructions:
          (compliance?['usageInstructions'] ?? json['usageInstructions'])
              as String?,
      imageUrls: urls,
    );
  }
}

class OperationProtocol {
  const OperationProtocol({
    required this.id,
    required this.title,
    this.versionNo,
    this.allowedVariancePct,
    this.protocolType,
    this.diseaseCaseId,
  });

  final String id;
  final String title;
  final int? versionNo;
  final double? allowedVariancePct;
  final String? protocolType;
  final String? diseaseCaseId;

  factory OperationProtocol.fromJson(Map<String, dynamic> json) =>
      OperationProtocol(
        id: json['id'] as String,
        title: json['title'] as String,
        versionNo: _asNullableInt(json['versionNo']),
        allowedVariancePct: _asNullableDouble(json['allowedVariancePct']),
        protocolType: json['protocolType'] as String?,
        diseaseCaseId: json['diseaseCaseId'] as String?,
      );
}

class OperationProtocolItem {
  const OperationProtocolItem({
    required this.id,
    this.productionMealId,
    this.mealNumber,
    this.plannedTime,
    this.dueAtMinutes,
    this.instructions,
    this.protocol,
  });

  final String id;
  final String? productionMealId;
  final int? mealNumber;
  final String? plannedTime;
  final int? dueAtMinutes;
  final String? instructions;
  final OperationProtocol? protocol;

  factory OperationProtocolItem.fromJson(Map<String, dynamic> json) =>
      OperationProtocolItem(
        id: json['id'] as String,
        productionMealId: json['productionMealId'] as String?,
        mealNumber: _asNullableInt(json['mealNumber']),
        plannedTime: json['plannedTime'] as String?,
        dueAtMinutes: _asNullableInt(json['dueAtMinutes']),
        instructions: json['instructions'] as String?,
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

class OperationExecuteBatchItem {
  const OperationExecuteBatchItem({
    required this.scheduleId,
    required this.actualQuantity,
    required this.idempotencyKey,
    this.actualProductId,
    this.note,
    this.varianceReason,
    this.executedAt,
    this.historicalOccurrence,
  });

  final String scheduleId;
  final double actualQuantity;
  final String idempotencyKey;
  final String? actualProductId;
  final String? note;
  final String? varianceReason;
  final DateTime? executedAt;
  final HistoricalFeedingOccurrence? historicalOccurrence;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'scheduleId': scheduleId,
    'actualQuantity': actualQuantity,
    'idempotencyKey': idempotencyKey,
    'actualProductId': ?actualProductId,
    if (historicalOccurrence case final occurrence?)
      'historicalOccurrence': {
        'seasonId': occurrence.seasonId,
        'scheduledAt': occurrence.scheduledAt.toUtc().toIso8601String(),
      },
    if (note != null && note!.isNotEmpty) 'note': note,
    if (varianceReason != null && varianceReason!.isNotEmpty)
      'varianceReason': varianceReason,
    if (executedAt != null) 'executedAt': executedAt!.toUtc().toIso8601String(),
  };
}

typedef HistoricalFeedingOccurrence = ({String seasonId, DateTime scheduledAt});

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
    this.availableStock,
    this.hasSufficientStock,
    this.activatedAt,
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
  final double? availableStock;
  final bool? hasSufficientStock;
  final DateTime? activatedAt;

  static const double _stockEpsilon = 1e-9;

  bool get isStockInsufficientForPlanned {
    if (status != OperationStatus.planned) return false;
    if (hasSufficientStock == false) return true;
    final stock = availableStock;
    return stock != null && stock + _stockEpsilon < plannedQuantity;
  }

  bool isStockInsufficientFor(double quantity) {
    final stock = availableStock;
    if (stock == null) return hasSufficientStock == false;
    return quantity > stock + _stockEpsilon;
  }

  String get productName => product?.name ?? 'Sản phẩm vận hành';

  String? get productImageUrl => product?.primaryImageUrl;

  DateTime? get deadlineAt {
    final mins = protocolItem?.dueAtMinutes;
    if (mins == null || mins < 0) return null;
    return scheduledAt.add(Duration(minutes: mins));
  }

  /// Khớp chính xác `timingComparison` ở BE (`protocolExecution.js`):
  /// lịch đang ở trạng thái `PLANNED` và đã vượt quá mốc `scheduledAt + dueAtMinutes`.
  bool isOverdueAt(DateTime now) {
    if (activatedAt != null) return false;
    if (status != OperationStatus.planned) return false;
    return isLateAt(now);
  }

  bool get isOverdue => isOverdueAt(DateTime.now());

  bool isLateAt(DateTime time) => deadlineAt?.isBefore(time) ?? false;

  bool requiresExecutionNote(DateTime executedAt) =>
      activatedAt != null || isLateAt(executedAt);

  /// Khớp `timingComparison` ở BE: bản ghi đã thực hiện sau mốc `scheduledAt + dueAtMinutes`.
  bool get wasExecutedLate {
    final execAt = execution?.executedAt;
    return execAt != null && isLateAt(execAt);
  }

  /// Chỉ cho phép ghi nhận từ đúng giờ dự kiến trở đi (đúng giờ hoặc trễ hạn),
  /// không cho phép ghi nhận trước `scheduledAt`.
  bool isBeforeScheduledAt(DateTime now) =>
      status == OperationStatus.planned && now.isBefore(scheduledAt);

  bool get isBeforeScheduled => isBeforeScheduledAt(DateTime.now());

  bool canExecuteAt(DateTime now) =>
      status == OperationStatus.planned && !now.isBefore(scheduledAt);

  bool get canExecute => canExecuteAt(DateTime.now());

  /// Thuộc phác đồ điều trị (TREATMENT protocol hoặc gắn với ca bệnh)
  bool get isTreatment {
    final type = protocolItem?.protocol?.protocolType?.toUpperCase();
    if (type == 'TREATMENT' || type == 'PRODUCTION') return type == 'TREATMENT';
    final caseId = protocolItem?.protocol?.diseaseCaseId;
    if (caseId != null && caseId.isNotEmpty) return true;
    final title = protocolItem?.protocol?.title.toLowerCase();
    if (title != null &&
        (title.contains('điều trị') || title.contains('ca bệnh'))) {
      return true;
    }
    final reason = cancellationReason?.toLowerCase();
    if (reason != null && reason.contains('khỏi bệnh')) return true;
    return false;
  }

  String _fmtHm(DateTime dt) {
    final local = dt.toLocal();
    return '${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}';
  }

  /// Khoảng giờ dự kiến - deadline (vd: "07:30 - 08:00" nếu có dueAtMinutes > 0, hoặc "07:30").
  String get timeRangeText {
    final start = _fmtHm(scheduledAt);
    final mins = protocolItem?.dueAtMinutes;
    final end = deadlineAt;
    if (end == null || mins == null || mins <= 0) return start;
    return '$start - ${_fmtHm(end)}';
  }

  String get doseBasisDescription => switch (doseBasisSnapshot.toUpperCase()) {
    'PERCENT_BIOMASS' => 'Theo % sinh khối',
    'PER_KG_BIOMASS' => 'Theo kg sinh khối',
    'PER_M3_WATER' => 'Theo m³ nước',
    _ => 'Số lượng cố định',
  };

  factory OperationSchedule.fromJson(Map<String, dynamic> json) {
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
      doseBasisSnapshot:
          json['doseBasisSnapshot'] as String? ?? 'FIXED_QUANTITY',
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
          ? OperationExecution.fromJson(
              json['execution'] as Map<String, dynamic>,
            )
          : null,
      seasonName: (season?['name'] ?? json['seasonName']) as String?,
      pondName: (pond?['name'] ?? json['pondName']) as String?,
      availableStock: _asNullableDouble(json['availableStock']),
      hasSufficientStock: json['hasSufficientStock'] as bool?,
      activatedAt: json['beforeActivation'] == true
          ? DateTime.parse(json['activatedAt'] as String)
          : null,
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

  factory OperationSummary.fromStatuses(Iterable<OperationStatus> statuses) {
    final counts = <OperationStatus, int>{};
    var total = 0;
    for (final status in statuses) {
      counts.update(status, (count) => count + 1, ifAbsent: () => 1);
      total++;
    }
    return OperationSummary(
      planned: counts[OperationStatus.planned] ?? 0,
      completed: counts[OperationStatus.completed] ?? 0,
      cancelled: counts[OperationStatus.cancelled] ?? 0,
      total: total,
    );
  }
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
    this.seasonStartDate,
    this.historicalFeedingAvailable = false,
    this.historicalSchedules = const [],
    this.nextPage,
  });

  final OperationSummary summary;
  final OperationBanner banner;
  final List<OperationSchedule> schedules;
  final String? seasonName;
  final String? pondName;
  final DateTime? seasonStartDate;
  final bool historicalFeedingAvailable;
  final List<OperationSchedule> historicalSchedules;
  final int? nextPage;

  factory OperationListResult.fromJson(Map<String, dynamic> json) {
    final season = json['season'] as Map<String, dynamic>?;
    final pond = season?['pond'] as Map<String, dynamic>?;
    final meta = json['meta'] as Map<String, dynamic>?;
    final page = _asInt(meta?['page'], 1);
    final rawStockingDate = season?['stockingDate'];
    final rawCreatedAt = season?['createdAt'];
    DateTime? startDate;
    if (rawStockingDate is String && rawStockingDate.isNotEmpty) {
      startDate = DateTime.tryParse(rawStockingDate);
    }
    startDate ??= (rawCreatedAt is String && rawCreatedAt.isNotEmpty)
        ? DateTime.tryParse(rawCreatedAt)
        : null;

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
              return OperationSchedule.fromJson({...sMap, 'season': season});
            }
            return OperationSchedule.fromJson(sMap);
          })
          .toList(growable: false),
      seasonName: season?['name'] as String?,
      pondName: pond?['name'] as String?,
      seasonStartDate: startDate,
      historicalFeedingAvailable: json['historicalFeedingAvailable'] == true,
      nextPage: page < _asInt(meta?['totalPages']) ? page + 1 : null,
      historicalSchedules:
          (json['historicalSchedules'] as List<dynamic>? ?? const [])
              .map(
                (row) =>
                    OperationSchedule.fromJson(row as Map<String, dynamic>),
              )
              .toList(growable: false),
    );
  }

  List<FeedingMedicineMealGroup> get mealGroups =>
      FeedingMedicineMealGroup.group(schedules);
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
    this.progress,
    this.materialProgress,
    this.seasonName,
    this.pondName,
  });

  final int total;
  final int planned;
  final int completed;
  final int cancelled;
  final int overdue;
  final double completionRate;
  final Map<String, OperationTypeStats> byType;
  final OperationProgress? progress;
  final Map<String, OperationCompletion>? materialProgress;
  final String? seasonName;
  final String? pondName;

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
      progress: json['progress'] is Map<String, dynamic>
          ? OperationProgress.fromJson(json['progress'] as Map<String, dynamic>)
          : null,
      materialProgress: switch (json['materialProgress']) {
        final Map<String, dynamic> types => {
          for (final entry in types.entries)
            if (entry.value case final Map<String, dynamic> counts)
              entry.key: OperationCompletion.fromJson(counts),
        },
        _ => null,
      },
      seasonName: json['seasonName'] as String?,
      pondName: json['pondName'] as String?,
    );
  }
}

class OperationCompletion {
  const OperationCompletion({required this.started, required this.completed});

  final int started;
  final int completed;

  double get fraction => started > 0 ? completed / started : 0;

  // Only an exact match may be displayed as 100%.
  double get percentage => started > 0 ? (completed * 1000 ~/ started) / 10 : 0;

  factory OperationCompletion.fromJson(Map<String, dynamic> json) =>
      OperationCompletion(
        started: _asInt(json['started']),
        completed: _asInt(json['completed']),
      );
}

class OperationProgress extends OperationCompletion {
  const OperationProgress({
    required super.started,
    required super.completed,
    required this.waiting,
    required this.overdue,
    required this.lockedUnrecorded,
  });

  final int waiting;
  final int overdue;
  final int lockedUnrecorded;

  factory OperationProgress.fromJson(Map<String, dynamic> json) =>
      OperationProgress(
        started: _asInt(json['started']),
        completed: _asInt(json['completed']),
        waiting: _asInt(json['waiting']),
        overdue: _asInt(json['overdue']),
        lockedUnrecorded: _asInt(json['lockedUnrecorded']),
      );
}

class FeedingMedicineMealGroup {
  FeedingMedicineMealGroup({
    required this.key,
    required this.mealNumber,
    required this.time,
    required this.scheduledAt,
    required this.feedings,
    required this.medicines,
    this.isTreatment = false,
    this.treatmentTitle,
    List<OperationSchedule>? otherItems,
  }) : otherItems = otherItems ?? <OperationSchedule>[];

  final String key;
  int? mealNumber;
  final String time;
  final DateTime scheduledAt;
  final List<OperationSchedule> feedings;
  final List<OperationSchedule> medicines;
  final bool isTreatment;
  final String? treatmentTitle;
  final List<OperationSchedule> otherItems;

  /// Match numbered meals and keep independent operations separate at the same time.
  static List<FeedingMedicineMealGroup> group(
    List<OperationSchedule> schedules,
  ) {
    final groups = <String, FeedingMedicineMealGroup>{};
    final sorted = List<OperationSchedule>.from(schedules)
      ..sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));

    for (final schedule in sorted) {
      final isTreatment = schedule.isTreatment;
      final type = schedule.operationType;
      if (!isTreatment &&
          type != OperationType.feeding &&
          type != OperationType.medicine) {
        continue;
      }

      final item = schedule.protocolItem;
      final mealNumber = item?.mealNumber;
      final protocolId = item?.protocol?.id;
      final local = schedule.scheduledAt.toLocal();
      final time =
          '${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}';
      final identity =
          item?.productionMealId ??
          (mealNumber == null ? schedule.protocolItemId : 'meal:$mealNumber');
      final instant = schedule.scheduledAt.millisecondsSinceEpoch;
      final key = '$protocolId:$isTreatment:$identity:$instant';
      final group = groups.putIfAbsent(
        key,
        () => FeedingMedicineMealGroup(
          key: key,
          mealNumber: mealNumber,
          time: time,
          scheduledAt: schedule.scheduledAt,
          feedings: [],
          medicines: [],
          isTreatment: isTreatment,
          treatmentTitle: isTreatment ? item?.protocol?.title : null,
        ),
      );
      switch (type) {
        case OperationType.feeding:
          group.feedings.add(schedule);
        case OperationType.medicine:
          group.medicines.add(schedule);
        default:
          group.otherItems.add(schedule);
      }
    }

    return groups.values.toList(growable: false);
  }

  List<OperationSchedule> get allSchedules => <OperationSchedule>[
    ...feedings,
    ...medicines,
    ...otherItems,
  ];

  OperationSchedule? get primaryFeeding =>
      feedings.isNotEmpty ? feedings.first : null;

  /// Khoảng giờ thực hiện của cả cữ (vd: "07:30 - 08:00") dựa trên deadline muộn nhất trong cữ.
  String get timeRangeText {
    DateTime? latestDeadline;
    for (final s in allSchedules) {
      final mins = s.protocolItem?.dueAtMinutes;
      final d = s.deadlineAt;
      if (d != null &&
          mins != null &&
          mins > 0 &&
          (latestDeadline == null || d.isAfter(latestDeadline))) {
        latestDeadline = d;
      }
    }
    if (latestDeadline == null) return time;
    final localEnd = latestDeadline.toLocal();
    final endStr =
        '${localEnd.hour.toString().padLeft(2, '0')}:${localEnd.minute.toString().padLeft(2, '0')}';
    final localStart = scheduledAt.toLocal();
    final days = DateTime.utc(localEnd.year, localEnd.month, localEnd.day)
        .difference(
          DateTime.utc(localStart.year, localStart.month, localStart.day),
        )
        .inDays;
    return '$time - $endStr${days > 0 ? ' (+$days ngày)' : ''}';
  }

  bool isOverdueAt(DateTime now) => allSchedules.any((s) => s.isOverdueAt(now));

  bool get isOverdue => isOverdueAt(DateTime.now());

  bool get wasExecutedLate => allSchedules.any((s) => s.wasExecutedLate);

  bool isBeforeScheduledAt(DateTime now) =>
      activeSchedules.any((s) => s.isBeforeScheduledAt(now));

  bool get isBeforeScheduled => isBeforeScheduledAt(DateTime.now());

  bool canExecuteAt(DateTime now) =>
      activeSchedules.isNotEmpty &&
      activeSchedules.every((s) => s.canExecuteAt(now));

  bool get canExecute => canExecuteAt(DateTime.now());

  /// Mốc giờ muộn nhất cần chờ trong cữ để có thể bắt đầu ghi nhận cả cữ.
  DateTime get executableFromAt {
    DateTime latest = scheduledAt;
    for (final s in activeSchedules) {
      if (s.scheduledAt.isAfter(latest)) {
        latest = s.scheduledAt;
      }
    }
    return latest;
  }

  String get cardTitle {
    if (mealNumber != null) return 'Cữ $mealNumber';
    if (isTreatment) return 'Điều trị';
    return 'Cữ ăn';
  }

  String get title =>
      mealNumber != null || isTreatment ? '$cardTitle ($time)' : 'Cữ $time';

  bool get hasFeeding => feedings.isNotEmpty;
  bool get hasMedicine => medicines.isNotEmpty;
  bool get hasBoth => hasFeeding && hasMedicine;

  List<OperationSchedule> get activeSchedules => allSchedules
      .where((s) => s.status == OperationStatus.planned)
      .toList(growable: false);

  bool get hasPlanned => activeSchedules.isNotEmpty;

  /// Chọn key của cữ gần nhất / ưu tiên sổ sẵn khi mở danh sách:
  /// 1. Đang trong khung giờ thực hiện (`scheduledAt <= now <= deadline`).
  /// 2. Đang quá hạn chờ xử lý (`hasPlanned && isOverdueAt(now)`), ưu tiên cữ sớm nhất cần ghi nhận ngay.
  /// 3. Cữ có thời gian dự kiến gần `now` nhất (`|scheduledAt - now|` nhỏ nhất).
  static String? pickNearestKey(
    List<FeedingMedicineMealGroup> groups, [
    DateTime? now,
  ]) {
    if (groups.isEmpty) return null;
    final ref = now ?? DateTime.now();

    for (final g in groups) {
      if (g.hasPlanned && !g.isBeforeScheduledAt(ref) && !g.isOverdueAt(ref)) {
        return g.key;
      }
    }

    for (final g in groups) {
      if (g.hasPlanned && g.isOverdueAt(ref)) {
        return g.key;
      }
    }

    FeedingMedicineMealGroup nearest = groups.first;
    int bestDiffMs =
        (nearest.scheduledAt.millisecondsSinceEpoch -
                ref.millisecondsSinceEpoch)
            .abs();
    for (var i = 1; i < groups.length; i++) {
      final candidate = groups[i];
      final diffMs =
          (candidate.scheduledAt.millisecondsSinceEpoch -
                  ref.millisecondsSinceEpoch)
              .abs();
      if (diffMs < bestDiffMs) {
        bestDiffMs = diffMs;
        nearest = candidate;
      }
    }
    return nearest.key;
  }

  OperationStatus get overallStatus {
    if (allSchedules.isEmpty) return OperationStatus.planned;
    if (activeSchedules.isNotEmpty) return OperationStatus.planned;
    if (allSchedules.any((s) => s.status == OperationStatus.completed)) {
      return OperationStatus.completed;
    }
    if (allSchedules.every((s) => s.status == OperationStatus.cancelled)) {
      return OperationStatus.cancelled;
    }
    return OperationStatus.cancelled;
  }
}
