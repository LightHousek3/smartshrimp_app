import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/widgets/app_notice.dart';
import 'package:smartshrimp_app/features/assigned_season/presentation/view_models/assigned_season_controller.dart';
import '../../domain/entities/ai_diagnosis.dart';
import '../view_models/ai_diagnosis_controller.dart';
import '../widgets/ai_diagnosis_photos.dart';
import '../widgets/ai_diagnosis_ui.dart';

class AiDiagnosisDetailPage extends ConsumerStatefulWidget {
  const AiDiagnosisDetailPage({
    required this.seasonId,
    required this.diagnosisId,
    super.key,
  });
  final String seasonId;
  final String diagnosisId;
  @override
  ConsumerState<AiDiagnosisDetailPage> createState() =>
      _AiDiagnosisDetailPageState();
}

class _AiDiagnosisDetailPageState extends ConsumerState<AiDiagnosisDetailPage>
    with WidgetsBindingObserver {
  AiDiagnosisKey get diagnosisKey =>
      (seasonId: widget.seasonId, diagnosisId: widget.diagnosisId);
  bool openingImage = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final detail = ref
        .read(aiDiagnosisDetailProvider(diagnosisKey))
        .asData
        ?.value;
    if (state == AppLifecycleState.resumed &&
        detail?.imageUrlsExpiredAt(DateTime.now()) == true) {
      refresh();
    }
  }

  Future<void> refresh() async {
    try {
      await ref
          .read(aiDiagnosisDetailProvider(diagnosisKey).notifier)
          .refresh();
    } on Object catch (error) {
      if (mounted) {
        AppNoticeService.show(
          context,
          message: AiDiagnosisText.message(error),
          level: AppNoticeLevel.danger,
        );
      }
    }
  }

  Future<void> viewImage(int index) async {
    if (openingImage) return;
    setState(() => openingImage = true);
    try {
      await ref
          .read(aiDiagnosisDetailProvider(diagnosisKey).notifier)
          .imagesForViewing();
      if (!mounted) return;
      await showModalBottomSheet<void>(
        context: context,
        useRootNavigator: true,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
        ),
        builder: (_) => AiDiagnosisImageViewer(
          initialIndex: index,
          diagnosisKey: diagnosisKey,
        ),
      );
    } on Object catch (error) {
      if (mounted) {
        AppNoticeService.show(
          context,
          message: AiDiagnosisText.message(error),
          level: AppNoticeLevel.danger,
        );
      }
    } finally {
      if (mounted) setState(() => openingImage = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(aiDiagnosisDetailProvider(diagnosisKey));
    final season = ref
        .watch(assignedSeasonDetailProvider(widget.seasonId))
        .asData
        ?.value;
    return AiDiagnosisFrame(
      title: 'Chi tiết nhận diện AI',
      subtitle: season == null ? null : '${season.pondName} · ${season.name}',
      child: state.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AiDiagnosisStyle.purple),
        ),
        error: (error, _) => Center(
          child: AiFailure(error: error, onRetry: refresh),
        ),
        data: (detail) => RefreshIndicator(
          onRefresh: refresh,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            children: [
              _ResultCard(detail),
              const SizedBox(height: 16),
              AiCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Expanded(child: AiTitle('Ảnh đã gửi')),
                        AiBadge('${detail.imageUrls.length} ảnh'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Chạm vào từng ảnh để xem đầy đủ.',
                      style: TextStyle(color: AppColors.inkMuted, fontSize: 11),
                    ),
                    const SizedBox(height: 12),
                    AiPhotoGrid(
                      count: detail.imageUrls.length,
                      busy: openingImage,
                      imageBuilder: (i) =>
                          AiNetworkPhoto(detail.imageUrls[i], onRetry: refresh),
                      onView: viewImage,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              if (detail.runStatus == AiRunStatus.success) ...[
                AiCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const AiTitle('Khuyến nghị từ AI'),
                      const SizedBox(height: 10),
                      Text(
                        detail.recommendation?.trim().isNotEmpty == true
                            ? detail.recommendation!
                            : 'Chưa có khuyến nghị.',
                        style: const TextStyle(
                          color: AppColors.inkSoft,
                          fontSize: 13,
                          height: 1.65,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFCF0DA),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Kết quả AI chỉ hỗ trợ nhận diện dấu hiệu, không thay thế đánh giá của Chuyên gia.',
                          style: TextStyle(
                            color: Color(0xFFB94B00),
                            fontSize: 11,
                            height: 1.6,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Tooltip(
                  message: 'Chưa hỗ trợ tạo ca bệnh từ kết quả AI.',
                  child: SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: null,
                      icon: const AiIcon('case'),
                      style: FilledButton.styleFrom(
                        disabledBackgroundColor: AppColors.error.withValues(
                          alpha: 0.45,
                        ),
                        disabledForegroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      label: const Text(
                        'Tạo ca bệnh từ kết quả này',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  const _ResultCard(this.detail);
  final AiDiagnosisDetail detail;
  @override
  Widget build(BuildContext context) {
    final success = detail.runStatus == AiRunStatus.success;
    return AiCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(height: 6),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        success
                            ? AiDiagnosisText.label(detail.predictedLabel)
                            : 'Nhận diện không thành công',
                        style: const TextStyle(
                          color: AppColors.ink,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          height: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: success
                            ? const Color(0xFFE2F6F3)
                            : const Color(0xFFFBE6EA),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        success ? '● Thành công' : '● Lỗi',
                        style: TextStyle(
                          fontSize: 11,
                          color: success
                              ? AiDiagnosisStyle.teal
                              : AppColors.error,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                if (success) ...[
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Độ tin cậy',
                          style: TextStyle(
                            color: AppColors.inkMuted,
                            fontSize: 11,
                          ),
                        ),
                      ),
                      Text(
                        AiDiagnosisText.percent(detail.confidence!),
                        style: AppTypography.mono(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AiDiagnosisStyle.purple,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: LinearProgressIndicator(
                      value: detail.confidence,
                      minHeight: 8,
                      color: AiDiagnosisStyle.purple,
                      backgroundColor: const Color(0xFFF1F5F9),
                    ),
                  ),
                ] else ...[
                  const SizedBox(height: 12),
                  Text(
                    detail.error!.message,
                    style: const TextStyle(
                      color: AppColors.error,
                      fontSize: 12,
                      height: 1.5,
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                LayoutBuilder(
                  builder: (_, constraints) {
                    final width = constraints.maxWidth > 300
                        ? (constraints.maxWidth - 8) / 2
                        : constraints.maxWidth;
                    return Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _Metric(
                          'Thời gian xử lý',
                          detail.processingTimeMs == null
                              ? '—'
                              : '${(detail.processingTimeMs! / 1000).toStringAsFixed(3).replaceAll('.', ',')} s',
                          width,
                        ),
                        _Metric(
                          'Thời điểm yêu cầu',
                          AiDiagnosisText.date(detail.createdAt),
                          width,
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric(this.title, this.value, this.width);
  final String title, value;
  final double width;
  @override
  Widget build(BuildContext context) => Container(
    width: width,
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    decoration: BoxDecoration(
      color: AiDiagnosisStyle.muted,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(color: AppColors.inkMuted, fontSize: 10),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.ink,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            height: 1.5,
          ),
        ),
      ],
    ),
  );
}
