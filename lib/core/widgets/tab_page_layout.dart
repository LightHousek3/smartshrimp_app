import 'package:flutter/material.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/widgets/app_gradient_background.dart';

/// Keep tab headers fixed while the header and body share one background.
class TabPageLayout extends StatelessWidget {
  const TabPageLayout({
    required this.title,
    required this.child,
    this.subtitle,
    this.trailing,
    this.headerBottom,
    super.key,
  });

  final String title;
  final String? subtitle;
  final Widget? trailing;
  final Widget? headerBottom;
  final Widget child;

  @override
  Widget build(BuildContext context) => AppGradientBackground(
    child: SafeArea(
      bottom: false,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 28, 16, 8),
            child: LayoutBuilder(
              builder: (context, constraints) => Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style:
                              AppTypography.display(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                color: AppColors.ink,
                                height: 1.25,
                                letterSpacing: -.55,
                              ).copyWith(
                                fontFamilyFallback: const ['PlusJakartaSans'],
                              ),
                        ),
                        const SizedBox(height: 2),
                        // Reserve a subtitle line while dashboard data is loading.
                        Text(
                          subtitle ?? '',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13,
                            height: 1.5,
                            color: AppColors.inkSoft,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (trailing != null) ...[
                    const SizedBox(width: 8),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: constraints.maxWidth * .45,
                      ),
                      child: trailing!,
                    ),
                  ],
                ],
              ),
            ),
          ),
          ?headerBottom,
          Expanded(child: child),
        ],
      ),
    ),
  );
}
