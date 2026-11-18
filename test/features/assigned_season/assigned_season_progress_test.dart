import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/features/assigned_season/domain/entities/assigned_season.dart';
import 'package:smartshrimp_app/features/assigned_season/domain/entities/assigned_season_detail.dart';
import 'package:smartshrimp_app/features/assigned_season/presentation/widgets/assigned_season_progress.dart';

AssignedSeasonDetail _season({
  required DateTime? start,
  required DateTime? end,
  AssignedSeasonStatus status = AssignedSeasonStatus.active,
}) => AssignedSeasonDetail(
  id: 'season',
  name: 'Vụ nuôi',
  status: status,
  shrimpType: ShrimpType.whiteleg,
  pondId: 'pond',
  pondName: 'Ao A3',
  pondType: 'AQUACULTURE',
  pondStatus: 'ACTIVE',
  farmId: 'farm',
  farmName: 'Trại',
  personnel: [],
  otherAssignedSeasons: [],
  assignedAt: DateTime(2026),
  stockingDate: start,
  expectedEndDate: end,
);

Future<void> _open(
  WidgetTester tester,
  AssignedSeasonDetail season, {
  double textScale = 1,
}) async {
  tester.view.physicalSize = const Size(320, 900);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: MediaQuery(
          data: MediaQueryData(textScaler: TextScaler.linear(textScale)),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: AssignedSeasonProgress(season: season),
          ),
        ),
      ),
    ),
  );
}

void main() {
  // Keep fixtures on the same Vietnam calendar used by the existing DOC rule.
  final today = AssignedSeasonRules.vietnamDay(DateTime.now());

  testWidgets('uses inclusive DOC and duration, and shows remaining days', (
    tester,
  ) async {
    await _open(
      tester,
      _season(
        start: today.subtract(const Duration(days: 44)),
        end: today.add(const Duration(days: 75)),
      ),
    );
    expect(find.text('DOC 45'), findsOneWidget);
    expect(find.text('45 / 120 ngày · 37,5%'), findsOneWidget);
    expect(find.text('Còn 75 ngày đến ngày kết thúc dự kiến'), findsOneWidget);
    expect(
      tester
          .widget<LinearProgressIndicator>(find.byType(LinearProgressIndicator))
          .value,
      0.375,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('stocking day is DOC 1', (tester) async {
    await _open(
      tester,
      _season(start: today, end: today.add(const Duration(days: 9))),
    );
    expect(find.text('DOC 1'), findsOneWidget);
    expect(find.text('1 / 10 ngày · 10,0%'), findsOneWidget);
    expect(find.text('Còn 9 ngày đến ngày kết thúc dự kiến'), findsOneWidget);
  });

  testWidgets('one-day season ends at 100 percent without division by zero', (
    tester,
  ) async {
    await _open(tester, _season(start: today, end: today));
    expect(find.text('1 / 1 ngày · 100,0%'), findsOneWidget);
    expect(find.text('Hôm nay là ngày kết thúc dự kiến'), findsOneWidget);
    expect(
      tester
          .widget<LinearProgressIndicator>(find.byType(LinearProgressIndicator))
          .value,
      1,
    );
  });

  testWidgets('overdue progress caps at 100 percent and retains actual DOC', (
    tester,
  ) async {
    await _open(
      tester,
      _season(
        start: today.subtract(const Duration(days: 14)),
        end: today.subtract(const Duration(days: 5)),
      ),
    );
    expect(find.text('DOC 15'), findsOneWidget);
    expect(find.text('15 / 10 ngày · 100,0%'), findsOneWidget);
    expect(find.text('Vượt dự kiến 5 ngày'), findsOneWidget);
    expect(
      tester
          .widget<LinearProgressIndicator>(find.byType(LinearProgressIndicator))
          .value,
      1,
    );
  });

  for (final dates in [
    (start: null, end: today),
    (start: today, end: null),
    (start: today, end: today.subtract(const Duration(days: 1))),
    (
      start: today.add(const Duration(days: 1)),
      end: today.add(const Duration(days: 10)),
    ),
  ]) {
    testWidgets('missing or invalid dates do not invent progress: $dates', (
      tester,
    ) async {
      await _open(tester, _season(start: dates.start, end: dates.end));
      expect(
        find.text('Chưa đủ dữ liệu ngày hợp lệ để tính tiến trình.'),
        findsOneWidget,
      );
      expect(
        tester
            .widget<LinearProgressIndicator>(
              find.byType(LinearProgressIndicator),
            )
            .value,
        0,
      );
      expect(tester.takeException(), isNull);
    });
  }

  for (final status in [
    AssignedSeasonStatus.planning,
    AssignedSeasonStatus.completed,
    AssignedSeasonStatus.cancelled,
  ]) {
    testWidgets('$status does not continue a live DOC progress', (
      tester,
    ) async {
      await _open(
        tester,
        _season(
          start: today.subtract(const Duration(days: 44)),
          end: today.add(const Duration(days: 75)),
          status: status,
        ),
      );
      expect(find.text('DOC 45'), findsNothing);
      expect(find.textContaining('37,5%'), findsNothing);
      expect(
        tester
            .widget<LinearProgressIndicator>(
              find.byType(LinearProgressIndicator),
            )
            .value,
        0,
      );
      if (status == AssignedSeasonStatus.planning) {
        expect(find.text('Thả giống dự kiến'), findsOneWidget);
        expect(find.text('Đang chuẩn bị'), findsOneWidget);
      }
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('timeline fits a narrow screen with large text', (tester) async {
    await _open(
      tester,
      _season(
        start: today.subtract(const Duration(days: 44)),
        end: today.add(const Duration(days: 75)),
      ),
      textScale: 2,
    );
    expect(find.text('Tiến trình vụ nuôi'), findsOneWidget);
    expect(find.text('Kết thúc dự kiến'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
