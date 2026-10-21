import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/season/domain/entities/aquaculture_season.dart';

const harvestNoteMaxLength = 500;
const harvestTimeNotAfterLatestCode = 'HARVEST_TIME_NOT_AFTER_LATEST';

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

String? earlyHarvestWarning(AquacultureSeason season, DateTime? harvestedAt) {
  final minimum = typicalHarvestMinDays[season.shrimpType];
  final stockingDate = season.stockingDate;
  if (minimum == null || stockingDate == null || harvestedAt == null) {
    return null;
  }
  final days = vietnamHarvestDay(
    harvestedAt,
  ).difference(_stockingDay(stockingDate)).inDays;
  if (days < 0 || days >= minimum) return null;
  return 'Thu hoạch sau $days ngày nuôi, sớm hơn chu kỳ tham khảo '
      '$minimum ngày của ${shrimpTypeLabel(season.shrimpType).toLowerCase()}. '
      'Bạn vẫn có thể ghi nhận thu hoạch theo tình trạng thực tế.';
}
