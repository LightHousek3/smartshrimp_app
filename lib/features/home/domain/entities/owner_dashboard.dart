import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';

part 'owner_dashboard.freezed.dart';
part 'owner_dashboard.g.dart';

enum DashboardAlertKind {
  @JsonValue('URGENT_TASK')
  urgentTask,
  @JsonValue('PENDING_TREATMENT')
  pendingTreatment,
  @JsonValue('PENDING_PRODUCTION')
  pendingProduction,
  @JsonValue('LOW_STOCK')
  lowStock,
  @JsonValue('IN_TREATMENT')
  inTreatment,
  @JsonValue('MONITORING')
  monitoring,
  @JsonValue('UNKNOWN')
  unknown,
}

enum FinancePeriod {
  thisMonth('THIS_MONTH', 'Tháng này'),
  lastMonth('LAST_MONTH', 'Tháng trước'),
  sixMonths('SIX_MONTHS', '6 tháng'),
  year('YEAR', '1 năm'),
  custom('CUSTOM', 'Tùy chỉnh…');

  const FinancePeriod(this.apiValue, this.label);
  final String apiValue;
  final String label;
}

@freezed
abstract class FinanceFilter with _$FinanceFilter {
  const FinanceFilter._();
  const factory FinanceFilter({
    String? farmId,
    @Default(FinancePeriod.thisMonth) FinancePeriod period,
    DateTime? from,
    DateTime? to,
  }) = _FinanceFilter;

  Map<String, dynamic> toQuery() {
    if (period == FinancePeriod.custom &&
        (from == null || to == null || from!.isAfter(to!))) {
      throw const ApiException('Vui lòng chọn khoảng ngày hợp lệ.');
    }
    if (period == FinancePeriod.custom &&
        (to!.year - from!.year) * 12 + to!.month - from!.month + 1 > 60) {
      throw const ApiException('Khoảng thời gian không được quá 60 tháng.');
    }
    return {
      if (farmId != null) 'farmId': farmId,
      'period': period.apiValue,
      if (period == FinancePeriod.custom) ...{
        'from': dateOnly(from!),
        'to': dateOnly(to!),
      },
    };
  }
}

String dateOnly(DateTime date) =>
    '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

@freezed
abstract class DashboardSummary with _$DashboardSummary {
  @JsonSerializable(checked: true)
  const factory DashboardSummary({
    required int farms,
    required int ponds,
    required int activeSeasons,
  }) = _DashboardSummary;
  factory DashboardSummary.fromJson(Map<String, dynamic> json) =>
      _$DashboardSummaryFromJson(json);
}

@freezed
abstract class DashboardAlertPreview with _$DashboardAlertPreview {
  @JsonSerializable(checked: true)
  const factory DashboardAlertPreview({
    required String id,
    required String title,
    required String farmId,
    required String farmName,
    String? pondId,
    String? pondName,
    String? seasonId,
    String? seasonName,
    double? quantity,
    double? minAlertQuantity,
    String? unit,
  }) = _DashboardAlertPreview;
  factory DashboardAlertPreview.fromJson(Map<String, dynamic> json) =>
      _$DashboardAlertPreviewFromJson(json);
}

@freezed
abstract class DashboardAlert with _$DashboardAlert {
  @JsonSerializable(checked: true)
  const factory DashboardAlert({
    @JsonKey(unknownEnumValue: DashboardAlertKind.unknown)
    required DashboardAlertKind kind,
    required int count,
    required DashboardAlertPreview preview,
  }) = _DashboardAlert;
  factory DashboardAlert.fromJson(Map<String, dynamic> json) =>
      _$DashboardAlertFromJson(json);
}

@freezed
abstract class DashboardSeason with _$DashboardSeason {
  @JsonSerializable(checked: true)
  const factory DashboardSeason({
    required String seasonId,
    required String seasonName,
    required String pondId,
    required String pondName,
    required String farmId,
    required String farmName,
    required String shrimpType,
    int? dayOfCulture,
  }) = _DashboardSeason;
  factory DashboardSeason.fromJson(Map<String, dynamic> json) =>
      _$DashboardSeasonFromJson(json);
}

@freezed
abstract class DashboardFarm with _$DashboardFarm {
  @JsonSerializable(checked: true)
  const factory DashboardFarm({required String id, required String name}) =
      _DashboardFarm;
  factory DashboardFarm.fromJson(Map<String, dynamic> json) =>
      _$DashboardFarmFromJson(json);
}

@freezed
abstract class DashboardInventory with _$DashboardInventory {
  @JsonSerializable(checked: true)
  const factory DashboardInventory({
    required String farmId,
    required String farmName,
    required int productCount,
    required int lowStockCount,
    required double stockValue,
  }) = _DashboardInventory;
  factory DashboardInventory.fromJson(Map<String, dynamic> json) =>
      _$DashboardInventoryFromJson(json);
}

@freezed
abstract class DashboardPersonnel with _$DashboardPersonnel {
  @JsonSerializable(checked: true)
  const factory DashboardPersonnel({
    required int technicians,
    required int experts,
    required int active,
  }) = _DashboardPersonnel;
  factory DashboardPersonnel.fromJson(Map<String, dynamic> json) =>
      _$DashboardPersonnelFromJson(json);
}

