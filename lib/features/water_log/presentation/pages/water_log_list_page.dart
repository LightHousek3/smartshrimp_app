import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/widgets/app_gradient_background.dart';
import 'package:smartshrimp_app/core/widgets/gradient_button.dart';
import 'package:smartshrimp_app/core/widgets/sticky_page_header.dart';
import 'package:smartshrimp_app/features/auth/domain/entities/auth_account.dart';
import 'package:smartshrimp_app/features/auth/presentation/view_models/auth_controller.dart';
import 'package:smartshrimp_app/features/water_log/domain/entities/water_log.dart';
import 'package:smartshrimp_app/features/water_log/presentation/view_models/water_log_controller.dart';
import 'package:smartshrimp_app/features/water_log/presentation/widgets/void_water_log_sheet.dart';
import 'package:smartshrimp_app/features/water_log/presentation/widgets/water_log_card.dart';
import 'package:smartshrimp_app/features/water_log/presentation/widgets/water_log_form_sheet.dart';
import 'package:smartshrimp_app/features/water_log/presentation/widgets/water_param_tiles.dart';

class WaterLogListPage extends ConsumerStatefulWidget {
  const WaterLogListPage({
    required this.seasonId,
    this.farmName,
    this.seasonName,
    this.pondName,
    super.key,
  });
  final String seasonId;
  final String? farmName;
  final String? seasonName;
  final String? pondName;

  @override
  ConsumerState<WaterLogListPage> createState() => _WaterLogListPageState();
}

enum _LogFilter { all, warning, voided }

