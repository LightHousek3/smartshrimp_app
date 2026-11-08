import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/farm/domain/entities/farm.dart'
    show FarmStatus;
import 'package:smartshrimp_app/features/pond/domain/entities/pond.dart';
import 'package:smartshrimp_app/features/pond/domain/pond_rules.dart';

void main() {
  test(
    'pond farm status parses known values and safely defaults to unknown',
    () {
      for (final entry in <String?, FarmStatus>{
        'ACTIVE': FarmStatus.active,
        'INACTIVE': FarmStatus.inactive,
        'FUTURE_STATUS': FarmStatus.unknown,
        null: FarmStatus.unknown,
      }.entries) {
        final farm = PondFarm.fromJson({
          'id': 'farm-1',
          'name': 'Farm',
          'status': entry.key,
        });
        expect(farm.status, entry.value);
        if (entry.value != FarmStatus.unknown) {
          expect(farm.toJson()['status'], entry.key);
        }
      }
      expect(
        PondFarm.fromJson({'id': 'farm-1', 'name': 'Farm'}).status,
        FarmStatus.unknown,
      );
    },
  );

  test(
    'autofill capacity uses backend rounding and validates the rounded result',
    () {
      expect(PondRules.calculateVolume(1000, 1.5), 1500);
      expect(PondRules.calculateVolume(1.23, 1.23), 1.51);
      expect(PondRules.validateVolumeCapacity(1.51, 1.23, 1.23), isNull);
      expect(PondRules.validateVolumeCapacity(1.52, 1.23, 1.23), isNotNull);
      expect(PondRules.calculateVolume(null, 1.5), isNull);
      expect(PondRules.calculateVolume(0, 1.5), isNull);
      expect(PondRules.calculateVolume(double.infinity, 1.5), isNull);
      expect(
        PondRules.calculateVolume(PondRules.maxAreaM2, PondRules.maxDepthM),
        isNull,
      );
    },
  );

  test(
    'round-trips both readiness states and treats removed INACTIVE as unknown',
    () {
      for (final entry in <String, PondStatus>{
        'AVAILABLE': PondStatus.available,
        'MAINTENANCE': PondStatus.maintenance,
        'INACTIVE': PondStatus.unknown,
      }.entries) {
        final pond = Pond.parse(<String, dynamic>{
          'id': 'pond-1',
          'farmId': 'farm-1',
          'name': 'Pond',
          'type': 'AQUACULTURE',
          'status': entry.key,
        });
        expect(pond.status, entry.value);
        if (entry.value != PondStatus.unknown) {
          expect(pond.toJson()['status'], entry.key);
        }
      }
    },
  );

  test('parses pond detail with farm and open season state', () {
    final pond = Pond.parse(<String, dynamic>{
      'id': 'pond-1',
      'farmId': 'farm-1',
      'name': 'Ao số 1',
      'areaM2': 1200,
      'depthM': 1.5,
      'volumeM3': 1800,
      'type': 'AQUACULTURE',
      'status': 'AVAILABLE',
      'farm': <String, dynamic>{'id': 'farm-1', 'name': 'Trại Cà Mau'},
      'currentSeason': <String, dynamic>{
        'id': 'season-1',
        'name': 'Vụ nuôi 09/2026',
        'status': 'ACTIVE',
        'stockingDate': '2026-09-01T00:00:00.000Z',
      },
    });

    expect(pond.type, PondType.aquaculture);
    expect(pond.status, PondStatus.available);
    expect(pond.currentSeason?.name, 'Vụ nuôi 09/2026');
    expect(pond.farm?.name, 'Trại Cà Mau');
    expect(pond.hasOpenSeason, isTrue);
  });

  test('uses safe enum fallbacks and rejects malformed required fields', () {
    final pond = Pond.parse(<String, dynamic>{
      'id': 'pond-1',
      'farmId': 'farm-1',
      'name': 'Ao mới',
      'type': 'FUTURE_TYPE',
      'status': 'FUTURE_STATUS',
    });
    expect(pond.type, PondType.unknown);
    expect(pond.status, PondStatus.unknown);
    expect(
      () => Pond.parse(<String, dynamic>{
        'id': 1,
        'farmId': 'farm-1',
        'name': 'Sai kiểu',
        'type': 'AQUACULTURE',
        'status': 'AVAILABLE',
      }),
      throwsA(isA<InvalidResponseException>()),
    );
  });

  test('normalizes names and validates positive decimals', () {
    expect(PondRules.normalizeName('  Ao   số 1 '), 'Ao số 1');
    expect(PondRules.validateName('   '), isNotNull);
    expect(
      PondRules.validateName(List<String>.filled(255, 'a').join()),
      isNull,
    );
    expect(
      PondRules.validateName(List<String>.filled(256, 'a').join()),
      isNotNull,
    );
    expect(PondRules.validatePositiveNumber('1,50', 'Độ sâu'), isNull);
    expect(PondRules.parseNumber('1,50'), 1.5);
    expect(PondRules.validatePositiveNumber('0', 'Độ sâu'), isNotNull);
    expect(PondRules.validatePositiveNumber('1.234', 'Độ sâu'), isNotNull);
    expect(
      PondRules.validatePositiveNumber('', 'Độ sâu', required: true),
      isNotNull,
    );
    expect(PondRules.validateArea('10000000000'), isNotNull);
    expect(PondRules.validateDepth('10000'), isNotNull);
    expect(
      PondRules.validateCalculatedVolume(
        PondRules.maxAreaM2,
        PondRules.maxDepthM,
      ),
      isNotNull,
    );
    expect(PondRules.validateCalculatedVolume(1200, 1.5), isNull);
    expect(PondRules.validateVolume(''), isNull);
    expect(PondRules.validateVolume('0'), isNotNull);
    expect(PondRules.validateVolumeCapacity(null, 1200, 1.5), isNull);
    expect(PondRules.validateVolumeCapacity(1700, 1200, 1.5), isNull);
    expect(PondRules.validateVolumeCapacity(1800.01, 1200, 1.5), isNotNull);
  });
}
