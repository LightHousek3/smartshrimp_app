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
              'Cộng doanh thu đã biết của các lần thu tỉa và thu cuối trong kỳ. Lần chưa có giá được ghi riêng; nếu tất cả chưa có giá thì doanh thu chưa xác định.',
        ),
        _TotalRow(
          label: 'Chi phí vật tư',
          value: totals.cost,
          color: dashboardRed,
          useRootNavigator: useRootNavigator,
          explanation:
              'Giá vốn phần nhập thực dùng của mọi nhóm vật tư xuất qua lần thực hiện ao, tính theo giờ dùng thật. Không tính tiền mua hoặc xuất thủ công không liên quan vận hành ao.',
        ),
        _TotalRow(
          label: 'Chênh lệch sau vật tư',
          value: totals.profit,
          color: AppColors.ocean,
          bold: true,
          useRootNavigator: useRootNavigator,
          explanation:
              'Tổng thu − Chi phí vật tư thực dùng. Đây không phải lợi nhuận đầy đủ: chưa gồm điện, nhân công và tôm giống. Nếu còn lần thu chưa có giá, chênh lệch cũng chưa đầy đủ.',
        ),
        if (totals.unpricedHarvests > 0)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              '${totals.unpricedHarvests} lần thu hoạch chưa có giá. Tổng thu và chênh lệch ${totals.income == null ? 'chưa xác định' : 'chưa đầy đủ'}.',
              style: const TextStyle(fontSize: 11, color: AppColors.inkMuted),
            ),
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
  final double? value;
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
        Expanded(
          flex: 6,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: bold ? AppColors.ink : AppColors.inkMuted,
              fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
            ),
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
          flex: 7,
          child: Text(
            value == null
                ? 'Chưa xác định'
                : dashboardMoney(value!, signed: bold),
            textAlign: TextAlign.right,
            style: dashboardDisplay(
              fontSize: value == null
                  ? 12
                  : bold
                  ? 16
                  : 14,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
        ),
      ],
    ),
  );
}
