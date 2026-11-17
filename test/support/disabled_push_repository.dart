import 'package:smartshrimp_app/features/notifications/domain/repositories/push_repository.dart';

/// Screen tests isolate native messaging; registration policy has dedicated transport tests.
final class DisabledPushRepository implements PushRepository {
  const DisabledPushRepository({
    this.openedNotificationIds = const Stream.empty(),
  });
  @override
  final Stream<String> openedNotificationIds;
  @override
  Stream<PushPermission> get states => const Stream.empty();
  @override
  Future<PushPermission> register(
    String accountId, {
    bool requestPermission = true,
  }) async => PushPermission.unavailable;
  @override
  void suspend() {}
  @override
  Future<void> unregister() async {}
  @override
  Future<void> openSettings() async {}
  @override
  Future<void> dispose() async {}
}
