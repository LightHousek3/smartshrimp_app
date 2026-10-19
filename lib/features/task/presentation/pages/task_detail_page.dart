import 'package:smartshrimp_app/core/widgets/app_form_field.dart';
import 'package:smartshrimp_app/core/widgets/app_svg_icon.dart';
import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/widgets/app_circle_button.dart';
import 'package:smartshrimp_app/core/widgets/app_gradient_background.dart';
import 'package:smartshrimp_app/core/widgets/app_notice.dart';
import 'package:smartshrimp_app/features/task/domain/entities/task_models.dart';
import 'package:smartshrimp_app/features/task/domain/task_rules.dart';
import 'package:smartshrimp_app/features/task/presentation/view_models/task_controller.dart';
import 'package:smartshrimp_app/features/task/presentation/widgets/task_ui.dart';

class TaskDetailPage extends ConsumerStatefulWidget {
  const TaskDetailPage({required this.taskId, super.key});
  final String taskId;
  @override
  ConsumerState<TaskDetailPage> createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends ConsumerState<TaskDetailPage> {
  Timer? _clock;
  @override
  void initState() {
    super.initState();
    _clock = Timer.periodic(const Duration(minutes: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _clock?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final detail = ref.watch(taskDetailProvider(widget.taskId));
    return AppGradientBackground(
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            TaskHeader(
              title: 'Chi tiết nhiệm vụ',
              onBack: () =>
                  context.canPop() ? context.pop() : context.go('/tasks'),
              trailing: detail.value?.canEdit == true
                  ? AppCircleButton(
                      icon: Icons.edit_outlined,
                      tooltip: 'Chỉnh sửa nhiệm vụ',
                      size: 36,
                      backgroundColor: taskGray,
                      iconWidget: const Center(
                        child: AppSvgIcon(
                          AppSvgIconName.edit,
                          size: 17,
                          color: AppColors.inkSoft,
                        ),
                      ),
                      onPressed: () async {
                        final saved = await context.push<bool>(
                          '/tasks/${widget.taskId}/edit',
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
            ),
            Expanded(
              child: detail.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => TaskLoadError(
                  e,
                  () => ref.invalidate(taskDetailProvider(widget.taskId)),
                ),
                data: (task) => RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(taskDetailProvider(widget.taskId));
                    await ref.read(taskDetailProvider(widget.taskId).future);
                  },
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      TaskPanel(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              task.title,
                              style: const TextStyle(
                                color: AppColors.ink,
                                fontSize: 16,
                                height: 1.5,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 12),
                            TaskBadges(task, detail: true, now: DateTime.now()),
                            if (task.description?.isNotEmpty == true) ...[
                              const SizedBox(height: 12),
                              Text(
                                task.description!,
                                style: const TextStyle(
                                  fontSize: 13,
                                  height: 1.625,
                                  color: AppColors.inkSoft,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      TaskPanel(
                        child: Column(
                          children: [
                            _DetailRow(
                              'Giao cho',
                              task.assignee.name,
                              AppSvgIconName.account,
                              taskBlue,
                            ),
                            const SizedBox(height: 10),
                            _DetailRow(
                              'Hạn hoàn thành',
                              taskDate(task.dueAt),
                              AppSvgIconName.clock,
                              taskAmber,
                              color: task.overdueAt(DateTime.now())
                                  ? const Color(0xFFF00046)
                                  : AppColors.ink,
                            ),
                            if (task.season != null) ...[
                              const SizedBox(height: 10),
                              _DetailRow(
                                'Vụ nuôi liên quan',
                                task.season!.name,
                                AppSvgIconName.shrimp,
                                taskBlue,
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (task.canEdit)
                        OutlinedButton(
                          onPressed: () async {
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
                              AppNoticeService.success(
                                context,
                                'Hủy nhiệm vụ thành công.',
                              );
                            }
                          },
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppColors.inkSoft,
                            minimumSize: const Size.fromHeight(47),
                            side: const BorderSide(
                              color: AppColors.line,
                              width: 1.2,
                            ),
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
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (task.status == TaskStatus.cancelled)
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: taskRed,
                            border: Border.all(color: const Color(0xFFFFC9D1)),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Lý do hủy: ${task.cancellationReason ?? 'Không có thông tin'}',
                                style: const TextStyle(
                                  color: Color(0xFFF00046),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              if (task.cancelledBy != null ||
                                  task.cancelledAt != null) ...[
                                const SizedBox(height: 6),
                                Text(
                                  [
                                    if (task.cancelledBy != null)
                                      task.cancelledBy!.name,
                                    if (task.cancelledAt != null)
                                      taskDate(task.cancelledAt),
                                  ].join(' · '),
                                  style: const TextStyle(
                                    color: AppColors.error,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow(
    this.label,
    this.value,
    this.asset,
    this.background, {
    this.color = AppColors.ink,
  });
  final String label, value;
  final AppSvgIconName asset;
  final Color background, color;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Container(
        width: 32,
        height: 32,
        alignment: Alignment.center,
        decoration: BoxDecoration(color: background, shape: BoxShape.circle),
        child: AppSvgIcon(
          asset,
          size: 15,
          color: background == taskAmber
              ? const Color(0xFFD98314)
              : AppColors.ocean,
        ),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                color: AppColors.inkMuted,
                height: 1.5,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: color,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    ],
  );
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
                              ? 'KTV đã bắt đầu thực hiện. Hủy lúc này sẽ dừng công việc nhưng vẫn giữ thời điểm bắt đầu và lý do để đối soát.'
                              : 'Nhiệm vụ chưa bắt đầu. Sau khi hủy, nhiệm vụ được giữ lại trong lịch sử để đối soát.',
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
