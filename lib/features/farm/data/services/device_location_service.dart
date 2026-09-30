import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/farm/domain/entities/farm_location.dart';

abstract interface class DeviceLocationService {
  Future<FarmLocation> getCurrentLocation();
}

final class GeolocatorDeviceLocationService implements DeviceLocationService {
  const GeolocatorDeviceLocationService();

  @override
  Future<FarmLocation> getCurrentLocation() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw const ApiException(
        'Dịch vụ vị trí đang tắt. Vui lòng bật GPS rồi thử lại.',
      );
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied) {
      throw const ApiException('Bạn chưa cho phép ứng dụng truy cập vị trí.');
    }
    if (permission == LocationPermission.deniedForever) {
      throw const ApiException(
        'Quyền vị trí đã bị từ chối vĩnh viễn. Hãy cấp quyền trong cài đặt thiết bị.',
      );
    }

    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 12),
        ),
      );
      return FarmLocation(
        latitude: position.latitude,
        longitude: position.longitude,
        accuracyMeters: position.accuracy,
      );
    } on TimeoutException {
      throw const ApiException(
        'Chưa xác định được vị trí. Hãy thử ở nơi có tín hiệu GPS tốt hơn.',
      );
    } on LocationServiceDisabledException {
      throw const ApiException(
        'Dịch vụ vị trí đang tắt. Vui lòng bật GPS rồi thử lại.',
      );
    }
  }
}
