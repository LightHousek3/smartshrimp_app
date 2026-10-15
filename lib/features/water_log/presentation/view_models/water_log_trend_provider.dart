import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/auth/presentation/view_models/auth_controller.dart';
import 'package:smartshrimp_app/features/water_log/domain/entities/water_log.dart';
import 'package:smartshrimp_app/features/water_log/domain/entities/water_log_metadata.dart';
import 'package:smartshrimp_app/features/water_log/presentation/view_models/water_log_controller.dart';
import 'package:smartshrimp_app/features/water_log/presentation/view_models/water_log_read_retry.dart';

typedef WaterLogTrendQuery = ({String seasonId, int? days});
typedef WaterLogTrendData = ({List<WaterLog> logs, WaterLogMetadata metadata});

/// Individual readings are required: daily averages can hide unsafe samples.
final waterLogTrendProvider = FutureProvider.autoDispose
    .family<WaterLogTrendData, WaterLogTrendQuery>((ref, query) async {
      ref.watch(waterLogRevisionProvider(query.seasonId));
      final repository = ref.watch(waterLogRepositoryProvider);
      final to = DateTime.now();
      final from = query.days == null
          ? null
          : to.subtract(Duration(days: query.days!));
      try {
        final metadata = await repository.getMetadata(seasonId: query.seasonId);
        final logs = <String, WaterLog>{};
        final cursors = <String>{};
        String? cursor;
        while (ref.mounted) {
          final page = await repository.getWaterLogs(
            seasonId: query.seasonId,
            from: from,
            // BE's date validator requires `from` whenever `to` is present.
            to: from == null ? null : to,
            limit: 50,
            cursor: cursor,
          );
          for (final log in page.items) {
            if (!log.isVoided) logs.putIfAbsent(log.id, () => log);
          }
          if (!page.hasNextPage) break;
          cursor = page.nextCursor;
          if (page.items.isEmpty ||
              cursor == null ||
              cursor.trim().isEmpty ||
              !cursors.add(cursor)) {
            throw const InvalidResponseException();
          }
        }
        final sorted = logs.values.toList()
          ..sort((a, b) {
            final order = a.recordedAt.compareTo(b.recordedAt);
            return order == 0 ? a.id.compareTo(b.id) : order;
          });
        return (logs: List<WaterLog>.unmodifiable(sorted), metadata: metadata);
      } on SessionExpiredException {
        if (ref.mounted) {
          await ref.read(authControllerProvider.notifier).expireSession();
        }
        rethrow;
      }
    }, retry: waterLogReadRetry);
