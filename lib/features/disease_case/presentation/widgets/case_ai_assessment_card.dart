import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/widgets/app_image_viewer.dart';
import 'package:smartshrimp_app/core/widgets/app_photo_grid.dart';
import 'package:smartshrimp_app/features/ai_diagnosis/domain/entities/ai_diagnosis.dart';
import 'package:smartshrimp_app/features/ai_diagnosis/presentation/widgets/ai_diagnosis_photos.dart';
import 'package:smartshrimp_app/features/ai_diagnosis/presentation/widgets/ai_diagnosis_ui.dart';
import 'package:smartshrimp_app/features/protocol/presentation/widgets/protocol_ui.dart'
    show protocolDate;

import '../../domain/entities/owner_disease_case.dart';
import '../view_models/owner_disease_case_controller.dart';
import 'disease_case_ui.dart';

/// Show the AI result attached to the case, including older label-only records.
class CaseAiAssessmentCard extends ConsumerWidget {
  const CaseAiAssessmentCard({
    required this.caseId,
    required this.assessment,
    required this.legacyLabel,
    super.key,
  });

  final String caseId;
  final DiseaseCaseAiAssessment? assessment;
  final String? legacyLabel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unrecognized =
        assessment?.recognitionStatus == AiRecognitionStatus.unrecognized;
    final label = unrecognized
        ? 'Chưa đủ tin cậy để nhận diện'
        : assessment?.predictedLabel ?? legacyLabel ?? 'Chưa lưu tên bệnh';
    final confidence = assessment?.confidence;
    final createdAt = assessment?.createdAt;
    final processingTimeMs = assessment?.processingTimeMs;
    final recommendation = assessment?.recommendation;
    final urls = assessment?.imageUrls ?? const <String>[];
    final tone = unrecognized ? caseAmber : casePurple;

    return DiseaseCaseSurface(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12,
        children: [
          const Row(
            spacing: 8,
            children: [
              Icon(Icons.auto_awesome_outlined, size: 18, color: caseAiAccent),
              Expanded(child: DiseaseCaseSectionTitle('Chẩn đoán AI')),
            ],
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: tone.background,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8,
              children: [
                Text(
                  label,
                  style: caseTitleStyle.copyWith(color: tone.foreground),
                ),
                if (confidence != null) ...[
                  Row(
                    children: [
                      const Expanded(
                        child: Text('Độ tin cậy', style: caseMetadataStyle),
                      ),
                      Text(
                        AiDiagnosisText.percent(confidence),
                        style: caseTitleStyle.copyWith(color: tone.foreground),
                      ),
                    ],
                  ),
                  LinearProgressIndicator(
                    value: confidence,
                    semanticsLabel: 'Độ tin cậy của AI',
                    color: tone.foreground,
                    backgroundColor: Colors.white,
                    minHeight: 6,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ],
              ],
            ),
          ),
          if (createdAt != null || processingTimeMs != null)
            Wrap(
              spacing: 20,
              runSpacing: 8,
              children: [
                if (createdAt != null)
                  _AssessmentMetric(
                    'Thời điểm nhận diện',
                    protocolDate(createdAt, year: true, time: true),
                  ),
                if (processingTimeMs != null)
                  _AssessmentMetric(
                    'Thời gian xử lý',
                    "${(processingTimeMs / 1000).toStringAsFixed(3).replaceAll('.', ',')} s",
                  ),
              ],
            ),
          if (!unrecognized &&
              recommendation != null &&
              recommendation.trim().isNotEmpty)
            _AssessmentMetric('Khuyến nghị từ AI', recommendation),
          if (urls.isNotEmpty) ...[
            DiseaseCaseSectionTitle(
              'Ảnh nhận diện',
              trailing: DiseaseCaseBadge('${urls.length} ảnh'),
            ),
            AppPhotoGrid(
              itemCount: urls.length,
              imageBuilder: (index) => AiNetworkPhoto(urls[index]),
              labelBuilder: (index) => 'Nhận diện ${index + 1}',
              onOpen: (index) => _openImages(context, ref, index),
            ),
          ],
          const Text(
            'Kết quả AI chỉ hỗ trợ nhận diện dấu hiệu, không thay thế đánh giá của Chuyên gia.',
            style: caseMetadataStyle,
          ),
        ],
      ),
    );
  }

  Future<void> _openImages(
    BuildContext context,
    WidgetRef ref,
    int index,
  ) async {
    final provider = diseaseCaseDetailProvider(caseId);
    final viewer = showAppImageViewer(
      context,
      builder: (_) => Consumer(
        builder: (context, ref, _) {
          final state = ref.watch(provider);
          final urls = state.value?.aiAssessment?.imageUrls ?? const <String>[];
          if (state.isLoading) {
            return const FractionallySizedBox(
              heightFactor: .78,
              child: Center(child: CircularProgressIndicator()),
            );
          }
          if (state.hasError && urls.isEmpty) {
            return FractionallySizedBox(
              heightFactor: .78,
              child: Center(
                child: TextButton(
                  onPressed: () => ref.invalidate(provider),
                  child: const Text('Tải lại ảnh'),
                ),
              ),
            );
          }
          return AppImageViewer(
            itemCount: urls.length,
            initialIndex: index,
            selectionColor: caseAiAccent,
            imageBuilder: (i, fit) => AiNetworkPhoto(
              urls[i],
              fit: fit,
              onRetry: () => ref.invalidate(provider),
            ),
          );
        },
      ),
    );
    if (assessment?.imagesExpireBy(DateTime.now()) == true) {
      ref.invalidate(provider);
    }
    await viewer;
  }
}

class _AssessmentMetric extends StatelessWidget {
  const _AssessmentMetric(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    spacing: 3,
    children: [
      Text(label, style: caseMetadataStyle),
      Text(value, style: caseBodyStyle.copyWith(color: AppColors.ink)),
    ],
  );
}
