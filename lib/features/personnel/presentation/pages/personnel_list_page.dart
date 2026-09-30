import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshrimp_app/app/router/app_router.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/widgets/app_feedback.dart';
import 'package:smartshrimp_app/core/widgets/app_gradient_background.dart';
import 'package:smartshrimp_app/features/personnel/domain/entities/managed_personnel.dart';
import 'package:smartshrimp_app/features/personnel/presentation/view_models/personnel_controller.dart';
import 'package:smartshrimp_app/features/personnel/presentation/widgets/personnel_visuals.dart';

class PersonnelListPage extends ConsumerStatefulWidget {
  const PersonnelListPage({super.key});

  @override
  ConsumerState<PersonnelListPage> createState() => _PersonnelListPageState();
}

class _PersonnelListPageState extends ConsumerState<PersonnelListPage> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  PersonnelRoleFilter _roleFilter = PersonnelRoleFilter.all;
  PersonnelStatusFilter _statusFilter = PersonnelStatusFilter.all;
  Timer? _debounce;
  bool _loadingMore = false;

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

  Future<void> _handleScroll() async {
    if (_scrollController.position.extentAfter >= 280 || _loadingMore) return;
    setState(() => _loadingMore = true);
    try {
      await ref.read(personnelListControllerProvider.notifier).loadMore();
    } on Object catch (error) {
      if (!mounted) return;
      AppFeedback.danger(context, _errorMessage(error, loadingMore: true));
    } finally {
      if (mounted) setState(() => _loadingMore = false);
    }
  }

  void _search(String value) {
    setState(() {});
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), _applyFilters);
  }

  void _changeRole(PersonnelRoleFilter filter) {
    if (_roleFilter == filter) return;
    setState(() => _roleFilter = filter);
    _applyFilters();
  }

  void _changeStatus(PersonnelStatusFilter filter) {
    if (_statusFilter == filter) return;
    setState(() => _statusFilter = filter);
    _applyFilters();
  }

  void _applyFilters() {
    ref
        .read(personnelListControllerProvider.notifier)
        .applyFilters(
          roleFilter: _roleFilter,
          statusFilter: _statusFilter,
          search: _searchController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(personnelListControllerProvider);
    return AppGradientBackground(
      child: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          color: AppColors.ocean,
          onRefresh: ref.read(personnelListControllerProvider.notifier).refresh,
          child: CustomScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: <Widget>[
              const SliverPadding(
                padding: EdgeInsets.fromLTRB(12, 8, 16, 0),
                sliver: SliverToBoxAdapter(child: _Header()),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                sliver: SliverToBoxAdapter(child: _buildSearch()),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                sliver: SliverToBoxAdapter(child: _buildFilters()),
              ),
              ...state.when(
                data: _buildData,
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
                    child: _PersonnelError(
                      message: _errorMessage(error),
                      onRetry: ref
                          .read(personnelListControllerProvider.notifier)
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

  Widget _buildSearch() => SizedBox(
    height: 44,
    child: TextField(
      controller: _searchController,
      onChanged: _search,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: 'Tìm kiếm theo tên',
        prefixIcon: const Icon(
          Icons.groups_outlined,
          size: 17,
          color: AppColors.inkMuted,
        ),
        suffixIcon: _searchController.text.isEmpty
            ? null
            : IconButton(
                tooltip: 'Xóa tìm kiếm',
                onPressed: () {
                  _searchController.clear();
                  setState(() {});
                  _applyFilters();
                },
                icon: const Icon(Icons.close_rounded, size: 19),
              ),
        hintStyle: const TextStyle(color: AppColors.inkMuted, fontSize: 13),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: const BorderSide(color: AppColors.line),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: const BorderSide(color: AppColors.oceanLight, width: 1.5),
        ),
      ),
    ),
  );

  Widget _buildFilters() => LayoutBuilder(
    builder: (context, constraints) {
      final roleFilters = Container(
        key: const Key('personnel_role_filters'),
        height: 48,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: const Color(0xB3D3E8FF),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: _RoleChip(
                label: 'Tất cả',
                selected: _roleFilter == PersonnelRoleFilter.all,
                onTap: () => _changeRole(PersonnelRoleFilter.all),
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: _RoleChip(
                label: 'KTV',
                selected: _roleFilter == PersonnelRoleFilter.technician,
                onTap: () => _changeRole(PersonnelRoleFilter.technician),
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: _RoleChip(
                label: 'Chuyên gia',
                selected: _roleFilter == PersonnelRoleFilter.expert,
                onTap: () => _changeRole(PersonnelRoleFilter.expert),
              ),
            ),
          ],
        ),
      );
      return SizedBox(
        height: 48,
        child: Row(
          children: <Widget>[
            if (constraints.maxWidth >= 600)
              SizedBox(width: 300, child: roleFilters)
            else
              Expanded(child: roleFilters),
            const SizedBox(width: 5),
            SizedBox(
              key: const Key('personnel_status_filter'),
              width: 124,
              height: 48,
              child: PopupMenuButton<PersonnelStatusFilter>(
                tooltip: 'Lọc trạng thái',
                initialValue: _statusFilter,
                onSelected: _changeStatus,
                color: Colors.white,
                surfaceTintColor: Colors.transparent,
                shadowColor: const Color(0x260F1C2E),
                elevation: 10,
                position: PopupMenuPosition.under,
                offset: const Offset(0, 6),
                constraints: const BoxConstraints.tightFor(width: 190),
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: const BorderSide(color: AppColors.line),
                ),
                itemBuilder: (_) => PersonnelStatusFilter.values
                    .map((status) {
                      final selected = status == _statusFilter;
                      return PopupMenuItem<PersonnelStatusFilter>(
                        value: status,
                        height: 42,
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                _statusFilterLabel(status),
                                style: TextStyle(
                                  color: selected
                                      ? AppColors.ocean
                                      : AppColors.inkSoft,
                                  fontSize: 12,
                                  fontWeight: selected
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                ),
                              ),
                            ),
                            if (selected) ...<Widget>[
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.check_rounded,
                                size: 17,
                                color: AppColors.ocean,
                              ),
                            ],
                          ],
                        ),
                      );
                    })
                    .toList(growable: false),
                child: Container(
                  padding: const EdgeInsets.only(left: 11, right: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.line),
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          _statusFilterLabel(_statusFilter),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.inkSoft,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 3),
                      const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 16,
                        color: AppColors.inkMuted,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );

  List<Widget> _buildData(ManagedPersonnelPage page) {
    if (page.items.isEmpty) {
      return <Widget>[
        SliverFillRemaining(
          hasScrollBody: false,
          child: _PersonnelEmpty(
            filtered:
                _searchController.text.trim().isNotEmpty ||
                _roleFilter != PersonnelRoleFilter.all ||
                _statusFilter != PersonnelStatusFilter.all,
          ),
        ),
      ];
    }

    return <Widget>[
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        sliver: SliverList.separated(
          itemCount: page.items.length,
          separatorBuilder: (_, _) => const SizedBox(height: 11),
          itemBuilder: (_, index) {
            final personnel = page.items[index];
            return _PersonnelCard(
              personnel: personnel,
              onTap: () => context.push('/personnel/${personnel.id}'),
            );
          },
        ),
      ),
      if (_loadingMore)
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.only(bottom: 18),
            child: Center(
              child: SizedBox.square(
                dimension: 22,
                child: CircularProgressIndicator(strokeWidth: 2.2),
              ),
            ),
          ),
        ),
    ];
  }

  static String _statusFilterLabel(PersonnelStatusFilter filter) =>
      switch (filter) {
        PersonnelStatusFilter.all => 'Mọi trạng thái',
        PersonnelStatusFilter.active => 'Đang hoạt động',
        PersonnelStatusFilter.pendingActivation => 'Chờ kích hoạt',
        PersonnelStatusFilter.inactive => 'Tạm ngưng',
        PersonnelStatusFilter.blocked => 'Đã khóa',
      };

  static String _errorMessage(Object error, {bool loadingMore = false}) =>
      error is AppException
      ? error.message
      : loadingMore
      ? 'Không thể tải thêm nhân sự.'
      : 'Không thể tải danh sách nhân sự.';
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) => Row(
    children: <Widget>[
      IconButton(
        tooltip: 'Về Tài khoản',
        onPressed: () => context.go(AppRoutes.account),
        color: AppColors.inkSoft,
        iconSize: 20,
        icon: const Icon(Icons.arrow_back_rounded),
      ),
      const SizedBox(width: 2),
      const Expanded(
        child: Text(
          'Nhân sự',
          style: TextStyle(
            color: AppColors.ink,
            fontSize: 20,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.3,
          ),
        ),
      ),
    ],
  );
}

