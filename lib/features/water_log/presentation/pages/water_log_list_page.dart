import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/widgets/app_gradient_background.dart';
import 'package:smartshrimp_app/core/widgets/gradient_button.dart';
import 'package:smartshrimp_app/core/widgets/sticky_page_header.dart';
import 'package:smartshrimp_app/features/auth/domain/entities/auth_account.dart';
import 'package:smartshrimp_app/features/auth/presentation/view_models/auth_controller.dart';
import 'package:smartshrimp_app/features/water_log/presentation/view_models/water_log_controller.dart';
import 'package:smartshrimp_app/features/water_log/presentation/widgets/void_water_log_sheet.dart';
import 'package:smartshrimp_app/features/water_log/presentation/widgets/water_log_card.dart';
import 'package:smartshrimp_app/features/water_log/presentation/widgets/water_log_form_sheet.dart';

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

class _WaterLogListPageState extends ConsumerState<WaterLogListPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 240) {
      ref.read(waterLogListProvider(widget.seasonId).notifier).loadMore();
    }
  }

  Future<void> _openForm() async {
    await showWaterLogFormSheet(context: context, seasonId: widget.seasonId);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(waterLogListProvider(widget.seasonId));
    final role = ref.watch(authControllerProvider).value?.role;
    final canWrite = role == AccountRole.technician;

    return Scaffold(
      body: AppGradientBackground(
        child: SafeArea(
          bottom: false,
          child: RefreshIndicator(
            onRefresh: () => ref
                .read(waterLogListProvider(widget.seasonId).notifier)
                .refresh(),
            child: CustomScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: <Widget>[
                StickyPageHeader(
                  title: 'Chất lượng nước',
                  subtitle: widget.pondName,
                  onBack: context.pop,
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        _ContextBar(
                          farmName: widget.farmName,
                          seasonName: widget.seasonName,
                          pondName: widget.pondName,
                        ),
                        const SizedBox(height: 14),
                        if (canWrite) ...<Widget>[
                          GradientButton(
                            label: 'Nhập nhật ký đo nước',
                            icon: Icons.add_rounded,
                            compact: true,
                            onPressed: _openForm,
                          ),
                          const SizedBox(height: 12),
                        ],
                        const _ImmutableNotice(),
                        const SizedBox(height: 14),
                      ],
                    ),
                  ),
                ),
                state.when(
                  loading: () => const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 48),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColors.ocean,
                        ),
                      ),
                    ),
                  ),
                  error: (error, _) => SliverToBoxAdapter(
                    child: _Failure(
                      error: error,
                      onRetry: () => ref
                          .read(waterLogListProvider(widget.seasonId).notifier)
                          .refresh(),
                    ),
                  ),
                  data: (page) {
                    if (page.items.isEmpty) {
                      return const SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 40),
                          child: Center(
                            child: Text(
                              'Chưa có nhật ký đo nước.',
                              style: TextStyle(
                                color: AppColors.inkMuted,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                    return SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 28),
                      sliver: SliverList.separated(
                        itemCount:
                            page.items.length + (page.hasNextPage ? 1 : 0),
                        separatorBuilder: (_, _) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          if (index >= page.items.length) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.ocean,
                                ),
                              ),
                            );
                          }
                          final log = page.items[index];
                          return WaterLogCard(
                            log: log,
                            onTap: () async {
                              await showVoidWaterLogSheet(
                                context: context,
                                seasonId: widget.seasonId,
                                log: log,
                              );
                            },
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ContextBar extends StatelessWidget {
  const _ContextBar({this.farmName, this.seasonName, this.pondName});

  final String? farmName;
  final String? seasonName;
  final String? pondName;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: const Color(0xB3E6F4FF),
      borderRadius: BorderRadius.circular(14),
    ),
    child: Text(
      '⌖  ${farmName ?? '—'}  ›  ${seasonName ?? '—'}  ›  ${pondName ?? '—'}',
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        color: AppColors.ocean,
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}

class _ImmutableNotice extends StatelessWidget {
  const _ImmutableNotice();

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    decoration: BoxDecoration(
      color: const Color(0xFFEAF4FF),
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: const Color(0xFFD3E7FF)),
    ),
    child: const Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Icon(Icons.info_outline_rounded, color: Color(0xFF1378D1), size: 18),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            'Bản ghi đo nước là bất biến. Ghi sai chỉ có thể hủy hiệu lực kèm lý do — không sửa/xóa.',
            style: TextStyle(
              color: Color(0xFF0C4E8F),
              fontSize: 12,
              height: 1.5,
            ),
          ),
        ),
      ],
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
