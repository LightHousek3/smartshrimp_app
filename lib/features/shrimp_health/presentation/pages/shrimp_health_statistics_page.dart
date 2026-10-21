import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/widgets/app_gradient_background.dart';
import 'package:smartshrimp_app/core/widgets/sticky_page_header.dart';
import 'package:smartshrimp_app/features/shrimp_health/domain/entities/shrimp_health_models.dart';
import 'package:smartshrimp_app/features/shrimp_health/presentation/view_models/shrimp_health_controller.dart';

class ShrimpHealthStatisticsPage extends ConsumerStatefulWidget {
  const ShrimpHealthStatisticsPage({
    required this.seasonId,
    this.pondName,
    this.seasonName,
    super.key,
  });

  final String seasonId;
  final String? pondName;
  final String? seasonName;

  @override
  ConsumerState<ShrimpHealthStatisticsPage> createState() =>
      _ShrimpHealthStatisticsPageState();
}

class _ShrimpHealthStatisticsPageState
    extends ConsumerState<ShrimpHealthStatisticsPage> {
  int _selectedDays = 30; // 7, 30, 90
  String _selectedMetric = 'weight'; // 'weight' (g) or 'biomass' (kg)

  String _formatNumber(num? value, {int fractionDigits = 1}) {
    if (value == null) return '-';
    if (value is int || fractionDigits == 0 || value == value.roundToDouble()) {
      final intVal = fractionDigits == 0 ? value.round() : value.toInt();
      return intVal.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]},',
      );
    }
    final parts = value.toStringAsFixed(fractionDigits).split('.');
    final intPart = parts[0].replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
    return parts.length > 1 ? '$intPart.${parts[1]}' : intPart;
  }

  Widget _buildMetricCard({
    required String label,
    required String value,
    String? unit,
    String? hint,
    required Color iconColor,
    required Color iconBgColor,
    required IconData icon,
  }) =>
      Expanded(
        child: Container(
          constraints: const BoxConstraints(minHeight: 90),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE5E8F0)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 10.5,
                      color: Color(0xFF6A7994),
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      color: iconBgColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(icon, size: 14, color: iconColor),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: <Widget>[
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0F1C2E),
                    ),
                  ),
                  if (unit != null) ...<Widget>[
                    const SizedBox(width: 3),
                    Text(
                      unit,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF6A7994),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ],
              ),
              if (hint != null) ...<Widget>[
                const SizedBox(height: 2),
                Text(
                  hint,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFF94A3B8),
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      );

  Widget _buildDaysSegmentedFilter() => Row(
        children: <Widget>[
          for (final (index, days) in <int>[7, 30, 90].indexed) ...<Widget>[
            if (index > 0) const SizedBox(width: 8),
            Expanded(
              child: _buildDaysFilterButton(days),
            ),
          ],
        ],
      );

  Widget _buildDaysFilterButton(int days) {
    final isSelected = _selectedDays == days;

    return Material(
      color: isSelected ? const Color(0xFF1D7DD8) : const Color(0xD9F4F8FF),
      borderRadius: BorderRadius.circular(12),
      elevation: isSelected ? 2 : 0,
      child: InkWell(
        onTap: () => setState(() {
          _selectedDays = days;
        }),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          alignment: Alignment.center,
          constraints: const BoxConstraints(minHeight: 44),
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
          child: Text(
            '$days ngày qua',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.white : AppColors.inkSoft,
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              height: 1.5,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGrowthChartCard(List<ShrimpGrowthPoint> series) {
    final validPoints = series
        .where((p) => _selectedMetric == 'weight'
            ? (p.avgWeightG != null && p.avgWeightG! > 0)
            : (p.estimatedBiomassKg != null && p.estimatedBiomassKg! > 0))
        .toList();

    double? growthVal;

    if (validPoints.isNotEmpty) {
      final values = validPoints
          .map((p) => _selectedMetric == 'weight' ? p.avgWeightG! : p.estimatedBiomassKg!)
          .toList();
      if (values.length > 1) {
        growthVal = values.last - values.first;
      }
    }

    final unitStr = _selectedMetric == 'weight' ? 'g' : 'kg';

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5E8F0)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Card Header with Blue tint
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: const BoxDecoration(
              color: Color(0xFFF4F8FF),
              border: Border(bottom: BorderSide(color: Color(0xFFEEF1F7))),
            ),
            child: Row(
              children: <Widget>[
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const <BoxShadow>[
                      BoxShadow(
                        color: Color(0x140F1C2E),
                        blurRadius: 3,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.trending_up_rounded,
                    color: Color(0xFF1378D1),
                    size: 18,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        'Biểu đồ tăng trưởng',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF0F1C2E),
                        ),
                      ),
                      Text(
                        '${validPoints.length} lần đo hợp lệ trong khoảng chọn',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF6A7994),
                        ),
                      ),
                    ],
                  ),
                ),
                // Metric toggle pills
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEF1F6),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      _buildMetricToggleItem('Trọng lượng', 'weight'),
                      _buildMetricToggleItem('Sinh khối', 'biomass'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Subheader: Min, Max, Growth highlights
          if (validPoints.length >= 2)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: Row(
                children: <Widget>[
                  _buildStatBadge(
                    'Đầu kỳ',
                    '${_formatNumber(validPoints.first.avgWeightG ?? validPoints.first.estimatedBiomassKg)} $unitStr',
                    const Color(0xFF6A7994),
                  ),
                  const SizedBox(width: 8),
                  _buildStatBadge(
                    'Cuối kỳ',
                    '${_formatNumber(validPoints.last.avgWeightG ?? validPoints.last.estimatedBiomassKg)} $unitStr',
                    const Color(0xFF1378D1),
                  ),
                  const Spacer(),
                  if (growthVal != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: growthVal >= 0 ? const Color(0xFFE2F6F3) : const Color(0xFFFBE6EA),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(
                            growthVal >= 0 ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
                            size: 12,
                            color: growthVal >= 0 ? const Color(0xFF0F9B8E) : const Color(0xFFD43B57),
                          ),
                          const SizedBox(width: 3),
                          Text(
                            '${growthVal >= 0 ? '+' : ''}${growthVal.toStringAsFixed(1)} $unitStr',
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                              color: growthVal >= 0 ? const Color(0xFF0F9B8E) : const Color(0xFFD43B57),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),

          // Chart Body
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
            child: validPoints.length < 2
                ? Container(
                    height: 150,
                    width: double.infinity,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      validPoints.length == 1
                          ? 'Đã ghi nhận 1 lần đo (${_selectedMetric == 'weight' ? '${validPoints[0].avgWeightG} g' : '${validPoints[0].estimatedBiomassKg} kg'}). Cần ít nhất 2 lần đo để vẽ đường tăng trưởng.'
                          : 'Chưa có chỉ số đo hợp lệ trong khoảng ngày này',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 12, color: Color(0xFF6A7994), height: 1.4),
                    ),
                  )
                : SizedBox(
                    height: 190,
                    child: _GrowthLineChart(
                      series: validPoints,
                      metric: _selectedMetric,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatBadge(String label, String value, Color color) => Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            '$label: ',
            style: const TextStyle(fontSize: 11, color: Color(0xFF6A7994), fontWeight: FontWeight.w500),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 11.5, color: color, fontWeight: FontWeight.w700),
          ),
        ],
      );

  Widget _buildMetricToggleItem(String label, String key) {
    final isSelected = _selectedMetric == key;
    return InkWell(
      onTap: () => setState(() => _selectedMetric = key),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1D7DD8) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          boxShadow: isSelected
              ? const <BoxShadow>[
                  BoxShadow(
                    color: Color(0x1A000000),
                    blurRadius: 3,
                    offset: Offset(0, 1),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? Colors.white : AppColors.inkSoft,
          ),
        ),
      ),
    );
  }

  Widget _buildHealthDistributionCard(ShrimpHealthDistribution dist) => Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE5E8F0)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Card Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: const BoxDecoration(
                color: Color(0xFFF4FBF9),
                border: Border(bottom: BorderSide(color: Color(0xFFEEF1F7))),
              ),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const <BoxShadow>[
                        BoxShadow(
                          color: Color(0x140F1C2E),
                          blurRadius: 3,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.pie_chart_outline_rounded,
                      color: Color(0xFF0F9B8E),
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text(
                          'Phân bố trạng thái sức khỏe',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF0F1C2E),
                          ),
                        ),
                        Text(
                          'Đánh giá thể trạng từ ${dist.totalLogs} lần ghi nhận',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF6A7994),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Segmented Bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: SizedBox(
                      height: 14,
                      child: dist.totalLogs == 0
                          ? Container(color: const Color(0xFFE5E8F0))
                          : Row(
                              children: <Widget>[
                                if (dist.excellent.count > 0)
                                  Expanded(
                                    flex: dist.excellent.count,
                                    child: Container(color: const Color(0xFF10B981)),
                                  ),
                                if (dist.good.count > 0)
                                  Expanded(
                                    flex: dist.good.count,
                                    child: Container(color: const Color(0xFF0284C7)),
                                  ),
                                if (dist.warning.count > 0)
                                  Expanded(
                                    flex: dist.warning.count,
                                    child: Container(color: const Color(0xFFF59E0B)),
                                  ),
                                if (dist.critical.count > 0)
                                  Expanded(
                                    flex: dist.critical.count,
                                    child: Container(color: const Color(0xFFEF4444)),
                                  ),
                              ],
                            ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // 2x2 Grid of Status Tiles
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: _buildStatusDetailTile(
                          label: 'Rất tốt',
                          count: dist.excellent.count,
                          percent: dist.excellent.percent,
                          color: const Color(0xFF10B981),
                          bgColor: const Color(0xFFE8F8F0),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildStatusDetailTile(
                          label: 'Bình thường',
                          count: dist.good.count,
                          percent: dist.good.percent,
                          color: const Color(0xFF0284C7),
                          bgColor: const Color(0xFFE0F2FE),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: _buildStatusDetailTile(
                          label: 'Cảnh báo',
                          count: dist.warning.count,
                          percent: dist.warning.percent,
                          color: const Color(0xFFD98314),
                          bgColor: const Color(0xFFFEF3C7),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildStatusDetailTile(
                          label: 'Nguy cấp',
                          count: dist.critical.count,
                          percent: dist.critical.percent,
                          color: const Color(0xFFDC2626),
                          bgColor: const Color(0xFFFEE2E2),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  Widget _buildStatusDetailTile({
    required String label,
    required int count,
    required double percent,
    required Color color,
    required Color bgColor,
  }) =>
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: bgColor.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: <Widget>[
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                  Text(
                    '$count lần · ${percent.toStringAsFixed(1)}%',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0F1C2E),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  ShrimpHealthDistribution _computeHealthDistribution(
    List<ShrimpGrowthPoint> points,
    ShrimpHealthDistribution defaultDist,
  ) {
    if (points.isEmpty) return defaultDist;
    final total = points.length;
    final exc = points.where((p) => p.healthStatus == HealthStatus.excellent).length;
    final good = points.where((p) => p.healthStatus == HealthStatus.good).length;
    final warn = points.where((p) => p.healthStatus == HealthStatus.warning).length;
    final crit = points.where((p) => p.healthStatus == HealthStatus.critical).length;

    return ShrimpHealthDistribution(
      totalLogs: total,
      excellent: ShrimpHealthDistributionItem(
        count: exc,
        percent: total > 0 ? (exc / total) * 100 : 0,
      ),
      good: ShrimpHealthDistributionItem(
        count: good,
        percent: total > 0 ? (good / total) * 100 : 0,
      ),
      warning: ShrimpHealthDistributionItem(
        count: warn,
        percent: total > 0 ? (warn / total) * 100 : 0,
      ),
      critical: ShrimpHealthDistributionItem(
        count: crit,
        percent: total > 0 ? (crit / total) * 100 : 0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Load full 90-day window once; date range filtering (7, 30, 90) handled in frontend
    final statsAsync = ref.watch(
      shrimpHealthStatsProvider(
        (
          seasonId: widget.seasonId,
          days: 90,
        ),
      ),
    );

    final subtitle = [
      widget.pondName,
      widget.seasonName,
    ].where((e) => e != null && e.trim().isNotEmpty).join(' · ');

    return Scaffold(
      body: AppGradientBackground(
        child: SafeArea(
          bottom: false,
          child: Column(
            children: <Widget>[
              // Consistent Header Bar matching App & KTV standards
              PageHeaderBar(
                title: 'Thống kê tăng trưởng tôm',
                subtitle: subtitle.isEmpty ? null : subtitle,
                onBack: context.pop,
                height: 74,
              ),

              // Scrollable Content
              Expanded(
                child: statsAsync.when(
                  loading: () => const Center(
                    child: CircularProgressIndicator(color: AppColors.ocean),
                  ),
                  error: (error, _) => Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Icon(
                            Icons.error_outline_rounded,
                            size: 48,
                            color: AppColors.error,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            error.toString().replaceAll('Exception: ', ''),
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: AppColors.ink),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () {
                              ref.invalidate(
                                shrimpHealthStatsProvider(
                                  (
                                    seasonId: widget.seasonId,
                                    days: 90,
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.refresh_rounded),
                            label: const Text('Tải lại'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  data: (data) {
                    final summary = data.summary;
                    final fullSeries = data.growthSeries;

                    // Filter growth series by selected days in frontend
                    final now = DateTime.now();
                    final cutoff = now.subtract(Duration(days: _selectedDays));
                    final filteredSeries = _selectedDays >= 90
                        ? fullSeries
                        : fullSeries
                            .where((p) =>
                                p.recordedAt.isAfter(cutoff) ||
                                p.recordedAt.isAtSameMomentAs(cutoff))
                            .toList();
                    final displaySeries =
                        filteredSeries.isNotEmpty ? filteredSeries : fullSeries;

                    // Calculate mortality in selected range in frontend
                    final mortalityInRange = _selectedDays >= 90
                        ? summary.totalMortalityInRange
                        : displaySeries.fold<int>(
                            0, (sum, p) => sum + p.mortalityCount);

                    // Compute health distribution for selected range in frontend
                    final displayDistribution = (_selectedDays >= 90 || displaySeries.isEmpty)
                        ? data.healthDistribution
                        : _computeHealthDistribution(displaySeries, data.healthDistribution);

                    return RefreshIndicator(
                      onRefresh: () async {
                        ref.invalidate(
                          shrimpHealthStatsProvider(
                            (
                              seasonId: widget.seasonId,
                              days: 90,
                            ),
                          ),
                        );
                      },
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            // Segmented Date Range Filter
                            _buildDaysSegmentedFilter(),
                            const SizedBox(height: 14),

                            // 2x2 KPI Metrics Grid matching Assigned Season _Metric cards
                            Row(
                              children: <Widget>[
                                _buildMetricCard(
                                  label: 'SINH KHỐI',
                                  value: _formatNumber(summary.currentBiomassKg, fractionDigits: 0),
                                  unit: 'kg',
                                  hint: 'Ước tính toàn ao',
                                  icon: Icons.inventory_2_outlined,
                                  iconColor: const Color(0xFF1378D1),
                                  iconBgColor: const Color(0xFFEAF4FF),
                                ),
                                const SizedBox(width: 10),
                                _buildMetricCard(
                                  label: 'CỠ TRUNG BÌNH',
                                  value: _formatNumber(summary.currentAvgWeightG, fractionDigits: 1),
                                  unit: 'g/con',
                                  hint: 'Trọng lượng cá thể',
                                  icon: Icons.scale_outlined,
                                  iconColor: const Color(0xFF0F9B8E),
                                  iconBgColor: const Color(0xFFE2F6F3),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: <Widget>[
                                _buildMetricCard(
                                  label: 'TỶ LỆ SỐNG',
                                  value: summary.survivalRatePercent != null
                                      ? '${summary.survivalRatePercent}%'
                                      : '-',
                                  hint: 'Dựa trên lượng giống',
                                  icon: Icons.favorite_outline_rounded,
                                  iconColor: const Color(0xFF10B981),
                                  iconBgColor: const Color(0xFFE8F8F0),
                                ),
                                const SizedBox(width: 10),
                                _buildMetricCard(
                                  label: 'SỐ HAO HỤT',
                                  value: '$mortalityInRange',
                                  unit: 'con',
                                  hint: 'Chết trong khoảng chọn',
                                  icon: Icons.heart_broken_outlined,
                                  iconColor: mortalityInRange > 0
                                      ? const Color(0xFFDC2626)
                                      : const Color(0xFF6A7994),
                                  iconBgColor: const Color(0xFFFBE6EA),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Growth Line Chart Card
                            _buildGrowthChartCard(displaySeries),
                            const SizedBox(height: 16),

                            // Health Distribution Card
                            _buildHealthDistributionCard(displayDistribution),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GrowthLineChart extends StatelessWidget {
  const _GrowthLineChart({
    required this.series,
    required this.metric,
  });

  final List<ShrimpGrowthPoint> series;
  final String metric;

  @override
  Widget build(BuildContext context) {
    final validPoints = series
        .where((p) => metric == 'weight'
            ? (p.avgWeightG != null && p.avgWeightG! > 0)
            : (p.estimatedBiomassKg != null && p.estimatedBiomassKg! > 0))
        .toList();

    if (validPoints.length < 2) {
      return Center(
        child: Text(
          validPoints.length == 1
              ? 'Đã ghi nhận 1 lần đo (${metric == 'weight' ? '${validPoints[0].avgWeightG} g' : '${validPoints[0].estimatedBiomassKg} kg'}). Cần ít nhất 2 lần đo để vẽ đường tăng trưởng.'
              : 'Chưa có chỉ số đo hợp lệ trong khoảng ngày này',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 12, color: Color(0xFF6A7994)),
        ),
      );
    }

    final values = validPoints.map((p) =>
        metric == 'weight' ? p.avgWeightG! : p.estimatedBiomassKg!).toList();

    final maxVal = values.reduce(math.max);
    final minVal = values.reduce(math.min);
    final range = maxVal - minVal > 0 ? maxVal - minVal : 1.0;

    return CustomPaint(
      size: Size.infinite,
      painter: _LineChartPainter(
        points: validPoints,
        values: values,
        minVal: minVal,
        maxVal: maxVal,
        range: range,
        isBiomass: metric == 'biomass',
      ),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  _LineChartPainter({
    required this.points,
    required this.values,
    required this.minVal,
    required this.maxVal,
    required this.range,
    required this.isBiomass,
  });

  final List<ShrimpGrowthPoint> points;
  final List<double> values;
  final double minVal;
  final double maxVal;
  final double range;
  final bool isBiomass;

  @override
  void paint(Canvas canvas, Size size) {
    const bottomPadding = 26.0;
    const topPadding = 18.0;
    const leftPadding = 38.0;
    const rightPadding = 14.0;

    final chartWidth = size.width - leftPadding - rightPadding;
    final chartHeight = size.height - topPadding - bottomPadding;

    if (chartWidth <= 0 || chartHeight <= 0) return;

    final primaryColor = isBiomass ? const Color(0xFF1378D1) : const Color(0xFF0F9B8E);

    final linePaint = Paint()
      ..color = primaryColor
      ..strokeWidth = 2.8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final areaPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: <Color>[
          primaryColor.withValues(alpha: 0.22),
          primaryColor.withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromLTWH(leftPadding, topPadding, chartWidth, chartHeight));

    final gridPaint = Paint()
      ..color = const Color(0xFFEEF2F6)
      ..strokeWidth = 0.9
      ..style = PaintingStyle.stroke;

    final pointInnerPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final pointBorderPaint = Paint()
      ..color = primaryColor
      ..strokeWidth = 2.2
      ..style = PaintingStyle.stroke;

    // Draw horizontal grid lines (3 lines)
    for (var i = 0; i <= 2; i++) {
      final y = topPadding + (chartHeight / 2) * i;
      canvas.drawLine(
        Offset(leftPadding, y),
        Offset(leftPadding + chartWidth, y),
        gridPaint,
      );

      final val = maxVal - (range / 2) * i;
      final textSpan = TextSpan(
        text: val.toStringAsFixed(isBiomass ? 0 : 1),
        style: const TextStyle(
          color: Color(0xFF94A3B8),
          fontSize: 9.5,
          fontWeight: FontWeight.w600,
        ),
      );
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      )..layout();
      textPainter.paint(canvas, Offset(2, y - 6));
    }

    final path = Path();
    final areaPath = Path();
    final pointOffsets = <Offset>[];

    final isSameDay = points.length > 1 &&
        points.every((p) =>
            p.recordedAt.year == points.first.recordedAt.year &&
            p.recordedAt.month == points.first.recordedAt.month &&
            p.recordedAt.day == points.first.recordedAt.day);

    for (var i = 0; i < points.length; i++) {
      final x = leftPadding + (chartWidth / (points.length - 1)) * i;
      final normalized = maxVal == minVal ? 0.5 : (values[i] - minVal) / (range > 0 ? range : 1);
      final y = topPadding + chartHeight - (normalized * chartHeight);

      pointOffsets.add(Offset(x, y));

      if (i == 0) {
        path.moveTo(x, y);
        areaPath.moveTo(x, topPadding + chartHeight);
        areaPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        areaPath.lineTo(x, y);
      }
    }

    areaPath.lineTo(pointOffsets.last.dx, topPadding + chartHeight);
    areaPath.close();

    canvas.drawPath(areaPath, areaPaint);
    canvas.drawPath(path, linePaint);

    // Draw Points and X-Axis labels
    for (var i = 0; i < pointOffsets.length; i++) {
      final offset = pointOffsets[i];
      canvas.drawCircle(offset, 4.5, pointInnerPaint);
      canvas.drawCircle(offset, 4.5, pointBorderPaint);

      // Label below (Time if same day, otherwise DOC or Date)
      final doc = points[i].dayOfCulture;
      final localTime = points[i].recordedAt.toLocal();
      final timeStr = '${localTime.hour.toString().padLeft(2, '0')}:${localTime.minute.toString().padLeft(2, '0')}';
      final label = isSameDay ? timeStr : (doc != null ? 'D$doc' : points[i].date.substring(5));

      final textSpan = TextSpan(
        text: label,
        style: const TextStyle(
          color: Color(0xFF6A7994),
          fontSize: 9.5,
          fontWeight: FontWeight.w600,
        ),
      );
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      )..layout();
      textPainter.paint(
        canvas,
        Offset(offset.dx - (textPainter.width / 2), size.height - bottomPadding + 6),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _LineChartPainter oldDelegate) =>
      oldDelegate.points != points || oldDelegate.isBiomass != isBiomass;
}
