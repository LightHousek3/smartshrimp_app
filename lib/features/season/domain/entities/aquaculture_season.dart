import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/pond/domain/entities/pond.dart';

part 'aquaculture_season.freezed.dart';

enum SeasonStatus { planning, active, completed, cancelled, unknown }

enum ShrimpType { whiteleg, blackTiger, unknown }

SeasonStatus seasonStatusFromJson(Object? value) => switch (value) {
  'PLANNING' => SeasonStatus.planning,
  'ACTIVE' => SeasonStatus.active,
  'COMPLETED' => SeasonStatus.completed,
  'CANCELLED' => SeasonStatus.cancelled,
  _ => SeasonStatus.unknown,
};

ShrimpType shrimpTypeFromJson(Object? value) => switch (value) {
  'WHITELEG' => ShrimpType.whiteleg,
  'BLACK_TIGER' => ShrimpType.blackTiger,
  _ => ShrimpType.unknown,
};

String seasonStatusApiValue(SeasonStatus value) => switch (value) {
  SeasonStatus.planning => 'PLANNING',
  SeasonStatus.active => 'ACTIVE',
  SeasonStatus.completed => 'COMPLETED',
  SeasonStatus.cancelled => 'CANCELLED',
  SeasonStatus.unknown => throw ArgumentError.value(value, 'value'),
};

String shrimpTypeApiValue(ShrimpType value) => switch (value) {
  ShrimpType.whiteleg => 'WHITELEG',
  ShrimpType.blackTiger => 'BLACK_TIGER',
  ShrimpType.unknown => throw ArgumentError.value(value, 'value'),
};

String seasonStatusLabel(SeasonStatus value) => switch (value) {
  SeasonStatus.planning => 'Đang chuẩn bị',
  SeasonStatus.active => 'Đang nuôi',
  SeasonStatus.completed => 'Đã hoàn thành',
  SeasonStatus.cancelled => 'Đã hủy',
  SeasonStatus.unknown => 'Không xác định',
};

String shrimpTypeLabel(ShrimpType value) => switch (value) {
  ShrimpType.whiteleg => 'Tôm thẻ chân trắng',
  ShrimpType.blackTiger => 'Tôm sú',
  ShrimpType.unknown => 'Không xác định',
};

@Freezed(fromJson: false, toJson: false)
abstract class SeasonAccount with _$SeasonAccount {
  const factory SeasonAccount({
    required String id,
    required String email,
    required String fullName,
    String? phone,
    required String status,
  }) = _SeasonAccount;

  factory SeasonAccount.fromJson(Map<String, dynamic> json) => SeasonAccount(
    id: _requiredString(json, 'id'),
    email: _requiredString(json, 'email'),
    fullName: _requiredString(json, 'fullName'),
    phone: _nullableString(json['phone']),
    status: _requiredString(json, 'status'),
  );
}

@Freezed(fromJson: false, toJson: false)
abstract class SeasonAssignment with _$SeasonAssignment {
  const factory SeasonAssignment({
    required String id,
    required String role,
    required DateTime assignedAt,
    required SeasonAccount account,
    DateTime? unassignedAt,
  }) = _SeasonAssignment;

  factory SeasonAssignment.fromJson(Map<String, dynamic> json) =>
      SeasonAssignment(
        id: _requiredString(json, 'id'),
        role: _requiredString(json, 'role'),
        assignedAt: _requiredDateTime(json, 'assignedAt'),
        unassignedAt: _nullableDateTime(json['unassignedAt']),
        account: SeasonAccount.fromJson(_requiredMap(json, 'account')),
      );
}

typedef SeasonPersonnelReplacementResult = ({
  SeasonAssignment assignment,
  int transferredTaskCount,
  int transferredDiseaseCaseCount,
});

@Freezed(fromJson: false, toJson: false)
abstract class SeasonPersonnel with _$SeasonPersonnel {
  const factory SeasonPersonnel({
    SeasonAssignment? technician,
    SeasonAssignment? expert,
  }) = _SeasonPersonnel;

  factory SeasonPersonnel.fromJson(Map<String, dynamic> json) {
    final technician = _nullableMap(json['technician']);
    final expert = _nullableMap(json['expert']);
    return SeasonPersonnel(
      technician: technician == null
          ? null
          : SeasonAssignment.fromJson(technician),
      expert: expert == null ? null : SeasonAssignment.fromJson(expert),
    );
  }
}

