import 'package:freezed_annotation/freezed_annotation.dart';

part 'farm_location.freezed.dart';

@freezed
abstract class FarmLocation with _$FarmLocation {
  const factory FarmLocation({
    required double latitude,
    required double longitude,
    String? displayAddress,
    double? accuracyMeters,
  }) = _FarmLocation;
}
