import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:smartshrimp_app/core/network/api_client.dart';
import 'package:smartshrimp_app/core/storage/session_store.dart';
import 'package:smartshrimp_app/features/season/data/services/season_api_service.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/season/domain/entities/aquaculture_season.dart';
import 'package:smartshrimp_app/features/season/domain/season_rules.dart';

void main() {
  test('parses additive costs without changing legacy season data', () {
    final legacy = AquacultureSeason.fromJson(_seasonJson());
    final updated = AquacultureSeason.fromJson(
      _seasonJson()..['materialCosts'] = _costsJson(),
    );
    expect(updated.copyWith(materialCosts: null), legacy);
    expect(legacy.materialCosts, isNull);
    expect(
      AquacultureSeason.fromJson(
        _seasonJson()..['materialCosts'] = null,
      ).materialCosts,
      isNull,
    );
    expect(updated.materialCosts!.total, '2000000.00');
    expect(
      updated.materialCosts!.proportion(updated.materialCosts!.feed),
      0.75,
    );
  });

  test('parses estimatedFcr when present and defaults to null when omitted', () {
    final omitted = AquacultureSeason.fromJson(_seasonJson());
    final withNull = AquacultureSeason.fromJson(
      _seasonJson()..['estimatedFcr'] = null,
    );
    final withValue = AquacultureSeason.fromJson(
      _seasonJson()..['estimatedFcr'] = 1.35,
    );

    expect(omitted.estimatedFcr, isNull);
    expect(withNull.estimatedFcr, isNull);
    expect(withValue.estimatedFcr, 1.35);
    expect(withValue.copyWith(estimatedFcr: null), omitted);
  });

  test('keeps large money exact and handles an empty total', () {
    final json = _costsJson()
      ..addAll({
        'feed': '9007199254740993.01',
        'medicine': '0.02',
        'environment': '0.03',
        'total': '9007199254740993.06',
      });
    final costs = SeasonMaterialCosts.fromJson(json);
    expect(
      SeasonMaterialCosts.minorUnits(costs.total),
      BigInt.parse('900719925474099306'),
    );
    final zero = SeasonMaterialCosts.fromJson(
      _costsJson()
        ..updateAll((key, value) => key == 'currency' ? value : '0.00'),
    );
    expect(zero.proportion(zero.feed), 0);
  });

  test('rejects invalid costs rather than displaying misleading zeros', () {
    for (final value in [123, [], 'costs']) {
      expect(
        () => AquacultureSeason.fromJson(
          _seasonJson()..['materialCosts'] = value,
        ),
        throwsA(isA<InvalidResponseException>()),
      );
    }
    for (final value in [
      null,
      10,
      '-1.00',
      'NaN',
      'Infinity',
      '1.234',
      '01.00',
      '1e3',
      '1',
      '1.00\n',
    ]) {
      expect(
        () => SeasonMaterialCosts.fromJson(_costsJson()..['feed'] = value),
        throwsA(isA<InvalidResponseException>()),
      );
    }
    expect(
      () => SeasonMaterialCosts.fromJson(_costsJson()..['currency'] = 'USD'),
      throwsA(isA<InvalidResponseException>()),
    );
    expect(
      () => SeasonMaterialCosts.fromJson(_costsJson()..['total'] = '0.00'),
      throwsA(isA<InvalidResponseException>()),
    );
  });

  test(
    'old and new detail responses use exactly one existing authenticated GET',
    () async {
      for (final hasCosts in [false, true]) {
        final requests = <RequestOptions>[];
        final dio = Dio(BaseOptions(baseUrl: 'https://api.smartshrimp.test'));
        addTearDown(dio.close);
        dio.interceptors.add(
          InterceptorsWrapper(
            onRequest: (request, handler) {
              requests.add(request);
              final data = _seasonJson();
              if (hasCosts) data['materialCosts'] = _costsJson();
              handler.resolve(
                Response(
                  requestOptions: request,
                  statusCode: 200,
                  data: {'success': true, 'message': 'Success', 'data': data},
                ),
              );
            },
          ),
        );
        final result = await SeasonApiService(
          ApiClient(dio, _SessionStore()),
        ).getSeason('season-1');
        expect(requests, hasLength(1));
        expect(requests.single.method, 'GET');
        expect(requests.single.path, '/owner/seasons/season-1');
        expect(requests.single.headers['Authorization'], 'Bearer access-token');
        expect(requests.single.queryParameters, isEmpty);
        expect(requests.single.data, isNull);
        expect(result.materialCosts != null, hasCosts);
      }
    },
  );

  test('parses list and detail fields returned by the season API', () {
    final season = AquacultureSeason.fromJson(_seasonJson());

    expect(season.name, 'Vụ tôm tháng 9');
    expect(season.status, SeasonStatus.planning);
    expect(season.shrimpType, ShrimpType.whiteleg);
    expect(season.initialQuantity, 100000);
    expect(season.initialDensityPerM2, 20);
    expect(season.pond.name, 'Ao A1');
    expect(season.personnel?.technician?.account.fullName, 'Kỹ thuật viên A');
    expect(season.personnel?.expert, isNull);
    expect(season.activationEligibility?.canActivate, isFalse);
    expect(
      season.activationEligibility?.missingConditions,
      contains('ACTIVE_EXPERT_REQUIRED'),
    );
    expect(season.canUpdate, isTrue);
    expect(season.canActivate, isFalse);
    expect(season.canCancel, isTrue);
  });

  test('rejects malformed required API fields', () {
    final json = _seasonJson()..['createdAt'] = 1;

    expect(
      () => AquacultureSeason.fromJson(json),
      throwsA(isA<InvalidResponseException>()),
    );
  });

  test('keeps former personnel visible for a cancelled season', () {
    final json = _seasonJson();
    final formerPersonnel = json['personnel']! as Map<String, dynamic>;
    final technician = formerPersonnel['technician']! as Map<String, dynamic>;
    technician['unassignedAt'] = '2026-09-29T03:00:00.000Z';
    json
      ..['status'] = 'CANCELLED'
      ..['personnel'] = <String, dynamic>{'technician': null, 'expert': null}
      ..['lastAssignedPersonnel'] = formerPersonnel;

    final season = AquacultureSeason.fromJson(json);

    expect(season.personnel?.technician, isNull);
    expect(
      season.personnelForDisplay?.technician?.account.fullName,
      isNotEmpty,
    );
    expect(
      season.personnelForDisplay?.technician?.unassignedAt,
      DateTime.parse('2026-09-29T03:00:00.000Z'),
    );
  });

  test('validates season form values and date ordering', () {
    expect(SeasonRules.validateName('   '), isNotNull);
    expect(SeasonRules.validateName('  Vụ   số 1 '), isNull);
    expect(SeasonRules.normalizeText('  Vụ   số 1 '), 'Vụ số 1');
    expect(SeasonRules.validateQuantity('100000'), isNull);
    expect(SeasonRules.validateQuantity('1.5'), isNotNull);
    expect(SeasonRules.calculateDensity(480000, 3200), 150);
    expect(SeasonRules.calculateDensity(480000, null), isNull);
    expect(
      SeasonRules.validateDateRange(
        DateTime(2026, 9, 20),
        DateTime(2026, 9, 19),
      ),
      isNotNull,
    );
    expect(
      SeasonRules.validateDateRange(
        DateTime(2026, 9, 20),
        DateTime(2026, 9, 20),
      ),
      isNull,
    );
    expect(SeasonRules.validateCancellationReason('  '), isNotNull);
  });
}

