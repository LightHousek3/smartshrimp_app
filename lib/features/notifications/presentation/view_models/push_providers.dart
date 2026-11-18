import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/auth/presentation/view_models/auth_controller.dart';
import 'package:smartshrimp_app/features/notifications/presentation/view_models/push_repository_provider.dart';
import 'package:smartshrimp_app/features/notifications/domain/repositories/push_repository.dart';

final pushOpenedProvider = StreamProvider<String>(
  (ref) => ref.watch(pushRepositoryProvider).openedNotificationIds,
);
final pushEventsProvider = StreamProvider<PushPermission>(
  (ref) => ref.watch(pushRepositoryProvider).states,
);

/// Read OS permission without treating a failed push registration as denied permission.
final notificationPermissionProvider = FutureProvider<PushPermission>((ref) {
  final accountId = ref.watch(
    authControllerProvider.select((value) => value.value?.id),
  );
  if (accountId == null) return PushPermission.unavailable;
  return ref.watch(pushRepositoryProvider).permission();
});
final pushStatusProvider =
    AsyncNotifierProvider<PushStatusController, PushPermission>(
      PushStatusController.new,
    );

final class PushStatusController extends AsyncNotifier<PushPermission> {
  int _request = 0;
  Future<PushPermission>? _registration;
  @override
  Future<PushPermission> build() {
    _request++;
    final accountId = ref.watch(
      authControllerProvider.select((value) => value.value?.id),
    );
    final repository = ref.read(pushRepositoryProvider);
    if (accountId == null) {
      repository.suspend();
      return Future.value(PushPermission.unavailable);
    }
    return _registration = repository.register(accountId);
  }

  /// Resuming the App rechecks settings silently; only an explicit request asks permission again.
  Future<void> synchronize({bool requestPermission = false}) async {
    final accountId = ref.read(authControllerProvider).value?.id;
    if (accountId == null) return;
    final request = ++_request;
    // Recheck after an in-flight registration so returning from Settings is never skipped.
    final previous = _registration;
    if (previous != null) {
      try {
        await previous;
      } on Object {
        // A failed registration must not prevent a new permission check.
      }
    }
    if (!ref.mounted ||
        request != _request ||
        ref.read(authControllerProvider).value?.id != accountId) {
      return;
    }
    state = const AsyncLoading<PushPermission>();
    _registration = ref
        .read(pushRepositoryProvider)
        .register(accountId, requestPermission: requestPermission);
    final result = await AsyncValue.guard(() => _registration!);
    if (ref.mounted &&
        request == _request &&
        ref.read(authControllerProvider).value?.id == accountId) {
      state = result;
    }
  }

  void reportError(AppException error) =>
      state = AsyncError(error, StackTrace.current);
  void reportPermission(PushPermission permission) =>
      state = AsyncData(permission);
}
