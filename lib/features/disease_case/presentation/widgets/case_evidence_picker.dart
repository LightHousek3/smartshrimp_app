import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/widgets/app_dialog.dart';
import 'package:smartshrimp_app/core/widgets/app_notice.dart';
import '../../domain/domain.dart';
import '../view_models/disease_case_controller.dart';
import 'case_ui.dart';

class CaseEvidencePicker extends ConsumerStatefulWidget {
  const CaseEvidencePicker({
    super.key,
    required this.urls,
    required this.onChanged,
    this.disabled = false,
    this.onBusyChanged,
    this.compact = false,
  });
  final List<String> urls;
  final ValueChanged<List<String>> onChanged;
  final bool disabled;
  final ValueChanged<bool>? onBusyChanged;
  final bool compact;
  @override
  ConsumerState<CaseEvidencePicker> createState() => _CaseEvidencePickerState();
}

class _CaseEvidencePickerState extends ConsumerState<CaseEvidencePicker> {
  bool _busy = false;
  Future<void> _pick(ImageSource source) async {
    if (_busy || widget.disabled || widget.urls.length >= 5) return;
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
      final url = await ref
          .read(diseaseCaseMutationProvider.notifier)
          .uploadEvidence(bytes, file.name);
      if (mounted) widget.onChanged([...widget.urls, url]);
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
    final source = await showDialog<ImageSource>(
      context: context,
      barrierColor: AppColors.ink.withValues(alpha: 0.35),
      builder: (dialogContext) => AppDialog(
        title: 'Thêm ảnh minh chứng',
        description: 'Chọn ảnh có sẵn hoặc chụp ảnh mới.',
        icon: Icons.add_photo_alternate_outlined,
        separatedActions: true,
        content: SizedBox(
          width: 360,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _sourceOption(
                dialogContext,
                icon: Icons.photo_library_outlined,
                label: 'Chọn ảnh từ thiết bị',
                source: ImageSource.gallery,
              ),
              const SizedBox(height: 10),
              _sourceOption(
                dialogContext,
                icon: Icons.camera_alt_outlined,
                label: 'Chụp ảnh minh chứng',
                source: ImageSource.camera,
              ),
            ],
          ),
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            height: 44,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.inkSoft,
                backgroundColor: Colors.white,
                side: const BorderSide(color: AppColors.line),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                textStyle: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Hủy'),
            ),
          ),
        ],
      ),
    );
    if (source != null && mounted) await _pick(source);
  }

  Widget _sourceOption(
    BuildContext dialogContext, {
    required IconData icon,
    required String label,
    required ImageSource source,
  }) => Material(
    color: const Color(0xFFF4F7FB),
    clipBehavior: Clip.antiAlias,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: const BorderSide(color: AppColors.line),
    ),
    child: ListTile(
      leading: Icon(icon, color: AppColors.ocean, size: 22),
      title: Text(
        label,
        style: Theme.of(dialogContext).textTheme.bodyMedium?.copyWith(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.ink,
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right_rounded,
        color: AppColors.inkMuted,
        size: 20,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      onTap: () => Navigator.of(dialogContext).pop(source),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final disabled = _busy || widget.disabled || widget.urls.length >= 5;
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
                _busy
                    ? 'Đang tải ảnh…'
                    : 'Đính kèm ảnh (${widget.urls.length}/5)',
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
                      _busy ? 'Đang tải ảnh…' : 'Thêm ảnh mẫu tôm / nhá',
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
        if (widget.urls.isNotEmpty)
          Wrap(
            spacing: 7,
            runSpacing: 6,
            children: [
              for (final url in widget.urls)
                Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          url,
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
                                  widget.urls.where((v) => v != url).toList(),
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
