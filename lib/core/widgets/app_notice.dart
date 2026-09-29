import 'package:flutter/material.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';

enum AppNoticeLevel { success, info, warning, danger }

@immutable
final class AppNoticeVisual {
  const AppNoticeVisual({
    required this.icon,
    required this.foreground,
    required this.background,
    required this.border,
  });

  final IconData icon;
  final Color foreground;
  final Color background;
  final Color border;
}

AppNoticeVisual appNoticeVisualFor(AppNoticeLevel level) => switch (level) {
  AppNoticeLevel.success => const AppNoticeVisual(
    icon: Icons.check_rounded,
    foreground: Color(0xFF168A7A),
    background: Color(0xFFE5F8F5),
    border: Color(0xFF8BE1D5),
  ),
  AppNoticeLevel.info => const AppNoticeVisual(
    icon: Icons.info_outline_rounded,
    foreground: AppColors.ocean,
    background: Color(0xFFEAF4FF),
    border: Color(0xFFB8D9F5),
  ),
  AppNoticeLevel.warning => const AppNoticeVisual(
    icon: Icons.warning_amber_rounded,
    foreground: Color(0xFFB66B08),
    background: Color(0xFFFFF3DB),
    border: Color(0xFFF0CD91),
  ),
  AppNoticeLevel.danger => const AppNoticeVisual(
    icon: Icons.error_outline_rounded,
    foreground: AppColors.error,
    background: Color(0xFFFDEBED),
    border: Color(0xFFF2B8C2),
  ),
};

String appNoticeDefaultTitle(AppNoticeLevel level) => switch (level) {
  AppNoticeLevel.success => 'Thành công',
  AppNoticeLevel.info => 'Thông tin',
  AppNoticeLevel.warning => 'Cảnh báo',
  AppNoticeLevel.danger => 'Có lỗi xảy ra',
};

abstract final class AppNoticeService {
  static ScaffoldMessengerState? _activeMessenger;

  static void show(
    BuildContext context, {
    required String title,
    String? message,
    AppNoticeLevel level = AppNoticeLevel.info,
    SnackBarAction? action,
    Duration? duration,
  }) {
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
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        padding: EdgeInsets.zero,
        duration:
            duration ??
            (level == AppNoticeLevel.danger || level == AppNoticeLevel.warning
                ? const Duration(seconds: 5)
                : const Duration(milliseconds: 3800)),
        content: Align(
          alignment: Alignment.bottomCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: _AppNoticeCard(
              title: title,
              message: message,
              level: level,
              action: action,
              onActionPressed: () {
                action?.onPressed();
                messenger.hideCurrentSnackBar();
              },
            ),
          ),
        ),
      ),
    );
    controller.closed.whenComplete(() {
      if (identical(_activeMessenger, messenger)) _activeMessenger = null;
    });
  }

  static void success(BuildContext context, String message, {String? title}) =>
      show(
        context,
        title: title ?? appNoticeDefaultTitle(AppNoticeLevel.success),
        message: message,
        level: AppNoticeLevel.success,
      );

  static void info(BuildContext context, String message, {String? title}) =>
      show(
        context,
        title: title ?? appNoticeDefaultTitle(AppNoticeLevel.info),
        message: message,
        level: AppNoticeLevel.info,
      );

  static void warning(BuildContext context, String message, {String? title}) =>
      show(
        context,
        title: title ?? appNoticeDefaultTitle(AppNoticeLevel.warning),
        message: message,
        level: AppNoticeLevel.warning,
      );

  static void danger(BuildContext context, String message, {String? title}) =>
      show(
        context,
        title: title ?? appNoticeDefaultTitle(AppNoticeLevel.danger),
        message: message,
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
    required this.action,
    required this.onActionPressed,
  });

  final String title;
  final String? message;
  final AppNoticeLevel level;
  final SnackBarAction? action;
  final VoidCallback onActionPressed;

  @override
  Widget build(BuildContext context) {
    final visual = appNoticeVisualFor(level);
    final normalizedMessage = message?.trim();
    return Semantics(
      liveRegion: true,
      label: normalizedMessage == null ? title : '$title. $normalizedMessage',
      child: Container(
        key: ValueKey<String>('app_notice_${level.name}'),
        constraints: const BoxConstraints(minHeight: 60),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFEFD),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: visual.border),
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: Color(0x1A16243A),
              blurRadius: 22,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: <Widget>[
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: visual.background,
                borderRadius: BorderRadius.circular(11),
              ),
              child: Icon(visual.icon, color: visual.foreground, size: 18),
            ),
            const SizedBox(width: 11),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.ink,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w800,
                      height: 1.2,
                    ),
                  ),
                  if (normalizedMessage != null &&
                      normalizedMessage.isNotEmpty) ...<Widget>[
                    const SizedBox(height: 4),
                    Text(
                      normalizedMessage,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.inkSoft,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        height: 1.32,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (action != null) ...<Widget>[
              const SizedBox(width: 6),
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: visual.foreground,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  visualDensity: VisualDensity.compact,
                ),
                onPressed: onActionPressed,
                child: Text(action!.label),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
