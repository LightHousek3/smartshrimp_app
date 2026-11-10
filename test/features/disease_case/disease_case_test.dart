import 'dart:async';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/di/core_providers.dart';
import 'package:smartshrimp_app/core/network/api_client.dart';
import 'package:smartshrimp_app/core/network/cloudinary_image_storage.dart';
import 'package:smartshrimp_app/features/auth/domain/entities/auth_account.dart';
import 'package:smartshrimp_app/features/auth/presentation/view_models/auth_controller.dart';
import 'package:smartshrimp_app/features/disease_case/domain/domain.dart';
import 'package:smartshrimp_app/features/disease_case/data/data.dart';
import 'package:smartshrimp_app/features/disease_case/presentation/presentation.dart';
import 'package:smartshrimp_app/features/notifications/data/services/notification_socket.dart';
import 'package:smartshrimp_app/features/notifications/presentation/view_models/notification_controller.dart';
import '../home/owner_dashboard_fixtures.dart';
import '../task/task_api_test.dart' show TaskSessionStore;

Map<String, dynamic> caseJson() => {
  'id': 'case',
  'seasonId': 'season',
  'title': 'Tôm giảm ăn',
  'description': 'Tình trạng quan sát tại ao',
  'severity': 'HIGH',
  'status': 'OPEN',
  'updatedAt': '2026-10-30T01:00:00.123Z',
  'createdAt': '2026-10-30T01:00:00Z',
  'canRespond': true,
  'caseSnapshot': {'seasonName': 'Vụ 1', 'pondName': 'Ao 1'},
  'responses': <dynamic>[],
};
DiseaseCase get fixture => DiseaseCase.fromJson(caseJson());

class CaseFixtureRepository implements DiseaseCaseRepository {
  @override
  Future<CaseCreationOptions> creationOptions(String seasonId) async {
    if (optionsFailure != null) throw optionsFailure!;
    return options;
  }

  CaseCreationOptions options = const CaseCreationOptions();
  Object? optionsFailure;
  String? selectedAi;
  CaseResponseType? sentType;
  String? sentMessage;
  DateTime? sentVersion;
  Object? mutationFailure;
  bool? lastResolved;
  int? lastPage;
  DiseaseCase item = fixture;
  Object? failure;
  Completer<DiseaseCase>? pending;
  int mutations = 0;
  int lists = 0;
  bool canCreate = true;
  bool empty = false;
  @override
  Future<DiseaseCasePage> list(
    String seasonId, {
    int page = 1,
    DiseaseCaseStatus? status,
    bool? resolved,
  }) async {
    lists++;
    lastResolved = resolved;
    lastPage = page;
    if (failure != null) throw failure!;
    return DiseaseCasePage(
      items: empty ? [] : [item],
      page: page,
      totalResults: empty ? 0 : 21,
      hasNextPage: !empty && page == 1,
      canCreate: canCreate,
      ongoingCount: empty ? 0 : 21,
      resolvedCount: 0,
      season: const {'name': 'Vụ 1', 'pondName': 'Ao 1'},
    );
  }

  @override
  Future<DiseaseCase> detail(String seasonId, String id) async {
    if (failure != null) throw failure!;
    return item;
  }

  @override
  Future<DiseaseCase> create(
    String seasonId,
    String title,
    String description,
    CaseSeverity severity, {
    List<String> attachments = const [],
    String? aiDiagnosisId,
    String? relatedCaseId,
  }) async {
    mutations++;
    selectedAi = aiDiagnosisId;
    if (failure != null) throw failure!;
    return pending?.future ?? item;
  }

  @override
  Future<DiseaseCase> respond(
    String seasonId,
    DiseaseCase value,
    CaseResponseType type,
    String message, {
    List<String> attachments = const [],
  }) async {
    mutations++;
    sentType = type;
    sentMessage = message;
    sentVersion = value.updatedAt;
    if (mutationFailure != null) throw mutationFailure!;
    if (failure != null) throw failure!;
    return pending?.future ?? item;
  }
}

Future<ProviderContainer> containerFor(
  CaseFixtureRepository repo, {
  AccountRole role = AccountRole.technician,
  NotificationSocket? realtimeSocket,
}) async {
  final container = ProviderContainer(
    overrides: [
      authRepositoryProvider.overrideWithValue(
        DashboardFixtureAuth(role: role),
      ),
      diseaseCaseRepositoryProvider.overrideWithValue(repo),
      notificationSocketProvider.overrideWithValue(realtimeSocket),
    ],
  );
  await container.read(authControllerProvider.future);
  return container;
}