Map<String, dynamic> _seasonJson() => <String, dynamic>{
  'id': 'season-1',
  'pondId': 'pond-1',
  'name': 'Vụ tôm tháng 9',
  'shrimpType': 'WHITELEG',
  'stockingDate': '2026-09-25',
  'expectedEndDate': '2027-01-20',
  'actualEndDate': null,
  'initialQuantity': '100000',
  'initialDensityPerM2': 20,
  'status': 'PLANNING',
  'cancellationReason': null,
  'createdBy': 'owner-1',
  'createdAt': '2026-09-22T01:00:00.000Z',
  'updatedAt': '2026-09-22T02:00:00.000Z',
  'dayOfCulture': null,
  'pond': <String, dynamic>{
    'id': 'pond-1',
    'farmId': 'farm-1',
    'name': 'Ao A1',
    'areaM2': 5000,
    'type': 'AQUACULTURE',
    'status': 'AVAILABLE',
    'archivedAt': null,
    'farm': <String, dynamic>{
      'id': 'farm-1',
      'name': 'Trại Cà Mau',
      'archivedAt': null,
    },
  },
  'personnel': <String, dynamic>{
    'technician': <String, dynamic>{
      'id': 'assignment-1',
      'role': 'TECHNICIAN',
      'assignedAt': '2026-09-22T01:00:00.000Z',
      'account': <String, dynamic>{
        'id': 'technician-1',
        'email': 'technician@smartshrimp.vn',
        'fullName': 'Kỹ thuật viên A',
        'phone': null,
        'status': 'ACTIVE',
      },
    },
    'expert': null,
  },
  'approvedProductionProtocol': null,
  'activationEligibility': <String, dynamic>{
    'canActivate': false,
    'missingConditions': <String>[
      'ACTIVE_EXPERT_REQUIRED',
      'APPROVED_PRODUCTION_PROTOCOL_REQUIRED',
    ],
  },
  'availableActions': <String, dynamic>{
    'update': true,
    'activate': false,
    'cancel': true,
  },
};

Map<String, dynamic> _costsJson() => {
  'currency': 'VND',
  'feed': '1500000.00',
  'medicine': '200000.00',
  'environment': '300000.00',
  'total': '2000000.00',
};

final class _SessionStore implements SessionStore {
  @override
  String? accessToken = 'access-token';
  @override
  String? refreshToken = 'refresh-token';
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
