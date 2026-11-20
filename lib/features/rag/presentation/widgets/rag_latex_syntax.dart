import 'package:markdown/markdown.dart' as md;

const ragInlineMathTag = 'rag-math-inline';
const ragBlockMathTag = 'rag-math-block';

bool _escaped(String source, int offset) {
  var backslashes = 0;
  for (var i = offset - 1; i >= 0 && source[i] == r'\'; i--) {
    backslashes++;
  }
  return backslashes.isOdd;
}

int _closing(String source, String delimiter, int start) {
  var offset = source.indexOf(delimiter, start);
  while (offset >= 0) {
    if (!_escaped(source, offset)) return offset;
    offset = source.indexOf(delimiter, offset + delimiter.length);
  }
  return -1;
}

md.Element _mathElement(
  String tag,
  String latex,
  String source,
  bool display,
) => md.Element.text(tag, latex.trim())
  ..attributes['source'] = source
  ..attributes['display'] = '$display';

/// Runs inside Markdown parsing, so code spans/fences remain literal.
class RagLatexInlineSyntax extends md.InlineSyntax {
  RagLatexInlineSyntax() : super(r'\$\$|\$|\\\(|\\\[');

  @override
  bool onMatch(md.InlineParser parser, Match match) {
    final opening = match[0]!;
    final closing = switch (opening) {
      r'\(' => r'\)',
      r'\[' => r'\]',
      _ => opening,
    };
    final display = opening == r'$$' || opening == r'\[';
    final start = match.end;
    var end = _closing(parser.source, closing, start);
    if (opening == r'$') {
      // Avoid treating ordinary prices such as "$5 and $10" as an equation.
      while (end >= 0 &&
          end + 1 < parser.source.length &&
          RegExp(r'[0-9$]').hasMatch(parser.source[end + 1])) {
        end = _closing(parser.source, closing, end + 1);
      }
    }
    final latex = end < 0 ? '' : parser.source.substring(start, end);
    final valid =
        latex.trim().isNotEmpty &&
        (display || !latex.contains('\n')) &&
        (opening != r'$' || latex == latex.trim());
    if (!valid) {
      parser.addNode(md.Text(opening));
      return true;
    }
    final after = end + closing.length;
    parser.addNode(
      _mathElement(
        ragInlineMathTag,
        latex,
        parser.source.substring(match.start, after),
        display,
      ),
    );
    parser.consume(after - match.start);
    return false;
  }
}

/// Recognizes complete display blocks, including inside lists and blockquotes.
class RagLatexBlockSyntax extends md.BlockSyntax {
  const RagLatexBlockSyntax();

  @override
  RegExp get pattern => RegExp(r'^ {0,3}(\$\$|\\\[)');

  ({int lines, String latex, String source})? _read(md.BlockParser parser) {
    final opening = pattern.firstMatch(parser.current.content);
    if (opening == null) return null;
    final closing = opening[1] == r'$$' ? r'$$' : r'\]';
    final parts = <String>[];
    final source = <String>[];
    for (var i = 0; ; i++) {
      final line = parser.peek(i)?.content;
      if (line == null) return null;
      source.add(line);
      final content = i == 0 ? line.substring(opening.end) : line;
      final end = _closing(content, closing, 0);
      if (end < 0) {
        parts.add(content);
        continue;
      }
      if (content.substring(end + closing.length).trim().isNotEmpty) {
        return null;
      }
      parts.add(content.substring(0, end));
      final latex = parts.join('\n').trim();
      if (latex.isEmpty) return null;
      return (lines: i + 1, latex: latex, source: source.join('\n'));
    }
  }

  @override
  bool canParse(md.BlockParser parser) => _read(parser) != null;

  @override
  md.Node parse(md.BlockParser parser) {
    final block = _read(parser)!;
    for (var i = 0; i < block.lines; i++) {
      parser.advance();
    }
    return _mathElement(ragBlockMathTag, block.latex, block.source, true);
  }
}
