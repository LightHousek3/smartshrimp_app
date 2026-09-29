import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/widgets/app_gradient_background.dart';
import 'package:smartshrimp_app/features/farm/presentation/widgets/farm_ui.dart';
import 'package:smartshrimp_app/features/pond/domain/entities/pond.dart';
import 'package:smartshrimp_app/features/pond/presentation/view_models/pond_controller.dart';
import 'package:smartshrimp_app/features/season/domain/entities/aquaculture_season.dart';
import 'package:smartshrimp_app/features/season/presentation/view_models/season_controller.dart';
import 'package:smartshrimp_app/features/season/presentation/widgets/season_ui.dart';

class SeasonListPage extends ConsumerStatefulWidget {
  const SeasonListPage({required this.farmId, required this.pondId, super.key});

  final String farmId;
  final String pondId;

  @override
  ConsumerState<SeasonListPage> createState() => _SeasonListPageState();
}

class _SeasonListPageState extends ConsumerState<SeasonListPage> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  Timer? _searchDebounce;
  SeasonStatus _status = SeasonStatus.active;
  bool _showSearch = false;

  SeasonListScope get _scope => (farmId: widget.farmId, pondId: widget.pondId);

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_loadMore);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref
          .read(seasonListControllerProvider(_scope).notifier)
          .applyFilters(status: _status);
    });
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    _scrollController
      ..removeListener(_loadMore)
      ..dispose();
    super.dispose();
  }

  void _loadMore() {
    if (_scrollController.position.extentAfter < 280) {
      ref.read(seasonListControllerProvider(_scope).notifier).loadMore();
    }
  }

  void _search(String value) {
    setState(() {});
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 350), () {
      ref
          .read(seasonListControllerProvider(_scope).notifier)
          .applyFilters(search: value);
    });
  }

  void _filter(SeasonStatus status) {
    if (_status == status) return;
    setState(() => _status = status);
    ref
        .read(seasonListControllerProvider(_scope).notifier)
        .applyFilters(status: status);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(seasonListControllerProvider(_scope));
    final pond = ref
        .watch(
          pondDetailControllerProvider((
            farmId: widget.farmId,
            pondId: widget.pondId,
          )),
        )
        .value;
    final canCreate =
        pond != null &&
        !pond.isDeleted &&
        !pond.hasOpenSeason &&
        pond.type == PondType.aquaculture &&
        pond.status == PondStatus.available;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppGradientBackground(
        child: SafeArea(
          top: false,
          bottom: false,
          child: RefreshIndicator(
            color: AppColors.ocean,
            onRefresh: ref
                .read(seasonListControllerProvider(_scope).notifier)
                .refresh,
            child: CustomScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: <Widget>[
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                    18,
                    seasonScreenTopPadding(context),
                    18,
                    0,
                  ),
                  sliver: SliverToBoxAdapter(child: _header(pond, canCreate)),
                ),
                if (_showSearch)
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                    sliver: SliverToBoxAdapter(child: _searchBar()),
                  ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 15, 16, 14),
                  sliver: SliverToBoxAdapter(child: _filters()),
                ),
                ...state.when(
                  data: _content,
                  loading: () => const <Widget>[
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColors.ocean,
                        ),
                      ),
                    ),
                  ],
                  error: (error, _) => <Widget>[
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: _SeasonError(
                        message: error is AppException
                            ? error.message
                            : 'Không thể tải danh sách vụ nuôi.',
                        onRetry: ref
                            .read(seasonListControllerProvider(_scope).notifier)
                            .refresh,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _header(Pond? pond, bool canCreate) => Row(
    children: <Widget>[
      FarmCircleButton(
        icon: Icons.adaptive.arrow_back,
        tooltip: 'Quay lại',
        onPressed: context.pop,
      ),
      const SizedBox(width: 13),
      const Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Vụ nuôi',
              style: TextStyle(
                color: AppColors.ink,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              'Theo dõi vụ hiện tại và lịch sử của ao',
              style: TextStyle(color: AppColors.inkMuted, fontSize: 11.5),
            ),
          ],
        ),
      ),
      FarmCircleButton(
        icon: _showSearch ? Icons.close_rounded : Icons.search_rounded,
        tooltip: _showSearch ? 'Đóng tìm kiếm' : 'Tìm kiếm vụ nuôi',
        onPressed: () {
          setState(() => _showSearch = !_showSearch);
          if (!_showSearch && _searchController.text.isNotEmpty) {
            _searchController.clear();
            _search('');
          }
        },
      ),
      if (canCreate)
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: FarmCircleButton(
            icon: Icons.add_rounded,
            tooltip: 'Tạo vụ nuôi',
            filled: true,
            onPressed: () => context.push(
              '/farms/${widget.farmId}/ponds/${widget.pondId}/seasons/create',
              extra: pond,
            ),
          ),
        ),
    ],
  );

  Widget _searchBar() => SizedBox(
    height: 44,
    child: TextField(
      controller: _searchController,
      autofocus: true,
      onChanged: _search,
      decoration: InputDecoration(
        hintText: 'Tìm tên vụ nuôi…',
        prefixIcon: const Icon(Icons.search_rounded, size: 20),
        suffixIcon: _searchController.text.isEmpty
            ? null
            : IconButton(
                tooltip: 'Xóa tìm kiếm',
                onPressed: () {
                  _searchController.clear();
                  _search('');
                },
                icon: const Icon(Icons.close_rounded, size: 19),
              ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 13),
      ),
    ),
  );

  Widget _filters() => Container(
    height: 52,
    padding: const EdgeInsets.all(4),
    decoration: BoxDecoration(
      color: const Color(0xB3D3E8FF),
      borderRadius: BorderRadius.circular(16),
    ),
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: <Widget>[
          for (final status in const <SeasonStatus>[
            SeasonStatus.active,
            SeasonStatus.planning,
            SeasonStatus.completed,
            SeasonStatus.cancelled,
          ]) ...<Widget>[
            _StatusFilter(
              label: switch (status) {
                SeasonStatus.completed => 'Hoàn tất',
                _ => seasonStatusLabel(status),
              },
              selected: _status == status,
              onTap: () => _filter(status),
            ),
            if (status != SeasonStatus.cancelled) const SizedBox(width: 4),
          ],
        ],
      ),
    ),
  );

  List<Widget> _content(SeasonPage page) {
    if (page.items.isEmpty) {
      return <Widget>[
        SliverFillRemaining(
          hasScrollBody: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 28),
            child: SeasonEmptyState(
              title: _searchController.text.isEmpty
                  ? 'Không có vụ nuôi'
                  : 'Không tìm thấy vụ nuôi',
              hint: _searchController.text.isEmpty
                  ? 'Chưa có vụ nào ở trạng thái "${seasonStatusLabel(_status)}".'
                  : 'Hãy thử từ khóa hoặc trạng thái khác.',
            ),
          ),
        ),
      ];
    }
    return <Widget>[
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 28),
        sliver: SliverList.separated(
          itemCount: page.items.length,
          separatorBuilder: (_, _) => const SizedBox(height: 11),
          itemBuilder: (_, index) {
            final season = page.items[index];
            return _SeasonCard(
              season: season,
              onTap: () => context.push(
                '/farms/${widget.farmId}/ponds/${widget.pondId}/seasons/${season.id}',
              ),
            );
          },
        ),
      ),
      if (page.hasNextPage)
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.only(bottom: 24),
            child: Center(
              child: CircularProgressIndicator(
                color: AppColors.ocean,
                strokeWidth: 2,
              ),
            ),
          ),
        ),
    ];
  }
}

