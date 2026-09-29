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
            const _DetailHeader(),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Color(0x260F1C2E),
                      blurRadius: 40,
                      offset: Offset(0, -12),
                      spreadRadius: -16,
                    ),
                  ],
                ),
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
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailHeader extends StatelessWidget {
  const _DetailHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 14, 16, 14),
      child: Row(
        children: <Widget>[
          Material(
            color: Colors.white.withValues(alpha: 0.7),
            shape: const CircleBorder(),
            child: IconButton(
              tooltip: 'Quay lại',
              onPressed: () => context.pop(),
              icon: Icon(
                Icons.adaptive.arrow_back,
                color: AppColors.inkSoft,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              'Chi tiết thông báo',
              style: TextStyle(
                color: AppColors.ink,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
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
    final badgeTextColor = NotificationVisuals.badgeTextColor(
      notification.type,
    );
    final content = notification.content?.trim();
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: NotificationVisuals.backgroundColor(notification.type),
                  borderRadius: BorderRadius.circular(16),
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
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
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
                          color: badgeTextColor,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          height: 1,
                        ),
                      ),
                    ),
                    const SizedBox(height: 9),
                    Text(
                      notification.title,
                      style: const TextStyle(
                        color: AppColors.ink,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (content != null && content.isNotEmpty) ...<Widget>[
            const SizedBox(height: 18),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xFFEEF1F6),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                content,
                style: const TextStyle(
                  color: AppColors.inkSoft,
                  fontSize: 13,
                  height: 1.55,
                ),
              ),
            ),
          ],
          const SizedBox(height: 18),
          const Divider(height: 1, color: Color(0xFFEEF1F7)),
          const SizedBox(height: 14),
          _TimeRow(
            label: 'Thời điểm gửi',
            value: NotificationVisuals.fullTime(notification.createdAt),
          ),
          if (notification.readAt != null) ...<Widget>[
            const SizedBox(height: 12),
            _TimeRow(
              label: 'Đã đọc lúc',
              value: NotificationVisuals.fullTime(notification.readAt!),
              icon: Icons.done_all_rounded,
            ),
          ],
        ],
      ),
    );
  }
}

class _TimeRow extends StatelessWidget {
  const _TimeRow({required this.label, required this.value, this.icon});

  final String label;
  final String value;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        if (icon != null) ...<Widget>[
          Icon(icon, color: const Color(0xFF0F9B8E), size: 15),
          const SizedBox(width: 6),
        ],
        Text(
          label,
          style: const TextStyle(color: AppColors.inkMuted, fontSize: 11),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.inkSoft,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
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
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.inkSoft),
            ),
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
