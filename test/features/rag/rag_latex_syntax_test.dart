import 'package:flutter_test/flutter_test.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:smartshrimp_app/features/rag/presentation/widgets/rag_latex_syntax.dart';

List<md.Element> elements(String text) {
  final document = md.Document(
    extensionSet: md.ExtensionSet.gitHubFlavored,
    inlineSyntaxes: [RagLatexInlineSyntax()],
    blockSyntaxes: const [RagLatexBlockSyntax()],
    encodeHtml: false,
  );
  final result = <md.Element>[];
  void visit(md.Node node) {
    if (node is md.Element) {
      result.add(node);
      node.children?.forEach(visit);
    }
  }

  document.parseLines(text.split('\n')).forEach(visit);
  return result;
}

List<md.Element> formulas(String text) => elements(text)
    .where(
      (node) => node.tag == ragInlineMathTag || node.tag == ragBlockMathTag,
    )
    .toList();

void main() {
  for (final text in [r'$x_1^2$', r'\(x_1^2\)', r'$$x_1^2$$', r'\[x_1^2\]']) {
    test('parses $text without Markdown interpreting formula content', () {
      final nodes = formulas('Text $text after');
      expect(nodes, hasLength(1));
      expect(nodes.single.textContent, 'x_1^2');
      expect(nodes.single.attributes['source'], text);
    });
  }

  for (final (open, close) in [(r'$$', r'$$'), (r'\[', r'\]')]) {
    test('multiline $open block retains LaTeX commands and line breaks', () {
      final latex =
          r'\begin{aligned}a &= b \\'
          '\n'
          r'c &= d\end{aligned}';
      final nodes = formulas('Before\n$open\n$latex\n$close\nAfter');
      expect(nodes, hasLength(1));
      expect(nodes.single.tag, ragBlockMathTag);
      expect(nodes.single.textContent, latex);
      expect(nodes.single.attributes['display'], 'true');
    });
  }

  test(
    'preserves Markdown headings, emphasis, lists, links and table cells',
    () {
      final nodes = elements(
        '# Title\n\n**Bold** and ${r'$x$'}\n\n'
        '- ${r'\(y\)'} in list\n\n[Link](https://example.com)\n\n'
        '| Value |\n| --- |\n| ${r'$z$'} |',
      );
      expect(
        nodes.map((node) => node.tag),
        containsAll(['h1', 'strong', 'li', 'a', 'td']),
      );
      expect(nodes.where((node) => node.tag == ragInlineMathTag), hasLength(3));
    },
  );

  test('does not render LaTeX inside inline, fenced or indented code', () {
    final text =
        r'`$x$` and `\(y\)`'
        '\n\n```tex\n'
        r'$$z$$'
        '\n```\n\n    '
        r'$w$';
    expect(formulas(text), isEmpty);
    expect(elements(text).where((node) => node.tag == 'code'), hasLength(4));
  });

  test('does not mistake prices or escaped dollar signs for formulas', () {
    expect(formulas(r'Price $5 and $10, then $20.'), isEmpty);
    expect(formulas(r'Literal \$x\$ and $ y $.'), isEmpty);
    expect(formulas(r'Price \$5; formula $x + y$.'), hasLength(1));
  });

  test('leaves incomplete or empty delimiters as ordinary Markdown', () {
    for (final text in [
      r'Price $5',
      r'\(x',
      r'$$x',
      r'\[x',
      r'$$$$',
      r'\(\)',
    ]) {
      expect(formulas(text), isEmpty, reason: text);
    }
  });

  test('display blocks work in blockquotes and list items', () {
    expect(formulas('> ${r'\['}\n> x\n> ${r'\]'}').single.tag, ragBlockMathTag);
    expect(formulas('- ${r'$$'}\n  x\n  ${r'$$'}').single.tag, ragBlockMathTag);
  });
}
