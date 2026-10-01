import 'package:flutter/material.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';

enum AppNoticeLevel { success, info, warning, danger }

@immutable
final class AppNoticeVisual {
  const AppNoticeVisual({
    required this.defaultTitle,
    required this.icon,
    required this.foreground,
    required this.background,
    required this.border,
  });

  final String defaultTitle;
  final IconData icon;
  final Color foreground;
  final Color background;
  final Color border;
}

AppNoticeVisual appNoticeVisualFor(AppNoticeLevel level) => switch (level) {
  AppNoticeLevel.success => const AppNoticeVisual(
    defaultTitle: 'Thành công',
    icon: Icons.check_circle_rounded,
    foreground: Color(0xFF087C70),
    background: Color(0xFFE2F6F3),
    border: Color(0xFF96F7E4),
  ),
  AppNoticeLevel.info => const AppNoticeVisual(
    defaultTitle: 'Thông báo',
    icon: Icons.info_outline_rounded,
    foreground: Color(0xFF0F62B4),
    background: Color(0xFFEAF4FF),
    border: Color(0xFFC4E0FF),
  ),
  AppNoticeLevel.warning => const AppNoticeVisual(
    defaultTitle: 'Cần kiểm tra',
    icon: Icons.warning_amber_rounded,
    foreground: Color(0xFFB66A00),
    background: Color(0xFFFFF8E6),
    border: Color(0xFFF4D58D),
  ),
  AppNoticeLevel.danger => const AppNoticeVisual(
    defaultTitle: 'Không thể thực hiện',
    icon: Icons.error_outline_rounded,
    foreground: Color(0xFFD43B57),
    background: Color(0xFFFFF0F3),
    border: Color(0xFFF4B8C4),
  ),
};

String appNoticeDefaultTitle(AppNoticeLevel level) =>
    appNoticeVisualFor(level).defaultTitle;

abstract final class AppNoticeService {
  static ScaffoldMessengerState? _activeMessenger;

  static void show(
    BuildContext context, {
    required String message,
    String? title,
    AppNoticeLevel level = AppNoticeLevel.info,
    String? actionLabel,
    VoidCallback? onAction,
    Duration? duration,
  }) {
    assert(
      actionLabel == null || onAction != null,
      'onAction is required when actionLabel is set.',
    );

    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) return;

    hide();
    _activeMessenger = messenger;
    final controller = messenger.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
        dismissDirection: DismissDirection.down,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 14),
        padding: EdgeInsets.zero,
        duration:
            duration ??
            (level == AppNoticeLevel.danger || level == AppNoticeLevel.warning
                ? const Duration(seconds: 5)
                : const Duration(milliseconds: 3200)),
        content: _AppNoticeCard(
          title: title ?? appNoticeDefaultTitle(level),
          message: message,
          level: level,
          actionLabel: actionLabel,
          onActionPressed: () => onAction?.call(),
        ),
      ),
    );
    controller.closed.whenComplete(() {
      if (identical(_activeMessenger, messenger)) _activeMessenger = null;
    });
  }

  static void success(
    BuildContext context,
    String message, {
    String? title,
    String? actionLabel,
    VoidCallback? onAction,
  }) => show(
    context,
    message: message,
    title: title,
    level: AppNoticeLevel.success,
    actionLabel: actionLabel,
    onAction: onAction,
  );

  static void info(BuildContext context, String message, {String? title}) =>
      show(context, message: message, title: title);

  static void warning(BuildContext context, String message, {String? title}) =>
      show(
        context,
        message: message,
        title: title,
        level: AppNoticeLevel.warning,
      );

  static void danger(BuildContext context, String message, {String? title}) =>
      show(
        context,
        message: message,
        title: title,
        level: AppNoticeLevel.danger,
      );

  static void hide() {
    final messenger = _activeMessenger;
    _activeMessenger = null;
    if (messenger?.mounted ?? false) messenger!.hideCurrentSnackBar();
  }
}

class _AppNoticeCard extends StatelessWidget {
  const _AppNoticeCard({
    required this.title,
    required this.message,
    required this.level,
    required this.actionLabel,
    required this.onActionPressed,
  });

  final String title;
  final String message;
  final AppNoticeLevel level;
  final String? actionLabel;
  final VoidCallback onActionPressed;

  @override
  Widget build(BuildContext context) {
    final visual = appNoticeVisualFor(level);
    return Semantics(
      liveRegion: true,
      label: '$title. $message',
      child: Align(
        alignment: Alignment.bottomCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 380),
          child: Container(
            key: ValueKey<String>('app_notice_${level.name}'),
            constraints: const BoxConstraints(minHeight: 64),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: visual.border),
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
                    color: visual.background,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(visual.icon, size: 18, color: visual.foreground),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.inkSoft,
                          fontSize: 11,
                          height: 1.45,
                        ),
                      ),
                      if (actionLabel != null) ...<Widget>[
                        const SizedBox(height: 5),
                        InkWell(
                          onTap: onActionPressed,
                          borderRadius: BorderRadius.circular(6),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: Text(
                              actionLabel!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: visual.foreground,
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
        ),
      ),
    );
  }
}

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
    final visual = appNoticeVisualFor(AppNoticeLevel.danger);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: visual.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: visual.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(visual.icon, size: 18, color: visual.foreground),
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