@Freezed(fromJson: false, toJson: false)
abstract class SeasonProtocol with _$SeasonProtocol {
  const factory SeasonProtocol({
    required String id,
    required String title,
    required int versionNo,
    required String status,
    DateTime? reviewedAt,
  }) = _SeasonProtocol;

  factory SeasonProtocol.fromJson(Map<String, dynamic> json) => SeasonProtocol(
    id: _requiredString(json, 'id'),
    title: _requiredString(json, 'title'),
    versionNo: _requiredInt(json, 'versionNo'),
    status: _requiredString(json, 'status'),
    reviewedAt: _nullableDateTime(json['reviewedAt']),
  );
}

@Freezed(fromJson: false, toJson: false)
abstract class ActivationEligibility with _$ActivationEligibility {
  const factory ActivationEligibility({
    required bool canActivate,
    required List<String> missingConditions,
  }) = _ActivationEligibility;

  factory ActivationEligibility.fromJson(Map<String, dynamic> json) {
    final conditions = json['missingConditions'];
    if (json['canActivate'] is! bool || conditions is! List<dynamic>) {
      throw const InvalidResponseException();
    }
    return ActivationEligibility(
      canActivate: json['canActivate']! as bool,
      missingConditions: conditions
          .map((value) {
            if (value is! String) throw const InvalidResponseException();
            return value;
          })
          .toList(growable: false),
    );
  }
}

@Freezed(fromJson: false, toJson: false)
abstract class SeasonActions with _$SeasonActions {
  const factory SeasonActions({
    required bool update,
    required bool activate,
    required bool cancel,
  }) = _SeasonActions;

  factory SeasonActions.fromJson(Map<String, dynamic> json) {
    if (json['update'] is! bool ||
        json['activate'] is! bool ||
        json['cancel'] is! bool) {
      throw const InvalidResponseException();
    }
    return SeasonActions(
      update: json['update']! as bool,
      activate: json['activate']! as bool,
      cancel: json['cancel']! as bool,
    );
  }
}

@Freezed(fromJson: false, toJson: false)
abstract class AquacultureSeason with _$AquacultureSeason {
  const AquacultureSeason._();

  const factory AquacultureSeason({
    required String id,
    required String pondId,
    required String name,
    required ShrimpType shrimpType,
    required SeasonStatus status,
    required String createdBy,
    required DateTime createdAt,
    required DateTime updatedAt,
    required Pond pond,
    DateTime? stockingDate,
    DateTime? expectedEndDate,
    DateTime? actualEndDate,
    int? initialQuantity,
    double? initialAvgWeightG,
    double? initialBiomassKg,
    double? initialDensityPerM2,
    String? cancellationReason,
    int? dayOfCulture,
    SeasonPersonnel? personnel,
    SeasonPersonnel? lastAssignedPersonnel,
    SeasonProtocol? approvedProductionProtocol,
    ActivationEligibility? activationEligibility,
    SeasonActions? availableActions,
  }) = _AquacultureSeason;

  factory AquacultureSeason.fromJson(Map<String, dynamic> json) {
    try {
      final personnel = _nullableMap(json['personnel']);
      final lastAssignedPersonnel = _nullableMap(json['lastAssignedPersonnel']);
      final protocol = _nullableMap(json['approvedProductionProtocol']);
      final eligibility = _nullableMap(json['activationEligibility']);
      final actions = _nullableMap(json['availableActions']);
      return AquacultureSeason(
        id: _requiredString(json, 'id'),
        pondId: _requiredString(json, 'pondId'),
        name: _requiredString(json, 'name'),
        shrimpType: shrimpTypeFromJson(json['shrimpType']),
        stockingDate: _nullableDateOnly(json['stockingDate']),
        expectedEndDate: _nullableDateOnly(json['expectedEndDate']),
        actualEndDate: _nullableDateOnly(json['actualEndDate']),
        initialQuantity: _nullableInt(json['initialQuantity']),
        initialAvgWeightG: _nullableDouble(json['initialAvgWeightG']),
        initialBiomassKg: _nullableDouble(json['initialBiomassKg']),
        initialDensityPerM2: _nullableDouble(json['initialDensityPerM2']),
        status: seasonStatusFromJson(json['status']),
        cancellationReason: _nullableString(json['cancellationReason']),
        createdBy: _requiredString(json, 'createdBy'),
        createdAt: _requiredDateTime(json, 'createdAt'),
        updatedAt: _requiredDateTime(json, 'updatedAt'),
        dayOfCulture: _nullableInt(json['dayOfCulture']),
        pond: Pond.parse(_requiredMap(json, 'pond')),
        personnel: personnel == null
            ? null
            : SeasonPersonnel.fromJson(personnel),
        lastAssignedPersonnel: lastAssignedPersonnel == null
            ? null
            : SeasonPersonnel.fromJson(lastAssignedPersonnel),
        approvedProductionProtocol: protocol == null
            ? null
            : SeasonProtocol.fromJson(protocol),
        activationEligibility: eligibility == null
            ? null
            : ActivationEligibility.fromJson(eligibility),
        availableActions: actions == null
            ? null
            : SeasonActions.fromJson(actions),
      );
    } on InvalidResponseException {
      rethrow;
    } on Object catch (_, stackTrace) {
      Error.throwWithStackTrace(const InvalidResponseException(), stackTrace);
    }
  }

