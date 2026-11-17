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
final pushStatusProvider =
    AsyncNotifierProvider<PushStatusController, PushPermission>(
      PushStatusController.new,
    );

final class PushStatusController extends AsyncNotifier<PushPermission> {
  int _request = 0;
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
    return repository.register(accountId);
  }

  /// Resuming the App rechecks settings silently; only an explicit request asks permission again.
  Future<void> synchronize({bool requestPermission = false}) async {
    final accountId = ref.read(authControllerProvider).value?.id;
    if (accountId == null || state.isLoading) return;
    final request = ++_request;
    state = const AsyncLoading<PushPermission>();
    final result = await AsyncValue.guard(
      () => ref
          .read(pushRepositoryProvider)
          .register(accountId, requestPermission: requestPermission),
    );
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
