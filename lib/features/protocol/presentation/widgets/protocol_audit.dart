import 'package:flutter/material.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/widgets/app_svg_icon.dart';
import 'package:smartshrimp_app/features/protocol/domain/entities/protocol.dart';
import 'package:smartshrimp_app/features/protocol/presentation/widgets/protocol_ui.dart';

class ProtocolAudit extends StatelessWidget {
  const ProtocolAudit({required this.detail, super.key});
  final ProtocolDetail detail;
  @override
  Widget build(BuildContext context) => ProtocolSurface(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Nguồn gốc & mốc thời gian',
          style: TextStyle(
            fontSize: 12,
            height: 1.5,
            fontWeight: FontWeight.w700,
            color: AppColors.ink,
          ),
        ),
        const SizedBox(height: 8),
        _AuditRow('Chuyên gia soạn', detail.card.authorName),
        _AuditRow(
          'Gửi duyệt',
          protocolDate(detail.card.submittedAt, time: true),
        ),
        _AuditRow(
          'Mốc tính ngày',
          detail.card.protocolType == ProtocolType.treatment
              ? 'Ngày Chủ trại phê duyệt'
              : 'Ngày thả giống của vụ',
        ),
        if (detail.reviewedAt != null)
          _AuditRow(
            detail.card.status == ProtocolStatus.rejected
                ? 'Đã từ chối'
                : 'Đã duyệt',
            '${detail.reviewerName ?? 'Chủ trại'} · ${protocolDate(detail.reviewedAt, time: true)}',
          ),
        if (detail.supersededAt != null)
          _AuditRow(
            'Đã thay thế lúc',
            protocolDate(detail.supersededAt, time: true),
          ),
        const SizedBox(height: 12),
        const Divider(height: 1, color: Color(0xFFEEF1F7)),
        const SizedBox(height: 12),
        const Text(
          'LỊCH SỬ TRẠNG THÁI',
          style: TextStyle(
            fontSize: 10,
            height: 1.5,
            fontWeight: FontWeight.w700,
            letterSpacing: .25,
            color: AppColors.inkMuted,
          ),
        ),
        if (detail.history.isEmpty)
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text(
              'Chưa có lịch sử trạng thái.',
              style: TextStyle(fontSize: 10, color: AppColors.inkMuted),
            ),
          ),
        for (final history in detail.history)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: protocolPanel,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      if (history.fromStatus != null) ...[
                        ProtocolBadge.status(history.fromStatus!),
                        const AppSvgIcon(AppSvgIconName.chevron, size: 13),
                      ],
                      ProtocolBadge.status(history.toStatus, dot: true),
                    ],
                  ),
                  if (history.reason?.isNotEmpty == true)
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        history.reason!,
                        style: const TextStyle(
                          fontSize: 10,
                          height: 1.5,
                          color: AppColors.inkSoft,
                        ),
                      ),
                    ),
                  const SizedBox(height: 6),
                  Text(
                    '${history.changedByName} · ${protocolDate(history.changedAt, time: true)}',
                    style: const TextStyle(
                      fontSize: 9,
                      height: 1.5,
                      color: AppColors.inkMuted,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    ),
  );
}

class _AuditRow extends StatelessWidget {
  const _AuditRow(this.label, this.value);
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            height: 1.5,
            color: AppColors.inkMuted,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: 11,
              height: 1.5,
              fontWeight: FontWeight.w600,
              color: AppColors.ink,
            ),
          ),
        ),
      ],
    ),
  );
}
