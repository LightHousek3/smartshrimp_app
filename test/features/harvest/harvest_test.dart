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
import 'package:smartshrimp_app/core/widgets/gradient_button.dart';
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
      expect(await newFuture, '900');
      older.complete(page().copyWith(availableQuantityCount: '1000'));
      expect(await oldFuture, '1000');
      expect(container.read(newProvider).value, '900');
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
      expect(await container.read(provider.future), '100000');
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
    await capture(tester, 'list');
    await tester.tap(find.byKey(const ValueKey('harvest-harvest-1')));
    await tester.pumpAndSettle();
    expect(find.text('Chi tiết thu hoạch'), findsOneWidget);
    expect(find.text('Sản lượng và giá bán'), findsOneWidget);
    await capture(tester, 'detail');
    expect(tester.takeException(), isNull);
  });
  testWidgets(
    'partial form suggests editable remaining; final form warns and hides it',
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
      final remaining = tester.widget<TextFormField>(
        find.byKey(const ValueKey('harvest-field-remaining')),
      );
      expect(weight('0'), isNotNull);
      expect(weight('1.0001'), isNotNull);
      expect(weight('1,125'), isNull);
      expect(
        tester
            .widget<TextField>(
              find.descendant(
                of: find.byKey(const ValueKey('harvest-field-remaining')),
                matching: find.byType(TextField),
              ),
            )
            .readOnly,
        isFalse,
      );
      await tester.enterText(
        find.byKey(const ValueKey('harvest-field-count')),
        '10000',
      );
      await tester.pumpAndSettle();
      expect(remaining.controller!.text, '90000');
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
        '120000',
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
        '120000',
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
        'price': '120000',
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
        tester
            .widget<TextFormField>(
              find.byKey(const ValueKey('harvest-field-remaining')),
            )
            .controller!
            .text,
        isEmpty,
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
        expect(repo.bodies.single, containsPair('estimatedRemainingCount', 0));
        expect(find.text('Danh sách thu hoạch'), findsOneWidget);
        if (warning != null) {
          expect(find.text(warning), findsOneWidget);
          expect(find.text('Đã ghi nhận thu hoạch thành công.'), findsNothing);
        } else {
          expect(
            find.text('Đã ghi nhận thu hoạch thành công.'),
            findsOneWidget,
          );
        }
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
      expect(repo.bodies.single['estimatedRemainingCount'], 700);
      expect(find.text(message), findsOneWidget);
      expect(find.byType(HarvestFormPage), findsOneWidget);
      expect(find.text('Đã ghi nhận thu hoạch thành công.'), findsNothing);
      final field = tester.widget<TextFormField>(
        find.byKey(const ValueKey('harvest-field-weight')),
      );
      expect(field.controller!.text, '10');
      expect(
        await SecureHarvestSubmissionStore(
          const FlutterSecureStorage(),
        ).read('owner', 'season-1'),
        isNull,
      );
      expect(tester.takeException(), isNull);
    });
  }

  for (final manual in [false, true]) {
    testWidgets('backdated partial uses historical capacity; manual=$manual', (
      tester,
    ) async {
      final historical = Completer<HarvestPage>();
      final repo = _HarvestRepo()
        ..result = page().copyWith(availableQuantityCount: '900')
        ..populationLoad = (_) => historical.future;
      await mount(tester, repo, route: '/harvests/create');
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const ValueKey('harvest-field-weight')),
        '10',
      );
      await tester.enterText(
        find.byKey(const ValueKey('harvest-field-count')),
        '100',
      );
      if (manual) {
        await tester.enterText(
          find.byKey(const ValueKey('harvest-field-remaining')),
          '850',
        );
      }
      FocusManager.instance.primaryFocus?.unfocus();
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Chọn ngày và giờ...'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Chọn ngày và giờ...'));
      await tester.pumpAndSettle();
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      tester
          .widget<CalendarDatePicker>(find.byType(CalendarDatePicker))
          .onDateChanged(yesterday);
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      expect(repo.queries.last, contains('populationAt'));
      await tester.ensureVisible(find.text('Ghi nhận thu tỉa'));
      await tester.pump();
      final button = find.ancestor(
        of: find.text('Ghi nhận thu tỉa'),
        matching: find.byType(GradientButton),
      );
      expect(tester.widget<GradientButton>(button).onPressed, isNull);
      historical.complete(page().copyWith(availableQuantityCount: '1000'));
      await tester.pumpAndSettle();
      final field = tester.widget<TextFormField>(
        find.byKey(const ValueKey('harvest-field-remaining')),
      );
      expect(field.controller!.text, manual ? '850' : '900');
      final requested = DateTime.parse(
        repo.queries.last['populationAt'] as String,
      ).toLocal();
      expect(
        (requested.year, requested.month, requested.day),
        (yesterday.year, yesterday.month, yesterday.day),
      );
      await tester.ensureVisible(find.text('Ghi nhận thu tỉa'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Ghi nhận thu tỉa'));
      await tester.pumpAndSettle();
      expect(find.text('Xác nhận thu tỉa'), findsOneWidget);
      await tester.tap(find.text('Xác nhận'));
      await tester.pumpAndSettle();
      expect(repo.bodies.single['estimatedRemainingCount'], manual ? 850 : 900);
      expect(repo.bodies.single.containsKey('varianceReason'), isFalse);
      expect(tester.takeException(), isNull);
    });
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
    await tester.enterText(
      find.byKey(const ValueKey('harvest-field-weight')),
      '10',
    );
    await tester.enterText(
      find.byKey(const ValueKey('harvest-field-count')),
      '200',
    );
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<TextFormField>(
            find.byKey(const ValueKey('harvest-field-remaining')),
          )
          .controller!
          .text,
      '450',
    );
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
    expect(repo.bodies.single['estimatedRemainingCount'], 450);
    expect(find.text('Danh sách thu hoạch'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  for (final (invalidCount, capacity) in [
    ('', '200000'),
    ('200000', '200000'),
    ('200001', '200000'),
    ('1', '9007199254740993'),
  ]) {
    testWidgets(
      'invalid partial count "$invalidCount" marks both fields and opens one modal',
      (tester) async {
        final repo = _HarvestRepo()
          ..result = page().copyWith(availableQuantityCount: capacity);
        await mount(tester, repo, route: '/harvests/create');
        await tester.pumpAndSettle();
        await tester.enterText(
          find.byKey(const ValueKey('harvest-field-weight')),
          '10',
        );
        if (invalidCount.isNotEmpty) {
          await tester.enterText(
            find.byKey(const ValueKey('harvest-field-count')),
            invalidCount,
          );
        }
        expect(find.text('Số lượng thu hoạch chưa hợp lệ'), findsNothing);
        await tester.ensureVisible(find.text('Ghi nhận thu tỉa'));
        await tester.pumpAndSettle();
        FocusManager.instance.primaryFocus?.unfocus();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Ghi nhận thu tỉa'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Ghi nhận thu tỉa'));
        await tester.pumpAndSettle();
        expect(find.text('Số lượng thu hoạch chưa hợp lệ'), findsOneWidget);
        expect(repo.keys, isEmpty);
        for (final field in ['count', 'remaining']) {
          expect(
            tester
                .widget<TextFormField>(
                  find.byKey(ValueKey('harvest-field-$field')),
                )
                .forceErrorText,
            isNotNull,
          );
        }
        if (invalidCount == '200000') {
          await capture(tester, 'strict-partial-modal');
        }
        await tester.tap(find.text('Kiểm tra lại'));
        await tester.pumpAndSettle();
        await tester.ensureVisible(
          find.byKey(const ValueKey('harvest-field-count')),
        );
        await tester.pumpAndSettle();
        if (invalidCount == '200000') {
          await capture(tester, 'strict-partial-fields');
        }
        await tester.enterText(
          find.byKey(const ValueKey('harvest-field-count')),
          '100000',
        );
        await tester.pumpAndSettle();
        expect(
          tester
              .widget<TextFormField>(
                find.byKey(const ValueKey('harvest-field-remaining')),
              )
              .controller!
              .text,
          (BigInt.parse(capacity) - BigInt.from(100000)).toString(),
        );
        for (final field in ['count', 'remaining']) {
          expect(
            tester
                .widget<TextFormField>(
                  find.byKey(ValueKey('harvest-field-$field')),
                )
                .forceErrorText,
            isNull,
          );
        }
        expect(find.text('Số lượng thu hoạch chưa hợp lệ'), findsNothing);
        expect(repo.keys, isEmpty);
      },
    );
  }

  testWidgets(
    'population rejection refreshes capacity, marks both fields and requires a fresh confirmation',
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
      await tester.enterText(
        find.byKey(const ValueKey('harvest-field-weight')),
        '10',
      );
      await tester.enterText(
        find.byKey(const ValueKey('harvest-field-count')),
        '100000',
      );
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
      await tester.tap(find.text('Xác nhận'));
      await tester.pumpAndSettle();
      expect(repo.keys, hasLength(1));
      expect(find.text('Số lượng thu hoạch chưa hợp lệ'), findsOneWidget);
      for (final field in ['count', 'remaining']) {
        expect(
          tester
              .widget<TextFormField>(
                find.byKey(ValueKey('harvest-field-$field')),
              )
              .forceErrorText,
          message,
        );
      }
      await tester.tap(find.text('Kiểm tra lại'));
      await tester.pumpAndSettle();
      expect(find.textContaining('trong ao: 190000 con'), findsOneWidget);
      expect(
        tester
            .widget<TextFormField>(
              find.byKey(const ValueKey('harvest-field-remaining')),
            )
            .controller!
            .text,
        '90000',
      );
      expect(repo.keys, hasLength(1));
      await tester.enterText(
        find.byKey(const ValueKey('harvest-field-count')),
        '90000',
      );
      await tester.pumpAndSettle();
      repo.recordError = null;
      await tester.ensureVisible(find.text('Ghi nhận thu tỉa'));
      await tester.pumpAndSettle();
      FocusManager.instance.primaryFocus?.unfocus();
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Ghi nhận thu tỉa'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Ghi nhận thu tỉa'));
      await tester.pumpAndSettle();
      expect(find.text('Xác nhận thu tỉa'), findsOneWidget);
      expect(repo.keys, hasLength(1));
      await tester.tap(find.text('Xác nhận'));
      await tester.pumpAndSettle();
      expect(repo.bodies.last['quantityCount'], 90000);
      expect(repo.bodies.last['estimatedRemainingCount'], 100000);
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

  for (final capacity in ['500000', null]) {
    testWidgets(
      'partial records actual 600000 and preserves manual remaining; estimate=$capacity',
      (tester) async {
        final repo = _HarvestRepo()
          ..result = page().copyWith(availableQuantityCount: capacity);
        await mount(tester, repo, route: '/harvests/create');
        await tester.pumpAndSettle();
        await tester.enterText(
          find.byKey(const ValueKey('harvest-field-weight')),
          '10000',
        );
        await tester.enterText(
          find.byKey(const ValueKey('harvest-field-count')),
          '600000',
        );
        await tester.enterText(
          find.byKey(const ValueKey('harvest-field-remaining')),
          '10000',
        );
        await tester.enterText(
          find.byKey(const ValueKey('harvest-field-variance')),
          'Sai số chài mẫu',
        );
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
        await tester.tap(find.text('Ghi nhận thu tỉa'));
        await tester.pumpAndSettle();
        expect(find.text('Xác nhận thu tỉa'), findsOneWidget);
        expect(
          find.textContaining('Lý do hiệu chỉnh: Sai số chài mẫu'),
          findsOneWidget,
        );
        await tester.tap(find.text('Xác nhận'));
        await tester.pumpAndSettle();
        expect(repo.bodies.single['quantityCount'], 600000);
        expect(repo.bodies.single['estimatedRemainingCount'], 10000);
        expect(repo.bodies.single['varianceReason'], 'Sai số chài mẫu');
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets(
    'final count above estimate is accepted with a correction reason',
    (tester) async {
      final repo = _HarvestRepo();
      await mount(tester, repo, route: '/harvests/create');
      await tester.pumpAndSettle();
      await tester.tap(find.text('Thu hoạch cuối'));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const ValueKey('harvest-field-weight')),
        '10',
      );
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const ValueKey('harvest-field-count')),
        '100001',
      );
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
      await tester.ensureVisible(find.text('Ghi nhận thu hoạch cuối'));
      FocusManager.instance.primaryFocus?.unfocus();
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Ghi nhận thu hoạch cuối'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Ghi nhận thu hoạch cuối'));
      await tester.pumpAndSettle();
      expect(find.text('Số lượng thu hoạch chưa hợp lệ'), findsOneWidget);
      expect(find.textContaining('vượt ước tính'), findsWidgets);
      expect(find.text('Xác nhận thu hoạch cuối'), findsNothing);
      expect(repo.keys, isEmpty);
      await tester.tap(find.text('Kiểm tra lại'));
      await tester.pumpAndSettle();
      await tester.ensureVisible(
        find.byKey(const ValueKey('harvest-field-variance')),
      );
      await tester.enterText(
        find.byKey(const ValueKey('harvest-field-variance')),
        'Sai số ước tính',
      );
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
      await tester.tap(find.text('Xác nhận'));
      await tester.pumpAndSettle();
      expect(repo.bodies.single['quantityCount'], 100001);
      expect(repo.bodies.single['varianceReason'], 'Sai số ước tính');
    },
  );

  testWidgets(
    'confirmed pending time rejection restores facts and permits a corrected submission',
    (tester) async {
      const key = '11111111-1111-4111-8111-111111111111';
      final body = {
        ...submissionBody(),
        'quantityCount': 100,
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
        'weight': '620.0',
        'count': '100',
        'remaining': '700',
        'price': '120000',
        'buyer': 'Buyer',
        'contact': '0901234567',
        'note': 'Original note',
        'variance': 'Original correction',
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
        'estimatedRemainingCount',
        'pricePerKg',
        'buyerName',
        'buyerContact',
        'note',
        'varianceReason',
      ]) {
        expect(repo.bodies.last[field], body[field]);
      }
    },
  );

  for (final entry in {'variance': 500, 'buyer': 255, 'contact': 255}.entries) {
    testWidgets(
      '${entry.key} rejects overlength Unicode without truncating and accepts the trimmed boundary',
      (tester) async {
        final repo = _HarvestRepo();
        await mount(tester, repo, route: '/harvests/create');
        await tester.pumpAndSettle();
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
      HarvestEvent.fromJson(eventJson());
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
