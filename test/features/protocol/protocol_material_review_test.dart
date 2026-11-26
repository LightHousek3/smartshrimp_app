import 'package:smartshrimp_app/core/widgets/app_image_viewer.dart';
import 'package:smartshrimp_app/features/inventory/presentation/widgets/inventory_product_image.dart';
import 'package:smartshrimp_app/features/inventory/presentation/widgets/inventory_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/core/widgets/gradient_button.dart';
import 'package:smartshrimp_app/features/protocol/domain/entities/protocol.dart';
import 'package:smartshrimp_app/features/protocol/presentation/widgets/protocol_audit.dart';
import 'package:smartshrimp_app/features/protocol/presentation/widgets/protocol_decision.dart';
import 'package:smartshrimp_app/features/protocol/presentation/widgets/protocol_materials.dart';
import 'package:smartshrimp_app/features/protocol/presentation/pages/protocol_detail_page.dart';
import 'protocol_fixtures.dart';
import 'protocol_pages_test.dart' as harness;

class _AnchoredTreatmentRepository extends ProtocolFixtureRepository {
  _AnchoredTreatmentRepository() : super(type: 'TREATMENT');
  @override
  Future<ProtocolDetail> detail(String id) async => (await super.detail(
    id,
  )).copyWith(treatmentStartAt: DateTime.parse('2027-11-29T17:00:00Z'));
}

class _MaterialListRepository extends ProtocolFixtureRepository {
  @override
  Future<ProtocolDetail> detail(String id) async {
    final detail = await super.detail(id);
    final row = ProtocolMaterialReview.fromJson(materialReviewJson());
    return detail.copyWith(
      materialReviews: [
        row.copyWith(
          name: 'Doxycycline 98%',
          operationType: 'MEDICINE',
          proposed: row.proposed!.copyWith(
            name: 'Doxycycline 98%',
            category: 'MEDICINE',
            unit: 'G',
            manufacturer: const ProtocolManufacturer(
              name: 'Công ty thuốc thủy sản An Phát',
            ),
          ),
        ),
        row.copyWith(
          itemId: 'item-2',
          name: 'Men tiêu hóa Bio-Gut Pro',
          productId: 'product-2',
          requiresResolution: false,
          proposed: const ProtocolMaterialSnapshot(
            name: 'Men tiêu hóa Bio-Gut Pro',
            category: 'OTHER',
            unit: 'PACK',
            recommendationReason: 'Bổ sung men tiêu hóa trong cữ sáng.',
            manufacturer: ProtocolManufacturer(name: 'Bio-Gut Việt Nam'),
          ),
          catalog: const ProtocolMaterialSnapshot(
            name: 'Men tiêu hóa Bio-Gut Pro',
            category: 'OTHER',
            unit: 'PACK',
            manufacturer: ProtocolManufacturer(name: 'Bio-Gut Việt Nam'),
          ),
        ),
        row.copyWith(
          itemId: 'item-3',
          name: 'Yucca liquid (khử khí độc)',
          operationType: 'CHEMICAL',
          productId: 'product-3',
          requiresResolution: false,
          proposed: null,
          catalog: const ProtocolMaterialSnapshot(
            name: 'Yucca liquid (khử khí độc)',
            category: 'CHEMICAL',
            unit: 'L',
            manufacturer: ProtocolManufacturer(name: 'Thủy sản Xanh'),
          ),
        ),
        row.copyWith(
          itemId: 'item-4',
          name: 'Chế phẩm xử lý nước',
          proposed: row.proposed!.copyWith(
            name: 'Chế phẩm xử lý nước',
            category: 'CHEMICAL',
            unit: 'L',
            recommendationReason:
                'Sử dụng theo chất lượng nước thực tế và hướng dẫn trên nhãn sản phẩm.',
            manufacturer: const ProtocolManufacturer(
              name: 'Công ty TNHH Chế phẩm Thủy sản Việt Nam',
            ),
          ),
        ),
      ],
    );
  }
}

class _CreationRepository extends ProtocolFixtureRepository {
  _CreationRepository() : super(v2: true);
  bool created = false;
  @override
  Future<ProtocolDetail> detail(String id) async {
    final result = await super.detail(id);
    return created
        ? result.copyWith(
            materialReviews: result.materialReviews
                .map(
                  (row) => row.copyWith(
                    productId: 'created-product',
                    requiresResolution: false,
                  ),
                )
                .toList(),
          )
        : result;
  }
}

