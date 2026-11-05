import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/widgets/gradient_button.dart';
import 'package:smartshrimp_app/features/assigned_season/domain/entities/assigned_season.dart';
import 'package:smartshrimp_app/features/assigned_season/presentation/view_models/assigned_season_controller.dart';
import '../../domain/entities/ai_diagnosis.dart';
import '../../domain/repositories/ai_diagnosis_repository.dart';
import '../view_models/ai_diagnosis_controller.dart';
import '../view_models/ai_diagnosis_state.dart';
import '../widgets/ai_diagnosis_photos.dart';
import '../widgets/ai_diagnosis_ui.dart';

class AiDiagnosisPage extends ConsumerStatefulWidget {
  const AiDiagnosisPage({required this.seasonId, super.key});
  final String seasonId;
  @override
  ConsumerState<AiDiagnosisPage> createState() => _AiDiagnosisPageState();
}

class _AiDiagnosisPageState extends ConsumerState<AiDiagnosisPage> {
  bool onHistoryScroll(ScrollNotification notification) {
    final scrollingDown =
        notification is ScrollUpdateNotification &&
            (notification.scrollDelta ?? 0) > 0 ||
        notification is OverscrollNotification && notification.overscroll > 0;
    if (notification.depth != 0 ||
        !scrollingDown ||
        notification.metrics.extentAfter > 240 ||
        ModalRoute.of(context)?.isCurrent == false ||
        ref.read(aiDiagnosisDraftProvider(widget.seasonId)).submitting) {
      return false;
    }
    final history = ref
        .read(aiDiagnosisHistoryProvider(widget.seasonId))
        .asData
        ?.value;
    if (history != null &&
        !history.loadingMore &&
        history.paginationError == null &&
        history.page.pagination.hasNextPage) {
      ref.read(aiDiagnosisHistoryProvider(widget.seasonId).notifier).loadMore();
    }
    return false;
  }

