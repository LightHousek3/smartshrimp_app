import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/network/api_client.dart';
import 'package:smartshrimp_app/core/storage/session_store.dart';
import 'package:smartshrimp_app/features/auth/domain/entities/auth_account.dart';
import 'package:smartshrimp_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:smartshrimp_app/features/auth/presentation/view_models/auth_controller.dart';
import 'package:smartshrimp_app/features/harvest/data/services/harvest_api_service.dart';
import 'package:smartshrimp_app/features/harvest/domain/entities/harvest_event.dart';
import 'package:smartshrimp_app/features/harvest/domain/repositories/harvest_repository.dart';
import 'package:smartshrimp_app/features/harvest/presentation/pages/harvest_list_page.dart';
import 'package:smartshrimp_app/features/harvest/presentation/pages/harvest_detail_page.dart';
import 'package:smartshrimp_app/features/harvest/presentation/pages/harvest_form_page.dart';
import 'package:smartshrimp_app/features/harvest/presentation/view_models/harvest_controller.dart';
import 'package:smartshrimp_app/features/harvest/presentation/widgets/harvest_ui.dart';
import 'package:smartshrimp_app/features/pond/domain/entities/pond.dart';
import 'package:smartshrimp_app/features/season/domain/entities/aquaculture_season.dart';
import 'package:smartshrimp_app/features/season/domain/repositories/season_repository.dart';
import 'package:smartshrimp_app/features/season/presentation/view_models/season_controller.dart';

Map<String, dynamic> eventJson() => {
  'id': 'harvest-1',
  'seasonId': 'season-1',
  'harvestType': 'PARTIAL',
  'harvestedAt': '2026-09-03T05:30:00+07:00',
  'totalWeightKg': 620,
  'quantityCount': '43400',
  'avgSizePerKg': 70,
  'pricePerKg': 190000,
  'totalRevenue': 117800000,
  'estimatedRemainingCount': '100000',
  'buyerName': 'Vựa tôm Minh Phát',
  'buyerContact': null,
  'note': 'Thu tỉa giảm mật độ.',
  'recordedBy': 'owner',
  'recorderName': 'Nguyễn Văn Đạt',
  'createdAt': '2026-09-03T05:40:00+07:00',
  'season': {
    'id': 'season-1',
    'name': 'Vụ Thu 2025',
    'status': 'ACTIVE',
    'pond': {
      'id': 'pond',
      'name': 'Ao B1',
      'farm': {'id': 'farm', 'name': 'Trang trại Cửa Lấp'},
    },
  },
};
HarvestPage page({
  List<HarvestEvent>? items,
  bool more = false,
  String? cursor,
}) => HarvestPage(
  items: items ?? [HarvestEvent.fromJson(eventJson())],
  limit: 20,
  totalResults: 1,
  hasNextPage: more,
  nextCursor: cursor,
  totalWeightKg: 620,
  totalRevenue: 117800000,
);
const owner = AuthAccount(
  id: 'owner',
  email: 'owner@test.vn',
  role: AccountRole.farmOwner,
  status: AccountStatus.active,
);
AquacultureSeason season(SeasonStatus status) => AquacultureSeason(
  id: 'season-1',
  pondId: 'pond',
  name: 'Vụ Thu 2025',
  shrimpType: ShrimpType.whiteleg,
  status: status,
  createdBy: 'owner',
  createdAt: DateTime(2026),
  updatedAt: DateTime(2026),
  stockingDate: DateTime(2026, 1, 1),
  initialQuantity: 200000,
  pond: const Pond(
    id: 'pond',
    farmId: 'farm',
    name: 'Ao B1',
    type: PondType.aquaculture,
    status: PondStatus.available,
  ),
);

