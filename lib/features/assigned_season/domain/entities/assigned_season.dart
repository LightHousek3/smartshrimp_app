import 'package:smartshrimp_app/core/errors/app_exception.dart';

enum AssignedSeasonStatus { planning, active, completed, cancelled }

AssignedSeasonStatus _status(Object? value) => switch (value) {
  'PLANNING' => AssignedSeasonStatus.planning,
  'ACTIVE' => AssignedSeasonStatus.active,
  'COMPLETED' => AssignedSeasonStatus.completed,
  'CANCELLED' => AssignedSeasonStatus.cancelled,
  _ => throw const InvalidResponseException(),
};

final class AssignedSeason {
  const AssignedSeason({
    required this.id,
    required this.name,
    required this.status,
    required this.shrimpType,
    required this.pondId,
    required this.pondName,
    required this.farmId,
    required this.farmName,
    required this.assignedAt,
    this.stockingDate,
    this.expectedEndDate,
    this.initialBiomassKg,
  });

  final String id, name, shrimpType, pondId, pondName, farmId, farmName;
  final AssignedSeasonStatus status;
  final DateTime assignedAt;
  final DateTime? stockingDate, expectedEndDate;
  final double? initialBiomassKg;

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

final class AssignedSeasonPage {
  const AssignedSeasonPage({
    required this.items,
    required this.totalResults,
    required this.activeResults,
    required this.allResults,
    required this.hasNextPage,
    this.nextCursor,
  });
  final List<AssignedSeason> items;
  final int totalResults;
  final int activeResults;
  final int allResults;
  final bool hasNextPage;
  final String? nextCursor;

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
