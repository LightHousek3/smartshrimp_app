import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/widgets/app_svg_icon.dart';
import 'package:smartshrimp_app/features/protocol/presentation/widgets/protocol_ui.dart'
    show protocolDate;

import '../../domain/entities/owner_disease_case.dart';
import '../view_models/owner_disease_case_controller.dart';
import '../widgets/disease_case_detail_sections.dart';
import '../widgets/disease_case_ui.dart';

class DiseaseCaseDetailPage extends ConsumerWidget {
  const DiseaseCaseDetailPage({required this.caseId, this.subtitle, super.key});

  final String caseId;
  final String? subtitle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = diseaseCaseDetailProvider(caseId);
    final state = ref.watch(provider);
    final detail = state.value;
    return DiseaseCaseFrame(
      title: 'Chi tiết ca bệnh',
      subtitle: detail == null
          ? subtitle
          : '${detail.pondName} · ${detail.seasonName}',
      onRefresh: () async {
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
        data: (detail) => [
          SliverPadding(
            padding: EdgeInsets.fromLTRB(
              16,
              0,
              16,
              detail.timeline.isEmpty ? 28 : 0,
            ),
            sliver: SliverList.list(
              children: [
                _CaseSummary(detail: detail),
                const SizedBox(height: 16),
                _CaseResponsibilities(detail: detail),
                if (detail.snapshot case final snapshot?) ...[
                  const SizedBox(height: 16),
                  CaseOpeningSnapshot(snapshot: snapshot),
                ],
                if (detail.attachments.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  CaseEvidence(attachments: detail.attachments),
                ],
                if (detail.protocols.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  CaseTreatmentProtocols(
                    protocols: detail.protocols,
                    onOpen: (id) =>
                        context.push('/protocols/${Uri.encodeComponent(id)}'),
                  ),
                ],
              ],
            ),
          ),
          if (detail.timeline.isNotEmpty)
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
              sliver: CaseTimeline(events: detail.timeline),
            ),
        ],
      ),
    );
  }
}

class _CaseSummary extends StatelessWidget {
  const _CaseSummary({required this.detail});

  final DiseaseCaseDetail detail;

  @override
  Widget build(BuildContext context) {
    final card = detail.card;
    final conclusion = detail.resolutionSummary;
    final hasResolutionResponse = detail.timeline
        .whereType<DiseaseCaseResponse>()
        .any(
          (event) =>
              event.responseType == DiseaseCaseResponseType.resolution &&
              event.message == conclusion?.trim(),
        );
    return DiseaseCaseSurface(
      summary: true,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: [
              DiseaseCaseBadge.status(card.status),
              DiseaseCaseBadge.severity(card.severity),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            card.title,
            style: caseTitleStyle.copyWith(fontSize: 15, height: 1.5),
          ),
          const SizedBox(height: 10),
          Text(
            card.description,
            style: caseBodyStyle.copyWith(fontSize: 13, height: 1.625),
          ),
          const SizedBox(height: 12),
          caseDivider,
          const SizedBox(height: 10),
          DefaultTextStyle.merge(
            style: caseMetadataStyle.copyWith(fontSize: 11),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4,
              children: [
                Text('Ao: ${detail.pondName} · ${detail.farmName}'),
                Text('Vụ nuôi: ${detail.seasonName}'),
                Text(
                  'Mở ca: ${protocolDate(detail.createdAt, year: true, time: true)}',
                ),
                Text(
                  'Cập nhật cuối: ${protocolDate(detail.updatedAt, year: true, time: true)}',
                ),
              ],
            ),
          ),
          if (card.aiDiagnosis case final diagnosis?) ...[
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: casePurple.background,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFEDE9FE)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CHẨN ĐOÁN AI',
                    style: caseMetadataStyle.copyWith(
                      color: casePurple.foreground,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    diagnosis,
                    style: const TextStyle(
                      color: Color(0xFF7000F5),
                      fontSize: 12,
                      height: 1.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (conclusion != null &&
              conclusion.trim().isNotEmpty &&
              !hasResolutionResponse) ...[
            const SizedBox(height: 10),
            Text('Kết luận: $conclusion', style: caseBodyStyle),
          ],
        ],
      ),
    );
  }
}

class _CaseResponsibilities extends StatelessWidget {
  const _CaseResponsibilities({required this.detail});

  final DiseaseCaseDetail detail;

  @override
  Widget build(BuildContext context) => DiseaseCaseSurface(
    padding: EdgeInsets.zero,
    child: Column(
      children: [
        _ResponsibilityRow(
          label: 'NGƯỜI PHÁT HIỆN VÀ BÁO CA',
          value: detail.reporterName,
        ),
        caseDivider,
        _ResponsibilityRow(
          label: 'CHUYÊN GIA CHỊU TRÁCH NHIỆM',
          value: detail.card.expertName,
        ),
        caseDivider,
        _ResponsibilityRow(
          label: 'SỐ PHẢN HỒI ĐÃ GHI NHẬN',
          value: '${detail.card.responseCount} phản hồi',
        ),
      ],
    ),
  );
}

class _ResponsibilityRow extends StatelessWidget {
  const _ResponsibilityRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    child: Row(
      spacing: 12,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: caseBlue.background,
          ),
          child: const SizedBox.square(
            dimension: 32,
            child: Center(
              child: AppSvgIcon(
                AppSvgIconName.person,
                size: 14,
                color: AppColors.ocean,
              ),
            ),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 2,
            children: [
              Text(
                label,
                style: caseMetadataStyle.copyWith(letterSpacing: .25),
              ),
              Text(
                value,
                style: const TextStyle(
                  color: AppColors.ink,
                  fontSize: 12,
                  height: 1.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
