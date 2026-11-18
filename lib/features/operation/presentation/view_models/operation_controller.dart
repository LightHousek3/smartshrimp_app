import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartshrimp_app/core/di/core_providers.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/home/presentation/view_models/technician_dashboard_controller.dart';
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
  String build() => 'PLANNED';

  void setTab(String tab) => state = tab;
}

final operationDateFilterProvider =
    NotifierProvider.autoDispose<OperationDateFilterController, DateTime>(
      OperationDateFilterController.new,
    );

final class OperationDateFilterController extends Notifier<DateTime> {
  @override
  DateTime build() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  void setDate(DateTime date) =>
      state = DateTime(date.year, date.month, date.day);
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
  final Map<String, OperationListResult> _cacheByDate =
      <String, OperationListResult>{};
  int _requestSeq = 0;

  String _formatDate(DateTime dt) =>
      '${dt.year.toString().padLeft(4, '0')}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';

  @override
  Future<OperationListResult> build() async {
    final selectedDate = ref.read(operationDateFilterProvider);
    final dateStr = _formatDate(selectedDate);
    final result = await _fetch(dateStr);
    _cacheByDate[dateStr] = result;
    // Prefetch âm thầm ngày mai & ngày mốt để chuyển chip ngày mượt 0ms
    _prefetchUpcomingDays();
    return result;
  }

  Future<OperationListResult> _fetch(String dateStr) async {
    try {
      return await ref
          .read(operationRepositoryProvider)
          .getSchedules(
            seasonId,
            status: null,
            operationType: _operationType,
            date: dateStr,
          );
    } on SessionExpiredException {
      await ref.read(authControllerProvider.notifier).expireSession();
      rethrow;
    }
  }

  Future<void> _prefetchUpcomingDays() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final targets = <DateTime>[
      today,
      today.add(const Duration(days: 1)),
      today.add(const Duration(days: 2)),
    ];

    for (final day in targets) {
      if (!ref.mounted) return;
      final key = _formatDate(day);
      if (_cacheByDate.containsKey(key)) continue;
      try {
        final data = await ref
            .read(operationRepositoryProvider)
            .getSchedules(
              seasonId,
              status: null,
              operationType: _operationType,
              date: key,
            );
        if (!ref.mounted) return;
        _cacheByDate[key] = data;
      } catch (_) {
        // Bỏ qua lỗi prefetch nền, sẽ tải trực tiếp khi người dùng chọn
      }
    }
  }

  /// Chuyển ngày mượt không reload toàn trang:
  /// - Nếu đã có trong RAM cache -> đổi dữ liệu tức thì (0ms).
  /// - Nếu chưa có (vd chọn ngày quá khứ) -> giữ nguyên UI hiện tại và chỉ tải ngầm danh sách.
  Future<void> selectDate(DateTime date) async {
    final normalized = DateTime(date.year, date.month, date.day);
    ref.read(operationDateFilterProvider.notifier).setDate(normalized);
    final dateStr = _formatDate(normalized);

    final seq = ++_requestSeq;
    final cached = _cacheByDate[dateStr];
    if (cached != null) {
      state = AsyncData(cached);
      return;
    }

    // Giữ nguyên dữ liệu hiện tại trên màn hình trong lúc tải nền (không nhấp nháy loading toàn trang)
    final nextState = await AsyncValue.guard(() => _fetch(dateStr));
    if (!ref.mounted || seq != _requestSeq) return;
    if (nextState case AsyncData(:final value)) {
      _cacheByDate[dateStr] = value;
    }
    state = nextState;
  }

  Future<void> refresh() async {
    _cacheByDate.clear();
    final selectedDate = ref.read(operationDateFilterProvider);
    final dateStr = _formatDate(selectedDate);
    final seq = ++_requestSeq;
    final nextState = await AsyncValue.guard(() => _fetch(dateStr));
    if (!ref.mounted || seq != _requestSeq) return;
    if (nextState case AsyncData(:final value)) {
      _cacheByDate[dateStr] = value;
      _prefetchUpcomingDays();
    }
    state = nextState;
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
      if (ref.mounted) {
        ref.invalidate(technicianDashboardProvider);
      }
      await refresh();
      return result;
    } on SessionExpiredException {
      await ref.read(authControllerProvider.notifier).expireSession();
      rethrow;
    }
  }
}
