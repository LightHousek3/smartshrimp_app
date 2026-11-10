import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/widgets/app_gradient_background.dart';
import 'package:smartshrimp_app/core/widgets/sticky_page_header.dart';
import 'package:smartshrimp_app/features/auth/domain/entities/auth_account.dart';
import 'package:smartshrimp_app/features/auth/presentation/view_models/auth_controller.dart';
import 'package:smartshrimp_app/features/season/presentation/view_models/season_controller.dart';
import 'package:smartshrimp_app/features/water_log/domain/entities/water_log.dart';
import 'package:smartshrimp_app/features/water_log/domain/entities/water_log_metadata.dart';
import 'package:smartshrimp_app/features/water_log/presentation/view_models/water_log_controller.dart';
import 'package:smartshrimp_app/features/water_log/presentation/widgets/owner_water_log_card.dart';
import 'package:smartshrimp_app/features/water_log/presentation/widgets/water_log_refresh_boundary.dart';
import 'package:smartshrimp_app/features/water_log/presentation/widgets/water_log_sheet_widgets.dart';

class OwnerWaterLogListPage extends ConsumerStatefulWidget {
  const OwnerWaterLogListPage({
    required this.farmId,
    required this.pondId,
    required this.seasonId,
    this.pondName,
    this.seasonName,
    super.key,
  });
  final String farmId, pondId, seasonId;
  final String? pondName, seasonName;
  @override
  ConsumerState<OwnerWaterLogListPage> createState() =>
      _OwnerWaterLogListPageState();
}

