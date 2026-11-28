import 'dart:async';

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
  final accountId = ref.watch(
    authControllerProvider.select((value) => value.value?.id),
  );
  final serverUrl = AppConfig.socketBaseUrl;
  if (accountId == null || serverUrl == null) return null;

  final socket = NotificationSocket(
    serverUrl: serverUrl,
    apiClient: ref.read(apiClientProvider),
    onChanged: () {
      if (ref.mounted) ref.invalidate(notificationListProvider);
    },
    onRead: (id, readAt) {
      if (ref.mounted &&
          ref.read(authControllerProvider).value?.id == accountId) {
        _recordNotificationRead(ref, id, readAt);
      }
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

void _recordNotificationRead(Ref ref, String id, DateTime readAt) {
  for (final category in NotificationCategory.values) {
    for (final readStatus in [
      NotificationReadStatus.all,
      NotificationReadStatus.unread,
    ]) {
      final provider = notificationListProvider((
        category: category,
        readStatus: readStatus,
      ));
      if (ref.exists(provider)) {
        unawaited(ref.read(provider.notifier).recordRead(id, readAt));
      }
    }
  }
}

final class NotificationListController extends AsyncNotifier<NotificationPage> {
  NotificationListController(this.query);

  final NotificationListQuery query;
  bool _loadingMore = false;
  bool _refreshing = false;
  bool _markingAllAsRead = false;
  bool _syncingUnreadTotal = false;
  int _generation = 0;
  final _observedReads = <String>{};

  @override
  Future<NotificationPage> build() {
    _generation++;
    _observedReads.clear();
    final accountId = ref.watch(
      authControllerProvider.select((value) => value.value?.id),
    );
    if (accountId == null) {
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

  /// Apply a confirmed read to loaded rows without discarding their cursor.
  Future<void> recordRead(String id, DateTime readAt) async {
    final accountId = ref.read(authControllerProvider).value?.id;
    if (accountId == null) return;
    if (state.value == null) {
      try {
        await future;
      } on Object {
        return; // The list already exposes its load error.
      }
      if (!ref.mounted ||
          ref.read(authControllerProvider).value?.id != accountId) {
        return;
      }
    }
    final page = state.value;
    if (page == null || !_observedReads.add(id)) return;

    final unreadOnly = query.readStatus == NotificationReadStatus.unread;
    final index = page.items.indexWhere((item) => item.id == id);
    if (index >= 0 && page.items[index].isUnread) {
      // A page response started before the read could reintroduce the unread row.
      _generation++;
      final items = page.items.toList();
      if (unreadOnly) {
        items.removeAt(index);
        state = AsyncData(
          _withUnreadTotal(
            page.copyWith(items: items),
            page.totalResults > 0 ? page.totalResults - 1 : 0,
          ),
        );
      } else {
        items[index] = items[index].copyWith(readAt: readAt);
        state = AsyncData(page.copyWith(items: items));
      }
      return;
    }
    if (index >= 0 || !page.hasNextPage) return;
    _generation++;
    if (!unreadOnly) return;

    // An unloaded item may contribute to the unread badge or to this filter's count.
    if (_syncingUnreadTotal) return;
    _syncingUnreadTotal = true;
    try {
      while (ref.mounted &&
          ref.read(authControllerProvider).value?.id == accountId) {
        final generation = _generation;
        final count = await _runAuthenticated(
          () => ref
              .read(notificationRepositoryProvider)
              .getNotifications(
                readStatus: query.readStatus,
                category: query.category,
                limit: 1,
              ),
        );
        if (!ref.mounted ||
            ref.read(authControllerProvider).value?.id != accountId) {
          return;
        }
        if (generation != _generation) continue;
        if (state.value case final latest?) {
          state = AsyncData(_withUnreadTotal(latest, count.totalResults));
        }
        break;
      }
    } on Object {
      // A failed background count must not replace an otherwise usable inbox.
      _observedReads.remove(id);
    } finally {
      _syncingUnreadTotal = false;
    }
  }

  NotificationPage _withUnreadTotal(NotificationPage page, int total) {
    final hasNext = page.hasNextPage && total > page.items.length;
    return page.copyWith(
      totalResults: total,
      hasNextPage: hasNext,
      nextCursor: hasNext ? page.nextCursor : null,
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
      final accountId = ref.watch(
        authControllerProvider.select((value) => value.value?.id),
      );
      if (accountId == null) {
        throw StateError('Notifications require an authenticated account.');
      }
      // Finish synchronizing the read state even if the sheet is closed quickly.
      final pendingRead = ref.keepAlive();
      try {
        final notification = await ref
            .read(notificationRepositoryProvider)
            .getNotification(id);
        final readAt = notification.readAt;
        if (ref.mounted &&
            ref.read(authControllerProvider).value?.id == accountId &&
            readAt != null) {
          _recordNotificationRead(ref, id, readAt);
        }
        return notification;
      } on SessionExpiredException {
        if (ref.mounted) {
          await ref.read(authControllerProvider.notifier).expireSession();
        }
        rethrow;
      } finally {
        pendingRead.close();
      }
    }, retry: (_, _) => null);
