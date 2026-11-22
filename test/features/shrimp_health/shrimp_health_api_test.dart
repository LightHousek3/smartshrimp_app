import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/core/di/core_providers.dart';
import 'package:smartshrimp_app/core/network/api_client.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/auth/domain/entities/auth_account.dart';
import 'package:smartshrimp_app/features/auth/presentation/view_models/auth_controller.dart';
import 'package:smartshrimp_app/features/shrimp_health/data/services/shrimp_health_api_service.dart';
import 'package:smartshrimp_app/features/shrimp_health/presentation/view_models/shrimp_health_controller.dart';

import '../home/owner_dashboard_fixtures.dart';
import '../task/task_api_test.dart' show TaskSessionStore;

void main() {
  ApiClient client(
    List<RequestOptions> requests, {
    Object? population = '105000',
  }) {
    final dio = Dio(BaseOptions(baseUrl: 'https://health.test'));
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (request, handler) {
          requests.add(request);
          final list =
              request.method == 'GET' &&
              request.path.endsWith('/shrimp-health-logs');
          handler.resolve(
            Response(
              requestOptions: request,
              statusCode: 200,
              data: {
                'success': true,
                'message': 'OK',
                'data': request.path.endsWith('/population')
                    ? {'availableQuantityCount': population}
                    : list
                    ? []
                    : {
                        'id': 'log',
                        'seasonId': 'season',
                        'recordedBy': 'account',
                        'recordedAt': '2026-11-01T00:00:00Z',
                        'createdAt': '2026-11-01T00:00:00Z',
                      },
                if (list) 'meta': {'hasNextPage': false},
              },
            ),
          );
        },
      ),
    );
    return ApiClient(dio, TaskSessionStore());
  }

  for (final population in ['105000', '0', null]) {
    test(
      'population preview preserves zero/null, scope, time and auth: $population',
      () async {
        final requests = <RequestOptions>[];
        final api = ShrimpHealthApiService(
          client(requests, population: population),
        );
        final at = DateTime.utc(2026, 11, 22, 2);
        expect(
          await api.getAvailablePopulation('season', at),
          population == null ? null : int.parse(population),
        );
        expect(
          requests.single.path,
          '/technician/seasons/season/shrimp-health-logs/population',
        );
        expect(requests.single.queryParameters, {'at': at.toIso8601String()});
        expect(requests.single.headers['Authorization'], 'Bearer access-token');
      },
    );
  }

  for (final population in [-1, '-1', '1.2', '9007199254740992', 'abc']) {
    test(
      'population preview rejects malformed/unsafe counts: $population',
      () async {
        final api = ShrimpHealthApiService(client([], population: population));
        await expectLater(
          api.getAvailablePopulation('season', DateTime.utc(2026, 11, 22)),
          throwsA(isA<InvalidResponseException>()),
        );
      },
    );
  }

  test(
    'technician health requests use new paths and preserve headers and payloads',
    () async {
      final requests = <RequestOptions>[];
      final api = ShrimpHealthApiService(client(requests));
      final from = DateTime.utc(2026, 11);
      final to = DateTime.utc(2026, 11, 20);
      await api.listLogs('season', filter: 'valid', cursor: 'next');
      await api.getLogDetail('season', 'log');
      await api.createLog(
        'season',
        recordedAt: from,
        avgWeightG: 10,
        idempotencyKey: 'request-1',
      );
      await api.voidLog('season', 'log', ' Incorrect entry ');
      await api.getStatistics('season', from: from, to: to);
      const base = '/technician/seasons/season/shrimp-health-logs';
      expect(requests.map((r) => '${r.method} ${r.path}'), [
        'GET $base',
        'GET $base/log',
        'POST $base',
        'PATCH $base/log/void',
        'GET $base/statistics',
      ]);
      expect(
        requests.map((r) => r.headers['Authorization']),
        everyElement('Bearer access-token'),
      );
      expect(requests.first.queryParameters, {
        'filter': 'valid',
        'cursor': 'next',
        'includeCounts': true,
      });
      expect(requests[2].headers['idempotency-key'], 'request-1');
      expect(requests[2].data, {
        'recordedAt': from.toIso8601String(),
        'avgWeightG': 10.0,
        'healthStatus': 'GOOD',
      });
      expect(requests[3].data, {'voidReason': 'Incorrect entry'});
      expect(requests.last.queryParameters, {
        'from': from.toIso8601String(),
        'to': to.toIso8601String(),
        'granularity': 'day',
      });
    },
  );

  for (final (role, prefix) in [
    (AccountRole.technician, '/technician'),
    (AccountRole.farmOwner, '/owner'),
    (AccountRole.expert, '/expert'),
  ]) {
    test('$role health provider selects $prefix scope', () async {
      final requests = <RequestOptions>[];
      final container = ProviderContainer(
        overrides: [
          apiClientProvider.overrideWithValue(client(requests)),
          authRepositoryProvider.overrideWithValue(
            DashboardFixtureAuth(role: role),
          ),
        ],
      );
      addTearDown(container.dispose);
      await container.read(authControllerProvider.future);
      await container.read(shrimpHealthRepositoryProvider).listLogs('season');
      expect(requests.single.path, '$prefix/seasons/season/shrimp-health-logs');
    });
  }
}