  bool get canUpdate =>
      availableActions?.update ?? status == SeasonStatus.planning;
  bool get canActivate => availableActions?.activate ?? false;
  bool get canCancel =>
      availableActions?.cancel ??
      (status == SeasonStatus.planning || status == SeasonStatus.active);

  SeasonPersonnel? get personnelForDisplay => switch (status) {
    SeasonStatus.completed ||
    SeasonStatus.cancelled => lastAssignedPersonnel ?? personnel,
    _ => personnel,
  };
}

@Freezed(fromJson: false, toJson: false)
abstract class SeasonPage with _$SeasonPage {
  const SeasonPage._();

  const factory SeasonPage({
    required List<AquacultureSeason> items,
    required int limit,
    required int totalResults,
    required bool hasNextPage,
    String? nextCursor,
  }) = _SeasonPage;

  SeasonPage append(SeasonPage next) => SeasonPage(
    items: <AquacultureSeason>[...items, ...next.items],
    limit: next.limit,
    totalResults: next.totalResults,
    hasNextPage: next.hasNextPage,
    nextCursor: next.nextCursor,
  );
}

@Freezed(fromJson: false, toJson: false)
abstract class SeasonCancellationResult with _$SeasonCancellationResult {
  const factory SeasonCancellationResult({
    required AquacultureSeason season,
    required int cancelledScheduleCount,
  }) = _SeasonCancellationResult;

  factory SeasonCancellationResult.fromJson(Map<String, dynamic> json) =>
      SeasonCancellationResult(
        season: AquacultureSeason.fromJson(_requiredMap(json, 'season')),
        cancelledScheduleCount: _requiredInt(json, 'cancelledScheduleCount'),
      );
}

Map<String, dynamic> _requiredMap(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is! Map<String, dynamic>) throw const InvalidResponseException();
  return value;
}

Map<String, dynamic>? _nullableMap(Object? value) {
  if (value == null) return null;
  if (value is! Map<String, dynamic>) throw const InvalidResponseException();
  return value;
}

String _requiredString(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is! String || value.isEmpty) throw const InvalidResponseException();
  return value;
}

String? _nullableString(Object? value) {
  if (value == null) return null;
  if (value is! String) throw const InvalidResponseException();
  return value;
}

int _requiredInt(Map<String, dynamic> json, String key) {
  final value = _nullableInt(json[key]);
  if (value == null) throw const InvalidResponseException();
  return value;
}

int? _nullableInt(Object? value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num && value == value.roundToDouble()) return value.toInt();
  if (value is String) {
    final parsed = int.tryParse(value);
    if (parsed != null) return parsed;
  }
  throw const InvalidResponseException();
}

double? _nullableDouble(Object? value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  if (value is String) {
    final parsed = double.tryParse(value);
    if (parsed != null) return parsed;
  }
  throw const InvalidResponseException();
}

DateTime _requiredDateTime(Map<String, dynamic> json, String key) {
  final value = _nullableDateTime(json[key]);
  if (value == null) throw const InvalidResponseException();
  return value;
}

DateTime? _nullableDateTime(Object? value) {
  if (value == null) return null;
  if (value is! String) throw const InvalidResponseException();
  final parsed = DateTime.tryParse(value);
  if (parsed == null) throw const InvalidResponseException();
  return parsed;
}

DateTime? _nullableDateOnly(Object? value) {
  final parsed = _nullableDateTime(value);
  return parsed == null
      ? null
      : DateTime(parsed.year, parsed.month, parsed.day);
}