@freezed
abstract class OwnerDashboard with _$OwnerDashboard {
  @JsonSerializable(checked: true)
  const factory OwnerDashboard({
    required String date,
    required DashboardSummary summary,
    required List<DashboardAlert> alerts,
    required List<DashboardSeason> seasons,
    required List<DashboardInventory> inventories,
    required List<DashboardFarm> financeFarms,
    required DashboardPersonnel personnel,
  }) = _OwnerDashboard;
  factory OwnerDashboard.fromJson(Map<String, dynamic> json) =>
      _$OwnerDashboardFromJson(json);

  static OwnerDashboard parse(Map<String, dynamic> json) {
    try {
      final value = OwnerDashboard.fromJson(json);
      _validateDate(value.date);
      final financeFarmIds = <String>{};
      for (final farm in value.financeFarms) {
        _strings([farm.id, farm.name]);
        if (!financeFarmIds.add(farm.id)) {
          throw const InvalidResponseException();
        }
      }
      _nonNegative([
        value.summary.farms,
        value.summary.ponds,
        value.summary.activeSeasons,
        value.personnel.technicians,
        value.personnel.experts,
        value.personnel.active,
      ]);
      for (final alert in value.alerts) {
        if (alert.count < 1) throw const InvalidResponseException();
        _strings([
          alert.preview.id,
          alert.preview.title,
          alert.preview.farmId,
          alert.preview.farmName,
        ]);
        if (alert.kind == DashboardAlertKind.lowStock &&
            (alert.preview.quantity == null ||
                alert.preview.minAlertQuantity == null ||
                alert.preview.unit == null)) {
          throw const InvalidResponseException();
        }
        if (alert.preview.seasonId != null) {
          _strings([
            alert.preview.seasonId,
            alert.preview.seasonName,
            alert.preview.pondId,
            if (alert.preview.pondName != null) alert.preview.pondName,
          ]);
        }
        _nonNegative([
          if (alert.preview.quantity != null) alert.preview.quantity!,
          if (alert.preview.minAlertQuantity != null)
            alert.preview.minAlertQuantity!,
        ]);
      }
      for (final season in value.seasons) {
        _strings([
          season.seasonId,
          season.seasonName,
          season.farmId,
          season.farmName,
          season.pondId,
          season.pondName,
        ]);
        if (season.dayOfCulture != null && season.dayOfCulture! < 1) {
          throw const InvalidResponseException();
        }
      }
      for (final inventory in value.inventories) {
        _strings([inventory.farmId, inventory.farmName]);
        _nonNegative([
          inventory.productCount,
          inventory.lowStockCount,
          inventory.stockValue,
        ]);
        if (inventory.lowStockCount > inventory.productCount) {
          throw const InvalidResponseException();
        }
      }
      return value;
    } on Object catch (_, stack) {
      Error.throwWithStackTrace(const InvalidResponseException(), stack);
    }
  }
}

@freezed
abstract class FinanceMonth with _$FinanceMonth {
  @JsonSerializable(checked: true)
  const factory FinanceMonth({
    required String month,
    required double income,
    required double cost,
  }) = _FinanceMonth;
  factory FinanceMonth.fromJson(Map<String, dynamic> json) =>
      _$FinanceMonthFromJson(json);
}

@freezed
abstract class FinanceTotals with _$FinanceTotals {
  @JsonSerializable(checked: true)
  const factory FinanceTotals({
    required double income,
    required double cost,
    required double profit,
  }) = _FinanceTotals;
  factory FinanceTotals.fromJson(Map<String, dynamic> json) =>
      _$FinanceTotalsFromJson(json);
}

@freezed
abstract class OwnerFinance with _$OwnerFinance {
  @JsonSerializable(checked: true)
  const factory OwnerFinance({
    required String from,
    required String to,
    required List<FinanceMonth> months,
    required FinanceTotals totals,
  }) = _OwnerFinance;
  factory OwnerFinance.fromJson(Map<String, dynamic> json) =>
      _$OwnerFinanceFromJson(json);

  static OwnerFinance parse(Map<String, dynamic> json) {
    try {
      final value = OwnerFinance.fromJson(json);
      _validateDate(value.from);
      _validateDate(value.to);
      if (value.from.compareTo(value.to) > 0 ||
          value.months.isEmpty ||
          value.months.length > 60) {
        throw const InvalidResponseException();
      }
      String? previous;
      for (final month in value.months) {
        _validateDate('${month.month}-01');
        if (previous != null && previous.compareTo(month.month) >= 0) {
          throw const InvalidResponseException();
        }
        previous = month.month;
        _nonNegative([month.income, month.cost]);
      }
      _nonNegative([value.totals.income, value.totals.cost]);
      if (!value.totals.profit.isFinite ||
          (value.totals.income - value.totals.cost - value.totals.profit)
                  .abs() >
              0.01) {
        throw const InvalidResponseException();
      }
      return value;
    } on Object catch (_, stack) {
      Error.throwWithStackTrace(const InvalidResponseException(), stack);
    }
  }
}

void _nonNegative(List<num> values) {
  if (values.any((value) => !value.isFinite || value < 0)) {
    throw const InvalidResponseException();
  }
}

void _strings(List<String?> values) {
  if (values.any((value) => value == null || value.trim().isEmpty)) {
    throw const InvalidResponseException();
  }
}

void _validateDate(String value) {
  final date = DateTime.tryParse(value);
  if (!RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(value) ||
      date == null ||
      dateOnly(date) != value) {
    throw const InvalidResponseException();
  }
}
