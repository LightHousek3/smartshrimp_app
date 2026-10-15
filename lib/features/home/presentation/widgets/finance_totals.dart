import 'package:flutter/material.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/features/home/domain/entities/owner_dashboard.dart';
import 'package:smartshrimp_app/features/home/presentation/widgets/dashboard_widgets.dart';
import 'package:smartshrimp_app/features/home/presentation/widgets/finance_chart.dart';

class FinanceRange extends StatelessWidget {
  const FinanceRange(this.finance, {super.key});
  final OwnerFinance finance;
  @override
  Widget build(BuildContext context) => Text(
    '${dashboardDate(finance.from)} – ${dashboardDate(finance.to)}',
    style: const TextStyle(color: AppColors.inkMuted, fontSize: 11),
  );
}

class FinanceTotalsView extends StatelessWidget {
  const FinanceTotalsView({
    required this.totals,
    this.panel = true,
    this.useRootNavigator = true,
    super.key,
  });
  final FinanceTotals totals;
  final bool panel;
  final bool useRootNavigator;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
    decoration: BoxDecoration(
      color: panel ? dashboardPanel : null,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      children: [
        _TotalRow(
          label: 'Tổng thu',
          value: totals.income,
          color: dashboardTeal,
          useRootNavigator: useRootNavigator,
          explanation:
              'Doanh thu từ các lần thu hoạch (thu tỉa và thu hoạch cuối) trong khoảng thời gian đã chọn.',
        ),
        _TotalRow(
          label: 'Tổng chi',
          value: totals.cost,
          color: dashboardRed,
          useRootNavigator: useRootNavigator,
          explanation:
              'Giá trị vật tư đã xuất kho cho vụ nuôi: thức ăn, thuốc, khoáng và hóa chất. Không tính tiền nhập kho để tránh tính trùng.',
        ),
        _TotalRow(
          label: 'Lợi nhuận',
          value: totals.profit,
          color: AppColors.ocean,
          bold: true,
          useRootNavigator: useRootNavigator,
          explanation:
              'Tổng thu − Tổng chi. Chỉ sử dụng dữ liệu đã ghi nhận trong hệ thống; chưa bao gồm điện, nhân công và tôm giống.',
        ),
      ],
    ),
  );
}

class _TotalRow extends StatelessWidget {
  const _TotalRow({
    required this.label,
    required this.value,
    required this.color,
    required this.explanation,
    required this.useRootNavigator,
    this.bold = false,
  });
  final String label;
  final double value;
  final Color color;
  final String explanation;
  final bool bold;
  final bool useRootNavigator;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Row(
      children: [
        FinanceDot(color),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: bold ? AppColors.ink : AppColors.inkMuted,
            fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
        SizedBox(
          width: 28,
          height: 32,
          child: IconButton(
            tooltip: 'Cách tính $label',
            padding: EdgeInsets.zero,
            onPressed: () => showDialog<void>(
              context: context,
              useRootNavigator: useRootNavigator,
              builder: (context) => AlertDialog(
                title: Text(label),
                content: Text(explanation),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Đã hiểu'),
                  ),
                ],
              ),
            ),
            icon: Container(
              width: 16,
              height: 16,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFE2E8F1),
              ),
              child: const Text(
                '?',
                style: TextStyle(
                  color: AppColors.inkMuted,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Text(
            dashboardMoney(value, signed: bold),
            textAlign: TextAlign.right,
            style: dashboardDisplay(
              fontSize: bold ? 16 : 14,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
        ),
      ],
    ),
  );
}
