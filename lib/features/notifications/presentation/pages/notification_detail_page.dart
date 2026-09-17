import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/widgets/app_gradient_background.dart';
import 'package:smartshrimp_app/features/notifications/domain/entities/app_notification.dart';
import 'package:smartshrimp_app/features/notifications/presentation/view_models/notification_controller.dart';
import 'package:smartshrimp_app/features/notifications/presentation/widgets/notification_visuals.dart';

class NotificationDetailPage extends ConsumerWidget {
  const NotificationDetailPage({required this.notificationId, super.key});

  final String notificationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailState = ref.watch(notificationDetailProvider(notificationId));
    return AppGradientBackground(
      child: SafeArea(
        bottom: false,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
              child: Row(
                children: <Widget>[
                  Material(
                    color: Colors.white.withValues(alpha: 0.88),
                    shape: const CircleBorder(),
                    child: IconButton(
                      tooltip: 'Quay lại',
                      onPressed: () => context.pop(),
                      icon: const Icon(
                        Icons.chevron_left_rounded,
                        color: AppColors.inkSoft,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'Chi tiết thông báo',
                      style: TextStyle(
                        color: AppColors.ink,
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: detailState.when(
                loading: () => const Center(
                  child: CircularProgressIndicator(color: AppColors.ocean),
                ),
                error: (error, _) => _DetailError(
                  message: error is AppException
                      ? error.message
                      : 'Không thể tải chi tiết thông báo. Vui lòng thử lại.',
                  onRetry: () => ref.invalidate(
                    notificationDetailProvider(notificationId),
                  ),
                ),
                data: (notification) =>
                    _DetailContent(notification: notification),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailContent extends StatelessWidget {
  const _DetailContent({required this.notification});

  final AppNotification notification;

  @override
  Widget build(BuildContext context) {
    final accent = NotificationVisuals.color(notification.type);
    final content = notification.content?.trim();
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 30),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: const Color(0xFFE3EBF4)),
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: Color(0x140F1C2E),
              blurRadius: 20,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.11),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(
                    NotificationVisuals.icon(notification.type),
                    color: accent,
                    size: 25,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        NotificationVisuals.label(notification.type),
                        style: TextStyle(
                          color: accent,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        NotificationVisuals.fullTime(notification.createdAt),
                        style: const TextStyle(
                          color: AppColors.inkMuted,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),
            Text(
              notification.title,
              style: const TextStyle(
                color: AppColors.ink,
                fontSize: 21,
                fontWeight: FontWeight.w800,
                height: 1.3,
              ),
            ),
            if (content != null && content.isNotEmpty) ...<Widget>[
              const SizedBox(height: 16),
              Text(
                content,
                style: const TextStyle(
                  color: AppColors.inkSoft,
                  fontSize: 15,
                  height: 1.55,
                ),
              ),
            ],
            if (notification.readAt != null) ...<Widget>[
              const SizedBox(height: 22),
              const Divider(height: 1, color: AppColors.line),
              const SizedBox(height: 16),
              Row(
                children: <Widget>[
                  const Icon(
                    Icons.done_all_rounded,
                    color: Color(0xFF159168),
                    size: 16,
                  ),
                  const SizedBox(width: 7),
                  Expanded(
                    child: Text(
                      'Đã đọc lúc ${NotificationVisuals.fullTime(notification.readAt!)}',
                      style: const TextStyle(
                        color: AppColors.inkMuted,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _DetailError extends StatelessWidget {
  const _DetailError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(
              Icons.cloud_off_outlined,
              color: AppColors.inkMuted,
              size: 44,
            ),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Thử lại'),
            ),
          ],
        ),
      ),
    );
  }
}
