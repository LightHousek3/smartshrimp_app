import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';

enum AppNoticeTone { success, info, warning, danger }

@immutable
class AppNotice {
  const AppNotice({
    required this.message,
    this.tone = AppNoticeTone.info,
    this.title,
    this.actionLabel,
    this.onAction,
    this.duration = const Duration(milliseconds: 3200),
  }) : assert(
         actionLabel == null || onAction != null,
         'onAction is required when actionLabel is set.',
       );

  final String message;
  final AppNoticeTone tone;
  final String? title;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Duration duration;
}

abstract final class AppFeedback {
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> show(
    BuildContext context,
    AppNotice notice,
  ) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    return messenger.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 14),
        padding: EdgeInsets.zero,
        elevation: 0,
        backgroundColor: Colors.transparent,
        duration: notice.duration,
        content: AppToast(notice: notice),
      ),
    );
  }

  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> success(
    BuildContext context,
    String message, {
    String? title,
    String? actionLabel,
    VoidCallback? onAction,
  }) => show(
    context,
    AppNotice(
      message: message,
      tone: AppNoticeTone.success,
      title: title,
      actionLabel: actionLabel,
      onAction: onAction,
    ),
  );

  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> info(
    BuildContext context,
    String message, {
    String? title,
  }) => show(context, AppNotice(message: message, title: title));

  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> warning(
    BuildContext context,
    String message, {
    String? title,
  }) => show(
    context,
    AppNotice(message: message, tone: AppNoticeTone.warning, title: title),
  );

  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> danger(
    BuildContext context,
    String message, {
    String? title,
  }) => show(
    context,
    AppNotice(
      message: message,
      tone: AppNoticeTone.danger,
      title: title,
      duration: const Duration(seconds: 5),
    ),
  );
}

class AppToast extends StatelessWidget {
  const AppToast({required this.notice, super.key});

  final AppNotice notice;

  @override
  Widget build(BuildContext context) {
    final style = _NoticeVisuals.of(notice.tone);
    return Semantics(
      liveRegion: true,
      label: '${notice.title ?? style.defaultTitle}. ${notice.message}',
      child: Container(
        constraints: const BoxConstraints(maxWidth: 380, minHeight: 64),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: style.borderColor),
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: Color(0x320F1C2E),
              blurRadius: 36,
              spreadRadius: -12,
              offset: Offset(0, 14),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: style.iconBackground,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(style.icon, size: 18, color: style.iconColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    notice.title ?? style.defaultTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.ink,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    notice.message,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.inkSoft,
                      fontSize: 11,
                      height: 1.45,
                    ),
                  ),
                  if (notice.actionLabel != null) ...<Widget>[
                    const SizedBox(height: 5),
                    InkWell(
                      onTap: notice.onAction,
                      borderRadius: BorderRadius.circular(6),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Text(
                          notice.actionLabel!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: style.iconColor,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AppDialog extends StatelessWidget {
  const AppDialog({
    required this.title,
    this.description,
    this.tone = AppNoticeTone.info,
    this.content,
    this.actions = const <Widget>[],
    super.key,
  });

  final String title;
  final String? description;
  final AppNoticeTone tone;
  final Widget? content;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final style = _NoticeVisuals.of(tone);
    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      actionsPadding: const EdgeInsets.all(14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 340),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: style.iconBackground,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(style.icon, size: 21, color: style.iconColor),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.display(
                color: AppColors.ink,
                fontSize: 17,
                fontWeight: FontWeight.w700,
                height: 1.35,
              ),
            ),
            if (description != null &&
                description!.trim().isNotEmpty) ...<Widget>[
              const SizedBox(height: 6),
              Text(
                description!,
                maxLines: 6,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.inkSoft,
                  fontSize: 12,
                  height: 1.5,
                ),
              ),
            ],
            if (content != null) ...<Widget>[
              const SizedBox(height: 16),
              Flexible(child: content!),
            ],
          ],
        ),
      ),
      actions: actions.isEmpty ? null : actions,
    );
  }
}

class AppConfirmDialog extends StatelessWidget {
  const AppConfirmDialog({
    required this.entityLabel,
    required this.entityName,
    required this.retentionMessage,
    this.blockers = const <String>[],
    this.confirmLabel = 'Xác nhận xóa',
    super.key,
  });

