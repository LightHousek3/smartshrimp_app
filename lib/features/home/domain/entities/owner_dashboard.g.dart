// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'owner_dashboard.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DashboardSummary _$DashboardSummaryFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_DashboardSummary', json, ($checkedConvert) {
      final val = _DashboardSummary(
        farms: $checkedConvert('farms', (v) => (v as num).toInt()),
        ponds: $checkedConvert('ponds', (v) => (v as num).toInt()),
        activeSeasons: $checkedConvert(
          'activeSeasons',
          (v) => (v as num).toInt(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$DashboardSummaryToJson(_DashboardSummary instance) =>
    <String, dynamic>{
      'farms': instance.farms,
      'ponds': instance.ponds,
      'activeSeasons': instance.activeSeasons,
    };

_DashboardAlertPreview _$DashboardAlertPreviewFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('_DashboardAlertPreview', json, ($checkedConvert) {
  final val = _DashboardAlertPreview(
    id: $checkedConvert('id', (v) => v as String),
    title: $checkedConvert('title', (v) => v as String),
    farmId: $checkedConvert('farmId', (v) => v as String),
    farmName: $checkedConvert('farmName', (v) => v as String),
    pondId: $checkedConvert('pondId', (v) => v as String?),
    pondName: $checkedConvert('pondName', (v) => v as String?),
    seasonId: $checkedConvert('seasonId', (v) => v as String?),
    seasonName: $checkedConvert('seasonName', (v) => v as String?),
    quantity: $checkedConvert('quantity', (v) => (v as num?)?.toDouble()),
    minAlertQuantity: $checkedConvert(
      'minAlertQuantity',
      (v) => (v as num?)?.toDouble(),
    ),
    unit: $checkedConvert('unit', (v) => v as String?),
  );
  return val;
});

Map<String, dynamic> _$DashboardAlertPreviewToJson(
  _DashboardAlertPreview instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'farmId': instance.farmId,
  'farmName': instance.farmName,
  'pondId': instance.pondId,
  'pondName': instance.pondName,
  'seasonId': instance.seasonId,
  'seasonName': instance.seasonName,
  'quantity': instance.quantity,
  'minAlertQuantity': instance.minAlertQuantity,
  'unit': instance.unit,
};

_DashboardAlert _$DashboardAlertFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_DashboardAlert', json, ($checkedConvert) {
      final val = _DashboardAlert(
        kind: $checkedConvert(
          'kind',
          (v) => $enumDecode(
            _$DashboardAlertKindEnumMap,
            v,
            unknownValue: DashboardAlertKind.unknown,
          ),
        ),
        count: $checkedConvert('count', (v) => (v as num).toInt()),
        preview: $checkedConvert(
          'preview',
          (v) => DashboardAlertPreview.fromJson(v as Map<String, dynamic>),
        ),
      );
      return val;
    });

Map<String, dynamic> _$DashboardAlertToJson(_DashboardAlert instance) =>
    <String, dynamic>{
      'kind': _$DashboardAlertKindEnumMap[instance.kind]!,
      'count': instance.count,
      'preview': instance.preview,
    };

const _$DashboardAlertKindEnumMap = {
  DashboardAlertKind.urgentTask: 'URGENT_TASK',
  DashboardAlertKind.pendingTreatment: 'PENDING_TREATMENT',
  DashboardAlertKind.pendingProduction: 'PENDING_PRODUCTION',
  DashboardAlertKind.lowStock: 'LOW_STOCK',
  DashboardAlertKind.inTreatment: 'IN_TREATMENT',
  DashboardAlertKind.monitoring: 'MONITORING',
  DashboardAlertKind.unknown: 'UNKNOWN',
};

_DashboardSeason _$DashboardSeasonFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_DashboardSeason', json, ($checkedConvert) {
      final val = _DashboardSeason(
        seasonId: $checkedConvert('seasonId', (v) => v as String),
        seasonName: $checkedConvert('seasonName', (v) => v as String),
        pondId: $checkedConvert('pondId', (v) => v as String),
        pondName: $checkedConvert('pondName', (v) => v as String),
        farmId: $checkedConvert('farmId', (v) => v as String),
        farmName: $checkedConvert('farmName', (v) => v as String),
        shrimpType: $checkedConvert('shrimpType', (v) => v as String),
        dayOfCulture: $checkedConvert(
          'dayOfCulture',
          (v) => (v as num?)?.toInt(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$DashboardSeasonToJson(_DashboardSeason instance) =>
    <String, dynamic>{
      'seasonId': instance.seasonId,
      'seasonName': instance.seasonName,
      'pondId': instance.pondId,
      'pondName': instance.pondName,
      'farmId': instance.farmId,
      'farmName': instance.farmName,
      'shrimpType': instance.shrimpType,
      'dayOfCulture': instance.dayOfCulture,
    };

_DashboardFarm _$DashboardFarmFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_DashboardFarm', json, ($checkedConvert) {
      final val = _DashboardFarm(
        id: $checkedConvert('id', (v) => v as String),
        name: $checkedConvert('name', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$DashboardFarmToJson(_DashboardFarm instance) =>
    <String, dynamic>{'id': instance.id, 'name': instance.name};

_DashboardInventory _$DashboardInventoryFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('_DashboardInventory', json, ($checkedConvert) {
  final val = _DashboardInventory(
    farmId: $checkedConvert('farmId', (v) => v as String),
    farmName: $checkedConvert('farmName', (v) => v as String),
    productCount: $checkedConvert('productCount', (v) => (v as num).toInt()),
    lowStockCount: $checkedConvert('lowStockCount', (v) => (v as num).toInt()),
    stockValue: $checkedConvert('stockValue', (v) => (v as num).toDouble()),
  );
  return val;
});

Map<String, dynamic> _$DashboardInventoryToJson(_DashboardInventory instance) =>
    <String, dynamic>{
      'farmId': instance.farmId,
      'farmName': instance.farmName,
      'productCount': instance.productCount,
      'lowStockCount': instance.lowStockCount,
      'stockValue': instance.stockValue,
    };

_DashboardPersonnel _$DashboardPersonnelFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_DashboardPersonnel', json, ($checkedConvert) {
      final val = _DashboardPersonnel(
        technicians: $checkedConvert('technicians', (v) => (v as num).toInt()),
        experts: $checkedConvert('experts', (v) => (v as num).toInt()),
        active: $checkedConvert('active', (v) => (v as num).toInt()),
      );
      return val;
    });

Map<String, dynamic> _$DashboardPersonnelToJson(_DashboardPersonnel instance) =>
    <String, dynamic>{
      'technicians': instance.technicians,
      'experts': instance.experts,
      'active': instance.active,
    };

_OwnerDashboard _$OwnerDashboardFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_OwnerDashboard', json, ($checkedConvert) {
      final val = _OwnerDashboard(
        date: $checkedConvert('date', (v) => v as String),
        summary: $checkedConvert(
          'summary',
          (v) => DashboardSummary.fromJson(v as Map<String, dynamic>),
        ),
        alerts: $checkedConvert(
          'alerts',
          (v) => (v as List<dynamic>)
              .map((e) => DashboardAlert.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        seasons: $checkedConvert(
          'seasons',
          (v) => (v as List<dynamic>)
              .map((e) => DashboardSeason.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        inventories: $checkedConvert(
          'inventories',
          (v) => (v as List<dynamic>)
              .map(
                (e) => DashboardInventory.fromJson(e as Map<String, dynamic>),
              )
              .toList(),
        ),
        financeFarms: $checkedConvert(
          'financeFarms',
          (v) => (v as List<dynamic>)
              .map((e) => DashboardFarm.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        personnel: $checkedConvert(
          'personnel',
          (v) => DashboardPersonnel.fromJson(v as Map<String, dynamic>),
        ),
      );
      return val;
    });

Map<String, dynamic> _$OwnerDashboardToJson(_OwnerDashboard instance) =>
    <String, dynamic>{
      'date': instance.date,
      'summary': instance.summary,
      'alerts': instance.alerts,
      'seasons': instance.seasons,
      'inventories': instance.inventories,
      'financeFarms': instance.financeFarms,
      'personnel': instance.personnel,
    };

_FinanceMonth _$FinanceMonthFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_FinanceMonth', json, ($checkedConvert) {
      final val = _FinanceMonth(
        month: $checkedConvert('month', (v) => v as String),
        income: $checkedConvert('income', (v) => (v as num).toDouble()),
        cost: $checkedConvert('cost', (v) => (v as num).toDouble()),
      );
      return val;
    });

Map<String, dynamic> _$FinanceMonthToJson(_FinanceMonth instance) =>
    <String, dynamic>{
      'month': instance.month,
      'income': instance.income,
      'cost': instance.cost,
    };

_FinanceTotals _$FinanceTotalsFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_FinanceTotals', json, ($checkedConvert) {
      final val = _FinanceTotals(
        income: $checkedConvert('income', (v) => (v as num).toDouble()),
        cost: $checkedConvert('cost', (v) => (v as num).toDouble()),
        profit: $checkedConvert('profit', (v) => (v as num).toDouble()),
      );
      return val;
    });

Map<String, dynamic> _$FinanceTotalsToJson(_FinanceTotals instance) =>
    <String, dynamic>{
      'income': instance.income,
      'cost': instance.cost,
      'profit': instance.profit,
    };

_OwnerFinance _$OwnerFinanceFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_OwnerFinance', json, ($checkedConvert) {
      final val = _OwnerFinance(
        from: $checkedConvert('from', (v) => v as String),
        to: $checkedConvert('to', (v) => v as String),
        months: $checkedConvert(
          'months',
          (v) => (v as List<dynamic>)
              .map((e) => FinanceMonth.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        totals: $checkedConvert(
          'totals',
          (v) => FinanceTotals.fromJson(v as Map<String, dynamic>),
        ),
      );
      return val;
    });

Map<String, dynamic> _$OwnerFinanceToJson(_OwnerFinance instance) =>
    <String, dynamic>{
      'from': instance.from,
      'to': instance.to,
      'months': instance.months,
      'totals': instance.totals,
    };
