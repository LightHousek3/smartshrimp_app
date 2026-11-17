import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/core/storage/device_id_store.dart';

void main() {
  const identifier = '11111111-1111-4111-8111-111111111111';
  const key = 'smartshrimp_device_id';
  const storage = FlutterSecureStorage();

  test('preserves a valid installation ID across store instances', () async {
    FlutterSecureStorage.setMockInitialValues({key: identifier});
    expect(await SecureDeviceIdStore(storage).getOrCreate(), identifier);
    expect(await SecureDeviceIdStore(storage).getOrCreate(), identifier);
  });

  test('replaces malformed stored identifiers before sending login', () async {
    FlutterSecureStorage.setMockInitialValues({key: 'invalid-old-value'});
    final identifier = await SecureDeviceIdStore(storage).getOrCreate();
    expect(
      identifier,
      matches(
        r'^[a-f0-9]{8}-[a-f0-9]{4}-4[a-f0-9]{3}-[89ab][a-f0-9]{3}-[a-f0-9]{12}$',
      ),
    );
    expect(await storage.read(key: key), identifier);
  });

  test(
    'concurrent initialization shares one persisted installation ID',
    () async {
      FlutterSecureStorage.setMockInitialValues({});
      final store = SecureDeviceIdStore(storage);
      final identifiers = await Future.wait(
        List.generate(8, (_) => store.getOrCreate()),
      );
      expect(identifiers.toSet(), hasLength(1));
      expect(await storage.read(key: key), identifiers.first);
      expect(await store.getOrCreate(), identifiers.first);
    },
  );
}