Future<ProviderContainer> showCase(
  WidgetTester tester,
  CaseFixtureRepository repo, {
  String path = '/cases',
  NotificationSocket? realtimeSocket,
  List<RouteBase> additionalRoutes = const [],
}) async {
  GoogleFonts.config.allowRuntimeFetching = false;
  final container = await containerFor(repo, realtimeSocket: realtimeSocket);
  final router = GoRouter(
    initialLocation: path,
    routes: [
      ...additionalRoutes,
      GoRoute(
        path: '/cases',
        builder: (_, _) => const DiseaseCaseListPage(seasonId: 'season'),
      ),
      GoRoute(
        path: '/seasons/season/disease-cases/create',
        builder: (_, _) => const DiseaseCaseFormPage(seasonId: 'season'),
      ),
      GoRoute(
        path: '/seasons/season/disease-cases/case',
        builder: (_, _) =>
            const DiseaseCaseDetailPage(seasonId: 'season', caseId: 'case'),
      ),
    ],
  );
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp.router(theme: AppTheme.light, routerConfig: router),
    ),
  );
  await tester.pumpAndSettle();
  addTearDown(() async {
    await tester.pumpWidget(const SizedBox());
    router.dispose();
    container.dispose();
  });
  return container;
}

void main() {
  test(
    'create sends optional evidence and existing AI/case links without workflow fields',
    () async {
      final requests = <RequestOptions>[];
      final dio = Dio(BaseOptions(baseUrl: 'https://example.org'))
        ..interceptors.add(
          InterceptorsWrapper(
            onRequest: (request, handler) {
              requests.add(request);
              handler.resolve(
                Response(
                  requestOptions: request,
                  statusCode: 200,
                  data: {'success': true, 'message': 'OK', 'data': caseJson()},
                ),
              );
            },
          ),
        );
      final repo = DiseaseCaseRepositoryImpl(
        DiseaseCaseApiService(ApiClient(dio, TaskSessionStore())),
      );
      await repo.create(
        'season',
        'Ca mới',
        'Quan sát tại ao',
        CaseSeverity.high,
        attachments: ['https://example.org/evidence.jpg'],
        aiDiagnosisId: 'ai',
        relatedCaseId: 'previous',
      );
      expect(requests.single.data, {
        'title': 'Ca mới',
        'description': 'Quan sát tại ao',
        'severity': 'HIGH',
        'attachments': ['https://example.org/evidence.jpg'],
        'aiDiagnosisId': 'ai',
        'relatedCaseId': 'previous',
      });
      expect(requests.single.headers['Authorization'], 'Bearer access-token');
      dio.close();
    },
  );
  test(
    'case evidence uses its own upload folder and validates bytes before network',
    () async {
      var calls = 0;
      final dio = Dio()
        ..interceptors.add(
          InterceptorsWrapper(
            onRequest: (request, handler) {
              calls++;
              final form = request.data as FormData;
              expect(
                Map.fromEntries(form.fields)['folder'],
                'smartshrimp/disease-cases',
              );
              expect(form.files.single.value.filename, 'evidence.jpg');
              handler.resolve(
                Response(
                  requestOptions: request,
                  statusCode: 200,
                  data: {'secure_url': 'https://example.org/evidence.jpg'},
                ),
              );
            },
          ),
        );
      final storage = CloudinaryImageStorage(
        dio,
        folder: 'smartshrimp/disease-cases',
        validateBytes: DiseaseCaseRules.validateImage,
        cloudName: 'test-cloud',
        uploadPreset: 'test-preset',
      );
      await expectLater(
        storage.upload(
          bytes: Uint8List.fromList([1, 2, 3]),
          fileName: 'fake.jpg',
        ),
        throwsA(isA<ApiException>()),
      );
      expect(calls, 0);
      expect(
        await storage.upload(
          bytes: Uint8List.fromList([0xff, 0xd8, 0xff]),
          fileName: 'evidence.jpg',
        ),
        'https://example.org/evidence.jpg',
      );
      expect(calls, 1);
      dio.close();
    },
  );
  test('N: parses full case and future enum values safely', () {
    expect(fixture.severity, CaseSeverity.high);
    expect(fixture.allowsResponse, true);
    final unknown = DiseaseCase.fromJson({
      ...caseJson(),
      'status': 'FUTURE',
      'severity': 'FUTURE',
    });
    expect(unknown.status, DiseaseCaseStatus.unknown);
    expect(unknown.allowsResponse, false);
  });
  test('N: reads expert response types and both attachment formats', () {
    final item = DiseaseCase.fromJson({
      ...caseJson(),
      'responses': [
        for (final type in ['EXPERT_ASSESSMENT', 'EXPERT_INSTRUCTION'])
          {
            'id': type,
            'authorId': 'expert',
            'responseType': type,
            'message': 'Phản hồi chuyên gia',
            'createdAt': '2026-11-10T01:00:00Z',
            'attachments': [
              {'fileUrl': 'https://example.org/expert.jpg', 'caption': 'Ảnh'},
              'https://example.org/technician.jpg',
            ],
          },
      ],
    });
    expect(item.responses.map((entry) => entry.responseType), [
      CaseResponseType.assessment,
      CaseResponseType.instruction,
    ]);
    for (final response in item.responses) {
      expect(response.attachments, [
        'https://example.org/expert.jpg',
        'https://example.org/technician.jpg',
      ]);
    }
  });
  test('A: rejects a response attachment without a file URL', () {
    expect(
      () => CaseResponse.fromJson({
        'id': 'response',
        'authorId': 'expert',
        'responseType': 'EXPERT_ASSESSMENT',
        'message': 'Phản hồi',
        'createdAt': '2026-11-10T01:00:00Z',
        'attachments': [
          {'caption': 'Thiếu đường dẫn'},
        ],
      }),
      throwsA(isA<InvalidResponseException>()),
    );
  });
  for (final invalid in [
    {'id': ''},
    {'seasonId': null},
    {'title': null},
    {'status': null},
    {'createdAt': 'bad-date'},
    {'updatedAt': null},
    {
      'responses': [null],
    },
  ]) {
    test('A: rejects malformed case ${invalid.keys.single}', () {
      expect(
        () => DiseaseCase.fromJson({...caseJson(), ...invalid}),
        throwsA(isA<InvalidResponseException>()),
      );
    });
  }
  test('B: validation counts Unicode code points and trims input', () {
    expect(DiseaseCaseRules.textError('🦐' * 500, 500), isNull);
    expect(DiseaseCaseRules.textError('🦐' * 501, 500), isNotNull);
    expect(DiseaseCaseRules.textError('  ', 500), isNotNull);
    expect(
      DiseaseCaseRules.textError('a' * 500, DiseaseCaseRules.textLimit),
      isNull,
    );
    expect(
      DiseaseCaseRules.textError('a' * 501, DiseaseCaseRules.textLimit),
      isNotNull,
    );
  });
  test(
    'N: network methods, paths, filters, normalized payloads, auth and version match backend',
    () async {
      final requests = <RequestOptions>[];
      final dio = Dio(BaseOptions(baseUrl: 'https://disease.test'));
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
                      request.method == 'GET' && !request.path.endsWith('/case')
                      ? [caseJson()]
                      : caseJson(),
                  'meta': {
                    'page': 2,
                    'totalResults': 21,
                    'hasNextPage': false,
                    'canCreate': true,
                  },
                },
              ),
            );
          },
        ),
      );
      final repo = DiseaseCaseRepositoryImpl(
        DiseaseCaseApiService(ApiClient(dio, TaskSessionStore())),
      );
      expect(
        (await repo.list(
          'season',
          page: 2,
          status: DiseaseCaseStatus.monitoring,
        )).page,
        2,
      );
      await repo.detail('season', 'case');
      await repo.create(
        'season',
        '  Tiêu đề  ',
        '  Mô tả  ',
        CaseSeverity.high,
      );
      await repo.respond(
        'season',
        fixture,
        CaseResponseType.emergencyAlert,
        '  Khẩn cấp  ',
      );
      expect(requests.map((r) => '${r.method} ${r.path}'), [
        'GET /me/seasons/season/disease-cases',
        'GET /me/seasons/season/disease-cases/case',
        'POST /me/seasons/season/disease-cases',
        'POST /me/seasons/season/disease-cases/case/responses',
      ]);
      expect(requests.first.queryParameters, {
        'page': 2,
        'limit': 20,
        'status': 'MONITORING',
      });
      expect(
        requests.map((r) => r.headers['Authorization']),
        everyElement('Bearer access-token'),
      );
      expect(requests[2].data, {
        'title': 'Tiêu đề',
        'description': 'Mô tả',
        'severity': 'HIGH',
      });
      expect(requests[3].data, {
        'responseType': 'EMERGENCY_ALERT',
        'message': 'Khẩn cấp',
        'expectedUpdatedAt': '2026-10-30T01:00:00.123Z',
      });
      dio.close();
    },
  );
  for (final status in [400, 403, 404, 409, 429, 500]) {
    test('A: preserves HTTP $status and backend message', () async {
      final dio = Dio();
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (request, handler) => handler.reject(
            DioException(
              requestOptions: request,
              type: DioExceptionType.badResponse,
              response: Response(
                requestOptions: request,
                statusCode: status,
                data: {
                  'success': false,
                  'statusCode': status,
                  'message': 'Lỗi ca bệnh',
                },
              ),
            ),
          ),
        ),
      );
      final api = DiseaseCaseApiService(ApiClient(dio, TaskSessionStore()));
      await expectLater(
        api.detail('season', 'case'),
        throwsA(
          isA<AppException>()
              .having((e) => e.statusCode, 'status', status)
              .having((e) => e.message, 'message', 'Lỗi ca bệnh'),
        ),
      );
      dio.close();
    });
  }
  test('A: missing pagination metadata is an invalid response', () async {
    final dio = Dio();
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (request, handler) => handler.resolve(
          Response(
            requestOptions: request,
            statusCode: 200,
            data: {'success': true, 'message': 'OK', 'data': []},
          ),
        ),
      ),
    );
    await expectLater(
      DiseaseCaseApiService(
        ApiClient(dio, TaskSessionStore()),
      ).list('season', 1, null),
      throwsA(isA<InvalidResponseException>()),
    );
    dio.close();
  });
  test(
    'A: resolved case, expert response and unknown severity never reach network',
    () async {
      final dio = Dio();
      var requests = 0;
      dio.interceptors.add(
        InterceptorsWrapper(onRequest: (_, _) => requests++),
      );
      final repo = DiseaseCaseRepositoryImpl(
        DiseaseCaseApiService(ApiClient(dio, TaskSessionStore())),
      );
      expect(
        () => repo.respond(
          'season',
          fixture.copyWith(status: DiseaseCaseStatus.resolved),
          CaseResponseType.provideInfo,
          'a',
        ),
        throwsA(isA<ApiException>()),
      );
      expect(
        () => repo.respond('season', fixture, CaseResponseType.resolution, 'a'),
        throwsA(isA<ApiException>()),
      );
      expect(
        () => repo.create('season', 'a', 'b', CaseSeverity.unknown),
        throwsA(isA<ApiException>()),
      );
      expect(requests, 0);
      dio.close();
    },
  );
  test('A: owner cannot read technician case provider', () async {
    final repo = CaseFixtureRepository();
    final c = await containerFor(repo, role: AccountRole.farmOwner);
    addTearDown(c.dispose);
    await expectLater(
      c.read(
        diseaseCaseListProvider((
          seasonId: 'season',
          page: 1,
          status: null,
          resolved: null,
        )).future,
      ),
      throwsA(isA<UnsupportedRoleException>()),
    );
    expect(repo.lists, 0);
  });
  test(
    'B: prevents duplicate submission and invalidates data after success',
    () async {
      final repo = CaseFixtureRepository()..pending = Completer<DiseaseCase>();
      final c = await containerFor(repo);
      addTearDown(c.dispose);
      final sub = c.listen(diseaseCaseMutationProvider, (_, _) {});
      addTearDown(sub.close);
      await c.read(diseaseCaseMutationProvider.future);
      final controller = c.read(diseaseCaseMutationProvider.notifier);
      final first = controller.create('season', 'a', 'b', CaseSeverity.medium);
      await expectLater(
        controller.create('season', 'a', 'b', CaseSeverity.medium),
        throwsA(isA<ApiException>()),
      );
      repo.pending!.complete(fixture);
      expect(await first, fixture);
      expect(repo.mutations, 1);
    },
  );
  testWidgets(
    'N: list opens detail and shows conversation, snapshot and response form',
    (tester) async {
      await showCase(tester, CaseFixtureRepository());
      expect(find.text('Tôm giảm ăn'), findsOneWidget);
      await tester.tap(find.text('Tôm giảm ăn'));
      await tester.pumpAndSettle();
      expect(find.text('Tôm giảm ăn'), findsOneWidget);
      expect(find.text('Dữ liệu lúc mở ca'), findsOneWidget);
      await tester.scrollUntilVisible(
        find.text('Chưa có phản hồi.'),
        150,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('Chưa có phản hồi.'), findsOneWidget);
      expect(find.byKey(const ValueKey('case-send-response')), findsOneWidget);
    },
  );
  testWidgets('N: create validates inputs and navigates to created case', (
    tester,
  ) async {
    final repo = CaseFixtureRepository();
    await showCase(tester, repo);
    await tester.tap(find.text('Tạo ca bệnh'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Gửi cho chuyên gia'),
      250,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Gửi cho chuyên gia'));
    await tester.pumpAndSettle();
    expect(repo.mutations, 0);
    expect(find.text('Vui lòng nhập nội dung.'), findsNWidgets(2));
    await tester.enterText(find.byType(TextFormField).at(0), 'Ca mới');
    await tester.enterText(find.byType(TextFormField).at(1), 'Mô tả');
    await tester.scrollUntilVisible(
      find.text('Gửi cho chuyên gia'),
      250,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Gửi cho chuyên gia'));
    await tester.pumpAndSettle();
    expect(repo.mutations, 1);
    expect(find.text('Tôm giảm ăn'), findsOneWidget);
  });
  testWidgets('B: resolved case has no response controls', (tester) async {
    final repo = CaseFixtureRepository()
      ..item = fixture.copyWith(
        status: DiseaseCaseStatus.resolved,
        canRespond: false,
        resolutionSummary: 'Đã giải quyết',
      );
    await showCase(tester, repo, path: '/seasons/season/disease-cases/case');
    expect(find.text('Gửi phản hồi'), findsNothing);
    expect(find.text('Ca bệnh hiện chỉ cho phép xem.'), findsOneWidget);
  });
  testWidgets(
    'A: error message can retry and empty list has no create when inactive',
    (tester) async {
      final repo = CaseFixtureRepository()..failure = const NetworkException();
      await showCase(tester, repo);
      expect(find.textContaining('Không thể kết nối'), findsOneWidget);
      repo
        ..failure = null
        ..empty = true
        ..canCreate = false;
      await tester.tap(find.text('Thử lại'));
      await tester.pumpAndSettle();
      expect(find.text('Chưa có ca bệnh đang xử lý.'), findsOneWidget);
      expect(find.text('Tạo ca bệnh'), findsNothing);
    },
  );
  testWidgets('N: pagination advances and filter resets to first page', (
    tester,
  ) async {
    final repo = CaseFixtureRepository();
    await showCase(tester, repo);
    await tester.tap(find.byTooltip('Trang sau'));
    await tester.pumpAndSettle();
    expect(find.text('Trang 2 • 21 ca bệnh'), findsOneWidget);
    await tester.tap(find.text('Đã giải quyết (0)'));
    await tester.pumpAndSettle();
    expect(find.text('Trang 1 • 21 ca bệnh'), findsOneWidget);
    expect(repo.lastResolved, true);
    expect(repo.lastPage, 1);
  });
  testWidgets(
    'A: conflict displays backend message and preserves typed response',
    (tester) async {
      final repo = CaseFixtureRepository();
      await showCase(tester, repo, path: '/seasons/season/disease-cases/case');
      await tester.enterText(find.byType(TextFormField), 'Bổ sung tình trạng');
      repo.failure = const ApiException(
        'Ca bệnh đã thay đổi.',
        statusCode: 409,
      );
      await tester.tap(find.byKey(const ValueKey('case-send-response')));
      await tester.pumpAndSettle();
      expect(find.text('Ca bệnh đã thay đổi.'), findsWidgets);
      expect(repo.mutations, 1);
      repo.failure = null;
      await tester.tap(find.text('Thử lại'));
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<TextFormField>(find.byType(TextFormField))
            .controller!
            .text,
        'Bổ sung tình trạng',
      );
    },
  );
  testWidgets('N: emergency response succeeds and clears the editor', (
    tester,
  ) async {
    final repo = CaseFixtureRepository();
    await showCase(tester, repo, path: '/seasons/season/disease-cases/case');
    await tester.tap(find.byKey(const ValueKey('case-emergency-alert')));
    await tester.pumpAndSettle();
    expect(find.textContaining('chuyên gia và chủ trại'), findsOneWidget);
    await tester.enterText(
      find.byType(TextFormField).last,
      'Cần chuyên gia hỗ trợ',
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Gửi cảnh báo khẩn'));
    await tester.pumpAndSettle();
    expect(repo.mutations, 1);
    expect(
      find.text('Đã gửi cảnh báo khẩn đến chuyên gia và chủ trại.'),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey('case-response-success')), findsOneWidget);
    expect(find.byType(SnackBar), findsNothing);
    expect(repo.sentType, CaseResponseType.emergencyAlert);
    expect(repo.sentMessage, 'Cần chuyên gia hỗ trợ');
    expect(
      tester.widget<TextFormField>(find.byType(TextFormField)).controller!.text,
      isEmpty,
    );
  });
  testWidgets('B: pending response disables repeat submission', (tester) async {
    final repo = CaseFixtureRepository()..pending = Completer<DiseaseCase>();
    await showCase(tester, repo, path: '/seasons/season/disease-cases/case');
    await tester.enterText(find.byType(TextFormField), 'Tình trạng mới');
    await tester.tap(find.byKey(const ValueKey('case-send-response')));
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsWidgets);
    expect(
      tester
          .widget<FilledButton>(
            find.byKey(const ValueKey('case-send-response')),
          )
          .onPressed,
      isNull,
    );
    repo.pending!.complete(fixture);
    await tester.pumpAndSettle();
    expect(repo.mutations, 1);
  });
  test('A: session expiry clears session and authentication state', () async {
    final repo = CaseFixtureRepository()
      ..failure = const SessionExpiredException();
    final session = TaskSessionStore();
    final c = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(
          const DashboardFixtureAuth(role: AccountRole.technician),
        ),
        sessionStoreProvider.overrideWithValue(session),
        diseaseCaseRepositoryProvider.overrideWithValue(repo),
      ],
    );
    addTearDown(c.dispose);
    await c.read(authControllerProvider.future);
    final provider = diseaseCaseDetailProvider((
      seasonId: 'season',
      id: 'case',
    ));
    final subscription = c.listen(provider, (_, _) {});
    addTearDown(subscription.close);
    await expectLater(
      c.read(provider.future),
      throwsA(isA<SessionExpiredException>()),
    );
    expect(c.read(authControllerProvider).value, isNull);
    expect(session.accessToken, isNull);
  });
  test(
    'detail preserves response authors and the existing expert conclusion',
    () {
      final item = DiseaseCase.fromJson({
        ...caseJson(),
        'status': 'RESOLVED',
        'canRespond': false,
        'resolutionSummary': 'Đã kết luận chuyên môn',
        'responses': [
          {
            'id': 'response',
            'authorId': 'expert',
            'responseType': 'EXPERT_ASSESSMENT',
            'message': 'Nhận định của chuyên gia',
            'createdAt': '2026-11-10T01:00:00Z',
            'author': {'fullName': 'Chuyên gia'},
          },
        ],
      });
      expect(item.responses.single.author?['fullName'], 'Chuyên gia');
      expect(item.resolutionSummary, 'Đã kết luận chuyên môn');
      expect(item.allowsResponse, false);
    },
  );
  test(
    'evidence rejects duplicates, oversized lists, invalid URLs and disguised bytes',
    () {
      DiseaseCaseRules.validateAttachments(['https://example.org/a.jpg']);
      for (final urls in [
        List.filled(6, 'https://example.org/a.jpg'),
        ['https://example.org/a.jpg', 'https://example.org/a.jpg'],
        ['http://example.org/a.jpg'],
      ]) {
        expect(
          () => DiseaseCaseRules.validateAttachments(urls),
          throwsA(isA<ApiException>()),
        );
      }
      expect(
        () => DiseaseCaseRules.validateImage(Uint8List.fromList([1, 2, 3])),
        throwsA(isA<ApiException>()),
      );
      expect(
        () => DiseaseCaseRules.validateImage(
          Uint8List(DiseaseCaseRules.maxImageBytes + 1),
        ),
        throwsA(isA<ApiException>()),
      );
      DiseaseCaseRules.validateImage(
        Uint8List.fromList([0xff, 0xd8, 0xff, 0x00]),
      );
    },
  );
}
