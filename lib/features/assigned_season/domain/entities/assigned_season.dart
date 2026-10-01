import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';

part 'assigned_season.freezed.dart';

enum AssignedSeasonStatus { planning, active, completed, cancelled }

AssignedSeasonStatus _status(Object? value) => switch (value) {
  'PLANNING' => AssignedSeasonStatus.planning,
  'ACTIVE' => AssignedSeasonStatus.active,
  'COMPLETED' => AssignedSeasonStatus.completed,
  'CANCELLED' => AssignedSeasonStatus.cancelled,
  _ => throw const InvalidResponseException(),
};

@freezed
abstract class AssignedSeason with _$AssignedSeason {
  const AssignedSeason._();

  const factory AssignedSeason({
    required String id,
    required String name,
    required AssignedSeasonStatus status,
    required String shrimpType,
    required String pondId,
    required String pondName,
    required String farmId,
    required String farmName,
    required DateTime assignedAt,
    DateTime? stockingDate,
    DateTime? expectedEndDate,
    double? initialBiomassKg,
  }) = _AssignedSeason;

  int? get dayOfCulture {
    if (stockingDate == null || status != AssignedSeasonStatus.active) {
      return null;
    }
    return DateTime.now().difference(stockingDate!).inDays + 1;
  }

  static AssignedSeason parse(Map<String, dynamic> json) {
    try {
      final pond = json['pond'] as Map<String, dynamic>;
      final farm = json['farm'] as Map<String, dynamic>;
      final assignment = json['assignment'] as Map<String, dynamic>;
      return AssignedSeason(
        id: json['id'] as String,
        name: json['name'] as String,
        status: _status(json['status']),
        shrimpType: json['shrimpType'] as String,
        pondId: pond['id'] as String,
        pondName: pond['name'] as String,
        farmId: farm['id'] as String,
        farmName: farm['name'] as String,
        assignedAt: DateTime.parse(assignment['assignedAt'] as String),
        stockingDate: _date(json['stockingDate']),
        expectedEndDate: _date(json['expectedEndDate']),
        initialBiomassKg: (json['initialBiomassKg'] as num?)?.toDouble(),
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
