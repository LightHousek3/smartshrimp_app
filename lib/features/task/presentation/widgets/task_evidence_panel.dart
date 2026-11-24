import 'package:flutter/material.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/widgets/app_svg_icon.dart';
import 'package:smartshrimp_app/core/widgets/app_image_viewer.dart';
import 'package:smartshrimp_app/features/task/domain/entities/task_models.dart';
import 'package:smartshrimp_app/features/task/domain/task_rules.dart';
import 'task_ui.dart';

/// The same gallery renders draft evidence for the assignee and saved evidence for both roles.
class TaskEvidencePanel extends StatelessWidget {
  const TaskEvidencePanel({
    required this.urls,
    required this.status,
    this.onAdd,
    this.onRemove,
    this.busy = false,
    this.uploading = false,
    super.key,
  });
  final List<String> urls;
  final TaskStatus status;
  final VoidCallback? onAdd;
  final ValueChanged<int>? onRemove;
  final bool busy;
  final bool uploading;

  @override
  Widget build(BuildContext context) {
    final editable = onRemove != null;
    final canAdd = !busy && urls.length < TaskRules.maxEvidenceImages;
    return TaskDetailPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Ảnh minh chứng',
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: taskGray,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${urls.length}/${TaskRules.maxEvidenceImages} ảnh',
                  style: const TextStyle(
                    fontSize: 12,
                    height: 1.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.inkMuted,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (urls.isEmpty)
            CustomPaint(
              foregroundPainter: const TaskDashedBorder(
                radius: 8,
                strokeWidth: 8 / 9,
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F6F9),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.transparent, width: 8 / 9),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Chưa có ảnh minh chứng',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.inkSoft,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      status == TaskStatus.completed
                          ? 'Nhiệm vụ đã hoàn thành không kèm ảnh minh chứng.'
                          : editable
                          ? 'Có thể thêm ảnh trước khi xác nhận hoàn thành.'
                          : 'Ảnh do Kỹ thuật viên tải lên sẽ xuất hiện tại đây.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 12,
                        height: 1.5,
                        color: AppColors.inkMuted,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            LayoutBuilder(
              builder: (context, constraints) {
                final width = (constraints.maxWidth - 16) / 3;
                return Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (var index = 0; index < urls.length; index++)
                      SizedBox.square(
                        dimension: width,
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: Material(
                                color: taskGray,
                                clipBehavior: Clip.antiAlias,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side: const BorderSide(color: AppColors.line),
                                ),
                                child: InkWell(
                                  onTap: () => _preview(context, index),
                                  child: Semantics(
                                    button: true,
                                    label: 'Xem ảnh minh chứng ${index + 1}',
                                    child: Stack(
                                      fit: StackFit.expand,
                                      children: [
                                        _EvidenceImage(urls[index]),
                                        Positioned(
                                          left: 0,
                                          right: 0,
                                          bottom: 0,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 6,
                                              vertical: 4,
                                            ),
                                            color: const Color(0x73000000),
                                            child: Text(
                                              'Minh chứng ${index + 1}',
                                              style: const TextStyle(
                                                fontSize: 11,
                                                height: 1.5,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            if (editable)
                              Positioned(
                                top: 4,
                                right: 4,
                                child: SizedBox.square(
                                  dimension: 28,
                                  child: IconButton(
                                    tooltip: 'Bỏ ảnh minh chứng ${index + 1}',
                                    padding: EdgeInsets.zero,
                                    style: IconButton.styleFrom(
                                      backgroundColor: const Color(0xBF0F1C2E),
                                    ),
                                    onPressed: busy
                                        ? null
                                        : () => onRemove!(index),
                                    icon: const AppSvgIcon(
                                      AppSvgIconName.closeSmall,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                  ],
                );
              },
            ),
          if (editable) ...[
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: canAdd ? onAdd : null,
              icon: const Icon(Icons.add_photo_alternate_outlined, size: 20),
              label: const Text('Thêm ảnh'),
              style: FilledButton.styleFrom(
                backgroundColor: taskBlue,
                foregroundColor: AppColors.ocean,
                minimumSize: const Size.fromHeight(44),
                textStyle: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            if (uploading) ...[
              const SizedBox(height: 8),
              const LinearProgressIndicator(),
              const SizedBox(height: 4),
              const Text(
                'Đang tải ảnh minh chứng…',
                style: TextStyle(fontSize: 12, color: AppColors.inkMuted),
              ),
            ],
            const SizedBox(height: 8),
            const Text(
              'Tối đa 5 ảnh · JPG, PNG, WebP · 5 MB/ảnh. Có thể hoàn thành mà không kèm ảnh minh chứng.',
              style: TextStyle(
                fontSize: 11,
                height: 1.625,
                color: AppColors.inkMuted,
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _preview(BuildContext context, int index) {
    final images = List<String>.unmodifiable(urls);
    showAppImageViewer(
      context,
      builder: (_) => AppImageViewer(
        itemCount: images.length,
        initialIndex: index,
        imageBuilder: (i, fit) => _EvidenceImage(images[i], fit: fit),
      ),
    );
  }
}

class _EvidenceImage extends StatefulWidget {
  const _EvidenceImage(this.url, {this.fit = BoxFit.cover});
  final String url;
  final BoxFit fit;
  @override
  State<_EvidenceImage> createState() => _EvidenceImageState();
}

class _EvidenceImageState extends State<_EvidenceImage> {
  int _retryCount = 0;

  @override
  Widget build(BuildContext context) {
    final image = ResizeImage.resizeIfNeeded(
      widget.fit == BoxFit.cover ? 600 : 2048,
      null,
      NetworkImage(widget.url),
    );
    return Image(
      key: ValueKey(_retryCount),
      image: image,
      fit: widget.fit,
      loadingBuilder: (_, child, progress) => progress == null
          ? child
          : const Center(child: CircularProgressIndicator(strokeWidth: 2)),
      errorBuilder: (_, _, _) => widget.fit == BoxFit.cover
          ? const ColoredBox(
              color: taskGray,
              child: Center(child: AppSvgIcon(AppSvgIconName.camera, size: 24)),
            )
          : Center(
              child: TextButton(
                onPressed: () async {
                  await image.evict();
                  if (mounted) setState(() => _retryCount++);
                },
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppSvgIcon(AppSvgIconName.camera, size: 20),
                    SizedBox(height: 4),
                    Text(
                      'Tải lại ảnh',
                      style: TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
