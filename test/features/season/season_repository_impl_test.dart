import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/features/pond/domain/entities/pond.dart';
import 'package:smartshrimp_app/features/season/data/repositories/season_repository_impl.dart';
import 'package:smartshrimp_app/features/season/data/services/season_api_service.dart';
import 'package:smartshrimp_app/features/season/domain/entities/aquaculture_season.dart';

void main() {
  late _FakeSeasonRemoteDataSource remote;
  late SeasonRepositoryImpl repository;

  setUp(() {
    remote = _FakeSeasonRemoteDataSource();
    repository = SeasonRepositoryImpl(remote);
  });

  test(
    'normalizes create payload using backend enum and date formats',
    () async {
      await repository.createSeason(
        pondId: 'pond-1',
        name: '  Vụ   tháng 9 ',
        shrimpType: ShrimpType.whiteleg,
        stockingDate: DateTime(2026, 9, 25),
        expectedEndDate: DateTime(2027, 1, 20),
        initialQuantity: 100000,
        initialAvgWeightG: 0.02,
      );

      expect(remote.lastData, <String, dynamic>{
        'pondId': 'pond-1',
        'name': 'Vụ tháng 9',
        'shrimpType': 'WHITELEG',
        'stockingDate': '2026-09-25',
        'expectedEndDate': '2027-01-20',
        'initialQuantity': 100000,
        'initialAvgWeightG': 0.02,
      });
    },
  );

  test(
    'sends optimistic concurrency token for update and status actions',
    () async {
      await repository.updateSeason(
        current: _season,
        name: 'Tên mới',
        shrimpType: ShrimpType.blackTiger,
      );
      expect(remote.lastData?['expectedUpdatedAt'], '2026-09-22T02:00:00.000Z');

      await repository.activateSeason(_season);
      expect(remote.lastData, <String, dynamic>{
        'expectedUpdatedAt': '2026-09-22T02:00:00.000Z',
      });

      await repository.cancelSeason(current: _season, reason: '  Nước   xấu ');
      expect(remote.lastData, <String, dynamic>{
        'reason': 'Nước xấu',
        'expectedUpdatedAt': '2026-09-22T02:00:00.000Z',
      });
    },
  );
}

const _pond = Pond(
  id: 'pond-1',
  farmId: 'farm-1',
  name: 'Ao A1',
  type: PondType.aquaculture,
  status: PondStatus.available,
);

final _season = AquacultureSeason(
  id: 'season-1',
  pondId: 'pond-1',
  name: 'Vụ tháng 9',
  shrimpType: ShrimpType.whiteleg,
  status: SeasonStatus.planning,
  createdBy: 'owner-1',
  createdAt: DateTime.utc(2026, 9, 22, 1),
  updatedAt: DateTime.utc(2026, 9, 22, 2),
  pond: _pond,
);

final class _FakeSeasonRemoteDataSource implements SeasonRemoteDataSource {
  Map<String, dynamic>? lastData;

  @override
  Future<AquacultureSeason> activateSeason(
    String seasonId,
    Map<String, dynamic> data,
  ) async {
    lastData = data;
    return _season;
  }

  @override
  Future<SeasonAssignment> assignPersonnel(
    String seasonId,
    Map<String, dynamic> data,
  ) => throw UnimplementedError();

  @override
  Future<SeasonCancellationResult> cancelSeason(
    String seasonId,
    Map<String, dynamic> data,
  ) async {
    lastData = data;
    return SeasonCancellationResult(season: _season, cancelledScheduleCount: 0);
  }

  @override
  Future<AquacultureSeason> createSeason(Map<String, dynamic> data) async {
    lastData = data;
    return _season;
  }

  @override
  Future<AquacultureSeason> getSeason(String seasonId) async => _season;

  @override
  Future<SeasonPage> getSeasons(Map<String, dynamic> query) async =>
      const SeasonPage(
        items: <AquacultureSeason>[],
        limit: 20,
        totalResults: 0,
        hasNextPage: false,
      );

  @override
  Future<SeasonPersonnelReplacementResult> replacePersonnel(
    String seasonId,
    String role,
    Map<String, dynamic> data,
  ) => throw UnimplementedError();

  @override
  Future<AquacultureSeason> updateSeason(
    String seasonId,
    Map<String, dynamic> data,
  ) async {
    lastData = data;
    return _season;
  }
}