void main() {
  setUpAll(() async {
    // Test engines use Ahem by default; load bundled fonts for readable render captures.
    final loader = FontLoader('Roboto')
      ..addFont(
        rootBundle.load(
          'assets/fonts/google_fonts/PlusJakartaSans-Regular.ttf',
        ),
      );
    await loader.load();
    final icons = FontLoader('MaterialIcons')
      ..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'));
    await icons.load();
  });
  test('parses BE counts, decimals, nullable facts and safe unknown enum', () {
    final event = HarvestEvent.fromJson(eventJson());
    expect(event.quantityCount, '43400');
    expect(event.totalWeightKg, 620);
    expect(event.buyerContact, isNull);
    expect(
      HarvestEvent.fromJson({
        ...eventJson(),
        'harvestType': 'FUTURE_TYPE',
      }).harvestType,
      HarvestType.unknown,
    );
    expect(harvestNumber(117800000), '117.800.000');
    expect(harvestNumber(620.125), '620,125');
  });
  for (final invalid in <Map<String, dynamic>>[
    {'id': ''},
    {'totalWeightKg': 0},
    {'totalWeightKg': '620'},
    {'harvestedAt': 'bad'},
    {'quantityCount': 123},
    {'quantityCount': '-1'},
    {'totalRevenue': -1},
    {'season': {}},
  ]) {
    test(
      'rejects malformed BE data $invalid',
      () => expect(
        () => HarvestEvent.fromJson({...eventJson(), ...invalid}),
        throwsA(isA<InvalidResponseException>()),
      ),
    );
  }
  test(
    'API requests preserve auth, path, filters, body and idempotency header',
    () async {
      final requests = <RequestOptions>[];
      final dio = Dio(BaseOptions(baseUrl: 'https://smartshrimp.test'));
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (request, handler) {
            requests.add(request);
            handler.resolve(
              Response(
                requestOptions: request,
                statusCode: 200,
                data: {
                  'success': true,
                  'message': 'OK',
                  'data':
                      request.method == 'GET' &&
                          request.path.endsWith('harvests')
                      ? [eventJson()]
                      : eventJson(),
                  'meta': {
                    'limit': 20,
                    'totalResults': 1,
                    'hasNextPage': false,
                    'nextCursor': null,
                    'totalWeightKg': 620,
                    'totalRevenue': 117800000,
                  },
                },
              ),
            );
          },
        ),
      );
      final api = HarvestApiService(ApiClient(dio, _Session()));
      final listed = await api.list('season 1', {
        'harvestType': 'PARTIAL',
        'cursor': 'cursor',
      });
      expect(listed.totalResults, 1);
      expect(requests.last.path, '/owner/seasons/season%201/harvests');
      expect(requests.last.queryParameters, {
        'harvestType': 'PARTIAL',
        'cursor': 'cursor',
      });
      await api.detail('season 1', 'harvest 1');
      expect(
        requests.last.path,
        '/owner/seasons/season%201/harvests/harvest%201',
      );
      final body = {'harvestType': 'FINAL', 'totalWeightKg': 620};
      await api.record('season-1', body, 'key-1');
      expect(requests.last.method, 'POST');
      expect(requests.last.data, body);
      expect(requests.last.headers['Idempotency-Key'], 'key-1');
      expect(
        requests.every((r) => r.headers['Authorization'] == 'Bearer token'),
        isTrue,
      );
    },
  );
  test('rejects incomplete pagination metadata', () async {
    final dio = Dio(BaseOptions(baseUrl: 'https://smartshrimp.test'));
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (r, h) => h.resolve(
          Response(
            requestOptions: r,
            statusCode: 200,
            data: {
              'success': true,
              'message': 'OK',
              'data': [],
              'meta': {'limit': 20},
            },
          ),
        ),
      ),
    );
    await expectLater(
      HarvestApiService(ApiClient(dio, _Session())).list('season', {}),
      throwsA(isA<InvalidResponseException>()),
    );
  });
  for (final status in [400, 403, 404, 409, 429, 500]) {
    test('API retains error status $status and server message', () async {
      final dio = Dio(BaseOptions(baseUrl: 'https://smartshrimp.test'));
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (r, h) => h.reject(
            DioException(
              requestOptions: r,
              type: DioExceptionType.badResponse,
              response: Response(
                requestOptions: r,
                statusCode: status,
                data: {
                  'success': false,
                  'statusCode': status,
                  'message': 'Harvest error',
                },
              ),
            ),
          ),
        ),
      );
      await expectLater(
        HarvestApiService(ApiClient(dio, _Session())).detail('season', 'event'),
        throwsA(
          isA<AppException>()
              .having((e) => e.statusCode, 'status', status)
              .having((e) => e.message, 'message', 'Harvest error'),
        ),
      );
    });
  }
  test(
    'unchanged retry retains key and duplicate in-flight submission is blocked',
    () async {
      final repo = _HarvestRepo();
      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(_AuthRepo()),
          harvestRepositoryProvider.overrideWithValue(repo),
        ],
      );
      addTearDown(container.dispose);
      await container.read(authControllerProvider.future);
      final provider = harvestMutationProvider('season-1');
      final subscription = container.listen(provider, (_, _) {});
      addTearDown(subscription.close);
      await container.read(provider.future);
      final notifier = container.read(provider.notifier);
      repo.recordError = const NetworkException();
      await expectLater(
        notifier.submit({'totalWeightKg': 620}),
        throwsA(isA<NetworkException>()),
      );
      repo.recordError = null;
      await notifier.submit({'totalWeightKg': 620});
      expect(repo.keys[0], repo.keys[1]);
      repo.recordWait = Completer<HarvestEvent>();
      final pending = notifier.submit({'totalWeightKg': 621});
      await expectLater(
        notifier.submit({'totalWeightKg': 621}),
        throwsA(isA<ApiException>()),
      );
      repo.recordWait!.complete(HarvestEvent.fromJson(eventJson()));
      await pending;
      expect(repo.keys[2], isNot(repo.keys[1]));
    },
  );
  test('non-owner cannot request harvest data', () async {
    final repo = _HarvestRepo();
    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(
          _AuthRepo(role: AccountRole.technician),
        ),
        harvestRepositoryProvider.overrideWithValue(repo),
      ],
    );
    addTearDown(container.dispose);
    await container.read(authControllerProvider.future);
    const query = (
      seasonId: 'season-1',
      harvestType: null,
      from: null,
      to: null,
      cursor: null,
    );
    final subscription = container.listen(
      harvestListProvider(query),
      (_, _) {},
    );
    addTearDown(subscription.close);
    await expectLater(
      container.read(harvestListProvider(query).future),
      throwsA(isA<UnsupportedRoleException>()),
    );
    expect(repo.queries, isEmpty);
  });

  Future<void> mount(
    WidgetTester tester,
    _HarvestRepo repo, {
    String route = '/harvests',
    SeasonStatus status = SeasonStatus.active,
  }) async {
    tester.view.physicalSize = const Size(403, 874);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    final router = GoRouter(
      initialLocation: route,
      routes: [
        GoRoute(
          path: '/harvests',
          builder: (_, _) => const HarvestListPage(seasonId: 'season-1'),
          routes: [
            GoRoute(
              path: 'create',
              builder: (_, _) => const HarvestFormPage(seasonId: 'season-1'),
            ),
            GoRoute(
              path: ':id',
              builder: (_, _) => const HarvestDetailPage(
                seasonId: 'season-1',
                harvestId: 'harvest-1',
              ),
            ),
          ],
        ),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(_AuthRepo()),
          harvestRepositoryProvider.overrideWithValue(repo),
          seasonRepositoryProvider.overrideWithValue(_SeasonRepo(status)),
        ],
        child: RepaintBoundary(
          key: const Key('capture'),
          child: MaterialApp.router(
            routerConfig: router,
            theme: AppTheme.light,
            debugShowCheckedModeBanner: false,
          ),
        ),
      ),
    );
    await tester.runAsync(() async {
      await GoogleFonts.pendingFonts();
    });
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
  }

  Future<void> capture(WidgetTester tester, String name) async {
    if (!const bool.fromEnvironment('HARVEST_CAPTURE')) return;
    final boundary = tester.renderObject<RenderRepaintBoundary>(
      find.byKey(const Key('capture')),
    );
    await tester.runAsync(() async {
      final image = await boundary.toImage();
      final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
      final file = File('../reports/harvest-$name.png');
      await file.parent.create(recursive: true);
      await file.writeAsBytes(bytes!.buffer.asUint8List());
      image.dispose();
    });
  }

  testWidgets('list loading, server error, retry, empty state and filters', (
    tester,
  ) async {
    final repo = _HarvestRepo()..listWait = Completer<HarvestPage>();
    await mount(tester, repo);
    expect(find.byType(CircularProgressIndicator), findsWidgets);
    repo.listWait!.completeError(
      const ApiException('Không có quyền xem', statusCode: 403),
    );
    await tester.pumpAndSettle();
    expect(find.text('Không có quyền xem'), findsOneWidget);
    repo.listWait = null;
    repo.result = page(items: []);
    await tester.tap(find.text('Thử lại'));
    await tester.pumpAndSettle();
    expect(find.text('Chưa có lần thu hoạch phù hợp.'), findsOneWidget);
    await tester.tap(find.widgetWithText(ChoiceChip, 'Thu tỉa'));
    await tester.pumpAndSettle();
    expect(repo.queries.last['harvestType'], 'PARTIAL');
    expect(repo.queries.last.containsKey('cursor'), isFalse);
  });
  testWidgets('pagination carries cursor and filter reset clears it', (
    tester,
  ) async {
    final repo = _HarvestRepo()..result = page(more: true, cursor: 'next');
    await mount(tester, repo);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Trang sau'));
    await tester.pumpAndSettle();
    expect(repo.queries.last['cursor'], 'next');
    await tester.tap(find.widgetWithText(ChoiceChip, 'Thu hoạch cuối'));
    await tester.pumpAndSettle();
    expect(repo.queries.last['harvestType'], 'FINAL');
    expect(repo.queries.last.containsKey('cursor'), isFalse);
  });
  testWidgets('list and detail render facts and retain completed history', (
    tester,
  ) async {
    await mount(tester, _HarvestRepo(), status: SeasonStatus.completed);
    await tester.pumpAndSettle();
    expect(find.text('Ghi nhận thu hoạch'), findsNothing);
    expect(find.text('620 kg'), findsWidgets);
    await capture(tester, 'list');
    await tester.tap(find.byKey(const ValueKey('harvest-harvest-1')));
    await tester.pumpAndSettle();
    expect(find.text('Chi tiết thu hoạch'), findsOneWidget);
    expect(find.text('Sản lượng và giá bán'), findsOneWidget);
    await capture(tester, 'detail');
    expect(tester.takeException(), isNull);
  });
  testWidgets(
    'partial form requires remaining estimate; final form warns and hides it',
    (tester) async {
      await mount(tester, _HarvestRepo(), route: '/harvests/create');
      await tester.pumpAndSettle();
      expect(
        find.byKey(const ValueKey('harvest-field-remaining')),
        findsOneWidget,
      );
      final weight = tester
          .widget<TextFormField>(
            find.byKey(const ValueKey('harvest-field-weight')),
          )
          .validator!;
      final remaining = tester
          .widget<TextFormField>(
            find.byKey(const ValueKey('harvest-field-remaining')),
          )
          .validator!;
      expect(weight('0'), isNotNull);
      expect(weight('1.0001'), isNotNull);
      expect(weight('1,125'), isNull);
      expect(remaining(''), isNotNull);
      expect(remaining('0'), isNotNull);
      expect(remaining('1.5'), isNotNull);
      expect(remaining('1'), isNull);
      await capture(tester, 'partial');
      await tester.tap(find.text('Thu hoạch cuối'));
      await tester.pumpAndSettle();
      expect(
        find.byKey(const ValueKey('harvest-field-remaining')),
        findsNothing,
      );
      expect(
        find.text('Thu hoạch cuối sẽ kết thúc vụ nuôi. Không thể hoàn tác.'),
        findsOneWidget,
      );
      await capture(tester, 'final');
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'final confirmation can be cancelled and successful submit returns to history',
    (tester) async {
      final repo = _HarvestRepo();
      await mount(tester, repo, route: '/harvests/create');
      await tester.pumpAndSettle();
      await tester.tap(find.text('Thu hoạch cuối'));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const ValueKey('harvest-field-weight')),
        '480',
      );
      await tester.tap(find.text('Chọn ngày và giờ'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Ghi nhận thu hoạch cuối'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Ghi nhận thu hoạch cuối'));
      await tester.pumpAndSettle();
      expect(find.text('Xác nhận thu hoạch cuối'), findsOneWidget);
      expect(repo.keys, isEmpty);
      await tester.tap(find.text('Quay lại'));
      await tester.pumpAndSettle();
      expect(repo.keys, isEmpty);
      await tester.tap(find.text('Ghi nhận thu hoạch cuối'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Xác nhận'));
      await tester.pumpAndSettle();
      expect(repo.keys, hasLength(1));
      expect(repo.bodies.single, containsPair('harvestType', 'FINAL'));
      expect(repo.bodies.single, containsPair('estimatedRemainingCount', 0));
      expect(find.text('Danh sách thu hoạch'), findsOneWidget);
    },
  );
}

