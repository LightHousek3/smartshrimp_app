import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartshrimp_app/core/widgets/app_error_state.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/widgets/app_notice.dart';
import 'package:smartshrimp_app/features/water_log/domain/entities/water_log.dart'
    show waterLogFormParams;
import 'package:smartshrimp_app/features/water_log/presentation/view_models/water_log_controller.dart';
import '../../domain/domain.dart';
import '../../domain/entities/owner_disease_case.dart' show DiseaseCaseSnapshot;
import '../view_models/case_evidence_draft.dart';
import '../view_models/disease_case_controller.dart';
import '../widgets/case_ui.dart';
import '../widgets/case_evidence.dart';
import '../widgets/case_evidence_picker.dart';
import '../widgets/case_care_notice.dart';
import '../widgets/disease_case_detail_sections.dart' show CaseOpeningSnapshot;

/// Show observations, evidence and conversation for the technician's selected case.
class DiseaseCaseDetailPage extends ConsumerStatefulWidget {
  const DiseaseCaseDetailPage({
    super.key,
    required this.seasonId,
    required this.caseId,
  });
  final String seasonId;
  final String caseId;
  @override
  ConsumerState<DiseaseCaseDetailPage> createState() =>
      _DiseaseCaseDetailPageState();
}

class _DiseaseCaseDetailPageState extends ConsumerState<DiseaseCaseDetailPage> {
  final _message = TextEditingController();
  final _form = GlobalKey<FormState>();
  final _evidence = CaseEvidenceDraft();
  bool _picking = false;
  bool _sending = false;
  @override
  void dispose() {
    _message.dispose();
    super.dispose();
  }

