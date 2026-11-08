import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/app/app.dart';
import 'package:smartshrimp_app/app/router/app_router.dart';
import 'package:smartshrimp_app/core/di/core_providers.dart';
import 'package:smartshrimp_app/core/storage/session_store.dart';
import 'package:smartshrimp_app/features/auth/domain/entities/auth_account.dart';
import 'package:smartshrimp_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:smartshrimp_app/features/auth/presentation/view_models/auth_controller.dart';
import 'package:smartshrimp_app/features/notifications/presentation/view_models/notification_controller.dart';
import 'package:smartshrimp_app/features/season/domain/entities/aquaculture_season.dart';
import 'package:smartshrimp_app/features/season/presentation/pages/season_detail_page.dart';
import 'package:smartshrimp_app/features/water_log/domain/entities/water_log.dart';
import 'package:smartshrimp_app/features/water_log/domain/entities/water_log_metadata.dart';
import 'package:smartshrimp_app/features/water_log/presentation/pages/owner_water_log_list_page.dart';
import 'package:smartshrimp_app/features/water_log/presentation/pages/water_log_statistics_page.dart';
import 'package:smartshrimp_app/features/water_log/presentation/widgets/owner_water_log_card.dart';
import 'package:smartshrimp_app/features/water_log/presentation/widgets/water_trend_chart.dart';
import '../../support/load_app_fonts.dart';
import '../home/owner_dashboard_fixtures.dart';
import 'water_statistics_fixtures.dart';

const _seasonPath = '/farms/farm/ponds/pond/seasons/season';
const _ownerPath = '$_seasonPath/water-logs';

Map<String, dynamic> _log(
  String id, {
  bool warning = false,
  bool voided = false,
}) => {
  'id': id,
  'seasonId': 'season',
  'recordedAt': '2026-09-18T06:15:00Z',
  'createdAt': '2026-09-18T06:15:00Z',
  'recordedBy': 'former-technician',
  'recordedByName': id == 'voided' ? null : 'Người ghi lịch sử',
  'isVoided': voided,
  'voidReason': voided ? 'Sai mẫu nước' : null,
  'voidedAt': voided ? '2026-09-19T00:00:00Z' : null,
  'temperatureC': 28.5,
  'ph': warning ? 9 : 8,
  'dissolvedOxygenMgL': 5.2,
  'salinityPpt': 15.3,
  'nh3MgL': .012,
  'no2MgL': .08,
  'alkalinityMgLCaCO3': 142,
  'h2sMgL': .00001,
  'exceededParameters': warning ? ['ph'] : [],
  'note': warning ? 'Sau mưa, đã báo chuyên gia.' : null,
};

final _season = <String, dynamic>{
  'id': 'season',
  'pondId': 'pond',
  'name': 'Vụ Owner',
  'status': 'ACTIVE',
  'shrimpType': 'WHITELEG',
  'createdBy': 'owner',
  'createdAt': '2026-01-01T00:00:00Z',
  'updatedAt': '2026-01-01T00:00:00Z',
  'pond': {
    'id': 'pond',
    'farmId': 'farm',
    'name': 'Ao Owner',
    'type': 'AQUACULTURE',
    'status': 'AVAILABLE',
    'farm': {'id': 'farm', 'name': 'Farm', 'status': 'ACTIVE'},
  },
};

