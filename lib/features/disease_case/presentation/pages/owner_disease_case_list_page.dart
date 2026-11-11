import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshrimp_app/app/router/app_router.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/widgets/app_notice.dart';
import 'package:smartshrimp_app/core/widgets/app_svg_icon.dart';

import '../../domain/entities/owner_disease_case.dart';
import '../view_models/owner_disease_case_controller.dart';
import '../widgets/disease_case_ui.dart';

class DiseaseCaseListPage extends ConsumerStatefulWidget {
  const DiseaseCaseListPage({required this.seasonId, this.subtitle, super.key});

  final String seasonId;
  final String? subtitle;

  @override
  ConsumerState<DiseaseCaseListPage> createState() =>
      _DiseaseCaseListPageState();
}

class _DiseaseCaseListPageState extends ConsumerState<DiseaseCaseListPage> {
  bool _resolved = false;
  Object? _pendingPage;

  @override
  Widget build(BuildContext context) {
    final provider = diseaseCaseListProvider(widget.seasonId);
    final state = ref.watch(provider);
    final page = state.value;
    final subtitle = page == null
        ? widget.subtitle
        : '${page.pondName} · ${page.seasonName}';

    return DiseaseCaseFrame(
      title: 'Ca bệnh',
      subtitle: subtitle,
      scrollKey: ValueKey(_resolved),
      tabs: _DiseaseCaseTabs(
        resolved: _resolved,
        activeCount: page?.activeCount,
        resolvedCount: page?.resolvedCount,
        onSelected: (resolved) {
          if (_resolved == resolved) return;
          setState(() {
            _resolved = resolved;
            _pendingPage = null;
          });
          ref.read(provider.notifier).selectTab(resolved: resolved);
        },
      ),
      onRefresh: () async {
        if (_pendingPage != null) setState(() => _pendingPage = null);
        // Refresh failures are shown by the same AsyncValue as initial failures.
        await AsyncValue.guard(() => ref.refresh(provider.future));
      },
      slivers: state.when(
        skipLoadingOnRefresh: false,
        loading: () => const [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Center(child: CircularProgressIndicator()),
          ),
        ],
        error: (error, _) => [
          SliverToBoxAdapter(
            child: DiseaseCaseFailure(
              error: error,
              onRetry: () => ref.invalidate(provider),
            ),
          ),
        ],
        data: (page) => [
          if (page.items.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Text(
                  _resolved
                      ? 'Chưa có ca bệnh đã giải quyết'
                      : 'Chưa có ca bệnh đang xử lý',
                  style: caseBodyStyle,
                  textAlign: TextAlign.center,
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
              sliver: SliverList.separated(
                itemCount: page.items.length + (page.hasNextPage ? 1 : 0),
                separatorBuilder: (_, _) => const SizedBox(height: 8),
                itemBuilder: (_, index) {
                  if (index == page.items.length) {
                    return OutlinedButton(
                      onPressed: _pendingPage == null ? _loadMore : null,
                      child: Text(
                        _pendingPage == null ? 'Xem thêm' : 'Đang tải…',
                      ),
                    );
                  }
                  final item = page.items[index];
                  return _CaseListCard(
                    data: item,
                    onTap: () => context.push(
                      '${AppRoutes.diseaseCases}/${Uri.encodeComponent(item.id)}',
                      extra: subtitle,
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _loadMore() async {
    final request = Object();
    setState(() => _pendingPage = request);
    try {
      await ref
          .read(diseaseCaseListProvider(widget.seasonId).notifier)
          .loadMore();
    } catch (error) {
      if (mounted && identical(_pendingPage, request)) {
        AppNoticeService.danger(context, caseErrorMessage(error));
      }
    } finally {
      if (mounted && identical(_pendingPage, request)) {
        setState(() => _pendingPage = null);
      }
    }
  }
}

class _DiseaseCaseTabs extends StatelessWidget {
  const _DiseaseCaseTabs({
    required this.resolved,
    required this.activeCount,
    required this.resolvedCount,
    required this.onSelected,
  });

  final bool resolved;
  final int? activeCount;
  final int? resolvedCount;
  final ValueChanged<bool> onSelected;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFB6E2F7), Color(0xFFBBE3F6)],
      ),
    ),
    child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xB3D3E8FF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 4,
        children: [
          for (final (isResolved, label, count) in [
            (false, 'Đang xử lý', activeCount),
            (true, 'Đã giải quyết', resolvedCount),
          ])
            Expanded(
              child: Semantics(
                selected: resolved == isResolved,
                button: true,
                child: Material(
                  color: resolved == isResolved
                      ? const Color(0xFF1D7AD6)
                      : const Color(0x8CFFFFFF),
                  borderRadius: BorderRadius.circular(12),
                  elevation: resolved == isResolved ? 1 : 0,
                  child: InkWell(
                    onTap: () => onSelected(isResolved),
                    borderRadius: BorderRadius.circular(12),
                    child: Center(
                      child: Text(
                        '$label${count == null ? '' : ' ($count)'}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: resolved == isResolved
                              ? Colors.white
                              : AppColors.inkSoft,
                          fontSize: 13,
                          height: 1.5,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    ),
  );
}

class _CaseListCard extends StatelessWidget {
  const _CaseListCard({required this.data, required this.onTap});

  final DiseaseCaseCard data;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => DiseaseCaseSurface(
    onTap: onTap,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DiseaseCaseTitleRow(
          title: Text(data.title, style: caseTitleStyle),
          badge: DiseaseCaseBadge.status(data.status, list: true),
        ),
        const SizedBox(height: 4),
        Text(
          data.description,
          style: caseBodyStyle,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
        if (data.aiDiagnosis case final diagnosis?) ...[
          const SizedBox(height: 9),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: casePurple.background,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 4,
              children: [
                const AppSvgIcon(
                  AppSvgIconName.sparkles,
                  color: caseAiAccent,
                  size: 11,
                ),
                Flexible(
                  child: Text(
                    'AI: $diagnosis',
                    style: const TextStyle(
                      color: caseAiAccent,
                      fontSize: 10,
                      height: 1.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 10),
        caseDivider,
        const SizedBox(height: 10),
        LayoutBuilder(
          builder: (context, constraints) {
            final maxWidth = constraints.maxWidth * .36;
            return Row(
              spacing: 6,
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxWidth),
                  child: DiseaseCaseBadge.severity(data.severity),
                ),
                Expanded(
                  child: Text(
                    data.expertName,
                    style: caseMetadataStyle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxWidth),
                  child: Text(
                    '${data.responseCount} phản hồi',
                    style: caseMetadataStyle,
                  ),
                ),
                const AppSvgIcon(AppSvgIconName.chevronCompact, size: 12),
              ],
            );
          },
        ),
      ],
    ),
  );
}
