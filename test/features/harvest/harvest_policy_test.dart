import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/errors/error_mapper.dart';
import 'package:smartshrimp_app/features/harvest/domain/harvest_policy.dart';
import 'package:smartshrimp_app/features/pond/domain/entities/pond.dart';
import 'package:smartshrimp_app/features/season/domain/entities/aquaculture_season.dart';

AquacultureSeason seasonFor(ShrimpType species) => AquacultureSeason(
  id: 'season',
  pondId: 'pond',
  name: 'Vụ nuôi',
  shrimpType: species,
  status: SeasonStatus.active,
  createdBy: 'owner',
  createdAt: DateTime.utc(2026),
  updatedAt: DateTime.utc(2026),
  stockingDate: DateTime.utc(2026, 1, 1),
  pond: const Pond(
    id: 'pond',
    farmId: 'farm',
    name: 'Ao 1',
    type: PondType.aquaculture,
    status: PondStatus.available,
  ),
);

void main() {
  test(
    'only the exact terminal time code with HTTP 400 confirms rejection',
    () {
      for (final status in [null, 400, 401, 403, 404, 409, 422, 429, 500]) {
        expect(
          isConfirmedHarvestTimeRejection(
            ApiException(
              'rejected',
              statusCode: status,
              details: {'code': harvestTimeNotAfterLatestCode},
            ),
          ),
          status == 400,
        );
      }
      expect(
        isConfirmedHarvestTimeRejection(
          const ApiException('rejected', statusCode: 400),
        ),
        isFalse,
      );
      expect(
        isConfirmedHarvestTimeRejection(
          const ApiException(
            'rejected',
            statusCode: 400,
            details: {'code': 'OTHER'},
          ),
        ),
        isFalse,
      );
      expect(
        isConfirmedHarvestTimeRejection(const NetworkException()),
        isFalse,
      );
    },
  );

  test('real error mapping preserves the BE terminal code', () {
    final request = RequestOptions(path: '/owner/seasons/id/harvests');
    final error = ErrorMapper.fromDio(
      DioException(
        requestOptions: request,
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: request,
          statusCode: 400,
          data: {
            'success': false,
            'statusCode': 400,
            'message': 'Invalid time',
            'errorCode': harvestTimeNotAfterLatestCode,
          },
        ),
      ),
    );
    expect(isConfirmedHarvestTimeRejection(error), isTrue);
  });

  test('notes trim and enforce the same UTF-16 boundary as BE', () {
    expect(validateHarvestNote(null), isNull);
    expect(validateHarvestNote(''), isNull);
    expect(validateHarvestNote(' ${'x' * 500} '), isNull);
    expect(validateHarvestNote('x' * 501), isNotNull);
    expect(validateHarvestNote('😀' * 250), isNull);
    expect(validateHarvestNote('😀' * 251), isNotNull);
  });

  for (final limit in [255, 500]) {
    test('optional text uses trimmed UTF-16 boundaries at $limit', () {
      String? validate(String? value) =>
          validateHarvestTextLength(value, label: 'Text', maxLength: limit);
      expect(validate(null), isNull);
      expect(validate('   '), isNull);
      expect(validate('x' * (limit - 1)), isNull);
      expect(validate(' ${'x' * limit} '), isNull);
      expect(validate('x' * (limit + 1)), isNotNull);
      for (final grapheme in ['😀', 'e\u0301']) {
        final boundary = grapheme * (limit ~/ 2) + 'x' * (limit % 2);
        expect(validate(' $boundary '), isNull);
        expect(validate('${boundary}x'), contains('$limit'));
      }
    });
  }

  for (final entry in {
    ShrimpType.whiteleg: 90,
    ShrimpType.blackTiger: 120,
  }.entries) {
    test('${entry.key} warns until the Vietnam midnight age boundary', () {
      final season = seasonFor(entry.key);
      final boundary = season.stockingDate!
          .add(Duration(days: entry.value))
          .subtract(const Duration(hours: 7));
      expect(
        earlyHarvestWarning(
          season,
          boundary.subtract(const Duration(seconds: 1)),
        ),
        contains('${entry.value} ngày'),
      );
      expect(earlyHarvestWarning(season, boundary), isNull);
      expect(
        earlyHarvestWarning(season, boundary.add(const Duration(days: 1))),
        isNull,
      );
    });
  }

  test('calendar validation uses Vietnam rather than UTC or device dates', () {
    final stocking = DateTime.utc(2026, 1, 1);
    final now = DateTime.utc(2026, 2, 1);
    expect(
      validateHarvestTime(
        DateTime.parse('2025-12-31T16:59:59Z'),
        stocking,
        now: now,
      ),
      contains('trước ngày thả'),
    );
    expect(
      validateHarvestTime(
        DateTime.parse('2025-12-31T17:00:00Z'),
        stocking,
        now: now,
      ),
      isNull,
    );
    expect(
      validateHarvestTime(
        DateTime.parse('2026-01-01T00:00:00+07:00'),
        stocking,
        now: now,
      ),
      isNull,
    );
  });

  test('missing and future times remain hard validation errors', () {
    final now = DateTime.utc(2026, 1, 2);
    expect(validateHarvestTime(null, null, now: now), isNotNull);
    expect(
      validateHarvestTime(now.add(const Duration(seconds: 1)), null, now: now),
      contains('tương lai'),
    );
  });

  test('early age is advisory while invalid dates do not produce advice', () {
    final season = seasonFor(ShrimpType.whiteleg);
    final early = DateTime.utc(2026, 1, 2);
    expect(earlyHarvestWarning(season, early), contains('vẫn có thể ghi nhận'));
    expect(validateHarvestTime(early, season.stockingDate, now: early), isNull);
    expect(earlyHarvestWarning(season, DateTime.utc(2025)), isNull);
    expect(earlyHarvestWarning(season, null), isNull);
    expect(
      earlyHarvestWarning(season.copyWith(stockingDate: null), early),
      isNull,
    );
    expect(
      earlyHarvestWarning(
        season.copyWith(shrimpType: ShrimpType.unknown),
        early,
      ),
      isNull,
    );
  });
}
