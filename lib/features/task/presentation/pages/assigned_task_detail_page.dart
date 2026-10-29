import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/widgets/app_notice.dart';
import 'package:smartshrimp_app/core/widgets/app_svg_icon.dart';
import 'package:smartshrimp_app/core/widgets/gradient_button.dart';
import 'package:smartshrimp_app/features/task/domain/entities/task_models.dart';
import 'package:smartshrimp_app/features/task/presentation/view_models/assigned_task_controller.dart';
import 'package:smartshrimp_app/features/task/presentation/widgets/task_detail_view.dart';
import 'package:smartshrimp_app/features/task/presentation/widgets/task_ui.dart';

class AssignedTaskDetailPage extends ConsumerWidget {
  const AssignedTaskDetailPage({required this.taskId, super.key});
  final String taskId;

  Future<void> _advance(
    BuildContext context,
    WidgetRef ref,
    TaskItem task,
  ) async {
    try {
      await ref.read(assignedTaskMutationProvider.notifier).advance(task);
      if (context.mounted) {
        AppNoticeService.success(
          context,
          task.status == TaskStatus.pending
              ? 'Đã bắt đầu nhiệm vụ và ghi nhận thời gian.'
              : 'Đã hoàn thành nhiệm vụ và ghi nhận thời gian.',
        );
      }
    } catch (error) {
      if (context.mounted) AppNoticeService.danger(context, taskError(error));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = assignedTaskDetailProvider(taskId);
    final detail = ref.watch(provider);
    final busy = ref.watch(assignedTaskMutationProvider).isLoading;
    return TaskDetailView(
      detail: detail,
      onBack: () => context.canPop() ? context.pop() : context.go('/tasks'),
      onRetry: () => ref.invalidate(provider),
      onRefresh: () async {
        ref.invalidate(provider);
        await ref.read(provider.future);
      },
      actions: (task) => [
        if (task.canEdit) ...[
          const SizedBox(height: 16),
          GradientButton(
            label: task.status == TaskStatus.pending
                ? 'Bắt đầu làm'
                : 'Đánh dấu hoàn thành',
            onPressed: busy ? null : () => _advance(context, ref, task),
            isLoading: busy,
            compact: true,
            height: 45,
            borderRadius: 12,
            leading: AppSvgIcon(
              task.status == TaskStatus.pending
                  ? AppSvgIconName.sparkles
                  : AppSvgIconName.check,
              size: 18,
              color: Colors.white,
            ),
          ),
        ],
        if (task.season != null) ...[
          const SizedBox(height: 16),
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