class _OwnerWaterLogListPageState extends ConsumerState<OwnerWaterLogListPage> {
  final _scroll = ScrollController();
  String get _path =>
      '/farms/${widget.farmId}/ponds/${widget.pondId}/seasons/${widget.seasonId}/water-logs';
  @override
  void initState() {
    super.initState();
    _scroll.addListener(_loadNearEnd);
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  void _loadNearEnd() {
    final state = ref.read(waterLogListProvider(widget.seasonId)).asData?.value;
    if (_scroll.position.isScrollingNotifier.value &&
        _scroll.position.extentAfter < 300 &&
        state != null &&
        state.paginationError == null) {
      _loadMore();
    }
  }

  Future<void> _loadMore() =>
      ref.read(waterLogListProvider(widget.seasonId).notifier).loadMore();
  Future<void> _refresh() async {
    invalidateWaterLogViews(ref, widget.seasonId);
    await ref.read(waterLogListProvider(widget.seasonId).notifier).refresh();
  }

  Future<void> _filter(WaterLogFilter filter) async {
    final notifier = ref.read(waterLogListProvider(widget.seasonId).notifier);
    if (notifier.filter == filter) return;
    if (_scroll.hasClients) _scroll.jumpTo(0);
    await notifier.setQuery(filter: filter);
  }

  void _detail(WaterLog log, WaterLogMetadata? metadata) {
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => SafeArea(
        child: SizedBox(
          height: MediaQuery.sizeOf(context).height * .8,
          child: Column(
            children: [
              WaterLogSheetHeader(
                title: 'Nhật ký đo nước',
                closeKey: const Key('close_owner_water_log'),
                onClose: () => Navigator.of(context).pop(),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: OwnerWaterLogCard(
                    log: log,
                    metadata: metadata,
                    showAudit: true,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authControllerProvider);
    if (auth.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (auth.value?.role != AccountRole.farmOwner) {
      return Scaffold(
        body: Center(child: Text(const UnsupportedRoleException().message)),
      );
    }
    // Deep links do not carry extra; reuse the owner season context in that case.
    final season = widget.pondName == null || widget.seasonName == null
        ? ref
              .watch(seasonDetailControllerProvider(widget.seasonId))
              .asData
              ?.value
        : null;
    final pondName = widget.pondName ?? season?.pond.name;
    final seasonName = widget.seasonName ?? season?.name;
    final state = ref.watch(waterLogListProvider(widget.seasonId));
    final metadata = ref.watch(waterLogMetadataProvider(widget.seasonId));
    final counts = state.asData?.value.page.counts;
    final selected = ref
        .read(waterLogListProvider(widget.seasonId).notifier)
        .filter;
    return Scaffold(
      body: WaterLogRefreshBoundary(
        onRefresh: _refresh,
        child: AppGradientBackground(
          child: SafeArea(
            bottom: false,
            child: Column(
              children: [
                PageHeaderBar(
                  title: 'Nhật ký đo nước',
                  subtitle: [
                    pondName,
                    seasonName,
                  ].whereType<String>().join(' · '),
                  onBack: context.pop,
                  trailing: TextButton.icon(
                    key: const Key('owner_water_statistics_button'),
                    onPressed: () => context.push(
                      '$_path/statistics',
                      extra: <String, String>{
                        'pondName': ?pondName,
                        'seasonName': ?seasonName,
                      },
                    ),
                    icon: const Icon(Icons.bar_chart_rounded, size: 18),
                    label: const Text('Thống kê'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                  child: Row(
                    children: [
                      for (final filter in WaterLogFilter.values) ...[
                        if (filter != WaterLogFilter.all)
                          const SizedBox(width: 6),
                        Expanded(
                          child: Semantics(
                            selected: selected == filter,
                            button: true,
                            child: Material(
                              color: selected == filter
                                  ? AppColors.ocean
                                  : const Color(0xFFEAF4FF),
                              borderRadius: BorderRadius.circular(14),
                              child: InkWell(
                                key: Key('owner_water_filter_${filter.name}'),
                                borderRadius: BorderRadius.circular(14),
                                onTap: () => _filter(filter),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 15,
                                    horizontal: 3,
                                  ),
                                  child: Text(
                                    switch (filter) {
                                      WaterLogFilter.all =>
                                        'Tất cả (${counts?.all ?? '—'})',
                                      WaterLogFilter.warning =>
                                        'Cảnh báo (${counts?.warning ?? '—'})',
                                      WaterLogFilter.voided =>
                                        'Vô hiệu (${counts?.voided ?? '—'})',
                                    },
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: selected == filter
                                          ? Colors.white
                                          : AppColors.inkSoft,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (metadata.hasError)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Text('Không tải được ngưỡng Min/Max.'),
                        ),
                        TextButton(
                          onPressed: () => ref.invalidate(
                            waterLogMetadataProvider(widget.seasonId),
                          ),
                          child: const Text('Thử lại ngưỡng'),
                        ),
                      ],
                    ),
                  ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _refresh,
                    child: CustomScrollView(
                      controller: _scroll,
                      physics: const AlwaysScrollableScrollPhysics(),
                      slivers: [
                        state.when(
                          skipLoadingOnRefresh: false,
                          loading: () => const SliverToBoxAdapter(
                            child: Padding(
                              padding: EdgeInsets.all(40),
                              child: Center(child: CircularProgressIndicator()),
                            ),
                          ),
                          error: (error, _) => SliverToBoxAdapter(
                            child: _Failure(error: error, retry: _refresh),
                          ),
                          data: (data) => SliverPadding(
                            padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                            sliver: SliverList.builder(
                              itemCount: data.page.items.length + 1,
                              itemBuilder: (context, index) {
                                if (index == data.page.items.length) {
                                  if (data.paginationError != null) {
                                    return _Failure(
                                      error: data.paginationError!,
                                      retry: _loadMore,
                                    );
                                  }
                                  if (data.loadingMore) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                  if (data.page.hasNextPage) {
                                    return TextButton(
                                      onPressed: _loadMore,
                                      child: const Text('Tải thêm'),
                                    );
                                  }
                                  if (data.page.items.isEmpty) {
                                    return Padding(
                                      padding: const EdgeInsets.all(36),
                                      child: Text(
                                        selected == WaterLogFilter.all
                                            ? 'Chưa có nhật ký đo nước.'
                                            : 'Không có bản ghi trong bộ lọc này.',
                                        textAlign: TextAlign.center,
                                      ),
                                    );
                                  }
                                  return const SizedBox.shrink();
                                }
                                final log = data.page.items[index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 14),
                                  child: OwnerWaterLogCard(
                                    key: ValueKey('owner_water_log_${log.id}'),
                                    log: log,
                                    metadata: metadata.asData?.value,
                                    onTap: () =>
                                        _detail(log, metadata.asData?.value),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
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

class _Failure extends StatelessWidget {
  const _Failure({required this.error, required this.retry});
  final Object error;
  final VoidCallback retry;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(32),
    child: Column(
      children: [
        Text(
          error is AppException
              ? (error as AppException).message
              : 'Đã xảy ra lỗi. Vui lòng thử lại.',
          textAlign: TextAlign.center,
        ),
        TextButton(onPressed: retry, child: const Text('Thử lại')),
      ],
    ),
  );
}
