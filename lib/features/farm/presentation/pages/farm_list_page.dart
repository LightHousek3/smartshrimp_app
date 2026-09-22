import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/widgets/app_gradient_background.dart';
import 'package:smartshrimp_app/features/farm/domain/entities/farm.dart';
import 'package:smartshrimp_app/features/farm/presentation/view_models/farm_controller.dart';
import 'package:smartshrimp_app/features/farm/presentation/widgets/farm_ui.dart';

class FarmListPage extends ConsumerStatefulWidget {
  const FarmListPage({super.key});

  @override
  ConsumerState<FarmListPage> createState() => _FarmListPageState();
}

class _FarmListPageState extends ConsumerState<FarmListPage> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _scrollController
      ..removeListener(_handleScroll)
      ..dispose();
    super.dispose();
  }

  void _handleScroll() {
    if (_scrollController.position.extentAfter < 280) {
      ref.read(farmListControllerProvider.notifier).loadMore();
    }
  }

  void _search(String value) {
    setState(() {});
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      ref.read(farmListControllerProvider.notifier).load(search: value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final farms = ref.watch(farmListControllerProvider);
    return AppGradientBackground(
      child: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          color: AppColors.ocean,
          onRefresh: ref.read(farmListControllerProvider.notifier).refresh,
          child: CustomScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: <Widget>[
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 28, 16, 0),
                sliver: SliverToBoxAdapter(child: _buildHeader()),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                sliver: SliverToBoxAdapter(child: _buildSearch()),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 12)),
              ...farms.when(
                data: (page) => _buildFarmSlivers(page.items, page.hasNextPage),
                loading: () => const <Widget>[
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: CircularProgressIndicator(color: AppColors.ocean),
                    ),
                  ),
                ],
                error: (error, _) => <Widget>[
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: _FarmError(
                      message: error is AppException
                          ? error.message
                          : 'Không thể tải danh sách trang trại.',
                      onRetry: ref
                          .read(farmListControllerProvider.notifier)
                          .refresh,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Trang trại',
          style: TextStyle(
            color: Color(0xFF0B1F3A),
            fontSize: 22,
            fontWeight: FontWeight.w800,
            height: 1.25,
            letterSpacing: -0.55,
          ),
        ),
        Text(
          'Quản lý trại, ao và vụ nuôi',
          style: TextStyle(color: AppColors.inkSoft, fontSize: 13, height: 1.5),
        ),
      ],
    );
  }

  Widget _buildSearch() {
    return Row(
      children: <Widget>[
        Expanded(
          child: SizedBox(
            height: 40,
            child: TextField(
              controller: _searchController,
              onChanged: _search,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: 'Tìm tên trang trại...',
                prefixIcon: const Icon(
                  Icons.location_on_outlined,
                  size: 16,
                  color: AppColors.inkMuted,
                ),
                prefixIconConstraints: const BoxConstraints(minWidth: 38),
                suffixIcon: _searchController.text.isEmpty
                    ? null
                    : IconButton(
                        tooltip: 'Xóa tìm kiếm',
                        onPressed: () {
                          _searchController.clear();
                          setState(() {});
                          _search('');
                        },
                        icon: const Icon(Icons.close_rounded, size: 19),
                      ),
                hintStyle: const TextStyle(
                  color: AppColors.inkMuted,
                  fontSize: 13,
                ),
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
          ),
        ),
        const SizedBox(width: 8),
        FarmCircleButton(
          icon: Icons.add_rounded,
          tooltip: 'Tạo trang trại',
          filled: true,
          size: 40,
          iconSize: 20,
          borderRadius: BorderRadius.circular(12),
          onPressed: () => context.push('/farms/create'),
        ),
      ],
    );
  }

  List<Widget> _buildFarmSlivers(List<Farm> farms, bool hasNextPage) {
    if (farms.isEmpty) {
      return <Widget>[
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverToBoxAdapter(
            child: _FarmEmptyState(
              searching: _searchController.text.trim().isNotEmpty,
            ),
          ),
        ),
      ];
    }
    return <Widget>[
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        sliver: SliverList.separated(
          itemCount: farms.length,
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          itemBuilder: (_, index) => _FarmCard(
            farm: farms[index],
            onTap: () => context.push('/farms/${farms[index].id}'),
          ),
        ),
      ),
      if (hasNextPage) const SliverToBoxAdapter(child: SizedBox(height: 24)),
    ];
  }
}

