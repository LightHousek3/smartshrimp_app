import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/season/domain/entities/aquaculture_season.dart';

const harvestNoteMaxLength = 500;
const harvestTimeNotAfterLatestCode = 'HARVEST_TIME_NOT_AFTER_LATEST';

const _speciesThresholds = {
  ShrimpType.whiteleg: (
    size: (10, 20, 150, 500),
    price: (70000, 250000),
    docWarningThrough: 35,
  ),
  ShrimpType.blackTiger: (
    size: (4, 10, 65, 200),
    price: (120000, 450000),
    docWarningThrough: 55,
  ),
};

const harvestUnusualSizeWarning =
    'Cỡ tôm tính từ số lượng và sản lượng nằm ngoài khoảng 10–500 con/kg. Vui lòng kiểm tra lại trước khi lưu.';

/// Match the server's half-up rounding using integer count and grams.
double roundedHarvestSize(num count, num weightKg) {
  final grams = BigInt.from((weightKg * 1000).round());
  final numerator = BigInt.from(count) * BigInt.from(100000);
  return ((numerator + grams ~/ BigInt.two) ~/ grams).toDouble() / 100;
}

(int, int) harvestSizeLimits(ShrimpType species, {required bool enabled}) {
  final ranges = enabled ? _speciesThresholds[species] : null;
  if (ranges == null) return (1, 10000);
  final (min, _, _, max) = ranges.size;
  return (min, max);
}

String? harvestSizeWarning(
  num count,
  num weight,
  ShrimpType species, {
  required bool enabled,
}) {
  final ranges = enabled ? _speciesThresholds[species] : null;
  if (ranges == null) {
    final size = count / weight;
    return size < 10 || size > 500 ? harvestUnusualSizeWarning : null;
  }
  final (_, min, max, _) = ranges.size;
  final size = roundedHarvestSize(count, weight);
  return size < min || size > max
      ? 'Cỡ tôm nằm ngoài khoảng thường gặp $min–$max con/kg. Kiểm tra lại khối lượng hoặc số con.'
      : null;
}

String? harvestPriceError(num? price, {required bool enabled}) =>
    enabled && price != null && price != 0 && (price < 10000 || price > 1000000)
    ? 'Đơn giá phải từ 10.000 đến 1.000.000 đ/kg, hoặc bằng 0 khi khai rõ không có doanh thu.'
    : null;

String? harvestPriceWarning(
  num? price,
  ShrimpType species, {
  required bool enabled,
}) {
  final ranges = enabled ? _speciesThresholds[species] : null;
  if (ranges == null || price == null || price == 0) return null;
  final (min, max) = ranges.price;
  return price < min || price > max
      ? 'Đơn giá nằm ngoài khoảng thường gặp của loài tôm này. Vui lòng kiểm tra lại.'
      : null;
}

// Only this permanent server rejection confirms an uncertain write cannot commit.
bool isConfirmedHarvestTimeRejection(Object error) =>
    error is AppException &&
    error.statusCode == 400 &&
    error.details is Map &&
    (error.details as Map)['code'] == harvestTimeNotAfterLatestCode;

// Match JavaScript UTF-16 length; Flutter's input limit counts graphemes instead.
String? validateHarvestTextLength(
  String? value, {
  required String label,
  required int maxLength,
}) => (value?.trim().length ?? 0) > maxLength
    ? '$label tối đa $maxLength ký tự.'
    : null;

String? validateHarvestNote(String? note) => validateHarvestTextLength(
  note,
  label: 'Ghi chú thu hoạch',
  maxLength: harvestNoteMaxLength,
);

// Advisory defaults aligned with BE SHRIMP_CULTIVATION. These never block saving.
const typicalHarvestMinDays = {
  ShrimpType.whiteleg: int.fromEnvironment(
    'HARVEST_WHITELEG_WARNING_MIN_DAYS',
    defaultValue: 90,
  ),
  ShrimpType.blackTiger: int.fromEnvironment(
    'HARVEST_BLACK_TIGER_WARNING_MIN_DAYS',
    defaultValue: 120,
  ),
};

// Harvest timestamps are instants; stocking dates are calendar dates from the API.
DateTime vietnamHarvestDay(DateTime instant) {
  final vietnam = instant.toUtc().add(const Duration(hours: 7));
  return DateTime.utc(vietnam.year, vietnam.month, vietnam.day);
}

DateTime _stockingDay(DateTime date) =>
    DateTime.utc(date.year, date.month, date.day);

String? validateHarvestTime(
  DateTime? harvestedAt,
  DateTime? stockingDate, {
  DateTime? now,
}) {
  if (harvestedAt == null) return 'Vui lòng chọn thời điểm thu hoạch.';
  if (harvestedAt.isAfter(now ?? DateTime.now())) {
    return 'Thời điểm thu hoạch không được ở tương lai.';
  }
  if (stockingDate != null &&
      vietnamHarvestDay(harvestedAt).isBefore(_stockingDay(stockingDate))) {
    return 'Ngày thu hoạch không được trước ngày thả giống.';
  }
  return null;
}

String? earlyHarvestWarning(
  AquacultureSeason season,
  DateTime? harvestedAt, {
  bool speciesThresholdsEnabled = false,
}) {
  final minimum = typicalHarvestMinDays[season.shrimpType];
  final stockingDate = season.stockingDate;
  if (minimum == null || stockingDate == null || harvestedAt == null) {
    return null;
  }
  final days = vietnamHarvestDay(
    harvestedAt,
  ).difference(_stockingDay(stockingDate)).inDays;
  final ranges = speciesThresholdsEnabled
      ? _speciesThresholds[season.shrimpType]
      : null;
  if (ranges != null) {
    if (days < 0 || days > ranges.docWarningThrough) return null;
    return 'Vụ nuôi mới $days ngày. '
        'Kiểm tra tình trạng thực tế trước khi ghi nhận thu hoạch.';
  }
  if (days < 0 || days >= minimum) return null;
  return 'Thu hoạch sau $days ngày nuôi, sớm hơn chu kỳ tham khảo '
      '$minimum ngày của ${shrimpTypeLabel(season.shrimpType).toLowerCase()}. '
      'Bạn vẫn có thể ghi nhận thu hoạch theo tình trạng thực tế.';
}
