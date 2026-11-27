import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/network/api_client.dart';
import 'package:smartshrimp_app/core/widgets/app_notice.dart';
import 'package:smartshrimp_app/core/widgets/gradient_button.dart';
import 'package:smartshrimp_app/core/widgets/app_error_state.dart';
import 'package:smartshrimp_app/core/storage/session_store.dart';
import 'package:smartshrimp_app/features/auth/domain/entities/auth_account.dart';
import 'package:smartshrimp_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:smartshrimp_app/features/auth/presentation/view_models/auth_controller.dart';
import 'package:smartshrimp_app/features/harvest/data/services/harvest_api_service.dart';
import 'package:smartshrimp_app/features/harvest/data/services/secure_harvest_submission_store.dart';
import 'package:smartshrimp_app/features/harvest/domain/entities/harvest_event.dart';
import 'package:smartshrimp_app/features/harvest/domain/harvest_policy.dart';
import 'package:smartshrimp_app/features/harvest/domain/repositories/harvest_repository.dart';
import 'package:smartshrimp_app/features/harvest/domain/repositories/harvest_submission_store.dart';
import 'package:smartshrimp_app/features/harvest/presentation/pages/harvest_list_page.dart';
import 'package:smartshrimp_app/features/harvest/presentation/pages/harvest_detail_page.dart';
import 'package:smartshrimp_app/features/harvest/presentation/pages/harvest_form_page.dart';
import 'package:smartshrimp_app/features/harvest/presentation/view_models/harvest_controller.dart';
import 'package:smartshrimp_app/features/harvest/presentation/widgets/harvest_ui.dart';
import 'package:smartshrimp_app/features/pond/domain/entities/pond.dart';
import 'package:smartshrimp_app/features/farm/domain/entities/farm.dart'
    as farms;
