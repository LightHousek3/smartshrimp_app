import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/widgets/app_circle_button.dart';
import 'package:smartshrimp_app/core/widgets/app_dialog.dart';
import 'package:smartshrimp_app/core/widgets/app_gradient_background.dart';
import 'package:smartshrimp_app/core/widgets/app_notice.dart';
import 'package:smartshrimp_app/core/widgets/destructive_action_button.dart';
import 'package:smartshrimp_app/core/widgets/sticky_page_header.dart';
import 'package:smartshrimp_app/features/farm/presentation/widgets/farm_ui.dart';
import 'package:smartshrimp_app/features/pond/domain/entities/pond.dart';
import 'package:smartshrimp_app/features/pond/presentation/pages/pond_list_page.dart';
import 'package:smartshrimp_app/features/pond/presentation/view_models/pond_controller.dart';
import 'package:smartshrimp_app/features/season/domain/entities/aquaculture_season.dart';
import 'package:smartshrimp_app/features/season/presentation/view_models/season_controller.dart';
import 'package:smartshrimp_app/features/season/presentation/widgets/season_ui.dart';

class PondDetailPage extends ConsumerWidget {
  const PondDetailPage({required this.farmId, required this.pondId, super.key});

  final String farmId;
  final String pondId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ids = (farmId: farmId, pondId: pondId);
    final state = ref.watch(pondDetailControllerProvider(ids));
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppGradientBackground(
        child: SafeArea(
          bottom: false,
          child: state.when(
            data: (pond) => _PondDetailContent(pond: pond),
            loading: () => const Center(
              child: CircularProgressIndicator(color: AppColors.ocean),
            ),
            error: (error, _) => _DetailError(
              message: error is AppException
                  ? error.message
                  : 'Không thể tải chi tiết ao.',
              onRetry: ref
                  .read(pondDetailControllerProvider(ids).notifier)
                  .refresh,
            ),
          ),
        ),
      ),
    );
  }
}

enum _SeasonFilter { all, active, planning, completed, cancelled }

class _PondDetailContent extends ConsumerStatefulWidget {
  const _PondDetailContent({required this.pond});

  final Pond pond;

  @override
  ConsumerState<_PondDetailContent> createState() => _PondDetailContentState();
}

class _PondDetailContentState extends ConsumerState<_PondDetailContent> {
  final _searchController = TextEditingController();
  _SeasonFilter _filter = _SeasonFilter.all;

