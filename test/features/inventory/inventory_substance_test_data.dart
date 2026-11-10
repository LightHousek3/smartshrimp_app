import 'package:smartshrimp_app/features/inventory/domain/entities/inventory_substance.dart';
import 'package:smartshrimp_app/features/inventory/domain/repositories/inventory_substance_repository.dart';

InventorySubstance testSubstance(
  String id,
  String name, {
  String status = 'listed',
}) => InventorySubstance(
  id: id,
  name: name,
  status: status,
  group: 'Vi sinh vật',
  appendix: status == 'listed' ? 'II' : 'I',
  sourceRow: '4',
  page: 11,
  note: name,
);

class FakeInventorySubstanceRepository implements InventorySubstanceRepository {
  final searches = <({String query, String? cursor})>[];
  final checks = <String>[];
  Future<InventorySubstancePage> Function(String query, String? cursor)?
  onSearch;
  Future<InventorySubstanceCheck> Function(String text)? onCheck;

  @override
  Future<InventorySubstancePage> search({
    required String farmId,
    required String query,
    String? cursor,
  }) async {
    searches.add((query: query, cursor: cursor));
    if (onSearch != null) return onSearch!(query, cursor);
    return const InventorySubstancePage(items: [], hasNextPage: false);
  }

  @override
  Future<InventorySubstanceCheck> check({
    required String farmId,
    required String ingredientsText,
  }) async {
    checks.add(ingredientsText);
    if (onCheck != null) return onCheck!(ingredientsText);
    return InventorySubstanceCheck(
      status: ingredientsText.contains('Chloramphenicol')
          ? 'blocked'
          : 'not_detected',
      message: ingredientsText.contains('Chloramphenicol')
          ? 'Phát hiện chất cấm: Chloramphenicol trong sản phẩm.'
          : 'Chưa phát hiện tên chất cấm trong nội dung đã nhập.',
    );
  }
}
