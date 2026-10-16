import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/widgets/app_notice.dart';
import 'package:smartshrimp_app/features/auth/presentation/view_models/auth_controller.dart';
import 'package:smartshrimp_app/features/notifications/domain/entities/app_notification.dart';
import 'package:smartshrimp_app/features/notifications/presentation/notification_navigation.dart';

class NotificationActionFooter extends ConsumerStatefulWidget {
  const NotificationActionFooter({
    required this.notification,
    this.closeBeforeNavigation = true,
    super.key,
  });
  final AppNotification notification;
  final bool closeBeforeNavigation;

  @override
  ConsumerState<NotificationActionFooter> createState() =>
      _NotificationActionFooterState();
}

class _NotificationActionFooterState
    extends ConsumerState<NotificationActionFooter> {
  bool _opening = false;

  Future<void> _open() async {
    if (_opening) return;
    final notification = widget.notification;
    final account = ref.read(authControllerProvider).value;
    if (account == null) return;
    final router = GoRouter.of(context);
    final provider = notificationReferenceContextProvider(notification.id);
    final needsContext = notificationNeedsReferenceContext(
      notification,
      account.role,
    );
    final subscription = needsContext
        ? ref.listenManual(provider, (_, _) {})
        : null;
    setState(() => _opening = true);
    try {
      final referenceContext = needsContext
          ? await ref.read(provider.future)
          : const <String, String>{};
      if (!mounted || ref.read(authControllerProvider).value?.id != account.id) {
        return;
      }
      final destination = notificationDestination(
        notification,
        account.role,
        referenceContext: referenceContext,
      );
      if (destination == null) {
        AppNoticeService.danger(
          context,
          'Nội dung liên quan không còn khả dụng hoặc bạn không có quyền truy cập.',
        );
        return;
      }
      if (widget.closeBeforeNavigation) Navigator.of(context).pop();
      router.push(destination);
    } on SessionExpiredException {
      if (mounted) ref.read(authControllerProvider.notifier).expireSession();
    } on AppException catch (error) {
      if (mounted) AppNoticeService.danger(context, error.message);
    } catch (_) {
      if (mounted) {
        AppNoticeService.danger(
          context,
          'Không thể mở nội dung liên quan. Vui lòng thử lại.',
        );
      }
    } finally {
      subscription?.close();
      if (mounted) setState(() => _opening = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final role = ref.watch(authControllerProvider).value?.role;
    final enabled =
        notificationNeedsReferenceContext(widget.notification, role) ||
        notificationDestination(widget.notification, role) != null;
    return SafeArea(
      top: false,
      minimum: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.oceanLight, AppColors.tealLight],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            key: const Key('notification_action_button'),
            onTap: enabled && !_opening ? _open : null,
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              height: 46,
              width: double.infinity,
              child: Center(
                child: _opening
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        notificationActionLabel(widget.notification, role),
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
}
