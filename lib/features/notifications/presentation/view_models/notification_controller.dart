import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartshrimp_app/core/di/core_providers.dart';
import 'package:smartshrimp_app/core/config/app_config.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/auth/presentation/view_models/auth_controller.dart';
import 'package:smartshrimp_app/features/notifications/data/repositories/notification_repository_impl.dart';
import 'package:smartshrimp_app/features/notifications/data/services/notification_api_service.dart';
import 'package:smartshrimp_app/features/notifications/data/services/notification_socket.dart';
import 'package:smartshrimp_app/features/notifications/domain/entities/app_notification.dart';
import 'package:smartshrimp_app/features/notifications/domain/repositories/notification_repository.dart';

final notificationRemoteDataSourceProvider =
    Provider<NotificationRemoteDataSource>((ref) {
      return NotificationApiService(ref.watch(apiClientProvider));
    });

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  return NotificationRepositoryImpl(
    ref.watch(notificationRemoteDataSourceProvider),
  );
});

final notificationSocketProvider = Provider.autoDispose<NotificationSocket?>((
  ref,
) {
  final account = switch (ref.watch(authControllerProvider)) {
    AsyncData(:final value) => value,
    _ => null,
  };
  final serverUrl = AppConfig.socketBaseUrl;
  if (account == null || serverUrl == null) return null;

  final socket = NotificationSocket(
    serverUrl: serverUrl,
    apiClient: ref.read(apiClientProvider),
    onChanged: () {
      if (ref.mounted) ref.invalidate(notificationListProvider);
    },
    onSessionExpired: () {
      if (ref.mounted) {
        ref.read(authControllerProvider.notifier).expireSession();
      }
    },
  );
  socket.connect();
  ref.onDispose(socket.dispose);
  return socket;
});

typedef NotificationListQuery = ({
  NotificationCategory category,
  NotificationReadStatus readStatus,
});

final notificationListProvider =
    AsyncNotifierProvider.family<
      NotificationListController,
      NotificationPage,
      NotificationListQuery
    >(NotificationListController.new);

final class NotificationListController extends AsyncNotifier<NotificationPage> {
  NotificationListController(this.query);

  final NotificationListQuery query;
  bool _loadingMore = false;
  bool _refreshing = false;
  bool _markingAllAsRead = false;
  int _generation = 0;

  @override
  Future<NotificationPage> build() {
    _generation++;
    final authState = ref.watch(authControllerProvider);
    if (authState.value == null) {
      throw StateError('Notifications require an authenticated account.');
    }
    return _runAuthenticated(
      () => ref
          .read(notificationRepositoryProvider)
          .getNotifications(
            readStatus: query.readStatus,
            category: query.category,
          ),
    );
  }

  Future<void> refresh() async {
    if (_refreshing) return;
    _refreshing = true;
    final generation = ++_generation;
    try {
      final result = await AsyncValue.guard(
        () => _runAuthenticated(
          () => ref
              .read(notificationRepositoryProvider)
              .getNotifications(
                readStatus: query.readStatus,
                category: query.category,
              ),
        ),
      );
      if (ref.mounted && generation == _generation) state = result;
    } finally {
      _refreshing = false;
    }
  }

  Future<void> loadMore() async {
    final current = state.value;
    if (_loadingMore || current == null || !current.hasNextPage) return;
    final cursor = current.nextCursor;
    if (cursor == null) return;

    _loadingMore = true;
    final generation = _generation;
    try {
      final next = await _runAuthenticated(
        () => ref
            .read(notificationRepositoryProvider)
            .getNotifications(
              readStatus: query.readStatus,
              category: query.category,
              cursor: cursor,
            ),
      );
      if (!ref.mounted || generation != _generation) return;
      final latest = state.value;
      if (latest == null || latest.nextCursor != cursor) return;
      final knownIds = latest.items.map((item) => item.id).toSet();
      state = AsyncData(
        next.copyWith(
          items: <AppNotification>[
            ...latest.items,
            ...next.items.where((item) => knownIds.add(item.id)),
          ],
        ),
      );
    } finally {
      _loadingMore = false;
    }
  }

  Future<int> markAllAsRead() async {
    if (_markingAllAsRead) return 0;
    _markingAllAsRead = true;
    try {
      return await _runAuthenticated(
        () => ref.read(notificationRepositoryProvider).markAllAsRead(),
      );
    } finally {
      _markingAllAsRead = false;
      if (ref.mounted) ref.invalidate(notificationListProvider);
    }
  }

  Future<T> _runAuthenticated<T>(Future<T> Function() operation) async {
    try {
      return await operation();
    } on SessionExpiredException {
      await ref.read(authControllerProvider.notifier).expireSession();
      rethrow;
    }
  }
}

final notificationDetailProvider = FutureProvider.autoDispose
    .family<AppNotification, String>((ref, id) async {
      final authState = ref.watch(authControllerProvider);
      if (authState.value == null) {
        throw StateError('Notifications require an authenticated account.');
      }
      try {
        final notification = await ref
            .read(notificationRepositoryProvider)
            .getNotification(id);
        // Opening the detail marks it read on the server. Reload all active filters.
        if (ref.mounted) ref.invalidate(notificationListProvider);
        return notification;
      } on SessionExpiredException {
        await ref.read(authControllerProvider.notifier).expireSession();
        rethrow;
      }
    });
