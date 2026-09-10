import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';

abstract interface class DeviceIdStore {
  Future<String> getOrCreate();
}

final class SecureDeviceIdStore implements DeviceIdStore {
  SecureDeviceIdStore(this._storage, {Uuid uuid = const Uuid()}) : _uuid = uuid;

  static const _deviceIdKey = 'smartshrimp_device_id';

  final FlutterSecureStorage _storage;
  final Uuid _uuid;
  String? _cachedDeviceId;

  @override
  Future<String> getOrCreate() async {
    final cached = _cachedDeviceId;
    if (cached != null) return cached;

    final stored = await _storage.read(key: _deviceIdKey);
    if (stored != null && stored.isNotEmpty) {
      _cachedDeviceId = stored;
      return stored;
    }

    final deviceId = _uuid.v4();
    await _storage.write(key: _deviceIdKey, value: deviceId);
    _cachedDeviceId = deviceId;
    return deviceId;
  }
}
