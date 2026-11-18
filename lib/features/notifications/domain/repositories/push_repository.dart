enum PushPermission {
  unavailable,
  unconfigured,
  pending,
  denied,
  authorized,
  provisional,
}

abstract interface class PushRepository {
  Stream<String> get openedNotificationIds;
  Stream<PushPermission> get states;

  Future<PushPermission> permission();

  Future<PushPermission> register(
    String accountId, {
    bool requestPermission = true,
  });

  void suspend();
  Future<void> openSettings();

  Future<void> unregister();

  Future<void> dispose();
}
