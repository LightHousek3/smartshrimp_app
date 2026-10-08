import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartshrimp_app/core/di/core_providers.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/auth/presentation/view_models/auth_controller.dart';
import 'package:smartshrimp_app/features/operation/data/repositories/operation_repository_impl.dart';
import 'package:smartshrimp_app/features/operation/data/services/operation_api_service.dart';
import 'package:smartshrimp_app/features/operation/domain/entities/operation_models.dart';
import 'package:smartshrimp_app/features/operation/domain/repositories/operation_repository.dart';

final operationRepositoryProvider = Provider<OperationRepository>(
  (ref) => OperationRepositoryImpl(
    OperationApiService(ref.watch(apiClientProvider)),
  ),
);

final operationFilterTabProvider =
    NotifierProvider.autoDispose<OperationFilterTabController, String>(
      OperationFilterTabController.new,
    );

final class OperationFilterTabController extends Notifier<String> {
  @override
  String build() => 'ALL';

  void setTab(String tab) => state = tab;
}

final operationListProvider = AsyncNotifierProvider.autoDispose
    .family<OperationListController, OperationListResult, String>(
      OperationListController.new,
    );

final operationDetailProvider = AsyncNotifierProvider.autoDispose
    .family<OperationDetailController, OperationSchedule, String>(
      OperationDetailController.new,
    );

final operationStatsProvider = FutureProvider.autoDispose
    .family<OperationStats, String>((ref, seasonId) async {
      try {
        return await ref
            .watch(operationRepositoryProvider)
            .getSeasonStats(seasonId);
      } on SessionExpiredException {
        await ref.read(authControllerProvider.notifier).expireSession();
        rethrow;
      }
    });

final class OperationListController extends AsyncNotifier<OperationListResult> {
  OperationListController(this.seasonId);
  final String seasonId;

  String? _operationType;
  String? _date;

  @override
  Future<OperationListResult> build() => _fetch();

  Future<OperationListResult> _fetch() async {
    try {
      return await ref
          .read(operationRepositoryProvider)
          .getSchedules(
            seasonId,
            status: null,
            operationType: _operationType,
            date: _date,
          );
    } on SessionExpiredException {
      await ref.read(authControllerProvider.notifier).expireSession();
      rethrow;
    }
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetch);
  }

  void setFilterTab(String tab) {
    ref.read(operationFilterTabProvider.notifier).setTab(tab);
  }
}

final class OperationDetailController extends AsyncNotifier<OperationSchedule> {
  OperationDetailController(this.scheduleId);
  final String scheduleId;

  @override
  Future<OperationSchedule> build() => _fetch();

  Future<OperationSchedule> _fetch() async {
    try {
      return await ref
          .read(operationRepositoryProvider)
          .getSchedule(scheduleId);
    } on SessionExpiredException {
      await ref.read(authControllerProvider.notifier).expireSession();
      rethrow;
    }
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetch);
  }

  Future<OperationExecution> execute({
    required double actualQuantity,
    required String idempotencyKey,
    String? actualProductId,
    String? note,
    String? varianceReason,
    DateTime? executedAt,
  }) async {
    try {
      final result = await ref
          .read(operationRepositoryProvider)
          .executeSchedule(
            scheduleId,
            actualQuantity: actualQuantity,
            idempotencyKey: idempotencyKey,
            actualProductId: actualProductId,
            note: note,
            varianceReason: varianceReason,
            executedAt: executedAt,
          );
      await refresh();
      return result;
    } on SessionExpiredException {
      await ref.read(authControllerProvider.notifier).expireSession();
      rethrow;
    }
  }
}
