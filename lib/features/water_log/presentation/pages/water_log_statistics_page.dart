import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/widgets/app_gradient_background.dart';
import 'package:smartshrimp_app/core/widgets/sticky_page_header.dart';
import 'package:smartshrimp_app/features/water_log/domain/entities/water_log.dart';
import 'package:smartshrimp_app/features/water_log/presentation/view_models/water_log_trend_provider.dart';
import 'package:smartshrimp_app/features/water_log/presentation/widgets/water_log_refresh_boundary.dart';
import 'package:smartshrimp_app/features/water_log/presentation/widgets/water_metric_trend.dart';
import 'package:smartshrimp_app/features/water_log/presentation/widgets/water_threshold_summary.dart';

class WaterLogStatisticsPage extends ConsumerStatefulWidget {
  const WaterLogStatisticsPage({
    required this.seasonId,
    this.pondName,
    this.seasonName,
    super.key,
  });
  final String seasonId;
  final String? pondName, seasonName;
  @override
  ConsumerState<WaterLogStatisticsPage> createState() =>
      _WaterLogStatisticsPageState();
}

class _WaterLogStatisticsPageState
    extends ConsumerState<WaterLogStatisticsPage> {
  int? _days;
  String _field = 'dissolvedOxygenMgL';
  @override
  Widget build(BuildContext context) {
    final query = (seasonId: widget.seasonId, days: _days);
    final state = ref.watch(waterLogTrendProvider(query));
    Future<void> refresh() async {
      ref.invalidate(waterLogTrendProvider(query));
      try {
        await ref.read(waterLogTrendProvider(query).future);
      } on Object {
        // The provider publishes the error in the card, including on pull refresh.
      }
    }

    final subtitle = [
      widget.pondName,
      widget.seasonName,
    ].whereType<String>().where((value) => value.trim().isNotEmpty).join(' · ');
    final params = [
      waterLogFormParams[2],
      waterLogFormParams[1],
      waterLogFormParams[0],
      ...waterLogFormParams.skip(3),
    ];
    return Scaffold(
      body: WaterLogRefreshBoundary(
        onRefresh: refresh,
        child: AppGradientBackground(
          child: SafeArea(
            bottom: false,
            child: Column(
              children: [
                AppGradientBackground(
                  child: PageHeaderBar(
                    height: 78,
                    titleStyle:
                        AppTypography.display(
                          color: AppColors.ink,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          height: 1.25,
                        ).copyWith(
                          fontFamilyFallback: [
                            GoogleFonts.plusJakartaSans(
                              fontWeight: FontWeight.w700,
                            ).fontFamily!,
                          ],
                        ),
                    title: 'Thống kê chất lượng nước',
                    subtitle: subtitle.isEmpty ? null : subtitle,
                    backgroundColor: AppColors.backgroundTop,
                    onBack: context.pop,
                    backButton: SizedBox(
                      width: 36,
                      height: 36,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        tooltip: 'Quay lại',
                        onPressed: context.pop,
                        icon: SvgPicture.asset(
                          'assets/icons/water-log/water_back.svg',
                          width: 19.9898,
                          height: 19.9898,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: refresh,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                      child: Container(
                        key: const Key('water_trend_card'),
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 30,
                                        height: 32,
                                        margin: const EdgeInsets.only(top: 12),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFEAF4FF),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: SvgPicture.asset(
                                          'assets/icons/water-log/water_trend_drop.svg',
                                          width: 15.9999,
                                          height: 15.9999,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Xu hướng chất lượng nước',
                                              style:
                                                  AppTypography.display(
                                                    color: AppColors.ink,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w700,
                                                    height: 1.5,
                                                  ).copyWith(
                                                    fontFamilyFallback: [
                                                      GoogleFonts.plusJakartaSans(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ).fontFamily!,
                                                    ],
                                                  ),
                                            ),
                                            Text(
                                              '${state.asData?.value.logs.length ?? '—'} lần đo hợp lệ',
                                              style: const TextStyle(
                                                color: AppColors.inkMuted,
                                                fontSize: 10,
                                                height: 1.5,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFEEF1F6),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            for (final days in <int?>[
                                              7,
                                              30,
                                              null,
                                            ])
                                              Semantics(
                                                selected: _days == days,
                                                button: true,
                                                child: InkWell(
                                                  key: Key(
                                                    'water_range_${days ?? 'all'}',
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  onTap: () => setState(
                                                    () => _days = days,
                                                  ),
                                                  child: Container(
                                                    width: days == null
                                                        ? 40
                                                        : 32,
                                                    height: 40,
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                      color: _days == days
                                                          ? Colors.white
                                                          : Colors.transparent,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            8,
                                                          ),
                                                      boxShadow: _days == days
                                                          ? const [
                                                              BoxShadow(
                                                                color: Color(
                                                                  0x18000000,
                                                                ),
                                                                blurRadius: 3,
                                                                offset: Offset(
                                                                  0,
                                                                  1,
                                                                ),
                                                              ),
                                                            ]
                                                          : null,
                                                    ),
                                                    child: Text(
                                                      days == null
                                                          ? 'Tất\ncả'
                                                          : '${days}N',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        color: _days == days
                                                            ? AppColors.ocean
                                                            : AppColors
                                                                  .inkMuted,
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        height: 1.5,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  SizedBox(
                                    height: 36,
                                    child: ListView.separated(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: params.length,
                                      separatorBuilder: (_, _) =>
                                          const SizedBox(width: 6),
                                      itemBuilder: (_, index) {
                                        final param = params[index];
                                        final selected = param.field == _field;
                                        return Semantics(
                                          selected: selected,
                                          button: true,
                                          child: InkWell(
                                            key: Key(
                                              'water_metric_${param.field}',
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            onTap: () => setState(
                                              () => _field = param.field,
                                            ),
                                            child: Container(
                                              alignment: Alignment.center,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: selected
                                                    ? AppColors.ocean
                                                    : Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                border: Border.all(
                                                  color: selected
                                                      ? AppColors.ocean
                                                      : const Color(0xFFEEF1F7),
                                                ),
                                              ),
                                              child: Text(
                                                param.label,
                                                style: TextStyle(
                                                  color: selected
                                                      ? Colors.white
                                                      : AppColors.inkSoft,
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(height: 1, color: Color(0xFFEEF1F7)),
                            state.when(
                              skipLoadingOnRefresh: false,
                              loading: () => const SizedBox(
                                height: 280,
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                              error: (error, _) => Padding(
                                padding: const EdgeInsets.all(24),
                                child: Column(
                                  children: [
                                    Text(
                                      error is AppException
                                          ? error.message
                                          : 'Không thể tải thống kê. Vui lòng thử lại.',
                                      textAlign: TextAlign.center,
                                    ),
                                    TextButton(
                                      onPressed: refresh,
                                      child: const Text('Thử lại'),
                                    ),
                                  ],
                                ),
                              ),
                              data: (data) => Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Biểu đồ theo thời gian',
                                    style: TextStyle(
                                      color: AppColors.ink,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Container(
                                    clipBehavior: Clip.antiAlias,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(18),
                                      border: Border.all(color: AppColors.line),
                                    ),
                                    child: WaterMetricTrend(
                                      key: ValueKey((_days, _field, data)),
                                      field: _field,
                                      logs: data.logs,
                                      metric: data.metadata.metrics.firstWhere(
                                        (metric) => metric.field == _field,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (state.asData?.value case final data?) ...[
                              const SizedBox(height: 16),
                              WaterThresholdSummary(
                                logs: data.logs,
                                metadata: data.metadata,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