  final String entityLabel;
  final String entityName;
  final String retentionMessage;
  final List<String> blockers;
  final String confirmLabel;

  bool get _blocked => blockers.isNotEmpty;

  @override
  Widget build(BuildContext context) => AppDialog(
    tone: _blocked ? AppNoticeTone.warning : AppNoticeTone.danger,
    title: _blocked ? 'Chưa thể xóa $entityLabel' : 'Xóa “$entityName”?',
    description: _blocked
        ? 'Hoàn tất các mục bên dưới rồi thử lại.'
        : retentionMessage,
    content: _blocked
        ? Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              for (final blocker in blockers)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _BlockerItem(message: blocker),
                ),
            ],
          )
        : null,
    actions: _blocked
        ? <Widget>[
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: context.pop,
                child: const Text('Đã hiểu'),
              ),
            ),
          ]
        : <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => context.pop(false),
                    child: const Text('Quay lại'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () => context.pop(true),
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFFD43B57),
                      foregroundColor: Colors.white,
                    ),
                    icon: const Icon(Icons.delete_outline_rounded, size: 17),
                    label: Text(
                      confirmLabel,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ],
  );
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
      builder: (_) => AppConfirmDialog(
        entityLabel: entityLabel,
        entityName: entityName,
        retentionMessage: retentionMessage,
        blockers: blockers,
        confirmLabel: confirmLabel,
      ),
    ) ??
    false;

Future<bool> showAppDecisionDialog(
  BuildContext context, {
  required String title,
  required String description,
  required String confirmLabel,
  String cancelLabel = 'Quay lại',
  AppNoticeTone tone = AppNoticeTone.info,
}) async =>
    await showDialog<bool>(
      context: context,
      barrierColor: AppColors.ink.withValues(alpha: 0.35),
      builder: (dialogContext) => AppDialog(
        title: title,
        description: description,
        tone: tone,
        actions: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: OutlinedButton(
                  onPressed: () => dialogContext.pop(false),
                  child: Text(
                    cancelLabel,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: FilledButton(
                  onPressed: () => dialogContext.pop(true),
                  style: tone == AppNoticeTone.danger
                      ? FilledButton.styleFrom(
                          backgroundColor: const Color(0xFFD43B57),
                        )
                      : null,
                  child: Text(
                    confirmLabel,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ) ??
    false;

class AppFormErrorBanner extends StatelessWidget {
  const AppFormErrorBanner({
    required this.message,
    this.title = 'Không thể lưu thông tin',
    super.key,
  });

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final style = _NoticeVisuals.of(AppNoticeTone.danger);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: style.iconBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: style.borderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(style.icon, size: 18, color: style.iconColor),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.ink,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  message,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.inkSoft,
                    fontSize: 11,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

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

@immutable
class _NoticeVisuals {
  const _NoticeVisuals({
    required this.defaultTitle,
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
    required this.borderColor,
  });

  final String defaultTitle;
  final IconData icon;
  final Color iconColor;
  final Color iconBackground;
  final Color borderColor;

  static _NoticeVisuals of(AppNoticeTone tone) => switch (tone) {
    AppNoticeTone.success => const _NoticeVisuals(
      defaultTitle: 'Thành công',
      icon: Icons.check_circle_rounded,
      iconColor: Color(0xFF087C70),
      iconBackground: Color(0xFFE2F6F3),
      borderColor: Color(0xFF96F7E4),
    ),
    AppNoticeTone.info => const _NoticeVisuals(
      defaultTitle: 'Thông báo',
      icon: Icons.info_outline_rounded,
      iconColor: Color(0xFF0F62B4),
      iconBackground: Color(0xFFEAF4FF),
      borderColor: Color(0xFFC4E0FF),
    ),
    AppNoticeTone.warning => const _NoticeVisuals(
      defaultTitle: 'Cần kiểm tra',
      icon: Icons.warning_amber_rounded,
      iconColor: Color(0xFFB66A00),
      iconBackground: Color(0xFFFFF8E6),
      borderColor: Color(0xFFF4D58D),
    ),
    AppNoticeTone.danger => const _NoticeVisuals(
      defaultTitle: 'Không thể thực hiện',
      icon: Icons.error_outline_rounded,
      iconColor: Color(0xFFD43B57),
      iconBackground: Color(0xFFFFF0F3),
      borderColor: Color(0xFFF4B8C4),
    ),
  };
}
