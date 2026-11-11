import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/widgets/app_notice.dart';
import '../../domain/domain.dart';
import '../view_models/disease_case_controller.dart';
import '../widgets/case_ui.dart';
import '../widgets/case_evidence_picker.dart';

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
  static const _historyExpansionDuration = Duration(milliseconds: 200);
  final _historyKey = GlobalKey();
  Timer? _historyRevealTimer;
  Timer? _successNoticeTimer;
  String? _successNotice;
  bool _historyExpanded = false;
  final _message = TextEditingController();
  final _form = GlobalKey<FormState>();
  CaseResponseType _type = CaseResponseType.provideInfo;
  bool _initialType = false;
  List<String> _evidence = [];
  bool _uploading = false;
  @override
  void dispose() {
    _historyRevealTimer?.cancel();
    _successNoticeTimer?.cancel();
    _message.dispose();
    super.dispose();
  }

  void _clearSuccessNotice() {
    _successNoticeTimer?.cancel();
    if (_successNotice != null) setState(() => _successNotice = null);
  }

  void _showResponseSuccess(String message) {
    _successNoticeTimer?.cancel();
    setState(() => _successNotice = message);
    _successNoticeTimer = Timer(const Duration(milliseconds: 3200), () {
      if (mounted) setState(() => _successNotice = null);
    });
  }

  void _onHistoryExpansionChanged(bool expanded) {
    _historyExpanded = expanded;
    _historyRevealTimer?.cancel();
    if (!expanded) return;
    FocusScope.of(context).unfocus();
    // Start counting after the expansion's first frame, so scrolling uses
    // its final height even when rendering starts after the tap callback.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_historyExpanded) return;
      _historyRevealTimer = Timer(_historyExpansionDuration, () {
        if (!mounted || !_historyExpanded) return;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted || !_historyExpanded) return;
          final historyContext = _historyKey.currentContext;
          if (historyContext == null) return;
          unawaited(
            Scrollable.ensureVisible(
              historyContext,
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
            ),
          );
        });
        WidgetsBinding.instance.ensureVisualUpdate();
      });
    });
  }

  Future<void> _respond(DiseaseCase item) async {
    if (!(_form.currentState?.validate() ?? false)) return;
    _clearSuccessNotice();
    try {
      await ref
          .read(diseaseCaseMutationProvider.notifier)
          .respond(
            widget.seasonId,
            item,
            _type,
            _message.text,
            attachments: _evidence,
          );
      if (mounted) {
        _message.clear();
        setState(() => _evidence = []);
        _showResponseSuccess('Đã gửi phản hồi.');
      }
    } catch (error) {
      if (mounted) {
        AppNoticeService.danger(context, caseError(error));
      }
    }
  }

  Future<void> _emergency() async {
    _clearSuccessNotice();
    final sent = await showModalBottomSheet<bool>(
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
    if (sent == true && mounted) {
      _showResponseSuccess('Đã gửi cảnh báo khẩn đến chuyên gia và chủ trại.');
    }
  }

  Future<void> _openAttachment(String url) async {
    final uri = Uri.tryParse(url);
    var opened = false;
    if (uri != null && uri.scheme == 'https' && uri.host.isNotEmpty) {
      try {
        opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
      } catch (_) {
        opened = false;
      }
    }
    if (!opened && mounted) {
      AppNoticeService.danger(context, 'Không thể mở ảnh minh chứng.');
    }
  }

  Widget _attachments(List<String> urls) => Wrap(
    spacing: 6,
    runSpacing: 4,
    children: [
      for (var i = 0; i < urls.length; i++)
        TextButton.icon(
          onPressed: () => _openAttachment(urls[i]),
          icon: const Icon(Icons.image_outlined, size: 14),
          label: Text('Ảnh ${i + 1}', style: const TextStyle(fontSize: 11)),
        ),
    ],
  );
  @override
  Widget build(BuildContext context) {
    final provider = diseaseCaseDetailProvider((
      seasonId: widget.seasonId,
      id: widget.caseId,
    ));
    final state = ref.watch(provider);
    final item = state.value;
    final sending = ref.watch(diseaseCaseMutationProvider).isLoading;
    final busy = sending || _uploading || item == null || state.hasError;
    if (item != null && !_initialType) {
      _initialType = true;
      _type = switch (item.status) {
        DiseaseCaseStatus.inTreatment => CaseResponseType.treatmentResult,
        DiseaseCaseStatus.monitoring => CaseResponseType.monitoringResult,
        _ => CaseResponseType.provideInfo,
      };
    }
    return CaseFrame(
      title: item?.title ?? 'Chi tiết ca bệnh',
      subtitle: item == null ? null : caseContext(item.caseSnapshot),
      notice: _successNotice == null
          ? null
          : Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Dismissible(
                key: const ValueKey('case-response-success'),
                direction: DismissDirection.up,
                resizeDuration: null,
                onDismissed: (_) => _clearSuccessNotice(),
                child: Material(
                  type: MaterialType.transparency,
                  child: AppNoticeCard(
                    title: 'Thành công',
                    message: _successNotice!,
                    level: AppNoticeLevel.success,
                  ),
                ),
              ),
            ),
      trailing: item == null
          ? null
          : ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 108),
              child: CaseStatusBadge(item.status),
            ),
      composer: item?.allowsResponse == true
          ? _composer(item!, busy, sending)
          : null,
      child: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) =>
            CaseFailure(error: error, retry: () => ref.invalidate(provider)),
        data: (item) => RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(provider);
            await ref.read(provider.future);
          },
          child: ListView(
            padding: const EdgeInsets.fromLTRB(3, 5, 3, 20),
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              CaseSurface(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                    SelectableText(
                      item.description ?? '',
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
                            const Icon(
                              Icons.auto_awesome,
                              color: caseViolet,
                              size: 15,
                            ),
                            const SizedBox(width: 7),
                            Expanded(
                              child: Text(
                                'AI tham khảo: ${caseAiLabel(ai)}\n${caseAiConfidence(num.tryParse('${ai['confidence']}'))}',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: caseViolet,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    if (item.attachments.isNotEmpty)
                      _attachments(
                        item.attachments
                            .map((a) => a['fileUrl'])
                            .whereType<String>()
                            .toList(),
                      ),
                    const SizedBox(height: 8),
                    Text(
                      'Tạo lúc ${caseDate(item.createdAt)}',
                      style: const TextStyle(
                        fontSize: 10,
                        color: AppColors.inkMuted,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              _CaseSnapshot(snapshot: item.caseSnapshot),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.only(left: 3, bottom: 10),
                child: Text(
                  'Diễn tiến trao đổi',
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
                _ResponseBubble(
                  response: response,
                  attachmentBuilder: _attachments,
                ),
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
              if (item.statusHistory.isNotEmpty)
                CaseSurface(
                  key: _historyKey,
                  padding: EdgeInsets.zero,
                  child: ExpansionTile(
                    onExpansionChanged: _onHistoryExpansionChanged,
                    expansionAnimationStyle: const AnimationStyle(
                      duration: _historyExpansionDuration,
                    ),
                    tilePadding: const EdgeInsets.symmetric(horizontal: 14),
                    backgroundColor: Colors.transparent,
                    collapsedBackgroundColor: Colors.transparent,
                    shape: const Border(),
                    collapsedShape: const Border(),
                    iconColor: AppColors.inkMuted,
                    collapsedIconColor: AppColors.inkMuted,
                    leading: const Icon(
                      Icons.history_rounded,
                      size: 20,
                      color: AppColors.inkMuted,
                    ),
                    title: const Text(
                      'Lịch sử trạng thái',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.inkSoft,
                      ),
                    ),
                    children: [
                      for (final event in item.statusHistory)
                        ListTile(
                          dense: true,
                          title: Text(
                            _statusLabel(event['toStatus']),
                            style: const TextStyle(fontSize: 12),
                          ),
                          subtitle: Text(
                            event['reason'] as String? ?? '',
                            style: const TextStyle(fontSize: 11),
                          ),
                        ),
                    ],
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

  Widget _composer(DiseaseCase item, bool busy, bool sending) => Container(
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
            children: [
              Expanded(
                child: DropdownButtonFormField<CaseResponseType>(
                  key: ValueKey(_type),
                  initialValue: _type,
                  isExpanded: true,
                  decoration: caseInput('').copyWith(
                    fillColor: const Color(0xFFF0F3F8),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 7,
                    ),
                  ),
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.inkSoft,
                  ),
                  items: [
                    for (final type in CaseResponseType.technicianTypes.where(
                      (v) => v != CaseResponseType.emergencyAlert,
                    ))
                      DropdownMenuItem(
                        value: type,
                        child: Text(
                          type.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                  onChanged: busy
                      ? null
                      : (value) => setState(() => _type = value!),
                ),
              ),
              const SizedBox(width: 10),
              Tooltip(
                message: 'Gửi cảnh báo khẩn cho chuyên gia',
                child: OutlinedButton.icon(
                  key: const ValueKey('case-emergency-alert'),
                  onPressed: busy ? null : _emergency,
                  icon: const Icon(Icons.warning_amber_rounded, size: 17),
                  label: const Text(
                    'Báo khẩn',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
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
          const SizedBox(height: 10),
          TextFormField(
            controller: _message,
            enabled: !busy,
            minLines: 2,
            maxLines: 3,
            textCapitalization: TextCapitalization.sentences,
            keyboardType: TextInputType.multiline,
            style: const TextStyle(fontSize: 14, height: 1.5),
            decoration:
                caseInput(switch (_type) {
                  CaseResponseType.monitoringResult =>
                    'Ghi nhận diễn biến và kết quả theo dõi…',
                  CaseResponseType.treatmentResult =>
                    'Ghi nhận đáp ứng và diễn biến điều trị…',
                  _ => 'Nhập thông tin cần gửi cho chuyên gia…',
                }).copyWith(
                  hintStyle: const TextStyle(
                    fontSize: 13,
                    height: 1.5,
                    color: AppColors.inkMuted,
                  ),
                  fillColor: const Color(0xFFF8FAFC),
                  contentPadding: const EdgeInsets.all(12),
                ),
            validator: (value) =>
                DiseaseCaseRules.textError(value, DiseaseCaseRules.textLimit),
          ),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: CaseEvidencePicker(
                  compact: true,
                  urls: _evidence,
                  disabled: busy && !_uploading,
                  onChanged: (urls) => setState(() => _evidence = urls),
                  onBusyChanged: (value) => setState(() => _uploading = value),
                ),
              ),
              const SizedBox(width: 10),
              Tooltip(
                message: 'Gửi phản hồi',
                child: SizedBox(
                  height: 44,
                  child: FilledButton.icon(
                    key: const ValueKey('case-send-response'),
                    onPressed: busy ? null : () => _respond(item),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.ocean,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
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
                    label: const Text(
                      'Gửi',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

class _CaseSnapshot extends StatelessWidget {
  const _CaseSnapshot({required this.snapshot});
  final Map<String, dynamic> snapshot;
  @override
  Widget build(BuildContext context) {
    final health = snapshot['healthStatus'];
    final metrics = [
      ('Cỡ TB', 'avgWeightG', 'g/con'),
      ('Hao hụt', 'mortalityCount', 'con'),
      ('Sinh khối', 'estimatedBiomassKg', 'kg'),
      ('pH', 'ph', ''),
      ('DO', 'doMgL', 'mg/L'),
      ('NH3', 'nh3MgL', 'mg/L'),
      ('NO2', 'no2MgL', 'mg/L'),
    ];
    return CaseSurface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Dữ liệu lúc mở ca',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                  ),
                ),
              ),
              if (health is String)
                CaseBadge(
                  switch (health) {
                    'WARNING' => 'Cần chú ý',
                    'CRITICAL' => 'Nguy cấp',
                    'GOOD' => 'Ổn định',
                    _ => 'Theo nhật ký',
                  },
                  color: health == 'GOOD' ? const Color(0xFF0F9B8E) : caseRose,
                  background: health == 'GOOD'
                      ? const Color(0xFFE2F6F3)
                      : const Color(0xFFFBE6EA),
                ),
            ],
          ),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) {
              final width = (constraints.maxWidth - 18) / 4;
              return Wrap(
                spacing: 6,
                runSpacing: 7,
                children: [
                  for (final (label, field, unit) in metrics)
                    Container(
                      width: width,
                      constraints: const BoxConstraints(minHeight: 70),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F3F8),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            label,
                            style: const TextStyle(
                              fontSize: 9,
                              color: AppColors.inkMuted,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            snapshot[field]?.toString() ?? '—',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.mono(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.ink,
                            ),
                          ),
                          if (unit.isNotEmpty)
                            Text(
                              unit,
                              style: const TextStyle(
                                fontSize: 8,
                                color: AppColors.inkMuted,
                              ),
                            ),
                        ],
                      ),
                    ),
                ],
              );
            },
          ),
          if (!metrics.any((m) => snapshot[m.$2] != null))
            const Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text(
                'Hồ sơ chưa có số liệu được lưu tại thời điểm mở ca.',
                style: TextStyle(fontSize: 10, color: AppColors.inkMuted),
              ),
            ),
          for (final (field, label) in [
            ('healthRecordedAt', 'Nhật ký sức khỏe'),
            ('waterRecordedAt', 'Nhật ký nước'),
          ])
            if (DateTime.tryParse('${snapshot[field]}') case final DateTime at)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  '$label: ${caseDate(at)}',
                  style: const TextStyle(
                    fontSize: 9,
                    color: AppColors.inkMuted,
                  ),
                ),
              ),
        ],
      ),
    );
  }
}

class _ResponseBubble extends StatelessWidget {
  const _ResponseBubble({
    required this.response,
    required this.attachmentBuilder,
  });
  final CaseResponse response;
  final Widget Function(List<String>) attachmentBuilder;
  @override
  Widget build(BuildContext context) {
    final mine = CaseResponseType.technicianTypes.contains(
      response.responseType,
    );
    final author = response.author?['fullName'];
    final type = response.responseType;
    final color = type == CaseResponseType.emergencyAlert
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
              color: mine ? const Color(0xFFE5F2FF) : Colors.white,
              borderRadius: BorderRadius.circular(17),
              border: Border.all(
                color: mine ? const Color(0xFFCDE5FB) : AppColors.line,
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
                      type.label,
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
                  attachmentBuilder(response.attachments),
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
        Navigator.pop(context, true);
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

String _statusLabel(Object? value) => switch (value) {
  'OPEN' => DiseaseCaseStatus.open.label,
  'WAITING_FOR_INFO' => DiseaseCaseStatus.waitingForInfo.label,
  'MONITORING' => DiseaseCaseStatus.monitoring.label,
  'IN_TREATMENT' => DiseaseCaseStatus.inTreatment.label,
  'RESOLVED' => DiseaseCaseStatus.resolved.label,
  _ => DiseaseCaseStatus.unknown.label,
};
