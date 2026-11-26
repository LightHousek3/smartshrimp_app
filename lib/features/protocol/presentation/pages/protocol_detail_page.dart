import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshrimp_app/core/widgets/app_error_state.dart';
import 'package:smartshrimp_app/core/widgets/app_notice.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/widgets/app_svg_icon.dart';
import 'package:smartshrimp_app/features/protocol/domain/entities/protocol.dart';
import 'package:smartshrimp_app/features/protocol/domain/protocol_calendar.dart';
import 'package:smartshrimp_app/features/protocol/presentation/view_models/protocol_controller.dart';
import 'package:smartshrimp_app/features/protocol/presentation/widgets/protocol_audit.dart';
import 'package:smartshrimp_app/features/protocol/presentation/widgets/protocol_day_audit.dart';
import 'package:smartshrimp_app/features/protocol/presentation/widgets/protocol_decision.dart';
import 'package:smartshrimp_app/features/protocol/presentation/widgets/protocol_timeline.dart';
import 'package:smartshrimp_app/features/protocol/presentation/widgets/protocol_ui.dart';
import 'package:smartshrimp_app/features/protocol/presentation/widgets/protocol_materials.dart';

class ProtocolDetailPage extends ConsumerStatefulWidget {
  const ProtocolDetailPage({required this.protocolId, super.key});
  final String protocolId;
  @override
  ConsumerState<ProtocolDetailPage> createState() => _ProtocolDetailPageState();
}

class _ProtocolDetailPageState extends ConsumerState<ProtocolDetailPage>
    with WidgetsBindingObserver {
  int? _selectedDay;
  late final Timer _clock;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _clock = Timer.periodic(const Duration(minutes: 1), (_) {
      if (!mounted) return;
      final lifecycle = WidgetsBinding.instance.lifecycleState;
      if ((lifecycle == null || lifecycle == AppLifecycleState.resumed) &&
          ModalRoute.of(context)?.isCurrent != false) {
        _synchronize();
      }
    });
  }

  void _synchronize() {
    if (!mounted) return;
    if (ref.read(protocolReviewProvider(widget.protocolId)).isLoading) return;
    final state = ref.read(protocolDetailProvider(widget.protocolId));
    if (state.isLoading) return;
    final detail = state.value;
    if (detail != null && detail.durationDays > 0) {
      final day =
          (_selectedDay ??
                  protocolInitialDay(detail, ref.read(protocolClockProvider)()))
              .clamp(1, detail.durationDays);
      ref.invalidate(protocolDayProvider((id: widget.protocolId, day: day)));
    }
    setState(() {});
    ref.invalidate(protocolDetailProvider(widget.protocolId));
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed &&
        ModalRoute.of(context)?.isCurrent != false) {
      _synchronize();
    }
  }

  @override
  void dispose() {
    _clock.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant ProtocolDetailPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.protocolId != widget.protocolId) _selectedDay = null;
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(protocolDetailProvider(widget.protocolId), (previous, next) {
      final before = previous?.value?.card;
      final after = next.asData?.value.card;
      if (before != null && after != null && before != after) {
        ref.invalidate(protocolListProvider);
      }
    });
    ref.listen(protocolReviewProvider(widget.protocolId), (previous, next) {
      if (previous?.isLoading != true || next.isLoading) return;
      if (next.hasError) {
        AppNoticeService.danger(context, protocolError(next.error!));
      } else if (next.value != null) {
        // The page survives the refresh that removes the decision form.
        AppNoticeService.success(
          context,
          next.value == true
              ? 'Đã phê duyệt. Phác đồ được áp dụng khi đủ điều kiện có hiệu lực.'
              : 'Đã từ chối phác đồ.',
        );
      }
    });
    final state = ref.watch(protocolDetailProvider(widget.protocolId));
    final detail = state.value;
    final now = ref.watch(protocolClockProvider)();
    return ProtocolFrame(
      title: 'Chi tiết phác đồ',
      subtitle: detail == null
          ? null
          : '${detail.card.pondName} · ${detail.card.seasonName}',
      child: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => AppErrorState(error: error, onRetry: _synchronize),
        data: (detail) {
          final day = (_selectedDay ?? protocolInitialDay(detail, now)).clamp(
            1,
            detail.durationDays > 0 ? detail.durationDays : 1,
          );
          return _DetailContent(
            detail: detail,
            day: day,
            currentDay: protocolCurrentDay(detail, now),
            now: now,
            onSelect: (value) => setState(() => _selectedDay = value),
          );
        },
      ),
    );
  }
}

