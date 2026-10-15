import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/assigned_season/domain/entities/assigned_season.dart';
import 'package:smartshrimp_app/features/assigned_season/domain/entities/assigned_season_detail.dart';
import 'package:smartshrimp_app/features/assigned_season/domain/repositories/assigned_season_repository.dart';
import 'package:smartshrimp_app/features/assigned_season/presentation/pages/assigned_season_detail_page.dart';
import 'package:smartshrimp_app/features/assigned_season/presentation/view_models/assigned_season_controller.dart';
import 'package:smartshrimp_app/features/operation/domain/entities/operation_models.dart';
import 'package:smartshrimp_app/features/operation/domain/repositories/operation_repository.dart';
import 'package:smartshrimp_app/features/operation/presentation/view_models/operation_controller.dart';
import 'package:smartshrimp_app/features/water_log/domain/entities/water_log.dart';
import 'package:smartshrimp_app/features/water_log/domain/entities/water_log_metadata.dart';
import 'package:smartshrimp_app/features/season/domain/entities/aquaculture_season.dart';
import 'package:smartshrimp_app/features/water_log/presentation/view_models/water_log_controller.dart';

Future<void> _open(
  WidgetTester tester,
  Future<WaterLog?> Function() latest, {
  AssignedSeasonStatus status = AssignedSeasonStatus.active,
  Future<WaterLogMetadata> Function()? metadata,
}) async {
  GoogleFonts.config.allowRuntimeFetching = false;
  tester.view.physicalSize = const Size(320, 700);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (_, _) =>
            const Scaffold(body: AssignedSeasonDetailPage(seasonId: 'season')),
      ),
    ],
  );
  addTearDown(router.dispose);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        assignedSeasonRepositoryProvider.overrideWithValue(_Seasons(status)),
        operationRepositoryProvider.overrideWithValue(_Operations()),
        latestWaterLogProvider('season').overrideWith((ref) => latest()),
        waterLogMetadataProvider('season').overrideWith(
          (ref) =>
              metadata?.call() ??
              Future.value(WaterLogMetadata.legacy(ShrimpType.whiteleg)),
        ),
      ],
      child: MaterialApp.router(theme: AppTheme.light, routerConfig: router),
    ),
  );
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 100));
  await tester.runAsync(() => GoogleFonts.pendingFonts());
}

