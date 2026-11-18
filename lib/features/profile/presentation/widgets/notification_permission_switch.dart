import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/widgets/app_dialog.dart';
import 'package:smartshrimp_app/core/widgets/app_notice.dart';
import 'package:smartshrimp_app/features/auth/presentation/view_models/auth_controller.dart';
import 'package:smartshrimp_app/features/notifications/domain/repositories/push_repository.dart';
import 'package:smartshrimp_app/features/notifications/presentation/view_models/push_providers.dart';
import 'package:smartshrimp_app/features/notifications/presentation/view_models/push_repository_provider.dart';

class NotificationPermissionSwitch extends ConsumerStatefulWidget {
  const NotificationPermissionSwitch({super.key});

  @override
  ConsumerState<NotificationPermissionSwitch> createState() =>
      _NotificationPermissionSwitchState();
}

class _NotificationPermissionSwitchState
    extends ConsumerState<NotificationPermissionSwitch> {
  bool _openingSettings = false;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(notificationPermissionProvider);
    if (state.isLoading) {
      return const SizedBox.square(
        dimension: 22,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: AppColors.ocean,
        ),
      );
    }
    if (state.hasError) {
      return IconButton(
        tooltip: 'Không thể kiểm tra quyền thông báo. Nhấn để thử lại.',
        icon: const Icon(Icons.refresh_rounded, color: AppColors.ocean),
        onPressed: () => ref.invalidate(notificationPermissionProvider),
      );
    }
    final permission = state.value;
    final enabled =
        permission == PushPermission.authorized ||
        permission == PushPermission.provisional;
    final supported = enabled || permission == PushPermission.denied;
    return Tooltip(
      message: supported
          ? 'Quyền thông báo của SmartShrimp trên thiết bị'
          : 'Cài đặt thông báo chỉ hỗ trợ trên ứng dụng điện thoại.',
      child: Semantics(
        label: 'Cho phép thông báo',
        child: Switch.adaptive(
          key: const Key('account_notification_switch'),
          value: enabled,
          activeThumbColor: AppColors.ocean,
          onChanged: supported && !_openingSettings ? _changePermission : null,
        ),
      ),
    );
  }

  /// Only the OS settings screen can change an already decided notification permission.
  Future<void> _changePermission(bool enable) async {
    if (_openingSettings) return;
    final accountId = ref.read(authControllerProvider).value?.id;
    if (accountId == null) return;
    setState(() => _openingSettings = true);
    try {
      final confirmed = await showDialog<bool>(
        context: context,
        barrierColor: AppColors.ink.withValues(alpha: 0.35),
        builder: (dialogContext) => AppConfirmDialog(
          title: enable ? 'Bật thông báo' : 'Tắt thông báo',
          description: enable
              ? 'Mở Cài đặt trên điện thoại, chọn Thông báo và bật quyền cho SmartShrimp. Ứng dụng sẽ cập nhật khi bạn quay lại.'
              : 'Mở Cài đặt trên điện thoại, chọn Thông báo và tắt quyền cho SmartShrimp. Bạn vẫn có thể xem thông báo trong ứng dụng.',
          icon: enable
              ? Icons.notifications_active_outlined
              : Icons.notifications_off_outlined,
          level: AppNoticeLevel.info,
          confirmLabel: 'Mở cài đặt',
          cancelLabel: 'Để sau',
          onConfirm: () => Navigator.of(dialogContext).pop(true),
        ),
      );
      if (!mounted ||
          confirmed != true ||
          ref.read(authControllerProvider).value?.id != accountId) {
        return;
      }
      await ref.read(pushRepositoryProvider).openSettings();
    } on AppException catch (error) {
      if (mounted) AppNoticeService.danger(context, error.message);
    } on Object {
      if (mounted) {
        AppNoticeService.danger(
          context,
          'Không thể mở Cài đặt thông báo. Vui lòng thử lại.',
        );
      }
    } finally {
      if (mounted) setState(() => _openingSettings = false);
    }
  }
}
