import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/features/protocol/domain/entities/protocol.dart';
import 'package:smartshrimp_app/features/protocol/domain/protocol_occurrence.dart';
import 'package:smartshrimp_app/features/protocol/presentation/widgets/protocol_day_audit.dart';
import 'package:smartshrimp_app/features/protocol/presentation/widgets/protocol_timeline.dart';
import 'protocol_fixtures.dart';
import 'protocol_pages_test.dart' as harness;

void main() {
  testWidgets('owner audit preserves the recorded quantity and unit', (
    tester,
  ) async {
    final row = dayRowJson(status: 'COMPLETED', medicine: true)
      ..addAll({'actualQuantity': 0.000001, 'actualUnit': 'ML'});
    await harness.open(
      tester,
      page: Scaffold(
        body: SingleChildScrollView(
          child: ProtocolDayAudit(
            farmId: 'farm-1',
            protocolStatus: ProtocolStatus.active,
            day: ProtocolDay.parse({
              'day': 1,
              'rows': [row],
            }),
          ),
        ),
      ),
    );

    expect(find.text('0,000001 ml'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'execution notes belong below the person responsible only for completed rows',
    (tester) async {
      for (final (status, reason, note, missingMetadata) in [
        ('COMPLETED', 'Giảm lượng theo sức ăn.', 'Thực hiện sau hạn.', false),
        ('COMPLETED', 'Giảm lượng theo sức ăn.', null, false),
        ('COMPLETED', null, 'Điền từ sổ ao.', true),
        ('COMPLETED', ' ', ' ', false),
        ('PLANNED', null, null, false),
        ('NOT_RECORDED', null, null, false),
        ('CANCELLED', null, null, false),
      ]) {
        final row = dayRowJson(status: status)
          ..addAll({
            'varianceReason': reason,
            'note': note,
            if (missingMetadata) 'executedAt': null,
            if (missingMetadata) 'executorName': ' ',
            if (status == 'CANCELLED') 'cancellationReason': 'Phác đồ đã dừng.',
          });
        await harness.open(
          tester,
          page: Scaffold(
            body: SingleChildScrollView(
              child: SizedBox(
                width: 300,
                child: ProtocolDayAudit(
                  farmId: 'farm-1',
                  protocolStatus: ProtocolStatus.active,
                  day: ProtocolDay.parse({
                    'day': 1,
                    'rows': [row],
                  }),
                ),
              ),
            ),
          ),
        );
        final responsible = find.textContaining('Chịu trách nhiệm:');
        final quantityReason = find.text('Lý do điều chỉnh lượng dùng');
        final executionNote = find.text('Ghi chú của Kỹ thuật viên');
        final completed = status == 'COMPLETED';
        final hasReason = completed && (reason?.trim().isNotEmpty ?? false);
        final hasNote = completed && (note?.trim().isNotEmpty ?? false);
        expect(find.text('THỰC SỰ DÙNG'), findsOneWidget);
        expect(responsible, completed ? findsOneWidget : findsNothing);
        expect(quantityReason, hasReason ? findsOneWidget : findsNothing);
        expect(executionNote, hasNote ? findsOneWidget : findsNothing);
        expect(
          find.text('Lý do không thực hiện'),
          status == 'CANCELLED' ? findsOneWidget : findsNothing,
        );
        expect(
          find.text('Kiểm tra giao dịch kho'),
          completed && !missingMetadata ? findsOneWidget : findsNothing,
        );
        if (hasReason) {
          expect(
            tester.getTopLeft(quantityReason).dy,
            greaterThan(tester.getTopLeft(responsible).dy),
          );
        }
        if (hasNote) {
          expect(
            tester.getTopLeft(executionNote).dy,
            greaterThan(tester.getTopLeft(responsible).dy),
          );
        }
        if (missingMetadata) {
          expect(find.textContaining('Chưa có tên'), findsOneWidget);
        }
        expect(tester.takeException(), isNull);
      }
    },
  );

  testWidgets(
    'owner sees a shared explanation once and keeps separate recordings',
    (tester) async {
      const reason = 'Mưa kéo dài, điều chỉnh lượng thức ăn.';
      Map<String, dynamic> item(
        String id,
        String minute, {
        bool medicine = false,
      }) => dayRowJson(status: 'COMPLETED', medicine: medicine)
        ..addAll({
          'itemId': id,
          'scheduleId': id,
          'productionMealId': 'meal-1',
          'recordedAt': '2026-06-29T00:$minute:00Z',
          'productName': id,
          'note': reason,
          'varianceReason': medicine ? null : reason,
        });
      await harness.open(
        tester,
        page: Scaffold(
          body: SingleChildScrollView(
            child: ProtocolDayAudit(
              farmId: 'farm-1',
              protocolStatus: ProtocolStatus.active,
              day: ProtocolDay.parse({
                'day': 1,
                'rows': [
                  item('Thức ăn 01', '10'),
                  item('Thuốc 01', '10', medicine: true),
                  item('Thức ăn 02', '15'),
                ],
              }),
            ),
          ),
        ),
      );
      expect(find.text(reason), findsNWidgets(2));
      expect(find.text('Thức ăn 01, Thuốc 01'), findsOneWidget);
      expect(find.text('Lý do ghi nhận'), findsNWidgets(2));
      expect(find.text('Kiểm tra giao dịch kho'), findsNWidgets(3));
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'DOC badges distinguish unrecorded, done, cancelled and actual issues',
    (tester) async {
      final data = detailJson(status: 'ACTIVE')
        ..['dayMarkers'] = [
          {
            'day': 1,
            'completed': 0,
            'planned': 0,
            'cancelled': 0,
            'unrecorded': 1,
          },
          {'day': 2, 'completed': 1, 'planned': 0, 'cancelled': 0},
          {'day': 3, 'completed': 1, 'planned': 0, 'cancelled': 1},
          {'day': 4, 'completed': 1, 'planned': 0, 'cancelled': 0, 'issues': 1},
          {'day': 5, 'completed': 1, 'planned': 1, 'cancelled': 0},
        ];
      await harness.open(
        tester,
        page: Scaffold(
          body: ProtocolTimeline(
            detail: ProtocolDetail.parse(data),
            selectedDay: 1,
            onSelect: (_) {},
          ),
        ),
      );
      final colors = [
        0xFFFFB900,
        0xFF00D5BE,
        0xFF94A3B8,
        0xFFFF637E,
        0xFFFFB900,
      ];
      for (var day = 1; day <= 6; day++) {
        final button = find.byWidgetPredicate(
          (w) => w is Semantics && w.properties.label == 'DOC $day',
        );
        final dot = find.descendant(
          of: button,
          matching: find.byWidgetPredicate(
            (w) =>
                w is Container &&
                w.decoration is BoxDecoration &&
                (w.decoration as BoxDecoration).shape == BoxShape.circle,
          ),
        );
        if (day == 6) {
          expect(dot, findsNothing);
        } else {
          expect(
            (tester.widget<Container>(dot).decoration as BoxDecoration).color,
            Color(colors[day - 1]),
          );
        }
      }
    },
  );

  testWidgets(
    'shared meal window and historical label fit on a narrow screen',
    (tester) async {
      final row = dayRowJson(status: 'NOT_RECORDED')
        ..addAll({'time': '23:45', 'dueAtMinutes': 30});
      await harness.open(
        tester,
        page: Scaffold(
          body: SizedBox(
            width: 310,
            child: ProtocolDayAudit(
              farmId: 'farm-1',
              protocolStatus: ProtocolStatus.active,
              mealNumbersByItem: const {'item-1': 3},
              day: ProtocolDay.parse({
                'day': 2,
                'rows': [row],
              }),
            ),
          ),
        ),
      );
      final time = find.text('23:45 - 00:15 (+1 ngày) (Cữ\u00a03)');
      final count = find.text('1 vật tư');
      final header = find.byType(Table).first;
      final label = find.descendant(
        of: header,
        matching: find.text('Chưa ghi nhận'),
      );
      final status = find.descendant(
        of: header,
        matching: find.text('Đã lên lịch'),
      );
      expect(time, findsOneWidget);
      expect(count, findsOneWidget);
      expect(find.text('Chưa ghi nhận'), findsOneWidget);
      expect(find.text('Đã lên lịch'), findsOneWidget);
      expect(tester.getCenter(status).dy, lessThan(tester.getCenter(label).dy));
      expect(
        tester.getCenter(count).dy,
        closeTo(tester.getCenter(label).dy, 1),
      );
      expect(
        tester.getCenter(time).dy,
        closeTo(tester.getCenter(status).dy, 1),
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('counts products once and omits a missing meal number', (
    tester,
  ) async {
    final item = dayRowJson(status: 'COMPLETED');
    final backup = dayRowJson(status: 'CANCELLED');
    final other = dayRowJson(status: 'NOT_RECORDED')..['itemId'] = 'item-2';
    await harness.open(
      tester,
      page: Scaffold(
        body: SingleChildScrollView(
          child: ProtocolDayAudit(
            farmId: 'farm-1',
            protocolStatus: ProtocolStatus.active,
            day: ProtocolDay.parse({
              'day': 2,
              'rows': [backup, item, other],
            }),
          ),
        ),
      ),
    );
    expect(find.text('2 vật tư'), findsOneWidget);
    expect(find.textContaining('(Cữ'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  test('meal window is hidden when item deadlines differ or are missing', () {
    ProtocolDayRow row(int? minutes) => ProtocolDayRow.fromJson(
      dayRowJson(status: 'NOT_RECORDED')..['dueAtMinutes'] = minutes,
    );
    expect(protocolMealTimeRange('07:30', [row(30), row(30)]), '07:30 - 08:00');
    expect(protocolMealTimeRange('07:30', [row(30), row(45)]), '07:30');
    expect(protocolMealTimeRange('07:30', [row(null)]), '07:30');
  });

  for (final (unit, stockLabel, actual, variance) in [
    ('G', 'gói', 25, '+25,0'),
    ('ML', 'chai', 15, '-25,0'),
    ('G', 'gói', 20, null),
  ]) {
    testWidgets('day audit displays $actual $unit and physical-unit variance', (
      tester,
    ) async {
      final row = dayRowJson(status: 'COMPLETED')
        ..addAll({
          'unit': unit,
          'doseUnit': unit,
          'plannedQuantity': 20,
          'actualQuantity': actual,
          'actualUnit': unit,
          'varianceReason': null,
          'note': 'Ghi bổ sung sau khi kiểm tra sổ ao.',
          'instructions': 'Rải đều quanh ao theo hướng dẫn.',
        });
      await harness.open(
        tester,
        page: Scaffold(
          body: SingleChildScrollView(
            child: ProtocolDayAudit(
              farmId: 'farm-1',
              protocolStatus: ProtocolStatus.active,
              day: ProtocolDay.parse({
                'day': 31,
                'rows': [row],
              }),
            ),
          ),
        ),
      );
      expect(find.text('Ghi bổ sung sau khi kiểm tra sổ ao.'), findsOneWidget);
      expect(find.text('Rải đều quanh ao theo hướng dẫn.'), findsOneWidget);
      expect(find.text('$actual ${unit.toLowerCase()}'), findsWidgets);
      expect(find.textContaining(stockLabel), findsNothing);
      if (variance == null) {
        expect(find.textContaining('Chênh lệch'), findsNothing);
      } else {
        expect(
          find.text('Chênh lệch $variance% · Vượt ngưỡng'),
          findsOneWidget,
        );
      }
      expect(tester.takeException(), isNull);
    });
  }
}
