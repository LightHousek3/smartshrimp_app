import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshrimp_app/core/di/core_providers.dart';
import 'package:smartshrimp_app/core/storage/session_store.dart';
import 'package:smartshrimp_app/core/widgets/app_notice.dart';
import 'package:smartshrimp_app/features/auth/domain/entities/auth_account.dart';
import 'package:smartshrimp_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:smartshrimp_app/features/auth/presentation/view_models/auth_controller.dart';
import 'package:smartshrimp_app/features/pond/domain/entities/pond.dart';
import 'package:smartshrimp_app/features/pond/presentation/pages/pond_detail_page.dart';
import 'package:smartshrimp_app/features/season/presentation/pages/season_form_page.dart';
import 'package:smartshrimp_app/features/season/presentation/view_models/season_controller.dart';

const _blockedMessage =
    'Không thể tạo vụ nuôi cho ao này. Ao phải là ao nuôi đang sẵn sàng của trại đang hoạt động và chưa có vụ đang mở.';
const _pondPath = '/farms/farm-1/ponds/pond-1';

void main() {
  tearDown(AppNoticeService.hide);

  for (final condition in <Map<String, dynamic>>[
    {
      'farm': {'id': 'farm-1', 'name': 'Farm', 'status': 'INACTIVE'},
    },
    {
      'farm': {'id': 'farm-1', 'name': 'Farm', 'status': 'FUTURE_STATUS'},
    },
    {
      'farm': {'id': 'farm-1', 'name': 'Farm'},
    },
    {'farm': null},
    {'status': 'MAINTENANCE'},
    {'type': 'WATER_TREATMENT'},
    {
      'currentSeason': {'id': 'open-1', 'name': 'Open', 'status': 'PLANNING'},
    },
    {
      'currentSeason': {'id': 'open-1', 'name': 'Open', 'status': 'ACTIVE'},
    },
  ]) {
    for (final withExtra in [false, true]) {
      testWidgets('ineligible $condition blocks create (extra=$withExtra)', (
        tester,
      ) async {
        final fixture = await _mount(
          tester,
          pondChanges: condition,
          withExtra: withExtra,
        );
        expect(find.byType(SeasonFormPage), findsNothing);
        expect(find.byType(Form), findsNothing);
        expect(find.byType(PondDetailPage), findsOneWidget);
        expect(find.text('Thêm vụ nuôi'), findsNothing);
        expect(find.text(_blockedMessage), findsOneWidget);
        expect(
          fixture.router.routeInformationProvider.value.uri.path,
          _pondPath,
        );
        expect(fixture.requests.where((r) => r.method == 'POST'), isEmpty);
      });
    }
  }

  testWidgets(
    'eligible deep link loads pond and creates through the existing API',
    (tester) async {
      final fixture = await _mount(tester);
      expect(find.byType(Form), findsOneWidget);
      expect(find.text(_blockedMessage), findsNothing);
      expect(fixture.requests.where((r) => r.method == 'POST'), isEmpty);

      await _submit(tester);
      final request = fixture.requests.singleWhere((r) => r.method == 'POST');
      expect(request.path, '/owner/seasons');
      expect(request.headers['Authorization'], 'Bearer test-access-token');
      expect(request.data, containsPair('pondId', 'pond-1'));
      expect(request.data, containsPair('name', 'Vụ mới'));
      expect(request.data, containsPair('shrimpType', 'WHITELEG'));
      expect(find.text('Created Season Detail'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('server conflict after loading is displayed without a crash', (
    tester,
  ) async {
    final fixture = await _mount(tester, conflict: true);
    await _submit(tester);
    expect(fixture.requests.where((r) => r.method == 'POST'), hasLength(1));
    expect(
      find.text('Server rejected concurrent season creation'),
      findsOneWidget,
    );
    expect(find.byType(Form), findsOneWidget);
    expect(find.text('Created Season Detail'), findsNothing);
    expect(tester.takeException(), isNull);
  });
}

Future<void> _submit(WidgetTester tester) async {
  await tester.enterText(find.byType(TextFormField).first, 'Vụ mới');
  await tester.tap(find.text('dd / mm / yyyy').first);
  await tester.pumpAndSettle();
  await tester.tap(find.text('OK'));
  await tester.pumpAndSettle();
  final submit = find.text('Tạo vụ nuôi');
  await tester.ensureVisible(submit);
  await tester.pumpAndSettle();
  await tester.tap(submit);
  await tester.pumpAndSettle();
}

Future<({GoRouter router, List<RequestOptions> requests})> _mount(
  WidgetTester tester, {
  Map<String, dynamic> pondChanges = const {},
  bool withExtra = false,
  bool conflict = false,
}) async {
  tester.view.physicalSize = const Size(430, 1000);
  tester.view.devicePixelRatio = 1;
  addTearDown(() {
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });
  final pond = <String, dynamic>{
    'id': 'pond-1',
    'farmId': 'farm-1',
    'name': 'Ao 1',
    'type': 'AQUACULTURE',
    'status': 'AVAILABLE',
    'areaM2': 1200,
    'farm': {'id': 'farm-1', 'name': 'Farm', 'status': 'ACTIVE'},
    ...pondChanges,
  };
  final requests = <RequestOptions>[];
  final dio = Dio(BaseOptions(baseUrl: 'https://api.smartshrimp.test'));
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (request, handler) {
        requests.add(request);
        if (request.method == 'POST' && conflict) {
          handler.reject(
            DioException(
              requestOptions: request,
              type: DioExceptionType.badResponse,
              response: Response<Map<String, dynamic>>(
                requestOptions: request,
                statusCode: 409,
                data: {
                  'success': false,
                  'statusCode': 409,
                  'message': 'Server rejected concurrent season creation',
                },
              ),
            ),
          );
          return;
        }
        handler.resolve(
          Response<Map<String, dynamic>>(
            requestOptions: request,
            statusCode: request.method == 'POST' ? 201 : 200,
            data: {
              'success': true,
              'message': 'Success',
              'data': request.method == 'POST'
                  ? {
                      'id': 'season-1',
                      'pondId': 'pond-1',
                      'name': 'Vụ mới',
                      'shrimpType': 'WHITELEG',
                      'status': 'PLANNING',
                      'createdBy': 'owner-1',
                      'createdAt': '2026-11-08T00:00:00.000Z',
                      'updatedAt': '2026-11-08T00:00:00.000Z',
                      'pond': pond,
                    }
                  : pond,
            },
          ),
        );
      },
    ),
  );
  addTearDown(() => dio.close(force: true));
  final router = GoRouter(
    initialLocation: '$_pondPath/seasons/create',
    initialExtra: withExtra ? Pond.parse(pond) : null,
    routes: [
      GoRoute(
        path: '/farms/:farmId/ponds/:pondId',
        builder: (_, _) =>
            const PondDetailPage(farmId: 'farm-1', pondId: 'pond-1'),
        routes: [
          GoRoute(
            path: 'seasons/create',
            builder: (_, state) => SeasonCreatePage(
              farmId: state.pathParameters['farmId']!,
              pondId: state.pathParameters['pondId']!,
              initialPond: state.extra is Pond ? state.extra! as Pond : null,
            ),
          ),
          GoRoute(
            path: 'seasons/:seasonId',
            builder: (_, _) =>
                const Scaffold(body: Text('Created Season Detail')),
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
        )).overrideWith((ref) async => []),
      ],
      child: MaterialApp.router(routerConfig: router),
    ),
  );
  await tester.pumpAndSettle();
  return (router: router, requests: requests);
}

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
