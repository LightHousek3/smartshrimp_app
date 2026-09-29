import 'package:flutter/material.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/widgets/app_notice.dart';

class AppDialog extends StatelessWidget {
  const AppDialog({
    required this.title,
    this.description,
    this.level = AppNoticeLevel.info,
    this.content,
    this.actions = const <Widget>[],
    super.key,
  });

  final String title;
  final String? description;
  final AppNoticeLevel level;
  final Widget? content;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final visual = appNoticeVisualFor(level);
    return AlertDialog(
      key: ValueKey<String>('app_dialog_${level.name}'),
      backgroundColor: const Color(0xFFFFFEFD),
      surfaceTintColor: Colors.transparent,
      shadowColor: const Color(0x2416243A),
      elevation: 12,
      scrollable: true,
      insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: visual.border),
      ),
      titlePadding: const EdgeInsets.fromLTRB(18, 18, 18, 0),
      contentPadding: const EdgeInsets.fromLTRB(18, 16, 18, 4),
      actionsPadding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: visual.background,
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(visual.icon, color: visual.foreground, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.ink,
                    fontSize: 17,
                    height: 1.2,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                if (description != null && description!.trim().isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    description!,
                    style: const TextStyle(
                      color: AppColors.inkSoft,
                      fontSize: 11.5,
                      height: 1.4,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
      content: content,
      actionsAlignment: MainAxisAlignment.center,
      actionsOverflowAlignment: OverflowBarAlignment.center,
      actionsOverflowButtonSpacing: 8,
      actions: actions,
    );
  }
}

class AppConfirmDialog extends StatelessWidget {
  const AppConfirmDialog({
    required this.title,
    required this.description,
    required this.confirmLabel,
    required this.onConfirm,
    this.cancelLabel = 'Quay lại',
    this.level = AppNoticeLevel.warning,
    this.destructive = false,
    this.content,
    super.key,
  });

  final String title;
  final String description;
  final String confirmLabel;
  final VoidCallback onConfirm;
  final String cancelLabel;
  final AppNoticeLevel level;
  final bool destructive;
  final Widget? content;

  @override
  Widget build(BuildContext context) => AppDialog(
    title: title,
    description: description,
    level: level,
    content: content,
    actions: <Widget>[
      Row(
        children: <Widget>[
          Expanded(
            child: _DialogActionButton(
              key: const Key('app_confirm_dialog_cancel'),
              label: cancelLabel,
              onPressed: () => Navigator.of(context).pop(false),
              secondary: true,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _DialogActionButton(
              key: const Key('app_confirm_dialog_confirm'),
              label: confirmLabel,
              onPressed: onConfirm,
              destructive: destructive,
            ),
          ),
        ],
      ),
    ],
  );
}

class _DialogActionButton extends StatelessWidget {
  const _DialogActionButton({
    required this.label,
    required this.onPressed,
    this.secondary = false,
    this.destructive = false,
    super.key,
  });

  final String label;
  final VoidCallback onPressed;
  final bool secondary;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    if (secondary) {
      return SizedBox(
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
          onPressed: onPressed,
          child: Text(label),
        ),
      );
    }

    final colors = destructive
        ? const <Color>[AppColors.error, Color(0xFFE75D72)]
        : const <Color>[AppColors.oceanLight, AppColors.tealLight];
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: colors),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x2077A1D3),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            height: 44,
            child: Center(
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
