import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/widgets/app_gradient_background.dart';
import 'package:smartshrimp_app/core/widgets/sticky_page_header.dart';
import 'package:smartshrimp_app/features/assigned_season/presentation/view_models/assigned_season_controller.dart';
import 'package:smartshrimp_app/features/shrimp_health/domain/entities/shrimp_health_models.dart';
import 'package:smartshrimp_app/features/shrimp_health/presentation/view_models/shrimp_health_controller.dart';
import 'package:smartshrimp_app/features/shrimp_health/presentation/widgets/shrimp_health_card.dart';
import 'package:smartshrimp_app/features/shrimp_health/presentation/widgets/shrimp_health_detail_sheet.dart';
import 'package:smartshrimp_app/features/shrimp_health/presentation/widgets/shrimp_health_form_sheet.dart';

class ShrimpHealthListPage extends ConsumerStatefulWidget {
  const ShrimpHealthListPage({
    required this.seasonId,
    this.pondName,
    this.seasonName,
    this.isSeasonActive = true,
    super.key,
  });

  final String seasonId;
  final String? pondName;
  final String? seasonName;
  final bool isSeasonActive;

  @override
  ConsumerState<ShrimpHealthListPage> createState() =>
      _ShrimpHealthListPageState();
}

class _ShrimpHealthListPageState extends ConsumerState<ShrimpHealthListPage> {
  // Tabs: 'all', 'attention', 'voided'
  String _selectedTab = 'all';

