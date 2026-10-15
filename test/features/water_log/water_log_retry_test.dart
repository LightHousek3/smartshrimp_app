import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/season/domain/entities/aquaculture_season.dart';
import 'package:smartshrimp_app/features/water_log/domain/entities/water_log.dart';
import 'package:smartshrimp_app/features/water_log/domain/entities/water_log_metadata.dart';
import 'package:smartshrimp_app/features/water_log/domain/repositories/water_log_repository.dart';
import 'package:smartshrimp_app/features/water_log/presentation/view_models/water_log_controller.dart';
import 'package:smartshrimp_app/features/water_log/presentation/view_models/water_log_trend_provider.dart';

class _Repository implements WaterLogRepository {
  AppException? metadataError, listError;
  int metadataCalls = 0, listCalls = 0;
  bool recoverAfterFirst = false;
  @override
  Future<WaterLogMetadata> getMetadata({required String seasonId}) async {
    metadataCalls++;
    if (metadataError != null && !(recoverAfterFirst && metadataCalls > 1)) {
      throw metadataError!;
    }
    return WaterLogMetadata.legacy(ShrimpType.whiteleg);
  }

  @override
  Future<WaterLogPage> getWaterLogs({
    required String seasonId,
    DateTime? from,
    DateTime? to,
    bool includeVoided = false,
    WaterLogFilter? filter,
    bool includeCounts = false,
    int limit = 20,
    String? cursor,
  }) async {
    listCalls++;
    if (listError != null) throw listError!;
    return const WaterLogPage(items: [], totalResults: 0, hasNextPage: false);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  for (final scenario in ['metadata', 'trend metadata', 'trend list']) {
    testWidgets(
      '$scenario does not retry 403 with production defaults and explicit retry recovers',
      (tester) async {
        const denied = ApiException(
          'Không có quyền xem dữ liệu vụ nuôi.',
          statusCode: 403,
        );
        final repository = _Repository();
        if (scenario == 'trend list') {
          repository.listError = denied;
        } else {
          repository.metadataError = denied;
        }
        // No container-level retry override: exercise the production policy.
        final container = ProviderContainer(
          overrides: [waterLogRepositoryProvider.overrideWithValue(repository)],
        );
        if (scenario == 'metadata') {
          final provider = waterLogMetadataProvider('season');
          final sub = container.listen(provider, (_, _) {});
          try {
            await expectLater(
              container.read(provider.future),
              throwsA(same(denied)),
            );
            await tester.pump(const Duration(seconds: 2));
            expect(repository.metadataCalls, 1);
            expect(container.read(provider).error, same(denied));
            repository.metadataError = null;
            container.invalidate(provider);
            await container.read(provider.future);
            expect(repository.metadataCalls, 2);
          } finally {
            sub.close();
            container.dispose();
            await tester.pump();
          }
        } else {
          final provider = waterLogTrendProvider((
            seasonId: 'season',
            days: null,
          ));
          final sub = container.listen(provider, (_, _) {});
          try {
            await expectLater(
              container.read(provider.future),
              throwsA(same(denied)),
            );
            await tester.pump(const Duration(seconds: 2));
            expect(repository.metadataCalls, 1);
            expect(repository.listCalls, scenario == 'trend list' ? 1 : 0);
            expect(container.read(provider).error, same(denied));
            repository.metadataError = null;
            repository.listError = null;
            container.invalidate(provider);
            expect((await container.read(provider.future)).logs, isEmpty);
            expect(repository.metadataCalls, 2);
          } finally {
            sub.close();
            container.dispose();
            await tester.pump();
          }
        }
      },
    );
  }
  testWidgets(
    'metadata still automatically retries a transient network error',
    (tester) async {
      final repository = _Repository()
        ..metadataError = const NetworkException()
        ..recoverAfterFirst = true;
      final container = ProviderContainer(
        overrides: [waterLogRepositoryProvider.overrideWithValue(repository)],
      );
      final provider = waterLogMetadataProvider('season');
      final sub = container.listen(provider, (_, _) {});
      try {
        await tester.pump();
        expect(repository.metadataCalls, 1);
        await tester.pump(const Duration(milliseconds: 250));
        await tester.pump();
        expect(repository.metadataCalls, 2);
        expect(container.read(provider).asData?.value.shrimpType, 'WHITELEG');
      } finally {
        sub.close();
        container.dispose();
        await tester.pump();
      }
    },
  );
}
