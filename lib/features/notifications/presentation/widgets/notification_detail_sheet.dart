import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/notifications/domain/entities/app_notification.dart';
import 'package:smartshrimp_app/features/notifications/presentation/view_models/notification_controller.dart';
import 'package:smartshrimp_app/features/notifications/presentation/widgets/notification_visuals.dart';

Future<void> showNotificationDetailSheet({
  required BuildContext context,
  required String notificationId,
}) => showModalBottomSheet<void>(
  context: context,
  useRootNavigator: true,
  useSafeArea: true,
  isScrollControlled: true,
  backgroundColor: Colors.transparent,
  barrierColor: const Color(0x990F1C2E),
  constraints: BoxConstraints(
    maxWidth: 560,
    maxHeight: MediaQuery.sizeOf(context).height * 0.86,
  ),
  builder: (_) => _NotificationDetailSheet(notificationId: notificationId),
);

class _NotificationDetailSheet extends ConsumerWidget {
  const _NotificationDetailSheet({required this.notificationId});

  final String notificationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailState = ref.watch(notificationDetailProvider(notificationId));
    return Container(
      key: const Key('notification_detail_sheet'),
      width: double.infinity,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.86,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Color(0x330F1C2E),
            blurRadius: 28,
            offset: Offset(0, -8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const _SheetHeader(),
          const Divider(height: 1, color: Color(0xFFEEF1F7)),
          detailState.when(
            loading: () => const _LoadingContent(),
            error: (error, _) => _ErrorContent(
              message: error is AppException
                  ? error.message
                  : 'Không thể tải chi tiết thông báo. Vui lòng thử lại.',
              onRetry: () =>
                  ref.invalidate(notificationDetailProvider(notificationId)),
            ),
            data: (notification) => Flexible(
              fit: FlexFit.loose,
              child: _LoadedContent(notification: notification),
            ),
          ),
        ],
      ),
    );
  }
}

class _SheetHeader extends StatelessWidget {
  const _SheetHeader();

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 12, 12, 10),
    child: Row(
      children: <Widget>[
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
        Material(
          color: const Color(0xFFEEF1F6),
          shape: const CircleBorder(),
          child: IconButton(
            key: const Key('close_notification_detail'),
            tooltip: 'Đóng',
            visualDensity: VisualDensity.compact,
            onPressed: Navigator.of(context).pop,
            icon: const Icon(
              Icons.close_rounded,
              color: AppColors.inkMuted,
              size: 19,
            ),
          ),
        ),
      ],
    ),
  );
}

class _LoadedContent extends StatelessWidget {
  const _LoadedContent({required this.notification});

  final AppNotification notification;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      Flexible(
        fit: FlexFit.loose,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
          child: _NotificationInformation(notification: notification),
        ),
      ),
      const Divider(height: 1, color: Color(0xFFEEF1F7)),
      _ActionFooter(notification: notification),
    ],
  );
}

class _NotificationInformation extends StatelessWidget {
  const _NotificationInformation({required this.notification});

  final AppNotification notification;

  @override
  Widget build(BuildContext context) {
    final accent = NotificationVisuals.color(notification.type);
    final content = notification.content?.trim();
    return Column(
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
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(
                NotificationVisuals.icon(notification.type),
                color: accent,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                  const SizedBox(height: 8),
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
          const SizedBox(height: 15),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
            decoration: BoxDecoration(
              color: const Color(0xFFEEF1F6),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              content,
              style: const TextStyle(
                color: AppColors.inkSoft,
                fontSize: 12.5,
                height: 1.5,
              ),
            ),
          ),
        ],
        const SizedBox(height: 15),
        const Divider(height: 1, color: Color(0xFFEEF1F7)),
        const SizedBox(height: 12),
        Row(
          children: <Widget>[
            const Text(
              'Thời điểm gửi',
              style: TextStyle(color: AppColors.inkMuted, fontSize: 10.5),
            ),
            const Spacer(),
            Text(
              NotificationVisuals.fullTime(notification.createdAt),
              style: const TextStyle(
                color: AppColors.inkSoft,
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ActionFooter extends StatelessWidget {
  const _ActionFooter({required this.notification});

  final AppNotification notification;

  @override
  Widget build(BuildContext context) => SafeArea(
    top: false,
    minimum: const EdgeInsets.fromLTRB(16, 10, 16, 10),
    child: DecoratedBox(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: <Color>[AppColors.oceanLight, AppColors.tealLight],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          key: const Key('notification_action_button'),
          // The destination will be wired when the related feature is ready.
          onTap: () {},
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            height: 46,
            width: double.infinity,
            child: Center(
              child: Text(
                NotificationVisuals.actionLabel(notification.type),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

class _LoadingContent extends StatelessWidget {
  const _LoadingContent();

  @override
  Widget build(BuildContext context) => const SizedBox(
    height: 240,
    child: Center(
      child: CircularProgressIndicator(color: AppColors.ocean, strokeWidth: 2),
    ),
  );
}

class _ErrorContent extends StatelessWidget {
  const _ErrorContent({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(24),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const Icon(
          Icons.cloud_off_outlined,
          color: AppColors.inkMuted,
          size: 38,
        ),
        const SizedBox(height: 10),
        Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.inkSoft, fontSize: 13),
        ),
        const SizedBox(height: 8),
        TextButton.icon(
          onPressed: onRetry,
          icon: const Icon(Icons.refresh_rounded, size: 18),
          label: const Text('Thử lại'),
        ),
      ],
    ),
  );
}
