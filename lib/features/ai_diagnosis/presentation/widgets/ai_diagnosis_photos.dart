import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import '../../domain/entities/ai_diagnosis_image.dart';
import '../view_models/ai_diagnosis_controller.dart';
import 'ai_diagnosis_ui.dart';

class AiNetworkPhoto extends StatelessWidget {
  const AiNetworkPhoto(
    this.url, {
    this.fit = BoxFit.cover,
    this.onRetry,
    super.key,
  });
  final String url;
  final BoxFit fit;
  final VoidCallback? onRetry;
  @override
  Widget build(BuildContext context) => Image.network(
    url,
    fit: fit,
    cacheWidth: fit == BoxFit.cover ? 600 : 2048,
    loadingBuilder: (_, child, progress) => progress == null
        ? child
        : const Center(child: CircularProgressIndicator(strokeWidth: 2)),
    errorBuilder: (_, _, _) => Center(
      child: TextButton(
        onPressed: onRetry,
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.broken_image_outlined, size: 20),
            SizedBox(height: 4),
            Text(
              'Tải lại ảnh',
              style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 10),
            ),
          ],
        ),
      ),
    ),
  );
}

class AiPhotoGrid extends StatelessWidget {
  const AiPhotoGrid({
    required this.count,
    required this.imageBuilder,
    required this.onView,
    this.onRemove,
    this.onAdd,
    this.busy = false,
    super.key,
  });
  final int count;
  final Widget Function(int index) imageBuilder;
  final ValueChanged<int> onView;
  final ValueChanged<int>? onRemove;
  final VoidCallback? onAdd;
  final bool busy;
  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final width = (constraints.maxWidth - 16) / 3;
      return Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (var i = 0; i < count; i++)
            SizedBox.square(
              dimension: width,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Semantics(
                      button: true,
                      label: 'Xem ảnh ${i + 1}',
                      child: InkWell(
                        onTap: busy ? null : () => onView(i),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: SizedBox.expand(child: imageBuilder(i)),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 6,
                    bottom: 6,
                    child: IgnorePointer(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xA60F1C2E),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'Ảnh ${i + 1}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (onRemove == null)
                    Positioned(
                      top: 6,
                      right: 6,
                      child: IgnorePointer(
                        child: Container(
                          width: 24,
                          height: 24,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.95),
                            shape: BoxShape.circle,
                          ),
                          child: const AiIcon('eye'),
                        ),
                      ),
                    ),
                  if (onRemove != null)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Opacity(
                        opacity: busy ? 0.4 : 1,
                        child: SizedBox.square(
                          dimension: 40,
                          child: IconButton(
                            tooltip: 'Xóa ảnh ${i + 1}',
                            onPressed: busy ? null : () => onRemove!(i),
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.white.withValues(
                                alpha: 0.95,
                              ),
                            ),
                            icon: const AiIcon('remove'),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          if (onAdd != null && count < 5)
            SizedBox.square(
              dimension: width,
              child: AiDashedBox(
                radius: 12,
                onTap: busy ? null : onAdd,
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AiIcon('add'),
                    SizedBox(height: 4),
                    Text(
                      'Thêm ảnh',
                      style: TextStyle(
                        color: AiDiagnosisStyle.purple,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      );
    },
  );
}

/// A gallery keeps signed URLs private and obtains fresh ones through GET detail only.
class AiDiagnosisImageViewer extends ConsumerStatefulWidget {
  const AiDiagnosisImageViewer({
    required this.initialIndex,
    this.images,
    this.diagnosisKey,
    super.key,
  }) : assert((images == null) != (diagnosisKey == null));
  final int initialIndex;
  final List<AiDiagnosisImage>? images;
  final AiDiagnosisKey? diagnosisKey;
  @override
  ConsumerState<AiDiagnosisImageViewer> createState() =>
      _AiDiagnosisImageViewerState();
}

class _AiDiagnosisImageViewerState
    extends ConsumerState<AiDiagnosisImageViewer> {
  late int index = widget.initialIndex;
  bool refreshing = false;
  String? refreshError;
  Future<void> refreshImages() async {
    if (refreshing || widget.diagnosisKey == null) return;
    setState(() {
      refreshing = true;
      refreshError = null;
    });
    try {
      await ref
          .read(aiDiagnosisDetailProvider(widget.diagnosisKey!).notifier)
          .imagesForViewing(forceRefresh: true);
    } on Object catch (error) {
      if (mounted) {
        setState(() => refreshError = AiDiagnosisText.message(error));
      }
    } finally {
      if (mounted) setState(() => refreshing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final detail = widget.diagnosisKey == null
        ? null
        : ref
              .watch(aiDiagnosisDetailProvider(widget.diagnosisKey!))
              .asData
              ?.value;
    final count = widget.images?.length ?? detail?.imageUrls.length ?? 0;
    Widget photo(int i, BoxFit fit) => widget.images != null
        ? Image.memory(
            widget.images![i].bytes,
            cacheWidth: fit == BoxFit.cover ? 256 : 2048,
            fit: fit,
            errorBuilder: (_, _, _) => const Icon(Icons.broken_image_outlined),
          )
        : AiNetworkPhoto(
            detail!.imageUrls[i],
            fit: fit,
            onRetry: refreshImages,
          );
    return SafeArea(
      top: false,
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.78,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 12, 12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Ảnh ${index + 1}/$count',
                      style: AiDiagnosisStyle.heading(fontSize: 16),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Đóng',
                    onPressed: () => Navigator.pop(context),
                    style: IconButton.styleFrom(
                      backgroundColor: AiDiagnosisStyle.muted,
                    ),
                    icon: const AiIcon('close'),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: AiDiagnosisStyle.muted),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: SizedBox.expand(
                    child: count > index
                        ? InteractiveViewer(
                            maxScale: 4,
                            child: photo(index, BoxFit.contain),
                          )
                        : const Center(child: Text('Không tải được ảnh.')),
                  ),
                ),
              ),
            ),
            if (refreshError != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  refreshError!,
                  style: const TextStyle(color: AppColors.error),
                ),
              ),
            if (count > 0)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                child: SizedBox(
                  height: 66,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: count,
                    separatorBuilder: (_, _) => const SizedBox(width: 8),
                    itemBuilder: (_, i) => Semantics(
                      button: true,
                      selected: i == index,
                      label: 'Xem ảnh ${i + 1} trong thư viện',
                      child: GestureDetector(
                        onTap: () => setState(() => index = i),
                        child: Container(
                          width: 64,
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: i == index
                                  ? AiDiagnosisStyle.purple
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: Opacity(
                            opacity: i == index ? 1 : 0.6,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: photo(i, BoxFit.cover),
                            ),
                          ),
                        ),
                      ),
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