class _Harness {
  final requests = <RequestOptions>[];
  int? listError;
  bool failNextPage = false, empty = false;
  Completer<void>? pending;
  late ProviderContainer container;
  Future<void> open(
    WidgetTester tester, {
    String route = _ownerPath,
    AccountRole role = AccountRole.farmOwner,
  }) async {
    await loadAppFonts();
    tester.view.physicalSize = const Size(430, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final dio = Dio(BaseOptions(baseUrl: 'https://smartshrimp.test'));
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (request, handler) async {
          requests.add(request);
          final path = request.path;
          final list = path == '/owner/seasons/season/water-logs';
          final cursor = request.queryParameters['cursor'];
          if (list && pending != null) await pending!.future;
          final status = list
              ? (listError ?? (cursor != null && failNextPage ? 500 : null))
              : null;
          if (status != null) {
            handler.reject(
              DioException(
                requestOptions: request,
                type: DioExceptionType.badResponse,
                response: Response(
                  requestOptions: request,
                  statusCode: status,
                  data: {
                    'success': false,
                    'statusCode': status,
                    'message': 'Owner water unavailable',
                  },
                ),
              ),
            );
            return;
          }
          Object? data = <String, dynamic>{};
          Map<String, dynamic>? meta;
          if (path == '/owner/seasons/season') data = _season;
          if (path.endsWith('/water-logs/metadata')) {
            final metadata = WaterLogMetadata.legacy(ShrimpType.whiteleg);
            data = {
              ...metadata.toJson(),
              'metrics': metadata.metrics.map((m) => m.toJson()).toList(),
            };
          }
          if (path.endsWith('/water-logs/statistics')) data = statisticsJson();
          if (list) {
            final filter = request.queryParameters['filter'];
            data = empty
                ? []
                : switch (filter) {
                    'warning' => [_log('warning', warning: true)],
                    'voided' => [_log('voided', voided: true)],
                    _ =>
                      cursor == null
                          ? [_log('normal'), _log('warning', warning: true)]
                          : [_log('voided', voided: true)],
                  };
            meta = {
              'totalResults': empty
                  ? 0
                  : filter == 'all'
                  ? 3
                  : 1,
              'hasNextPage': !empty && filter == 'all' && cursor == null,
              'nextCursor': !empty && filter == 'all' && cursor == null
                  ? 'next'
                  : null,
              if (cursor == null)
                'counts': {
                  'all': empty ? 0 : 3,
                  'valid': empty ? 0 : 2,
                  'warning': empty ? 0 : 1,
                  'voided': empty ? 0 : 1,
                },
            };
          }
          handler.resolve(
            Response(
              requestOptions: request,
              statusCode: 200,
              data: {
                'success': true,
                'message': 'OK',
                'data': data,
                'meta': ?meta,
              },
            ),
          );
        },
      ),
    );
    addTearDown(() => dio.close(force: true));
    container = ProviderContainer(
      retry: (_, _) => null,
      overrides: [
        authRepositoryProvider.overrideWithValue(_Auth(role)),
        backendDioProvider.overrideWithValue(dio),
        sessionStoreProvider.overrideWithValue(_Session()),
        notificationRepositoryProvider.overrideWithValue(
          DashboardFixtureNotifications(),
        ),
        notificationSocketProvider.overrideWith((ref) => null),
      ],
    );
    addTearDown(container.dispose);
    await container.read(authControllerProvider.future);
    container.read(appRouterProvider).go(route);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const SmartShrimpApp(),
      ),
    );
    if (pending == null) {
      await tester.pumpAndSettle();
    } else {
      for (var i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }
    }
  }
}

