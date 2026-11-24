import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/features/operation/domain/entities/operation_models.dart';
import 'package:smartshrimp_app/features/operation/domain/repositories/operation_repository.dart';
import 'package:smartshrimp_app/features/operation/presentation/view_models/operation_controller.dart';
import 'package:smartshrimp_app/features/operation/presentation/widgets/operation_execute_sheet.dart';

final _past = DateTime.utc(2026, 6, 1, 0, 30);

OperationSchedule _feeding({
  bool historical = false,
  DateTime? scheduledAt,
  DateTime? activatedAt,
}) => OperationSchedule(
  id: 'item-1',
  seasonId: 'season-1',
  protocolItemId: 'item-1',
  operationType: OperationType.feeding,
  scheduledAt: scheduledAt ?? _past,
  plannedQuantity: 2,
  unit: 'KG',
  doseBasisSnapshot: 'FIXED_QUANTITY',
  doseValueSnapshot: 2,
  calculationVersion: 'v3',
  status: OperationStatus.planned,
  activatedAt:
      activatedAt ?? (historical ? _past.add(const Duration(days: 1)) : null),
  protocolItem: const OperationProtocolItem(id: 'item-1', dueAtMinutes: 30),
);

Future<void> _open(
  WidgetTester tester,
  OperationSchedule schedule,
  _Repository repo,
) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [operationRepositoryProvider.overrideWithValue(repo)],
      child: MaterialApp(
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        ),
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () =>
                  OperationExecuteSheet.show(context, schedules: [schedule]),
              child: const Text('Mở form'),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.tap(find.text('Mở form'));
  await tester.pumpAndSettle();
}

Future<void> _pick(WidgetTester tester, {int? hour, int? minute}) async {
  await tester.tap(find.text('Chọn giờ thực hiện'));
  await tester.pumpAndSettle();
  expect(find.byType(DatePickerDialog), findsNothing);
  if (hour != null && minute != null) {
    await tester.tap(find.byIcon(Icons.keyboard_outlined));
    await tester.pumpAndSettle();
    final fields = find.descendant(
      of: find.byType(TimePickerDialog),
      matching: find.byType(TextField),
    );
    await tester.enterText(fields.first, hour.toString());
    await tester.enterText(fields.last, minute.toString());
  }
  await tester.tap(find.text('OK'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets(
    'historical entry requires a selected time and prefills the reason',
    (tester) async {
      final repo = _Repository();
      await _open(tester, _feeding(historical: true), repo);
      expect(
        find.text('Ghi bổ sung do vụ nuôi kích hoạt muộn'),
        findsOneWidget,
      );
      await tester.tap(find.text('Xác nhận ghi nhận'));
      await tester.pumpAndSettle();
      expect(find.text('Vui lòng chọn giờ thực hiện.'), findsOneWidget);
      await _pick(tester);
      await tester.tap(find.text('Xác nhận ghi nhận'));
      await tester.pumpAndSettle();
      expect(repo.executedAt, _past);
      expect(repo.note, 'Ghi bổ sung do vụ nuôi kích hoạt muộn');
      expect(repo.historical?.scheduledAt, _past);
    },
  );

  testWidgets('a feeding at activation while still on time can be recorded', (
    tester,
  ) async {
    final repo = _Repository();
    final scheduledAt = DateTime.utc(2026, 6, 1, 7);
    final activatedAt = DateTime.utc(2026, 6, 1, 7, 25);
    await _open(
      tester,
      _feeding(scheduledAt: scheduledAt, activatedAt: activatedAt),
      repo,
    );
    final calendar = find.widgetWithIcon(
      OutlinedButton,
      Icons.calendar_today_outlined,
    );
    expect(tester.widget<OutlinedButton>(calendar).onPressed, isNull);

    await _pick(tester, hour: 14, minute: 25);
    await tester.tap(find.text('Xác nhận ghi nhận'));
    await tester.pumpAndSettle();
    expect(repo.executedAt, activatedAt);
    expect(repo.historical?.scheduledAt, scheduledAt);
    expect(repo.note, 'Ghi bổ sung do vụ nuôi kích hoạt muộn');
  });

  testWidgets(
    'a past feeding slot accepts late use after activation that day',
    (tester) async {
      final repo = _Repository();
      await _open(
        tester,
        _feeding(activatedAt: DateTime.utc(2026, 6, 1, 7, 25)),
        repo,
      );
      await _pick(tester, hour: 15, minute: 15);
      expect(find.text('Lý do thực hiện quá hạn *'), findsOneWidget);
      expect(find.text('Ghi bổ sung do vụ nuôi kích hoạt muộn'), findsNothing);

      await tester.tap(find.text('Xác nhận ghi nhận'));
      await tester.pumpAndSettle();
      expect(find.text('Vui lòng nhập lý do.'), findsOneWidget);
      expect(repo.executedAt, isNull);

      await tester.enterText(
        find.byType(TextFormField).first,
        'Thực hiện muộn.',
      );
      await tester.tap(find.text('Xác nhận ghi nhận'));
      await tester.pumpAndSettle();
      expect(repo.executedAt, DateTime.utc(2026, 6, 1, 8, 15));
      expect(repo.historical?.scheduledAt, _past);
      expect(repo.note, 'Thực hiện muộn.');
    },
  );

  testWidgets(
    'requires a note for the selected late time and no quantity reason within tolerance',
    (tester) async {
      final repo = _Repository();
      await _open(tester, _feeding(), repo);
      await _pick(tester, hour: 8, minute: 15);
      expect(find.text('Lý do thực hiện quá hạn *'), findsWidgets);
      await tester.tap(find.text('Xác nhận ghi nhận'));
      await tester.pumpAndSettle();
      expect(find.text('Vui lòng nhập lý do.'), findsOneWidget);
      await tester.enterText(
        find.byType(TextFormField).first,
        'Điều chỉnh theo sức ăn.',
      );
      final quantity = find.byType(TextFormField).last;
      await tester.ensureVisible(quantity);
      await tester.enterText(quantity, '2.1');
      await tester.pumpAndSettle();
      expect(find.text('Lý do chênh lệch *'), findsNothing);
      await tester.tap(find.text('Xác nhận ghi nhận'));
      await tester.pumpAndSettle();
      expect(repo.executedAt, _past.add(const Duration(minutes: 45)));
      expect(repo.note, 'Điều chỉnh theo sức ăn.');
      expect(repo.reason, isNull);
    },
  );
}

class _Repository implements OperationRepository {
  DateTime? executedAt;
  String? note;
  String? reason;
  HistoricalFeedingOccurrence? historical;

  @override
  Future<OperationExecution> executeSchedule(
    String scheduleId, {
    required double actualQuantity,
    required String idempotencyKey,
    String? actualProductId,
    String? note,
    String? varianceReason,
    DateTime? executedAt,
    HistoricalFeedingOccurrence? historicalOccurrence,
  }) async {
    this.executedAt = executedAt;
    this.note = note;
    reason = varianceReason;
    historical = historicalOccurrence;
    return OperationExecution(
      id: 'exec-1',
      actualQuantity: actualQuantity,
      executedAt: executedAt!,
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
