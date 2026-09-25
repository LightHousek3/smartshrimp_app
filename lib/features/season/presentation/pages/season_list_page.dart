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
  Timer? _debounce;
  SeasonStatus? _status;

  SeasonListScope get _scope => (farmId: widget.farmId, pondId: widget.pondId);

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_loadMore);
  }

  @override
  void dispose() {
    _debounce?.cancel();
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
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      ref
          .read(seasonListControllerProvider(_scope).notifier)
          .applyFilters(search: value);
    });
  }

  void _filter(SeasonStatus? status) {
    if (_status == status) return;
    setState(() => _status = status);
    ref
        .read(seasonListControllerProvider(_scope).notifier)
        .applyFilters(status: status, clearStatus: status == null);
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
        !pond.isArchived &&
        !pond.hasOpenSeason &&
        pond.type == PondType.aquaculture &&
        pond.status == PondStatus.available;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppGradientBackground(
        child: SafeArea(
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
                  padding: const EdgeInsets.fromLTRB(18, 16, 18, 0),
                  sliver: SliverToBoxAdapter(child: _header(pond, canCreate)),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(18, 18, 18, 0),
                  sliver: SliverToBoxAdapter(child: _searchBar()),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(18, 12, 0, 14),
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
        icon: Icons.arrow_back_ios_new_rounded,
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
      if (canCreate)
        FarmCircleButton(
          icon: Icons.add_rounded,
          tooltip: 'Tạo vụ nuôi',
          filled: true,
          onPressed: () => context.push(
            '/farms/${widget.farmId}/ponds/${widget.pondId}/seasons/create',
            extra: pond,
          ),
        ),
    ],
  );

  Widget _searchBar() => SizedBox(
    height: 44,
    child: TextField(
      controller: _searchController,
      onChanged: _search,
      decoration: InputDecoration(
        hintText: 'Tìm tên vụ nuôi...',
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

  Widget _filters() => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: <Widget>[
        _StatusFilter(
          label: 'Tất cả',
          selected: _status == null,
          onTap: () => _filter(null),
        ),
        for (final status in const <SeasonStatus>[
          SeasonStatus.planning,
          SeasonStatus.active,
          SeasonStatus.completed,
          SeasonStatus.cancelled,
        ]) ...<Widget>[
          const SizedBox(width: 8),
          _StatusFilter(
            label: seasonStatusLabel(status),
            selected: _status == status,
            onTap: () => _filter(status),
          ),
        ],
        const SizedBox(width: 18),
      ],
    ),
  );

  List<Widget> _content(SeasonPage page) {
    if (page.items.isEmpty) {
      return <Widget>[
        SliverFillRemaining(
          hasScrollBody: false,
          child: _SeasonEmpty(searching: _searchController.text.isNotEmpty),
        ),
      ];
    }
    return <Widget>[
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(18, 0, 18, 28),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE7F4FF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.waves_rounded,
                    color: AppColors.ocean,
                    size: 21,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    season.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.ink,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                SeasonStatusBadge(status: season.status),
              ],
            ),
            const SizedBox(height: 13),
            Row(
              children: <Widget>[
                Expanded(
                  child: _CardInfo(
                    label: 'LOẠI TÔM',
                    value: shrimpTypeLabel(season.shrimpType),
                  ),
                ),
                Expanded(
                  child: _CardInfo(
                    label: 'NGÀY THẢ',
                    value: seasonDateLabel(season.stockingDate),
                  ),
                ),
              ],
            ),
            if (season.status == SeasonStatus.active &&
                season.dayOfCulture != null) ...<Widget>[
              const SizedBox(height: 12),
              Text(
                'Ngày nuôi thứ ${season.dayOfCulture}',
                style: const TextStyle(
                  color: AppColors.ocean,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ],
        ),
      ),
    ),
  );
}

class _CardInfo extends StatelessWidget {
  const _CardInfo({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        label,
        style: const TextStyle(
          color: AppColors.inkMuted,
          fontSize: 9,
          fontWeight: FontWeight.w600,
        ),
      ),
      const SizedBox(height: 4),
      Text(
        value,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: AppColors.inkSoft,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    ],
  );
}

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
  Widget build(BuildContext context) => ChoiceChip(
    label: Text(label),
    selected: selected,
    onSelected: (_) => onTap(),
    showCheckmark: false,
    backgroundColor: const Color(0xCFFFFFFF),
    selectedColor: AppColors.ocean,
    side: BorderSide(color: selected ? AppColors.ocean : AppColors.line),
    labelStyle: TextStyle(
      color: selected ? Colors.white : AppColors.inkSoft,
      fontSize: 12,
      fontWeight: FontWeight.w700,
    ),
  );
}

class _SeasonEmpty extends StatelessWidget {
  const _SeasonEmpty({required this.searching});
  final bool searching;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Icon(Icons.waves_outlined, size: 48, color: AppColors.inkMuted),
          const SizedBox(height: 12),
          Text(
            searching ? 'Không tìm thấy vụ nuôi' : 'Ao chưa có vụ nuôi',
            style: const TextStyle(
              color: AppColors.ink,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            searching
                ? 'Hãy thử từ khóa hoặc trạng thái khác.'
                : 'Nhấn nút + để tạo vụ nuôi đầu tiên.',
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.inkMuted, fontSize: 12),
          ),
        ],
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
