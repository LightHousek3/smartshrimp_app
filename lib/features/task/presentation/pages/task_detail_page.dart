import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/widgets/app_circle_button.dart';
import 'package:smartshrimp_app/core/widgets/app_form_field.dart';
import 'package:smartshrimp_app/core/widgets/app_notice.dart';
import 'package:smartshrimp_app/core/widgets/app_svg_icon.dart';
import 'package:smartshrimp_app/features/task/domain/entities/task_models.dart';
import 'package:smartshrimp_app/features/task/domain/task_rules.dart';
import 'package:smartshrimp_app/features/task/presentation/view_models/task_controller.dart';
import 'package:smartshrimp_app/features/task/presentation/widgets/task_detail_view.dart';
import 'package:smartshrimp_app/features/task/presentation/widgets/task_ui.dart';

class TaskDetailPage extends ConsumerWidget {
  const TaskDetailPage({required this.taskId, super.key});
  final String taskId;

  Future<void> _cancel(BuildContext context, TaskItem task) async {
    final cancelled = await showDialog<bool>(
      context: context,
      useRootNavigator: false,
      barrierDismissible: false,
      barrierColor: const Color(0x590F1C2E),
      builder: (_) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
        child: _CancelTaskDialog(task),
      ),
    );
    if (context.mounted && cancelled == true) {
      AppNoticeService.success(context, 'Hủy nhiệm vụ thành công.');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = taskDetailProvider(taskId);
    final detail = ref.watch(provider);
    final busy = ref.watch(taskMutationProvider).isLoading;
    return TaskDetailView(
      detail: detail,
      onBack: () => context.canPop() ? context.pop() : context.go('/tasks'),
      onRetry: () => ref.invalidate(provider),
      onRefresh: () async {
        ref.invalidate(provider);
        await ref.read(provider.future);
      },
      trailing: detail.value?.canEdit == true
          ? AppCircleButton(
              icon: Icons.edit_outlined,
              tooltip: 'Chỉnh sửa nhiệm vụ',
              size: 36,
              backgroundColor: taskGray,
              iconWidget: const Center(
                child: AppSvgIcon(
                  AppSvgIconName.edit,
                  size: 18,
                  color: AppColors.inkSoft,
                ),
              ),
              onPressed: busy
                  ? null
                  : () async {
                      final saved = await context.push<bool>(
                        '/tasks/$taskId/edit',
                      );
                      if (context.mounted && saved == true) {
                        AppNoticeService.success(
                          context,
                          'Cập nhật nhiệm vụ thành công.',
                        );
                      }
                    },
            )
          : null,
      actions: (task) => [
        if (task.canEdit) ...[
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: busy ? null : () => _cancel(context, task),
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.inkSoft,
              side: const BorderSide(color: AppColors.line, width: .8),
              minimumSize: const Size.fromHeight(47),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppSvgIcon(
                  AppSvgIconName.close,
                  size: 18,
                  color: AppColors.inkSoft,
                ),
                SizedBox(width: 8),
                Text(
                  'Hủy nhiệm vụ',
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _CancelTaskDialog extends ConsumerStatefulWidget {
  const _CancelTaskDialog(this.task);
  final TaskItem task;
  @override
  ConsumerState<_CancelTaskDialog> createState() => _CancelTaskDialogState();
}

class _CancelTaskDialogState extends ConsumerState<_CancelTaskDialog> {
  final _reason = TextEditingController();
  final _form = GlobalKey<FormState>();
  String? _error;
  @override
  void dispose() {
    _reason.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final busy = ref.watch(taskMutationProvider).isLoading;
    return PopScope(
      canPop: !busy,
      child: Dialog(
        alignment: const Alignment(0, 0.1),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        clipBehavior: Clip.antiAlias,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 380),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _form,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: taskRed,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const AppSvgIcon(
                            AppSvgIconName.close,
                            size: 20,
                            color: AppColors.error,
                          ),
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          'Xác nhận hủy nhiệm vụ',
                          style: TextStyle(
                            color: AppColors.ink,
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.task.status == TaskStatus.inProgress
                              ? 'KTV đã bắt đầu thực hiện. Sau khi hủy, KTV không thể tiếp tục nhiệm vụ.'
                              : 'Nhiệm vụ chưa bắt đầu. Sau khi hủy, nhiệm vụ không thể tiếp tục hoặc chỉnh sửa.',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.inkSoft,
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 18),
                        const Text(
                          'Lý do hủy *',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.inkSoft,
                          ),
                        ),
                        const SizedBox(height: 6),
                        AppTextField(
                          controller: _reason,
                          enabled: !busy,
                          minLines: 3,
                          maxLines: 5,
                          maxLength: TaskRules.cancellationReasonLimit,
                          style: const TextStyle(fontSize: 14, height: 1.3),
                          decoration: InputDecoration(
                            hintText: 'Nhập lý do hủy…',
                            counterText: '',
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 12,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: AppColors.line,
                                width: 1.2,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: AppColors.line,
                                width: 1.2,
                              ),
                            ),
                          ),
                          validator: TaskRules.cancellationReasonError,
                        ),
                        if (_error != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              _error!,
                              style: const TextStyle(
                                color: AppColors.error,
                                fontSize: 12,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(14),
                  color: const Color(0xFFF5F6F9),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: busy
                              ? null
                              : () => Navigator.pop(context, false),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppColors.inkSoft,
                            textStyle: const TextStyle(
                              fontFamily: 'PlusJakartaSans',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                            side: const BorderSide(
                              color: AppColors.line,
                              width: 1.2,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            minimumSize: const Size.fromHeight(47),
                          ),
                          child: const Text('Quay lại'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: FilledButton(
                          onPressed: busy
                              ? null
                              : () async {
                                  if (!_form.currentState!.validate()) return;
                                  setState(() => _error = null);
                                  try {
                                    await ref
                                        .read(taskMutationProvider.notifier)
                                        .cancel(widget.task.id, _reason.text);
                                    if (context.mounted) {
                                      Navigator.pop(context, true);
                                    }
                                  } catch (error) {
                                    if (mounted) {
                                      setState(() => _error = taskError(error));
                                    }
                                  }
                                },
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.error,
                            foregroundColor: Colors.white,
                            textStyle: const TextStyle(
                              fontFamily: 'PlusJakartaSans',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            minimumSize: const Size.fromHeight(47),
                          ),
                          child: busy
                              ? const SizedBox.square(
                                  dimension: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text('Xác nhận hủy'),
                        ),
                      ),
                    ],
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
