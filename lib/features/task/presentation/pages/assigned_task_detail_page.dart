import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/widgets/app_notice.dart';
import 'package:smartshrimp_app/core/widgets/app_dialog.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/widgets/app_svg_icon.dart';
import 'package:smartshrimp_app/core/widgets/gradient_button.dart';
import 'package:smartshrimp_app/features/task/domain/entities/task_models.dart';
import 'package:smartshrimp_app/features/task/domain/task_rules.dart';
import 'package:smartshrimp_app/features/task/presentation/view_models/assigned_task_controller.dart';
import 'package:smartshrimp_app/features/task/presentation/widgets/task_detail_view.dart';
import 'package:smartshrimp_app/features/task/presentation/widgets/task_evidence_panel.dart';
import 'package:smartshrimp_app/features/task/presentation/widgets/task_ui.dart';

class AssignedTaskDetailPage extends ConsumerStatefulWidget {
  const AssignedTaskDetailPage({required this.taskId, super.key});
  final String taskId;

  @override
  ConsumerState<AssignedTaskDetailPage> createState() =>
      _AssignedTaskDetailPageState();
}

class _AssignedTaskDetailPageState
    extends ConsumerState<AssignedTaskDetailPage> {
  List<String> _evidenceUrls = [];
  bool _picking = false;
  bool _confirming = false;
  int _generation = 0;

  @override
  void didUpdateWidget(covariant AssignedTaskDetailPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.taskId != widget.taskId) {
      _generation++;
      _evidenceUrls = [];
      _picking = false;
      _confirming = false;
    }
  }

  Future<void> _pick(ImageSource source) async {
    if (_picking ||
        _confirming ||
        ref.read(assignedTaskMutationProvider).isLoading ||
        _evidenceUrls.length >= TaskRules.maxEvidenceImages) {
      return;
    }
    final generation = _generation;
    final picker = ref.read(taskImagePickerProvider);
    setState(() => _picking = true);
    try {
      final file = await picker.pickImage(
        source: source,
        requestFullMetadata: false,
      );
      if (file == null || !mounted || generation != _generation) return;
      if (await file.length() > TaskRules.maxEvidenceImageBytes) {
        throw const ApiException('Ảnh minh chứng tối đa 5 MB.');
      }
      final bytes = await file.readAsBytes();
      TaskRules.validateEvidenceImage(bytes);
      if (!mounted || generation != _generation) return;
      final url = await ref
          .read(assignedTaskMutationProvider.notifier)
          .uploadEvidence(bytes, file.name);
      if (!mounted || generation != _generation) return;
      final urls = [..._evidenceUrls, url];
      TaskRules.validateEvidenceUrls(urls);
      setState(() => _evidenceUrls = urls);
    } on PlatformException catch (error) {
      if (mounted && generation == _generation) {
        AppNoticeService.danger(context, switch (error.code) {
          'camera_access_denied' || 'camera_access_restricted' =>
            'Vui lòng cho phép truy cập camera trong cài đặt thiết bị.',
          'photo_access_denied' || 'photo_access_restricted' =>
            'Vui lòng cho phép truy cập thư viện ảnh trong cài đặt thiết bị.',
          _ => 'Không thể mở camera hoặc thư viện ảnh. Vui lòng thử lại.',
        });
      }
    } catch (error) {
      if (mounted && generation == _generation) {
        AppNoticeService.danger(
          context,
          error is AppException
              ? error.message
              : 'Không thể tải ảnh minh chứng. Vui lòng thử lại.',
        );
      }
    } finally {
      if (mounted && generation == _generation) {
        setState(() => _picking = false);
      }
    }
  }

  Future<void> _advance(TaskItem task) async {
    if (_picking ||
        _confirming ||
        ref.read(assignedTaskMutationProvider).isLoading) {
      return;
    }
    final generation = _generation;
    if (task.status == TaskStatus.inProgress) {
      setState(() => _confirming = true);
      final confirmed = await showDialog<bool>(
        context: context,
        useRootNavigator: false,
        builder: (dialogContext) => AppConfirmDialog(
          title: 'Xác nhận hoàn thành nhiệm vụ',
          description: _evidenceUrls.isEmpty
              ? 'Hoàn thành nhiệm vụ không kèm ảnh minh chứng?'
              : 'Hoàn thành nhiệm vụ với ${_evidenceUrls.length} ảnh minh chứng?',
          confirmLabel: 'Xác nhận',
          level: AppNoticeLevel.info,
          onConfirm: () => Navigator.pop(dialogContext, true),
        ),
      );
      if (!mounted || generation != _generation) return;
      setState(() => _confirming = false);
      if (confirmed != true) return;
    }
    try {
      await ref
          .read(assignedTaskMutationProvider.notifier)
          .advance(
            task,
            evidenceUrls: task.status == TaskStatus.inProgress
                ? List.of(_evidenceUrls)
                : const [],
          );
      if (mounted && generation == _generation) {
        setState(() => _evidenceUrls = []);
        AppNoticeService.success(
          context,
          task.status == TaskStatus.pending
              ? 'Đã bắt đầu nhiệm vụ và ghi nhận thời gian.'
              : 'Đã hoàn thành nhiệm vụ và ghi nhận thời gian.',
        );
      }
    } catch (error) {
      if (mounted && generation == _generation) {
        AppNoticeService.danger(context, taskError(error));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = assignedTaskDetailProvider(widget.taskId);
    final detail = ref.watch(provider);
    final mutating = ref.watch(assignedTaskMutationProvider).isLoading;
    final busy = mutating || _picking || _confirming;
    return TaskDetailView(
      detail: detail,
      onBack: () => context.canPop() ? context.pop() : context.go('/tasks'),
      onRetry: () => ref.invalidate(provider),
      onRefresh: () async {
        ref.invalidate(provider);
        await ref.read(provider.future);
      },
      actions: (task) => [
        if (task.status == TaskStatus.inProgress ||
            task.status == TaskStatus.completed ||
            task.evidenceUrls.isNotEmpty) ...[
          const SizedBox(height: 10),
          TaskEvidencePanel(
            urls: task.status == TaskStatus.inProgress
                ? _evidenceUrls
                : task.evidenceUrls,
            status: task.status,
            busy: busy,
            uploading: _picking,
            onCamera: task.status == TaskStatus.inProgress
                ? () => _pick(ImageSource.camera)
                : null,
            onLibrary: task.status == TaskStatus.inProgress
                ? () => _pick(ImageSource.gallery)
                : null,
            onRemove: task.status == TaskStatus.inProgress
                ? (index) => setState(() => _evidenceUrls.removeAt(index))
                : null,
          ),
        ],
        if (task.canEdit) ...[
          const SizedBox(height: 10),
          GradientButton(
            label: task.status == TaskStatus.pending
                ? 'Bắt đầu làm'
                : 'Đánh dấu hoàn thành',
            onPressed: busy ? null : () => _advance(task),
            isLoading: mutating,
            compact: true,
            height: 45,
            borderRadius: 12,
            boxShadow: const [
              BoxShadow(
                color: Color(0x1A000000),
                offset: Offset(0, 1),
                blurRadius: 1.5,
              ),
              BoxShadow(
                color: Color(0x1A000000),
                offset: Offset(0, 1),
                blurRadius: 1,
              ),
            ],
            leading: AppSvgIcon(
              task.status == TaskStatus.pending
                  ? AppSvgIconName.sparkles
                  : AppSvgIconName.checkMark,
              size: 18,
              color: Colors.white,
            ),
          ),
        ],
        if (task.season != null) ...[
          const SizedBox(height: 10),
          Tooltip(
            message: task.canOpenRelatedSeason
                ? 'Mở ao liên quan'
                : 'Bạn không còn được phân công vào vụ nuôi này',
            child: OutlinedButton(
              onPressed: task.canOpenRelatedSeason
                  ? () => context.push('/seasons/${task.season!.id}')
                  : null,
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.inkSoft,
                textStyle: const TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  letterSpacing: 0,
                ),
                side: const BorderSide(color: AppColors.line, width: .8),
                minimumSize: const Size.fromHeight(47),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppSvgIcon(
                    AppSvgIconName.pin,
                    size: 18,
                    color: task.canOpenRelatedSeason
                        ? AppColors.inkSoft
                        : AppColors.inkMuted,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Mở ao liên quan',
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}
