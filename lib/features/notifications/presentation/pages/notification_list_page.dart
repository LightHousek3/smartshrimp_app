import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/widgets/app_gradient_background.dart';
import 'package:smartshrimp_app/features/notifications/domain/entities/app_notification.dart';
import 'package:smartshrimp_app/features/notifications/domain/repositories/notification_repository.dart';
import 'package:smartshrimp_app/features/notifications/presentation/widgets/notification_detail_sheet.dart';
import 'package:smartshrimp_app/features/notifications/presentation/view_models/notification_controller.dart';
import 'package:smartshrimp_app/features/notifications/presentation/widgets/notification_visuals.dart';

enum _NotificationFilter { all, unread, action, warning }

class NotificationListPage extends ConsumerStatefulWidget {
  const NotificationListPage({super.key});

  @override
  ConsumerState<NotificationListPage> createState() =>
      _NotificationListPageState();
}

class _NotificationListPageState extends ConsumerState<NotificationListPage> {
  _NotificationFilter _filter = _NotificationFilter.all;
  bool _loadingMore = false;
  bool _markingAllAsRead = false;
  String? _loadMoreError;

  NotificationReadStatus get _readStatus => switch (_filter) {
    _NotificationFilter.all => NotificationReadStatus.all,
    _NotificationFilter.unread => NotificationReadStatus.unread,
    _NotificationFilter.action => NotificationReadStatus.unread,
    _NotificationFilter.warning => NotificationReadStatus.all,
  };

  List<AppNotification> _applyClientFilter(List<AppNotification> items) =>
      switch (_filter) {
        _NotificationFilter.action =>
          items
              .where(
                (notification) =>
                    notification.isUnread && notification.referenceId != null,
              )
              .toList(growable: false),
        _NotificationFilter.warning =>
          items
              .where(
                (notification) =>
                    NotificationVisuals.isWarning(notification.type),
              )
              .toList(growable: false),
        _ => items,
      };