  Widget historySliver(AsyncValue<AiDiagnosisHistory> history) => SliverPadding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    sliver: history.when(
      loading: () => const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Center(
            child: CircularProgressIndicator(color: AiDiagnosisStyle.purple),
          ),
        ),
      ),
      error: (error, _) => SliverToBoxAdapter(
        child: AiCard(
          child: AiFailure(
            error: error,
            onRetry: () => ref
                .read(aiDiagnosisHistoryProvider(widget.seasonId).notifier)
                .refresh(),
          ),
        ),
      ),
      data: (state) => SliverList.builder(
        itemCount: state.page.items.length + 1,
        itemBuilder: (context, index) {
          if (index < state.page.items.length) {
            final item = state.page.items[index];
            return Padding(
              key: ValueKey('ai-diagnosis-${item.id}'),
              padding: const EdgeInsets.only(bottom: 8),
              child: _HistoryCard(
                item,
                onTap: () => context.push(
                  '/seasons/${widget.seasonId}/ai-diagnoses/${item.id}',
                ),
              ),
            );
          }
          if (state.page.items.isEmpty) {
            return const AiCard(
              child: SizedBox(
                width: double.infinity,
                child: Text(
                  'Chưa có lịch sử nhận diện.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.inkMuted),
                ),
              ),
            );
          }
          if (state.paginationError != null) {
            return AiFailure(
              error: state.paginationError!,
              onRetry: () => ref
                  .read(aiDiagnosisHistoryProvider(widget.seasonId).notifier)
                  .loadMore(),
            );
          }
          return state.loadingMore
              ? const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(
                    child: SizedBox.square(
                      dimension: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                )
              : const SizedBox.shrink();
        },
      ),
    ),
  );

  Future<void> pickImages() async {
    final source = await showModalBottomSheet<AiImageSource>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Chọn từ thư viện'),
              onTap: () => Navigator.pop(context, AiImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('Chụp ảnh'),
              onTap: () => Navigator.pop(context, AiImageSource.camera),
            ),
          ],
        ),
      ),
    );
    if (source != null && mounted) {
      await ref
          .read(aiDiagnosisDraftProvider(widget.seasonId).notifier)
          .pick(source);
    }
  }

  Future<void> submit() async {
    final result = await ref
        .read(aiDiagnosisDraftProvider(widget.seasonId).notifier)
        .submit();
    if (mounted && result != null) {
      await context.push(
        '/seasons/${widget.seasonId}/ai-diagnoses/${result.id}',
      );
    }
  }

  void viewLocalImage(int index) {
    final images = ref.read(aiDiagnosisDraftProvider(widget.seasonId)).images;
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      builder: (_) =>
          AiDiagnosisImageViewer(initialIndex: index, images: images),
    );
  }

  @override
  Widget build(BuildContext context) {
    final season = ref.watch(assignedSeasonDetailProvider(widget.seasonId));
    final history = ref.watch(aiDiagnosisHistoryProvider(widget.seasonId));
    final draft = ref.watch(aiDiagnosisDraftProvider(widget.seasonId));
    final busy = draft.picking || draft.submitting;
    return AiDiagnosisFrame(
      title: 'AI nhận diện bệnh',
      subtitle: season.asData == null
          ? null
          : '${season.asData!.value.pondName} · ${season.asData!.value.name}',
      child: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(assignedSeasonDetailProvider(widget.seasonId));
          await ref
              .read(aiDiagnosisHistoryProvider(widget.seasonId).notifier)
              .refresh();
        },
        child: NotificationListener<ScrollNotification>(
          onNotification: onHistoryScroll,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      season.when(
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (error, _) => AiFailure(
                          error: error,
                          onRetry: () => ref.invalidate(
                            assignedSeasonDetailProvider(widget.seasonId),
                          ),
                        ),
                        data: (season) =>
                            season.status != AssignedSeasonStatus.active
                            ? const AiCard(
                                child: Text(
                                  'Vụ nuôi không hoạt động. Bạn vẫn có thể xem lịch sử nhận diện.',
                                ),
                              )
                            : AiCard(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Expanded(
                                          child: AiTitle('Ảnh mẫu tôm'),
                                        ),
                                        AiBadge(
                                          '${draft.images.length}/5 ảnh',
                                          empty: draft.images.isEmpty,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    if (draft.images.isEmpty)
                                      AiDashedBox(
                                        onTap: busy ? null : pickImages,
                                        child: SizedBox(
                                          width: double.infinity,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 28,
                                            ),
                                            child: Column(
                                              children: [
                                                Container(
                                                  width: 56,
                                                  height: 56,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          16,
                                                        ),
                                                    boxShadow: const [
                                                      BoxShadow(
                                                        color: Color(
                                                          0x26000000,
                                                        ),
                                                        blurRadius: 3,
                                                        offset: Offset(0, 1),
                                                      ),
                                                    ],
                                                  ),
                                                  child: const AiIcon('camera'),
                                                ),
                                                const SizedBox(height: 12),
                                                const Text(
                                                  'Chọn ảnh mẫu tôm',
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w700,
                                                    color:
                                                        AiDiagnosisStyle.purple,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                const Text(
                                                  'Tải từ 1–5 ảnh rõ nét vùng nghi bệnh',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 11,
                                                    color: AppColors.inkMuted,
                                                    height: 1.5,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    else
                                      AiPhotoGrid(
                                        count: draft.images.length,
                                        busy: busy,
                                        imageBuilder: (i) => Image.memory(
                                          draft.images[i].bytes,
                                          cacheWidth: 600,
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, _, _) => const Icon(
                                            Icons.broken_image_outlined,
                                          ),
                                        ),
                                        onView: viewLocalImage,
                                        onAdd: pickImages,
                                        onRemove: ref
                                            .read(
                                              aiDiagnosisDraftProvider(
                                                widget.seasonId,
                                              ).notifier,
                                            )
                                            .remove,
                                      ),
                                    const SizedBox(height: 10),
                                    const Text(
                                      'JPG, PNG, WebP · Tối đa 10 MB/ảnh.',
                                      style: TextStyle(
                                        color: AppColors.inkMuted,
                                        fontSize: 10,
                                      ),
                                    ),
                                    if (draft.error != null)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 12),
                                        child: Text(
                                          AiDiagnosisText.message(draft.error!),
                                          style: const TextStyle(
                                            color: AppColors.error,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    if (draft.submissionFailed)
                                      const Padding(
                                        padding: EdgeInsets.only(top: 8),
                                        child: Text(
                                          'Kiểm tra lịch sử nhận diện trước khi gửi lại. Yêu cầu có thể đã được lưu dù bạn chưa nhận được phản hồi.',
                                          style: TextStyle(
                                            color: AppColors.inkMuted,
                                            fontSize: 11,
                                            height: 1.5,
                                          ),
                                        ),
                                      ),
                                    const SizedBox(height: 16),
                                    Opacity(
                                      opacity: busy || draft.images.isEmpty
                                          ? 0.45
                                          : 1,
                                      child: GradientButton(
                                        label: draft.submitting
                                            ? 'Đang phân tích ảnh…'
                                            : draft.picking
                                            ? 'Đang chọn ảnh…'
                                            : 'Yêu cầu AI nhận diện',
                                        onPressed: busy || draft.images.isEmpty
                                            ? null
                                            : submit,
                                        leading:
                                            draft.submitting || draft.picking
                                            ? const SizedBox.square(
                                                dimension: 18,
                                                child:
                                                    CircularProgressIndicator(
                                                      color: Colors.white,
                                                      strokeWidth: 1.5,
                                                    ),
                                              )
                                            : const AiIcon('submit'),
                                        compact: true,
                                        disabledGradientColors: const [
                                          AppColors.oceanLight,
                                          AppColors.tealLight,
                                          AppColors.oceanLight,
                                        ],
                                        height: 45,
                                        borderRadius: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                      ),
                      const SizedBox(height: 12),
                      const _ClassificationInfo(),
                      const SizedBox(height: 12),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4),
                        child: AiTitle('Lịch sử nhận diện'),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
              historySliver(history),
              const SliverToBoxAdapter(child: SizedBox(height: 28)),
            ],
          ),
        ),
      ),
    );
  }
}

class _ClassificationInfo extends StatelessWidget {
  const _ClassificationInfo();

  @override
  Widget build(BuildContext context) {
    final labels = AiDiseaseLabel.values
        .where((label) => label != AiDiseaseLabel.unknown)
        .toList();
    return Container(
      key: const Key('ai-classification-info'),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AiDiagnosisStyle.lavender,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline,
            size: 18,
            color: AiDiagnosisStyle.purple,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hỗ trợ dự đoán ${labels.length} nhóm',
                  style: const TextStyle(
                    color: AppColors.ink,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  labels.map(AiDiagnosisText.label).join(' · '),
                  style: const TextStyle(
                    color: AppColors.inkSoft,
                    fontSize: 11,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  const _HistoryCard(this.item, {required this.onTap});
  final AiDiagnosisSummary item;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => AiCard(
    onTap: onTap,
    padding: const EdgeInsets.all(14),
    child: Row(
      children: [
        Container(
          width: 36,
          height: 36,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AiDiagnosisStyle.lavender,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const AiIcon('history'),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.runStatus == AiRunStatus.error
                    ? 'Nhận diện không thành công'
                    : AiDiagnosisText.label(item.predictedLabel),
                style: const TextStyle(
                  color: AppColors.ink,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '${item.imageCount} ảnh · ${AiDiagnosisText.date(item.createdAt)}',
                style: const TextStyle(
                  color: AppColors.inkMuted,
                  fontSize: 11,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        if (item.runStatus == AiRunStatus.success)
          Text(
            AiDiagnosisText.percent(item.confidence!),
            style: AppTypography.mono(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AiDiagnosisStyle.purple,
            ),
          )
        else
          const AiBadge('Lỗi', error: true),
        const SizedBox(width: 8),
        const AiIcon('chevron'),
      ],
    ),
  );
}
