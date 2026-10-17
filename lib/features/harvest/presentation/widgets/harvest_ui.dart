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
String harvestNumber(num? value) {
  if (value == null) return '—';
  final parts = value.toStringAsFixed(value % 1 == 0 ? 0 : 3).split('.');
  // Group digits locally without adding a formatting dependency.
  final whole = value.toStringAsFixed(value % 1 == 0 ? 0 : 3).split('.').first;
  final grouped = whole.replaceAllMapped(
    RegExp(r'(\d)(?=(\d{3})+$)'),
    (m) => '${m[1]}.',
  );
  final fraction = parts.length > 1
      ? parts[1].replaceFirst(RegExp(r'0+$'), '')
      : '';
  return fraction.isNotEmpty ? '$grouped,$fraction' : grouped;
}

String harvestDate(DateTime value) {
  final d = value.toLocal();
  String two(int n) => n.toString().padLeft(2, '0');
  return '${two(d.hour)}:${two(d.minute)} ${two(d.day)}/${two(d.month)}/${d.year}';
}

String harvestError(Object error) => error is AppException
    ? error.message
    : 'Không thể tải dữ liệu thu hoạch. Vui lòng thử lại.';

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
          titleStyle: AppTypography.display(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.ink,
          ).copyWith(fontFamilyFallback: const ['Roboto']),
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

class HarvestErrorView extends StatelessWidget {
  const HarvestErrorView({required this.error, required this.retry, super.key});
  final Object error;
  final VoidCallback retry;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(24),
    child: Column(
      children: [
        Text(harvestError(error), textAlign: TextAlign.center),
        TextButton(onPressed: retry, child: const Text('Thử lại')),
      ],
    ),
  );
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
