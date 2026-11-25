import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/services/app_image_picker.dart';
import 'package:smartshrimp_app/core/widgets/app_image_source_dialog.dart';
import 'package:smartshrimp_app/core/widgets/app_notice.dart';
import '../../domain/domain.dart';
import '../view_models/case_evidence_draft.dart';
import '../view_models/disease_case_controller.dart';
import 'case_ui.dart';

class CaseEvidencePicker extends ConsumerStatefulWidget {
  const CaseEvidencePicker({
    super.key,
    required this.images,
    required this.onChanged,
    this.disabled = false,
    this.onBusyChanged,
    this.compact = false,
  });

  final List<LocalCaseEvidence> images;
  final ValueChanged<List<LocalCaseEvidence>> onChanged;
  final bool disabled;
  final ValueChanged<bool>? onBusyChanged;
  final bool compact;
  @override
  ConsumerState<CaseEvidencePicker> createState() => _CaseEvidencePickerState();
}

class _CaseEvidencePickerState extends ConsumerState<CaseEvidencePicker> {
  bool _busy = false;
  int get _imageCount => widget.images.length;
  int get _remaining => DiseaseCaseRules.maxEvidenceImages - _imageCount;

  Future<void> _addEvidence() async {
    final remaining = _remaining;
    if (_busy || widget.disabled || remaining <= 0) return;
    setState(() => _busy = true);
    widget.onBusyChanged?.call(true);
    try {
      final source = await showAppImageSourceDialog(
        context,
        remaining: remaining,
      );
      if (source == null || !mounted || widget.disabled) return;
      final files = await pickAppImages(
        ref.read(caseImagePickerProvider),
        source: source,
        limit: remaining,
      );
      if (files.isEmpty || !mounted || widget.disabled) return;
      final images = <LocalCaseEvidence>[];
      for (final file in files) {
        if (await file.length() > DiseaseCaseRules.maxImageBytes) {
          throw const ApiException('Ảnh tối đa 5 MB.');
        }
        final bytes = await file.readAsBytes();
        DiseaseCaseRules.validateImage(bytes);
        images.add((bytes: bytes, fileName: file.name));
      }
      if (mounted && !widget.disabled) {
        widget.onChanged([...widget.images, ...images]);
      }
    } catch (error) {
      if (mounted) {
        AppNoticeService.danger(context, caseError(error));
      }
    } finally {
      if (mounted) {
        setState(() => _busy = false);
        widget.onBusyChanged?.call(false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final disabled = _busy || widget.disabled || _remaining <= 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.compact)
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: disabled ? null : _addEvidence,
              icon: const Icon(Icons.add_photo_alternate_outlined, size: 18),
              style: TextButton.styleFrom(
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                minimumSize: const Size(0, 44),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
              ),
              label: Text(
                _busy
                    ? 'Đang đọc ảnh…'
                    : 'Đính kèm ảnh ($_imageCount/${DiseaseCaseRules.maxEvidenceImages})',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontSize: 12,
                  color: AppColors.inkSoft,
                ),
              ),
            ),
          )
        else
          CustomPaint(
            painter: _EvidenceBorder(),
            child: SizedBox(
              width: double.infinity,
              child: TextButton.icon(
                onPressed: disabled ? null : _addEvidence,
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 15,
                  ),
                ),
                icon: Icon(
                  _busy ? Icons.hourglass_top : Icons.photo_camera_outlined,
                  color: AppColors.inkMuted,
                  size: 17,
                ),
                label: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _busy ? 'Đang đọc ảnh…' : 'Thêm ảnh mẫu tôm / nhá',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: 12,
                        color: AppColors.inkMuted,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'JPG, PNG, WebP · tối đa ${DiseaseCaseRules.maxEvidenceImages} ảnh, 5 MB/ảnh',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: 10,
                        height: 1.5,
                        color: AppColors.inkMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        if (_imageCount > 0)
          Wrap(
            spacing: 7,
            runSpacing: 6,
            children: [
              for (final (index, image) in widget.images.indexed)
                Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.memory(
                          image.bytes,
                          height: widget.compact ? 44 : 72,
                          width: widget.compact ? 58 : 78,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => Container(
                            height: widget.compact ? 44 : 72,
                            width: widget.compact ? 58 : 78,
                            color: const Color(0xFFF0F3F8),
                            child: const Icon(
                              Icons.broken_image_outlined,
                              color: AppColors.inkMuted,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: SizedBox(
                        width: 25,
                        height: 25,
                        child: IconButton(
                          tooltip: 'Bỏ ảnh minh chứng',
                          padding: EdgeInsets.zero,
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.white,
                          ),
                          onPressed: _busy || widget.disabled
                              ? null
                              : () => widget.onChanged(
                                  [...widget.images]..removeAt(index),
                                ),
                          icon: const Icon(Icons.close, size: 14),
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
      ],
    );
  }
}

class _EvidenceBorder extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.line
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(12)),
      );
    for (final metric in path.computeMetrics()) {
      for (var distance = 0.0; distance < metric.length; distance += 7) {
        canvas.drawPath(
          metric.extractPath(distance, (distance + 3).clamp(0, metric.length)),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
