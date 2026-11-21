import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/widgets/app_dialog.dart';

/// Select a source; each feature retains its own image limits, validation and upload.
Future<ImageSource?> showAppImageSourceDialog(BuildContext context) =>
    showDialog<ImageSource>(
      context: context,
      barrierColor: AppColors.ink.withValues(alpha: 0.35),
      builder: (dialogContext) => AppDialog(
        title: 'Thêm ảnh',
        description: 'Chọn ảnh có sẵn hoặc chụp ảnh mới.',
        icon: Icons.add_photo_alternate_outlined,
        separatedActions: true,
        content: SizedBox(
          width: 360,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              _SourceOption(
                icon: Icons.photo_library_outlined,
                label: 'Chọn ảnh từ thiết bị',
                source: ImageSource.gallery,
              ),
              SizedBox(height: 10),
              _SourceOption(
                icon: Icons.camera_alt_outlined,
                label: 'Chụp ảnh mới',
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

class _SourceOption extends StatelessWidget {
  const _SourceOption({
    required this.icon,
    required this.label,
    required this.source,
  });

  final IconData icon;
  final String label;
  final ImageSource source;

  @override
  Widget build(BuildContext context) => Material(
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
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
      onTap: () => Navigator.of(context).pop(source),
    ),
  );
}
