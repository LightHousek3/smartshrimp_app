import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshrimp_app/app/router/app_router.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/widgets/app_gradient_background.dart';
import 'package:smartshrimp_app/features/notifications/domain/entities/app_notification.dart';
import 'package:smartshrimp_app/features/notifications/domain/repositories/notification_repository.dart';
import 'package:smartshrimp_app/features/notifications/presentation/view_models/notification_controller.dart';
import 'package:smartshrimp_app/features/notifications/presentation/widgets/notification_visuals.dart';

class NotificationListPage extends ConsumerStatefulWidget {
  const NotificationListPage({super.key});

  @override
  ConsumerState<NotificationListPage> createState() =>
      _NotificationListPageState();
}

class _NotificationListPageState extends ConsumerState<NotificationListPage> {
  NotificationReadStatus _filter = NotificationReadStatus.all;
  bool _loadingMore = false;
  String? _loadMoreError;

  @override
  Widget build(BuildContext context) {
    final provider = notificationListProvider(_filter);
    final listState = ref.watch(provider);

    return AppGradientBackground(
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const _ListHeader(),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 3, 16, 18),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: <Widget>[
                    for (final filter in NotificationReadStatus.values) ...[
                      _FilterChip(
                        label: switch (filter) {
                          NotificationReadStatus.all => 'Tất cả',
                          NotificationReadStatus.unread => 'Chưa đọc',
                          NotificationReadStatus.read => 'Đã đọc',
                        },
                        selected: _filter == filter,
                        onTap: () {
                          if (_filter == filter) return;
                          setState(() {
                            _filter = filter;
                            _loadMoreError = null;
                            _loadingMore = false;
                          });
                        },
                      ),
                      const SizedBox(width: 8),
                    ],
                  ],
                ),
              ),
            ),
            Expanded(
              child: listState.when(
                loading: () => const Center(
                  child: CircularProgressIndicator(color: AppColors.ocean),
                ),
                error: (error, _) => _MessageState(
                  icon: Icons.cloud_off_outlined,
                  title: 'Không thể tải thông báo',
                  message: _errorMessage(error),
                  actionLabel: 'Thử lại',
                  onAction: () => ref.read(provider.notifier).refresh(),
                ),
                data: (page) => page.items.isEmpty
                    ? _MessageState(
                        icon: _filter == NotificationReadStatus.unread
                            ? Icons.mark_email_read_outlined
                            : Icons.notifications_none_rounded,
                        title: _filter == NotificationReadStatus.unread
                            ? 'Bạn đã xem hết thông báo'
                            : 'Chưa có thông báo',
                        message: _filter == NotificationReadStatus.read
                            ? 'Các thông báo đã xem sẽ xuất hiện ở đây.'
                            : _filter == NotificationReadStatus.unread
                            ? 'Hiện không có thông báo nào chưa đọc.'
                            : 'Thông báo mới sẽ xuất hiện tại đây.',
                      )
                    : RefreshIndicator(
                        color: AppColors.ocean,
                        onRefresh: () => ref.read(provider.notifier).refresh(),
                        child: ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 26),
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(bottom: 11),
                              child: Row(
                                children: <Widget>[
                                  const Expanded(
                                    child: Text(
                                      'Hoạt động gần đây',
                                      style: TextStyle(
                                        color: AppColors.ink,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '${page.totalResults} thông báo',
                                    style: const TextStyle(
                                      color: AppColors.inkMuted,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            for (final notification in page.items) ...[
                              _NotificationCard(
                                notification: notification,
                                onTap: () => context.push(
                                  '${AppRoutes.notifications}/${notification.id}',
                                ),
                              ),
                              const SizedBox(height: 10),
                            ],
                            if (_loadMoreError != null) ...[
                              Text(
                                _loadMoreError!,
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: AppColors.error),
                              ),
                              const SizedBox(height: 8),
                            ],
                            if (page.hasNextPage)
                              Center(
                                child: OutlinedButton.icon(
                                  onPressed: _loadingMore
                                      ? null
                                      : () => _loadMore(provider),
                                  icon: _loadingMore
                                      ? const SizedBox.square(
                                          dimension: 16,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : const Icon(Icons.expand_more_rounded),
                                  label: Text(
                                    _loadingMore ? 'Đang tải...' : 'Xem thêm',
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
              ),
            ),
          ],
        ),
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

  static String _errorMessage(Object error) => error is AppException
      ? error.message
      : 'Có lỗi xảy ra. Vui lòng thử lại.';
}

class _ListHeader extends StatelessWidget {
  const _ListHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 18),
      child: Row(
        children: <Widget>[
          IconButton.filledTonal(
            tooltip: 'Về Trang chủ',
            onPressed: () => context.go(AppRoutes.home),
            icon: const Icon(Icons.arrow_back_rounded),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Thông báo',
                  style: TextStyle(
                    color: AppColors.ink,
                    fontSize: 27,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Theo dõi những cập nhật dành cho bạn',
                  style: TextStyle(color: AppColors.inkSoft, fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.86),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.white),
            ),
            child: const Icon(
              Icons.notifications_active_outlined,
              color: AppColors.ocean,
              size: 24,
            ),
          ),
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
            ? AppColors.ocean
            : Colors.white.withValues(alpha: 0.86),
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 11),
            child: Text(
              label,
              style: TextStyle(
                color: selected ? Colors.white : AppColors.inkSoft,
                fontWeight: FontWeight.w700,
                fontSize: 13,
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
          color: unread ? const Color(0xFFFFFAEF) : Colors.white,
          borderRadius: BorderRadius.circular(18),
          child: InkWell(
            key: Key('notification_${notification.id}'),
            borderRadius: BorderRadius.circular(18),
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: unread ? const Color(0xFFF2DEAA) : AppColors.line,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: accent.withValues(alpha: 0.11),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Icon(
                      NotificationVisuals.icon(notification.type),
                      color: accent,
                      size: 21,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                NotificationVisuals.label(notification.type),
                                style: TextStyle(
                                  color: accent,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              NotificationVisuals.shortTime(
                                notification.createdAt,
                                DateTime.now(),
                              ),
                              style: const TextStyle(
                                color: AppColors.inkMuted,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          notification.title,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: unread ? AppColors.ink : AppColors.inkSoft,
                            fontSize: 14,
                            fontWeight: unread
                                ? FontWeight.w800
                                : FontWeight.w600,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Padding(
                    padding: const EdgeInsets.only(top: 3),
                    child: unread
                        ? const Icon(
                            Icons.priority_high_rounded,
                            size: 16,
                            color: Color(0xFFE5A32D),
                          )
                        : const Icon(
                            Icons.check_rounded,
                            size: 15,
                            color: Color(0xFF159168),
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
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
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
              width: 70,
              height: 70,
              decoration: const BoxDecoration(
                color: Color(0xFFEAF4FF),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColors.ocean, size: 34),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.ink,
                fontSize: 17,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.inkSoft),
            ),
            if (onAction != null && actionLabel != null) ...[
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: onAction,
                icon: const Icon(Icons.refresh_rounded),
                label: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
