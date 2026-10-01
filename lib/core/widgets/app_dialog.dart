import 'package:flutter/material.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/widgets/app_notice.dart';

class AppDialog extends StatelessWidget {
  const AppDialog({
    required this.title,
    this.description,
    this.level = AppNoticeLevel.info,
    this.icon,
    this.content,
    this.actions = const <Widget>[],
    this.verticalHeader = false,
    this.separatedActions = false,
    super.key,
  });

  final String title;
  final String? description;
  final AppNoticeLevel level;
  final IconData? icon;
  final Widget? content;
  final List<Widget> actions;
  final bool verticalHeader;
  final bool separatedActions;

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
      clipBehavior: Clip.antiAlias,
      insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: visual.border),
      ),
      titlePadding: const EdgeInsets.fromLTRB(18, 18, 18, 0),
      contentPadding: const EdgeInsets.fromLTRB(18, 16, 18, 4),
      actionsPadding: separatedActions
          ? EdgeInsets.zero
          : const EdgeInsets.fromLTRB(14, 14, 14, 14),
      title: verticalHeader
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _DialogLevelIcon(visual: visual, icon: icon),
                const SizedBox(height: 14),
                _DialogTitleText(title: title, description: description),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                _DialogLevelIcon(visual: visual, icon: icon),
                const SizedBox(width: 12),
                Expanded(
                  child: _DialogTitleText(
                    title: title,
                    description: description,
                  ),
                ),
              ],
            ),
      content: content,
      actionsAlignment: MainAxisAlignment.center,
      actionsOverflowAlignment: OverflowBarAlignment.center,
      actionsOverflowButtonSpacing: 8,
      actions: separatedActions && actions.isNotEmpty
          ? <Widget>[
              Container(
                width: double.maxFinite,
                padding: const EdgeInsets.all(14),
                decoration: const BoxDecoration(
                  color: Color(0xFFF7F8FA),
                  border: Border(top: BorderSide(color: AppColors.line)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: actions,
                ),
              ),
            ]
          : actions,
    );
  }
}

class _DialogLevelIcon extends StatelessWidget {
  const _DialogLevelIcon({required this.visual, required this.icon});

  final AppNoticeVisual visual;
  final IconData? icon;

  @override
  Widget build(BuildContext context) => Container(
    width: 40,
    height: 40,
    decoration: BoxDecoration(
      color: visual.background,
      borderRadius: BorderRadius.circular(13),
    ),
    child: Icon(icon ?? visual.icon, color: visual.foreground, size: 20),
  );
}

class _DialogTitleText extends StatelessWidget {
  const _DialogTitleText({required this.title, required this.description});

  final String title;
  final String? description;

  @override
  Widget build(BuildContext context) => Column(
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
      if (description != null && description!.trim().isNotEmpty) ...<Widget>[
        const SizedBox(height: 4),
        Text(
          description!,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.inkSoft,
            fontSize: 12,
            height: 1.45,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.05,
            wordSpacing: 0.8,
          ),
        ),
      ],
    ],
  );
}

class AppConfirmDialog extends StatelessWidget {
  const AppConfirmDialog({
    required this.title,
    required this.description,
    required this.confirmLabel,
    required this.onConfirm,
    this.onCancel,
    this.cancelLabel = 'Quay lại',
    this.level = AppNoticeLevel.warning,
    this.destructive = false,
    this.icon,
    this.content,
    this.verticalHeader = false,
    this.separatedActions = false,
    super.key,
  });

  final String title;
  final String description;
  final String confirmLabel;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;
  final String cancelLabel;
  final AppNoticeLevel level;
  final bool destructive;
  final IconData? icon;
  final Widget? content;
  final bool verticalHeader;
  final bool separatedActions;

  @override
  Widget build(BuildContext context) => AppDialog(
    title: title,
    description: description,
    level: level,
    icon: icon,
    content: content,
    verticalHeader: verticalHeader,
    separatedActions: separatedActions,
    actions: <Widget>[
      Row(
        children: <Widget>[
          Expanded(
            child: _DialogActionButton(
              key: const Key('app_confirm_dialog_cancel'),
              label: cancelLabel,
              onPressed: onCancel ?? () => Navigator.of(context).pop(false),
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

Future<bool> showAppConfirmDialog(
  BuildContext context, {
  required String entityLabel,
  required String entityName,
  required String retentionMessage,
  List<String> blockers = const <String>[],
  String confirmLabel = 'Xác nhận xóa',
}) async =>
    await showDialog<bool>(
      context: context,
      barrierColor: AppColors.ink.withValues(alpha: 0.35),
      builder: (dialogContext) {
        if (blockers.isNotEmpty) {
          return AppDialog(
            level: AppNoticeLevel.warning,
            title: 'Chưa thể xóa $entityLabel',
            description: 'Hoàn tất các mục bên dưới rồi thử lại.',
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                for (final blocker in blockers)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _BlockerItem(message: blocker),
                  ),
              ],
            ),
            actions: <Widget>[
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.of(dialogContext).pop(false),
                  child: const Text('Đã hiểu'),
                ),
              ),
            ],
          );
        }

        return AppConfirmDialog(
          title: 'Xóa “$entityName”?',
          description: retentionMessage,
          confirmLabel: confirmLabel,
          level: AppNoticeLevel.danger,
          destructive: true,
          onConfirm: () => Navigator.of(dialogContext).pop(true),
        );
      },
    ) ??
    false;

class _BlockerItem extends StatelessWidget {
  const _BlockerItem({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    decoration: BoxDecoration(
      color: const Color(0xFFFFF8E6),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.only(top: 1),
          child: Icon(
            Icons.warning_amber_rounded,
            size: 15,
            color: Color(0xFFB66A00),
          ),
        ),
        const SizedBox(width: 9),
        Expanded(
          child: Text(
            message,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFF8A5500),
              fontSize: 11,
              height: 1.45,
            ),
          ),
        ),
      ],
    ),
  );
}