class _FarmCard extends StatelessWidget {
  const _FarmCard({required this.farm, required this.onTap});
  final Farm farm;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: const <BoxShadow>[
              BoxShadow(
                color: Color(0x0F000000),
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFE6F4FF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.grid_view_rounded,
                  color: Color(0xFF1D7AD6),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      farm.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.ink,
                        fontSize: 15,
                        height: 1.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      farm.address?.trim().isNotEmpty == true
                          ? farm.address!
                          : 'Chưa cập nhật địa chỉ',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.inkMuted,
                        fontSize: 12,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: <Widget>[
                        _FarmBadge(
                          '${farm.pondCount} ao',
                          background: const Color(0xFFEAF4FF),
                          foreground: const Color(0xFF0C4E8F),
                        ),
                        if (farm.activeSeasonCount > 0)
                          _FarmBadge(
                            '${farm.activeSeasonCount} vụ nuôi',
                            background: const Color(0xFFE2F6F3),
                            foreground: const Color(0xFF0F9B8E),
                            showDot: true,
                          ),
                        if (farm.totalAreaHectares != null)
                          _FarmBadge(
                            '${formatCompactNumber(farm.totalAreaHectares)} ha',
                            background: const Color(0xFFEEF1F6),
                            foreground: const Color(0xFF64748B),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.inkMuted,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FarmBadge extends StatelessWidget {
  const _FarmBadge(
    this.label, {
    required this.background,
    required this.foreground,
    this.showDot = false,
  });
  final String label;
  final Color background;
  final Color foreground;
  final bool showDot;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: background,
      borderRadius: BorderRadius.circular(100),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (showDot) ...<Widget>[
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: foreground,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
        ],
        Text(
          label,
          style: TextStyle(
            color: foreground,
            fontSize: 11,
            height: 1,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}

class _FarmEmptyState extends StatelessWidget {
  const _FarmEmptyState({required this.searching});
  final bool searching;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 202,
    child: CustomPaint(
      foregroundPainter: const _DashedRoundRectPainter(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: Color(0xFFEEF1F6),
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
            child: Icon(
              searching ? Icons.search_off_rounded : Icons.grid_view_rounded,
              color: AppColors.inkMuted,
              size: 22,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            searching ? 'Không tìm thấy trang trại' : 'Chưa có trang trại',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.ink,
              fontSize: 14,
              height: 1.5,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            searching
                ? 'Hãy thử một từ khóa khác.'
                : 'Nhấn nút + để tạo trang trại đầu tiên.',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.inkMuted,
              fontSize: 12,
              height: 1.5,
            ),
          ),
        ],
      ),
    ),
  );
}

class _DashedRoundRectPainter extends CustomPainter {
  const _DashedRoundRectPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final borderRect = Rect.fromLTWH(
      0.55,
      0.55,
      size.width - 1.1,
      size.height - 1.1,
    );
    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(borderRect, const Radius.circular(16)),
      );
    final paint = Paint()
      ..color = AppColors.line
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.1;
    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        canvas.drawPath(metric.extractPath(distance, distance + 5), paint);
        distance += 9;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _FarmError extends StatelessWidget {
  const _FarmError({required this.message, required this.onRetry});
  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Icon(
            Icons.cloud_off_rounded,
            size: 42,
            color: AppColors.inkMuted,
          ),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.inkSoft),
          ),
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
