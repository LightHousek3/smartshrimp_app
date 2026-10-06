import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';

class RagAnswerBody extends StatelessWidget {
  const RagAnswerBody({required this.text, super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    final body = Theme.of(context).textTheme.bodyMedium!.copyWith(
      color: AppColors.inkSoft,
      fontSize: 13,
      letterSpacing: 0,
      height: 1.625,
    );
    final heading = body.copyWith(
      color: AppColors.ink,
      fontSize: 14,
      fontWeight: FontWeight.w700,
    );
    return MarkdownBody(
      data: text,
      selectable: true,
      styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
        p: body,
        listBullet: body,
        h1: heading,
        h2: heading,
        h3: heading,
        h4: heading,
        h5: heading,
        h6: heading,
        strong: body.copyWith(fontWeight: FontWeight.w700),
        em: body.copyWith(fontStyle: FontStyle.italic),
        blockSpacing: 8,
        horizontalRuleDecoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.line)),
        ),
      ),
    );
  }
}