class _CatalogueOnlyRepository extends ProtocolFixtureRepository {
  _CatalogueOnlyRepository({required super.type});

  @override
  Future<ProtocolDetail> detail(String id) async {
    final detail = await super.detail(id);
    return detail.copyWith(
      materialReviews: detail.materialReviews
          .map((row) => row.copyWith(proposed: null))
          .toList(),
    );
  }
}

void main() {
  for (final type in ['PRODUCTION', 'TREATMENT']) {
    testWidgets('$type catalogue-only protocols omit the proposal card', (
      tester,
    ) async {
      await harness.open(
        tester,
        repository: _CatalogueOnlyRepository(type: type),
      );
      expect(find.byType(ProtocolMaterials), findsNothing);
      expect(find.text('Vật tư đề xuất bởi chuyên gia'), findsNothing);
      expect(find.text('Lịch theo từng cữ'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets(
    'mixed protocols show only proposals and retain those already created',
    (tester) async {
      final detail = await _MaterialListRepository().detail('protocol-1');
      await harness.open(
        tester,
        page: Scaffold(
          body: SingleChildScrollView(child: ProtocolMaterials(detail: detail)),
        ),
        size: const Size(320, 900),
      );
      expect(find.text('3 vật tư'), findsNothing);
      expect(find.text('2/3 cần xử lý'), findsOneWidget);
      expect(find.text('Yucca liquid (khử khí độc)'), findsNothing);
      expect(find.text('Men tiêu hóa Bio-Gut Pro'), findsOneWidget);
      expect(find.text('Đã tạo vật tư'), findsOneWidget);
      expect(find.text('Tạo vật tư'), findsNWidgets(2));
      expect(
        tester.getCenter(find.text('Vật tư đề xuất bởi chuyên gia')).dy,
        tester.getCenter(find.text('2/3 cần xử lý')).dy,
      );
      expect(
        tester.getTopLeft(find.text('Chưa tạo vật tư').first).dy,
        tester.getTopLeft(find.text('Doxycycline 98%')).dy + 3,
      );
      expect(
        tester.getTopLeft(find.text('Thuốc · g')).dy,
        tester.getTopLeft(find.text('NSX: Công ty thuốc thủy sản An Phát')).dy,
      );
      expect(
        tester.getTopLeft(find.text('Chưa tạo vật tư').first).dx,
        tester.getTopLeft(find.text('NSX: Công ty thuốc thủy sản An Phát')).dx,
      );
      expect(
        tester
            .getTopLeft(find.byKey(const ValueKey('create-proposal-item-1')))
            .dy,
        tester.getTopLeft(find.text('Doxycycline 98%')).dy,
      );
      expect(
        tester.getTopLeft(find.text('NSX: Công ty thuốc thủy sản An Phát')).dx,
        closeTo(tester.getCenter(find.byType(ProtocolMaterials)).dx, 1),
      );
      expect(
        tester.getTopLeft(find.text('Đã tạo vật tư')).dx,
        tester.getTopLeft(find.text('Chưa tạo vật tư').first).dx,
      );
      final title = tester.widget<Text>(find.text('Doxycycline 98%'));
      expect(title.maxLines, 1);
      expect(title.overflow, TextOverflow.ellipsis);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'both proposals created in this review remain visible without create actions',
    (tester) async {
      final detail = ProtocolDetail.parse(detailJson());
      final accepted = detail.materialReviews.first;
      await harness.open(
        tester,
        page: Scaffold(
          body: ProtocolMaterials(
            detail: detail.copyWith(
              materialReviews: [
                accepted,
                accepted.copyWith(
                  itemId: 'second-proposal',
                  productId: 'second-product',
                  proposed: accepted.proposed!.copyWith(
                    name: 'Vật tư đề xuất thứ hai',
                  ),
                ),
              ],
            ),
          ),
        ),
        size: const Size(320, 700),
      );
      expect(find.text('0/2 cần xử lý'), findsOneWidget);
      expect(find.text('Đã tạo vật tư'), findsNWidgets(2));
      expect(find.text('Tạo vật tư'), findsNothing);
      expect(find.text('Vật tư đề xuất thứ hai'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('an empty material list has no proposal surface', (tester) async {
    await harness.open(
      tester,
      page: Scaffold(
        body: ProtocolMaterials(
          detail: ProtocolDetail.parse(
            detailJson(),
          ).copyWith(materialReviews: []),
        ),
      ),
    );
    expect(find.text('Vật tư đề xuất bởi chuyên gia'), findsNothing);
    expect(find.byType(InventoryProductImage), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('catalogue meals do not hide a proposal for the same product', (
    tester,
  ) async {
    final detail = ProtocolDetail.parse(detailJson());
    final accepted = detail.materialReviews.first;
    await harness.open(
      tester,
      page: Scaffold(
        body: ProtocolMaterials(
          detail: detail.copyWith(
            materialReviews: [
              accepted.copyWith(itemId: 'catalogue-meal', proposed: null),
              accepted,
              accepted.copyWith(itemId: 'repeated-proposal-meal'),
            ],
          ),
        ),
      ),
    );
    expect(find.text('0/1 cần xử lý'), findsOneWidget);
    expect(find.text('Feed đề xuất'), findsOneWidget);
    expect(find.text('Đã tạo vật tư'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'proposal label photos take priority over catalogue photos and open the shared gallery',
    (tester) async {
      final base = ProtocolDetail.parse(detailJson());
      final row = base.materialReviews.first;
      final detail = base.copyWith(
        materialReviews: [
          row.copyWith(
            proposed: row.proposed!.copyWith(
              imageUrls: [
                'https://example.test/expert-front.jpg',
                'https://example.test/expert-back.jpg',
              ],
            ),
            catalog: row.proposed!.copyWith(
              imageUrls: ['https://example.test/catalogue.jpg'],
            ),
          ),
        ],
      );
      await harness.open(
        tester,
        page: Scaffold(
          body: SingleChildScrollView(child: ProtocolMaterials(detail: detail)),
        ),
        size: const Size(320, 700),
      );
      final photo = tester.widget<InventoryProductImage>(
        find.byType(InventoryProductImage),
      );
      expect(photo.url, 'https://example.test/expert-front.jpg');
      expect(find.byType(InventorySvgIcon), findsNothing);
      await tester.tap(
        find.byKey(ValueKey('protocol_material_photo_${row.itemId}')),
      );
      await tester.pumpAndSettle();
      expect(
        tester.widget<AppImageViewer>(find.byType(AppImageViewer)).itemCount,
        2,
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'missing photos use a neutral placeholder and keep the proposal list compact',
    (tester) async {
      final detail = ProtocolDetail.parse(detailJson());
      await harness.open(
        tester,
        page: Scaffold(
          body: SingleChildScrollView(child: ProtocolMaterials(detail: detail)),
        ),
        size: const Size(320, 700),
      );
      expect(find.text('Chưa có ảnh'), findsOneWidget);
      expect(find.byType(InventorySvgIcon), findsNothing);
      expect(
        tester.getSize(find.byType(ProtocolMaterials)).height,
        lessThan(230),
      );
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'creating a proposal returns to the same protocol, refreshes readiness and enables approval',
    (tester) async {
      final repository = _CreationRepository();
      ProtocolMaterialCreation? captured;
      final router = GoRouter(
        routes: [
          GoRoute(
            path: '/',
            builder: (_, state) =>
                const ProtocolDetailPage(protocolId: 'protocol-1'),
          ),
          GoRoute(
            path: '/farms/:farmId/inventory/new',
            builder: (context, state) {
              captured = state.extra as ProtocolMaterialCreation;
              return Scaffold(
                body: TextButton(
                  onPressed: () {
                    repository.created = true;
                    context.pop(true);
                  },
                  child: const Text('Save proposed material'),
                ),
              );
            },
          ),
        ],
      );
      addTearDown(router.dispose);
      await harness.open(
        tester,
        repository: repository,
        page: MaterialApp.router(routerConfig: router),
      );
      await harness.scrollTo(tester, 'Tạo vật tư');
      await tester.tap(find.text('Tạo vật tư'));
      await tester.pumpAndSettle();
      expect(captured?.protocolId, 'protocol-1');
      expect(captured?.itemId, 'item-1');
      expect(captured?.farmId, 'farm-1');
      expect(captured?.material.name, 'Feed đề xuất');
      await tester.tap(find.text('Save proposed material'));
      await tester.pumpAndSettle();
      expect(find.text('Đã tạo vật tư'), findsOneWidget);
      await harness.scrollTo(tester, 'Phê duyệt phác đồ');
      expect(
        tester
            .widget<GradientButton>(
              find.widgetWithText(GradientButton, 'Phê duyệt phác đồ'),
            )
            .onPressed,
        isNotNull,
      );
      expect(repository.materialOptionsCalls, 0);
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets('material proposals visual review at mobile width', (
    tester,
  ) async {
    await harness.open(
      tester,
      repository: _MaterialListRepository(),
      page: const RepaintBoundary(
        key: Key('proposal-screen'),
        child: ProtocolDetailPage(protocolId: 'protocol-1'),
      ),
    );
    await tester.ensureVisible(find.byType(ProtocolMaterials));
    await tester.pumpAndSettle();
    expect(find.text('Doxycycline 98%'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
  testWidgets('a waiting treatment keeps approval and rejection available', (
    tester,
  ) async {
    final repo = _AnchoredTreatmentRepository();
    await harness.open(tester, repository: repo, size: const Size(320, 900));
    await harness.scrollTo(tester, 'Phê duyệt phác đồ');
    expect(
      tester
          .widget<GradientButton>(
            find.widgetWithText(GradientButton, 'Phê duyệt phác đồ'),
          )
          .onPressed,
      isNotNull,
    );
    await tester.tap(find.text('Từ chối và nêu lý do'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('protocol_rejection_reason')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
  testWidgets(
    'treatment confirmation uses the Expert anchor instead of the approval date',
    (tester) async {
      await harness.open(
        tester,
        repository: _AnchoredTreatmentRepository(),
        size: const Size(320, 900),
      );
      await harness.scrollTo(tester, 'Phê duyệt phác đồ');
      await tester.tap(find.text('Phê duyệt phác đồ'));
      await tester.pumpAndSettle();
      expect(
        find.descendant(
          of: find.byType(ProtocolDecision),
          matching: find.textContaining('00:00 30/11/2027'),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: find.byType(ProtocolAudit),
          matching: find.text('Ngày bắt đầu do Chuyên gia chỉ định'),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: find.byType(ProtocolAudit),
          matching: find.text('00:00 30/11/2027'),
        ),
        findsOneWidget,
      );
      expect(find.text('Ngày Chủ trại phê duyệt'), findsNothing);
      expect(
        find.textContaining('Ngày duyệt hôm nay trở thành ngày 1'),
        findsNothing,
      );
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'repeated meals show one material proposal without catalogue requests',
    (tester) async {
      final detail = ProtocolDetail.parse({
        ...detailJson(),
        'materialReviews': List.generate(
          1000,
          (index) => {...materialReviewJson(), 'itemId': 'item-$index'},
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
      expect(find.text('Feed đề xuất'), findsOneWidget);
      expect(find.byType(ExpansionTile), findsNothing);
      expect(find.textContaining('Vật tư và căn cứ'), findsNothing);
      expect(protocolMaterialGroups(detail).single, hasLength(1000));
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'uncreated proposal disables approval immediately; rejection stays available',
    (tester) async {
      final repository = ProtocolFixtureRepository(v2: true);
      await harness.open(tester, repository: repository);
      await harness.scrollTo(tester, 'Cần xử lý 1 vật tư');
      expect(
        tester
            .widget<GradientButton>(
              find.widgetWithText(GradientButton, 'Cần xử lý 1 vật tư'),
            )
            .onPressed,
        isNull,
      );
      expect(repository.materialOptionsCalls, 0);
      await tester.tap(find.text('Từ chối và nêu lý do'));
      await tester.pumpAndSettle();
      expect(
        find.byKey(const Key('protocol_rejection_reason')),
        findsOneWidget,
      );
      expect(repository.reviewCalls, 0);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'material proposals render before the day timeline without expansion tiles',
    (tester) async {
      await harness.open(
        tester,
        repository: ProtocolFixtureRepository(v2: true),
        size: const Size(320, 900),
      );
      await harness.scrollTo(tester, 'Tạo vật tư');
      expect(find.text('Chưa tạo vật tư'), findsOneWidget);
      expect(find.byType(ExpansionTile), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );
}
