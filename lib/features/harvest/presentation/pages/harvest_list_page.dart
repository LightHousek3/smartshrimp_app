import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/widgets/app_gradient_background.dart';
import 'package:smartshrimp_app/core/widgets/gradient_button.dart';
import 'package:smartshrimp_app/core/widgets/sticky_page_header.dart';
import 'package:smartshrimp_app/features/harvest/domain/entities/harvest_event.dart';
import 'package:smartshrimp_app/features/harvest/presentation/view_models/harvest_controller.dart';
import 'package:smartshrimp_app/features/harvest/presentation/widgets/harvest_ui.dart';
import 'package:smartshrimp_app/features/season/domain/entities/aquaculture_season.dart';
import 'package:smartshrimp_app/features/season/presentation/view_models/season_controller.dart';

String _formatDateOnly(DateTime date) {
  final local = date.toLocal();
  final d = local.day.toString().padLeft(2, '0');
  final m = local.month.toString().padLeft(2, '0');
  return '$d/$m/${local.year}';
}

class HarvestListPage extends ConsumerStatefulWidget {
  const HarvestListPage({required this.seasonId, super.key});
  final String seasonId;
  @override
  ConsumerState<HarvestListPage> createState() => _HarvestListPageState();
}

class _HarvestListPageState extends ConsumerState<HarvestListPage> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.isScrollingNotifier.value &&
        _scrollController.position.extentAfter < 300 &&
        ref
                .read(harvestListProvider(widget.seasonId))
                .asData
                ?.value
                .paginationError ==
            null) {
      _loadMore();
    }
  }

  Future<void> _loadMore() =>
      ref.read(harvestListProvider(widget.seasonId).notifier).loadMore();

  Future<void> _refresh() async {
    await ref.read(harvestListProvider(widget.seasonId).notifier).refresh();
  }

  @override
  Widget build(BuildContext context) {
    final provider = harvestListProvider(widget.seasonId);
    final state = ref.watch(provider);
    final season =
        ref.watch(seasonDetailControllerProvider(widget.seasonId)).value;
    final base = GoRouterState.of(context).uri.path;

    return _HarvestListScaffold(
      title: 'Danh sách thu hoạch',
      subtitle:
          season == null ? null : '${season.pond.name} · ${season.name}',
      scrollController: _scrollController,
      onRefresh: _refresh,
      children: [
        // 1. Top row: 3 Summary Cards
        state.maybeWhen(
          data: (data) => Row(
            children: [
              Expanded(
                child: _SummaryCard(
                  value: data.totalResults.toString(),
                  label: 'SỐ LẦN THU',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _SummaryCard(
                  value: '${harvestNumber(data.totalWeightKg)} kg',
                  label: 'TỔNG SẢN LƯỢNG',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _SummaryCard(
                  value: '${harvestNumber(data.totalRevenue / 1000000)} tr',
                  label: 'DOANH THU',
                ),
              ),
            ],
          ),
          orElse: () => const Row(
            children: [
              Expanded(child: _SummaryCard(value: '—', label: 'SỐ LẦN THU')),
              SizedBox(width: 10),
              Expanded(child: _SummaryCard(value: '—', label: 'TỔNG SẢN LƯỢNG')),
              SizedBox(width: 10),
              Expanded(child: _SummaryCard(value: '—', label: 'DOANH THU')),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // 2. Action Button
        if (season?.status == SeasonStatus.active) ...[
          GradientButton(
            label: 'Ghi nhận thu hoạch',
            icon: Icons.add,
            compact: true,
            borderRadius: 14,
            onPressed: () => context.push('$base/create'),
          ),
          const SizedBox(height: 16),
        ],

        // 3. Harvest items list
        state.when(
          skipLoadingOnRefresh: false,
          loading: () => const Padding(
            padding: EdgeInsets.all(40),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (error, _) => HarvestErrorView(
            error: error,
            retry: () => ref.invalidate(provider),
          ),
          data: (data) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (data.items.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(
                    child: Text(
                      'Chưa có lần thu hoạch nào.',
                      style: TextStyle(color: AppColors.inkMuted, fontSize: 13),
                    ),
                  ),
                ),
              for (final event in data.items)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _HarvestItemCard(
                    event: event,
                    onTap: () => context.push('$base/${event.id}'),
                  ),
                ),

              // Load-more footer
              if (data.paginationError != null)
                _PaginationError(
                  error: data.paginationError!,
                  onRetry: _loadMore,
                )
              else if (data.loadingMore)
                const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (data.hasNextPage)
                Center(
                  child: TextButton(
                    onPressed: _loadMore,
                    child: const Text('Tải thêm'),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.value,
    required this.label,
  });

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF0F4F8)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x120F1C2E),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
          BoxShadow(
            color: Color(0x060F1C2E),
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.ink,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: AppColors.inkMuted,
              letterSpacing: 0.2,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _HarvestItemCard extends StatelessWidget {
  const _HarvestItemCard({
    required this.event,
    required this.onTap,
  });

  final HarvestEvent event;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFF0F4F8)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x120F1C2E),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
          BoxShadow(
            color: Color(0x060F1C2E),
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(22),
        child: InkWell(
          key: ValueKey('harvest-${event.id}'),
          onTap: onTap,
          borderRadius: BorderRadius.circular(22),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          harvestTypeLabel(event.harvestType),
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.ink,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          _formatDateOnly(event.harvestedAt),
                          style: const TextStyle(
                            fontSize: 12.5,
                            color: AppColors.inkMuted,
                          ),
                        ),
                      ],
                    ),
                    const Icon(
                      Icons.chevron_right_rounded,
                      size: 20,
                      color: AppColors.inkMuted,
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            const Text(
                              'Sản lượng',
                              style: TextStyle(
                                fontSize: 11,
                                color: AppColors.inkMuted,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${harvestNumber(event.totalWeightKg)} kg',
                              style: const TextStyle(
                                fontSize: 14.5,
                                fontWeight: FontWeight.w700,
                                color: AppColors.ink,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            const Text(
                              'Giá/kg',
                              style: TextStyle(
                                fontSize: 11,
                                color: AppColors.inkMuted,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              event.pricePerKg == null
                                  ? '—'
                                  : '${harvestNumber(event.pricePerKg)} đ',
                              style: const TextStyle(
                                fontSize: 14.5,
                                fontWeight: FontWeight.w700,
                                color: AppColors.ink,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            const Text(
                              'Doanh thu',
                              style: TextStyle(
                                fontSize: 11,
                                color: AppColors.inkMuted,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              event.totalRevenue == null
                                  ? '—'
                              : '${harvestNumber(event.totalRevenue)} đ',
                              style: const TextStyle(
                                fontSize: 14.5,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF0F9B8E),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ],
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

class _HarvestListScaffold extends StatelessWidget {
  const _HarvestListScaffold({
    required this.title,
    required this.children,
    required this.scrollController,
    this.subtitle,
    this.onRefresh,
  });
  final String title;
  final String? subtitle;
  final List<Widget> children;
  final ScrollController scrollController;
  final Future<void> Function()? onRefresh;

  @override
  Widget build(BuildContext context) {
    final scroll = CustomScrollView(
      controller: scrollController,
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

class _PaginationError extends StatelessWidget {
  const _PaginationError({required this.error, required this.onRetry});
  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: Column(
          children: [
            Text(
              harvestError(error),
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.inkMuted, fontSize: 12),
            ),
            TextButton(
              onPressed: onRetry,
              child: const Text('Thử lại'),
            ),
          ],
        ),
      );
}
