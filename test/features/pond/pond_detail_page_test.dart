import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshrimp_app/core/di/core_providers.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/storage/session_store.dart';
import 'package:smartshrimp_app/core/widgets/app_notice.dart';
import 'package:smartshrimp_app/features/auth/domain/entities/auth_account.dart';
import 'package:smartshrimp_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:smartshrimp_app/features/auth/presentation/view_models/auth_controller.dart';
import 'package:smartshrimp_app/features/pond/domain/entities/pond.dart';
import 'package:smartshrimp_app/features/pond/presentation/pages/pond_detail_page.dart';
import 'package:smartshrimp_app/features/season/domain/entities/aquaculture_season.dart';
import 'package:smartshrimp_app/features/season/presentation/view_models/season_controller.dart';

const _historyBlocker =
    'Ao đã có lịch sử vụ nuôi. Không thể xóa ao khi còn lịch sử vụ nuôi.';
const _openBlocker =
    'Ao đang có vụ nuôi mở. Không thể xóa ao khi còn vụ nuôi hoặc dữ liệu liên quan.';

void main() {
  tearDown(AppNoticeService.hide);

  for (final condition in [
    (
      farmStatus: 'INACTIVE',
      status: 'AVAILABLE',
      type: 'AQUACULTURE',
      open: null,
    ),
    (
      farmStatus: 'FUTURE_STATUS',
      status: 'AVAILABLE',
      type: 'AQUACULTURE',
      open: null,
    ),
    (farmStatus: null, status: 'AVAILABLE', type: 'AQUACULTURE', open: null),
    (
      farmStatus: 'ACTIVE',
      status: 'MAINTENANCE',
      type: 'AQUACULTURE',
      open: null,
    ),
    (
      farmStatus: 'ACTIVE',
      status: 'AVAILABLE',
      type: 'WATER_TREATMENT',
      open: null,
    ),
    (
      farmStatus: 'ACTIVE',
      status: 'AVAILABLE',
      type: 'AQUACULTURE',
      open: 'PLANNING',
    ),
    (
      farmStatus: 'ACTIVE',
      status: 'AVAILABLE',
      type: 'AQUACULTURE',
      open: 'ACTIVE',
    ),
  ]) {
    testWidgets('create button hidden for $condition', (tester) async {
      await _mount(
        tester,
        history: () async => [],
        farmStatus: condition.farmStatus,
        pondStatus: condition.status,
        pondType: condition.type,
        openStatus: condition.open,
      );
      expect(find.text('Thêm vụ nuôi'), findsNothing);
    });
  }

  testWidgets('create button is visible when all four conditions hold', (
    tester,
  ) async {
    await _mount(tester, history: () async => []);
    expect(find.text('Thêm vụ nuôi'), findsOneWidget);
  });

  for (final status in [SeasonStatus.completed, SeasonStatus.cancelled]) {
    testWidgets('$status history blocks deletion without a DELETE request', (
      tester,
    ) async {
      final requests = await _mount(
        tester,
        history: () async => [_season(status)],
      );
      // A local search hiding every season must not bypass the history blocker.
      await tester.enterText(find.byType(TextField), 'no matching season');
      await tester.pumpAndSettle();
      await _openDelete(tester);
      await _expectBlocked(tester, _historyBlocker);
      expect(_deletes(requests), isEmpty);
    });
  }

  for (final status in [SeasonStatus.planning, SeasonStatus.active]) {
    testWidgets('$status open season keeps the existing blocker', (
      tester,
    ) async {
      final requests = await _mount(
        tester,
        openStatus: seasonStatusApiValue(status),
        history: () async => [_season(status)],
      );
      await _openDelete(tester);
      expect(find.text(_historyBlocker), findsOneWidget);
      await _expectBlocked(tester, _openBlocker);
      expect(_deletes(requests), isEmpty);
    });
  }

  testWidgets('loading history disables deletion until it finishes', (
    tester,
  ) async {
    final history = Completer<List<AquacultureSeason>>();
    final requests = await _mount(
      tester,
      history: () => history.future,
      loading: true,
    );
    final button = find.widgetWithText(OutlinedButton, 'Xóa ao');
    await tester.ensureVisible(button);
    await tester.pump();
    expect(tester.widget<OutlinedButton>(button).onPressed, isNull);
    await tester.tap(button);
    await tester.pump();
    expect(find.byType(AlertDialog), findsNothing);
    expect(_deletes(requests), isEmpty);

    history.complete([_season(SeasonStatus.completed)]);
    await tester.pumpAndSettle();
    await _openDelete(tester);
    await _expectBlocked(tester, _historyBlocker);
    expect(_deletes(requests), isEmpty);
  });

  testWidgets('history failure blocks deletion', (tester) async {
    final requests = await _mount(
      tester,
      history: () async => throw const ApiException('History unavailable'),
    );
    await _openDelete(tester);
    await _expectBlocked(tester, 'Không thể tải danh sách vụ nuôi.');
    expect(_deletes(requests), isEmpty);
  });

  testWidgets('empty history confirms, deletes once and returns to farm', (
    tester,
  ) async {
    final requests = await _mount(tester, history: () async => []);
    await _openDelete(tester);
    expect(find.text('Xóa “Ao 1”?'), findsOneWidget);
    expect(_deletes(requests), isEmpty);
    await tester.tap(
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.text('Xóa ao'),
      ),
    );
    await tester.pumpAndSettle();
    expect(_deletes(requests), hasLength(1));
    final request = _deletes(requests).single;
    expect(request.path, '/owner/farms/farm-1/ponds/pond-1');
    expect(request.headers['Authorization'], 'Bearer test-access-token');
    expect(find.text('Đã xóa ao.'), findsOneWidget);
    expect(find.text('Farm Detail'), findsOneWidget);
  });
}

