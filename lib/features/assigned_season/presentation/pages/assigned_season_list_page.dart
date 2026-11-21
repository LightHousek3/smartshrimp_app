import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/errors/error_mapper.dart';
import 'package:smartshrimp_app/core/widgets/app_error_state.dart';
import 'package:smartshrimp_app/core/widgets/app_notice.dart';
import 'package:smartshrimp_app/core/widgets/app_search_toolbar.dart';
import 'package:smartshrimp_app/core/widgets/app_svg_icon.dart';
import 'package:smartshrimp_app/core/widgets/tab_page_layout.dart';
import 'package:smartshrimp_app/features/assigned_season/presentation/view_models/assigned_season_controller.dart';
import 'package:smartshrimp_app/features/season/presentation/widgets/season_ui.dart';
import 'package:smartshrimp_app/features/shrimp_health/domain/entities/shrimp_health_models.dart';

class AssignedSeasonListPage extends ConsumerStatefulWidget {
  const AssignedSeasonListPage({super.key});
  @override
  ConsumerState<AssignedSeasonListPage> createState() =>
      _AssignedSeasonListPageState();
}

class _AssignedSeasonListPageState
    extends ConsumerState<AssignedSeasonListPage> {
  final _scroll = ScrollController();
  late final TextEditingController _search;
  Timer? _debounce;
  int _queryEpoch = 0;
  bool _loadingMore = false;
  String? _loadMoreError;
  @override
  void initState() {
    super.initState();
    _search = TextEditingController(
      text: ref.read(assignedSeasonListProvider.notifier).filter.search,
    );
    _scroll.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scroll.removeListener(_onScroll);
    _scroll.dispose();
    _debounce?.cancel();
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(assignedSeasonListProvider);
    final controller = ref.read(assignedSeasonListProvider.notifier);
    final filter = controller.filter;
    final retainRows = controller.retainRowsOnRefresh && !state.hasError;
    final page = retainRows ? state.value : state.asData?.value;
    final farms = ref.watch(assignedSeasonFarmOptionsProvider);
    final showFarmError =
        page != null &&
        farms.hasError &&
        !farms.isLoading &&
        !state.hasError &&
        _loadMoreError == null;
    final filtered = filter.search.isNotEmpty || filter.farmId != null;
    ref.listen(assignedSeasonFarmOptionsProvider, (_, next) {
      final selectedFarm = ref
          .read(assignedSeasonListProvider.notifier)
          .filter
          .farmId;
      if (next.hasError || !next.hasValue || selectedFarm == null) return;
      if (next.value!.any((farm) => farm.id == selectedFarm)) return;
      // Assignment changes can remove the selected farm from the allowed choices.
      unawaited(_applyFilters(changeFarm: true));
      AppNoticeService.danger(
        context,
        'Trại đã chọn không còn vụ nuôi được phân công.',
      );
    });
    return TabPageLayout(
      title: 'Vụ nuôi',
      subtitle: 'Các vụ nuôi bạn được phân công',
      child: RefreshIndicator(
        onRefresh: _refresh,
        child: CustomScrollView(
          controller: _scroll,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: Column(
                  children: [
                    _SeasonSearchTools(
                      search: _search,
                      farms: farms,
                      farmId: filter.farmId,
                      onSearch: _onSearch,
                      onSubmit: () => unawaited(_applyFilters()),
                      onClear: () {
                        _search.clear();
                        unawaited(_applyFilters());
                      },
                      onFarm: (id) => unawaited(
                        _applyFilters(changeFarm: true, farmId: id),
                      ),
                    ),
                    if (showFarmError)
                      AppErrorState(
                        error: farms.error,
                        message: 'Không thể tải danh sách trại.',
                        actionLabel: 'Thử lại trại',
                        onRetry: () =>
                            ref.invalidate(assignedSeasonFarmOptionsProvider),
                      ),
                    const SizedBox(height: 12),
                    _Segmented(
                      activeOnly: filter.status == AssignedSeasonStatus.active,
                      activeCount: page?.activeResults,
                      totalCount: page?.allResults,
                      onChanged: (value) =>
                          unawaited(_applyFilters(activeOnly: value)),
                    ),
                    if (filtered)
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: _clearFilters,
                          child: const Text('Xóa bộ lọc'),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            // Keep controls mounted so typing, clearing and retrying work
            // while a different query is loading or has failed.
            state.when<Widget>(
              skipLoadingOnRefresh: retainRows,
              skipError: false,
              loading: () => const SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: CircularProgressIndicator(color: AppColors.ocean),
                ),
              ),
              error: (error, _) => SliverFillRemaining(
                hasScrollBody: false,
                child: AppErrorState(
                  error: error,
                  message: 'Không thể tải danh sách vụ nuôi.',
                  onRetry: _refresh,
                ),
              ),
              data: (result) => result.items.isEmpty
                  ? SliverFillRemaining(
                      hasScrollBody: false,
                      child: _EmptyState(
                        filtered: filtered,
                        onReset: _clearFilters,
                      ),
                    )
                  : SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                      sliver: SliverList.separated(
                        itemCount: result.items.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 12),
                        itemBuilder: (_, index) =>
                            _SeasonCard(season: result.items[index]),
                      ),
                    ),
            ),
            if (page != null && (page.hasNextPage || _loadMoreError != null))
              SliverToBoxAdapter(
                child: _PaginationFooter(
                  loading: _loadingMore,
                  error: _loadMoreError,
                  onRetry: () => _loadMore(page),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _onSearch(String _) {
    setState(() {});
    _debounce?.cancel();
    _debounce = Timer(
      AssignedSeasonRules.searchDebounce,
      () => unawaited(_applyFilters()),
    );
  }

  Future<void> _applyFilters({
    bool? activeOnly,
    bool changeFarm = false,
    String? farmId,
  }) async {
    _debounce?.cancel();
    final controller = ref.read(assignedSeasonListProvider.notifier);
    final current = controller.filter;
    final next = (
      status: activeOnly == null
          ? current.status
          : activeOnly
          ? AssignedSeasonStatus.active
          : null,
      search: _search.text.trim(),
      farmId: changeFarm ? farmId : current.farmId,
    );
    if (next == current) {
      setState(() {});
      return;
    }
    _resetPagination();
    // Invalidate the old query before a scroll reset can request its next page.
    final loading = controller.setFilters(
      status: next.status,
      search: next.search,
      farmId: next.farmId,
    );
    if (_scroll.hasClients) _scroll.jumpTo(0);
    await loading;
  }

  void _clearFilters() {
    _search.clear();
    unawaited(_applyFilters(changeFarm: true));
  }

  void _resetPagination() {
    setState(() {
      _queryEpoch++;
      _loadingMore = false;
      _loadMoreError = null;
    });
  }

  void _onScroll() {
    if (_scroll.hasClients && _scroll.position.extentAfter < 260) {
      final state = ref.read(assignedSeasonListProvider);
      if (state.isLoading ||
          state.hasError ||
          !ref.read(assignedSeasonListProvider.notifier).retainRowsOnRefresh) {
        return;
      }
      final page = state.value;
      if (page != null) _loadMore(page);
    }
  }

  Future<void> _refresh() async {
    _debounce?.cancel();
    // Refresh also supersedes any pagination spinner/error still in flight.
    _resetPagination();
    ref.invalidate(assignedSeasonFarmOptionsProvider);
    final controller = ref.read(assignedSeasonListProvider.notifier);
    if (_search.text.trim() != controller.filter.search) {
      await _applyFilters();
    } else {
      // The list state already owns the refresh failure.
      await AsyncValue.guard(controller.refresh);
    }
  }

  Future<void> _loadMore(AssignedSeasonPage page) async {
    if (_loadingMore || !page.hasNextPage) return;
    final epoch = _queryEpoch;
    setState(() {
      _loadingMore = true;
      _loadMoreError = null;
    });
    try {
      await ref.read(assignedSeasonListProvider.notifier).loadMore();
    } on Object catch (error) {
      if (mounted && epoch == _queryEpoch) {
        setState(
          () => _loadMoreError = ErrorMapper.displayMessage(
            error,
            fallback: 'Không thể tải thêm vụ nuôi. Vui lòng thử lại.',
          ),
        );
      }
    } finally {
      if (mounted && epoch == _queryEpoch) setState(() => _loadingMore = false);
    }
  }
}

/// Keep assignment filters independent from the shared toolbar layout.
class _SeasonSearchTools extends StatelessWidget {
  const _SeasonSearchTools({
    required this.search,
    required this.farms,
    required this.farmId,
    required this.onSearch,
    required this.onSubmit,
    required this.onClear,
    required this.onFarm,
  });
  final TextEditingController search;
  final AsyncValue<List<AssignedSeasonFarm>> farms;
  final String? farmId;
  final ValueChanged<String> onSearch;
  final VoidCallback onSubmit, onClear;
  final ValueChanged<String?> onFarm;

  @override
  Widget build(BuildContext context) {
    final choices = farms.value ?? const <AssignedSeasonFarm>[];
    final name = choices.where((farm) => farm.id == farmId).firstOrNull?.name;
    return AppSearchToolbar(
      search: TextField(
        key: const Key('assigned_season_search'),
        controller: search,
        onChanged: onSearch,
        onSubmitted: (_) => onSubmit(),
        textInputAction: TextInputAction.search,
        maxLength: AssignedSeasonRules.searchMaxLength,
        style: const TextStyle(color: AppColors.ink, fontSize: 13),
        decoration: InputDecoration(
          hintText: 'Tìm tên vụ nuôi hoặc tên ao…',
          counterText: '',
          hintStyle: const TextStyle(color: AppColors.inkMuted, fontSize: 13),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: AppColors.inkMuted,
            size: 15,
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 38,
            minHeight: 40,
          ),
          suffixIcon: search.text.isEmpty
              ? null
              : IconButton(
                  tooltip: 'Xóa tìm kiếm',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 38,
                    minHeight: 40,
                  ),
                  onPressed: onClear,
                  icon: const Icon(Icons.close_rounded, size: 19),
                ),
          isDense: true,
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.line),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: AppColors.oceanLight,
              width: 1.5,
            ),
          ),
        ),
      ),
      filter: PopupMenuButton<String>(
        key: const Key('assigned_season_farm_filter'),
        tooltip: 'Lọc trại',
        enabled: farms.hasValue && !farms.isLoading,
        initialValue: farmId ?? AssignedSeasonRules.allFarmsValue,
        onSelected: (value) =>
            onFarm(value == AssignedSeasonRules.allFarmsValue ? null : value),
        color: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        itemBuilder: (_) => [
          const PopupMenuItem(
            value: AssignedSeasonRules.allFarmsValue,
            child: Text('Tất cả trại'),
          ),
          for (final farm in choices)
            PopupMenuItem(value: farm.id, child: Text(farm.name)),
        ],
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: farmId == null ? AppColors.line : AppColors.ocean,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  farmId == null ? 'Tất cả trại' : name ?? 'Trại đã chọn',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.inkSoft,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              if (farms.isLoading)
                const SizedBox.square(
                  dimension: 14,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              else
                const AppSvgIcon(
                  AppSvgIconName.dropdownChevron,
                  color: AppColors.inkSoft,
                  size: 11,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PaginationFooter extends StatelessWidget {
  const _PaginationFooter({
    required this.loading,
    required this.error,
    required this.onRetry,
  });
  final bool loading;
  final String? error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
    child: Column(
      children: <Widget>[
        if (error != null) ...<Widget>[
          Text(
            error!,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.error, fontSize: 12),
          ),
          const SizedBox(height: 8),
        ],
        OutlinedButton.icon(
          onPressed: loading ? null : onRetry,
          icon: loading
              ? const SizedBox.square(
                  dimension: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.refresh_rounded),
          label: Text(loading ? 'Đang tải...' : 'Thử tải thêm'),
        ),
      ],
    ),
  );
}

class _Segmented extends StatelessWidget {
  const _Segmented({
    required this.activeOnly,
    required this.onChanged,
    this.activeCount,
    this.totalCount,
  });
  final bool activeOnly;
  final ValueChanged<bool> onChanged;
  final int? activeCount, totalCount;
  @override
  Widget build(BuildContext context) => Container(
    height: 52,
    padding: const EdgeInsets.all(4),
    decoration: BoxDecoration(
      color: const Color(0xB3D3E8FF),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Row(
      children: <Widget>[
        Expanded(
          child: _Tab(
            label: 'Đang nuôi${activeCount == null ? '' : ' ($activeCount)'}',
            selected: activeOnly,
            onTap: () => onChanged(true),
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: _Tab(
            label: 'Tất cả${totalCount == null ? '' : ' ($totalCount)'}',
            selected: !activeOnly,
            onTap: () => onChanged(false),
          ),
        ),
      ],
    ),
  );
}

class _Tab extends StatelessWidget {
  const _Tab({
    required this.label,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final bool selected;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Material(
    color: selected ? const Color(0xFF1D7AD6) : const Color(0x8CFFFFFF),
    borderRadius: BorderRadius.circular(12),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : AppColors.inkSoft,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    ),
  );
}

class _SeasonCard extends StatelessWidget {
  const _SeasonCard({required this.season});
  final AssignedSeason season;
  @override
  Widget build(BuildContext context) => Material(
    color: Colors.white,
    elevation: 8,
    shadowColor: const Color(0x590F1C2E),
    borderRadius: BorderRadius.circular(18),
    child: InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () => context.push('/seasons/${season.id}'),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 36,
                  height: 36,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: seasonStatusColors(season.status).background,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: AppSvgIcon(
                    AppSvgIconName.shrimp,
                    size: 20,
                    color: seasonStatusColors(season.status).foreground,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        season.pondName,
                        style: const TextStyle(
                          color: AppColors.ink,
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '${season.farmName} · ${season.name}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.inkMuted,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                SeasonStatusBadge(status: season.status),
              ],
            ),
            const SizedBox(height: 12),
            if (season.status == AssignedSeasonStatus.planning)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFE7FF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Chờ Chủ trại kích hoạt vụ. Chức năng ghi nhận vận hành chỉ mở khi vụ bắt đầu nuôi.',
                  style: TextStyle(
                    color: Color(0xFF7008E7),
                    fontSize: 11,
                    height: 1.45,
                  ),
                ),
              )
            else
              Row(
                children: <Widget>[
                  _MiniStat('DOC', season.dayOfCulture?.toString() ?? '—'),
                  const SizedBox(width: 8),
                  _MiniStat(
                    'MẬT ĐỘ',
                    season.initialDensityPerM2 == null
                        ? '—'
                        : '${season.initialDensityPerM2!.toStringAsFixed(season.initialDensityPerM2! % 1 == 0 ? 0 : 1)} con/m²',
                  ),
                  const SizedBox(width: 8),
                  _HealthStat(season.currentHealthStatus),
                ],
              ),
          ],
        ),
      ),
    ),
  );
}

