import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/widgets/app_notice.dart';
import 'package:smartshrimp_app/core/widgets/app_form_field.dart';
import '../../domain/domain.dart';
import '../view_models/disease_case_controller.dart';
import '../widgets/case_ui.dart';
import '../widgets/case_evidence_picker.dart';

class DiseaseCaseFormPage extends ConsumerStatefulWidget {
  const DiseaseCaseFormPage({super.key, required this.seasonId});
  final String seasonId;
  @override
  ConsumerState<DiseaseCaseFormPage> createState() =>
      _DiseaseCaseFormPageState();
}

class _DiseaseCaseFormPageState extends ConsumerState<DiseaseCaseFormPage> {
  final _form = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _description = TextEditingController();
  CaseSeverity _severity = CaseSeverity.medium;
  List<String> _evidence = [];
  bool _uploading = false;
  String? _aiDiagnosisId;
  String? _relatedCaseId;
  bool _showAllAi = false;
  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_form.currentState?.validate() ?? false)) return;
    try {
      final item = await ref
          .read(diseaseCaseMutationProvider.notifier)
          .create(
            widget.seasonId,
            _title.text,
            _description.text,
            _severity,
            attachments: _evidence,
            aiDiagnosisId: _aiDiagnosisId,
            relatedCaseId: _relatedCaseId,
          );
      if (mounted) {
        context.pushReplacement(
          '/seasons/${widget.seasonId}/disease-cases/${item.id}',
        );
      }
    } catch (error) {
      if (mounted) {
        AppNoticeService.danger(context, caseError(error));
      }
    }
  }

  Future<void> _openAi({String? diagnosisId}) async {
    final path = '/seasons/${widget.seasonId}/ai-diagnoses';
    await context.push(diagnosisId == null ? path : '$path/$diagnosisId');
    if (mounted) ref.invalidate(caseCreationOptionsProvider(widget.seasonId));
  }

  @override
  Widget build(BuildContext context) {
    final busy = ref.watch(diseaseCaseMutationProvider).isLoading || _uploading;
    final contextData =
        ref
            .watch(
              diseaseCaseListProvider((
                seasonId: widget.seasonId,
                page: 1,
                status: null,
                resolved: false,
              )),
            )
            .value
            ?.season ??
        {};
    return CaseFrame(
      title: 'Tạo ca bệnh',
      subtitle: caseContext(contextData),
      child: Form(
        key: _form,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: ListView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            CaseSurface(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CaseField(
                    'Ca bệnh *',
                    child: TextFormField(
                      controller: _title,
                      enabled: !busy,
                      textInputAction: TextInputAction.next,
                      textCapitalization: TextCapitalization.sentences,
                      style: AppFormMetrics.inputStyle,
                      decoration: AppFormMetrics.decoration(
                        InputDecoration(
                          hintText:
                              'VD: Tôm giảm ăn — ${contextData['pondName'] ?? 'tên ao'}',
                        ),
                      ),
                      validator: (v) => DiseaseCaseRules.textError(
                        v,
                        DiseaseCaseRules.titleLimit,
                      ),
                    ),
                  ),
                  CaseField(
                    'Mức độ nghiêm trọng',
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final columns = constraints.maxWidth < 300 ? 2 : 4;
                        return Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            for (final severity in CaseSeverity.values.where(
                              (v) => v != CaseSeverity.unknown,
                            ))
                              SizedBox(
                                width:
                                    (constraints.maxWidth - 8 * (columns - 1)) /
                                    columns,
                                child: Semantics(
                                  selected: _severity == severity,
                                  child: OutlinedButton(
                                    onPressed: busy
                                        ? null
                                        : () => setState(
                                            () => _severity = severity,
                                          ),
                                    style: OutlinedButton.styleFrom(
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 2,
                                      ),
                                      minimumSize: const Size(0, 44),
                                      backgroundColor: _severity == severity
                                          ? _severityColor(
                                              severity,
                                            ).withValues(alpha: .09)
                                          : Colors.white,
                                      foregroundColor: _severity == severity
                                          ? _severityColor(severity)
                                          : AppColors.inkSoft,
                                      side: BorderSide(
                                        color: _severity == severity
                                            ? _severityColor(severity)
                                            : AppColors.line,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(11),
                                      ),
                                    ),
                                    child: Text(
                                      severity.label,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                  CaseField(
                    'Mô tả dấu hiệu *',
                    child: TextFormField(
                      controller: _description,
                      enabled: !busy,
                      minLines: 4,
                      maxLines: 7,
                      textCapitalization: TextCapitalization.sentences,
                      style: AppFormMetrics.inputStyle,
                      decoration: AppFormMetrics.decoration(
                        const InputDecoration(
                          hintText:
                              'Quan sát sức ăn, màu sắc, phân, vỏ và thời điểm xuất hiện…',
                        ),
                      ),
                      validator: (v) => DiseaseCaseRules.textError(
                        v,
                        DiseaseCaseRules.textLimit,
                      ),
                    ),
                  ),
                  CaseField(
                    'Ảnh minh chứng (tùy chọn)',
                    bottomGap: 0,
                    child: CaseEvidencePicker(
                      urls: _evidence,
                      disabled: ref
                          .watch(diseaseCaseMutationProvider)
                          .isLoading,
                      onChanged: (urls) => setState(() => _evidence = urls),
                      onBusyChanged: (value) =>
                          setState(() => _uploading = value),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            CaseSurface(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.auto_awesome_outlined,
                        size: 20,
                        color: caseViolet,
                      ),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'Liên kết kết quả AI (tùy chọn)',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.ink,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Chọn tối đa một kết quả để chuyên gia tham khảo. Bạn có thể gửi ca bệnh khi chưa có kết quả AI.',
                    style: TextStyle(
                      fontSize: 12,
                      height: 1.5,
                      color: AppColors.inkMuted,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ref
                      .watch(caseCreationOptionsProvider(widget.seasonId))
                      .when(
                        loading: () =>
                            const LinearProgressIndicator(minHeight: 2),
                        error: (_, _) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Chưa tải được thông tin liên kết.',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.inkMuted,
                              ),
                            ),
                            TextButton.icon(
                              onPressed: () => ref.invalidate(
                                caseCreationOptionsProvider(widget.seasonId),
                              ),
                              icon: const Icon(Icons.refresh, size: 16),
                              label: const Text(
                                'Thử lại',
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                        data: (options) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (options.aiDiagnoses.isEmpty)
                              const Text(
                                'Chưa có kết quả AI trong vụ này.',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.inkSoft,
                                ),
                              ),
                            if (options.aiDiagnoses.isNotEmpty) ...[
                              for (final ai in options.aiDiagnoses.take(
                                _showAllAi ? options.aiDiagnoses.length : 3,
                              ))
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: _AiOption(
                                    ai: ai,
                                    selected: _aiDiagnosisId == ai['id'],
                                    onView: busy
                                        ? null
                                        : () => _openAi(
                                            diagnosisId: ai['id'] as String,
                                          ),
                                    onTap: busy
                                        ? null
                                        : () => setState(
                                            () => _aiDiagnosisId =
                                                _aiDiagnosisId == ai['id']
                                                ? null
                                                : ai['id'] as String,
                                          ),
                                  ),
                                ),
                              if (options.aiDiagnoses.length > 3)
                                TextButton(
                                  onPressed: () =>
                                      setState(() => _showAllAi = !_showAllAi),
                                  child: Text(
                                    _showAllAi
                                        ? 'Thu gọn'
                                        : 'Xem thêm ${options.aiDiagnoses.length - 3} kết quả',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge
                                        ?.copyWith(fontSize: 12),
                                  ),
                                ),
                            ],
                            if (options.relatedCases.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: ExpansionTile(
                                  tilePadding: const EdgeInsets.symmetric(
                                    horizontal: 3,
                                  ),
                                  title: const Text(
                                    'Liên kết ca trước (tùy chọn)',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  children: [
                                    DropdownButtonFormField<String>(
                                      initialValue: _relatedCaseId,
                                      isExpanded: true,
                                      decoration: caseInput(
                                        'Chọn ca đã khép trong vụ',
                                      ),
                                      items: [
                                        const DropdownMenuItem(
                                          value: null,
                                          child: Text(
                                            'Không liên kết ca trước',
                                          ),
                                        ),
                                        for (final old in options.relatedCases)
                                          DropdownMenuItem(
                                            value: old['id'] as String,
                                            child: Text(
                                              old['title'] as String,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                      ],
                                      onChanged: busy
                                          ? null
                                          : (value) => setState(
                                              () => _relatedCaseId = value,
                                            ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      onPressed: busy ? null : () => _openAi(),
                      icon: const Icon(Icons.manage_search_rounded, size: 18),
                      label: Text(
                        'Xem lịch sử AI',
                        style: Theme.of(
                          context,
                        ).textTheme.labelLarge?.copyWith(fontSize: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            CasePrimaryButton(
              label: busy ? 'Đang gửi…' : 'Gửi cho chuyên gia',
              busy: busy,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}

Color _severityColor(CaseSeverity severity) => switch (severity) {
  CaseSeverity.low => const Color(0xFF087C70),
  CaseSeverity.medium => const Color(0xFF9B6500),
  CaseSeverity.high => const Color(0xFFBE5A12),
  CaseSeverity.critical => caseRose,
  _ => AppColors.inkMuted,
};

class _AiOption extends StatelessWidget {
  const _AiOption({
    required this.ai,
    required this.selected,
    required this.onTap,
    required this.onView,
  });
  final Map<String, dynamic> ai;
  final bool selected;
  final VoidCallback? onTap;
  final VoidCallback? onView;
  @override
  Widget build(BuildContext context) {
    final confidence = num.tryParse('${ai['confidence']}');
    final date = DateTime.tryParse('${ai['createdAt']}');
    return Semantics(
      selected: selected,
      child: Material(
        color: selected ? const Color(0xFFEEE8FD) : const Color(0xEEFFFFFF),
        borderRadius: BorderRadius.circular(15),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(15),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: selected ? caseViolet : AppColors.line),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0E9FF),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.auto_awesome,
                    size: 17,
                    color: caseViolet,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        caseAiLabel(ai),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.ink,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '${caseAiConfidence(confidence)}${date == null ? '' : '\n${caseDate(date)}'}',
                        style: const TextStyle(
                          fontSize: 11,
                          height: 1.5,
                          color: AppColors.inkMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Xem chi tiết kết quả AI',
                  onPressed: onView,
                  icon: const Icon(
                    Icons.open_in_new_rounded,
                    size: 18,
                    color: AppColors.inkMuted,
                  ),
                ),
                Icon(
                  selected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_off,
                  color: selected ? caseViolet : AppColors.inkMuted,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
