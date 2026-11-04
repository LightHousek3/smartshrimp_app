import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/core/widgets/gradient_button.dart';
import 'package:smartshrimp_app/features/protocol/domain/entities/protocol.dart';
import 'package:smartshrimp_app/features/protocol/presentation/widgets/protocol_materials.dart';
import 'protocol_fixtures.dart';
import 'protocol_pages_test.dart' as harness;

void main() {
  testWidgets(
    'V2: 1000 preserved items render in bounded pages without catalog requests',
    (tester) async {
      final detail = ProtocolDetail.parse({
        ...detailJson(),
        'contentVersion': 2,
        'materialReviews': List.generate(
          1000,
          (index) => {
            ...materialReviewJson(),
            'itemId': 'item-$index',
            'name': 'Feed $index',
          },
        ),
      });
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: ProtocolMaterials(detail: detail),
            ),
          ),
        ),
      );
      expect(detail.materialReviews, hasLength(1000));
      expect(find.byType(ExpansionTile), findsNWidgets(20));
      expect(find.text('Feed 0'), findsOneWidget);
      await tester.ensureVisible(find.text('Tiếp'));
      await tester.tap(find.text('Tiếp'));
      await tester.pumpAndSettle();
      expect(find.text('Feed 20'), findsOneWidget);
      expect(find.text('Feed 0'), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'V2: unresolved proposal disables confirmation; reject remains available without catalog queries',
    (tester) async {
      final repository = ProtocolFixtureRepository(v2: true);
      await harness.open(tester, repository: repository);
      await harness.scrollTo(tester, 'Phê duyệt phác đồ');
      await tester.tap(find.text('Phê duyệt phác đồ'));
      await tester.pumpAndSettle();
      await harness.scrollTo(tester, 'Xác nhận duyệt');
      expect(
        tester
            .widget<GradientButton>(
              find.widgetWithText(GradientButton, 'Xác nhận duyệt'),
            )
            .onPressed,
        isNull,
      );
      expect(repository.reviewCalls, 0);
      expect(repository.materialOptionsCalls, 0);
      await tester.tap(find.text('Xem lại'));
      await tester.pumpAndSettle();
      expect(find.text('Từ chối và nêu lý do'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'V2: selecting a reviewed catalog shows both evidence snapshots and sends the resolution',
    (tester) async {
      final repository = ProtocolFixtureRepository(v2: true);
      await harness.open(
        tester,
        repository: repository,
        size: const Size(320, 900),
      );
      await harness.scrollTo(tester, 'Feed đề xuất');
      await tester.tap(find.text('Feed đề xuất'));
      await tester.pumpAndSettle();
      await harness.scrollTo(tester, 'Chọn catalog đủ điều kiện');
      await tester.tap(find.text('Chọn catalog đủ điều kiện'));
      await tester.pumpAndSettle();
      expect(repository.materialOptionsCalls, 1);
      await tester.tap(find.text('Catalog Feed'));
      await tester.pumpAndSettle();
      await harness.scrollTo(tester, 'Vật tư Owner chọn để thực thi');
      expect(find.text('Mô tả gốc'), findsOneWidget);
      expect(
        find.text('Nguồn hồ sơ: https://example.test/catalog'),
        findsOneWidget,
      );
      await harness.scrollTo(tester, 'Phê duyệt phác đồ');
      await tester.tap(find.text('Phê duyệt phác đồ'));
      await tester.pumpAndSettle();
      await harness.scrollTo(tester, 'Xác nhận duyệt');
      await tester.tap(find.text('Xác nhận duyệt'));
      await tester.pumpAndSettle();
      expect(repository.reviewCalls, 1);
      expect(repository.selectedMaterials, {'item-1': 'catalog-1'});
      expect(repository.reviewedContentVersion, 2);
      expect(tester.takeException(), isNull);
    },
  );
}
