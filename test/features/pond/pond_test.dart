import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/pond/domain/entities/pond.dart';
import 'package:smartshrimp_app/features/pond/domain/pond_rules.dart';

void main() {
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
      'deletedAt': null,
      'farm': <String, dynamic>{'id': 'farm-1', 'name': 'Trại Cà Mau'},
      'currentSeason': <String, dynamic>{
        'id': 'season-1',
        'status': 'ACTIVE',
        'stockingDate': '2026-09-01T00:00:00.000Z',
      },
    });

    expect(pond.type, PondType.aquaculture);
    expect(pond.status, PondStatus.available);
    expect(pond.farm?.name, 'Trại Cà Mau');
    expect(pond.hasOpenSeason, isTrue);
    expect(pond.isDeleted, isFalse);
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
  });
}
