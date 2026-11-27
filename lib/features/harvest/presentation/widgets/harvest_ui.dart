import 'package:smartshrimp_app/core/utils/vietnamese_number.dart';
import 'package:flutter/material.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/widgets/app_gradient_background.dart';
import 'package:smartshrimp_app/core/widgets/sticky_page_header.dart';
import 'package:smartshrimp_app/features/harvest/domain/entities/harvest_event.dart';

String harvestTypeLabel(HarvestType type) => switch (type) {
  HarvestType.partial => 'Thu tỉa',
  HarvestType.finalHarvest => 'Thu hoạch cuối',
  HarvestType.unknown => 'Không xác định',
};
String harvestNumber(num? value) =>
    value == null ? '—' : formatVietnameseNumber(value, decimalPlaces: 3);

String _compactHarvestNumber(num value) {
  final (divisor, suffix) = switch (value.abs()) {
    >= 999950000000 => (1000000000000, 'nghìn tỷ'),
    >= 999950000 => (1000000000, 'tỷ'),
    >= 999950 => (1000000, 'tr'),
    >= 1000 => (1000, 'nghìn'),
    _ => (1, ''),
  };
  return suffix.isEmpty
      ? harvestNumber(value)
      : '${formatVietnameseNumber(value / divisor, decimalPlaces: 1)} $suffix';
}

class HarvestValue extends StatelessWidget {
  const HarvestValue(
    this.value, {
    required this.style,
    this.unit,
    this.empty = '—',
    this.alignment = Alignment.centerLeft,
    this.compactMillions = false,
    super.key,
  });

  final num? value;
  final TextStyle style;
  final String? unit;
  final String empty;
  final Alignment alignment;
  final bool compactMillions;

  @override
  Widget build(BuildContext context) {
    final amount = value;
    if (amount == null || !amount.isFinite) {
      return Text(empty, style: style, textAlign: TextAlign.center);
    }
    final suffix = unit == null ? '' : ' $unit';
    final full = '${harvestNumber(amount)}$suffix';
    return LayoutBuilder(
      builder: (context, constraints) {
        final painter = TextPainter(
          text: TextSpan(
            text: full,
            style: DefaultTextStyle.of(context).style.merge(style),
          ),
          textDirection: Directionality.of(context),
          textScaler: MediaQuery.textScalerOf(context),
          maxLines: 1,
        )..layout();
        final needsCompact =
            (compactMillions && amount.abs() >= 999950) ||
            painter.width > constraints.maxWidth;
        painter.dispose();

        final label = needsCompact
            ? '${_compactHarvestNumber(amount)}$suffix'
            : full;
        final text = FittedBox(
          fit: BoxFit.scaleDown,
          alignment: alignment,
          child: Text(label, style: style, maxLines: 1, semanticsLabel: full),
        );
        return label == full
            ? text
            : Tooltip(message: full, excludeFromSemantics: true, child: text);
      },
    );
  }
}

String harvestDate(DateTime value) {
  final d = value.toLocal();
  String two(int n) => n.toString().padLeft(2, '0');
  return '${two(d.hour)}:${two(d.minute)} ${two(d.day)}/${two(d.month)}/${d.year}';
}

String harvestError(
  Object error, {
  String fallback = 'Không thể tải dữ liệu thu hoạch. Vui lòng thử lại.',
}) => error is AppException ? error.message : fallback;

class HarvestScaffold extends StatelessWidget {
  const HarvestScaffold({
    required this.title,
    required this.children,
    this.subtitle,
    this.onRefresh,
    super.key,
  });
  final String title;
  final String? subtitle;
  final List<Widget> children;
  final Future<void> Function()? onRefresh;
  @override
  Widget build(BuildContext context) {
    final scroll = CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        StickyPageHeader(
          title: title,
          subtitle: subtitle,
          onBack: () => Navigator.of(context).maybePop(),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
          sliver: SliverList.list(children: children),
        ),
      ],
    );
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppGradientBackground(
        child: SafeArea(
          bottom: false,
          child: onRefresh == null
              ? scroll
              : RefreshIndicator(onRefresh: onRefresh!, child: scroll),
        ),
      ),
    );
  }
}

class HarvestFact extends StatelessWidget {
  const HarvestFact(
    this.label,
    this.value, {
    this.highlight = false,
    super.key,
  });
  final String label;
  final String value;
  final bool highlight;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(color: AppColors.inkMuted, fontSize: 11),
      ),
      const SizedBox(height: 4),
      Text(
        value,
        style: TextStyle(
          color: highlight ? const Color(0xFF00786F) : AppColors.ink,
          fontWeight: FontWeight.w700,
        ),
      ),
    ],
  );
}
