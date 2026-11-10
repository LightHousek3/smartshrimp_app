import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/season/domain/entities/aquaculture_season.dart';
import 'package:smartshrimp_app/features/water_log/domain/entities/water_log.dart';
import 'package:smartshrimp_app/features/water_log/domain/entities/water_log_metadata.dart';
import 'package:smartshrimp_app/features/water_log/domain/repositories/water_log_repository.dart';
import 'package:smartshrimp_app/features/water_log/presentation/view_models/water_log_controller.dart';
import 'water_statistics_fixtures.dart';

class _Repository implements WaterLogRepository {
  AppException? error;
  int metadataCalls = 0, statisticsCalls = 0;
  bool recoverAfterFirst = false;
  @override
  Future<WaterLogMetadata> getMetadata({required String seasonId}) async {
    metadataCalls++;
    if (error != null && !(recoverAfterFirst && metadataCalls > 1)) {
      throw error!;
    }
    return WaterLogMetadata.legacy(ShrimpType.whiteleg);
  }

  @override
  Future<WaterLogStatistics> getStatistics({
    required String seasonId,
    DateTime? from,
    required DateTime to,
    required String granularity,
  }) async {
    statisticsCalls++;
    if (error != null && !(recoverAfterFirst && statisticsCalls > 1)) {
      throw error!;
    }
    return sampleStatistics();
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  for (final statistics in [false, true]) {
    testWidgets(
      '${statistics ? 'statistics' : 'metadata'} does not retry 403, explicit retry recovers',
      (tester) async {
        const denied = ApiException(
          'Không có quyền xem dữ liệu vụ nuôi.',
          statusCode: 403,
        );
        final repository = _Repository()..error = denied;
        final container = ProviderContainer(
          overrides: [waterLogRepositoryProvider.overrideWithValue(repository)],
        );
        final provider = statistics
            ? waterLogStatisticsProvider((
                seasonId: 'season',
                days: null,
                granularity: 'day',
              ))
            : waterLogMetadataProvider('season');
        final sub = container.listen(provider, (_, _) {});
        try {
          await tester.pump();
          await tester.pump(const Duration(seconds: 2));
          expect(container.read(provider).error, same(denied));
          expect(repository.metadataCalls + repository.statisticsCalls, 1);
          repository.error = null;
          if (statistics) {
            final target = waterLogStatisticsProvider((
              seasonId: 'season',
              days: null,
              granularity: 'day',
            ));
            container.invalidate(target);
            await container.read(target.future);
          } else {
            container.invalidate(waterLogMetadataProvider('season'));
            await container.read(waterLogMetadataProvider('season').future);
          }
          expect(repository.metadataCalls + repository.statisticsCalls, 2);
        } finally {
          sub.close();
          container.dispose();
          await tester.pump();
        }
      },
    );
    testWidgets(
      '${statistics ? 'statistics' : 'metadata'} retries transient network errors',
      (tester) async {
        final repository = _Repository()
          ..error = const NetworkException()
          ..recoverAfterFirst = true;
        final container = ProviderContainer(
          overrides: [waterLogRepositoryProvider.overrideWithValue(repository)],
        );
        final provider = statistics
            ? waterLogStatisticsProvider((
                seasonId: 'season',
                days: null,
                granularity: 'day',
              ))
            : waterLogMetadataProvider('season');
        final sub = container.listen(provider, (_, _) {});
        try {
          await tester.pump();
          await tester.pump(const Duration(milliseconds: 250));
          await tester.pump();
          expect(repository.metadataCalls + repository.statisticsCalls, 2);
          expect(container.read(provider).hasValue, isTrue);
        } finally {
          sub.close();
          container.dispose();
          await tester.pump();
        }
      },
    );
  }
}