class _HarvestRepo implements HarvestRepository {
  HarvestPage result = page();
  final queries = <Map<String, dynamic>>[];
  final keys = <String>[];
  final bodies = <Map<String, dynamic>>[];
  Object? recordError;
  Completer<HarvestPage>? listWait;
  Completer<HarvestEvent>? recordWait;
  @override
  Future<HarvestPage> list(String seasonId, Map<String, dynamic> query) {
    queries.add(Map.of(query));
    return listWait?.future ?? Future.value(result);
  }

  @override
  Future<HarvestEvent> detail(String seasonId, String harvestId) async =>
      HarvestEvent.fromJson(eventJson());
  @override
  Future<HarvestEvent> record(
    String seasonId,
    Map<String, dynamic> body,
    String key,
  ) async {
    keys.add(key);
    bodies.add(Map.of(body));
    if (recordError != null) throw recordError!;
    return recordWait?.future ?? HarvestEvent.fromJson(eventJson());
  }
}

class _AuthRepo implements AuthRepository {
  _AuthRepo({this.role = AccountRole.farmOwner});
  final AccountRole role;
  @override
  Future<AuthAccount?> restoreSession() async => owner.copyWith(role: role);
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _SeasonRepo implements SeasonRepository {
  _SeasonRepo(this.status);
  final SeasonStatus status;
  @override
  Future<AquacultureSeason> getSeason(String seasonId) async => season(status);
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Session implements SessionStore {
  @override
  String? accessToken = 'token';
  @override
  String? refreshToken = 'refresh';
  @override
  Future<void> initialize() async {}
  @override
  Future<void> clear() async {
    accessToken = null;
    refreshToken = null;
  }

  @override
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    this.accessToken = accessToken;
    this.refreshToken = refreshToken;
  }
}
