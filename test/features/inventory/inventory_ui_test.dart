import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/widgets/destructive_action_button.dart';
import 'package:smartshrimp_app/core/widgets/sticky_page_header.dart';
import 'package:smartshrimp_app/features/inventory/presentation/widgets/inventory_ui.dart';

void main() {
  Widget app(Widget child) => MaterialApp(
    theme: AppTheme.light,
    home: Scaffold(body: Center(child: child)),
  );

  testWidgets('surface uses standard card styling without changing padding', (
    tester,
  ) async {
    await tester.pumpWidget(
      app(const InventorySurface(child: SizedBox(width: 200, height: 40))),
    );
    final container = tester.widget<Container>(
      find.descendant(
        of: find.byType(InventorySurface),
        matching: find.byType(Container),
      ),
    );
    final decoration = container.decoration! as BoxDecoration;
    expect(container.padding, const EdgeInsets.all(16));
    expect(decoration.color, Colors.white);
    expect(decoration.borderRadius, BorderRadius.circular(16));
    expect(decoration.border, Border.all(color: AppColors.line));
    expect(decoration.boxShadow!.single.offset, const Offset(0, 2));
    // The existing one-pixel border contributes to the outer extent.
    expect(tester.getSize(find.byType(InventorySurface)), const Size(234, 74));
  });

  test('inputs match the app form borders and readable error typography', () {
    final decoration = inventoryInputDecoration();
    final focusedBorder = decoration.focusedBorder! as OutlineInputBorder;
    expect(focusedBorder.borderRadius, BorderRadius.circular(12));
    expect(focusedBorder.borderSide.color, AppColors.oceanLight);
    expect(focusedBorder.borderSide.width, 1.5);
    expect(decoration.hintStyle!.fontSize, 14);
    expect(decoration.errorStyle!.fontSize, 12);
    expect(inventoryInputTextStyle.fontSize, 14);
    expect(
      decoration.contentPadding,
      const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    );
  });

  testWidgets(
    'header keeps its size and uses the shared title and icon colors',
    (tester) async {
      var backPressed = false;
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: InventoryPageFrame(
            title: 'Kho vật tư',
            onBack: () => backPressed = true,
            child: const SizedBox.expand(),
          ),
        ),
      );
      expect(tester.getSize(find.byType(PageHeaderBar)).height, 76);
      final titleStyle = tester.widget<Text>(find.text('Kho vật tư')).style!;
      expect(titleStyle.fontFamily, startsWith('Sora'));
      expect(titleStyle.color, AppColors.ink);
      expect(titleStyle.fontWeight, FontWeight.w700);
      expect(
        tester.widget<SvgPicture>(find.byType(SvgPicture)).colorFilter,
        const ColorFilter.mode(AppColors.inkSoft, BlendMode.srcIn),
      );
      await tester.tap(find.byType(InkResponse));
      expect(backPressed, isTrue);
    },
  );

  testWidgets('primary button keeps its height and shows disabled styling', (
    tester,
  ) async {
    var presses = 0;
    Widget button(VoidCallback? onPressed) => app(
      SizedBox(
        width: 300,
        child: InventoryGradientButton(
          label: 'Lưu vật tư',
          iconAsset: InventoryAssets.save,
          onPressed: onPressed,
        ),
      ),
    );
    await tester.pumpWidget(button(() => presses++));
    expect(
      tester.getSize(find.byType(InventoryGradientButton)),
      const Size(300, 45),
    );
    final decoration =
        tester
                .widget<DecoratedBox>(
                  find.descendant(
                    of: find.byType(InventoryGradientButton),
                    matching: find.byType(DecoratedBox),
                  ),
                )
                .decoration
            as BoxDecoration;
    expect(decoration.borderRadius, BorderRadius.circular(16));
    expect((decoration.gradient! as LinearGradient).colors, <Color>[
      AppColors.oceanLight,
      AppColors.tealLight,
      AppColors.oceanLight,
    ]);
    await tester.tap(find.text('Lưu vật tư'));
    expect(presses, 1);

    await tester.pumpWidget(button(null));
    await tester.tap(find.text('Lưu vật tư'));
    expect(presses, 1);
    final disabledDecoration =
        tester
                .widget<DecoratedBox>(
                  find.descendant(
                    of: find.byType(InventoryGradientButton),
                    matching: find.byType(DecoratedBox),
                  ),
                )
                .decoration
            as BoxDecoration;
    expect(
      (disabledDecoration.gradient! as LinearGradient).colors,
      const <Color>[Color(0xFFBAC6D1), Color(0xFFBAC6D1)],
    );
    expect(disabledDecoration.boxShadow, isNull);
  });

  testWidgets('archive uses the shared action style and preserves its height', (
    tester,
  ) async {
    var pressed = false;
    await tester.pumpWidget(
      app(
        SizedBox(
          width: 300,
          child: InventoryDangerButton(
            label: 'Lưu trữ vật tư',
            onPressed: () => pressed = true,
          ),
        ),
      ),
    );
    expect(find.byType(DestructiveActionButton), findsOneWidget);
    expect(
      tester.getSize(find.byType(InventoryDangerButton)),
      const Size(300, 46),
    );
    await tester.tap(find.text('Lưu trữ vật tư'));
    expect(pressed, isTrue);
  });

  testWidgets('filter chips use app box styling and keep selection behavior', (
    tester,
  ) async {
    bool? selection;
    await tester.pumpWidget(
      app(
        InventoryFilterChip(
          label: 'Đang dùng',
          selected: true,
          onSelected: (value) => selection = value,
        ),
      ),
    );
    final chip = tester.widget<ChoiceChip>(find.byType(ChoiceChip));
    expect(chip.selectedColor, const Color(0xFFEAF4FF));
    expect(chip.labelStyle!.fontSize, 12);
    expect(chip.showCheckmark, isFalse);
    expect(chip.labelStyle!.height, 1.25);
    expect((chip.label as Text).textAlign, TextAlign.center);
    expect(
      (chip.shape! as RoundedRectangleBorder).borderRadius,
      BorderRadius.circular(12),
    );
    await tester.tap(find.text('Đang dùng'));
    expect(selection, isFalse);
  });
}