Iterable<RequestOptions> _deletes(List<RequestOptions> requests) =>
    requests.where((request) => request.method == 'DELETE');

Future<void> _openDelete(WidgetTester tester) async {
  final button = find.widgetWithText(OutlinedButton, 'Xóa ao');
  await tester.ensureVisible(button);
  await tester.pumpAndSettle();
  await tester.tap(button);
  await tester.pumpAndSettle();
}

Future<void> _expectBlocked(WidgetTester tester, String message) async {
  expect(find.text('Chưa thể xóa ao'), findsOneWidget);
  expect(find.text(message), findsOneWidget);
  expect(find.text('Đã hiểu'), findsOneWidget);
  final dialog = find.byType(AlertDialog);
  expect(
    find.descendant(
      of: dialog,
      matching: find.byWidgetPredicate((w) => w is ButtonStyleButton),
    ),
    findsOneWidget,
  );
  expect(
    find.descendant(of: dialog, matching: find.text('Xóa ao')),
    findsNothing,
  );
  await tester.tap(find.text('Đã hiểu'));
  await tester.pumpAndSettle();
}

Future<List<RequestOptions>> _mount(
  WidgetTester tester, {
  required Future<List<AquacultureSeason>> Function() history,
  String? openStatus,
  String? farmStatus = 'ACTIVE',
  String pondStatus = 'AVAILABLE',
  String pondType = 'AQUACULTURE',
  bool loading = false,
}) async {
  tester.view.physicalSize = const Size(430, 1000);
  tester.view.devicePixelRatio = 1;
  addTearDown(() {
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });
  final requests = <RequestOptions>[];
  final dio = Dio(BaseOptions(baseUrl: 'https://api.smartshrimp.test'));
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (request, handler) {
        requests.add(request);
        handler.resolve(
          Response<Map<String, dynamic>>(
            requestOptions: request,
            statusCode: 200,
            data: {
              'success': true,
              'message': 'Success',
              'data': {
                'id': 'pond-1',
                'farmId': 'farm-1',
                'name': 'Ao 1',
                'type': pondType,
                'status': pondStatus,
                'farm': {'id': 'farm-1', 'name': 'Farm', 'status': ?farmStatus},
                if (openStatus != null)
                  'currentSeason': {
                    'id': 'season-1',
                    'name': 'Vụ 1',
                    'status': openStatus,
                  },
              },
            },
          ),
        );
      },
    ),
  );
  addTearDown(() => dio.close(force: true));
  final router = GoRouter(
    initialLocation: '/farms/farm-1/ponds/pond-1',
    routes: [
      GoRoute(
        path: '/farms/:farmId',
        builder: (_, _) => const Scaffold(body: Text('Farm Detail')),
        routes: [
          GoRoute(
            path: 'ponds/:pondId',
            builder: (_, _) =>
                const PondDetailPage(farmId: 'farm-1', pondId: 'pond-1'),
          ),
        ],
      ),
    ],
  );
  addTearDown(router.dispose);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        authRepositoryProvider.overrideWithValue(_OwnerAuthRepository()),
        backendDioProvider.overrideWithValue(dio),
        sessionStoreProvider.overrideWithValue(_SessionStore()),
        pondSeasonHistoryProvider((
          farmId: 'farm-1',
          pondId: 'pond-1',
        )).overrideWith((ref) => history()),
      ],
      child: MaterialApp.router(routerConfig: router),
    ),
  );
  if (loading) {
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }
  } else {
    await tester.pumpAndSettle();
  }
  return requests;
}

AquacultureSeason _season(SeasonStatus status) => AquacultureSeason(
  id: 'season-1',
  pondId: 'pond-1',
  name: 'Vụ 1',
  shrimpType: ShrimpType.whiteleg,
  status: status,
  createdBy: 'owner-1',
  createdAt: DateTime.utc(2026, 9, 1),
  updatedAt: DateTime.utc(2026, 9, 30),
  pond: const Pond(
    id: 'pond-1',
    farmId: 'farm-1',
    name: 'Ao 1',
    type: PondType.aquaculture,
    status: PondStatus.available,
  ),
);

final class _OwnerAuthRepository implements AuthRepository {
  static const _owner = AuthAccount(
    id: 'owner-1',
    email: 'owner@smartshrimp.test',
    role: AccountRole.farmOwner,
    status: AccountStatus.active,
  );

  @override
  Future<AuthAccount?> restoreSession() async => _owner;

  @override
  Future<AuthAccount> login({
    required String email,
    required String password,
  }) async => _owner;

  @override
  Future<void> logout() async {}
}

final class _SessionStore implements SessionStore {
  @override
  String? accessToken = 'test-access-token';
  @override
  String? refreshToken = 'test-refresh-token';
  @override
  Future<void> initialize() async {}
  @override
  Future<void> clear() async {}
  @override
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    this.accessToken = accessToken;
    this.refreshToken = refreshToken;
  }
}