class _SeasonCard extends StatelessWidget {
  const _SeasonCard({required this.season, required this.onTap});

  final AquacultureSeason season;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: SeasonSectionCard(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: 36,
              height: 36,
              margin: const EdgeInsets.only(top: 1),
              decoration: BoxDecoration(
                color: _seasonIconBackground(season.status),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.layers_rounded,
                color: _seasonIconForeground(season.status),
                size: 17,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          season.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.ink,
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(width: 7),
                      SeasonStatusBadge(status: season.status),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${season.pond.farm?.name ?? 'Trang trại'} · ${season.pond.name} · ${shrimpTypeLabel(season.shrimpType)}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.inkMuted,
                      fontSize: 11.5,
                    ),
                  ),
                  if (season.status == SeasonStatus.active) ...<Widget>[
                    const SizedBox(height: 5),
                    Text(
                      <String>[
                        if (season.dayOfCulture != null)
                          'DOC ${season.dayOfCulture}',
                        if (season.initialQuantity != null)
                          'Thả ${seasonIntegerLabel(season.initialQuantity)} con',
                      ].join(' · '),
                      style: const TextStyle(
                        color: AppColors.ocean,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                  if (season.status == SeasonStatus.planning) ...<Widget>[
                    const SizedBox(height: 5),
                    Text(
                      season.approvedProductionProtocol == null
                          ? 'Chưa có phác đồ được duyệt'
                          : 'Phác đồ đã duyệt',
                      style: TextStyle(
                        color: season.approvedProductionProtocol == null
                            ? const Color(0xFFB86808)
                            : const Color(0xFF7B5BD6),
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 7, top: 4),
              child: Icon(
                Icons.chevron_right_rounded,
                size: 18,
                color: AppColors.inkMuted,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Color _seasonIconBackground(SeasonStatus status) => switch (status) {
  SeasonStatus.active => const Color(0xFFE2F6F3),
  SeasonStatus.planning => const Color(0xFFEFEAFC),
  SeasonStatus.cancelled => const Color(0xFFFBE6EA),
  _ => const Color(0xFFEEF1F6),
};

Color _seasonIconForeground(SeasonStatus status) => switch (status) {
  SeasonStatus.active => const Color(0xFF0F9B8E),
  SeasonStatus.planning => const Color(0xFF7B5BD6),
  SeasonStatus.cancelled => AppColors.error,
  _ => const Color(0xFF64748B),
};

class _StatusFilter extends StatelessWidget {
  const _StatusFilter({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    selected: selected,
    child: Material(
      color: selected ? const Color(0xFF1D7AD6) : const Color(0xA6FFFFFF),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 44),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Center(
              child: Text(
                label,
                style: TextStyle(
                  color: selected ? Colors.white : AppColors.inkSoft,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

class _SeasonError extends StatelessWidget {
  const _SeasonError({required this.message, required this.onRetry});
  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Icon(Icons.cloud_off_rounded, size: 44),
          const SizedBox(height: 12),
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Thử lại'),
          ),
        ],
      ),
    ),
  );
}
