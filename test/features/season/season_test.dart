import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/season/domain/entities/aquaculture_season.dart';
import 'package:smartshrimp_app/features/season/domain/season_rules.dart';

void main() {
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
