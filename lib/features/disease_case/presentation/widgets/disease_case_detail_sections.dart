import 'package:flutter/material.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/widgets/app_svg_icon.dart';
import 'package:smartshrimp_app/features/auth/domain/entities/auth_account.dart';
import 'package:smartshrimp_app/features/protocol/domain/entities/protocol.dart';
import 'package:smartshrimp_app/features/protocol/presentation/widgets/protocol_ui.dart'
    show ProtocolBadge, protocolDate;

import 'package:smartshrimp_app/features/water_log/presentation/widgets/owner_water_log_card.dart';
import 'package:smartshrimp_app/features/water_log/presentation/widgets/water_log_card.dart';

import '../../domain/entities/owner_disease_case.dart';
import 'disease_case_ui.dart';

export 'case_evidence.dart' show CaseEvidence;

class CaseOpeningSnapshot extends StatelessWidget {
  const CaseOpeningSnapshot({required this.snapshot, super.key});

  final DiseaseCaseSnapshot? snapshot;

  @override
  Widget build(BuildContext context) {
    final reading =
        snapshot ?? const DiseaseCaseSnapshot(exceededWaterMetrics: []);
    final hasHealth =
        reading.healthRecordedAt != null ||
        reading.healthStatus != null ||
        reading.avgWeightG != null ||
        reading.mortalityCount != null;
    final hasWater =
        reading.waterRecordedAt != null ||
        reading.hasMeasurements ||
        reading.waterNote?.trim().isNotEmpty == true;
    return DiseaseCaseSurface(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 12,
        children: [
          const DiseaseCaseSectionTitle('Hiện trạng khi mở ca'),
          if (!hasHealth && !hasWater)
            const Text(
              'Chưa có thông tin ghi nhận khi mở ca.',
              style: caseBodyStyle,
            )
          else ...[
            if (hasHealth) _OpeningHealth(snapshot: reading),
            if (hasHealth && hasWater) caseDivider,
            if (hasWater)
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: 8,
                children: [
                  _OpeningObservationHeading(
                    title: 'Nhật ký đo nước',
                    recordedAt: reading.waterRecordedAt,
                    timeLabel: 'Đo lúc',
                    status: reading.hasMeasurements
                        ? WaterLogStatusBadge(log: reading)
                        : null,
                  ),
                  WaterLogObservation(
                    measurements: reading,
                    note: reading.waterNote,
                    showStatusBadge: false,
                  ),
                ],
              ),
            if (reading.note case final note? when note.trim().isNotEmpty) ...[
              caseDivider,
              Text(note, style: caseBodyStyle.copyWith(fontSize: 11)),
            ],
          ],
        ],
      ),
    );
  }
}

class _OpeningHealth extends StatelessWidget {
  const _OpeningHealth({required this.snapshot});

  final DiseaseCaseSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final status = switch (snapshot.healthStatus) {
      OpeningHealthStatus.excellent => const DiseaseCaseBadge(
        'Rất tốt',
        tone: caseTeal,
        dot: true,
      ),
      OpeningHealthStatus.good => const DiseaseCaseBadge(
        'Tốt',
        tone: caseTeal,
        dot: true,
      ),
      OpeningHealthStatus.warning => const DiseaseCaseBadge(
        'Cần chú ý',
        tone: caseAmber,
        dot: true,
      ),
      OpeningHealthStatus.critical => const DiseaseCaseBadge(
        'Nguy cấp',
        tone: caseRose,
        dot: true,
      ),
      null => null,
    };
    final metrics = [
      if (snapshot.avgWeightG case final weight?)
        _OpeningMetric(label: 'Cỡ TB', value: weight, unit: 'g/con'),
      if (snapshot.mortalityCount case final mortality?)
        _OpeningMetric(
          label: 'Hao hụt',
          value: mortality,
          unit: 'con',
          tone: mortality > 0 ? caseAmber : null,
        ),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 8,
      children: [
        _OpeningObservationHeading(
          title: 'Sức khỏe',
          recordedAt: snapshot.healthRecordedAt,
          timeLabel: 'Ghi nhận lúc',
          status: status,
        ),
        if (metrics.isNotEmpty)
          LayoutBuilder(
            builder: (context, constraints) {
              const gap = 8.0;
              final minWidth = MediaQuery.textScalerOf(context).scale(96);
              if (metrics.length == 1 ||
                  constraints.maxWidth < 2 * minWidth + gap) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: gap,
                  children: metrics,
                );
              }
              return IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: gap,
                  children: [
                    for (final metric in metrics) Expanded(child: metric),
                  ],
                ),
              );
            },
          ),
      ],
    );
  }
}

