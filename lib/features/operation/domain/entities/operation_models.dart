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
    this.mealNumber,
    this.plannedTime,
    this.dueAtMinutes,
    this.instructions,
    this.protocol,
  });

  final String id;
  final int? mealNumber;
  final String? plannedTime;
  final int? dueAtMinutes;
  final String? instructions;
  final OperationProtocol? protocol;

  factory OperationProtocolItem.fromJson(Map<String, dynamic> json) =>
      OperationProtocolItem(
        id: json['id'] as String,
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
  });

  final String scheduleId;
  final double actualQuantity;
  final String idempotencyKey;
  final String? actualProductId;
  final String? note;
  final String? varianceReason;
  final DateTime? executedAt;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'scheduleId': scheduleId,
    'actualQuantity': actualQuantity,
    'idempotencyKey': idempotencyKey,
    'actualProductId': ?actualProductId,
    if (note != null && note!.isNotEmpty) 'note': note,
    if (varianceReason != null && varianceReason!.isNotEmpty)
      'varianceReason': varianceReason,
    if (executedAt != null) 'executedAt': executedAt!.toUtc().toIso8601String(),
  };
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
    this.availableStock,
    this.hasSufficientStock,
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
    if (status != OperationStatus.planned) return false;
    final deadline = deadlineAt;
    return deadline != null && now.isAfter(deadline);
  }

  bool get isOverdue => isOverdueAt(DateTime.now());

  /// Khớp `timingComparison` ở BE: bản ghi đã thực hiện sau mốc `scheduledAt + dueAtMinutes`.
  bool get wasExecutedLate {
    final execAt = execution?.executedAt;
    final deadline = deadlineAt;
    if (execAt == null || deadline == null) return false;
    return execAt.isAfter(deadline);
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
    final caseId = protocolItem?.protocol?.diseaseCaseId;
    if (caseId != null && caseId.isNotEmpty) return true;
    final type = protocolItem?.protocol?.protocolType?.toUpperCase();
    if (type == 'TREATMENT') return true;
    final title = protocolItem?.protocol?.title.toLowerCase();
    if (title != null && (title.contains('điều trị') || title.contains('ca bệnh'))) {
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
    this.seasonStartDate,
  });

  final OperationSummary summary;
  final OperationBanner banner;
  final List<OperationSchedule> schedules;
  final String? seasonName;
  final String? pondName;
  final DateTime? seasonStartDate;

  factory OperationListResult.fromJson(Map<String, dynamic> json) {
    final season = json['season'] as Map<String, dynamic>?;
    final pond = season?['pond'] as Map<String, dynamic>?;
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

  /// Gom nhóm cữ vận hành:
  /// - Phác đồ điều trị: gom các thành phần CÙNG THỜI GIAN trong ngày thành box "Điều trị".
  ///   Nếu khác thời gian, tách riêng hoàn toàn.
  /// - Phác đồ nuôi thông thường: gom thức ăn + thuốc theo CÙNG NGÀY và CÙNG CỮ (hoặc cùng giờ).
  static List<FeedingMedicineMealGroup> group(
    List<OperationSchedule> schedules,
  ) {
    final groups = <FeedingMedicineMealGroup>[];

    final sorted = List<OperationSchedule>.from(schedules)
      ..sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));

    for (final s in sorted) {
      final isTreat = s.isTreatment;
      if (!isTreat &&
          s.operationType != OperationType.feeding &&
          s.operationType != OperationType.medicine) {
        continue;
      }

      final local = s.scheduledAt.toLocal();
      final dateStr =
          '${local.year.toString().padLeft(4, '0')}-${local.month.toString().padLeft(2, '0')}-${local.day.toString().padLeft(2, '0')}';
      final timeStr =
          '${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}';

      if (isTreat) {
        // === PHÁC ĐỒ ĐIỀU TRỊ ===
        // Box "Điều trị" thay vì cữ.
        // Gom các thành phần có CÙNG THỜI GIAN trong ngày. Nếu khác thời gian thì tách riêng hoàn toàn.
        FeedingMedicineMealGroup? matchedGroup;
        for (final g in groups) {
          if (!g.isTreatment) continue;
          final gLocal = g.scheduledAt.toLocal();
          final isSameDay = gLocal.year == local.year &&
              gLocal.month == local.month &&
              gLocal.day == local.day;
          if (isSameDay && g.time == timeStr) {
            matchedGroup = g;
            break;
          }
        }

        if (matchedGroup != null) {
          if (s.operationType == OperationType.feeding) {
            matchedGroup.feedings.add(s);
          } else if (s.operationType == OperationType.medicine) {
            matchedGroup.medicines.add(s);
          } else {
            matchedGroup.otherItems.add(s);
          }
        } else {
          final groupKey = '${dateStr}_treatment_$timeStr';
          groups.add(
            FeedingMedicineMealGroup(
              key: groupKey,
              mealNumber: null,
              time: timeStr,
              scheduledAt: s.scheduledAt,
              isTreatment: true,
              treatmentTitle: s.protocolItem?.protocol?.title,
              feedings: s.operationType == OperationType.feeding
                  ? <OperationSchedule>[s]
                  : <OperationSchedule>[],
              medicines: s.operationType == OperationType.medicine
                  ? <OperationSchedule>[s]
                  : <OperationSchedule>[],
              otherItems: (s.operationType != OperationType.feeding &&
                      s.operationType != OperationType.medicine)
                  ? <OperationSchedule>[s]
                  : <OperationSchedule>[],
            ),
          );
        }
      } else {
        // === PHÁC ĐỒ NUÔI THÔNG THƯỜNG ===
        final mealNum = s.protocolItem?.mealNumber;
        FeedingMedicineMealGroup? matchedGroup;
        for (final g in groups) {
          if (g.isTreatment) continue;
          final gLocal = g.scheduledAt.toLocal();
          final isSameDay = gLocal.year == local.year &&
              gLocal.month == local.month &&
              gLocal.day == local.day;

          if (!isSameDay) continue;

          if (mealNum != null && g.mealNumber != null) {
            if (mealNum == g.mealNumber) {
              matchedGroup = g;
              break;
            }
          } else if (g.time == timeStr) {
            matchedGroup = g;
            break;
          }
        }

        if (matchedGroup != null) {
          if (matchedGroup.mealNumber == null && mealNum != null) {
            matchedGroup.mealNumber = mealNum;
          }
          if (s.operationType == OperationType.feeding) {
            matchedGroup.feedings.add(s);
          } else if (s.operationType == OperationType.medicine) {
            matchedGroup.medicines.add(s);
          }
        } else {
          final groupKey = mealNum != null
              ? '${dateStr}_meal_$mealNum'
              : '${dateStr}_time_$timeStr';

          groups.add(
            FeedingMedicineMealGroup(
              key: groupKey,
              mealNumber: mealNum,
              time: timeStr,
              scheduledAt: s.scheduledAt,
              isTreatment: false,
              feedings: s.operationType == OperationType.feeding
                  ? <OperationSchedule>[s]
                  : <OperationSchedule>[],
              medicines: s.operationType == OperationType.medicine
                  ? <OperationSchedule>[s]
                  : <OperationSchedule>[],
            ),
          );
        }
      }
    }

    groups.sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
    return groups;
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
    return '$time - $endStr';
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
    if (isTreatment) return 'Điều trị';
    return mealNumber != null ? 'Cữ $mealNumber' : 'Cữ ăn';
  }

  String get title => isTreatment
      ? 'Điều trị ($time)'
      : (mealNumber != null ? 'Cữ $mealNumber ($time)' : 'Cữ $time');

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