  static String _formatNumber(num? value, {int fractionDigits = 1}) {
    if (value == null) return '-';
    if (value is int || fractionDigits == 0 || value == value.roundToDouble()) {
      final intVal = fractionDigits == 0 ? value.round() : value.toInt();
      return intVal.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]}.',
      );
    }
    final fixed = value.toStringAsFixed(fractionDigits);
    final parts = fixed.split('.');
    final intPart = parts[0].replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
    return parts.length > 1 ? '$intPart,${parts[1]}' : intPart;
  }

  void _onTabChanged(String tab) {
    if (_selectedTab == tab) return;
    setState(() => _selectedTab = tab);
  }

  Widget _buildTopStatCards(List<ShrimpHealthLog> allLogs) {
    // Find latest valid log and previous valid log to calculate growth
    final validLogs = allLogs.where((l) => !l.isVoided).toList();
    final latest = validLogs.isNotEmpty ? validLogs.first : null;
    final previous = validLogs.length > 1 ? validLogs[1] : null;

    final String biomassStr = latest?.estimatedBiomassKg != null
        ? _formatNumber(latest!.estimatedBiomassKg, fractionDigits: 0)
        : '-';

    final String avgWeightStr = latest?.avgWeightG != null
        ? _formatNumber(latest!.avgWeightG, fractionDigits: 1)
        : '-';

    String growthStr = '-';
    final latestWeight = latest?.avgWeightG;
    final previousWeight = previous?.avgWeightG;
    if (latestWeight != null && previousWeight != null) {
      final diff = latestWeight - previousWeight;
      final prefix = diff >= 0 ? '+' : '';
      growthStr = '$prefix${diff.toStringAsFixed(1)}';
    } else if (latestWeight != null) {
      growthStr = '+0.0';
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: <Widget>[
          // Sinh khối
          Expanded(
            child: _buildKpiCard(
              title: 'SINH KHỐI',
              value: biomassStr,
              unit: 'kg',
              valueColor: const Color(0xFF0F9B8E),
            ),
          ),
          const SizedBox(width: 10),
          // Cỡ TB
          Expanded(
            child: _buildKpiCard(
              title: 'CỠ TB',
              value: avgWeightStr,
              unit: 'g/con',
              valueColor: const Color(0xFF0F1C2E),
            ),
          ),
          const SizedBox(width: 10),
          // Tăng trưởng
          Expanded(
            child: _buildKpiCard(
              title: 'TĂNG TRƯỞNG',
              value: growthStr,
              unit: 'g/kỳ',
              valueColor: const Color(0xFF0F1C2E),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKpiCard({
    required String title,
    required String value,
    required String unit,
    required Color valueColor,
  }) =>
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
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
          children: <Widget>[
            Text(
              title,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Color(0xFF6A7994),
                letterSpacing: 0.2,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: valueColor,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              unit,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Color(0xFF6A7994),
              ),
            ),
          ],
        ),
      );

  Widget _buildMissingTodayBanner() => Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFBEB),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFFDE68A)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF3C7),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.notification_important_rounded,
                color: Color(0xFFD97706),
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Chưa có ghi nhận hôm nay',
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF92400E),
                    ),
                  ),
                  SizedBox(height: 3),
                  Text(
                    'Ao nuôi chưa có dữ liệu sức khỏe tôm trong ngày hôm nay. Hãy thực hiện chài mẫu kiểm tra và ghi nhận định kỳ nhé!',
                    style: TextStyle(
                      fontSize: 11.5,
                      color: Color(0xFFB45309),
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  Widget _buildSegmentedFilter(List<ShrimpHealthLog> allLogs, ShrimpHealthCounts? counts) {
    final totalCount = counts?.total ?? allLogs.length;
    final attentionCount = counts?.warningOrCritical ??
        allLogs
            .where((l) =>
                !l.isVoided &&
                (l.healthStatus == HealthStatus.warning ||
                    l.healthStatus == HealthStatus.critical))
            .length;
    final voidedCount = counts?.voided ?? allLogs.where((l) => l.isVoided).length;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: <Widget>[
          Expanded(
            child: _buildFilterButton('Tất cả ($totalCount)', 'all'),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildFilterButton('Cảnh báo ($attentionCount)', 'attention'),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildFilterButton('Vô hiệu ($voidedCount)', 'voided'),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String label, String key) {
    final isSelected = _selectedTab == key;

    return Material(
      color: isSelected ? const Color(0xFF1D7DD8) : const Color(0xD9F4F8FF),
      borderRadius: BorderRadius.circular(12),
      elevation: isSelected ? 2 : 0,
      child: InkWell(
        onTap: () => _onTabChanged(key),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          alignment: Alignment.center,
          constraints: const BoxConstraints(minHeight: 44),
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.white : AppColors.inkSoft,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              height: 1.5,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final listAsync = ref.watch(shrimpHealthListProvider(widget.seasonId));
    final subtitle = [
      if (widget.pondName?.trim().isNotEmpty == true) widget.pondName!.trim(),
      if (widget.seasonName?.trim().isNotEmpty == true)
        widget.seasonName!.trim(),
    ].join(' · ');

    return Scaffold(
      body: AppGradientBackground(
        child: SafeArea(
          bottom: false,
          child: Column(
            children: <Widget>[
              AppGradientBackground(
                child: PageHeaderBar(
                  title: 'Sức khỏe tôm',
                  subtitle: subtitle.isEmpty ? null : subtitle,
                  onBack: context.pop,
                  backButton: SizedBox(
                    width: 36,
                    height: 36,
                    child: IconButton(
                      tooltip: 'Quay lại',
                      padding: EdgeInsets.zero,
                      onPressed: context.pop,
                      icon: SvgPicture.asset(
                        'assets/icons/water-log/water_back.svg',
                        width: 19.9898,
                        height: 19.9898,
                      ),
                    ),
                  ),
                  backgroundColor: AppColors.backgroundTop,
                  trailing: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xB3FFFFFF),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xB3FFFFFF)),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x1A000000),
                          blurRadius: 3,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    child: TextButton(
                      key: const Key('shrimp_health_statistics_button'),
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF0C4E8F),
                        minimumSize: const Size(96, 35),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        textStyle: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      onPressed: () {
                        final currentUri = GoRouterState.of(context).uri.path;
                        final target = currentUri.endsWith('/shrimp-health')
                            ? '$currentUri/statistics'
                            : '/seasons/${widget.seasonId}/shrimp-health/statistics';
                        context.push(
                          target,
                          extra: <String, dynamic>{
                            if (widget.pondName != null) 'pondName': widget.pondName,
                            if (widget.seasonName != null) 'seasonName': widget.seasonName,
                          },
                        );
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            'assets/icons/water-log/water_statistics.svg',
                            width: 14.9997,
                            height: 14.9997,
                          ),
                          const SizedBox(width: 6),
                          const Text('Thống kê'),
                        ],
                      ),
                    ),
                  ),
                  titleStyle: AppTypography.display(
                    color: AppColors.ink,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    height: 1.5,
                  ).copyWith(
                    fontFamilyFallback: <String>[
                      GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w700,
                      ).fontFamily!,
                    ],
                  ),
                ),
              ),

              // Full width Action Button: + Ghi nhận sức khỏe tôm (matching Figma figma_list.png)
              if (widget.isSeasonActive)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                    onPressed: () {
                      final initialQuantity = ref
                          .watch(assignedSeasonDetailProvider(widget.seasonId))
                          .value
                          ?.initialQuantity;
                      ShrimpHealthFormSheet.show(
                        context,
                        seasonId: widget.seasonId,
                        initialQuantity: initialQuantity,
                        onCreated: () {
                          ref
                              .read(shrimpHealthListProvider(widget.seasonId).notifier)
                              .refresh();
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD43B57),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.add_rounded, color: Colors.white, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Ghi nhận sức khỏe tôm',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Scrollable Body Content
              Expanded(
                child: listAsync.when(
                  loading: () => const Center(
                    child: CircularProgressIndicator(),
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
                            style: const TextStyle(color: Color(0xFF0F1C2E)),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () {
                              ref
                                  .read(shrimpHealthListProvider(widget.seasonId).notifier)
                                  .refresh();
                            },
                            icon: const Icon(Icons.refresh_rounded),
                            label: const Text('Thử lại'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  data: (result) {
                    final counts = result.counts;
                    final now = DateTime.now();
                    final hasLogToday = result.logs.any((l) =>
                        !l.isVoided &&
                        l.recordedAt.year == now.year &&
                        l.recordedAt.month == now.month &&
                        l.recordedAt.day == now.day);
                    final showMissingToday = widget.isSeasonActive && !hasLogToday;

                    // Filter logs based on selected tab
                    final displayedLogs = result.logs.where((log) {
                      if (_selectedTab == 'attention') {
                        return !log.isVoided &&
                            (log.healthStatus == HealthStatus.warning ||
                                log.healthStatus == HealthStatus.critical);
                      }
                      if (_selectedTab == 'voided') {
                        return log.isVoided;
                      }
                      return true;
                    }).toList();

                    return RefreshIndicator(
                      onRefresh: () async {
                        await ref
                            .read(shrimpHealthListProvider(widget.seasonId).notifier)
                            .refresh();
                      },
                      child: NotificationListener<ScrollNotification>(
                        onNotification: (notification) {
                          if (notification.metrics.pixels >=
                              notification.metrics.maxScrollExtent - 200) {
                            ref
                                .read(shrimpHealthListProvider(widget.seasonId).notifier)
                                .loadMore();
                          }
                          return false;
                        },
                        child: CustomScrollView(
                          slivers: <Widget>[
                            const SliverToBoxAdapter(child: SizedBox(height: 6)),

                            // 3 Top Stat Cards: SINH KHỐI, CỠ TB, TĂNG TRƯỞNG
                            SliverToBoxAdapter(
                              child: _buildTopStatCards(result.logs),
                            ),
                            const SliverToBoxAdapter(child: SizedBox(height: 12)),

                            // Warning Banner: Only alert KTV if active season has NO log today!
                            if (showMissingToday) ...<Widget>[
                              SliverToBoxAdapter(
                                child: _buildMissingTodayBanner(),
                              ),
                              const SliverToBoxAdapter(child: SizedBox(height: 12)),
                            ],

                            // Segmented Filter Tabs: Tất cả, Chú ý, Vô hiệu
                            SliverToBoxAdapter(
                              child: _buildSegmentedFilter(result.logs, counts),
                            ),
                            const SliverToBoxAdapter(child: SizedBox(height: 8)),

                            // Empty State or List of Cards
                            if (displayedLogs.isEmpty)
                              SliverFillRemaining(
                                hasScrollBody: false,
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(32),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          padding: const EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFF1F5F9),
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          child: const Icon(
                                            Icons.assignment_outlined,
                                            size: 40,
                                            color: Color(0xFF6A7994),
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        const Text(
                                          'Không có bản ghi phù hợp',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xFF0F1C2E),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        const Text(
                                          'Chưa có dữ liệu sức khỏe cho bộ lọc này.',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Color(0xFF6A7994),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            else
                              SliverPadding(
                                padding: const EdgeInsets.only(bottom: 24),
                                sliver: SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                    (context, index) {
                                      final log = displayedLogs[index];
                                      return ShrimpHealthCard(
                                        log: log,
                                        onTap: () {
                                          ShrimpHealthDetailSheet.show(
                                            context,
                                            seasonId: widget.seasonId,
                                            log: log,
                                            onVoided: () {
                                              ref
                                                  .read(
                                                    shrimpHealthListProvider(
                                                      widget.seasonId,
                                                    ).notifier,
                                                  )
                                                  .refresh();
                                            },
                                          );
                                        },
                                      );
                                    },
                                    childCount: displayedLogs.length,
                                  ),
                                ),
                              ),

                            // Loading more spinner
                            if (result.hasNext)
                              const SliverToBoxAdapter(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  child: Center(
                                    child: SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    ),
                                  ),
                                ),
                              ),
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