void main() {
  for (final status in [
    AssignedSeasonStatus.planning,
    AssignedSeasonStatus.completed,
    AssignedSeasonStatus.cancelled,
  ]) {
    testWidgets('water history and latest remain visible in $status', (
      tester,
    ) async {
      await _open(tester, () async => null, status: status);
      await tester.pumpAndSettle();
      expect(find.text('Nhật ký đo nước'), findsOneWidget);
      expect(find.text('Đo nước gần nhất'), findsOneWidget);
      expect(find.text('Chưa có nhật ký đo nước.'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
  for (final exceeded in <List<String>>[
    [],
    ['h2sMgL'],
    ['h2sMgL', 'ph'],
  ]) {
    testWidgets('latest card displays H2S with warnings $exceeded', (
      tester,
    ) async {
      await _open(
        tester,
        () async => WaterLog(
          id: 'log',
          seasonId: 'season',
          recordedAt: DateTime(2026),
          createdAt: DateTime(2026),
          isVoided: false,
          exceededParameters: exceeded,
          h2sMgL: exceeded.isEmpty ? 0.00001 : 0.05001,
          ph: exceeded.contains('ph') ? 9 : 8,
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('H2S'), findsOneWidget);
      for (final param in waterLogFormParams) {
        for (final bound in ['min', 'max']) {
          expect(
            find.byKey(Key('latest_water_threshold_${param.field}_$bound')),
            findsOneWidget,
          );
        }
      }
      expect(find.text('Min: 25'), findsOneWidget);
      expect(find.text('Max: 33'), findsOneWidget);
      expect(find.text('Max: 0.05'), findsOneWidget);
      expect(find.text('Min: —'), findsNWidgets(3));
      final measuredValue = find.text(exceeded.isEmpty ? '0.00001' : '0.05001');
      expect(
        tester.renderObject<RenderParagraph>(measuredValue).didExceedMaxLines,
        isFalse,
      );
      expect(
        find.ancestor(of: measuredValue, matching: find.byType(FittedBox)),
        findsOneWidget,
      );
      final tile = find
          .ancestor(of: find.text('H2S'), matching: find.byType(Container))
          .first;
      final decoration =
          tester.widget<Container>(tile).decoration! as BoxDecoration;
      expect(
        decoration.color,
        exceeded.isEmpty ? const Color(0xB3EEF1F6) : const Color(0xFFFBE6EA),
      );
      expect(tester.takeException(), isNull);
    });
  }
  testWidgets('latest card keeps loading, empty and error states', (
    tester,
  ) async {
    final pending = Completer<WaterLog?>();
    await _open(tester, () => pending.future);
    expect(find.byType(CircularProgressIndicator), findsWidgets);
    pending.complete(null);
    await tester.pumpAndSettle();
    expect(find.text('Chưa có nhật ký đo nước.'), findsOneWidget);
    // Use a new provider scope so this represents a separate failed request.
    await tester.pumpWidget(const SizedBox.shrink());
    await _open(tester, () async => throw StateError('offline'));
    await tester.pumpAndSettle();
    expect(find.text('Không tải được dữ liệu đo nước.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
  testWidgets(
    'latest thresholds load independently and retry without hiding measurements',
    (tester) async {
      final pending = Completer<WaterLogMetadata>();
      var calls = 0;
      await _open(
        tester,
        () async => WaterLog(
          id: 'log',
          seasonId: 'season',
          recordedAt: DateTime(2026),
          createdAt: DateTime(2026),
          isVoided: false,
          exceededParameters: [],
          ph: 8,
        ),
        metadata: () {
          calls++;
          return calls == 1
              ? pending.future
              : Future.value(WaterLogMetadata.legacy(ShrimpType.blackTiger));
        },
      );
      await tester.pumpAndSettle();
      expect(find.text('Min: …'), findsNWidgets(8));
      pending.completeError(StateError('offline'));
      await tester.pumpAndSettle();
      expect(find.text('Không tải được ngưỡng Min/Max.'), findsOneWidget);
      expect(find.text('H2S'), findsOneWidget);
      await tester.ensureVisible(find.text('Thử lại ngưỡng'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Thử lại ngưỡng'));
      await tester.pumpAndSettle();
      expect(find.text('Min: 26'), findsOneWidget);
      expect(find.text('Max: 32'), findsOneWidget);
      expect(find.text('Không tải được ngưỡng Min/Max.'), findsNothing);
      expect(calls, 2);
      expect(tester.takeException(), isNull);
    },
  );
  for (final error in <AppException>[
    const ApiException(
      'Bạn không có quyền xem ngưỡng vụ nuôi.',
      statusCode: 403,
    ),
    const NetworkException(),
  ]) {
    testWidgets('latest thresholds preserve API message: ${error.message}', (
      tester,
    ) async {
      await _open(
        tester,
        () async => WaterLog(
          id: 'log',
          seasonId: 'season',
          recordedAt: DateTime(2026),
          createdAt: DateTime(2026),
          isVoided: false,
          exceededParameters: [],
        ),
        metadata: () async => throw error,
      );
      await tester.pumpAndSettle();
      expect(find.text(error.message), findsOneWidget);
      expect(find.text('Không tải được ngưỡng Min/Max.'), findsNothing);
      expect(find.text('H2S'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
}

class _Seasons implements AssignedSeasonRepository {
  _Seasons(this.status);
  final AssignedSeasonStatus status;
  @override
  Future<AssignedSeasonDetail> getAssignedSeason(String seasonId) async =>
      AssignedSeasonDetail(
        id: seasonId,
        name: 'Vụ nuôi',
        status: status,
        shrimpType: 'WHITELEG',
        pondId: 'pond',
        pondName: 'Ao A3',
        pondType: 'LINED',
        pondStatus: 'ACTIVE',
        farmId: 'farm',
        farmName: 'Trại',
        personnel: [],
        otherAssignedSeasons: [],
        assignedAt: DateTime(2026),
      );
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Operations implements OperationRepository {
  @override
  Future<OperationListResult> getSchedules(
    String seasonId, {
    String? status,
    String? operationType,
    String? date,
    int? page,
    int? limit,
  }) async => OperationListResult.fromJson({});
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