class _DetailContent extends ConsumerWidget {
  const _DetailContent({
    required this.detail,
    required this.day,
    required this.onSelect,
    required this.currentDay,
    required this.now,
  });
  final ProtocolDetail detail;
  final int day;
  final ValueChanged<int> onSelect;
  final int? currentDay;
  final DateTime now;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dayScope = (id: detail.card.id, day: day);
    final AsyncValue<ProtocolDay?> dayState = detail.durationDays > 0
        ? ref.watch(protocolDayProvider(dayScope))
        : const AsyncData<ProtocolDay?>(null);
    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(protocolDetailProvider(detail.card.id));
        ref.invalidate(protocolDayProvider(dayScope));
        // Providers render the failure; the refresh gesture must settle without a second error.
        await AsyncValue.guard(
          () => ref.read(protocolDetailProvider(detail.card.id).future),
        );
      },
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
        children: [
          _Header(detail),
          if (protocolStatusDescription(detail) case final description?) ...[
            const SizedBox(height: 8),
            ProtocolSurface(
              color: protocolPanel,
              child: Text(
                description,
                style: const TextStyle(
                  fontSize: 12,
                  height: 1.6,
                  color: AppColors.inkSoft,
                ),
              ),
            ),
          ],
          const SizedBox(height: 16),
          ProtocolSurface(
            color: const Color(0xFFEAF4FF),
            border: const Color(0xFFD3E8FF),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    AppSvgIcon(
                      AppSvgIconName.info,
                      size: 13,
                      color: AppColors.ocean,
                    ),
                    SizedBox(width: 6),
                    Text(
                      'MỤC TIÊU PHÁC ĐỒ',
                      style: TextStyle(
                        fontSize: 11,
                        height: 1.5,
                        letterSpacing: .275,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ocean,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  detail.card.summary ?? 'Chưa có mô tả mục tiêu.',
                  style: const TextStyle(
                    fontSize: 12,
                    height: 1.625,
                    color: AppColors.ink,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          if (detail.materialReviews.any((row) => row.proposed != null)) ...[
            ProtocolMaterials(
              detail: detail,
              busy: ref.watch(protocolReviewProvider(detail.card.id)).isLoading,
            ),
            const SizedBox(height: 16),
          ],
          if (detail.durationDays > 0) ...[
            ProtocolTimeline(
              detail: detail,
              selectedDay: day,
              currentDay: currentDay,
              onSelect: onSelect,
            ),
            const SizedBox(height: 16),
            if (detail.card.protocolType == ProtocolType.treatment &&
                detail.anchorDate == null) ...[
              const ProtocolSurface(
                color: protocolAmberPanel,
                border: Color(0xFFFFDF6A),
                padding: EdgeInsets.all(14),
                radius: 12,
                child: Text(
                  'Chưa có mốc bắt đầu điều trị hợp lệ. Chuyên gia cần đặt mốc và Chủ trại duyệt trước mốc đó; các cữ dưới đây là kế hoạch để đối chiếu.',
                  style: TextStyle(
                    fontSize: 10,
                    height: 1.625,
                    color: Color(0xFFBB4D00),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
            ProtocolDayBanner(
              detail: detail,
              day: day,
              data: dayState.hasError ? null : dayState.value,
              loadFailed: dayState.hasError,
              onSelect: onSelect,
            ),
            const SizedBox(height: 16),
            dayState.when(
              loading: () => const ProtocolSurface(
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (error, _) => ProtocolSurface(
                child: AppErrorState(
                  error: error,
                  onRetry: () => ref.invalidate(protocolDayProvider(dayScope)),
                ),
              ),
              data: (data) => data == null
                  ? const SizedBox.shrink()
                  : ProtocolDayAudit(
                      farmId: detail.farmId,
                      day: data,
                      protocolStatus: detail.card.status,
                      isTreatment:
                          detail.card.protocolType == ProtocolType.treatment,
                      mealNumbersByItem: {
                        for (final item in detail.materialReviews)
                          item.itemId: ?item.mealNumber,
                      },
                      now: now,
                    ),
            ),
            const SizedBox(height: 16),
          ] else ...[
            const ProtocolSurface(
              child: Text(
                'Phác đồ chưa có hạng mục thực hiện.',
                style: TextStyle(fontSize: 12),
              ),
            ),
            const SizedBox(height: 16),
          ],
          ProtocolAudit(detail: detail),
          if (detail.canReview) ...[
            const SizedBox(height: 16),
            ProtocolDecision(detail: detail),
          ],
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header(this.detail);
  final ProtocolDetail detail;
  @override
  Widget build(BuildContext context) {
    final card = detail.card;
    final treatment = card.protocolType == ProtocolType.treatment;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: card.status == ProtocolStatus.pendingApproval
            ? Border.all(color: const Color(0xFFFEE685))
            : null,
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 14,
            offset: Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 6,
            color: treatment
                ? const Color(0xFFFF587C)
                : const Color(0xFF1D7AD6),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    ProtocolBadge(
                      treatment ? 'Phác đồ điều trị' : 'Phác đồ nuôi',
                      color: treatment ? protocolRose : const Color(0xFF0C4E8F),
                      background: treatment
                          ? protocolRosePanel
                          : const Color(0xFFEAF4FF),
                    ),
                    ProtocolBadge('Phiên bản ${card.versionNo}'),
                    ProtocolBadge.status(
                      card.status,
                      dot: card.status == ProtocolStatus.pendingApproval,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  card.title,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.375,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${card.pondName} · ${card.farmName}',
                  style: const TextStyle(
                    fontSize: 12,
                    height: 1.5,
                    color: AppColors.inkMuted,
                  ),
                ),
                if (card.diseaseCaseTitle != null) ...[
                  const SizedBox(height: 12),
                  Material(
                    color: protocolRosePanel,
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: card.diseaseCaseId?.trim().isNotEmpty == true
                          ? () => context.push(
                              '/disease-cases/${Uri.encodeComponent(card.diseaseCaseId!)}',
                              extra: '${card.pondName} · ${card.seasonName}',
                            )
                          : null,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            const AppSvgIcon(
                              AppSvgIconName.shield,
                              size: 14,
                              color: protocolRose,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'CA BỆNH LIÊN QUAN',
                                    style: TextStyle(
                                      fontSize: 9,
                                      height: 1.5,
                                      fontWeight: FontWeight.w700,
                                      color: protocolRose,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    card.diseaseCaseTitle!,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      height: 1.5,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFFD70040),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            if (card.diseaseCaseId?.trim().isNotEmpty == true)
                              const AppSvgIcon(
                                AppSvgIconName.chevron,
                                size: 13,
                                color: Color(0xFFFF587C),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
