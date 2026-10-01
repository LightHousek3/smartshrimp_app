import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/widgets/app_gradient_background.dart';
import 'package:smartshrimp_app/core/widgets/app_notice.dart';
import 'package:smartshrimp_app/features/assigned_season/domain/entities/assigned_season.dart';
import 'package:smartshrimp_app/features/assigned_season/presentation/view_models/assigned_season_controller.dart';

class AssignedSeasonListPage extends ConsumerStatefulWidget {
  const AssignedSeasonListPage({super.key});
  @override
  ConsumerState<AssignedSeasonListPage> createState() =>
      _AssignedSeasonListPageState();
}

class _AssignedSeasonListPageState
    extends ConsumerState<AssignedSeasonListPage> {
  final _scroll = ScrollController();
  bool _activeOnly = true;
  bool _loadingMore = false;
  String? _loadMoreError;
  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scroll.removeListener(_onScroll);
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(assignedSeasonListProvider);
    return AppGradientBackground(
      child: SafeArea(
        bottom: false,
        child: state.when(
          skipLoadingOnRefresh: true,
          skipError: true,
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.ocean),
          ),
          error: (error, _) => _ErrorState(
            message: _message(error),
            onRetry: () =>
                ref.read(assignedSeasonListProvider.notifier).refresh(),
          ),
          data: (page) => RefreshIndicator(
            onRefresh: _refresh,
            child: CustomScrollView(
              controller: _scroll,
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: <Widget>[
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(16, 26, 16, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Vụ nuôi',
                          style: TextStyle(
                            color: AppColors.ink,
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Các vụ nuôi bạn được phân công',
                          style: TextStyle(
                            color: AppColors.inkSoft,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                    child: _Segmented(
                      activeOnly: _activeOnly,
                      activeCount: page.activeResults,
                      totalCount: page.allResults,
                      onChanged: (value) {
                        setState(() {
                          _activeOnly = value;
                          _loadingMore = false;
                          _loadMoreError = null;
                        });
                        ref
                            .read(assignedSeasonListProvider.notifier)
                            .setActiveOnly(value);
                      },
                    ),
                  ),
                ),
                if (page.items.isEmpty)
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: _EmptyState(),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    sliver: SliverList.separated(
                      itemCount: page.items.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (_, index) =>
                          _SeasonCard(season: page.items[index]),
                    ),
                  ),
                if (page.hasNextPage || _loadMoreError != null)
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
        ),
      ),
    );
  }

  void _onScroll() {
    if (_scroll.hasClients && _scroll.position.extentAfter < 260) {
      final page = ref.read(assignedSeasonListProvider).value;
      if (page != null) _loadMore(page);
    }
  }

  Future<void> _refresh() async {
    try {
      await ref.read(assignedSeasonListProvider.notifier).refresh();
      if (mounted) setState(() => _loadMoreError = null);
    } on AppException catch (error) {
      if (mounted) AppNoticeService.danger(context, error.message);
    } on Object {
      if (mounted) {
        AppNoticeService.danger(
          context,
          'Không thể làm mới danh sách vụ nuôi. Vui lòng thử lại.',
        );
      }
    }
  }

  Future<void> _loadMore(AssignedSeasonPage page) async {
    if (_loadingMore || !page.hasNextPage) return;
    setState(() {
      _loadingMore = true;
      _loadMoreError = null;
    });
    try {
      await ref.read(assignedSeasonListProvider.notifier).loadMore();
    } on AppException catch (error) {
      if (mounted) setState(() => _loadMoreError = error.message);
    } on Object {
      if (mounted) {
        setState(
          () =>
              _loadMoreError = 'Không thể tải thêm vụ nuôi. Vui lòng thử lại.',
        );
      }
    } finally {
      if (mounted) setState(() => _loadingMore = false);
    }
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
                _StatusBadge(status: season.status),
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
                  const _MiniStat('SỨC KHỎE', 'Chưa có'),
                ],
              ),
          ],
        ),
      ),
    ),
  );
}

class _MiniStat extends StatelessWidget {
  const _MiniStat(this.label, this.value);
  final String label, value;
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
            style: const TextStyle(
              color: AppColors.ink,
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    ),
  );
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});
  final AssignedSeasonStatus status;
  @override
  Widget build(BuildContext context) {
    final (label, foreground, background) = switch (status) {
      AssignedSeasonStatus.planning => (
        '● Đang chuẩn bị',
        const Color(0xFF7B5BD6),
        const Color(0xFFEFEAFC),
      ),
      AssignedSeasonStatus.active => (
        '● Đang nuôi',
        const Color(0xFF0F9B8E),
        const Color(0xFFE2F6F3),
      ),
      AssignedSeasonStatus.completed => (
        '● Hoàn tất',
        const Color(0xFF52647F),
        const Color(0xFFEEF1F6),
      ),
      AssignedSeasonStatus.cancelled => (
        '● Đã hủy',
        AppColors.error,
        const Color(0xFFFBE6EA),
      ),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: foreground,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();
  @override
  Widget build(BuildContext context) => const Center(
    child: Padding(
      padding: EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            Icons.layers_clear_outlined,
            size: 48,
            color: AppColors.inkMuted,
          ),
          SizedBox(height: 12),
          Text(
            'Chưa có vụ nuôi được phân công',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.ink, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    ),
  );
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});
  final String message;
  final Future<void> Function() onRetry;
  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Icon(Icons.cloud_off_rounded, size: 48),
          const SizedBox(height: 12),
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Thử lại'),
          ),
        ],
      ),
    ),
  );
}

String _message(Object error) =>
    error is AppException ? error.message : 'Không thể tải danh sách vụ nuôi.';