  @override
  Widget build(BuildContext context) {
    final provider = notificationListProvider(_readStatus);
    final listState = ref.watch(provider);
    final unreadState = ref.watch(
      notificationListProvider(NotificationReadStatus.unread),
    );
    final unreadCount = unreadState.asData?.value.totalResults;
    final hasUnread = (unreadCount ?? 0) > 0;

    return AppGradientBackground(
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _ListHeader(
              unreadCount: unreadCount,
              markingAllAsRead: _markingAllAsRead,
              onMarkAllAsRead: hasUnread && !_markingAllAsRead
                  ? () => _markAllAsRead(provider)
                  : null,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 3, 16, 12),
              child: _FilterChips(
                selected: _filter,
                onSelect: (filter) {
                  if (_filter == filter) return;
                  setState(() {
                    _filter = filter;
                    _loadMoreError = null;
                    _loadingMore = false;
                  });
                },
              ),
            ),
            Expanded(
              child: listState.when(
                loading: () => const Center(
                  child: CircularProgressIndicator(color: AppColors.ocean),
                ),
                error: (error, _) => _MessageState(
                  icon: Icons.cloud_off_rounded,
                  title: 'Không thể tải thông báo',
                  message: _errorMessage(error),
                  actionLabel: 'Thử lại',
                  actionIcon: Icons.refresh_rounded,
                  onAction: () => ref.read(provider.notifier).refresh(),
                ),
                data: (page) => _buildList(provider, page),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList(
    AsyncNotifierProvider<NotificationListController, NotificationPage>
    provider,
    NotificationPage page,
  ) {
    final displayItems = _applyClientFilter(page.items);
    if (displayItems.isEmpty) {
      return RefreshIndicator(
        color: AppColors.ocean,
        onRefresh: () => ref.read(provider.notifier).refresh(),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 26),
          children: <Widget>[
            SizedBox(
              height: 430,
              child: _MessageState(
                icon: switch (_filter) {
                  _NotificationFilter.unread => Icons.mark_email_read_rounded,
                  _NotificationFilter.warning => Icons.warning_amber_rounded,
                  _NotificationFilter.action => Icons.check_circle_rounded,
                  _NotificationFilter.all => Icons.notifications_none_rounded,
                },
                title: switch (_filter) {
                  _NotificationFilter.unread => 'Bạn đã xem hết thông báo',
                  _NotificationFilter.action => 'Không có mục cần xử lý',
                  _NotificationFilter.warning => 'Không có cảnh báo nào',
                  _NotificationFilter.all => 'Chưa có thông báo',
                },
                message: page.hasNextPage
                    ? 'Tiếp tục tải để kiểm tra các thông báo cũ hơn.'
                    : switch (_filter) {
                        _NotificationFilter.unread =>
                          'Hiện không có thông báo nào chưa đọc.',
                        _NotificationFilter.action =>
                          'Tất cả thông báo cần xử lý đã được giải quyết.',
                        _NotificationFilter.warning =>
                          'Không có cảnh báo nào cần chú ý.',
                        _NotificationFilter.all =>
                          'Thông báo mới sẽ xuất hiện tại đây.',
                      },
                actionLabel: page.hasNextPage
                    ? (_loadingMore ? 'Đang tải...' : 'Xem thêm')
                    : null,
                actionIcon: Icons.expand_more_rounded,
                onAction: page.hasNextPage && !_loadingMore
                    ? () => _loadMore(provider)
                    : null,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: AppColors.ocean,
      onRefresh: () => ref.read(provider.notifier).refresh(),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 26),
        children: <Widget>[
          for (final notification in displayItems) ...<Widget>[
            _NotificationCard(
              notification: notification,
              onTap: () => showNotificationDetailSheet(
                context: context,
                notificationId: notification.id,
              ),
            ),
            const SizedBox(height: 10),
          ],
          if (_loadMoreError != null) ...<Widget>[
            Text(
              _loadMoreError!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.error, fontSize: 12),
            ),
            const SizedBox(height: 8),
          ],
          if (page.hasNextPage)
            Center(
              child: OutlinedButton.icon(
                onPressed: _loadingMore ? null : () => _loadMore(provider),
                icon: _loadingMore
                    ? const SizedBox.square(
                        dimension: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.expand_more_rounded),
                label: Text(_loadingMore ? 'Đang tải...' : 'Xem thêm'),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _loadMore(
    AsyncNotifierProvider<NotificationListController, NotificationPage>
    provider,
  ) async {
    if (_loadingMore) return;
    final filter = _filter;
    setState(() {
      _loadingMore = true;
      _loadMoreError = null;
    });
    try {
      await ref.read(provider.notifier).loadMore();
    } on AppException catch (error) {
      if (mounted && _filter == filter) {
        setState(() => _loadMoreError = error.message);
      }
    } on Object {
      if (mounted && _filter == filter) {
        setState(
          () => _loadMoreError = 'Không thể tải thêm. Vui lòng thử lại.',
        );
      }
    } finally {
      if (mounted && _filter == filter) {
        setState(() => _loadingMore = false);
      }
    }
  }

  Future<void> _markAllAsRead(
    AsyncNotifierProvider<NotificationListController, NotificationPage>
    provider,
  ) async {
    if (_markingAllAsRead) return;
    setState(() => _markingAllAsRead = true);
    try {
      final updatedCount = await ref.read(provider.notifier).markAllAsRead();
      if (!mounted) return;
      _showNotice(
        updatedCount > 0
            ? 'Đã đánh dấu tất cả thông báo là đã đọc.'
            : 'Không có thông báo chưa đọc.',
      );
    } on AppException catch (error) {
      if (mounted) _showNotice(error.message, isError: true);
    } on Object {
      if (mounted) {
        _showNotice(
          'Không thể đánh dấu đã đọc. Vui lòng thử lại.',
          isError: true,
        );
      }
    } finally {
      if (mounted) setState(() => _markingAllAsRead = false);
    }
  }

  void _showNotice(String message, {bool isError = false}) {
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) return;
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.white,
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          content: Row(
            children: <Widget>[
              Icon(
                isError
                    ? Icons.error_outline_rounded
                    : Icons.check_circle_rounded,
                color: isError ? AppColors.error : const Color(0xFF0F9B8E),
                size: 20,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(
                    color: AppColors.inkSoft,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }

  static String _errorMessage(Object error) => error is AppException
      ? error.message
      : 'Có lỗi xảy ra. Vui lòng thử lại.';
}

class _ListHeader extends StatelessWidget {
  const _ListHeader({
    required this.unreadCount,
    required this.markingAllAsRead,
    required this.onMarkAllAsRead,
  });

  final int? unreadCount;
  final bool markingAllAsRead;
  final VoidCallback? onMarkAllAsRead;

  @override
  Widget build(BuildContext context) {
    final subtitle = unreadCount == null
        ? 'Đang cập nhật thông báo'
        : unreadCount! > 0
        ? '$unreadCount thông báo chưa đọc'
        : 'Bạn đã đọc hết';
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 14),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Thông báo',
                  style: TextStyle(
                    color: AppColors.ink,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.35,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.inkMuted,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          TextButton(
            key: const Key('mark_all_notifications_read'),
            onPressed: onMarkAllAsRead,
            style: TextButton.styleFrom(
              foregroundColor: AppColors.ocean,
              disabledForegroundColor: AppColors.inkMuted,
              backgroundColor: Colors.white.withValues(alpha: 0.7),
              disabledBackgroundColor: Colors.white.withValues(alpha: 0.55),
              minimumSize: const Size(0, 34),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              shape: const StadiumBorder(),
              textStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
            child: markingAllAsRead
                ? const SizedBox.square(
                    dimension: 15,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Đọc tất cả'),
          ),
        ],
      ),
    );
  }
}

class _FilterChips extends StatelessWidget {
  const _FilterChips({required this.selected, required this.onSelect});

  final _NotificationFilter selected;
  final void Function(_NotificationFilter) onSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const Key('notification_filters'),
      height: 48,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xB3D3E8FF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: <Widget>[
          for (final filter in _NotificationFilter.values) ...<Widget>[
            Expanded(
              child: _FilterChip(
                label: switch (filter) {
                  _NotificationFilter.all => 'Tất cả',
                  _NotificationFilter.unread => 'Chưa đọc',
                  _NotificationFilter.action => 'Cần xử lý',
                  _NotificationFilter.warning => 'Cảnh báo',
                },
                selected: selected == filter,
                onTap: () => onSelect(filter),
              ),
            ),
            if (filter != _NotificationFilter.values.last)
              const SizedBox(width: 4),
          ],
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      child: Material(
        color: selected
            ? const Color(0xFF1D7AD6)
            : Colors.white.withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: SizedBox(
            height: 40,
            child: Center(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: selected ? Colors.white : AppColors.inkSoft,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  height: 1.15,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({required this.notification, required this.onTap});

  final AppNotification notification;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final unread = notification.isUnread;
    final accent = NotificationVisuals.color(notification.type);
    final content = notification.content?.trim();
    return Semantics(
      button: true,
      onTap: onTap,
      label:
          '${unread ? 'Chưa đọc' : 'Đã đọc'}, '
          '${NotificationVisuals.label(notification.type)}, '
          '${notification.title}, '
          '${NotificationVisuals.fullTime(notification.createdAt)}',
      child: ExcludeSemantics(
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          child: InkWell(
            key: Key('notification_${notification.id}'),
            borderRadius: BorderRadius.circular(18),
            onTap: onTap,
            child: Container(
              key: Key('notification_surface_${notification.id}'),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.line),
                boxShadow: const <BoxShadow>[
                  BoxShadow(
                    color: Color(0x100F1C2E),
                    blurRadius: 16,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: NotificationVisuals.backgroundColor(
                        notification.type,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      NotificationVisuals.icon(notification.type),
                      color: accent,
                      size: 17,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 9,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: NotificationVisuals.backgroundColor(
                                  notification.type,
                                ),
                                borderRadius: BorderRadius.circular(99),
                              ),
                              child: Text(
                                NotificationVisuals.label(notification.type),
                                style: TextStyle(
                                  color: NotificationVisuals.badgeTextColor(
                                    notification.type,
                                  ),
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w600,
                                  height: 1,
                                ),
                              ),
                            ),
                            if (unread) ...<Widget>[
                              const SizedBox(width: 8),
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF1D7AD6),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          notification.title,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: unread ? AppColors.ink : AppColors.inkSoft,
                            fontSize: 13,
                            fontWeight: unread
                                ? FontWeight.w700
                                : FontWeight.w600,
                            height: 1.3,
                          ),
                        ),
                        if (content != null && content.isNotEmpty) ...<Widget>[
                          const SizedBox(height: 3),
                          Text(
                            content,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AppColors.inkSoft,
                              fontSize: 12,
                              height: 1.35,
                            ),
                          ),
                        ],
                        const SizedBox(height: 7),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                NotificationVisuals.fullTime(
                                  notification.createdAt,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: AppColors.inkMuted,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                            if (notification.referenceId != null) ...<Widget>[
                              const SizedBox(width: 8),
                              const Text(
                                'Xem chi tiết',
                                style: TextStyle(
                                  color: AppColors.ocean,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const Icon(
                                Icons.chevron_right_rounded,
                                color: AppColors.ocean,
                                size: 13,
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MessageState extends StatelessWidget {
  const _MessageState({
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.actionIcon,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final IconData? actionIcon;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.72),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(icon, color: AppColors.inkMuted, size: 30),
            ),
            const SizedBox(height: 14),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.ink,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.inkMuted, fontSize: 12),
            ),
            if (onAction != null && actionLabel != null) ...<Widget>[
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: onAction,
                icon: Icon(actionIcon ?? Icons.refresh_rounded),
                label: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
