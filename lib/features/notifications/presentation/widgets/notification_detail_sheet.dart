import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/notifications/domain/entities/app_notification.dart';
import 'package:smartshrimp_app/features/notifications/presentation/view_models/notification_controller.dart';
import 'package:smartshrimp_app/features/notifications/presentation/widgets/notification_visuals.dart';
import 'package:smartshrimp_app/features/notifications/presentation/widgets/notification_action_footer.dart';

Future<void> showNotificationDetailSheet({
  required BuildContext context,
  required AppNotification notification,
}) {
  final router = GoRouter.maybeOf(context);
  if (router != null) {
    return router.push<void>(
      '/notifications/${Uri.encodeComponent(notification.id)}',
      extra: notification,
    );
  }
  return Navigator.of(context, rootNavigator: true).push<void>(
    _detailRoute(
      context,
      notificationId: notification.id,
      notification: notification,
    ),
  );
}

/// Router-backed links and list taps share one modal route, including Back and drag dismissal.
class NotificationDetailSheetPage extends Page<void> {
  const NotificationDetailSheetPage({
    required this.notificationId,
    this.notification,
    super.key,
  });

  final String notificationId;
  final AppNotification? notification;

  @override
  Route<void> createRoute(BuildContext context) => _detailRoute(
    context,
    notificationId: notificationId,
    notification: notification,
    settings: this,
  );
}

ModalBottomSheetRoute<void> _detailRoute(
  BuildContext context, {
  required String notificationId,
  AppNotification? notification,
  RouteSettings? settings,
}) => ModalBottomSheetRoute<void>(
  settings: settings,
  capturedThemes: InheritedTheme.capture(
    from: context,
    to: Navigator.of(context, rootNavigator: true).context,
  ),
  barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
  useSafeArea: true,
  isScrollControlled: true,
  backgroundColor: Colors.transparent,
  modalBarrierColor: const Color(0x990F1C2E),
  constraints: BoxConstraints(
    maxWidth: 560,
    maxHeight: MediaQuery.sizeOf(context).height * 0.86,
  ),
  builder: (_) => _NotificationDetailSheet(
    notificationId: notificationId,
    notification: notification,
  ),
);

class _NotificationDetailSheet extends ConsumerWidget {
  const _NotificationDetailSheet({
    required this.notificationId,
    this.notification,
  });

  final String notificationId;
  final AppNotification? notification;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailProvider = notificationDetailProvider(notificationId);
    final detail = ref.watch(detailProvider);
    final current = detail.asData?.value ?? notification;
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
          if (detail.hasError)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      current != null
                          ? 'Chưa thể cập nhật trạng thái đã đọc.'
                          : detail.error is AppException
                          ? (detail.error! as AppException).message
                          : 'Không thể tải chi tiết thông báo. Vui lòng thử lại.',
                    ),
                  ),
                  TextButton(
                    key: const Key('retry_notification_read'),
                    onPressed: () => ref.invalidate(detailProvider),
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            ),
          if (current != null)
            Flexible(
              fit: FlexFit.loose,
              child: _LoadedContent(notification: current),
            )
          else if (detail.isLoading)
            const SizedBox(
              height: 160,
              child: Center(
                child: CircularProgressIndicator(color: AppColors.ocean),
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
      NotificationActionFooter(notification: notification),
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
