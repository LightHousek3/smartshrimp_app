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
  Future<String>? _loading;
  static final _uuidV4 = RegExp(
    r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-4[0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$',
  );

  @override
  Future<String> getOrCreate() {
    final cached = _cachedDeviceId;
    if (cached != null) return Future.value(cached);
    return _loading ??= _readOrCreate().whenComplete(() => _loading = null);
  }

  Future<String> _readOrCreate() async {
    final stored = await _storage.read(key: _deviceIdKey);
    if (stored != null && _uuidV4.hasMatch(stored)) {
      _cachedDeviceId = stored;
      return stored;
    }

    final deviceId = _uuid.v4();
    await _storage.write(key: _deviceIdKey, value: deviceId);
    _cachedDeviceId = deviceId;
    return deviceId;
  }
}
