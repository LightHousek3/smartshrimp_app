import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/features/rag/presentation/widgets/rag_answer_body.dart';

Future<void> pumpAnswer(
  WidgetTester tester,
  String text, {
  double scale = 1,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      home: MediaQuery(
        data: MediaQueryData(textScaler: TextScaler.linear(scale)),
        child: Scaffold(
          body: SingleChildScrollView(
            child: SizedBox(width: 280, child: RagAnswerBody(text: text)),
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('renders mixed Markdown with inline and display math', (
    tester,
  ) async {
    await pumpAnswer(
      tester,
      '**Oxy**: ${r'$C = \frac{m}{V}$'}.\n\n${r'\['}\n'
      r'\mathrm{pH} = -\log_{10}[H^+]'
      '\n${r'\]'}',
    );
    expect(find.byType(Math), findsNWidgets(2));
    final widgets = tester.widgetList<Math>(find.byType(Math));
    expect(
      widgets.map((widget) => widget.mathStyle),
      containsAll([MathStyle.text, MathStyle.display]),
    );
    expect(
      tester.widget<MarkdownBody>(find.byType(MarkdownBody)).selectable,
      isTrue,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('malformed LaTeX shows its source without crashing', (
    tester,
  ) async {
    const text = r'$\unknowncommand{x}$';
    await pumpAnswer(tester, text);
    expect(find.text(text), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  for (final scale in [1.0, 2.0]) {
    testWidgets('long formulas fit narrow screens at text scale $scale', (
      tester,
    ) async {
      final formula = List.generate(35, (i) => 'x_{$i}').join(' + ');
      await pumpAnswer(
        tester,
        '\$\$$formula\$\$\n\nInline \$$formula\$.',
        scale: scale,
      );
      expect(find.byType(Math), findsNWidgets(2));
      final scrolls = find.byWidgetPredicate(
        (widget) =>
            widget is SingleChildScrollView &&
            widget.scrollDirection == Axis.horizontal,
      );
      expect(scrolls, findsOneWidget);
      await tester.drag(scrolls, const Offset(-100, 0));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('code fences show literal delimiters', (tester) async {
    await pumpAnswer(tester, '```text\n${r'$x$ and \(y\)'}\n```');
    expect(find.byType(Math), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('math works in lists, bold text and table cells', (tester) async {
    await pumpAnswer(
      tester,
      '- **${r'\(x_1\)'}** in list\n\n'
      '| Value |\n| --- |\n| ${r'$\frac{a}{b}$'} |',
    );
    expect(find.byType(Math), findsNWidgets(2));
    expect(tester.takeException(), isNull);
  });
}