class _OpeningObservationHeading extends StatelessWidget {
  const _OpeningObservationHeading({
    required this.title,
    required this.recordedAt,
    required this.timeLabel,
    this.status,
  });

  final String title;
  final DateTime? recordedAt;
  final String timeLabel;
  final Widget? status;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    spacing: 4,
    children: [
      LayoutBuilder(
        builder: (context, constraints) => Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 8,
          children: [
            Expanded(child: Text(title, style: caseTitleStyle)),
            if (status case final badge?)
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: constraints.maxWidth / 2),
                child: badge,
              ),
          ],
        ),
      ),
      Text(
        recordedAt == null
            ? 'Chưa lưu thời điểm ghi nhận'
            : '$timeLabel ${protocolDate(recordedAt, year: true, time: true)}',
        style: caseMetadataStyle,
      ),
    ],
  );
}

class _OpeningMetric extends StatelessWidget {
  const _OpeningMetric({
    required this.label,
    required this.value,
    this.unit,
    this.tone,
  });

  final String label;
  final num value;
  final String? unit;
  final CaseTone? tone;

  @override
  Widget build(BuildContext context) => Container(
    constraints: const BoxConstraints(minHeight: 71),
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: tone?.background ?? const Color(0xCCEEF1F6),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: caseMetadataStyle.copyWith(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 2),
        FittedBox(
          alignment: Alignment.centerLeft,
          fit: BoxFit.scaleDown,
          child: Text(
            '$value',
            style: TextStyle(
              fontFamily: 'JetBrainsMono',
              color: tone?.foreground ?? AppColors.ink,
              fontSize: 14,
              height: 1.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        if (unit != null)
          Text(unit!, style: caseMetadataStyle.copyWith(fontSize: 9)),
      ],
    ),
  );
}

class CaseTreatmentProtocols extends StatelessWidget {
  const CaseTreatmentProtocols({
    required this.protocols,
    required this.onOpen,
    super.key,
  });

  final List<DiseaseCaseProtocol> protocols;
  final ValueChanged<String> onOpen;

  @override
  Widget build(BuildContext context) => Column(
    spacing: 8,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: DiseaseCaseSectionTitle(
          'Phác đồ điều trị',
          trailing: Text(
            '${protocols.length} phiên bản',
            style: caseMetadataStyle,
          ),
        ),
      ),
      for (final protocol in protocols)
        DiseaseCaseSurface(
          onTap: () => onOpen(protocol.id),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DiseaseCaseTitleRow(
                title: Text(
                  protocol.title,
                  style: caseTitleStyle.copyWith(fontSize: 13),
                ),
                badge: protocol.status == ProtocolStatus.superseded
                    ? const DiseaseCaseBadge('Đã thay thế')
                    : ProtocolBadge.status(
                        protocol.status,
                        dot: protocol.status == ProtocolStatus.pendingApproval,
                      ),
              ),
              if (protocol.summary case final summary?) ...[
                const SizedBox(height: 6),
                Text(summary, style: caseBodyStyle.copyWith(fontSize: 11)),
              ],
              const SizedBox(height: 10),
              caseDivider,
              const SizedBox(height: 10),
              Row(
                spacing: 6,
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: DiseaseCaseBadge(
                        'Phiên bản ${protocol.versionNo}',
                      ),
                    ),
                  ),
                  const Text('Xem phác đồ', style: caseMetadataStyle),
                  const AppSvgIcon(AppSvgIconName.chevronCompact, size: 12),
                ],
              ),
            ],
          ),
        ),
    ],
  );
}

class CaseTimeline extends StatelessWidget {
  const CaseTimeline({required this.events, super.key});

  final List<DiseaseCaseEvent> events;

  @override
  Widget build(BuildContext context) => SliverList.builder(
    itemCount: events.length + 1,
    itemBuilder: (_, index) {
      if (index == 0) {
        return const Padding(
          padding: EdgeInsets.fromLTRB(4, 0, 4, 8),
          child: DiseaseCaseSectionTitle('Diễn biến và trách nhiệm'),
        );
      }
      return _TimelineEntry(
        event: events[index - 1],
        first: index == 1,
        last: index == events.length,
      );
    },
  );
}

/// Preserve server event order and distinguish audited decisions from ordinary replies.
class _TimelineEntry extends StatelessWidget {
  const _TimelineEntry({
    required this.event,
    required this.first,
    required this.last,
  });

  final DiseaseCaseEvent event;
  final bool first;
  final bool last;

