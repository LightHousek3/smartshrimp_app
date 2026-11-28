import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/features/operation/domain/entities/operation_models.dart';
import 'package:smartshrimp_app/features/operation/domain/repositories/operation_repository.dart';
import 'package:smartshrimp_app/features/operation/presentation/view_models/operation_controller.dart';
import 'package:smartshrimp_app/features/operation/presentation/widgets/operation_execute_sheet.dart';
import 'package:smartshrimp_app/features/operation/presentation/widgets/operation_execute_item_card.dart';

final _past = DateTime.utc(2026, 6, 1, 0, 30);

OperationSchedule _feeding({
  String id = 'item-1',
  OperationType type = OperationType.feeding,
  bool historical = false,
  DateTime? scheduledAt,
  DateTime? activatedAt,
}) => OperationSchedule(
  id: id,
  seasonId: 'season-1',
  protocolItemId: id,
  operationType: type,
  scheduledAt: scheduledAt ?? _past,
  plannedQuantity: 2,
  unit: 'KG',
  doseBasisSnapshot: 'FIXED_QUANTITY',
  doseValueSnapshot: 2,
  calculationVersion: 'v3',
  status: OperationStatus.planned,
  activatedAt:
      activatedAt ?? (historical ? _past.add(const Duration(days: 1)) : null),
  protocolItem: OperationProtocolItem(id: id, dueAtMinutes: 30),
);

final _explanation = find.byKey(const Key('operation-execution-reason'));

Future<void> _open(
  WidgetTester tester,
  OperationSchedule schedule,
  _Repository repo, {
  OperationSchedule? second,
}) async {
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
              onPressed: () => OperationExecuteSheet.show(
                context,
                schedules: [schedule, ?second],
              ),
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

      await tester.ensureVisible(_explanation);
      await tester.enterText(_explanation, 'Thực hiện muộn.');
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
      await tester.ensureVisible(_explanation);
      await tester.enterText(_explanation, 'Điều chỉnh theo sức ăn.');
      final quantity = find.byType(TextFormField).first;
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

  testWidgets('a late meal uses one explanation for both materials', (
    tester,
  ) async {
    final repo = _Repository();
    await _open(
      tester,
      _feeding(),
      repo,
      second: _feeding(id: 'item-2', type: OperationType.medicine),
    );
    await _pick(tester, hour: 8, minute: 15);
    final quantity = find.descendant(
      of: find.byType(OperationExecuteItemCard).first,
      matching: find.byType(TextFormField),
    );
    await tester.enterText(quantity, '3');
    await tester.pumpAndSettle();
    expect(_explanation, findsOneWidget);
    expect(find.text('Lý do ghi nhận *'), findsOneWidget);
    await tester.ensureVisible(_explanation);
    await tester.enterText(
      _explanation,
      'Mưa kéo dài, điều chỉnh lượng thức ăn.',
    );
    await tester.tap(find.text('Xác nhận ghi nhận'));
    await tester.pumpAndSettle();

    expect(repo.batch.map((item) => item.scheduleId), ['item-1', 'item-2']);
    expect(repo.batch.map((item) => item.note).toSet(), {
      'Mưa kéo dài, điều chỉnh lượng thức ăn.',
    });
    expect(repo.batch.first.varianceReason, repo.batch.first.note);
    expect(repo.batch.last.varianceReason, isNull);
    expect(repo.batch.map((item) => item.executedAt).toSet(), {
      _past.add(const Duration(minutes: 45)),
    });
  });
}

class _Repository implements OperationRepository {
  DateTime? executedAt;
  String? note;
  String? reason;
  HistoricalFeedingOccurrence? historical;
  List<OperationExecuteBatchItem> batch = [];

  @override
  Future<List<OperationExecution>> executeSchedulesBatch(
    List<OperationExecuteBatchItem> items,
  ) async {
    batch = items;
    return [];
  }

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
