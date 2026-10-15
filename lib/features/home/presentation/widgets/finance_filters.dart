import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/widgets/app_svg_icon.dart';
import 'package:smartshrimp_app/features/home/domain/entities/owner_dashboard.dart';
import 'package:smartshrimp_app/features/home/presentation/view_models/owner_dashboard_controller.dart';
import 'package:smartshrimp_app/features/home/presentation/widgets/dashboard_widgets.dart';

class FinanceFilters extends ConsumerWidget {
  const FinanceFilters({
    required this.farms,
    required this.today,
    this.useRootNavigator = true,
    super.key,
  });
  final List<DashboardFarm> farms;
  final DateTime today;
  final bool useRootNavigator;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(financeFilterProvider);
    final controller = ref.read(financeFilterProvider.notifier);
    final missingFarm =
        filter.farmId != null && !farms.any((farm) => farm.id == filter.farmId);
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _FinanceDropdown<String>(
                label: 'Trang trại',
                icon: AppSvgIconName.farm,
                value: filter.farmId ?? '',
                expandMenu: true,
                items: [
                  if (missingFarm)
                    _FinanceOption(
                      value: filter.farmId!,
                      enabled: false,
                      label: 'Trang trại không còn khả dụng',
                    ),
                  const _FinanceOption(value: '', label: 'Tất cả trang trại'),
                  for (final farm in farms)
                    _FinanceOption(value: farm.id, label: farm.name),
                ],
                onChanged: (value) =>
                    controller.selectFarm(value == '' ? null : value),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _FinanceDropdown<FinancePeriod>(
                label: 'Khoảng thời gian',
                icon: AppSvgIconName.calendar,
                value: filter.period,
                items: [
                  for (final period in FinancePeriod.values)
                    _FinanceOption(value: period, label: period.label),
                ],
                onChanged: (value) {
                  if (value != null) controller.selectPeriod(value, today);
                },
              ),
            ),
          ],
        ),
        if (filter.period == FinancePeriod.custom) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _DateField(
                  key: const Key('finance-date-from'),
                  label: 'Từ ngày',
                  date: filter.from!,
                  onTap: () => _pick(context, ref, true),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 6),
                child: Text(
                  '→',
                  style: TextStyle(color: AppColors.inkMuted, fontSize: 12),
                ),
              ),
              Expanded(
                child: _DateField(
                  key: const Key('finance-date-to'),
                  label: 'Đến ngày',
                  date: filter.to!,
                  onTap: () => _pick(context, ref, false),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Future<void> _pick(BuildContext context, WidgetRef ref, bool from) async {
    final filter = ref.read(financeFilterProvider);
    final result = await showDatePicker(
      context: context,
      useRootNavigator: useRootNavigator,
      helpText: from ? 'Chọn từ ngày' : 'Chọn đến ngày',
      cancelText: 'Hủy',
      confirmText: 'Chọn',
      initialDate: from ? filter.from! : filter.to!,
      firstDate: from
          ? DateTime(filter.to!.year, filter.to!.month - 59, 1)
          : filter.from!,
      lastDate: from ? filter.to! : today,
    );
    if (result == null || !context.mounted) return;
    // Re-read to avoid overwriting a farm/period change while the picker was open.
    final current = ref.read(financeFilterProvider);
    if (current.period != FinancePeriod.custom) return;
    ref
        .read(financeFilterProvider.notifier)
        .selectDates(
          from ? result : current.from!,
          from ? current.to! : result,
        );
  }
}

class _FinanceOption<T> {
  const _FinanceOption({
    required this.value,
    required this.label,
    this.enabled = true,
  });
  final T value;
  final String label;
  final bool enabled;
}

class _FinanceDropdown<T> extends StatelessWidget {
  const _FinanceDropdown({
    required this.label,
    required this.icon,
    required this.value,
    required this.items,
    required this.onChanged,
    this.expandMenu = false,
  });
  final String label;
  final AppSvgIconName icon;
  final T value;
  final List<_FinanceOption<T>> items;
  final ValueChanged<T?> onChanged;
  final bool expandMenu;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: AppColors.line, width: 1.3),
    ),
    child: Row(
      children: [
        AppSvgIcon(icon, size: 16, color: AppColors.ocean),
        const SizedBox(width: 6),
        Expanded(
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              key: ValueKey('finance-filter-$label'),
              value: value,
              items: [
                for (final item in items)
                  DropdownMenuItem(
                    value: item.value,
                    enabled: item.enabled,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: expandMenu ? 12 : 0,
                      ),
                      child: Text(item.label, softWrap: true),
                    ),
                  ),
              ],
              selectedItemBuilder: (context) => [
                for (final item in items)
                  Tooltip(
                    message: item.label,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        item.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
              ],
              onChanged: onChanged,
              isExpanded: true,
              itemHeight: expandMenu ? null : kMinInteractiveDimension,
              menuWidth: expandMenu
                  ? (MediaQuery.sizeOf(context).width - 32).clamp(0, 400)
                  : null,
              dropdownColor: Colors.white,
              borderRadius: BorderRadius.circular(12),
              menuMaxHeight: 320,
              hint: Text(label),
              icon: const AppSvgIcon(AppSvgIconName.chevronDown, size: 12),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.ink,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

class _DateField extends StatelessWidget {
  const _DateField({
    required this.label,
    required this.date,
    required this.onTap,
    super.key,
  });
  final String label;
  final DateTime date;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => OutlinedButton(
    onPressed: onTap,
    style: OutlinedButton.styleFrom(
      backgroundColor: Colors.white,
      side: const BorderSide(color: AppColors.line),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
      minimumSize: const Size(0, 40),
    ),
    child: Semantics(
      label: '$label ${dashboardDate(dateOnly(date))}',
      child: Row(
        children: [
          Expanded(
            child: Text(
              '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}',
              style: const TextStyle(fontSize: 11, color: AppColors.ocean),
            ),
          ),
          const AppSvgIcon(
            AppSvgIconName.calendar,
            size: 12,
            color: AppColors.ink,
          ),
        ],
      ),
    ),
  );
}