class _WaterLogListPageState extends ConsumerState<WaterLogListPage> {
  _LogFilter _filter = _LogFilter.all;
  bool _loadingRemaining = false;
  Object? _paginationError;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _loadRemaining();
    });
  }

  // Counts and filters need the complete collection, not just the first API page.
  Future<void> _loadRemaining() async {
    if (_loadingRemaining) return;
    _loadingRemaining = true;
    try {
      while (mounted) {
        final page = ref
            .read(waterLogListProvider(widget.seasonId))
            .asData
            ?.value;
        if (page == null || !page.hasNextPage) break;
        await ref
            .read(waterLogListProvider(widget.seasonId).notifier)
            .loadMore();
        if (!mounted) return;
        final next = ref
            .read(waterLogListProvider(widget.seasonId))
            .asData
            ?.value;
        if (next == null || next.items.length <= page.items.length) break;
      }
      if (mounted && _paginationError != null) {
        setState(() => _paginationError = null);
      }
    } on Object catch (error) {
      if (mounted) setState(() => _paginationError = error);
    } finally {
      _loadingRemaining = false;
    }
  }

  Future<void> _refresh() async {
    await ref.read(waterLogListProvider(widget.seasonId).notifier).refresh();
    await _loadRemaining();
  }

  @override
  Widget build(BuildContext context) {
    final provider = waterLogListProvider(widget.seasonId);
    final state = ref.watch(provider);
    ref.listen(provider, (_, next) {
      if (next.asData?.value.hasNextPage == true) _loadRemaining();
    });
    final canWrite =
        ref.watch(authControllerProvider).value?.role == AccountRole.technician;
    final page = state.asData?.value;
    final logs = page?.items ?? const <WaterLog>[];
    final valid = logs.where((log) => !log.isVoided).toList(growable: false);
    final warnings = valid
        .where((log) => log.exceededParameters.isNotEmpty)
        .length;
    final voided = logs.length - valid.length;
    WaterLog? latest;
    for (final log in valid) {
      if (latest == null || log.recordedAt.isAfter(latest.recordedAt)) {
        latest = log;
      }
    }
    final complete = page != null && !page.hasNextPage;
    final visible = logs
        .where(
          (log) => switch (_filter) {
            _LogFilter.all => true,
            _LogFilter.warning =>
              !log.isVoided && log.exceededParameters.isNotEmpty,
            _LogFilter.voided => log.isVoided,
          },
        )
        .toList(growable: false);
    final subtitle = <String>[
      if (widget.pondName?.trim().isNotEmpty == true) widget.pondName!.trim(),
      if (widget.seasonName?.trim().isNotEmpty == true)
        widget.seasonName!.trim(),
    ].join(' · ');

    return Scaffold(
      body: AppGradientBackground(
        child: SafeArea(
          bottom: false,
          child: Column(
            children: <Widget>[
              AppGradientBackground(
                child: PageHeaderBar(
                  title: 'Chất lượng nước',
                  subtitle: subtitle.isEmpty ? null : subtitle,
                  onBack: context.pop,
                  backgroundColor: Colors.transparent,
                  titleStyle:
                      AppTypography.display(
                        color: AppColors.ink,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        height: 1.5,
                      ).copyWith(
                        fontFamilyFallback: <String>[
                          GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.w700,
                          ).fontFamily!,
                        ],
                      ),
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _refresh,
                  child: CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: <Widget>[
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                        sliver: SliverToBoxAdapter(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              if (canWrite) ...<Widget>[
                                GradientButton(
                                  label: 'Nhập nhật ký đo nước',
                                  icon: Icons.add_rounded,
                                  compact: true,
                                  borderRadius: 12,
                                  onPressed: () => showWaterLogFormSheet(
                                    context: context,
                                    seasonId: widget.seasonId,
                                  ),
                                ),
                                const SizedBox(height: 12),
                              ],
                              IntrinsicHeight(
                                child: Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: <Widget>[
                                    Expanded(
                                      child: _SummaryTile(
                                        label: 'BẢN GHI HỢP LỆ',
                                        value: complete
                                            ? '${valid.length}'
                                            : '—',
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: _SummaryTile(
                                        label: 'CÓ CẢNH BÁO',
                                        value: complete ? '$warnings' : '—',
                                        teal: true,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: _SummaryTile(
                                        label: 'DO MỚI NHẤT',
                                        value: formatWaterValue(
                                          latest?.dissolvedOxygenMgL,
                                        ),
                                        unit: 'mg/L',
                                        teal: true,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 12),
                              const _ImmutableNotice(),
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: const Color(0xB3E6F4FF),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  children: <Widget>[
                                    for (final filter
                                        in _LogFilter.values) ...<Widget>[
                                      if (filter != _LogFilter.all)
                                        const SizedBox(width: 4),
                                      Expanded(
                                        child: _FilterButton(
                                          label: switch (filter) {
                                            _LogFilter.all =>
                                              'Tất cả (${page?.totalResults ?? '—'})',
                                            _LogFilter.warning =>
                                              'Cảnh báo (${complete ? warnings : '—'})',
                                            _LogFilter.voided =>
                                              'Vô hiệu (${complete ? voided : '—'})',
                                          },
                                          selected: _filter == filter,
                                          onTap: () =>
                                              setState(() => _filter = filter),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      state.when(
                        loading: () => const SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.all(40),
                            child: Center(child: CircularProgressIndicator()),
                          ),
                        ),
                        error: (error, _) => SliverToBoxAdapter(
                          child: _Failure(error: error, onRetry: _refresh),
                        ),
                        data: (page) => SliverPadding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 28),
                          sliver: SliverList.builder(
                            itemCount: visible.length + 1,
                            itemBuilder: (context, index) {
                              if (index == visible.length) {
                                if (_paginationError != null) {
                                  return _Failure(
                                    error: _paginationError!,
                                    onRetry: _loadRemaining,
                                  );
                                }
                                if (page.hasNextPage) {
                                  return const Padding(
                                    padding: EdgeInsets.all(24),
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                }
                                if (visible.isEmpty) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 36,
                                    ),
                                    child: Center(
                                      child: Text(
                                        _filter == _LogFilter.all
                                            ? 'Chưa có nhật ký đo nước.'
                                            : 'Không có bản ghi trong bộ lọc này.',
                                        style: const TextStyle(
                                          color: AppColors.inkMuted,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  );
                                }
                                return const SizedBox.shrink();
                              }
                              final log = visible[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: WaterLogCard(
                                  log: log,
                                  onTap: () => showVoidWaterLogSheet(
                                    context: context,
                                    seasonId: widget.seasonId,
                                    log: log,
                                  ),
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
    );
  }
}

class _SummaryTile extends StatelessWidget {
  const _SummaryTile({
    required this.label,
    required this.value,
    this.unit,
    this.teal = false,
  });
  final String label, value;
  final String? unit;
  final bool teal;

  @override
  Widget build(BuildContext context) => Container(
    constraints: const BoxConstraints(minHeight: 86),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: const Color(0xD9FFFFFF),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: AppColors.inkMuted,
            fontSize: 10,
            fontWeight: FontWeight.w500,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: GoogleFonts.plusJakartaSans(
            color: teal ? const Color(0xFF0F9B8E) : AppColors.ink,
            fontSize: 20,
            fontWeight: FontWeight.w700,
            height: 1.3,
          ),
        ),
        if (unit != null) ...<Widget>[
          const SizedBox(height: 4),
          Text(
            unit!,
            style: const TextStyle(
              color: AppColors.inkMuted,
              fontSize: 11,
              height: 1.5,
            ),
          ),
        ],
      ],
    ),
  );
}

class _FilterButton extends StatelessWidget {
  const _FilterButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: selected ? const Color(0xFF1D7DD8) : const Color(0xD9F4F8FF),
    borderRadius: BorderRadius.circular(12),
    elevation: selected ? 2 : 0,
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        alignment: Alignment.center,
        constraints: const BoxConstraints(minHeight: 44),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: selected ? Colors.white : AppColors.inkSoft,
            fontSize: 11,
            fontWeight: FontWeight.w600,
            height: 1.5,
          ),
        ),
      ),
    ),
  );
}

class _ImmutableNotice extends StatelessWidget {
  const _ImmutableNotice();
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(
      color: const Color(0xB3E6F4FF),
      borderRadius: BorderRadius.circular(14),
    ),
    child: const Text(
      'Kết quả đo đã lưu không thể chỉnh sửa. Nếu ghi sai, KTV chỉ có thể hủy hiệu lực kèm lý do để vẫn giữ được lịch sử đối chiếu.',
      style: TextStyle(color: AppColors.ocean, fontSize: 11, height: 1.5),
    ),
  );
}

class _Failure extends StatelessWidget {
  const _Failure({required this.error, required this.onRetry});

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
    child: Column(
      children: <Widget>[
        Text(
          error is AppException
              ? (error as AppException).message
              : 'Đã xảy ra lỗi. Vui lòng thử lại.',
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.inkMuted, fontSize: 13),
        ),
        const SizedBox(height: 12),
        TextButton(onPressed: onRetry, child: const Text('Thử lại')),
      ],
    ),
  );
}