/// Unknown server values must never silently become a healthy assessment.
class _HealthStat extends StatelessWidget {
  const _HealthStat(this.value);
  final String? value;

  @override
  Widget build(BuildContext context) {
    final status = HealthStatus.values
        .where((status) => status.toApiValue() == value)
        .firstOrNull;
    return _MiniStat(
      'SỨC KHỎE',
      value == null ? 'Chưa có' : status?.displayName ?? 'Không xác định',
      valueColor: status?.color ?? AppColors.inkMuted,
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat(this.label, this.value, {this.valueColor = AppColors.ink});
  final String label, value;
  final Color valueColor;
  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(
      height: 54,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xB3EEF1F6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            label,
            style: const TextStyle(color: AppColors.inkMuted, fontSize: 10),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: valueColor,
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    ),
  );
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({this.filtered = false, this.onReset});
  final bool filtered;
  final VoidCallback? onReset;
  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const AppSvgIcon(
            AppSvgIconName.shrimp,
            size: 48,
            color: AppColors.inkMuted,
          ),
          const SizedBox(height: 12),
          Text(
            filtered
                ? 'Không tìm thấy vụ nuôi phù hợp'
                : 'Chưa có vụ nuôi được phân công',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.ink,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (filtered)
            TextButton(
              onPressed: onReset,
              child: const Text('Xóa bộ lọc tìm kiếm'),
            ),
        ],
      ),
    ),
  );
}