class _RoleChip extends StatelessWidget {
  const _RoleChip({
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
      color: selected
          ? const Color(0xFF1D7AD6)
          : Colors.white.withValues(alpha: 0.65),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: SizedBox(
          height: 40,
          child: Center(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: selected ? Colors.white : AppColors.inkSoft,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

class _PersonnelCard extends StatelessWidget {
  const _PersonnelCard({required this.personnel, required this.onTap});

  final ManagedPersonnel personnel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label:
        '${personnel.displayName}, '
        '${PersonnelVisuals.roleLabel(personnel.role)}, '
        '${PersonnelVisuals.statusLabel(personnel.status)}',
    child: Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const <BoxShadow>[
              BoxShadow(
                color: Color(0x0F0F1C2E),
                blurRadius: 12,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: <Widget>[
              PersonnelAvatar(personnel: personnel),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      personnel.displayName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.ink,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: <Widget>[
                        PersonnelPill(
                          label: PersonnelVisuals.roleBadgeLabel(
                            personnel.role,
                          ),
                          foreground: PersonnelVisuals.roleForeground(
                            personnel.role,
                          ),
                          background: PersonnelVisuals.roleBackground(
                            personnel.role,
                          ),
                        ),
                        PersonnelPill(
                          label: PersonnelVisuals.statusLabel(personnel.status),
                          foreground: PersonnelVisuals.statusForeground(
                            personnel.status,
                          ),
                          background: PersonnelVisuals.statusBackground(
                            personnel.status,
                          ),
                        ),
                      ],
                    ),
                    if (personnel.currentSeasonAssignments > 0) ...<Widget>[
                      const SizedBox(height: 5),
                      Text(
                        'Đang phụ trách ${personnel.currentSeasonAssignments} vụ nuôi',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.inkMuted,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 6),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.inkMuted,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class _PersonnelEmpty extends StatelessWidget {
  const _PersonnelEmpty({required this.filtered});

  final bool filtered;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: const Color(0xE6FFFFFF),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              filtered ? Icons.person_search_rounded : Icons.groups_outlined,
              color: AppColors.inkMuted,
              size: 31,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            filtered ? 'Không tìm thấy nhân sự' : 'Chưa có nhân sự',
            style: const TextStyle(
              color: AppColors.ink,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            filtered
                ? 'Hãy thử thay đổi từ khóa hoặc bộ lọc.'
                : 'Nhân sự do bạn quản lý sẽ xuất hiện tại đây.',
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.inkMuted, fontSize: 13),
          ),
        ],
      ),
    ),
  );
}

class _PersonnelError extends StatelessWidget {
  const _PersonnelError({required this.message, required this.onRetry});

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
            size: 44,
            color: AppColors.inkMuted,
          ),
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
