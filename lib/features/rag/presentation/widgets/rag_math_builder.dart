import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:markdown/markdown.dart' as md;

class RagMathBuilder extends MarkdownElementBuilder {
  RagMathBuilder({required this.block, required this.style});

  final bool block;
  final TextStyle style;

  @override
  bool isBlockElement() => block;

  @override
  Widget visitElementAfterWithContext(
    BuildContext context,
    md.Element element,
    TextStyle? preferredStyle,
    TextStyle? parentStyle,
  ) {
    final textStyle = preferredStyle ?? parentStyle ?? style;
    final fontSize = textStyle.fontSize ?? 13;
    final formula = Math.tex(
      element.textContent,
      mathStyle: element.attributes['display'] == 'true'
          ? MathStyle.display
          : MathStyle.text,
      textStyle: textStyle,
      textScaleFactor:
          MediaQuery.textScalerOf(context).scale(fontSize) / fontSize,
      onErrorFallback: (_) =>
          Text(element.attributes['source']!, style: textStyle),
    );
    final content = block
        ? SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: formula,
          )
        : FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: formula,
          );
    return Semantics(
      label: 'Công thức: ${element.textContent}',
      child: ExcludeSemantics(child: content),
    );
  }
}
