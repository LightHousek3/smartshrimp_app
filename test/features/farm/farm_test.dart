import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/farm/domain/entities/farm.dart';
import 'package:smartshrimp_app/features/farm/domain/farm_rules.dart';

void main() {
  test('parses the complete farm detail projection safely', () {
    final farm = Farm.parse(<String, dynamic>{
      'id': 'farm-1',
      'ownerId': 'owner-1',
      'name': 'Trại Cà Mau',
      'address': 'Cà Mau',
      'totalAreaHectares': 3.5,
      'pondCount': 1,
      'activeSeasonCount': 1,
      'canDelete': false,
      'deletedAt': null,
      'ponds': <Object?>[
        <String, dynamic>{
          'id': 'pond-1',
          'name': 'Ao A1',
          'areaM2': 1200,
          'depthM': 1.5,
          'volumeM3': 1800,
          'type': 'AQUACULTURE',
          'status': 'AVAILABLE',
          'currentSeason': <String, dynamic>{
            'id': 'season-1',
            'status': 'ACTIVE',
            'stockingDate': '2026-07-01T00:00:00.000Z',
            'dayOfCulture': 72,
          },
        },
      ],
    });

    expect(farm.isDeleted, isFalse);
    expect(farm.canDelete, isFalse);
    expect(farm.ponds.single.type, PondType.aquaculture);
    expect(farm.ponds.single.status, PondStatus.available);
    expect(farm.ponds.single.currentSeason?.dayOfCulture, 72);
  });

  test('uses safe enum fallbacks for forward-compatible values', () {
    final farm = Farm.parse(<String, dynamic>{
      'id': 'farm-1',
      'ownerId': 'owner-1',
      'name': 'Trại mới',
      'ponds': <Object?>[
        <String, dynamic>{
          'id': 'pond-1',
          'name': 'Ao mới',
          'type': 'NEW_TYPE',
          'status': 'NEW_STATUS',
        },
      ],
    });

    expect(farm.ponds.single.type, PondType.unknown);
    expect(farm.ponds.single.status, PondStatus.unknown);
  });

  test('rejects malformed required fields at the parsing boundary', () {
    expect(
      () => Farm.parse(<String, dynamic>{
        'id': 1,
        'ownerId': 'owner-1',
        'name': 'Sai kiểu',
      }),
      throwsA(isA<InvalidResponseException>()),
    );
  });

  group('FarmRules', () {
    test('normalizes whitespace consistently with backend', () {
      expect(FarmRules.normalizeText('  Trại   Cà Mau  '), 'Trại Cà Mau');
    });

    test('accepts comma decimals and enforces two decimal places', () {
      expect(FarmRules.validateArea('3,50'), isNull);
      expect(FarmRules.parseArea('3,50'), 3.5);
      expect(FarmRules.validateArea('3.501'), isNotNull);
      expect(FarmRules.validateArea('0'), isNotNull);
    });
  });
}
