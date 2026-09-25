import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/pond/domain/entities/pond.dart';

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

final class SeasonAccount {
  const SeasonAccount({
    required this.id,
    required this.email,
    required this.fullName,
    this.phone,
    required this.status,
  });

  factory SeasonAccount.fromJson(Map<String, dynamic> json) => SeasonAccount(
    id: _requiredString(json, 'id'),
    email: _requiredString(json, 'email'),
    fullName: _requiredString(json, 'fullName'),
    phone: _nullableString(json['phone']),
    status: _requiredString(json, 'status'),
  );

  final String id;
  final String email;
  final String fullName;
  final String? phone;
  final String status;
}

final class SeasonAssignment {
  const SeasonAssignment({
    required this.id,
    required this.role,
    required this.assignedAt,
    required this.account,
  });

  factory SeasonAssignment.fromJson(Map<String, dynamic> json) =>
      SeasonAssignment(
        id: _requiredString(json, 'id'),
        role: _requiredString(json, 'role'),
        assignedAt: _requiredDateTime(json, 'assignedAt'),
        account: SeasonAccount.fromJson(_requiredMap(json, 'account')),
      );

  final String id;
  final String role;
  final DateTime assignedAt;
  final SeasonAccount account;
}

final class SeasonPersonnel {
  const SeasonPersonnel({this.technician, this.expert});

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

  final SeasonAssignment? technician;
  final SeasonAssignment? expert;
}

final class SeasonProtocol {
  const SeasonProtocol({
    required this.id,
    required this.title,
    required this.versionNo,
    required this.status,
    this.reviewedAt,
  });

  factory SeasonProtocol.fromJson(Map<String, dynamic> json) => SeasonProtocol(
    id: _requiredString(json, 'id'),
    title: _requiredString(json, 'title'),
    versionNo: _requiredInt(json, 'versionNo'),
    status: _requiredString(json, 'status'),
    reviewedAt: _nullableDateTime(json['reviewedAt']),
  );

  final String id;
  final String title;
  final int versionNo;
  final String status;
  final DateTime? reviewedAt;
}

final class ActivationEligibility {
  const ActivationEligibility({
    required this.canActivate,
    required this.missingConditions,
  });

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

  final bool canActivate;
  final List<String> missingConditions;
}

final class SeasonActions {
  const SeasonActions({
    required this.update,
    required this.activate,
    required this.cancel,
  });

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

  final bool update;
  final bool activate;
  final bool cancel;
}

final class AquacultureSeason {
  const AquacultureSeason({
    required this.id,
    required this.pondId,
    required this.name,
    required this.shrimpType,
    required this.status,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    required this.pond,
    this.stockingDate,
    this.expectedEndDate,
    this.actualEndDate,
    this.initialQuantity,
    this.initialAvgWeightG,
    this.initialBiomassKg,
    this.initialDensityPerM2,
    this.cancellationReason,
    this.dayOfCulture,
    this.personnel,
    this.approvedProductionProtocol,
    this.activationEligibility,
    this.availableActions,
  });

  factory AquacultureSeason.fromJson(Map<String, dynamic> json) {
    try {
      final personnel = _nullableMap(json['personnel']);
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

  final String id;
  final String pondId;
  final String name;
  final ShrimpType shrimpType;
  final DateTime? stockingDate;
  final DateTime? expectedEndDate;
  final DateTime? actualEndDate;
  final int? initialQuantity;
  final double? initialAvgWeightG;
  final double? initialBiomassKg;
  final double? initialDensityPerM2;
  final SeasonStatus status;
  final String? cancellationReason;
  final String createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int? dayOfCulture;
  final Pond pond;
  final SeasonPersonnel? personnel;
  final SeasonProtocol? approvedProductionProtocol;
  final ActivationEligibility? activationEligibility;
  final SeasonActions? availableActions;

  bool get canUpdate =>
      availableActions?.update ?? status == SeasonStatus.planning;
  bool get canActivate => availableActions?.activate ?? false;
  bool get canCancel =>
      availableActions?.cancel ??
      (status == SeasonStatus.planning || status == SeasonStatus.active);
}

final class SeasonPage {
  const SeasonPage({
    required this.items,
    required this.limit,
    required this.totalResults,
    required this.hasNextPage,
    this.nextCursor,
  });

  final List<AquacultureSeason> items;
  final int limit;
  final int totalResults;
  final bool hasNextPage;
  final String? nextCursor;

  SeasonPage append(SeasonPage next) => SeasonPage(
    items: <AquacultureSeason>[...items, ...next.items],
    limit: next.limit,
    totalResults: next.totalResults,
    hasNextPage: next.hasNextPage,
    nextCursor: next.nextCursor,
  );
}

final class SeasonCancellationResult {
  const SeasonCancellationResult({
    required this.season,
    required this.cancelledScheduleCount,
  });

  factory SeasonCancellationResult.fromJson(Map<String, dynamic> json) =>
      SeasonCancellationResult(
        season: AquacultureSeason.fromJson(_requiredMap(json, 'season')),
        cancelledScheduleCount: _requiredInt(json, 'cancelledScheduleCount'),
      );

  final AquacultureSeason season;
  final int cancelledScheduleCount;
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
