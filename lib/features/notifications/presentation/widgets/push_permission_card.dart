import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/notifications/domain/repositories/push_repository.dart';
import 'package:smartshrimp_app/features/notifications/presentation/view_models/push_providers.dart';
import 'package:smartshrimp_app/features/notifications/presentation/view_models/push_repository_provider.dart';

/// Permission and registration problems never replace the persisted inbox state.
class PushPermissionCard extends ConsumerWidget {
  const PushPermissionCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(pushStatusProvider);
    final permission = state.asData?.value;
    if ((state.isLoading && !state.hasValue && !state.hasError) ||
        [
          PushPermission.unavailable,
          PushPermission.authorized,
          PushPermission.provisional,
        ].contains(permission)) {
      return const SizedBox.shrink();
    }
    final denied = permission == PushPermission.denied;
    final error = state.error;
    final text = state.isLoading
        ? 'Đang kiểm tra khả năng nhận thông báo…'
        : error is AppException
        ? error.message
        : denied
        ? 'Bật quyền thông báo trong Cài đặt để nhận thông báo trên thiết bị.'
        : permission == PushPermission.pending
        ? 'Đang chờ thiết bị đăng ký nhận thông báo.'
        : 'Chưa thể nhận thông báo trên thiết bị. Bạn vẫn có thể xem thông báo tại đây.';
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Icon(Icons.notifications_off_outlined),
          const SizedBox(width: 10),
          Expanded(child: Text(text)),
          TextButton(
            onPressed: state.isLoading
                ? null
                : () async {
                    if (denied) {
                      await ref.read(pushRepositoryProvider).openSettings();
                    } else {
                      await ref
                          .read(pushStatusProvider.notifier)
                          .synchronize(requestPermission: true);
                    }
                  },
            child: state.isLoading
                ? const SizedBox.square(
                    dimension: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(denied ? 'Cài đặt' : 'Thử lại'),
          ),
        ],
      ),
    );
  }
}
