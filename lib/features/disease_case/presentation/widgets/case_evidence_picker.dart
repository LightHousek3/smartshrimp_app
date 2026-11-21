import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/widgets/app_image_source_dialog.dart';
import 'package:smartshrimp_app/core/widgets/app_notice.dart';
import '../../domain/domain.dart';
import '../view_models/disease_case_controller.dart';
import 'case_ui.dart';

typedef LocalCaseEvidence = ({Uint8List bytes, String fileName});

class CaseEvidencePicker extends ConsumerStatefulWidget {
  const CaseEvidencePicker({
    super.key,
    required this.urls,
    required this.onChanged,
    this.disabled = false,
    this.onBusyChanged,
    this.compact = false,
  }) : localImages = const [],
       onLocalChanged = null;

  const CaseEvidencePicker.local({
    super.key,
    required this.localImages,
    required ValueChanged<List<LocalCaseEvidence>> onChanged,
    this.disabled = false,
    this.onBusyChanged,
    this.compact = false,
  }) : urls = const [],
       onChanged = null,
       onLocalChanged = onChanged;

  final List<String> urls;
  final ValueChanged<List<String>>? onChanged;
  final List<LocalCaseEvidence> localImages;
  final ValueChanged<List<LocalCaseEvidence>>? onLocalChanged;
  final bool disabled;
  final ValueChanged<bool>? onBusyChanged;
  final bool compact;
  @override
  ConsumerState<CaseEvidencePicker> createState() => _CaseEvidencePickerState();
}

class _CaseEvidencePickerState extends ConsumerState<CaseEvidencePicker> {
  bool _busy = false;
  int get _imageCount => widget.urls.length + widget.localImages.length;
  String get _busyLabel =>
      widget.onLocalChanged == null ? 'Đang tải ảnh…' : 'Đang đọc ảnh…';

  Future<void> _pick(ImageSource source) async {
    if (_busy || widget.disabled || _imageCount >= 5) return;
    setState(() => _busy = true);
    widget.onBusyChanged?.call(true);
    try {
      final file = await ref
          .read(caseImagePickerProvider)
          .pickImage(source: source);
      if (file == null || !mounted) return;
      if (await file.length() > DiseaseCaseRules.maxImageBytes) {
        throw const ApiException('Ảnh tối đa 5 MB.');
      }
      final bytes = await file.readAsBytes();
      if (!mounted) return;
      DiseaseCaseRules.validateImage(bytes);
      if (widget.onLocalChanged != null) {
        widget.onLocalChanged!([
          ...widget.localImages,
          (bytes: bytes, fileName: file.name),
        ]);
        return;
      }
      final url = await ref
          .read(diseaseCaseMutationProvider.notifier)
          .uploadEvidence(bytes, file.name);
      if (mounted) widget.onChanged!([...widget.urls, url]);
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

  Future<void> _choose() async {
    if (_busy || widget.disabled || widget.urls.length >= 5) return;
    final source = await showAppImageSourceDialog(context);
    if (source != null && mounted) await _pick(source);
  }

  @override
  Widget build(BuildContext context) {
    final disabled = _busy || widget.disabled || _imageCount >= 5;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.compact)
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: disabled ? null : _choose,
              icon: const Icon(Icons.add_photo_alternate_outlined, size: 18),
              style: TextButton.styleFrom(
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                minimumSize: const Size(0, 44),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
              ),
              label: Text(
                _busy ? _busyLabel : 'Đính kèm ảnh ($_imageCount/5)',
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
                onPressed: disabled ? null : _choose,
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
                      _busy ? _busyLabel : 'Thêm ảnh mẫu tôm / nhá',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: 12,
                        color: AppColors.inkMuted,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'JPG, PNG, WebP · tối đa 5 ảnh, 5 MB/ảnh',
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
              for (final preview in [
                for (final url in widget.urls)
                  (
                    image: NetworkImage(url) as ImageProvider,
                    remove: () => widget.onChanged!(
                      widget.urls.where((v) => v != url).toList(),
                    ),
                  ),
                for (final image in widget.localImages)
                  (
                    image: MemoryImage(image.bytes) as ImageProvider,
                    remove: () => widget.onLocalChanged!(
                      widget.localImages.where((v) => v != image).toList(),
                    ),
                  ),
              ])
                Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image(
                          image: preview.image,
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
                              : preview.remove,
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