  Future<void> _respond(DiseaseCase item) async {
    if (_picking ||
        _sending ||
        ref.read(diseaseCaseMutationProvider).isLoading) {
      return;
    }
    if (!(_form.currentState?.validate() ?? false)) return;
    setState(() => _sending = true);
    final message = _message.text;
    try {
      final mutation = ref.read(diseaseCaseMutationProvider.notifier);
      final attachments = await _evidence.upload(
        uploadImage: mutation.uploadEvidence,
        isActive: () => mounted,
      );
      if (!mounted || attachments == null) return;
      await mutation.respond(
        widget.seasonId,
        item,
        CaseResponseType.normal,
        message,
        attachments: attachments,
      );
      if (mounted) {
        _message.clear();
        _evidence.replace(const []);
      }
    } catch (error) {
      if (mounted) {
        AppNoticeService.danger(context, caseError(error));
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  Future<void> _emergency() async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (context) => _EmergencySheet(
        onSend: (text) async {
          final current = await ref.read(
            diseaseCaseDetailProvider((
              seasonId: widget.seasonId,
              id: widget.caseId,
            )).future,
          );
          await ref
              .read(diseaseCaseMutationProvider.notifier)
              .respond(
                widget.seasonId,
                current,
                CaseResponseType.emergencyAlert,
                text,
              );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = diseaseCaseDetailProvider((
      seasonId: widget.seasonId,
      id: widget.caseId,
    ));
    final state = ref.watch(provider);
    final item = state.value;
    final sending =
        ref.watch(diseaseCaseMutationProvider).isLoading || _sending;
    final disabled = sending || state.hasError;
    return CaseFrame(
      title: 'Chi tiết ca bệnh',
      subtitle: item == null ? null : caseContext(item.caseSnapshot),
      trailing: item == null
          ? null
          : ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 108),
              child: CaseStatusBadge(item.status),
            ),
      composer: item?.allowsResponse == true
          ? _composer(item!, disabled: disabled, sending: sending)
          : null,
      child: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => AppErrorState(
          error: error,
          onRetry: () => ref.invalidate(provider),
        ),
        data: (item) => RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(provider);
            await ref.read(provider.future);
          },
          child: ListView(
            padding: const EdgeInsets.fromLTRB(3, 5, 3, 20),
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              if (item.productionPaused) const CaseCareNotice(),
              _CaseOpeningData(item: item),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.only(left: 3, bottom: 10),
                child: Text(
                  'Trò chuyện với chuyên gia',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                  ),
                ),
              ),
              if (item.responses.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(18),
                  child: Text(
                    'Chưa có phản hồi.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: AppColors.inkMuted),
                  ),
                ),
              for (final response in item.responses)
                _ResponseBubble(response: response),
              if (item.resolutionSummary != null)
                CaseSurface(
                  child: Text(
                    'Kết luận: ${item.resolutionSummary}',
                    style: const TextStyle(
                      fontSize: 12,
                      height: 1.6,
                      color: AppColors.inkSoft,
                    ),
                  ),
                ),
              if (!item.allowsResponse)
                const Padding(
                  padding: EdgeInsets.only(top: 12),
                  child: Text(
                    'Ca bệnh hiện chỉ cho phép xem.',
                    style: TextStyle(fontSize: 12, color: AppColors.inkMuted),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _composer(
    DiseaseCase item, {
    required bool disabled,
    required bool sending,
  }) {
    final busy = disabled || _picking;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.line)),
        boxShadow: [
          BoxShadow(
            color: Color(0x080F1C2E),
            blurRadius: 16,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: Form(
        key: _form,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: CaseEvidencePicker(
                    compact: true,
                    images: _evidence.images,
                    disabled: disabled,
                    onChanged: (images) =>
                        setState(() => _evidence.replace(images)),
                    onBusyChanged: (value) => setState(() => _picking = value),
                  ),
                ),
                const SizedBox(width: 8),
                Tooltip(
                  message: 'Gửi cảnh báo khẩn cho chuyên gia',
                  child: OutlinedButton.icon(
                    key: const ValueKey('case-emergency-alert'),
                    onPressed: busy ? null : _emergency,
                    icon: const Icon(Icons.warning_amber_rounded, size: 17),
                    label: const Text(
                      'Báo khẩn',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: caseRose,
                      side: const BorderSide(color: Color(0xFFF4B8C4)),
                      minimumSize: const Size(0, 44),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _message,
              enabled: !busy,
              minLines: 2,
              maxLines: 3,
              textCapitalization: TextCapitalization.sentences,
              keyboardType: TextInputType.multiline,
              style: const TextStyle(fontSize: 14, height: 1.5),
              decoration: caseInput('Nhập thông tin cần gửi cho chuyên gia…')
                  .copyWith(
                    hintStyle: const TextStyle(
                      fontSize: 13,
                      height: 1.5,
                      color: AppColors.inkMuted,
                    ),
                    fillColor: const Color(0xFFF8FAFC),
                    contentPadding: const EdgeInsets.fromLTRB(12, 12, 8, 12),
                    suffixIcon: Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: Tooltip(
                        message: 'Gửi phản hồi',
                        child: IconButton.filled(
                          key: const ValueKey('case-send-response'),
                          onPressed: busy ? null : () => _respond(item),
                          style: IconButton.styleFrom(
                            backgroundColor: AppColors.ocean,
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: AppColors.ocean.withValues(
                              alpha: 0.4,
                            ),
                            disabledForegroundColor: Colors.white,
                            minimumSize: const Size(40, 40),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          icon: sending
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(Icons.send_rounded, size: 18),
                        ),
                      ),
                    ),
                    suffixIconConstraints: const BoxConstraints(
                      minWidth: 48,
                      minHeight: 40,
                    ),
                  ),
              validator: (value) =>
                  DiseaseCaseRules.textError(value, DiseaseCaseRules.textLimit),
            ),
          ],
        ),
      ),
    );
  }
}

class _CaseOpeningData extends StatelessWidget {
  const _CaseOpeningData({required this.item});

  final DiseaseCase item;

  @override
  Widget build(BuildContext context) => CaseSurface(
    padding: EdgeInsets.zero,
    child: ExpansionTile(
      key: PageStorageKey((item.seasonId, item.id)),
      tilePadding: const EdgeInsets.symmetric(horizontal: 14),
      childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
      expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
      shape: const Border(),
      collapsedShape: const Border(),
      title: const Text(
        'Dữ liệu lúc mở ca',
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: AppColors.ink,
        ),
      ),
      children: [
        Wrap(
          spacing: 7,
          runSpacing: 7,
          children: [
            CaseBadge(
              'Mức độ: ${item.severity.label}',
              color: caseRose,
              background: const Color(0xFFFBE6EA),
              dot: true,
            ),
            if (item.expert?['fullName'] case final String name)
              CaseBadge(name),
          ],
        ),
        const SizedBox(height: 12),
        // Keep text scroll offsets separate from the tile's expansion state.
        SelectableText(
          'Ca bệnh: ${item.title}',
          key: const PageStorageKey('case-summary-title'),
          style: const TextStyle(
            fontSize: 13,
            height: 1.6,
            fontWeight: FontWeight.w700,
            color: AppColors.ink,
          ),
        ),
        const SizedBox(height: 4),
        SelectableText(
          'Ghi chú: ${item.description?.trim().isNotEmpty == true ? item.description! : '—'}',
          key: const PageStorageKey('case-summary-note'),
          style: const TextStyle(
            fontSize: 12,
            height: 1.7,
            color: AppColors.inkSoft,
          ),
        ),
        if (item.caseSnapshot['aiDiagnosis'] case final Map ai) ...[
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF0E9FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.auto_awesome, color: caseViolet, size: 15),
                const SizedBox(width: 7),
                Expanded(
                  child: Text(
                    'AI tham khảo: ${caseAiLabel(ai)}\n${caseAiConfidence(num.tryParse('${ai['confidence']}'))}',
                    style: const TextStyle(fontSize: 11, color: caseViolet),
                  ),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 8),
        Text(
          'Tạo lúc ${caseDate(item.createdAt)}',
          style: const TextStyle(fontSize: 10, color: AppColors.inkMuted),
        ),
        const SizedBox(height: 12),
        Consumer(
          builder: (context, ref, _) {
            final recorded = item.caseSnapshot;
            final snapshot = DiseaseCaseSnapshot.fromRecordedSnapshot(recorded);
            final water = {
              for (final param in waterLogFormParams)
                param.field: ?snapshot.valueOf(param.field),
            };
            final hasRecordedFlags = recorded['exceededWaterMetrics'] is List;
            final metadata = water.isNotEmpty && !hasRecordedFlags
                ? ref
                      .watch(waterLogMetadataProvider(item.seasonId))
                      .asData
                      ?.value
                : null;
            return CaseOpeningSnapshot(
              showWaterStatus: hasRecordedFlags || metadata != null,
              snapshot: metadata == null
                  ? snapshot
                  : snapshot.copyWith(
                      exceededWaterMetrics: [
                        for (final warning in metadata.warnings(water))
                          warning.threshold.param.field,
                      ],
                    ),
            );
          },
        ),
        if (item.attachments.isNotEmpty)
          CaseAttachmentStrip(
            urls: item.attachments
                .map((attachment) => attachment['fileUrl'])
                .whereType<String>()
                .toList(),
          ),
      ],
    ),
  );
}

class _ResponseBubble extends StatelessWidget {
  const _ResponseBubble({required this.response});
  final CaseResponse response;
  @override
  Widget build(BuildContext context) {
    final mine = response.author?['role'] == 'TECHNICIAN';
    final author = response.author?['fullName'];
    final type = response.responseType;
    // Decision styling comes from audit metadata, never from the message's wording.
    final isCare = response.careAction?.isDecision ?? false;
    final careVisual = appNoticeVisualFor(AppNoticeLevel.warning);
    final color = isCare
        ? careVisual.foreground
        : type == CaseResponseType.emergencyAlert
        ? caseRose
        : type == CaseResponseType.instruction
        ? caseViolet
        : AppColors.ocean;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Align(
        alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
        child: FractionallySizedBox(
          widthFactor: .88,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isCare
                  ? careVisual.background
                  : mine
                  ? const Color(0xFFE5F2FF)
                  : Colors.white,
              borderRadius: BorderRadius.circular(17),
              border: Border.all(
                color: isCare
                    ? careVisual.border
                    : mine
                    ? const Color(0xFFCDE5FB)
                    : AppColors.line,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 6,
                  runSpacing: 5,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      author is String && author.isNotEmpty
                          ? author
                          : mine
                          ? 'Kỹ thuật viên'
                          : 'Chuyên gia',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                      ),
                    ),
                    CaseBadge(
                      isCare ? 'Quyết định chăm sóc' : type.label,
                      color: color,
                      background: color.withValues(alpha: .09),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                SelectableText(
                  response.message,
                  style: const TextStyle(
                    fontSize: 12,
                    height: 1.6,
                    color: AppColors.inkSoft,
                  ),
                ),
                if (response.attachments.isNotEmpty)
                  CaseAttachmentStrip(urls: response.attachments),
                const SizedBox(height: 5),
                Text(
                  caseDate(response.createdAt),
                  style: const TextStyle(
                    fontSize: 9,
                    color: AppColors.inkMuted,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EmergencySheet extends StatefulWidget {
  const _EmergencySheet({required this.onSend});
  final Future<void> Function(String) onSend;
  @override
  State<_EmergencySheet> createState() => _EmergencySheetState();
}

class _EmergencySheetState extends State<_EmergencySheet> {
  final _text = TextEditingController();
  final _form = GlobalKey<FormState>();
  bool _busy = false;
  String? _error;
  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    if (_busy || !_form.currentState!.validate()) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await widget.onSend(_text.text);
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _busy = false;
          _error = caseError(error);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: !_busy,
    child: SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        18,
        20,
        18,
        MediaQuery.viewInsetsOf(context).bottom + 20,
      ),
      child: Form(
        key: _form,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Cảnh báo khẩn',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: 'Đóng cảnh báo',
                  onPressed: _busy ? null : () => Navigator.pop(context),
                  icon: const Icon(Icons.close, size: 20),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'Mô tả tình huống cần hỗ trợ. Cảnh báo được gửi đến chuyên gia và chủ trại.',
              style: TextStyle(fontSize: 12, height: 1.6, color: caseRose),
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _text,
              enabled: !_busy,
              minLines: 3,
              maxLines: 5,
              decoration: caseInput('Mô tả tình huống khẩn cấp…'),
              style: const TextStyle(fontSize: 12),
              validator: (v) =>
                  DiseaseCaseRules.textError(v, DiseaseCaseRules.textLimit),
            ),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  _error!,
                  style: const TextStyle(color: caseRose, fontSize: 12),
                ),
              ),
            const SizedBox(height: 14),
            CasePrimaryButton(
              label: 'Gửi cảnh báo khẩn',
              icon: Icons.warning_amber_rounded,
              destructive: true,
              busy: _busy,
              onPressed: _send,
            ),
          ],
        ),
      ),
    ),
  );
}
