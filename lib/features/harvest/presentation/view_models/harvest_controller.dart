import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:smartshrimp_app/core/di/core_providers.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/auth/domain/entities/auth_account.dart';
import 'package:smartshrimp_app/features/auth/presentation/view_models/auth_controller.dart';
import 'package:smartshrimp_app/features/harvest/data/services/harvest_api_service.dart';
import 'package:smartshrimp_app/features/harvest/data/services/secure_harvest_submission_store.dart';
import 'package:smartshrimp_app/features/harvest/domain/entities/harvest_event.dart';
import 'package:smartshrimp_app/features/harvest/domain/harvest_policy.dart';
import 'package:smartshrimp_app/features/harvest/domain/repositories/harvest_repository.dart';
import 'package:smartshrimp_app/features/harvest/domain/repositories/harvest_submission_store.dart';
import 'package:smartshrimp_app/features/season/presentation/view_models/season_controller.dart';
import 'package:smartshrimp_app/features/pond/presentation/view_models/pond_controller.dart';
import 'package:smartshrimp_app/features/home/presentation/view_models/owner_dashboard_controller.dart';
import 'package:smartshrimp_app/features/farm/presentation/view_models/farm_controller.dart';

final harvestRepositoryProvider = Provider<HarvestRepository>(
  (ref) => HarvestApiService(ref.watch(apiClientProvider)),
);

final harvestSubmissionStoreProvider = Provider<HarvestSubmissionStore>(
  (ref) => SecureHarvestSubmissionStore(ref.watch(secureStorageProvider)),
);

final pendingHarvestProvider = FutureProvider.autoDispose
    .family<PendingHarvestSubmission?, String>((ref, seasonId) {
      final account = ref.watch(authControllerProvider).value;
      if (account?.role != AccountRole.farmOwner) {
        throw const UnsupportedRoleException();
      }
      return ref
          .watch(harvestSubmissionStoreProvider)
          .read(account!.id, seasonId);
    }, retry: (retryCount, error) => null);

Future<T> _authenticated<T>(
  Ref ref,
  Future<T> Function() action, {
  bool watchAccount = true,
}) async {
  // Reads follow account changes; an in-flight write must not rebuild on profile edits.
  final account = watchAccount
      ? ref.watch(authControllerProvider).value
      : ref.read(authControllerProvider).value;
  if (account?.role != AccountRole.farmOwner) {
    throw const UnsupportedRoleException();
  }
  try {
    return await action();
  } on SessionExpiredException {
    if (ref.mounted) {
      await ref.read(authControllerProvider.notifier).expireSession();
    }
    rethrow;
  }
}

// ---------------------------------------------------------------------------
// Harvest list — stateful, infinite-scroll, no filters
// ---------------------------------------------------------------------------

const _kHarvestPageSize = 10;

/// Accumulated list state for infinite-scroll harvest list.
class HarvestListState {
  const HarvestListState({
    required this.items,
    required this.totalResults,
    required this.hasNextPage,
    required this.totalWeightKg,
    required this.totalRevenue,
    this.nextCursor,
    this.loadingMore = false,
    this.paginationError,
    this.availableQuantityCount,
  });

  final List<HarvestEvent> items;
  final int totalResults;
  final bool hasNextPage;
  final double totalWeightKg;
  final double totalRevenue;
  final String? nextCursor;
  final bool loadingMore;
  final Object? paginationError;
  final String? availableQuantityCount;

  HarvestListState copyWith({
    List<HarvestEvent>? items,
    int? totalResults,
    bool? hasNextPage,
    double? totalWeightKg,
    double? totalRevenue,
    String? nextCursor,
    bool? loadingMore,
    Object? paginationError,
    bool clearPaginationError = false,
    String? availableQuantityCount,
  }) => HarvestListState(
    items: items ?? this.items,
    totalResults: totalResults ?? this.totalResults,
    hasNextPage: hasNextPage ?? this.hasNextPage,
    totalWeightKg: totalWeightKg ?? this.totalWeightKg,
    totalRevenue: totalRevenue ?? this.totalRevenue,
    availableQuantityCount:
        availableQuantityCount ?? this.availableQuantityCount,
    nextCursor: nextCursor ?? this.nextCursor,
    loadingMore: loadingMore ?? this.loadingMore,
    paginationError: clearPaginationError
        ? null
        : (paginationError ?? this.paginationError),
  );