  Pond get pond => widget.pond;
  PondSeasonScope get _scope => (farmId: pond.farmId, pondId: pond.id);
  bool get _canCreateSeason =>
      !pond.isDeleted &&
      !pond.hasOpenSeason &&
      pond.type == PondType.aquaculture &&
      pond.status == PondStatus.available;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mutation = ref.watch(pondMutationControllerProvider(pond.farmId));
    final seasons = ref.watch(pondSeasonHistoryProvider(_scope));
    final ids = (farmId: pond.farmId, pondId: pond.id);
    return RefreshIndicator(
      color: AppColors.ocean,
      onRefresh: () async {
        ref.invalidate(pondSeasonHistoryProvider(_scope));
        await Future.wait(<Future<void>>[
          ref.read(pondDetailControllerProvider(ids).notifier).refresh(),
          ref.read(pondSeasonHistoryProvider(_scope).future),
        ]);
      },
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: <Widget>[
          StickyPageHeader(
            title: pond.name,
            subtitle: pond.farm?.name ?? 'Trang trại',
            onBack: mutation.isLoading ? null : context.pop,
            trailing: AppCircleButton(
              icon: Icons.edit_rounded,
              tooltip: 'Chỉnh sửa ao',
              size: 36,
              iconSize: 17,
              onPressed: mutation.isLoading
                  ? null
                  : () => context.push(
                      '/farms/${pond.farmId}/ponds/${pond.id}/edit',
                      extra: pond,
                    ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
            sliver: SliverList.list(
              children: <Widget>[
                _PondSummaryCard(pond: pond),
                const SizedBox(height: 16),
                _seasonHeading(mutation.isLoading),
                const SizedBox(height: 8),
                _seasonTools(),
                const SizedBox(height: 12),
                seasons.when(
                  data: _seasonContent,
                  loading: () => const Padding(
                    padding: EdgeInsets.symmetric(vertical: 18),
                    child: Center(
                      child: SizedBox.square(
                        dimension: 24,
                        child: CircularProgressIndicator(
                          color: AppColors.ocean,
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                  ),
                  error: (error, _) => _InlineError(
                    message: error is AppException
                        ? error.message
                        : 'Không thể tải danh sách vụ nuôi.',
                    onRetry: _refreshSeasons,
                  ),
                ),
                const SizedBox(height: 16),
                _deleteButton(mutation.isLoading),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _seasonHeading(bool loading) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 4),
    child: Row(
      children: <Widget>[
        const Expanded(
          child: Text(
            'Vụ nuôi',
            style: TextStyle(
              color: AppColors.ink,
              fontSize: 15,
              height: 1.5,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        if (_canCreateSeason)
          SizedBox(
            height: 32,
            child: TextButton.icon(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.ocean,
                backgroundColor: const Color(0xFFEAF4FF),
                disabledForegroundColor: AppColors.ocean.withValues(
                  alpha: 0.55,
                ),
                disabledBackgroundColor: const Color(0xFFEAF4FF),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(11),
                ),
                textStyle: const TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
              onPressed: loading ? null : _openCreateSeason,
              icon: const Icon(Icons.add_rounded, size: 14),
              label: const Text('Thêm vụ nuôi'),
            ),
          ),
      ],
    ),
  );

  void _openCreateSeason() {
    context.push(
      '/farms/${pond.farmId}/ponds/${pond.id}/seasons/create',
      extra: pond,
    );
  }

  Widget _seasonTools() => SizedBox(
    height: 36,
    child: Row(
      children: <Widget>[
        Expanded(
          child: TextField(
            controller: _searchController,
            onChanged: _search,
            style: const TextStyle(color: AppColors.ink, fontSize: 11),
            decoration: InputDecoration(
              hintText: 'Tìm vụ…',
              hintStyle: const TextStyle(
                color: AppColors.inkMuted,
                fontSize: 11,
              ),
              prefixIcon: const Icon(
                Icons.search_rounded,
                color: AppColors.inkMuted,
                size: 15,
              ),
              prefixIconConstraints: const BoxConstraints(
                minWidth: 31,
                minHeight: 36,
              ),
              suffixIcon: _searchController.text.isEmpty
                  ? null
                  : IconButton(
                      tooltip: 'Xóa tìm kiếm',
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 34,
                        minHeight: 36,
                      ),
                      onPressed: () {
                        _searchController.clear();
                        _search('');
                      },
                      icon: const Icon(Icons.close_rounded, size: 15),
                    ),
              isDense: true,
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 8),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.line),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.oceanLight),
              ),
            ),
          ),
        ),
        const SizedBox(width: 6),
        PopupMenuButton<_SeasonFilter>(
          tooltip: 'Lọc trạng thái vụ nuôi',
          initialValue: _filter,
          onSelected: _selectFilter,
          color: Colors.white,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          itemBuilder: (_) => const <PopupMenuEntry<_SeasonFilter>>[
            PopupMenuItem(
              value: _SeasonFilter.all,
              child: Text('Tất cả trạng thái'),
            ),
            PopupMenuItem(
              value: _SeasonFilter.active,
              child: Text('Đang nuôi'),
            ),
            PopupMenuItem(
              value: _SeasonFilter.planning,
              child: Text('Đang chuẩn bị'),
            ),
            PopupMenuItem(
              value: _SeasonFilter.completed,
              child: Text('Hoàn tất'),
            ),
            PopupMenuItem(
              value: _SeasonFilter.cancelled,
              child: Text('Đã hủy'),
            ),
          ],
          child: Container(
            width: 87,
            height: 36,
            padding: const EdgeInsets.only(left: 12, right: 7),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.line),
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    _filterLabel,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.inkSoft,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.inkSoft,
                  size: 17,
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );

  Widget _seasonContent(List<AquacultureSeason> seasons) {
    final filteredSeasons = _filterSeasons(seasons);
    final hasFilter =
        _searchController.text.trim().isNotEmpty ||
        _filter != _SeasonFilter.all;
    if (filteredSeasons.isEmpty) {
      return SeasonEmptyState(
        compact: true,
        showBackground: false,
        title: hasFilter ? 'Không tìm thấy vụ nuôi' : 'Chưa có vụ nuôi',
        hint: hasFilter
            ? 'Hãy thử từ khóa hoặc trạng thái khác.'
            : 'Ao chưa có vụ nuôi.',
      );
    }
    return Column(
      children: <Widget>[
        for (
          var index = 0;
          index < filteredSeasons.length;
          index++
        ) ...<Widget>[
          _PondSeasonCard(
            season: filteredSeasons[index],
            onTap: () => context.push(
              '/farms/${pond.farmId}/ponds/${pond.id}/seasons/${filteredSeasons[index].id}',
            ),
          ),
          if (index != filteredSeasons.length - 1) const SizedBox(height: 8),
        ],
      ],
    );
  }

  Widget _deleteButton(bool loading) => DestructiveActionButton(
    label: 'Xóa ao',
    loading: loading,
    onPressed: _delete,
  );

  String get _filterLabel => switch (_filter) {
    _SeasonFilter.all => 'Trạng thái',
    _SeasonFilter.active => 'Đang nuôi',
    _SeasonFilter.planning => 'Chuẩn bị',
    _SeasonFilter.completed => 'Hoàn tất',
    _SeasonFilter.cancelled => 'Đã hủy',
  };

  void _search(String value) {
    setState(() {});
  }

  void _selectFilter(_SeasonFilter value) {
    setState(() => _filter = value);
  }

  List<AquacultureSeason> _filterSeasons(List<AquacultureSeason> seasons) {
    final query = _searchController.text.trim().toLowerCase();
    return seasons
        .where((season) {
          final matchesSearch =
              query.isEmpty || season.name.toLowerCase().contains(query);
          final matchesStatus = switch (_filter) {
            _SeasonFilter.all => true,
            _SeasonFilter.active => season.status == SeasonStatus.active,
            _SeasonFilter.planning => season.status == SeasonStatus.planning,
            _SeasonFilter.completed => season.status == SeasonStatus.completed,
            _SeasonFilter.cancelled => season.status == SeasonStatus.cancelled,
          };
          return matchesSearch && matchesStatus;
        })
        .toList(growable: false);
  }

  Future<void> _refreshSeasons() async {
    ref.invalidate(pondSeasonHistoryProvider(_scope));
    await ref.read(pondSeasonHistoryProvider(_scope).future);
  }

  Future<void> _delete() async {
    final confirmed = await showAppConfirmDialog(
      context,
      entityLabel: 'ao',
      entityName: pond.name,
      retentionMessage:
          'Ao sẽ được ẩn khỏi danh sách quản lý. Dữ liệu lịch sử vẫn được giữ lại.',
      confirmLabel: 'Xóa ao',
      blockers: pond.hasOpenSeason
          ? const <String>[
              'Ao đang có vụ nuôi mở. Hãy hủy hoặc hoàn tất vụ nuôi trước khi xóa ao.',
            ]
          : const <String>[],
    );
    if (!confirmed || !mounted) return;
    try {
      await ref
          .read(pondMutationControllerProvider(pond.farmId).notifier)
          .delete(pond.id);
      if (!mounted) return;
      AppNoticeService.success(
        context,
        'Ao đã được ẩn khỏi danh sách và dữ liệu lịch sử vẫn được giữ lại.',
      );
      context.go('/farms/${pond.farmId}');
    } on AppException catch (error) {
      if (mounted) {
        AppNoticeService.danger(
          context,
          error.message,
          title: 'Không thể xóa ao',
        );
      }
    }
  }
}

class _PondSummaryCard extends StatelessWidget {
  const _PondSummaryCard({required this.pond});

  final Pond pond;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: const <BoxShadow>[
        BoxShadow(
          color: Color(0x0F000000),
          blurRadius: 6,
          offset: Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            _PondBadge(
              label: pondStatusLabel(pond.status),
              background: _pondStatusBackground(pond.status),
              foreground: _pondStatusForeground(pond.status),
            ),
            const SizedBox(width: 8),
            _PondBadge(
              label: pondTypeLabel(pond.type),
              background: const Color(0xFFEEF1F6),
              foreground: const Color(0xFF64748B),
            ),
          ],
        ),
        _PondInfoRow(
          icon: Icons.layers_rounded,
          iconColor: const Color(0xFF3B82F6),
          label: 'Diện tích mặt nước',
          value: '${formatCompactNumber(pond.areaM2)} m²',
        ),
        _PondInfoRow(
          icon: Icons.water_drop_outlined,
          iconColor: const Color(0xFF3B82F6),
          label: 'Độ sâu trung bình',
          value: '${formatCompactNumber(pond.depthM)} m',
        ),
        _PondInfoRow(
          icon: Icons.water_drop_outlined,
          iconColor: const Color(0xFF0F9B8E),
          label: 'Thể tích nước',
          value: '${formatCompactNumber(pond.volumeM3)} m³',
        ),
      ],
    ),
  );
}

class _PondBadge extends StatelessWidget {
  const _PondBadge({
    required this.label,
    required this.background,
    required this.foreground,
  });

  final String label;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: background,
      borderRadius: BorderRadius.circular(99),
    ),
    child: Text(
      label,
      style: TextStyle(
        color: foreground,
        fontSize: 11,
        height: 1,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}

class _PondInfoRow extends StatelessWidget {
  const _PondInfoRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 49,
    child: Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Icon(icon, size: 15, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.inkMuted,
                    fontSize: 11,
                    height: 1.5,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    color: AppColors.ink,
                    fontSize: 13,
                    height: 1.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class _PondSeasonCard extends StatelessWidget {
  const _PondSeasonCard({required this.season, required this.onTap});

  final AquacultureSeason season;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
    shadowColor: const Color(0x0D000000),
    elevation: 1,
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: <Widget>[
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: seasonStatusColors(season.status).background,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.layers_rounded,
                size: 16,
                color: seasonStatusColors(season.status).foreground,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    season.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.ink,
                      fontSize: 13,
                      height: 1.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    _subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
            SeasonStatusBadge(status: season.status),
            const SizedBox(width: 8),
            const Icon(
              Icons.chevron_right_rounded,
              size: 15,
              color: AppColors.inkMuted,
            ),
          ],
        ),
      ),
    ),
  );

  String get _subtitle {
    final parts = <String>[shrimpTypeLabel(season.shrimpType)];
    if (season.dayOfCulture != null) parts.add('DOC ${season.dayOfCulture}');
    return parts.join(' · ');
  }
}

class _InlineError extends StatelessWidget {
  const _InlineError({required this.message, required this.onRetry});

  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Row(
      children: <Widget>[
        const Icon(Icons.error_outline_rounded, color: AppColors.error),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            message,
            style: const TextStyle(color: AppColors.inkSoft, fontSize: 12),
          ),
        ),
        TextButton(onPressed: onRetry, child: const Text('Thử lại')),
      ],
    ),
  );
}

Color _pondStatusBackground(PondStatus status) => switch (status) {
  PondStatus.available => const Color(0xFFE2F6F3),
  PondStatus.maintenance => const Color(0xFFFBF0DC),
  _ => const Color(0xFFEEF1F6),
};

Color _pondStatusForeground(PondStatus status) => switch (status) {
  PondStatus.available => const Color(0xFF0F9B8E),
  PondStatus.maintenance => const Color(0xFFB86808),
  _ => const Color(0xFF64748B),
};

class _DetailError extends StatelessWidget {
  const _DetailError({required this.message, required this.onRetry});

  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) => Column(
    children: <Widget>[
      PageHeaderBar(title: 'Chi tiết ao', onBack: context.pop),
      Expanded(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Icon(Icons.error_outline_rounded, size: 44),
                const SizedBox(height: 10),
                Text(message, textAlign: TextAlign.center),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: onRetry,
                  child: const Text('Thử lại'),
                ),
              ],
            ),
          ),
        ),
      ),
    ],
  );
}
