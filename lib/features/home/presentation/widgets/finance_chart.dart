import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/features/home/domain/entities/owner_dashboard.dart';
import 'package:smartshrimp_app/features/home/presentation/widgets/dashboard_widgets.dart';

class FinanceChart extends StatefulWidget {
  const FinanceChart({required this.months, this.height = 180, super.key});
  final List<FinanceMonth> months;
  final double height;
  @override
  State<FinanceChart> createState() => _FinanceChartState();
}

class _FinanceChartState extends State<FinanceChart> {
  int? _selected;
  int? _hovered;
  @override
  void didUpdateWidget(covariant FinanceChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.months != widget.months) {
      _selected = null;
      _hovered = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final peak = widget.months.fold<double>(
      0,
      (max, month) => math.max(max, math.max(month.income, month.cost)),
    );
    final scale = _niceScale(peak);
    final activeIndex = _hovered ?? _selected;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 28,
          child: Row(
            children: [
              const FinanceLegend(),
              const SizedBox(width: 8),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: activeIndex == null
                      ? const SizedBox.shrink()
                      : FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerRight,
                          child: Semantics(
                            liveRegion: true,
                            child: Container(
                              key: const Key('finance-month-detail'),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: dashboardPanel,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Tháng ${widget.months[activeIndex].month.split('-').reversed.join('/')} · Thu ${dashboardMoney(widget.months[activeIndex].income)} · Chi ${dashboardMoney(widget.months[activeIndex].cost)}',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppColors.inkSoft,
                                ),
                              ),
                            ),
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        LayoutBuilder(
          builder: (context, constraints) {
            final width = math.max(
              constraints.maxWidth,
              46 + widget.months.length * 25.0,
            );
            return SizedBox(
              height: widget.height,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: width,
                  height: widget.height,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: CustomPaint(painter: _ChartGrid(scale)),
                      ),
                      Positioned(
                        left: 42,
                        right: 0,
                        top: 5,
                        bottom: 22,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            for (
                              var index = 0;
                              index < widget.months.length;
                              index++
                            )
                              Expanded(
                                child: Semantics(
                                  button: true,
                                  label:
                                      '${widget.months[index].month}, Thu ${widget.months[index].income} đồng, Chi ${widget.months[index].cost} đồng',
                                  selected: activeIndex == index,
                                  child: InkWell(
                                    key: ValueKey(
                                      'finance-month-${widget.months[index].month}',
                                    ),
                                    onTap: () => setState(
                                      () => _selected = _selected == index
                                          ? null
                                          : index,
                                    ),
                                    onHover: (hovering) {
                                      if (hovering) {
                                        setState(() => _hovered = index);
                                      } else if (_hovered == index) {
                                        setState(() => _hovered = null);
                                      }
                                    },
                                    child: Container(
                                      color: activeIndex == index
                                          ? AppColors.ocean.withValues(
                                              alpha: 0.06,
                                            )
                                          : null,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          _bar(
                                            widget.months[index].income,
                                            scale,
                                            dashboardTeal,
                                            width,
                                          ),
                                          const SizedBox(width: 2),
                                          _bar(
                                            widget.months[index].cost,
                                            scale,
                                            dashboardRed,
                                            width,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      Positioned(
                        left: 42,
                        right: 0,
                        bottom: 0,
                        height: 18,
                        child: Row(
                          children: [
                            for (final month in widget.months)
                              Expanded(
                                child: Text(
                                  _monthLabel(month.month),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 9,
                                    color: AppColors.inkMuted,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        if (peak == 0)
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text(
              'Chưa có thu chi trong khoảng thời gian này.',
              style: TextStyle(fontSize: 11, color: AppColors.inkMuted),
            ),
          ),
      ],
    );
  }

  Widget _bar(double value, double scale, Color color, double chartWidth) =>
      Container(
        width: math.min(10, (chartWidth - 42) / widget.months.length / 3),
        height: (widget.height - 27) * value / scale,
        decoration: BoxDecoration(
          color: color,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(3)),
        ),
      );
}

String _monthLabel(String month) {
  final parts = month.split('-');
  final number = int.parse(parts[1]);
  return number == 1 ? 'T1/${parts[0].substring(2)}' : 'T$number';
}

double _niceScale(double peak) {
  if (peak <= 0) return 1e6;
  final base = math.pow(10, (math.log(peak) / math.ln10).floor()).toDouble();
  final normalized = peak / base;
  final factor = normalized <= 1
      ? 1
      : normalized <= 2
      ? 2
      : normalized <= 3
      ? 3
      : normalized <= 5
      ? 5
      : 10;
  return base * factor;
}

class FinanceLegend extends StatelessWidget {
  const FinanceLegend({super.key});
  @override
  Widget build(BuildContext context) => const Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      FinanceDot(dashboardTeal),
      SizedBox(width: 4),
      Text('Thu', style: TextStyle(color: AppColors.inkMuted, fontSize: 11)),
      SizedBox(width: 14),
      FinanceDot(dashboardRed),
      SizedBox(width: 4),
      Text('Chi', style: TextStyle(color: AppColors.inkMuted, fontSize: 11)),
    ],
  );
}

class FinanceDot extends StatelessWidget {
  const FinanceDot(this.color, {super.key});
  final Color color;
  @override
  Widget build(BuildContext context) => Container(
    width: 8,
    height: 8,
    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
  );
}

class _ChartGrid extends CustomPainter {
  const _ChartGrid(this.scale);
  final double scale;
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFE5EBF5)
      ..strokeWidth = 1;
    final bottom = size.height - 22;
    for (final fraction in [0.0, 0.5, 1.0]) {
      final y = bottom - (bottom - 5) * fraction;
      if (fraction == 0) {
        canvas.drawLine(Offset(42, y), Offset(size.width, y), paint);
      }
      for (double x = 42; x < size.width; x += 4) {
        canvas.drawLine(
          Offset(x, y),
          Offset(math.min(x + 2, size.width), y),
          paint,
        );
      }
      final value = scale * fraction;
      final text = TextPainter(
        text: TextSpan(
          text: value == 0
              ? '0'
              : dashboardMoney(value).replaceAll(' tr', 'tr'),
          style: const TextStyle(
            color: AppColors.inkMuted,
            fontSize: 9,
            fontFamily: 'PlusJakartaSans_regular',
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: 40);
      text.paint(
        canvas,
        Offset(
          37 - text.width,
          (y - text.height / 2).clamp(0, bottom - text.height),
        ),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ChartGrid oldDelegate) =>
      oldDelegate.scale != scale;
}