  @override
  Widget build(BuildContext context) {
    final (icon, iconTone, heading) = switch (event) {
      DiseaseCaseStatusChange(:final fromStatus, :final toStatus) => (
        AppSvgIconName.refresh,
        caseNeutral,
        Wrap(
          spacing: 6,
          runSpacing: 6,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            if (fromStatus != null) ...[
              DiseaseCaseBadge.status(fromStatus, dot: false),
              const AppSvgIcon(AppSvgIconName.chevronCompact, size: 12),
            ],
            DiseaseCaseBadge.status(
              toStatus,
              dot: toStatus != DiseaseCaseStatus.waitingForInfo,
            ),
          ],
        ),
      ),
      DiseaseCaseResponse(
        :final responseType,
        :final authorRole,
        :final careAction,
      ) =>
        (
          AppSvgIconName.message,
          careAction?.isDecision == true
              ? caseAmber
              : authorRole == AccountRole.expert
              ? casePurple
              : caseBlue,
          _ResponseHeading(
            type: responseType,
            role: authorRole,
            careDecision: careAction?.isDecision ?? false,
          ),
        ),
    };
    final message = event.message;
    return Stack(
      children: [
        if (!first || !last)
          Positioned(
            left: 15.5,
            top: first ? 16 : 0,
            bottom: last ? null : 0,
            height: last ? 16 : null,
            width: 1,
            child: const ColoredBox(color: AppColors.line),
          ),
        Padding(
          padding: EdgeInsets.only(bottom: last ? 0 : 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 12,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: icon == AppSvgIconName.refresh
                      ? const Color(0xFFF1F5F9)
                      : iconTone.background,
                ),
                child: SizedBox.square(
                  dimension: 32,
                  child: Center(
                    child: AppSvgIcon(
                      icon,
                      size: 14,
                      color: iconTone == casePurple
                          ? caseAiAccent
                          : icon == AppSvgIconName.message
                          ? AppColors.ocean
                          : iconTone.foreground,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: DiseaseCaseSurface(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      heading,
                      if (message != null && message.trim().isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          message,
                          style: event is DiseaseCaseResponse
                              ? caseBodyStyle.copyWith(color: AppColors.ink)
                              : caseBodyStyle.copyWith(fontSize: 11),
                        ),
                      ],
                      const SizedBox(height: 10),
                      Text(
                        '${event.authorName} · ${protocolDate(event.at, year: true, time: true)}',
                        style: caseMetadataStyle,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ResponseHeading extends StatelessWidget {
  const _ResponseHeading({
    required this.type,
    required this.role,
    this.careDecision = false,
  });

  final DiseaseCaseResponseType type;
  final AccountRole role;
  final bool careDecision;

  @override
  Widget build(BuildContext context) {
    final (label, tone) = careDecision
        ? ('Quyết định chăm sóc', caseAmber)
        : switch (type) {
            DiseaseCaseResponseType.normal => ('Trao đổi', caseBlue),
            DiseaseCaseResponseType.requestInfo => (
              'Yêu cầu bổ sung',
              caseAmber,
            ),
            DiseaseCaseResponseType.provideInfo => (
              'Bổ sung thông tin',
              caseBlue,
            ),
            DiseaseCaseResponseType.monitoringResult => (
              'Kết quả theo dõi',
              caseTeal,
            ),
            DiseaseCaseResponseType.treatmentResult => (
              'Kết quả điều trị',
              caseTeal,
            ),
            DiseaseCaseResponseType.emergencyAlert => (
              'Cảnh báo khẩn cấp',
              caseRose,
            ),
            DiseaseCaseResponseType.expertAssessment => (
              'Đánh giá chuyên gia',
              casePurple,
            ),
            DiseaseCaseResponseType.expertInstruction => (
              'Chỉ dẫn chuyên gia',
              casePurple,
            ),
            DiseaseCaseResponseType.resolution => ('Kết luận', caseTeal),
            DiseaseCaseResponseType.unknown => ('Phản hồi', caseNeutral),
          };
    final roleLabel = switch (role) {
      AccountRole.technician => 'Kỹ thuật viên',
      AccountRole.expert => 'Chuyên gia',
      AccountRole.farmOwner => 'Chủ trại',
      AccountRole.admin => 'Quản trị viên',
      AccountRole.unknown => null,
    };
    return Wrap(
      spacing: 6,
      runSpacing: 4,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        DiseaseCaseBadge(label, tone: tone),
        if (roleLabel != null)
          Text(
            roleLabel,
            style: caseMetadataStyle.copyWith(fontWeight: FontWeight.w600),
          ),
      ],
    );
  }
}
