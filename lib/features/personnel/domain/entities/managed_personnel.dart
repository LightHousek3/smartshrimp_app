import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/auth/domain/entities/auth_account.dart';

part 'managed_personnel.freezed.dart';
part 'managed_personnel.g.dart';

@freezed
abstract class ManagedPersonnel with _$ManagedPersonnel {
  const ManagedPersonnel._();

  const factory ManagedPersonnel({
    required String id,
    required String email,
    String? phone,
    String? fullName,
    String? avatarUrl,
    @JsonKey(unknownEnumValue: AccountRole.unknown) required AccountRole role,
    @JsonKey(unknownEnumValue: AccountStatus.unknown)
    required AccountStatus status,
    required int currentSeasonAssignments,
    required DateTime createdAt,
    DateTime? activatedAt,
    DateTime? lastLoginAt,
    DateTime? updatedAt,
  }) = _ManagedPersonnel;

  factory ManagedPersonnel.fromJson(Map<String, dynamic> json) =>
      _$ManagedPersonnelFromJson(json);

  static ManagedPersonnel parse(
    Map<String, dynamic> json, {
    bool detail = false,
  }) {
    if (json['id'] is! String ||
        (json['id'] as String).trim().isEmpty ||
        json['email'] is! String ||
        (json['email'] as String).trim().isEmpty ||
        json['role'] is! String ||
        json['status'] is! String ||
        json['createdAt'] is! String ||
        json['currentSeasonAssignments'] is! int ||
        (json['currentSeasonAssignments'] as int) < 0 ||
        (detail && json['updatedAt'] is! String)) {
      throw const InvalidResponseException();
    }

    try {
      return ManagedPersonnel.fromJson(json);
    } on Object catch (_, stackTrace) {
      Error.throwWithStackTrace(const InvalidResponseException(), stackTrace);
    }
  }

  String get displayName {
    final name = fullName?.trim();
    return name == null || name.isEmpty ? email : name;
  }

  String get initials {
    final parts = displayName
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList(growable: false);
    if (parts.isEmpty) return 'NV';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return '${parts.first.substring(0, 1)}${parts.last.substring(0, 1)}'
        .toUpperCase();
  }
}

final class ManagedPersonnelDetail {
  const ManagedPersonnelDetail({
    required this.personnel,
    required this.kpi,
    required this.currentAssignments,
    required this.assignmentHistory,
  });

  factory ManagedPersonnelDetail.parse(Map<String, dynamic> json) {
    final rawKpi = json['kpi'];
    final rawCurrentAssignments = json['currentAssignments'];
    final rawAssignmentHistory = json['assignmentHistory'];
    if (rawKpi is! Map<String, dynamic> ||
        rawCurrentAssignments is! List<dynamic> ||
        rawAssignmentHistory is! List<dynamic>) {
      throw const InvalidResponseException();
    }

    final personnel = ManagedPersonnel.parse(json, detail: true);
    return ManagedPersonnelDetail(
      personnel: personnel,
      kpi: PersonnelKpi.parse(rawKpi, personnel.role),
      currentAssignments: _parsePersonnelAssignments(
        rawCurrentAssignments,
        historical: false,
      ),
      assignmentHistory: _parsePersonnelAssignments(
        rawAssignmentHistory,
        historical: true,
      ),
    );
  }

  final ManagedPersonnel personnel;
  final PersonnelKpi kpi;
  final List<PersonnelSeasonAssignment> currentAssignments;
  final List<PersonnelSeasonAssignment> assignmentHistory;
}

final class PersonnelKpi {
  const PersonnelKpi({
    required this.seasonsParticipated,
    this.completedTasks,
    this.onTimeCompletedTasks,
    this.onTimeCompletionRatePct,
    this.diseaseCasesHandled,
    this.diseaseCasesResolved,
    this.avgResolutionHours,
  });

  factory PersonnelKpi.parse(Map<String, dynamic> json, AccountRole role) {
    final seasonsParticipated = _nonNegativeInt(json, 'seasonsParticipated');
    if (role == AccountRole.technician) {
      return PersonnelKpi(
        seasonsParticipated: seasonsParticipated,
        completedTasks: _nonNegativeInt(json, 'completedTasks'),
        onTimeCompletedTasks: _nonNegativeInt(json, 'onTimeCompletedTasks'),
        onTimeCompletionRatePct: _nullableNonNegativeNumber(
          json,
          'onTimeCompletionRatePct',
          max: 100,
        ),
      );
    }
    if (role == AccountRole.expert) {
      return PersonnelKpi(
        seasonsParticipated: seasonsParticipated,
        diseaseCasesHandled: _nonNegativeInt(json, 'diseaseCasesHandled'),
        diseaseCasesResolved: _nonNegativeInt(json, 'diseaseCasesResolved'),
        avgResolutionHours: _nullableNonNegativeNumber(
          json,
          'avgResolutionHours',
        ),
      );
    }
    throw const InvalidResponseException();
  }