  factory HarvestListState.fromPage(HarvestPage page) => HarvestListState(
    items: page.items,
    totalResults: page.totalResults,
    hasNextPage: page.hasNextPage,
    totalWeightKg: page.totalWeightKg,
    totalRevenue: page.totalRevenue,
    availableQuantityCount: page.availableQuantityCount,
    nextCursor: page.nextCursor,
  );

  HarvestListState appendPage(HarvestPage next) {
    final seen = <String>{};
    final merged = [
      for (final e in [...items, ...next.items])
        if (seen.add(e.id)) e,
    ];
    return copyWith(
      items: merged,
      totalResults: next.totalResults,
      hasNextPage: next.hasNextPage,
      totalWeightKg: next.totalWeightKg,
      totalRevenue: next.totalRevenue,
      availableQuantityCount: next.availableQuantityCount,
      nextCursor: next.nextCursor,
      loadingMore: false,
      clearPaginationError: true,
    );
  }
}

final harvestListProvider = AsyncNotifierProvider.autoDispose
    .family<HarvestListController, HarvestListState, String>(
      HarvestListController.new,
    );

// Keep historical estimates separate from the current list and its pagination.
final harvestPopulationProvider = FutureProvider.autoDispose
    .family<String?, ({String seasonId, DateTime? at})>((ref, query) {
      return _authenticated(ref, () async {
        final page = await ref
            .watch(harvestRepositoryProvider)
            .list(query.seasonId, {
              'limit': 1,
              if (query.at != null)
                'populationAt': query.at!.toUtc().toIso8601String(),
            });
        return page.availableQuantityCount;
      });
    }, retry: (retryCount, error) => null);

class HarvestListController extends AsyncNotifier<HarvestListState> {
  HarvestListController(this.seasonId);
  final String seasonId;

  int _generation = 0;
  int? _loadingMoreGeneration;
  bool _refreshing = false;

  Future<HarvestPage> _fetch({String? cursor}) async {
    final generation = _generation;
    try {
      return await _authenticated(
        ref,
        () => ref.read(harvestRepositoryProvider).list(seasonId, {
          'limit': _kHarvestPageSize,
          'cursor': ?cursor,
        }),
      );
    } on SessionExpiredException {
      if (ref.mounted && generation == _generation) {
        await ref.read(authControllerProvider.notifier).expireSession();
      }
      rethrow;
    }
  }

  @override
  Future<HarvestListState> build() async {
    _generation++;
    _refreshing = false;
    _loadingMoreGeneration = null;
    return HarvestListState.fromPage(await _fetch());
  }

  Future<void> refresh() async {
    if (state.isLoading) {
      ref.invalidateSelf();
      await future;
      return;
    }
    final generation = ++_generation;
    _refreshing = true;
    _loadingMoreGeneration = null;
    final previous = state.value;
    if (previous != null) {
      state = AsyncData(
        previous.copyWith(loadingMore: false, clearPaginationError: true),
      );
    }
    try {
      final page = await _fetch();
      if (!ref.mounted || generation != _generation) return;
      _refreshing = false;
      state = AsyncData(HarvestListState.fromPage(page));
    } on Object catch (error, stack) {
      if (!ref.mounted || generation != _generation) return;
      if (previous == null) {
        state = AsyncError<HarvestListState>(error, stack);
      }
      Error.throwWithStackTrace(error, stack);
    } finally {
      if (generation == _generation) _refreshing = false;
    }
  }

  Future<void> loadMore() async {
    final current = state.value;
    final generation = _generation;
    if (current == null ||
        !current.hasNextPage ||
        _refreshing ||
        _loadingMoreGeneration == generation) {
      return;
    }
    _loadingMoreGeneration = generation;
    state = AsyncData(
      current.copyWith(loadingMore: true, clearPaginationError: true),
    );
    try {
      final cursor = current.nextCursor;
      if (cursor == null || cursor.trim().isEmpty) {
        throw const InvalidResponseException();
      }
      final next = await _fetch(cursor: cursor);
      if (ref.mounted && generation == _generation) {
        if (next.hasNextPage &&
            (next.nextCursor == null ||
                next.nextCursor!.trim().isEmpty ||
                next.nextCursor == cursor)) {
          throw const InvalidResponseException();
        }
        state = AsyncData(current.appendPage(next));
      }
    } on Object catch (error) {
      if (!ref.mounted || generation != _generation) return;
      state = AsyncData(
        current.copyWith(loadingMore: false, paginationError: error),
      );
    } finally {
      if (_loadingMoreGeneration == generation) _loadingMoreGeneration = null;
    }
  }
}

