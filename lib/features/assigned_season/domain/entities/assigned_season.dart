import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';

import 'package:smartshrimp_app/features/season/domain/entities/aquaculture_season.dart';
import 'package:smartshrimp_app/features/season/domain/season_rules.dart';

// Keep feature imports on existing entry points instead of adding barrel files.
export 'package:smartshrimp_app/features/season/domain/entities/aquaculture_season.dart'
    show
        ShrimpType,
        seasonStatusLabel,
        seasonStatusFromJson,
        seasonStatusApiValue;

part 'assigned_season.freezed.dart';

/// Reuse the app's existing wire adapter; Prisma owns the server enum values.
/// The alias keeps existing callers and generated Freezed signatures compatible.
typedef AssignedSeasonStatus = SeasonStatus;

/// Compact server-owned farm choices; records provide immutable value equality.
typedef AssignedSeasonFarm = ({String id, String name});

/// Shared policy for assigned-season pages; no UI/network dependencies belong here.
abstract final class AssignedSeasonRules {
  static const pageSize = 20;
  static const searchMaxLength = 255;
  static const searchDebounce = Duration(milliseconds: 300);
  // UI-only menu value; farm IDs remain UUIDs on the wire.
  static const allFarmsValue = 'all';
  static const operationPageSize = 100;
  static const operationPreviewSize = 3;
  static const vietnamOffset = Duration(hours: 7);

  /// Use the farm's Vietnam calendar even when the device has another timezone.
  static DateTime vietnamDay(DateTime instant) {
    final local = instant.toUtc().add(vietnamOffset);
    return DateTime.utc(local.year, local.month, local.day);
  }

  static int? dayOfCulture(
    DateTime? stockingDate,
    AssignedSeasonStatus status,
  ) {
    if (stockingDate == null || status != AssignedSeasonStatus.active) {
      return null;
    }
    final stocked = DateTime.utc(
      stockingDate.year,
      stockingDate.month,
      stockingDate.day,
    );
    final days = vietnamDay(DateTime.now()).difference(stocked).inDays + 1;
    return days > 0 ? days : null;
  }

  static String dateOnly(DateTime date) => SeasonRules.dateOnly(date);
}

/// Reject unknown contract values consistently in both list and detail parsing.
AssignedSeasonStatus assignedSeasonStatusFromJson(Object? value) {
  final status = seasonStatusFromJson(value);
  if (status == SeasonStatus.unknown) throw const InvalidResponseException();
  return status;
}

@freezed
abstract class AssignedSeason with _$AssignedSeason {
  const AssignedSeason._();

  const factory AssignedSeason({
    required String id,
    required String name,
    required AssignedSeasonStatus status,
    required ShrimpType shrimpType,
    required String pondId,
    required String pondName,
    required String farmId,
    required String farmName,
    required DateTime assignedAt,
    DateTime? stockingDate,
    DateTime? expectedEndDate,
    double? initialDensityPerM2,
    // Keep the wire value in domain; presentation reuses existing health labels.
    String? currentHealthStatus,
  }) = _AssignedSeason;

  int? get dayOfCulture =>
      AssignedSeasonRules.dayOfCulture(stockingDate, status);

  static AssignedSeason parse(Map<String, dynamic> json) {
    try {
      final pond = json['pond'] as Map<String, dynamic>;
      final farm = json['farm'] as Map<String, dynamic>;
      final assignment = json['assignment'] as Map<String, dynamic>;
      return AssignedSeason(
        id: json['id'] as String,
        name: json['name'] as String,
        status: assignedSeasonStatusFromJson(json['status']),
        shrimpType: shrimpTypeFromJson(json['shrimpType']),
        pondId: pond['id'] as String,
        pondName: pond['name'] as String,
        farmId: farm['id'] as String,
        farmName: farm['name'] as String,
        assignedAt: DateTime.parse(assignment['assignedAt'] as String),
        stockingDate: _date(json['stockingDate']),
        expectedEndDate: _date(json['expectedEndDate']),
        initialDensityPerM2: (json['initialDensityPerM2'] as num?)?.toDouble(),
        currentHealthStatus: json['currentHealthStatus'] as String?,
      );
    } on Object catch (_, stackTrace) {
      Error.throwWithStackTrace(const InvalidResponseException(), stackTrace);
    }
  }
}

@freezed
abstract class AssignedSeasonPage with _$AssignedSeasonPage {
  const AssignedSeasonPage._();

  const factory AssignedSeasonPage({
    required List<AssignedSeason> items,
    required int totalResults,
    required int activeResults,
    required int allResults,
    required bool hasNextPage,
    String? nextCursor,
  }) = _AssignedSeasonPage;

  AssignedSeasonPage append(AssignedSeasonPage next) => AssignedSeasonPage(
    items: <AssignedSeason>[...items, ...next.items],
    totalResults: next.totalResults,
    activeResults: next.activeResults,
    allResults: next.allResults,
    hasNextPage: next.hasNextPage,
    nextCursor: next.nextCursor,
  );
}

DateTime? _date(Object? value) =>
    value is String ? DateTime.tryParse(value) : null;