  final int seasonsParticipated;
  final int? completedTasks;
  final int? onTimeCompletedTasks;
  final double? onTimeCompletionRatePct;
  final int? diseaseCasesHandled;
  final int? diseaseCasesResolved;
  final double? avgResolutionHours;
}

final class PersonnelSeasonAssignment {
  const PersonnelSeasonAssignment({
    required this.id,
    required this.seasonId,
    required this.seasonName,
    required this.farmId,
    required this.farmName,
    required this.pondId,
    required this.pondName,
    required this.assignedAt,
    this.unassignedAt,
    this.replacementReason,
  });

  factory PersonnelSeasonAssignment.parse(Map<String, dynamic> json) =>
      PersonnelSeasonAssignment(
        id: _requiredString(json, 'id'),
        seasonId: _requiredString(json, 'seasonId'),
        seasonName: _requiredString(json, 'seasonName'),
        farmId: _requiredString(json, 'farmId'),
        farmName: _requiredString(json, 'farmName'),
        pondId: _requiredString(json, 'pondId'),
        pondName: _requiredString(json, 'pondName'),
        assignedAt: _requiredDateTime(json, 'assignedAt'),
        unassignedAt: _nullableDateTime(json, 'unassignedAt'),
        replacementReason: _nullableString(json, 'replacementReason'),
      );

  final String id;
  final String seasonId;
  final String seasonName;
  final String farmId;
  final String farmName;
  final String pondId;
  final String pondName;
  final DateTime assignedAt;
  final DateTime? unassignedAt;
  final String? replacementReason;
}

List<PersonnelSeasonAssignment> _parsePersonnelAssignments(
  List<dynamic> values, {
  required bool historical,
}) => values
    .map((value) {
      if (value is! Map<String, dynamic>) {
        throw const InvalidResponseException();
      }
      final assignment = PersonnelSeasonAssignment.parse(value);
      if (historical != (assignment.unassignedAt != null)) {
        throw const InvalidResponseException();
      }
      return assignment;
    })
    .toList(growable: false);

String _requiredString(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is! String || value.trim().isEmpty) {
    throw const InvalidResponseException();
  }
  return value;
}

String? _nullableString(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value == null) return null;
  if (value is! String) throw const InvalidResponseException();
  return value;
}

DateTime _requiredDateTime(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is! String) throw const InvalidResponseException();
  final parsed = DateTime.tryParse(value);
  if (parsed == null) throw const InvalidResponseException();
  return parsed;
}

DateTime? _nullableDateTime(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value == null) return null;
  if (value is! String) throw const InvalidResponseException();
  final parsed = DateTime.tryParse(value);
  if (parsed == null) throw const InvalidResponseException();
  return parsed;
}

int _nonNegativeInt(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is! int || value < 0) throw const InvalidResponseException();
  return value;
}

double? _nullableNonNegativeNumber(
  Map<String, dynamic> json,
  String key, {
  double? max,
}) {
  final value = json[key];
  if (value == null) return null;
  if (value is! num || value < 0 || (max != null && value > max)) {
    throw const InvalidResponseException();
  }
  return value.toDouble();
}

@freezed
abstract class ManagedPersonnelPage with _$ManagedPersonnelPage {
  const factory ManagedPersonnelPage({
    required List<ManagedPersonnel> items,
    required int limit,
    required int totalResults,
    required bool hasNextPage,
    String? nextCursor,
  }) = _ManagedPersonnelPage;

  static ManagedPersonnelPage parse(Object? data, Map<String, dynamic>? meta) {
    if (data is! List ||
        meta == null ||
        meta['limit'] is! int ||
        (meta['limit'] as int) < 1 ||
        (meta['limit'] as int) > 100 ||
        meta['totalResults'] is! int ||
        (meta['totalResults'] as int) < 0 ||
        meta['hasNextPage'] is! bool ||
        (meta['nextCursor'] != null && meta['nextCursor'] is! String) ||
        (meta['hasNextPage'] == true &&
            (meta['nextCursor'] is! String ||
                (meta['nextCursor'] as String).isEmpty))) {
      throw const InvalidResponseException();
    }

    final items = data
        .map((item) {
          if (item is! Map<String, dynamic>) {
            throw const InvalidResponseException();
          }
          return ManagedPersonnel.parse(item);
        })
        .toList(growable: false);
    if (meta['hasNextPage'] == true && items.isEmpty) {
      throw const InvalidResponseException();
    }

    return ManagedPersonnelPage(
      items: items,
      limit: meta['limit'] as int,
      totalResults: meta['totalResults'] as int,
      hasNextPage: meta['hasNextPage'] as bool,
      nextCursor: meta['nextCursor'] as String?,
    );
  }
}
