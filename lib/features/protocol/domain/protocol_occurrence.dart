import 'package:smartshrimp_app/features/protocol/domain/entities/protocol.dart';

enum ProtocolOccurrenceState {
  completed,
  cancelled,
  pendingApproval,
  notGenerated,
  notRecorded,
  planned,
  overdue,
  awaitingActivation,
  paused,
  locked,
  unknown,
}

typedef ProtocolMealKey = ({String? id, String? time, int? mealNumber});

/// A shared clock time does not merge independently prescribed meals.
Map<ProtocolMealKey, List<ProtocolDayRow>> protocolMeals(
  List<ProtocolDayRow> rows, {
  Map<String, int> mealNumbersByItem = const {},
}) {
  final groups = <ProtocolMealKey, List<ProtocolDayRow>>{};
  for (final row in rows) {
    groups
        .putIfAbsent((
          id: row.productionMealId ?? (row.time == null ? row.itemId : null),
          time: row.time,
          mealNumber: mealNumbersByItem[row.itemId],
        ), () => [])
        .add(row);
  }
  return groups;
}

/// Display a meal deadline only when all current items share a valid window.
String protocolMealTimeRange(String? time, List<ProtocolDayRow> rows) {
  if (time == null) return 'Chưa đặt giờ';
  final start =
      int.parse(time.substring(0, 2)) * 60 + int.parse(time.substring(3, 5));
  final windows = rows
      .map(
        (row) => row.scheduledAt != null && row.dueAt != null
            ? row.dueAt!.difference(row.scheduledAt!).inMinutes
            : row.dueAtMinutes,
      )
      .toSet();
  if (windows.length != 1) return time;
  final minutes = windows.single;
  if (minutes == null || minutes <= 0) return time;
  final end = start + minutes;
  final days = end ~/ 1440;
  final hour = (end ~/ 60 % 24).toString().padLeft(2, '0');
  final minute = (end % 60).toString().padLeft(2, '0');
  return '$time - $hour:$minute${days > 0 ? ' (+$days ngày)' : ''}';
}

/// Recalculation keeps cancelled history, but its replacement counts only once.
List<ProtocolDayRow> protocolCurrentRows(List<ProtocolDayRow> rows) {
  final current = <String, ProtocolDayRow>{};
  for (final row in rows) {
    final previous = current[row.itemId];
    if (previous == null ||
        previous.status == ProtocolOperationStatus.cancelled &&
            (row.status != ProtocolOperationStatus.cancelled ||
                (row.cancelledAt?.millisecondsSinceEpoch ?? 0) >=
                    (previous.cancelledAt?.millisecondsSinceEpoch ?? 0))) {
      current[row.itemId] = row;
    }
  }
  return current.values.toList();
}

ProtocolOccurrenceState protocolOccurrenceState(
  ProtocolDayRow row,
  ProtocolStatus protocolStatus,
  DateTime now,
) => switch (row.status) {
  ProtocolOperationStatus.completed => ProtocolOccurrenceState.completed,
  ProtocolOperationStatus.cancelled => ProtocolOccurrenceState.cancelled,
  ProtocolOperationStatus.pendingApproval =>
    ProtocolOccurrenceState.pendingApproval,
  ProtocolOperationStatus.notRecorded => ProtocolOccurrenceState.notRecorded,
  ProtocolOperationStatus.notGenerated => ProtocolOccurrenceState.notGenerated,
  ProtocolOperationStatus.unknown => ProtocolOccurrenceState.unknown,
  ProtocolOperationStatus.planned => switch (protocolStatus) {
    ProtocolStatus.active =>
      row.dueAt != null && now.isAfter(row.dueAt!)
          ? ProtocolOccurrenceState.overdue
          : ProtocolOccurrenceState.planned,
    ProtocolStatus.approved => ProtocolOccurrenceState.awaitingActivation,
    ProtocolStatus.paused => ProtocolOccurrenceState.paused,
    ProtocolStatus.draft ||
    ProtocolStatus.pendingApproval => ProtocolOccurrenceState.pendingApproval,
    ProtocolStatus.unknown => ProtocolOccurrenceState.unknown,
    _ => ProtocolOccurrenceState.locked,
  },
};

int protocolExpectedItems(ProtocolDetail detail, int day) => detail
    .materialReviews
    .where(
      (item) =>
          day >= item.firstDay &&
          day <= item.lastDay &&
          (day - item.recurrenceAnchorDay) % item.repeatIntervalDays == 0,
    )
    .length;

bool protocolMealCompleted(List<ProtocolDayRow> rows) {
  final current = protocolCurrentRows(rows);
  return current.isNotEmpty &&
      current.every((row) => row.status == ProtocolOperationStatus.completed);
}