// ---------------------------------------------------------------------------
// Detail and durable harvest submissions
// ---------------------------------------------------------------------------

final harvestDetailProvider = FutureProvider.autoDispose
    .family<HarvestEvent, ({String seasonId, String harvestId})>(
      (ref, ids) => _authenticated(
        ref,
        () => ref
            .watch(harvestRepositoryProvider)
            .detail(ids.seasonId, ids.harvestId),
      ),
      retry: (retryCount, error) => null,
    );

final harvestMutationProvider = AsyncNotifierProvider.autoDispose
    .family<HarvestMutationController, void, String>(
      HarvestMutationController.new,
    );

class HarvestMutationController extends AsyncNotifier<void> {
  HarvestMutationController(this.seasonId);
  final String seasonId;
  bool _submitting = false;
  @override
  void build() {}

  Future<HarvestEvent> submit(Map<String, dynamic> body) async {
    if (_submitting || state.isLoading) {
      throw const ApiException('Đang ghi nhận thu hoạch.');
    }
    final account = ref.read(authControllerProvider).value;
    if (account?.role != AccountRole.farmOwner) {
      throw const UnsupportedRoleException();
    }
    final ownerId = account!.id;
    final store = ref.read(harvestSubmissionStoreProvider);
    final repository = ref.read(harvestRepositoryProvider);
    final keepAlive = ref.keepAlive();
    _submitting = true;
    state = const AsyncLoading();
    bool resuming = false;
    bool requestStarted = false;
    String? requestKey;
    try {
      final prior = await store.read(ownerId, seasonId);
      resuming = prior != null;
      // Sorting keys compares content, not insertion order; the durable body remains authoritative.
      String fingerprint(Map<String, dynamic> value) => jsonEncode(
        Map.fromEntries(
          value.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
        ),
      );
      if (prior != null && fingerprint(prior.body) != fingerprint(body)) {
        throw const ApiException(
          'Còn một lần thu hoạch chưa rõ kết quả. Hãy kiểm tra lần đó trước khi ghi mới.',
        );
      }
      final pending =
          prior ??
          PendingHarvestSubmission(
            key: const Uuid().v4(),
            body: jsonDecode(jsonEncode(body)) as Map<String, dynamic>,
          );
      requestKey = pending.key;
      if (prior == null) await store.write(ownerId, seasonId, pending);
      if (!ref.mounted ||
          ref.read(authControllerProvider).value?.id != ownerId) {
        throw const SessionExpiredException();
      }
      requestStarted = true;
      final event = await _authenticated(
        ref,
        () => repository.record(seasonId, pending.body, pending.key),
        watchAccount: false,
      );
      await store.clear(ownerId, seasonId, expectedKey: pending.key);
      if (ref.mounted) {
        ref.invalidate(harvestListProvider(seasonId));
        ref.invalidate(harvestDetailProvider);
        ref.invalidate(harvestPopulationProvider);
        ref.invalidate(seasonDetailControllerProvider(seasonId));
        ref.invalidate(pondSeasonHistoryProvider);
        ref.invalidate(pondDetailControllerProvider);
        ref.invalidate(pondListControllerProvider);
        final farmId = event.season.pond.farm?.id;
        if (farmId != null) {
          ref.invalidate(farmDetailControllerProvider(farmId));
        }
        ref.invalidate(farmListControllerProvider);
        ref.invalidate(ownerDashboardProvider);
        ref.invalidate(ownerFinanceProvider);
        state = const AsyncData(null);
      }
      return event;
    } on Object catch (error, stack) {
      if (ref.mounted) state = AsyncError(error, stack);
      // A resumed request needs confirmation that even a delayed original cannot commit.
      if (requestStarted &&
          requestKey != null &&
          error is AppException &&
          (isConfirmedHarvestTimeRejection(error) ||
              (!resuming &&
                  [
                    400,
                    401,
                    403,
                    404,
                    409,
                    422,
                    429,
                  ].contains(error.statusCode)))) {
        try {
          await store.clear(ownerId, seasonId, expectedKey: requestKey);
        } on Object catch (storageError, storageStack) {
          if (ref.mounted) state = AsyncError(storageError, storageStack);
          Error.throwWithStackTrace(storageError, storageStack);
        }
      }
      rethrow;
    } finally {
      _submitting = false;
      if (ref.mounted) ref.invalidate(pendingHarvestProvider(seasonId));
      keepAlive.close();
    }
  }
}