import 'package:smartshrimp_app/features/farm/domain/repositories/farm_repository.dart';
import 'package:smartshrimp_app/features/farm/presentation/view_models/farm_controller.dart';
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
Map<String, dynamic> submissionBody({
  double weight = 620,
  bool finalHarvest = false,
}) => {
  'harvestType': finalHarvest ? 'FINAL' : 'PARTIAL',
  'harvestedAt': '2026-09-03T05:30:00+07:00',
  'totalWeightKg': weight,
  'estimatedRemainingCount': finalHarvest ? 0 : 700,
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
  availableQuantityCount: '100000',
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
  setUp(() => FlutterSecureStorage.setMockInitialValues({}));
  setUpAll(() async {
    // Test engines use Ahem by default; load bundled fonts for readable render captures.
    final loader = FontLoader('Roboto')
      ..addFont(
        rootBundle.load(
          'assets/fonts/google_fonts/PlusJakartaSans-Regular.ttf',
        ),
      );
    await loader.load();
    // Dialogs inherit themed font families, including their weight variants.
    final theme = AppTheme.light.textTheme;
    final families = {
      for (final style in [
        theme.bodySmall,
        theme.bodyMedium,
        theme.bodyLarge,
        theme.labelSmall,
        theme.labelMedium,
        theme.labelLarge,
        theme.titleSmall,
        theme.titleMedium,
        theme.titleLarge,
      ])
        if (style?.fontFamily != null) style!.fontFamily!,
    };
    for (final family in families) {
      final fonts = FontLoader(family);
      for (final weight in [
        'Regular',
        'Medium',
        'SemiBold',
        'Bold',
        'ExtraBold',
      ]) {
        fonts.addFont(
          rootBundle.load(
            'assets/fonts/google_fonts/PlusJakartaSans-$weight.ttf',
          ),
        );
      }
      await fonts.load();
    }
    final icons = FontLoader('MaterialIcons')
      ..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'));
    await icons.load();
  });
  test('parses BE counts, decimals, nullable facts and safe unknown enum', () {
    final event = HarvestEvent.fromJson(eventJson());
    expect(event.quantityCount, '43400');
    expect(event.totalWeightKg, 620);
    expect(event.buyerContact, isNull);
    expect(event.warnings, isEmpty);
    expect(
      HarvestEvent.fromJson({
        ...eventJson(),
        'varianceReason': 'Sai số đếm giống',
      }).varianceReason,
      'Sai số đếm giống',
    );
    expect(
      HarvestEvent.fromJson({
        ...eventJson(),
        'warnings': ['Cảnh báo từ cấu hình BE'],
      }).warnings,
      ['Cảnh báo từ cấu hình BE'],
    );
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
    {'warnings': 'invalid'},
    {
      'warnings': [123],
    },
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
                    'finalReasonRequired': true,
                    'populationCorrectionEnabled': true,
                    'availableQuantityCount': '100000',
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
        'populationAt': '2026-09-02T10:00:00Z',
      });
      expect(listed.totalResults, 1);
      expect(listed.finalReasonRequired, isTrue);
      expect(listed.populationCorrectionEnabled, isTrue);
      expect(listed.availableQuantityCount, '100000');
      expect(requests.last.path, '/owner/seasons/season%201/harvests');
      expect(requests.last.queryParameters, {
        'harvestType': 'PARTIAL',
        'cursor': 'cursor',
        'populationAt': '2026-09-02T10:00:00Z',
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

  for (final available in [null, '0', '9007199254740993', -1, '1.5']) {
    test(
      'available population metadata validates decimal-string contract: $available',
      () async {
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
                  'meta': {
                    'limit': 20,
                    'totalResults': 0,
                    'hasNextPage': false,
                    'nextCursor': null,
                    'totalWeightKg': 0,
                    'totalRevenue': 0,
                    'availableQuantityCount': ?available,
                  },
                },
              ),
            ),
          ),
        );
        final request = HarvestApiService(
          ApiClient(dio, _Session()),
        ).list('season-1', {});
        if (available == -1 || available == '1.5') {
          await expectLater(request, throwsA(isA<InvalidResponseException>()));
        } else {
          expect((await request).availableQuantityCount, available);
        }
      },
    );
  }
  for (final status in [400, 403, 404, 409, 429, 500]) {
    test('API retains error status $status with localized copy', () async {
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
                  'message': 'Không thể ghi nhận thu hoạch.',
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
              .having(
                (e) => e.message,
                'message',
                status >= 500
                    ? 'Máy chủ đang gặp sự cố. Vui lòng thử lại sau.'
                    : 'Không thể ghi nhận thu hoạch.',
              ),
        ),
      );
    });
  }
  test(
    'unchanged retry retains key and duplicate in-flight submission is blocked',
    () async {
      final repo = _HarvestRepo();
      final container = ProviderContainer(
        retry: (retryCount, error) => null,
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
        notifier.submit(submissionBody()),
        throwsA(isA<NetworkException>()),
      );
      repo.recordError = null;
      await notifier.submit(submissionBody());
      expect(repo.keys[0], repo.keys[1]);
      repo.recordWait = Completer<HarvestEvent>();
      final pending = notifier.submit(submissionBody(weight: 621));
      await expectLater(
        notifier.submit(submissionBody(weight: 621)),
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
      retry: (retryCount, error) => null,
      overrides: [
        authRepositoryProvider.overrideWithValue(
          _AuthRepo(role: AccountRole.technician),
        ),
        harvestRepositoryProvider.overrideWithValue(repo),
      ],
    );
    addTearDown(container.dispose);
    await container.read(authControllerProvider.future);
    const query = 'season-1';
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

  Future<ProviderContainer> mutationContainer(
    _HarvestRepo repo, {
    String accountId = 'owner',
    HarvestSubmissionStore? store,
  }) async {
    final container = ProviderContainer(
      retry: (_, _) => null,
      overrides: [
        authRepositoryProvider.overrideWithValue(_AuthRepo(id: accountId)),
        harvestRepositoryProvider.overrideWithValue(repo),
        if (store != null)
          harvestSubmissionStoreProvider.overrideWithValue(store),
      ],
    );
    addTearDown(container.dispose);
    await container.read(authControllerProvider.future);
    final subscription = container.listen(
      harvestMutationProvider('season-1'),
      (_, _) {},
    );
    addTearDown(subscription.close);
    await container.read(harvestMutationProvider('season-1').future);
    return container;
  }

  test('final harvest refreshes mounted farm detail and list caches', () async {
    final repo = _HarvestRepo()
      ..recordResult = HarvestEvent.fromJson({
        ...eventJson(),
        'harvestType': 'FINAL',
        'estimatedRemainingCount': '0',
      });
    final farmRepo = _HarvestFarmRepo();
    final container = ProviderContainer(
      retry: (_, _) => null,
      overrides: [
        authRepositoryProvider.overrideWithValue(_AuthRepo()),
        harvestRepositoryProvider.overrideWithValue(repo),
        farmRepositoryProvider.overrideWithValue(farmRepo),
      ],
    );
    addTearDown(container.dispose);
    await container.read(authControllerProvider.future);
    final detail = farmDetailControllerProvider('farm');
    final subscriptions = [
      container.listen(detail, (_, _) {}),
      container.listen(farmListControllerProvider, (_, _) {}),
      container.listen(harvestMutationProvider('season-1'), (_, _) {}),
    ];
    addTearDown(() {
      for (final sub in subscriptions) {
        sub.close();
      }
    });
    expect((await container.read(detail.future)).activeSeasonCount, 1);
    expect(
      (await container.read(
        farmListControllerProvider.future,
      )).items.single.activeSeasonCount,
      1,
    );
    await container.read(harvestMutationProvider('season-1').future);
    farmRepo.activeSeasonCount = 0;
    await container
        .read(harvestMutationProvider('season-1').notifier)
        .submit(submissionBody(finalHarvest: true));
    final refreshed = await container.read(detail.future);
    expect(refreshed.activeSeasonCount, 0);
    expect(refreshed.ponds.single.currentSeason, isNull);
    expect(
      (await container.read(
        farmListControllerProvider.future,
      )).items.single.activeSeasonCount,
      0,
    );
    expect(farmRepo.detailReads, 2);
    expect(farmRepo.listReads, 2);
  });

  test(
    'historical previews keep later responses scoped to their selected instant',
    () async {
      final older = Completer<HarvestPage>();
      final newer = Completer<HarvestPage>();
      final repo = _HarvestRepo()
        ..populationLoad = (query) =>
            (query['populationAt'] == '2026-09-01T00:00:00.000Z'
                    ? older
                    : newer)
                .future;
      final container = await mutationContainer(repo);
      final oldProvider = harvestPopulationProvider((
        seasonId: 'season-1',
        at: DateTime.utc(2026, 9, 1),
      ));
      final newProvider = harvestPopulationProvider((
        seasonId: 'season-1',
        at: DateTime.utc(2026, 9, 2),
      ));
      final oldSubscription = container.listen(oldProvider, (_, _) {});
      final newSubscription = container.listen(newProvider, (_, _) {});
      addTearDown(oldSubscription.close);
      addTearDown(newSubscription.close);
      final oldFuture = container.read(oldProvider.future);
      final newFuture = container.read(newProvider.future);
      newer.complete(page().copyWith(availableQuantityCount: '900'));
      expect((await newFuture).availableQuantityCount, '900');
      older.complete(page().copyWith(availableQuantityCount: '1000'));
      expect((await oldFuture).availableQuantityCount, '1000');
      expect(container.read(newProvider).value?.availableQuantityCount, '900');
      expect(
        repo.queries.every(
          (query) => query['limit'] == 1 && query.containsKey('populationAt'),
        ),
        isTrue,
      );
    },
  );

  for (final at in [null, DateTime.utc(2026, 9, 1)]) {
    test('population lookup can retry a failed request; at=$at', () async {
      final pending = Completer<HarvestPage>();
      final repo = _HarvestRepo()..listWait = pending;
      final container = await mutationContainer(repo);
      final provider = harvestPopulationProvider((
        seasonId: 'season-1',
        at: at,
      ));
      final subscription = container.listen(provider, (_, _) {});
      addTearDown(subscription.close);
      final failure = expectLater(
        container.read(provider.future),
        throwsA(isA<NetworkException>()),
      );
      pending.completeError(const NetworkException());
      await failure;
      repo.listWait = null;
      container.invalidate(provider);
      expect(
        (await container.read(provider.future)).availableQuantityCount,
        '100000',
      );
      expect(repo.queries, hasLength(2));
    });
  }

  test(
    'lost response survives provider recreation and restart with the same body/key',
    () async {
      final repo = _HarvestRepo()..recordError = const NetworkException();
      final first = await mutationContainer(repo);
      await expectLater(
        first
            .read(harvestMutationProvider('season-1').notifier)
            .submit(submissionBody()),
        throwsA(isA<NetworkException>()),
      );
      final saved = await first.read(pendingHarvestProvider('season-1').future);
      expect(saved!.key, repo.keys.single);
      first.invalidate(harvestMutationProvider('season-1'));
      final second = await mutationContainer(repo);
      final recovered = await second.read(
        pendingHarvestProvider('season-1').future,
      );
      expect(recovered, saved);
      repo.recordError = null;
      await second
          .read(harvestMutationProvider('season-1').notifier)
          .submit(recovered!.body);
      expect(repo.keys, [saved.key, saved.key]);
      expect(repo.bodies[0], repo.bodies[1]);
      expect(
        await second
            .read(harvestSubmissionStoreProvider)
            .read('owner', 'season-1'),
        isNull,
      );
    },
  );

  test('an unresolved attempt cannot be changed into another key', () async {
    final repo = _HarvestRepo()..recordError = const NetworkException();
    final container = await mutationContainer(repo);
    final mutation = container.read(
      harvestMutationProvider('season-1').notifier,
    );
    await expectLater(
      mutation.submit(submissionBody()),
      throwsA(isA<NetworkException>()),
    );
    await expectLater(
      mutation.submit(submissionBody(weight: 621)),
      throwsA(isA<ApiException>()),
    );
    expect(repo.keys, hasLength(1));
    expect(
      (await container
              .read(harvestSubmissionStoreProvider)
              .read('owner', 'season-1'))!
          .body,
      submissionBody(),
    );
  });

  test(
    'pending submissions are scoped to owner and season across new containers',
    () async {
      final repo = _HarvestRepo()..recordError = const NetworkException();
      final first = await mutationContainer(repo);
      await expectLater(
        first
            .read(harvestMutationProvider('season-1').notifier)
            .submit(submissionBody()),
        throwsA(isA<NetworkException>()),
      );
      final second = await mutationContainer(repo, accountId: 'another-owner');
      expect(
        await second.read(pendingHarvestProvider('season-1').future),
        isNull,
      );
      final store = second.read(harvestSubmissionStoreProvider);
      expect(await store.read('owner', 'another-season'), isNull);
      expect(await store.read('owner', 'season-1'), isNotNull);
    },
  );

  for (final status in [400, 409]) {
    test(
      'fresh $status rejection clears pending, uncertain retry retains it',
      () async {
        final repo = _HarvestRepo()
          ..recordError = ApiException('rejected', statusCode: status);
        final container = await mutationContainer(repo);
        final mutation = container.read(
          harvestMutationProvider('season-1').notifier,
        );
        final store = container.read(harvestSubmissionStoreProvider);
        await expectLater(
          mutation.submit(submissionBody()),
          throwsA(isA<ApiException>()),
        );
        expect(await store.read('owner', 'season-1'), isNull);
        repo.recordError = const NetworkException();
        await expectLater(
          mutation.submit(submissionBody()),
          throwsA(isA<NetworkException>()),
        );
        final saved = await store.read('owner', 'season-1');
        repo.recordError = ApiException('rejected', statusCode: status);
        await expectLater(
          mutation.submit(submissionBody()),
          throwsA(isA<ApiException>()),
        );
        expect(await store.read('owner', 'season-1'), saved);
      },
    );
  }

  for (final status in [401, 403, 404, 409, 422, 429, 500]) {
    test(
      'uncertain pending survives HTTP $status even with a time code',
      () async {
        final repo = _HarvestRepo()..recordError = const NetworkException();
        final container = await mutationContainer(repo);
        final mutation = container.read(
          harvestMutationProvider('season-1').notifier,
        );
        final store = container.read(harvestSubmissionStoreProvider);
        await expectLater(
          mutation.submit(submissionBody()),
          throwsA(isA<NetworkException>()),
        );
        final saved = await store.read('owner', 'season-1');
        repo.recordError = ApiException(
          'rejected',
          statusCode: status,
          details: {'code': harvestTimeNotAfterLatestCode},
        );
        await expectLater(
          mutation.submit(submissionBody()),
          throwsA(isA<AppException>()),
        );
        expect(await store.read('owner', 'season-1'), saved);
        expect(repo.keys, [saved!.key, saved.key]);
      },
    );
  }

  test(
    'profile edits keep a pending write busy and reject overlapping submissions',
    () async {
      final wait = Completer<HarvestEvent>();
      final repo = _HarvestRepo()..recordWait = wait;
      final container = await mutationContainer(repo);
      final mutation = container.read(
        harvestMutationProvider('season-1').notifier,
      );
      final first = mutation.submit(submissionBody());
      while (repo.keys.isEmpty) {
        await Future<void>.delayed(Duration.zero);
      }
      container
          .read(authControllerProvider.notifier)
          .updateAccountDetails(
            fullName: 'Updated',
            phone: null,
            avatarUrl: null,
          );
      await container.pump();
      final busy = container
          .read(harvestMutationProvider('season-1'))
          .isLoading;
      await expectLater(
        mutation.submit(submissionBody()),
        throwsA(isA<ApiException>()),
      );
      wait.complete(HarvestEvent.fromJson(eventJson()));
      await first;
      expect(busy, isTrue);
      expect(repo.keys, hasLength(1));
    },
  );

  test(
    'provider rebuild cannot bypass the independent submission guard',
    () async {
      final wait = Completer<HarvestEvent>();
      final repo = _HarvestRepo()..recordWait = wait;
      final container = await mutationContainer(repo);
      final mutation = container.read(
        harvestMutationProvider('season-1').notifier,
      );
      final first = mutation.submit(submissionBody());
      while (repo.keys.isEmpty) {
        await Future<void>.delayed(Duration.zero);
      }
      container.invalidate(harvestMutationProvider('season-1'));
      await container.pump();
      await expectLater(
        container
            .read(harvestMutationProvider('season-1').notifier)
            .submit(submissionBody()),
        throwsA(isA<ApiException>()),
      );
      wait.complete(HarvestEvent.fromJson(eventJson()));
      await first;
      expect(repo.keys, hasLength(1));
    },
  );

  for (final rejected in [false, true]) {
    test(
      'old response preserves a newer durable pending key; rejected=$rejected',
      () async {
        final wait = Completer<HarvestEvent>();
        final repo = _HarvestRepo()..recordWait = wait;
        final container = await mutationContainer(repo);
        final oldRequest = container
            .read(harvestMutationProvider('season-1').notifier)
            .submit(submissionBody());
        final result = rejected
            ? expectLater(oldRequest, throwsA(isA<ApiException>()))
            : oldRequest;
        while (repo.keys.isEmpty) {
          await Future<void>.delayed(Duration.zero);
        }
        final store = container.read(harvestSubmissionStoreProvider);
        final newer = PendingHarvestSubmission(
          key: '11111111-1111-4111-8111-111111111111',
          body: {
            ...submissionBody(weight: 621),
            'harvestedAt': '2026-09-03T06:30:00+07:00',
          },
        );
        await store.write('owner', 'season-1', newer);
        if (rejected) {
          wait.completeError(
            const ApiException(
              'Invalid time',
              statusCode: 400,
              details: {'code': harvestTimeNotAfterLatestCode},
            ),
          );
        } else {
          wait.complete(HarvestEvent.fromJson(eventJson()));
        }
        await result;
        expect(await store.read('owner', 'season-1'), newer);
      },
    );
  }

  test(
    'compare/delete and a newer write serialize across storage instances',
    () async {
      final first = SecureHarvestSubmissionStore(const FlutterSecureStorage());
      final second = SecureHarvestSubmissionStore(const FlutterSecureStorage());
      final old = PendingHarvestSubmission(
        key: '11111111-1111-4111-8111-111111111111',
        body: submissionBody(),
      );
      final newer = PendingHarvestSubmission(
        key: '22222222-2222-4222-8222-222222222222',
        body: submissionBody(weight: 621),
      );
      await first.write('owner', 'season-1', old);
      await Future.wait([
        first.clear('owner', 'season-1', expectedKey: old.key),
        second.write('owner', 'season-1', newer),
      ]);
      expect(await first.read('owner', 'season-1'), newer);
      await first.clear('owner', 'season-1', expectedKey: old.key);
      expect(await second.read('owner', 'season-1'), newer);
      await second.clear('owner', 'season-1', expectedKey: newer.key);
      expect(await first.read('owner', 'season-1'), isNull);
    },
  );

  test(
    'failed pending cleanup releases the storage queue without losing the error',
    () async {
      final slot =
          'harvest_pending_v1_${base64Url.encode(utf8.encode(jsonEncode(['owner', 'season-1'])))}';
      FlutterSecureStorage.setMockInitialValues({slot: 'broken-json'});
      final store = SecureHarvestSubmissionStore(const FlutterSecureStorage());
      final newer = PendingHarvestSubmission(
        key: '22222222-2222-4222-8222-222222222222',
        body: submissionBody(),
      );
      final failed = expectLater(
        store.clear('owner', 'season-1', expectedKey: newer.key),
        throwsA(isA<ApiException>()),
      );
      final queued = store.write('owner', 'season-1', newer);
      await Future.wait([failed, queued]);
      expect(await store.read('owner', 'season-1'), newer);
    },
  );

  test(
    'storage write failure prevents POST and leaves mutation out of loading',
    () async {
      final repo = _HarvestRepo();
      final store = _FailingSubmissionStore(
        SecureHarvestSubmissionStore(const FlutterSecureStorage()),
        failWrite: true,
      );
      final container = await mutationContainer(repo, store: store);
      await expectLater(
        container
            .read(harvestMutationProvider('season-1').notifier)
            .submit(submissionBody()),
        throwsStateError,
      );
      expect(repo.keys, isEmpty);
      expect(
        container.read(harvestMutationProvider('season-1')).hasError,
        isTrue,
      );
    },
  );

  test(
    'confirmed time rejection after restart releases pending; correction gets a new key',
    () async {
      final repo = _HarvestRepo()..recordError = const NetworkException();
      final first = await mutationContainer(repo);
      await expectLater(
        first
            .read(harvestMutationProvider('season-1').notifier)
            .submit(submissionBody()),
        throwsA(isA<NetworkException>()),
      );
      final second = await mutationContainer(repo);
      final store = second.read(harvestSubmissionStoreProvider);
      final saved = await store.read('owner', 'season-1');
      repo.recordError = const ApiException(
        'Invalid time',
        statusCode: 400,
        details: {'code': harvestTimeNotAfterLatestCode},
      );
      await expectLater(
        second
            .read(harvestMutationProvider('season-1').notifier)
            .submit(saved!.body),
        throwsA(isA<ApiException>()),
      );
      expect(await store.read('owner', 'season-1'), isNull);
      repo.recordError = null;
      final corrected = {
        ...saved.body,
        'harvestedAt': '2026-09-03T06:30:00+07:00',
      };
      await second
          .read(harvestMutationProvider('season-1').notifier)
          .submit(corrected);
      expect(repo.keys[0], repo.keys[1]);
      expect(repo.keys[2], isNot(saved.key));
      expect(repo.bodies.last, corrected);
    },
  );

  test(
    'storage cleanup failure retains a confirmed rejected pending key',
    () async {
      final repo = _HarvestRepo()..recordError = const NetworkException();
      final store = _FailingSubmissionStore(
        SecureHarvestSubmissionStore(const FlutterSecureStorage()),
        failClear: true,
      );
      final container = await mutationContainer(repo, store: store);
      final mutation = container.read(
        harvestMutationProvider('season-1').notifier,
      );
      await expectLater(
        mutation.submit(submissionBody()),
        throwsA(isA<NetworkException>()),
      );
      final saved = await store.read('owner', 'season-1');
      repo.recordError = const ApiException(
        'Invalid time',
        statusCode: 400,
        details: {'code': harvestTimeNotAfterLatestCode},
      );
      await expectLater(mutation.submit(submissionBody()), throwsStateError);
      expect(await store.read('owner', 'season-1'), saved);
    },
  );

  test(
    'failure to clear a successful response preserves a recoverable key',
    () async {
      final repo = _HarvestRepo();
      final store = _FailingSubmissionStore(
        SecureHarvestSubmissionStore(const FlutterSecureStorage()),
        failClear: true,
      );
      final first = await mutationContainer(repo, store: store);
      await expectLater(
        first
            .read(harvestMutationProvider('season-1').notifier)
            .submit(submissionBody()),
        throwsStateError,
      );
      final saved = await store.read('owner', 'season-1');
      final second = await mutationContainer(repo, store: store);
      store.failClear = false;
      await second
          .read(harvestMutationProvider('season-1').notifier)
          .submit(saved!.body);
      expect(repo.keys, [saved.key, saved.key]);
      expect(await store.read('owner', 'season-1'), isNull);
    },
  );

  test(
    'corrupt durable data fails closed and is not silently discarded',
    () async {
      final key =
          'harvest_pending_v1_${base64Url.encode(utf8.encode(jsonEncode(['owner', 'season-1'])))}';
      FlutterSecureStorage.setMockInitialValues({key: 'broken-json'});
      final store = SecureHarvestSubmissionStore(const FlutterSecureStorage());
      await expectLater(
        store.read('owner', 'season-1'),
        throwsA(isA<ApiException>()),
      );
      expect(await const FlutterSecureStorage().read(key: key), 'broken-json');
    },
  );

  Future<void> mount(
    WidgetTester tester,
    _HarvestRepo repo, {
    String route = '/harvests',
    SeasonStatus status = SeasonStatus.active,
    AquacultureSeason? seasonOverride,
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
        retry: (retryCount, error) => null,
        overrides: [
          authRepositoryProvider.overrideWithValue(_AuthRepo()),
          harvestRepositoryProvider.overrideWithValue(repo),
          seasonRepositoryProvider.overrideWithValue(
            _SeasonRepo(status, seasonValue: seasonOverride),
          ),
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

  testWidgets('numeric errors are specific and fields reject letters', (
    tester,
  ) async {
    await mount(tester, _HarvestRepo(), route: '/harvests/create');
    await tester.pumpAndSettle();
    for (final key in ['weight', 'count', 'price']) {
      final finder = find.byKey(ValueKey('harvest-field-$key'));
      final field = tester.widget<TextFormField>(finder);
      expect(field.validator!('abc'), 'Vui lòng chỉ nhập số');
      expect(field.validator!('0'), 'Giá trị phải lớn hơn 0');
      expect(field.validator!('99999999999999999999'), 'Giá trị quá lớn');
      if (key == 'weight') {
        expect(field.validator!('1.234'), isNull);
        expect(field.validator!('1,234'), isNull);
        expect(field.validator!('0.001'), isNull);
        expect(field.validator!('99999999999.999'), isNull);
        expect(
          field.validator!('1.2345'),
          'Chỉ nhập tối đa 3 chữ số sau dấu phẩy',
        );
      } else if (key == 'price') {
        expect(
          field.validator!('1,234'),
          'Chỉ nhập tối đa 2 chữ số sau dấu phẩy',
        );
        expect(field.validator!('1,23'), isNull);
      } else {
        expect(field.validator!('1.2'), 'Vui lòng nhập số nguyên');
      }
      await tester.enterText(finder, '12');
      await tester.enterText(finder, '12abc');
      expect(field.controller!.text, '12');
      await tester.enterText(finder, '1e3');
      expect(field.controller!.text, '12');
      await tester.enterText(finder, '');
      expect(field.controller!.text, isEmpty);
    }
    expect(tester.takeException(), isNull);
  });

  for (final finalHarvest in [false, true]) {
    for (final count in [999, 1000, 50000, 50001]) {
      testWidgets(
        'size warning before save: final=$finalHarvest count=$count',
        (tester) async {
          final repo = _HarvestRepo();
          await mount(tester, repo, route: '/harvests/create');
          await tester.pumpAndSettle();
          if (finalHarvest) {
            await tester.tap(find.text('Thu hoạch cuối'));
            await tester.pumpAndSettle();
          }
          for (final entry in {
            'weight': '100',
            'count': '$count',
            'price': '180000',
            'buyer': 'Người mua',
          }.entries) {
            await tester.enterText(
              find.byKey(ValueKey('harvest-field-${entry.key}')),
              entry.value,
            );
          }
          FocusManager.instance.primaryFocus?.unfocus();
          await tester.pumpAndSettle();
          await tester.ensureVisible(find.text('Chọn ngày và giờ...'));
          await tester.pumpAndSettle();
          await tester.tap(find.text('Chọn ngày và giờ...'));
          await tester.pumpAndSettle();
          await tester.tap(find.text('OK'));
          await tester.pumpAndSettle();
          await tester.tap(find.text('OK'));
          await tester.pumpAndSettle();
          final submit = find.text(
            finalHarvest ? 'Ghi nhận thu hoạch cuối' : 'Ghi nhận thu tỉa',
          );
          await tester.ensureVisible(submit);
          await tester.pumpAndSettle();
          await tester.tap(submit);
          await tester.pumpAndSettle();
          final standaloneWarning = find.text('Cỡ tôm ngoài khoảng thường gặp');
          final sizeWarning = find.textContaining(
            'nằm ngoài khoảng 10–500 con/kg',
          );
          if (count < 1000 || count > 50000) {
            expect(sizeWarning, findsOneWidget);
            expect(
              standaloneWarning,
              finalHarvest ? findsOneWidget : findsNothing,
            );
            if (!finalHarvest) {
              expect(find.text('Xác nhận thu tỉa'), findsOneWidget);
            }
            expect(repo.bodies, isEmpty);
            await tester.tap(find.text('Kiểm tra lại'));
            await tester.pumpAndSettle();
            expect(repo.bodies, isEmpty);
            expect(
              tester
                  .widget<TextFormField>(
                    find.byKey(const ValueKey('harvest-field-count')),
                  )
                  .controller!
                  .text,
              count == 50001 ? '50.001' : '$count',
            );
            await tester.ensureVisible(submit);
            await tester.pumpAndSettle();
            await tester.tap(submit);
            await tester.pumpAndSettle();
            if (finalHarvest) {
              await tester.tap(find.text('Vẫn lưu'));
              await tester.pumpAndSettle();
            } else {
              expect(sizeWarning, findsOneWidget);
            }
          } else {
            expect(sizeWarning, findsNothing);
            expect(standaloneWarning, findsNothing);
          }
          expect(
            find.text(
              finalHarvest ? 'Xác nhận thu hoạch cuối' : 'Xác nhận thu tỉa',
            ),
            findsOneWidget,
          );
          expect(repo.bodies, isEmpty);
          await tester.tap(find.text('Xác nhận'));
          await tester.pumpAndSettle();
          expect(repo.bodies, hasLength(1));
          expect(repo.bodies.single['quantityCount'], count);
          expect(repo.bodies.single['totalWeightKg'], 100);
          expect(tester.takeException(), isNull);
        },
      );
    }
  }

  testWidgets(
    'partial remainder cannot be edited or calculated by the client',
    (tester) async {
      await mount(tester, _HarvestRepo(), route: '/harvests/create');
      await tester.pumpAndSettle();
      for (final count in ['10000', '20000', '100001', '']) {
        await tester.enterText(
          find.byKey(const ValueKey('harvest-field-count')),
          count,
        );
        await tester.pumpAndSettle();
        expect(
          find.byKey(const ValueKey('harvest-field-remaining')),
          findsNothing,
        );
      }
      expect(
        find.text(
          'Số tôm còn lại sau thu tỉa được hệ thống tự tính khi ghi nhận.',
        ),
        findsNothing,
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('list loading, server error, retry and empty state', (
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
    expect(find.text('Chưa có lần thu hoạch nào.'), findsOneWidget);
    expect(repo.queries.last.containsKey('cursor'), isFalse);
  });

  testWidgets(
    'failed pull to refresh keeps items, shows a notice and can retry',
    (tester) async {
      final repo = _HarvestRepo();
      await mount(tester, repo);
      await tester.pumpAndSettle();
      repo.listWait = Completer<HarvestPage>();
      await tester.drag(
        find.byType(CustomScrollView).first,
        const Offset(0, 500),
      );
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      expect(repo.queries, hasLength(2));
      repo.listWait!.completeError(const NetworkException('Refresh failed'));
      await tester.pump();
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.text('Refresh failed'), findsOneWidget);
      expect(find.byKey(const ValueKey('harvest-harvest-1')), findsOneWidget);
      expect(find.byType(RefreshProgressIndicator), findsNothing);
      repo.listWait = null;
      repo.result = page(
        items: [
          HarvestEvent.fromJson({...eventJson(), 'id': 'harvest-2'}),
        ],
      );
      await tester.drag(
        find.byType(CustomScrollView).first,
        const Offset(0, 500),
      );
      await tester.pumpAndSettle();
      expect(repo.queries, hasLength(3));
      expect(find.byKey(const ValueKey('harvest-harvest-2')), findsOneWidget);
      expect(find.byKey(const ValueKey('harvest-harvest-1')), findsNothing);
    },
  );

  testWidgets('load more carries cursor, merges items and refresh clears it', (
    tester,
  ) async {
    final repo = _HarvestRepo()..result = page(more: true, cursor: 'next');
    await mount(tester, repo);
    await tester.pumpAndSettle();
    repo.result = page(
      items: [
        HarvestEvent.fromJson({...eventJson(), 'id': 'harvest-2'}),
      ],
    );
    await tester.ensureVisible(find.text('Tải thêm'));
    await tester.tap(find.text('Tải thêm'));
    await tester.pumpAndSettle();
    expect(repo.queries.last['cursor'], 'next');
    expect(find.byKey(const ValueKey('harvest-harvest-1')), findsOneWidget);
    expect(find.byKey(const ValueKey('harvest-harvest-2')), findsOneWidget);
    final context = tester.element(find.byType(HarvestListPage));
    await ProviderScope.containerOf(
      context,
    ).read(harvestListProvider('season-1').notifier).refresh();
    await tester.pumpAndSettle();
    expect(repo.queries.last.containsKey('cursor'), isFalse);
  });
  testWidgets('list and detail render facts and retain completed history', (
    tester,
  ) async {
    await mount(tester, _HarvestRepo(), status: SeasonStatus.completed);
    await tester.pumpAndSettle();
    expect(find.text('Ghi nhận thu hoạch'), findsNothing);
    expect(find.text('620 kg'), findsWidgets);
    expect(find.text('117,8 tr đ'), findsNWidgets(2));
    expect(
      find.text(harvestDate(DateTime.parse(eventJson()['harvestedAt']))),
      findsOneWidget,
    );
    await capture(tester, 'list');
    await tester.tap(find.byKey(const ValueKey('harvest-harvest-1')));
    await tester.pumpAndSettle();
    expect(find.text('Chi tiết thu hoạch'), findsOneWidget);
    expect(find.text('Sản lượng và giá bán'), findsOneWidget);
    expect(find.text('117,8 tr đ'), findsNWidgets(2));
    await capture(tester, 'detail');
    expect(tester.takeException(), isNull);
  });

  testWidgets('large harvest values and complete timestamps fit narrow cards', (
    tester,
  ) async {
    final event = HarvestEvent.fromJson(eventJson()).copyWith(
      harvestType: HarvestType.finalHarvest,
      totalWeightKg: 99999999999.5,
      quantityCount: '9007199254740991',
      pricePerKg: 999999999999.99,
      totalRevenue: 12000000000,
      estimatedRemainingCount: '0',
    );
    final repo = _HarvestRepo()
      ..detailResult = event
      ..result = page(items: [event]).copyWith(
        totalWeightKg: event.totalWeightKg,
        totalRevenue: event.totalRevenue!,
      );
    await mount(tester, repo, status: SeasonStatus.completed);
    tester.view.physicalSize = const Size(320, 900);
    tester.platformDispatcher.textScaleFactorTestValue = 1.3;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await tester.pumpAndSettle();
    expect(find.text('12 tỷ đ'), findsNWidgets(2));
    expect(find.text(harvestDate(event.harvestedAt)), findsOneWidget);
    expect(find.byTooltip('12.000.000.000 đ'), findsNWidgets(2));
    expect(tester.takeException(), isNull);

    await tester.tap(find.byKey(const ValueKey('harvest-harvest-1')));
    await tester.pumpAndSettle();
    expect(find.text('12 tỷ đ'), findsNWidgets(2));
    expect(find.text(harvestDate(event.harvestedAt)), findsWidgets);
    await tester.scrollUntilVisible(find.text('Tạo lúc'), 150);
    expect(find.text(harvestDate(event.createdAt)), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'final harvest groups species, price and DOC warnings in one dialog',
    (tester) async {
      final repo = _HarvestRepo()
        ..result = page().copyWith(speciesThresholdsEnabled: true);
      await mount(
        tester,
        repo,
        route: '/harvests/create',
        seasonOverride: season(SeasonStatus.active).copyWith(
          stockingDate: DateTime.now().subtract(const Duration(days: 20)),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Thu hoạch cuối'));
      await tester.pumpAndSettle();
      await _fillHarvestFacts(tester, weight: '10', count: '1600');
      await tester.enterText(
        find.byKey(const ValueKey('harvest-field-price')),
        '30000',
      );
      await _pickHarvestTime(tester);
      await _pressHarvest(tester, finalHarvest: true);
      expect(find.text('Xác nhận thu hoạch cuối'), findsOneWidget);
      expect(
        find.textContaining('Cỡ tôm nằm ngoài khoảng thường gặp 20–150'),
        findsOneWidget,
      );
      expect(
        find.textContaining('Đơn giá nằm ngoài khoảng thường gặp'),
        findsOneWidget,
      );
      expect(find.textContaining('Vụ nuôi mới').hitTestable(), findsWidgets);
      expect(find.text('Vẫn lưu'), findsNothing);
      expect(repo.bodies, isEmpty);
    },
  );

  for (final finalHarvest in [false, true]) {
    testWidgets(
      'can record harvest without price when enabled, final=$finalHarvest',
      (tester) async {
        final repo = _HarvestRepo()
          ..result = page().copyWith(deferredPriceEnabled: true);
        await mount(tester, repo, route: '/harvests/create');
        await tester.pumpAndSettle();
        if (finalHarvest) {
          await tester.tap(find.text('Thu hoạch cuối'));
          await tester.pumpAndSettle();
        }
        expect(find.text('Nhập giá bán'), findsOneWidget);
        final banner = find.byType(AppFormMessageBanner);
        expect(banner, findsOneWidget);
        final notice = tester.widget<AppFormMessageBanner>(banner);
        expect(notice.title, 'Lưu ý');
        expect(notice.level, AppNoticeLevel.info);
        expect(
          find.text('Tôm chết ghi vào hao hụt, không ghi thành thu hoạch.'),
          findsOneWidget,
        );
        expect(
          tester.getBottomLeft(find.text('Ghi nhận thu hoạch')).dy,
          lessThanOrEqualTo(tester.getTopLeft(banner).dy),
        );
        expect(
          tester.getBottomLeft(banner).dy,
          lessThan(tester.getTopLeft(find.text('Loại thu hoạch *')).dy),
        );
        await _fillHarvestFacts(tester);
        await tester.enterText(
          find.byKey(const ValueKey('harvest-field-price')),
          '',
        );
        await _pickHarvestTime(tester);
        await _pressHarvest(tester, finalHarvest: finalHarvest);
        expect(
          find.textContaining('Đơn giá và doanh thu chưa xác định'),
          findsOneWidget,
        );
        await tester.tap(find.text('Xác nhận'));
        await tester.pumpAndSettle();
        expect(repo.bodies.single.containsKey('pricePerKg'), isFalse);
        expect(repo.bodies.single['quantityCount'], 100);
      },
    );
  }

  testWidgets('confirms price on the completed season harvest detail', (
    tester,
  ) async {
    final repo = _HarvestRepo()
      ..detailResult = HarvestEvent.fromJson(eventJson()).copyWith(
        harvestType: HarvestType.finalHarvest,
        pricePerKg: null,
        totalRevenue: null,
        canConfirmPrice: true,
      );
    await mount(
      tester,
      repo,
      route: '/harvests/harvest-1',
      status: SeasonStatus.completed,
    );
    await tester.pumpAndSettle();
    expect(find.text('Chưa xác định'), findsWidgets);
    await tester.ensureVisible(find.text('Bổ sung giá'));
    await tester.tap(find.text('Bổ sung giá'));
    await tester.pumpAndSettle();
    expect(find.text('Chốt giá thu hoạch'), findsOneWidget);
    expect(
      find.text('Sau khi chốt, đơn giá sẽ không thể sửa.'),
      findsOneWidget,
    );
    final zeroNotice = find.text(
      'Doanh thu của phiếu sẽ được ghi nhận là 0 đ.',
    );
    expect(zeroNotice, findsNothing);
    await tester.enterText(find.byType(TextFormField), '0');
    await tester.pumpAndSettle();
    expect(zeroNotice, findsOneWidget);
    await tester.enterText(find.byType(TextFormField), '125000');
    await tester.pumpAndSettle();
    expect(zeroNotice, findsNothing);
    await tester.tap(find.text('Chốt giá'));
    await tester.pumpAndSettle();
    expect(repo.confirmedPrices, [125000]);
    expect(repo.detailResult?.totalRevenue, 77500000);
    expect(find.text('Bổ sung giá'), findsNothing);
  });
  testWidgets(
    'partial form has no remainder input and final form keeps completion warning',
    (tester) async {
      await mount(tester, _HarvestRepo(), route: '/harvests/create');
      await tester.pumpAndSettle();
      expect(
        find.byKey(const ValueKey('harvest-field-remaining')),
        findsNothing,
      );
      final weight = tester
          .widget<TextFormField>(
            find.byKey(const ValueKey('harvest-field-weight')),
          )
          .validator!;
      expect(weight('0'), isNotNull);
      expect(weight('1,125'), isNull);
      expect(weight('1,1254'), 'Chỉ nhập tối đa 3 chữ số sau dấu phẩy');
      expect(weight('1,12'), isNull);
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
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'revenue preview updates to 12 billion for 100000 kg at 120000 per kg',
    (tester) async {
      await mount(tester, _HarvestRepo(), route: '/harvests/create');
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const ValueKey('harvest-field-weight')),
        '100000',
      );
      await tester.enterText(
        find.byKey(const ValueKey('harvest-field-price')),
        '120.000',
      );
      await tester.pumpAndSettle();
      expect(find.text('Doanh thu dự kiến: 12.000.000.000 đ'), findsOneWidget);
      await tester.enterText(
        find.byKey(const ValueKey('harvest-field-weight')),
        '1000',
      );
      await tester.pumpAndSettle();
      expect(
        find.textContaining('Doanh thu dự kiến: 120.000.000 đ'),
        findsOneWidget,
      );
      await tester.ensureVisible(find.text('Thu tỉa'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Thu tỉa'));
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<TextFormField>(
              find.byKey(const ValueKey('harvest-field-price')),
            )
            .controller!
            .text,
        '120.000',
      );
    },
  );

  testWidgets(
    'switching harvest types clears inputs, date, revenue and validation errors',
    (tester) async {
      final repo = _HarvestRepo();
      await mount(tester, repo, route: '/harvests/create');
      await tester.pumpAndSettle();
      for (final entry in {
        'weight': '100000',
        'price': '120.000',
        'count': '100001',
        'buyer': 'Người mua',
        'contact': '0901234567',
        'note': 'Ghi chú cũ',
      }.entries) {
        await tester.enterText(
          find.byKey(ValueKey('harvest-field-${entry.key}')),
          entry.value,
        );
      }
      await tester.ensureVisible(find.text('Chọn ngày và giờ...'));
      await tester.pumpAndSettle();
      FocusManager.instance.primaryFocus?.unfocus();
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Chọn ngày và giờ...'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Chọn ngày và giờ...'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Ghi nhận thu tỉa'));
      await tester.pumpAndSettle();
      FocusManager.instance.primaryFocus?.unfocus();
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Ghi nhận thu tỉa'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Ghi nhận thu tỉa'));
      await tester.pumpAndSettle();
      expect(find.text('Số lượng thu hoạch chưa hợp lệ'), findsOneWidget);
      await tester.tap(find.text('Kiểm tra lại'));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Thu hoạch cuối'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Thu hoạch cuối'));
      await tester.pumpAndSettle();
      for (final field in [
        'weight',
        'price',
        'count',
        'buyer',
        'contact',
        'note',
      ]) {
        final widget = tester.widget<TextFormField>(
          find.byKey(ValueKey('harvest-field-$field')),
        );
        expect(widget.controller!.text, isEmpty);
        expect(widget.forceErrorText, isNull);
      }
      expect(find.text('Chọn ngày và giờ...'), findsOneWidget);
      expect(find.textContaining('Doanh thu dự kiến:'), findsNothing);
      await tester.tap(find.text('Thu tỉa'));
      await tester.pumpAndSettle();
      expect(
        find.byKey(const ValueKey('harvest-field-remaining')),
        findsNothing,
      );
      expect(find.textContaining('Vui lòng chọn thời điểm'), findsNothing);
      expect(find.textContaining('Thu tỉa phải còn tôm'), findsNothing);
      expect(repo.keys, isEmpty);
    },
  );

  for (final warning in [null, 'Cảnh báo BE theo ngưỡng cấu hình']) {
    testWidgets(
      'final confirmation can be cancelled and success shows server warning: $warning',
      (tester) async {
        final repo = _HarvestRepo()
          ..recordResult = HarvestEvent.fromJson(
            eventJson(),
          ).copyWith(warnings: warning == null ? [] : [warning]);
        await mount(tester, repo, route: '/harvests/create');
        await tester.pumpAndSettle();
        await tester.tap(find.text('Thu hoạch cuối'));
        await tester.pumpAndSettle();
        await tester.enterText(
          find.byKey(const ValueKey('harvest-field-weight')),
          '480',
        );
        await _fillHarvestFacts(tester, weight: '480', count: '48000');
        FocusManager.instance.primaryFocus?.unfocus();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Chọn ngày và giờ...'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Chọn ngày và giờ...'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('OK'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('OK'));
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Ghi nhận thu hoạch cuối'));
        await tester.pumpAndSettle();
        FocusManager.instance.primaryFocus?.unfocus();
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
        FocusManager.instance.primaryFocus?.unfocus();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Ghi nhận thu hoạch cuối'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Ghi nhận thu hoạch cuối'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Xác nhận'));
        await tester.pumpAndSettle();
        expect(repo.keys, hasLength(1));
        expect(repo.bodies.single, containsPair('harvestType', 'FINAL'));
        expect(
          repo.bodies.single.containsKey('estimatedRemainingCount'),
          isFalse,
        );
        expect(find.text('Danh sách thu hoạch'), findsOneWidget);
        if (warning != null) {
          expect(find.text(warning), findsNothing);
        }
        expect(find.text('Đã ghi nhận thu hoạch thành công.'), findsOneWidget);
      },
    );
  }

  for (final status in [400, 409]) {
    testWidgets('BE rejection $status keeps the harvest form and entered facts', (
      tester,
    ) async {
      final message = status == 400
          ? 'Thời điểm thu hoạch phải từ ngày thả giống, muộn hơn lần thu gần nhất và không ở tương lai.'
          : 'BE từ chối lần thu hoạch này';
      final repo = _HarvestRepo()
        ..recordError = ApiException(message, statusCode: status);
      await mount(tester, repo, route: '/harvests/create');
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const ValueKey('harvest-field-weight')),
        '10',
      );
      await tester.enterText(
        find.byKey(const ValueKey('harvest-field-count')),
        '99300',
      );
      await _fillHarvestFacts(tester, weight: '1000', count: '99300');
      FocusManager.instance.primaryFocus?.unfocus();
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Chọn ngày và giờ...'));
      FocusManager.instance.primaryFocus?.unfocus();
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Chọn ngày và giờ...'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Chọn ngày và giờ...'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Ghi nhận thu tỉa'));
      FocusManager.instance.primaryFocus?.unfocus();
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Ghi nhận thu tỉa'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Ghi nhận thu tỉa'));
      await tester.pumpAndSettle();
      expect(find.text('Xác nhận thu tỉa'), findsOneWidget);
      expect(repo.keys, isEmpty);
      if (status == 400) {
        await tester.tap(find.text('Quay lại'));
        await tester.pumpAndSettle();
        expect(repo.keys, isEmpty);
        expect(
          await SecureHarvestSubmissionStore(
            const FlutterSecureStorage(),
          ).read('owner', 'season-1'),
          isNull,
        );
        await tester.ensureVisible(find.text('Ghi nhận thu tỉa'));
        FocusManager.instance.primaryFocus?.unfocus();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Ghi nhận thu tỉa'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Ghi nhận thu tỉa'));
        await tester.pumpAndSettle();
      }
      await tester.tap(find.text('Xác nhận'));
      await tester.pumpAndSettle();
      expect(repo.keys, hasLength(1));
      expect(
        repo.bodies.single.containsKey('estimatedRemainingCount'),
        isFalse,
      );
      expect(find.text(message), findsOneWidget);
      expect(find.byType(HarvestFormPage), findsOneWidget);
      expect(find.text('Đã ghi nhận thu hoạch thành công.'), findsNothing);
      final field = tester.widget<TextFormField>(
        find.byKey(const ValueKey('harvest-field-weight')),
      );
      expect(field.controller!.text, '1.000');
      expect(
        await SecureHarvestSubmissionStore(
          const FlutterSecureStorage(),
        ).read('owner', 'season-1'),
        isNull,
      );
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets(
    'backdated partial waits for the historical population and sends no remainder',
    (tester) async {
      final historical = Completer<HarvestPage>();
      final repo = _HarvestRepo()
        ..result = page().copyWith(availableQuantityCount: '900')
        ..populationLoad = (_) => historical.future;
      await mount(tester, repo, route: '/harvests/create');
      await tester.pumpAndSettle();
      await _fillHarvestFacts(tester);
      await _pickHarvestTime(tester, waitForPopulation: false);
      final submit = find.widgetWithText(GradientButton, 'Ghi nhận thu tỉa');
      expect(tester.widget<GradientButton>(submit).onPressed, isNull);
      historical.complete(page().copyWith(availableQuantityCount: '1000'));
      await tester.pumpAndSettle();
      expect(find.textContaining('trong ao: 1.000 con'), findsOneWidget);
      expect(
        find.byKey(const ValueKey('harvest-field-remaining')),
        findsNothing,
      );
      expect(repo.queries.last, contains('populationAt'));
      await _pressHarvest(tester);
      expect(find.text('Xác nhận thu tỉa'), findsOneWidget);
      await tester.tap(find.text('Xác nhận'));
      await tester.pumpAndSettle();
      expect(
        repo.bodies.single.containsKey('estimatedRemainingCount'),
        isFalse,
      );
    },
  );

  for (final isFinal in [false, true]) {
    for (final days in [10, 59]) {
      testWidgets('DOC warning stays consistent while population loads '
          '(final: $isFinal, elapsed days: $days)', (tester) async {
        final historical = Completer<HarvestPage>();
        final policyPage = page().copyWith(speciesThresholdsEnabled: true);
        final repo = _HarvestRepo()
          ..result = policyPage
          ..populationLoad = (_) => historical.future;
        await mount(
          tester,
          repo,
          route: '/harvests/create',
          seasonOverride: season(SeasonStatus.active).copyWith(
            stockingDate: vietnamHarvestDay(
              DateTime.now(),
            ).subtract(Duration(days: days)),
          ),
        );
        await tester.pumpAndSettle();
        if (isFinal) {
          await tester.tap(find.text('Thu hoạch cuối'));
          await tester.pumpAndSettle();
        }
        await _pickHarvestTime(tester, waitForPopulation: false);
        final warning = find.byKey(const ValueKey('harvest-early-warning'));
        final expected = days == 10 ? findsOneWidget : findsNothing;
        expect(repo.queries.last, contains('populationAt'));
        expect(warning, expected);
        expect(find.textContaining('chu kỳ tham khảo'), findsNothing);
        if (days == 10) {
          expect(find.textContaining('Vụ nuôi mới'), findsOneWidget);
        }

        historical.complete(policyPage);
        await tester.pumpAndSettle();
        expect(warning, expected);
        expect(find.textContaining('chu kỳ tham khảo'), findsNothing);
      });
    }
  }

  testWidgets('early warning allows saving at the mortality-adjusted limit', (
    tester,
  ) async {
    final repo = _HarvestRepo()
      ..result = page().copyWith(availableQuantityCount: '650');
    final recentSeason = season(SeasonStatus.active).copyWith(
      shrimpType: ShrimpType.blackTiger,
      stockingDate: vietnamHarvestDay(
        DateTime.now(),
      ).subtract(const Duration(days: 10)),
    );
    await mount(
      tester,
      repo,
      route: '/harvests/create',
      seasonOverride: recentSeason,
    );
    await tester.pumpAndSettle();
    expect(find.textContaining('trong ao: 650 con'), findsOneWidget);
    await _fillHarvestFacts(tester, weight: '10', count: '200');
    await tester.enterText(
      find.byKey(const ValueKey('harvest-field-weight')),
      '10',
    );
    await tester.enterText(
      find.byKey(const ValueKey('harvest-field-count')),
      '200',
    );
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Chọn ngày và giờ...'));
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Chọn ngày và giờ...'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Chọn ngày và giờ...'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('harvest-early-warning')), findsOneWidget);
    expect(find.textContaining('120 ngày của tôm sú'), findsOneWidget);
    await capture(tester, 'early-warning');
    await tester.ensureVisible(find.text('Ghi nhận thu tỉa'));
    await tester.pumpAndSettle();
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Ghi nhận thu tỉa'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ghi nhận thu tỉa'));
    await tester.pumpAndSettle();
    expect(find.text('Xác nhận thu tỉa'), findsOneWidget);
    expect(find.textContaining('Lưu ý: Thu hoạch sau'), findsOneWidget);
    await tester.tap(find.text('Xác nhận'));
    await tester.pumpAndSettle();
    expect(repo.bodies.single['quantityCount'], 200);
    expect(repo.bodies.single.containsKey('estimatedRemainingCount'), isFalse);
    expect(find.text('Danh sách thu hoạch'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'required labels are marked and untouched fields wait for submit',
    (tester) async {
      final repo = _HarvestRepo();
      await mount(tester, repo, route: '/harvests/create');
      await tester.pumpAndSettle();

      for (final label in [
        'Loại thu hoạch',
        'Thời điểm thu hoạch',
        'Sản lượng (kg)',
        'Số lượng thu hoạch (con)',
        'Giá bán (đ/kg)',
        'Tên người mua',
      ]) {
        final text = tester.widget<Text>(find.text('$label *'));
        final span = text.textSpan! as TextSpan;
        expect(text.style?.color, AppColors.ink);
        expect(span.children?.single.style?.color, AppColors.error);
      }
      expect(find.text('Liên hệ người mua *'), findsNothing);

      Finder field(String name) => find.byKey(ValueKey('harvest-field-$name'));
      String? error(String name) =>
          tester.state<FormFieldState<String>>(field(name)).errorText;

      await tester.enterText(field('weight'), '100');
      await tester.enterText(field('count'), '1');
      await tester.pumpAndSettle();
      expect(error('weight'), isNull);
      expect(error('count'), isNull);
      FocusManager.instance.primaryFocus?.unfocus();
      await tester.pumpAndSettle();
      expect(error('weight'), contains('Cỡ tôm'));
      expect(error('count'), contains('Cỡ tôm'));
      expect(error('price'), isNull);
      expect(error('buyer'), isNull);

      await tester.enterText(field('count'), '1000');
      await tester.pumpAndSettle();
      expect(error('weight'), isNull);
      expect(error('count'), isNull);
      expect(error('price'), isNull);
      expect(error('buyer'), isNull);

      await _pressHarvest(tester);
      expect(error('price'), 'Vui lòng nhập giá trị.');
      expect(error('buyer'), 'Vui lòng nhập tên người mua.');
      expect(repo.bodies, isEmpty);
    },
  );

  for (final (weight, expectedSize) in [('100', '0,01'), ('1000', '< 0,01')]) {
    testWidgets(
      'partial harvest shows small size $expectedSize after leaving the count field',
      (tester) async {
        final repo = _HarvestRepo();
        await mount(tester, repo, route: '/harvests/create');
        await tester.pumpAndSettle();
        await tester.enterText(
          find.byKey(const ValueKey('harvest-field-weight')),
          weight,
        );
        await tester.pump();
        expect(find.textContaining('Cỡ tôm (số lượng'), findsNothing);
        await tester.enterText(
          find.byKey(const ValueKey('harvest-field-count')),
          '1',
        );
        await tester.pumpAndSettle();
        expect(find.textContaining('Cỡ tôm (số lượng'), findsNothing);
        FocusManager.instance.primaryFocus?.unfocus();
        await tester.pumpAndSettle();
        for (final field in ['weight', 'count']) {
          final error = tester
              .widget<TextFormField>(
                find.byKey(ValueKey('harvest-field-$field')),
              )
              .forceErrorText;
          expect(error, contains('Cỡ tôm'));
          expect(error, contains('$expectedSize con/kg'));
          expect(error, isNot(contains(': 0 con/kg')));
        }
        await tester.enterText(
          find.byKey(const ValueKey('harvest-field-weight')),
          '1,005',
        );
        await tester.pumpAndSettle();
        expect(find.textContaining('Cỡ tôm (số lượng'), findsNothing);
        expect(repo.bodies, isEmpty);
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets('count and price show validation after leaving the field', (
    tester,
  ) async {
    final repo = _HarvestRepo()
      ..result = page().copyWith(speciesThresholdsEnabled: true);
    await mount(tester, repo, route: '/harvests/create');
    await tester.pumpAndSettle();
    final count = find.byKey(const ValueKey('harvest-field-count'));
    final price = find.byKey(const ValueKey('harvest-field-price'));
    await tester.enterText(
      find.byKey(const ValueKey('harvest-field-weight')),
      '10',
    );
    await tester.enterText(count, '1');
    await tester.pumpAndSettle();
    expect(tester.widget<TextFormField>(count).forceErrorText, isNull);
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle();
    expect(
      tester.widget<TextFormField>(count).forceErrorText,
      contains('vô lý'),
    );

    await tester.ensureVisible(price);
    await tester.enterText(price, '100');
    await tester.pumpAndSettle();
    final priceError = find.textContaining('Đơn giá phải từ');
    expect(priceError, findsNothing);
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle();
    expect(priceError, findsOneWidget);
  });

  for (final isFinal in [false, true]) {
    testWidgets(
      'size validation waits for the weight field when count is entered first (final: $isFinal)',
      (tester) async {
        final repo = _HarvestRepo()
          ..result = page().copyWith(speciesThresholdsEnabled: true);
        await mount(tester, repo, route: '/harvests/create');
        await tester.pumpAndSettle();
        if (isFinal) {
          await tester.tap(find.text('Thu hoạch cuối'));
          await tester.pumpAndSettle();
        }
        final count = find.byKey(const ValueKey('harvest-field-count'));
        final weight = find.byKey(const ValueKey('harvest-field-weight'));
        final sizeError = find.textContaining('Cỡ tôm (số lượng');
        await tester.enterText(count, '20000');
        await tester.pumpAndSettle();
        await tester.enterText(weight, '1');
        await tester.pumpAndSettle();
        expect(sizeError, findsNothing);

        FocusManager.instance.primaryFocus?.unfocus();
        await tester.pumpAndSettle();
        expect(sizeError, findsNWidgets(2));

        await tester.enterText(weight, '400');
        await tester.pumpAndSettle();
        expect(sizeError, findsNothing);
        FocusManager.instance.primaryFocus?.unfocus();
        await tester.pumpAndSettle();
        expect(sizeError, findsNothing);
        expect(repo.bodies, isEmpty);
      },
    );
  }

  testWidgets('invalid size marks only the quantity and weight fields', (
    tester,
  ) async {
    final repo = _HarvestRepo();
    await mount(tester, repo, route: '/harvests/create');
    await tester.pumpAndSettle();
    await _fillHarvestFacts(tester, weight: '1', count: '50000');
    for (final field in ['weight', 'count']) {
      expect(
        tester
            .widget<TextFormField>(find.byKey(ValueKey('harvest-field-$field')))
            .forceErrorText,
        contains('vô lý'),
      );
    }
    expect(find.text('Số lượng thu hoạch chưa hợp lệ'), findsNothing);
    await _pressHarvest(tester);
    expect(find.text('Số lượng thu hoạch chưa hợp lệ'), findsOneWidget);
    expect(repo.bodies, isEmpty);
    await tester.tap(find.text('Kiểm tra lại'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const ValueKey('harvest-field-weight')),
      '5',
    );
    await tester.pumpAndSettle();
    for (final field in ['weight', 'count']) {
      expect(
        tester
            .widget<TextFormField>(find.byKey(ValueKey('harvest-field-$field')))
            .forceErrorText,
        isNull,
      );
    }
  });

  for (final invalidCount in ['', '200000', '200001', '9007199254740992']) {
    testWidgets('invalid partial count $invalidCount cannot be submitted', (
      tester,
    ) async {
      final repo = _HarvestRepo()
        ..result = page().copyWith(availableQuantityCount: '200000');
      await mount(tester, repo, route: '/harvests/create');
      await tester.pumpAndSettle();
      await _fillHarvestFacts(tester, weight: '1000', count: invalidCount);
      await _pressHarvest(tester);
      expect(repo.bodies, isEmpty);
      if (invalidCount == '9007199254740992') {
        expect(find.text('Giá trị quá lớn'), findsOneWidget);
      } else {
        expect(find.text('Số lượng thu hoạch chưa hợp lệ'), findsOneWidget);
        await tester.tap(find.text('Kiểm tra lại'));
        await tester.pumpAndSettle();
      }
      await tester.enterText(
        find.byKey(const ValueKey('harvest-field-count')),
        '100000',
      );
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<TextFormField>(
              find.byKey(const ValueKey('harvest-field-count')),
            )
            .forceErrorText,
        isNull,
      );
      expect(
        find.byKey(const ValueKey('harvest-field-remaining')),
        findsNothing,
      );
    });
  }

  testWidgets(
    'population rejection refreshes capacity and requires a fresh confirmation',
    (tester) async {
      const message = 'Số lượng trong ao đã thay đổi, vui lòng kiểm tra lại.';
      final repo = _HarvestRepo()
        ..result = page().copyWith(availableQuantityCount: '200000')
        ..nextResultOnError = page().copyWith(availableQuantityCount: '190000')
        ..recordError = const ApiException(
          message,
          statusCode: 400,
          details: {'code': 'HARVEST_POPULATION_MISMATCH'},
        );
      await mount(tester, repo, route: '/harvests/create');
      await tester.pumpAndSettle();
      await _fillHarvestFacts(tester, weight: '1000', count: '100000');
      await _pickHarvestTime(tester);
      await _pressHarvest(tester);
      await tester.tap(find.text('Xác nhận'));
      await tester.pumpAndSettle();
      expect(repo.keys, hasLength(1));
      expect(find.text('Số lượng thu hoạch chưa hợp lệ'), findsOneWidget);
      await tester.tap(find.text('Kiểm tra lại'));
      await tester.pumpAndSettle();
      expect(find.textContaining('trong ao: 190.000 con'), findsOneWidget);
      repo.recordError = null;
      await tester.enterText(
        find.byKey(const ValueKey('harvest-field-count')),
        '90000',
      );
      await tester.pumpAndSettle();
      await _pressHarvest(tester);
      expect(repo.keys, hasLength(1));
      await tester.tap(find.text('Xác nhận'));
      await tester.pumpAndSettle();
      expect(repo.bodies.last['quantityCount'], 90000);
      expect(repo.bodies.last.containsKey('estimatedRemainingCount'), isFalse);
      expect(repo.keys, hasLength(2));
      expect(repo.keys.first, isNot(repo.keys.last));
    },
  );

  for (final status in [
    SeasonStatus.planning,
    SeasonStatus.completed,
    SeasonStatus.cancelled,
  ]) {
    testWidgets('fresh harvest form is unavailable for $status', (
      tester,
    ) async {
      await mount(
        tester,
        _HarvestRepo(),
        route: '/harvests/create',
        status: status,
      );
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('harvest-field-weight')), findsNothing);
      expect(
        find.textContaining('Không thể ghi thêm thu hoạch'),
        findsOneWidget,
      );
    });
  }

  testWidgets('unknown available count never falls back to initial stock', (
    tester,
  ) async {
    final repo = _HarvestRepo()
      ..result = page().copyWith(
        items: [],
        totalResults: 0,
        availableQuantityCount: null,
      );
    await mount(tester, repo, route: '/harvests/create');
    await tester.pumpAndSettle();
    expect(
      find.text('Chưa có ước tính số tôm còn lại trong ao.'),
      findsOneWidget,
    );
    expect(find.textContaining('trong ao: 200000'), findsNothing);
  });

  testWidgets(
    'estimate is grouped above count and only an excess final count needs a reason',
    (tester) async {
      await mount(tester, _HarvestRepo(), route: '/harvests/create');
      await tester.pumpAndSettle();
      final estimate = find.byKey(const ValueKey('harvest-available-count'));
      final count = find.byKey(const ValueKey('harvest-field-count'));
      final reason = find.byKey(const ValueKey('harvest-field-variance'));
      expect(find.textContaining('trong ao: 100.000 con'), findsOneWidget);
      expect(reason, findsNothing);
      expect(
        tester.getBottomLeft(estimate).dy,
        lessThan(tester.getTopLeft(count).dy),
      );
      await tester.enterText(count, '10000');
      await tester.pumpAndSettle();
      expect(reason, findsNothing);
      FocusManager.instance.primaryFocus?.unfocus();
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Thu hoạch cuối'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Thu hoạch cuối'));
      await tester.pumpAndSettle();
      expect(reason, findsNothing);
      await tester.enterText(count, '100001');
      await tester.pumpAndSettle();
      expect(reason, findsOneWidget);
      await tester.enterText(count, '100000');
      await tester.pumpAndSettle();
      expect(reason, findsNothing);
    },
  );

  testWidgets(
    'final harvest uses the API reason flag even without a season disease count',
    (tester) async {
      final repo = _HarvestRepo()
        ..result = page().copyWith(finalReasonRequired: true);
      await mount(
        tester,
        repo,
        route: '/harvests/create',
        seasonOverride: season(
          SeasonStatus.active,
        ).copyWith(activeDiseaseCasesCount: 0),
      );
      await tester.pumpAndSettle();
      final reason = find.byKey(const ValueKey('harvest-field-variance'));
      expect(reason, findsNothing);
      expect(
        tester
            .widget<GradientButton>(
              find.widgetWithText(GradientButton, 'Ghi nhận thu tỉa'),
            )
            .onPressed,
        isNull,
      );
      expect(
        find.text(
          'Không thể thu tỉa khi còn ca bệnh chưa đóng hoặc phác đồ điều trị chưa kết thúc.',
        ),
        findsOneWidget,
      );
      await tester.tap(find.text('Thu hoạch cuối'));
      await tester.pumpAndSettle();
      expect(reason, findsOneWidget);
      expect(tester.widget<TextFormField>(reason).validator!(''), isNotNull);
      repo.result = page().copyWith(finalReasonRequired: false);
      ProviderScope.containerOf(
        tester.element(find.byType(HarvestFormPage)),
      ).invalidate(harvestPopulationProvider((seasonId: 'season-1', at: null)));
      await tester.pumpAndSettle();
      expect(reason, findsNothing);
    },
  );

  testWidgets(
    'final disease exception requires a reason and submits after withdrawal clears',
    (tester) async {
      final repo = _HarvestRepo()
        ..result = page().copyWith(finalReasonRequired: true);
      await mount(tester, repo, route: '/harvests/create');
      await tester.pumpAndSettle();
      await tester.tap(find.text('Thu hoạch cuối'));
      await tester.pumpAndSettle();
      await _fillHarvestFacts(tester);
      await _pickHarvestTime(tester);
      await _pressHarvest(tester, finalHarvest: true);
      expect(repo.bodies, isEmpty);
      expect(find.text('Vui lòng nhập lý do thu hoạch cuối.'), findsOneWidget);
      final reason = find.byKey(const ValueKey('harvest-field-variance'));
      await tester.ensureVisible(reason);
      await tester.enterText(reason, 'Thu cuối khi còn ca bệnh');
      await _pressHarvest(tester, finalHarvest: true);
      expect(find.text('Xác nhận thu hoạch cuối'), findsOneWidget);
      await tester.tap(find.text('Xác nhận'));
      await tester.pumpAndSettle();
      expect(repo.bodies.single['varianceReason'], 'Thu cuối khi còn ca bệnh');
      expect(tester.takeException(), isNull);
    },
  );

  for (final scenario in [
    (unknown: false, disease: false),
    (unknown: true, disease: false),
    (unknown: false, disease: true),
    (unknown: true, disease: true),
  ]) {
    testWidgets(
      'withdrawal blocks both harvest types even with a disease reason; $scenario',
      (tester) async {
        final repo = _HarvestRepo()
          ..result = page().copyWith(
            finalReasonRequired: scenario.disease,
            withdrawal: HarvestWithdrawal(
              verified: true,
              unknown: scenario.unknown,
              blocked: !scenario.unknown,
              latestEndAt: scenario.unknown
                  ? null
                  : DateTime.now().add(const Duration(days: 7)),
            ),
          );
        await mount(tester, repo, route: '/harvests/create');
        await tester.pumpAndSettle();
        expect(
          tester
              .widget<GradientButton>(
                find.widgetWithText(GradientButton, 'Ghi nhận thu tỉa'),
              )
              .onPressed,
          isNull,
        );
        await tester.tap(find.text('Thu hoạch cuối'));
        await tester.pumpAndSettle();
        final reason = find.byKey(const ValueKey('harvest-field-variance'));
        expect(reason, scenario.disease ? findsOneWidget : findsNothing);
        if (scenario.disease) {
          await tester.ensureVisible(reason);
          await tester.enterText(reason, 'Thu cuối khi còn ca bệnh');
        }
        expect(
          find.textContaining(
            'Không thể ghi nhận thu hoạch, kể cả thu hoạch cuối.',
          ),
          findsOneWidget,
        );
        await _fillHarvestFacts(tester);
        await _pickHarvestTime(tester);
        expect(
          tester
              .widget<GradientButton>(
                find.widgetWithText(GradientButton, 'Ghi nhận thu hoạch cuối'),
              )
              .onPressed,
          isNull,
        );
        await _pressHarvest(tester, finalHarvest: true);
        expect(find.text('Xác nhận thu hoạch cuối'), findsNothing);
        expect(repo.bodies, isEmpty);
        expect(tester.takeException(), isNull);
      },
    );
  }

  for (final finalHarvest in [false, true]) {
    for (final businessError in [false, true]) {
      testWidgets(
        'save error identifies harvest action instead of loading; final=$finalHarvest business=$businessError',
        (tester) async {
          const message =
              'Thời điểm thu hoạch không hợp lệ. Vui lòng kiểm tra lại.';
          final repo = _HarvestRepo()
            ..recordError = businessError
                ? const ApiException(message, statusCode: 400)
                : StateError('internal persistence failure');
          await mount(tester, repo, route: '/harvests/create');
          await tester.pumpAndSettle();
          if (finalHarvest) {
            await tester.tap(find.text('Thu hoạch cuối'));
            await tester.pumpAndSettle();
          }
          await _fillHarvestFacts(tester);
          await _pickHarvestTime(tester);
          await _pressHarvest(tester, finalHarvest: finalHarvest);
          await tester.tap(find.text('Xác nhận'));
          await tester.pumpAndSettle();
          final label = finalHarvest ? 'thu hoạch cuối' : 'thu tỉa';
          expect(find.text('Không thể ghi nhận $label'), findsOneWidget);
          expect(
            find.byKey(const ValueKey('harvest-submission-error')),
            findsOneWidget,
          );
          expect(
            find.textContaining('Không thể tải dữ liệu thu hoạch'),
            findsNothing,
          );
          expect(
            find.textContaining('internal persistence failure'),
            findsNothing,
          );
          expect(find.text('Đã ghi nhận thu hoạch thành công.'), findsNothing);
          if (businessError) {
            expect(find.text(message), findsOneWidget);
            expect(find.text('Thu hoạch đang chờ xác nhận'), findsNothing);
          } else {
            expect(
              find.textContaining('Chưa thể xác nhận kết quả ghi nhận $label'),
              findsOneWidget,
            );
            expect(find.text('Thu hoạch đang chờ xác nhận'), findsOneWidget);
          }
          expect(repo.bodies, hasLength(1));
          expect(tester.takeException(), isNull);
        },
      );
    }
  }

  for (final finalHarvest in [false, true]) {
    testWidgets(
      'population time rejection is red inline at the time field; final=$finalHarvest',
      (tester) async {
        const message = 'Thời điểm ước tính số tôm không được ở tương lai.';
        final repo = _HarvestRepo()
          ..populationLoad = (_) async =>
              throw const ApiException(message, statusCode: 400);
        await mount(tester, repo, route: '/harvests/create');
        await tester.pumpAndSettle();
        if (finalHarvest) {
          await tester.tap(find.text('Thu hoạch cuối'));
          await tester.pumpAndSettle();
        }
        await _pickHarvestTime(tester);
        final decorator = tester.widget<InputDecorator>(
          find.ancestor(
            of: find.text(
              harvestDate(
                DateTime.parse(repo.queries.last['populationAt'] as String),
              ),
            ),
            matching: find.byType(InputDecorator),
          ),
        );
        expect(decorator.decoration.errorText, message);
        expect(find.byType(AppErrorState), findsNothing);
        expect(find.byIcon(Icons.cloud_off_rounded), findsNothing);
        expect(find.text('Thử lại'), findsNothing);
        expect(find.text('Kiểm tra lại số tôm'), findsNothing);
        expect(repo.bodies, isEmpty);
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets('server-required final reason can be entered and retried', (
    tester,
  ) async {
    final repo = _HarvestRepo()
      ..nextResultOnError = page().copyWith(finalReasonRequired: true)
      ..recordError = const ApiException(
        'Vui lòng nhập lý do thu hoạch cuối khi còn ca bệnh đang mở hoặc đang điều trị.',
        statusCode: 400,
        details: {'code': 'HARVEST_FINAL_REASON_REQUIRED'},
      );
    await mount(tester, repo, route: '/harvests/create');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Thu hoạch cuối'));
    await tester.pumpAndSettle();
    for (final entry in {
      'weight': '1000',
      'count': '50000',
      'price': '120000',
      'buyer': 'Người mua',
    }.entries) {
      await tester.enterText(
        find.byKey(ValueKey('harvest-field-${entry.key}')),
        entry.value,
      );
    }
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Chọn ngày và giờ...'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Chọn ngày và giờ...'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    final reason = find.byKey(const ValueKey('harvest-field-variance'));
    expect(reason, findsNothing);
    await tester.ensureVisible(find.text('Ghi nhận thu hoạch cuối'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ghi nhận thu hoạch cuối'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Xác nhận'));
    await tester.pumpAndSettle();
    expect(repo.bodies, hasLength(1));
    expect(reason, findsOneWidget);
    expect(tester.widget<TextFormField>(reason).validator!(''), isNotNull);
    repo.recordError = null;
    await tester.ensureVisible(reason);
    await tester.enterText(reason, 'Đã kiểm tra tình trạng ao');
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Ghi nhận thu hoạch cuối'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ghi nhận thu hoạch cuối'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Xác nhận'));
    await tester.pumpAndSettle();
    expect(repo.bodies, hasLength(2));
    expect(repo.bodies.last['varianceReason'], 'Đã kiểm tra tình trạng ao');
    expect(tester.takeException(), isNull);
  });

  for (final capacity in ['500000', '600000', null]) {
    testWidgets(
      'partial rejects exhaustion or unknown population; estimate=$capacity',
      (tester) async {
        final repo = _HarvestRepo()
          ..result = page().copyWith(
            availableQuantityCount: capacity,
            populationCorrectionEnabled: capacity == null,
          );
        await mount(tester, repo, route: '/harvests/create');
        await tester.pumpAndSettle();
        await _fillHarvestFacts(tester, weight: '10000', count: '600000');
        await _pressHarvest(tester);
        expect(find.text('Số lượng thu hoạch chưa hợp lệ'), findsOneWidget);
        expect(
          find.textContaining(
            capacity == null
                ? 'Chưa xác định được số tôm'
                : 'vui lòng chọn thu hoạch cuối',
          ),
          findsWidgets,
        );
        expect(repo.bodies, isEmpty);
        expect(
          find.byKey(const ValueKey('harvest-field-variance')),
          findsNothing,
        );
      },
    );
  }

  for (final (isFinal, count, useLegacyPolicy) in [
    (false, 99999, false),
    (false, 100000, false),
    (false, 100001, false),
    (true, 99999, false),
    (true, 100000, false),
    (true, 100001, false),
    (true, 100001, true),
  ]) {
    testWidgets(
      'population boundary: final=$isFinal, count=$count, legacy=$useLegacyPolicy',
      (tester) async {
        final repo = _HarvestRepo()
          ..result = page().copyWith(
            populationCorrectionEnabled: !useLegacyPolicy,
          );
        await mount(tester, repo, route: '/harvests/create');
        await tester.pumpAndSettle();
        if (isFinal) {
          await tester.tap(find.text('Thu hoạch cuối'));
          await tester.pumpAndSettle();
        }
        await _fillHarvestFacts(tester, weight: '1000', count: '$count');
        await _pickHarvestTime(tester);
        final reason = find.byKey(const ValueKey('harvest-field-variance'));
        final needsReason = isFinal && count > 100000;
        expect(reason, needsReason ? findsOneWidget : findsNothing);
        expect(
          find.byKey(const ValueKey('harvest-field-remaining')),
          findsNothing,
        );
        await _pressHarvest(tester, finalHarvest: isFinal);
        if (!isFinal && count >= 100000) {
          expect(find.text('Số lượng thu hoạch chưa hợp lệ'), findsOneWidget);
          expect(
            find.textContaining('vui lòng chọn thu hoạch cuối'),
            findsWidgets,
          );
          expect(repo.bodies, isEmpty);
          return;
        }
        if (needsReason) {
          expect(repo.bodies, isEmpty);
          expect(find.text('Vui lòng nhập lý do hiệu chỉnh.'), findsOneWidget);
          await tester.ensureVisible(reason);
          await tester.enterText(reason, 'Đã đếm lại số tôm');
          await _pressHarvest(tester, finalHarvest: isFinal);
        }
        expect(
          find.text(isFinal ? 'Xác nhận thu hoạch cuối' : 'Xác nhận thu tỉa'),
          findsOneWidget,
        );
        await tester.tap(find.text('Xác nhận'));
        await tester.pumpAndSettle();
        expect(repo.bodies.single['quantityCount'], count);
        expect(
          repo.bodies.single['varianceReason'],
          needsReason ? 'Đã đếm lại số tôm' : isNull,
        );
        expect(
          repo.bodies.single.containsKey('estimatedRemainingCount'),
          isFalse,
        );
        expect(tester.takeException(), isNull);
      },
    );
  }

  for (final isFinal in [false, true]) {
    testWidgets('refreshes a changed estimate after save, final=$isFinal', (
      tester,
    ) async {
      final repo = _HarvestRepo()
        ..result = page().copyWith(availableQuantityCount: '1100')
        ..nextResultOnError = page().copyWith(availableQuantityCount: '900')
        ..recordError = isFinal
            ? const ApiException(
                'Vui lòng nhập lý do hiệu chỉnh.',
                statusCode: 400,
                details: {'code': 'HARVEST_VARIANCE_REASON_REQUIRED'},
              )
            : const ApiException(
                'Nếu thu hết hoặc vượt ước tính, vui lòng chọn thu hoạch cuối.',
                statusCode: 400,
                details: {'code': 'HARVEST_POPULATION_MISMATCH'},
              );
      await mount(tester, repo, route: '/harvests/create');
      await tester.pumpAndSettle();
      if (isFinal) {
        await tester.tap(find.text('Thu hoạch cuối'));
        await tester.pumpAndSettle();
      }
      await _fillHarvestFacts(tester, weight: '10', count: '1000');
      await _pickHarvestTime(tester);
      await _pressHarvest(tester, finalHarvest: isFinal);
      await tester.tap(find.text('Xác nhận'));
      await tester.pumpAndSettle();
      expect(repo.bodies, hasLength(1));
      expect(find.textContaining('trong ao: 900 con'), findsOneWidget);
      final count = find.byKey(const ValueKey('harvest-field-count'));
      expect(tester.widget<TextFormField>(count).controller!.text, '1.000');
      final reason = find.byKey(const ValueKey('harvest-field-variance'));
      if (!isFinal) {
        expect(
          find.textContaining('vui lòng chọn thu hoạch cuối'),
          findsWidgets,
        );
        expect(reason, findsNothing);
        return;
      }
      await tester.ensureVisible(reason);
      await tester.enterText(reason, 'Đã đếm lại số tôm');
      repo.recordError = null;
      await _pressHarvest(tester, finalHarvest: true);
      await tester.tap(find.text('Xác nhận'));
      await tester.pumpAndSettle();
      expect(repo.bodies.last['varianceReason'], 'Đã đếm lại số tôm');
      expect(repo.keys.last, isNot(repo.keys.first));
    });
  }

  testWidgets(
    'confirmed pending time rejection restores facts and permits a corrected submission',
    (tester) async {
      const key = '11111111-1111-4111-8111-111111111111';
      final body = {
        ...submissionBody(),
        'quantityCount': 31000,
        'pricePerKg': 120000,
        'buyerName': 'Buyer',
        'buyerContact': '0901234567',
        'note': 'Original note',
        'varianceReason': 'Original correction',
      };
      final store = SecureHarvestSubmissionStore(const FlutterSecureStorage());
      await store.write(
        'owner',
        'season-1',
        PendingHarvestSubmission(key: key, body: body),
      );
      final repo = _HarvestRepo()
        ..recordError = const ApiException(
          'Time must be later',
          statusCode: 400,
          details: {'code': harvestTimeNotAfterLatestCode},
        );
      await mount(tester, repo, route: '/harvests/create');
      await tester.pumpAndSettle();
      await tester.tap(find.text('Kiểm tra và gửi lại'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Xác nhận'));
      await tester.pumpAndSettle();
      expect(await store.read('owner', 'season-1'), isNull);
      expect(find.text('Thu hoạch đang chờ xác nhận'), findsNothing);
      for (final entry in {
        'weight': '620',
        'count': '31.000',
        'price': '120.000',
        'buyer': 'Buyer',
        'contact': '0901234567',
        'note': 'Original note',
      }.entries) {
        expect(
          tester
              .widget<TextFormField>(
                find.byKey(ValueKey('harvest-field-${entry.key}')),
              )
              .controller!
              .text,
          entry.value,
        );
      }
      expect(repo.keys, [key]);
      final time = find.text(
        harvestDate(DateTime.parse(body['harvestedAt'] as String).toLocal()),
      );
      // Pick the following day, keeping all restored facts unchanged.
      await tester.ensureVisible(time);
      await tester.pumpAndSettle();
      await tester.tap(time);
      await tester.pumpAndSettle();
      tester
          .widget<CalendarDatePicker>(find.byType(CalendarDatePicker))
          .onDateChanged(DateTime(2026, 9, 4));
      await tester.pump();
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      repo.recordError = null;
      await tester.ensureVisible(find.text('Ghi nhận thu tỉa'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Ghi nhận thu tỉa'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Xác nhận'));
      await tester.pumpAndSettle();
      expect(repo.keys, hasLength(2));
      expect(repo.keys.last, isNot(key));
      expect(
        DateTime.parse(
          repo.bodies.last['harvestedAt'] as String,
        ).isAfter(DateTime.parse(body['harvestedAt'] as String)),
        isTrue,
      );
      for (final field in [
        'totalWeightKg',
        'quantityCount',
        'pricePerKg',
        'buyerName',
        'buyerContact',
        'note',
      ]) {
        expect(repo.bodies.last[field], body[field]);
      }
      expect(repo.bodies.first['varianceReason'], 'Original correction');
      expect(repo.bodies.last.containsKey('varianceReason'), isFalse);
    },
  );

  for (final entry in {'variance': 500, 'buyer': 255, 'contact': 255}.entries) {
    testWidgets(
      '${entry.key} rejects overlength Unicode without truncating and accepts the trimmed boundary',
      (tester) async {
        final repo = _HarvestRepo();
        if (entry.key == 'variance') {
          repo.result = page().copyWith(finalReasonRequired: true);
        }
        await mount(tester, repo, route: '/harvests/create');
        await tester.pumpAndSettle();
        if (entry.key == 'variance') {
          await tester.tap(find.text('Thu hoạch cuối'));
          await tester.pumpAndSettle();
          await tester.enterText(
            find.byKey(const ValueKey('harvest-field-count')),
            '100001',
          );
          await tester.pumpAndSettle();
        }
        final field = find.byKey(ValueKey('harvest-field-${entry.key}'));
        final boundary = '😀' * (entry.value ~/ 2) + 'x' * (entry.value % 2);
        final overlength = '${boundary}x';
        await tester.enterText(field, overlength);
        final state = tester.state<FormFieldState<String>>(field);
        expect(
          tester.widget<TextFormField>(field).controller!.text,
          overlength,
        );
        expect(state.validate(), isFalse);
        expect(state.errorText, contains('${entry.value}'));
        await tester.enterText(field, ' $boundary ');
        expect(state.validate(), isTrue);
        expect(state.errorText, isNull);
        expect(
          tester.widget<TextFormField>(field).controller!.text,
          ' $boundary ',
        );
        expect(repo.keys, isEmpty);
      },
    );
  }

  testWidgets(
    'note input caps new text at 500 and validates multi-unit characters',
    (tester) async {
      await mount(tester, _HarvestRepo(), route: '/harvests/create');
      await tester.pumpAndSettle();
      final note = find.byKey(const ValueKey('harvest-field-note'));
      await tester.enterText(note, 'x' * 501);
      expect(tester.widget<TextFormField>(note).controller!.text, 'x' * 500);
      await tester.enterText(note, '😀' * 251);
      final state = tester.state<FormFieldState<String>>(note);
      expect(state.validate(), isFalse);
      expect(state.errorText, contains('500'));
    },
  );

  testWidgets(
    'completed season restores an uncertain final instead of opening a fresh form',
    (tester) async {
      const key = '11111111-1111-4111-8111-111111111111';
      final store = SecureHarvestSubmissionStore(const FlutterSecureStorage());
      final body = {...submissionBody(finalHarvest: true), 'note': 'x' * 5000};
      await store.write(
        'owner',
        'season-1',
        PendingHarvestSubmission(key: key, body: body),
      );
      final repo = _HarvestRepo();
      await mount(tester, repo, status: SeasonStatus.completed);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Kiểm tra lần thu hoạch đang chờ'));
      await tester.pumpAndSettle();
      expect(find.text('Thu hoạch đang chờ xác nhận'), findsOneWidget);
      expect(find.byKey(const ValueKey('harvest-field-weight')), findsNothing);
      await tester.tap(find.text('Kiểm tra và gửi lại'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Quay lại'));
      await tester.pumpAndSettle();
      expect(repo.keys, isEmpty);
      await tester.tap(find.text('Kiểm tra và gửi lại'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Xác nhận'));
      await tester.pumpAndSettle();
      expect(repo.keys, [key]);
      expect(repo.bodies.single, body);
      expect(await store.read('owner', 'season-1'), isNull);
    },
  );
}

class _HarvestRepo implements HarvestRepository {
  HarvestPage result = page();
  final queries = <Map<String, dynamic>>[];
  final keys = <String>[];
  final bodies = <Map<String, dynamic>>[];
  Object? recordError;
  HarvestPage? nextResultOnError;
  Completer<HarvestPage>? listWait;
  Future<HarvestPage> Function(Map<String, dynamic>)? populationLoad;
  Completer<HarvestEvent>? recordWait;
  HarvestEvent? recordResult;
  HarvestEvent? detailResult;
  final confirmedPrices = <double>[];
  @override
  Future<HarvestPage> list(String seasonId, Map<String, dynamic> query) {
    queries.add(Map.of(query));
    if (query.containsKey('populationAt') && populationLoad != null) {
      return populationLoad!(query);
    }
    return listWait?.future ?? Future.value(result);
  }

  @override
  Future<HarvestEvent> detail(String seasonId, String harvestId) async =>
      detailResult ?? HarvestEvent.fromJson(eventJson());

  @override
  Future<HarvestEvent> confirmPrice(
    String seasonId,
    String harvestId,
    double pricePerKg,
  ) async {
    final event = await detail(seasonId, harvestId);
    confirmedPrices.add(pricePerKg);
    return detailResult = event.copyWith(
      pricePerKg: pricePerKg,
      totalRevenue: event.totalWeightKg * pricePerKg,
      canConfirmPrice: false,
    );
  }

  @override
  Future<HarvestEvent> record(
    String seasonId,
    Map<String, dynamic> body,
    String key,
  ) async {
    keys.add(key);
    bodies.add(Map.of(body));
    if (recordError != null) {
      result = nextResultOnError ?? result;
      throw recordError!;
    }
    return recordWait?.future ??
        recordResult ??
        HarvestEvent.fromJson(eventJson());
  }
}

class _HarvestFarmRepo implements FarmRepository {
  int activeSeasonCount = 1;
  int detailReads = 0;
  int listReads = 0;
  farms.Farm get farm => farms.Farm(
    id: 'farm',
    ownerId: 'owner',
    name: 'Farm',
    activeSeasonCount: activeSeasonCount,
    ponds: [
      farms.FarmPond(
        id: 'pond',
        name: 'Pond',
        type: farms.PondType.aquaculture,
        status: farms.PondStatus.available,
        currentSeason: activeSeasonCount == 0
            ? null
            : const farms.FarmCurrentSeason(
                id: 'season-1',
                status: farms.FarmSeasonStatus.active,
              ),
      ),
    ],
  );
  @override
  Future<farms.Farm> getFarm(String farmId) async {
    detailReads++;
    return farm;
  }

  @override
  Future<List<farms.Farm>> getFarms() async {
    listReads++;
    return [farm];
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _AuthRepo implements AuthRepository {
  _AuthRepo({this.role = AccountRole.farmOwner, this.id = 'owner'});
  final AccountRole role;
  final String id;
  @override
  Future<AuthAccount?> restoreSession() async =>
      owner.copyWith(role: role, id: id);
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FailingSubmissionStore implements HarvestSubmissionStore {
  _FailingSubmissionStore(
    this.delegate, {
    this.failWrite = false,
    this.failClear = false,
  });
  final HarvestSubmissionStore delegate;
  bool failWrite;
  bool failClear;
  @override
  Future<PendingHarvestSubmission?> read(String ownerId, String seasonId) =>
      delegate.read(ownerId, seasonId);
  @override
  Future<void> write(
    String ownerId,
    String seasonId,
    PendingHarvestSubmission submission,
  ) async {
    if (failWrite) throw StateError('storage write failed');
    await delegate.write(ownerId, seasonId, submission);
  }

  @override
  Future<void> clear(
    String ownerId,
    String seasonId, {
    required String expectedKey,
  }) async {
    if (failClear) throw StateError('storage clear failed');
    await delegate.clear(ownerId, seasonId, expectedKey: expectedKey);
  }
}

class _SeasonRepo implements SeasonRepository {
  _SeasonRepo(this.status, {this.seasonValue});
  final SeasonStatus status;
  final AquacultureSeason? seasonValue;
  @override
  Future<AquacultureSeason> getSeason(String seasonId) async =>
      seasonValue ?? season(status);
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

Future<void> _fillHarvestFacts(
  WidgetTester tester, {
  String weight = '10',
  String count = '100',
}) async {
  for (final entry in {
    'weight': weight,
    'count': count,
    'price': '120000',
    'buyer': 'Buyer',
  }.entries) {
    await tester.enterText(
      find.byKey(ValueKey('harvest-field-${entry.key}')),
      entry.value,
    );
  }
}

Future<void> _pickHarvestTime(
  WidgetTester tester, {
  bool waitForPopulation = true,
}) async {
  FocusManager.instance.primaryFocus?.unfocus();
  await tester.pumpAndSettle();
  await tester.ensureVisible(find.text('Chọn ngày và giờ...'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Chọn ngày và giờ...'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('OK'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('OK'));
  if (waitForPopulation) {
    await tester.pumpAndSettle();
  } else {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
  }
}

Future<void> _pressHarvest(
  WidgetTester tester, {
  bool finalHarvest = false,
}) async {
  FocusManager.instance.primaryFocus?.unfocus();
  await tester.pumpAndSettle();
  final label = find.text(
    finalHarvest ? 'Ghi nhận thu hoạch cuối' : 'Ghi nhận thu tỉa',
  );
  await tester.ensureVisible(label);
  await tester.pumpAndSettle();
  await tester.tap(label);
  await tester.pumpAndSettle();
}
