import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/widgets/app_notice.dart';
import 'package:smartshrimp_app/core/widgets/app_svg_icon.dart';
import 'package:smartshrimp_app/features/auth/domain/entities/auth_account.dart';
import 'package:smartshrimp_app/features/protocol/domain/entities/protocol.dart';
import 'package:smartshrimp_app/features/protocol/presentation/widgets/protocol_ui.dart'
    show ProtocolBadge, protocolDate;
import 'package:url_launcher/url_launcher.dart';

import '../../domain/entities/owner_disease_case.dart';
import 'disease_case_ui.dart';

class CaseOpeningSnapshot extends StatelessWidget {
  const CaseOpeningSnapshot({required this.snapshot, super.key});

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
      ('avgWeightG', 'Cỡ TB', snapshot.avgWeightG, 'g/con'),
      ('mortalityCount', 'Hao hụt', snapshot.mortalityCount, 'con'),
      ('ph', 'pH', snapshot.ph, null),
      ('no2MgL', 'NO₂', snapshot.no2MgL, 'mg/L'),
      ('nh3MgL', 'NH₃', snapshot.nh3MgL, 'mg/L'),
    ].where((metric) => metric.$3 != null);
    return DiseaseCaseSurface(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DiseaseCaseSectionTitle('Hiện trạng khi mở ca', trailing: status),
          if (snapshot.capturedAt case final capturedAt?)
            Text(
              'Chụp tại ${protocolDate(capturedAt, year: true, time: true)}',
              style: caseMetadataStyle,
            ),
          if (metrics.isNotEmpty) ...[
            const SizedBox(height: 12),
            LayoutBuilder(
              builder: (context, constraints) {
                const gap = 8.0;
                final minWidth = MediaQuery.textScalerOf(context).scale(68);
                final columns =
                    ((constraints.maxWidth + gap) / (minWidth + gap))
                        .floor()
                        .clamp(1, 4);
                final width =
                    (constraints.maxWidth - gap * (columns - 1)) / columns;
                return Wrap(
                  spacing: gap,
                  runSpacing: gap,
                  children: [
                    for (final (field, label, value, unit) in metrics)
                      SizedBox(
                        width: width,
                        child: _OpeningMetric(
                          label: label,
                          value: value!,
                          unit: unit,
                          tone: snapshot.exceededWaterMetrics.contains(field)
                              ? caseRose
                              : field == 'mortalityCount' && value > 0
                              ? caseAmber
                              : null,
                        ),
                      ),
                  ],
                );
              },
            ),
          ],
          if (snapshot.note case final note?) ...[
            const SizedBox(height: 12),
            caseDivider,
            const SizedBox(height: 8),
            Text(note, style: caseBodyStyle.copyWith(fontSize: 11)),
          ],
        ],
      ),
    );
  }
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

class CaseEvidence extends StatelessWidget {
  const CaseEvidence({required this.attachments, super.key});

  final List<DiseaseCaseAttachment> attachments;

  @override
  Widget build(BuildContext context) => Column(
    spacing: 8,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: DiseaseCaseSectionTitle(
          'Bằng chứng ban đầu',
          trailing: DiseaseCaseBadge('${attachments.length} tệp'),
        ),
      ),
      for (final item in attachments)
        DiseaseCaseSurface(
          onTap: () => _openAttachment(context, item.fileUrl),
          child: Row(
            spacing: 12,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: casePurple.background,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: AppSvgIcon(
                    item.mediaType?.toLowerCase().startsWith('image/') == true
                        ? AppSvgIconName.camera
                        : AppSvgIconName.document,
                    color: caseAiAccent,
                    size: 18,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.caption ?? 'Tệp đính kèm',
                      style: caseTitleStyle.copyWith(fontSize: 12, height: 1.5),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${item.uploaderName} · ${protocolDate(item.createdAt, year: true, time: true)}',
                      style: caseMetadataStyle,
                    ),
                    if (item.mediaType case final type?)
                      Text(
                        type.toUpperCase(),
                        style: caseMetadataStyle.copyWith(fontSize: 9),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
    ],
  );

  Future<void> _openAttachment(BuildContext context, String url) async {
    final uri = Uri.tryParse(url);
    if (uri != null &&
        (uri.isScheme('https') || uri.isScheme('http')) &&
        uri.host.isNotEmpty) {
      try {
        if (await launchUrl(uri, mode: LaunchMode.externalApplication)) return;
      } on PlatformException {
        // Use the same notice when the device cannot open the file.
      }
    }
    if (context.mounted) {
      AppNoticeService.danger(context, 'Không thể mở tệp đính kèm.');
    }
  }
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 2,
            children: [
              DiseaseCaseSectionTitle('Diễn tiến và trách nhiệm'),
              Text(
                'Toàn bộ thay đổi trạng thái và phản hồi theo thứ tự thời gian',
                style: caseMetadataStyle,
              ),
            ],
          ),
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
            Text(
              'Đổi trạng thái',
              style: caseTitleStyle.copyWith(fontSize: 11),
            ),
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
      DiseaseCaseResponse(:final responseType, :final authorRole) => (
        AppSvgIconName.message,
        authorRole == AccountRole.expert ? casePurple : caseBlue,
        _ResponseHeading(type: responseType, role: authorRole),
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
  const _ResponseHeading({required this.type, required this.role});

  final DiseaseCaseResponseType type;
  final AccountRole role;

  @override
  Widget build(BuildContext context) {
    final (label, tone) = switch (type) {
      DiseaseCaseResponseType.requestInfo => ('Yêu cầu bổ sung', caseAmber),
      DiseaseCaseResponseType.provideInfo => ('Bổ sung thông tin', caseBlue),
      DiseaseCaseResponseType.monitoringResult => (
        'Kết quả theo dõi',
        caseTeal,
      ),
      DiseaseCaseResponseType.treatmentResult => ('Kết quả điều trị', caseTeal),
      DiseaseCaseResponseType.emergencyAlert => ('Cảnh báo khẩn cấp', caseRose),
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
      AccountRole.technician => 'KTV',
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
