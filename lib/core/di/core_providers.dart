import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:smartshrimp_app/core/config/app_config.dart';
import 'package:smartshrimp_app/core/network/api_client.dart';
import 'package:smartshrimp_app/core/storage/device_id_store.dart';
import 'package:smartshrimp_app/core/storage/session_store.dart';

final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});

final sessionStoreProvider = Provider<SessionStore>((ref) {
  return SecureSessionStore(ref.watch(secureStorageProvider));
});

final deviceIdStoreProvider = Provider<DeviceIdStore>((ref) {
  return SecureDeviceIdStore(ref.watch(secureStorageProvider));
});

final backendDioProvider = Provider<Dio>((ref) {
  return Dio(
    BaseOptions(
      baseUrl: AppConfig.apiBaseUrl,
      connectTimeout: AppConfig.connectTimeout,
      receiveTimeout: AppConfig.receiveTimeout,
      headers: const <String, Object>{
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ),
  );
});

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(
    ref.watch(backendDioProvider),
    ref.watch(sessionStoreProvider),
  );
});

final cloudinaryDioProvider = Provider<Dio>((ref) {
  return Dio(
    BaseOptions(
      connectTimeout: AppConfig.connectTimeout,
      receiveTimeout: AppConfig.receiveTimeout,
      sendTimeout: AppConfig.receiveTimeout,
      headers: const <String, Object>{'Accept': 'application/json'},
    ),
  );
});
