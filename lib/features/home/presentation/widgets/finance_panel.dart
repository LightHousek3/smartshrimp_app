import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/widgets/app_svg_icon.dart';
import 'package:smartshrimp_app/features/home/domain/entities/owner_dashboard.dart';
import 'package:smartshrimp_app/features/home/presentation/view_models/owner_dashboard_controller.dart';
import 'package:smartshrimp_app/features/home/presentation/widgets/dashboard_widgets.dart';
import 'package:smartshrimp_app/features/home/presentation/widgets/finance_chart.dart';
import 'package:smartshrimp_app/features/home/presentation/widgets/finance_filters.dart';
import 'package:smartshrimp_app/features/home/presentation/widgets/finance_totals.dart';

class FinancePanel extends ConsumerWidget {
  const FinancePanel({required this.farms, required this.today, super.key});
  final List<DashboardFarm> farms;
  final DateTime today;

  @override
  Widget build(BuildContext context, WidgetRef ref) => Column(
    children: [
      DashboardSectionTitle(
        'Thống kê thu chi',
        trailing: TextButton(
          onPressed: () =>
              Navigator.of(context, rootNavigator: true).push<void>(
                MaterialPageRoute(
                  builder: (_) => FinanceFullscreen(farms: farms, today: today),
                ),
              ),
          style: TextButton.styleFrom(
            textStyle: Theme.of(context).textTheme.bodyMedium,
            padding: EdgeInsets.zero,
            minimumSize: const Size(0, 32),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppSvgIcon(
                AppSvgIconName.expand,
                color: AppColors.ocean,
                size: 12,
              ),
              SizedBox(width: 5),
              Text(
                'Toàn màn hình',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
      DashboardCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FinanceFilters(farms: farms, today: today),
            const SizedBox(height: 14),
            ref
                .watch(ownerFinanceProvider)
                .when(
                  skipLoadingOnRefresh: false,
                  skipLoadingOnReload: false,
                  loading: () => const SizedBox(
                    height: 220,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (error, _) => DashboardFailure(
                    error: error,
                    onRetry: () => ref.invalidate(ownerFinanceProvider),
                  ),
                  data: (finance) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FinanceRange(finance),
                      const SizedBox(height: 16),
                      FinanceChart(months: finance.months),
                      const SizedBox(height: 16),
                      FinanceTotalsView(totals: finance.totals),
                    ],
                  ),
                ),
          ],
        ),
      ),
    ],
  );
}

class FinanceFullscreen extends StatefulWidget {
  const FinanceFullscreen({
    required this.farms,
    required this.today,
    super.key,
  });
  final List<DashboardFarm> farms;
  final DateTime today;

  @override
  State<FinanceFullscreen> createState() => _FinanceFullscreenState();
}

class _FinanceFullscreenState extends State<FinanceFullscreen> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: dashboardPanel,
    resizeToAvoidBottomInset: false,
    body: SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final media = MediaQuery.of(context);
          final portrait = media.orientation == Orientation.portrait;
          final logicalSize = portrait
              ? Size(constraints.maxHeight, constraints.maxWidth)
              : constraints.biggest;
          // Popup routes need the same coordinate space and orientation as the chart.
          // Keep rotation local: other screens and the device orientation stay untouched.
          return RotatedBox(
            quarterTurns: portrait ? 1 : 0,
            child: MediaQuery(
              data: media.copyWith(
                size: logicalSize,
                padding: EdgeInsets.zero,
                viewPadding: EdgeInsets.zero,
                viewInsets: portrait
                    ? _landscapeInsets(media.viewInsets)
                    : media.viewInsets,
                systemGestureInsets: portrait
                    ? _landscapeInsets(media.systemGestureInsets)
                    : media.systemGestureInsets,
              ),
              child: NavigatorPopHandler<void>(
                onPopWithResult: (_) => _navigatorKey.currentState!.pop(),
                child: Navigator(
                  key: _navigatorKey,
                  onGenerateRoute: (_) => MaterialPageRoute<void>(
                    builder: (_) => _FinanceFullscreenContent(
                      farms: widget.farms,
                      today: widget.today,
                      onClose: () => Navigator.of(context).pop(),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    ),
  );
}

EdgeInsets _landscapeInsets(EdgeInsets insets) =>
    EdgeInsets.fromLTRB(insets.top, insets.right, insets.bottom, insets.left);

class _FinanceFullscreenContent extends ConsumerWidget {
  const _FinanceFullscreenContent({
    required this.farms,
    required this.today,
    required this.onClose,
  });
  final List<DashboardFarm> farms;
  final DateTime today;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context, WidgetRef ref) => Column(
    children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 6),
        child: Row(
          children: [
            IconButton(
              tooltip: 'Quay lại',
              onPressed: onClose,
              icon: const AppSvgIcon(
                AppSvgIconName.back,
                size: 20,
                color: AppColors.inkSoft,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Thống kê thu chi',
              style: dashboardDisplay(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.ink,
              ),
            ),
          ],
        ),
      ),
      Expanded(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
          child: LayoutBuilder(
            builder: (context, layout) => Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: (layout.maxWidth * 0.4).clamp(220, 360),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FinanceFilters(
                          farms: farms,
                          today: today,
                          useRootNavigator: false,
                        ),
                        const SizedBox(height: 12),
                        ref
                            .watch(ownerFinanceProvider)
                            .when(
                              skipLoadingOnRefresh: false,
                              skipLoadingOnReload: false,
                              loading: () => const Center(
                                child: CircularProgressIndicator(),
                              ),
                              error: (error, _) => DashboardFailure(
                                error: error,
                                onRetry: () =>
                                    ref.invalidate(ownerFinanceProvider),
                              ),
                              data: (finance) => Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  FinanceRange(finance),
                                  const SizedBox(height: 14),
                                  FinanceTotalsView(
                                    totals: finance.totals,
                                    panel: false,
                                    useRootNavigator: false,
                                  ),
                                ],
                              ),
                            ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: DashboardCard(
                    child: ref
                        .watch(ownerFinanceProvider)
                        .when(
                          skipLoadingOnRefresh: false,
                          skipLoadingOnReload: false,
                          loading: () =>
                              const Center(child: CircularProgressIndicator()),
                          error: (error, _) => DashboardFailure(
                            error: error,
                            onRetry: () => ref.invalidate(ownerFinanceProvider),
                          ),
                          data: (finance) => SingleChildScrollView(
                            child: FinanceChart(
                              months: finance.months,
                              height: (layout.maxHeight - 66).clamp(100, 600),
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
    ],
  );
}