void main() {
  testWidgets(
    'Owner shortcut opens read-only journal and statistics through the real router',
    (tester) async {
      final h = _Harness();
      await h.open(tester, route: _seasonPath);
      await tester.ensureVisible(find.text('Đo nước'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Đo nước'));
      await tester.pumpAndSettle();
      expect(find.byType(OwnerWaterLogListPage), findsOneWidget);
      expect(find.text('Ao Owner · Vụ Owner'), findsOneWidget);
      expect(find.text('Tất cả (3)'), findsOneWidget);
      expect(find.text('Người ghi lịch sử'), findsNWidgets(2));
      expect(find.text('Sau mưa, đã báo chuyên gia.'), findsOneWidget);
      expect(find.text('Nhập nhật ký đo nước'), findsNothing);
      expect(find.text('Không tải được ngưỡng Min/Max.'), findsNothing);
      expect(
        h.requests.where(
          (r) => r.path.startsWith('/me/') || r.path.contains('/assigned'),
        ),
        isEmpty,
      );
      final card = find.byKey(const ValueKey('owner_water_log_normal'));
      await tester.ensureVisible(card);
      await tester.tap(card);
      await tester.pumpAndSettle();
      expect(find.text('Hủy hiệu lực'), findsNothing);
      await tester.tap(find.byKey(const Key('close_owner_water_log')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('owner_water_statistics_button')));
      await tester.pumpAndSettle();
      expect(find.byType(WaterLogStatisticsPage), findsOneWidget);
      expect(find.byType(WaterTrendChart), findsOneWidget);
      final stat = h.requests.singleWhere(
        (r) => r.path.endsWith('/water-logs/statistics'),
      );
      expect(
        DateTime.parse(
          stat.queryParameters['to'],
        ).difference(DateTime.parse(stat.queryParameters['from'])),
        const Duration(days: 7),
      );
      h.container.read(appRouterProvider).pop();
      await tester.pumpAndSettle();
      expect(find.byType(OwnerWaterLogListPage), findsOneWidget);
      h.container.read(appRouterProvider).pop();
      await tester.pumpAndSettle();
      expect(find.byType(SeasonDetailPage), findsOneWidget);
      expect(h.requests.every((r) => r.method == 'GET'), isTrue);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'Owner filters, void audit, pagination retry and refresh reuse shared reads',
    (tester) async {
      final h = _Harness()..failNextPage = true;
      await h.open(tester);
      expect(find.text('Ao Owner · Vụ Owner'), findsOneWidget);
      final more = find.text('Tải thêm');
      await tester.ensureVisible(more);
      await tester.pumpAndSettle();
      await tester.tap(more);
      await tester.pumpAndSettle();
      expect(find.text('Owner water unavailable'), findsOneWidget);
      h.failNextPage = false;
      await tester.ensureVisible(find.text('Thử lại'));
      await tester.tap(find.text('Thử lại'));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('owner_water_filter_voided')));
      await tester.pumpAndSettle();
      expect(find.text('Chưa cập nhật tên'), findsOneWidget);
      expect(find.text('Vô hiệu (1)'), findsOneWidget);
      final card = tester.widget<OwnerWaterLogCard>(
        find.byType(OwnerWaterLogCard),
      );
      expect(card.log.isVoided, isTrue);
      await tester.tap(find.byType(OwnerWaterLogCard));
      await tester.pumpAndSettle();
      expect(find.text('Sai mẫu nước'), findsOneWidget);
      expect(find.byType(TextField), findsNothing);
      await tester.tap(find.byKey(const Key('close_owner_water_log')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('owner_water_filter_warning')));
      await tester.pumpAndSettle();
      expect(find.text('Sau mưa, đã báo chuyên gia.'), findsOneWidget);
      final refresh = tester
          .widget<RefreshIndicator>(find.byType(RefreshIndicator).last)
          .onRefresh();
      await tester.pumpAndSettle();
      await refresh;
      final lists = h.requests
          .where((r) => r.path == '/owner/seasons/season/water-logs')
          .toList();
      expect(lists.any((r) => r.queryParameters['cursor'] == 'next'), isTrue);
      expect(lists.last.queryParameters['filter'], 'warning');
      expect(lists.first.queryParameters['includeCounts'], isTrue);
      expect(h.requests.every((r) => r.method == 'GET'), isTrue);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'Owner loading, forbidden error, retry and empty states are readable',
    (tester) async {
      final h = _Harness()
        ..pending = Completer<void>()
        ..listError = 403;
      await h.open(tester);
      expect(find.byType(CircularProgressIndicator), findsWidgets);
      h.pending!.complete();
      h.pending = null;
      await tester.pumpAndSettle();
      expect(find.text('Owner water unavailable'), findsOneWidget);
      h.listError = null;
      h.empty = true;
      await tester.tap(find.text('Thử lại').last);
      await tester.pumpAndSettle();
      expect(find.text('Chưa có nhật ký đo nước.'), findsOneWidget);
      expect(find.text('Tất cả (0)'), findsOneWidget);
      expect(find.byType(OwnerWaterLogCard), findsNothing);
    },
  );

  test(
    'recordedByName is optional and never inferred from the current assignment',
    () {
      final json = _log('normal');
      expect(WaterLog.parse(json).recordedByName, 'Người ghi lịch sử');
      json.remove('recordedByName');
      expect(WaterLog.parse(json).recordedByName, isNull);
      expect(WaterLog.parse(json).recordedBy, 'former-technician');
    },
  );

  testWidgets('non-owner cannot enter the owner journal route', (tester) async {
    final h = _Harness();
    await h.open(tester, role: AccountRole.technician);
    expect(find.byType(OwnerWaterLogListPage), findsNothing);
    expect(
      h.container
          .read(appRouterProvider)
          .routeInformationProvider
          .value
          .uri
          .path,
      '/',
    );
    expect(h.requests.where((r) => r.path.contains('/water-logs')), isEmpty);
  });

  testWidgets(
    'Owner cards keep eight metrics and readable void history at 320px',
    (tester) async {
      await loadAppFonts();
      tester.view.physicalSize = const Size(320, 1100);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: OwnerWaterLogCard(
                log: WaterLog.parse(
                  _log('voided', warning: true, voided: true),
                ),
                metadata: WaterLogMetadata.legacy(ShrimpType.whiteleg),
                showAudit: true,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      for (final param in waterLogFormParams) {
        expect(find.text(param.label), findsOneWidget);
      }
      expect(find.text('Chưa cập nhật tên'), findsOneWidget);
      expect(find.text('Sai mẫu nước'), findsOneWidget);
      expect(tester.widget<Opacity>(find.byType(Opacity).first).opacity, .65);
      expect(find.text('Hủy hiệu lực'), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );
}

class _Auth implements AuthRepository {
  _Auth(this.role);
  final AccountRole role;
  @override
  Future<AuthAccount?> restoreSession() async => AuthAccount(
    id: 'owner',
    email: 'owner@test.vn',
    role: role,
    status: AccountStatus.active,
  );
  @override
  Future<AuthAccount> login({
    required String email,
    required String password,
  }) async => (await restoreSession())!;
  @override
  Future<void> logout() async {}
}

class _Session implements SessionStore {
  @override
  String? accessToken = 'test-token';
  @override
  String? refreshToken = 'test-refresh';
  @override
  Future<void> initialize() async {}
  @override
  Future<void> clear() async {}
  @override
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {}
}
