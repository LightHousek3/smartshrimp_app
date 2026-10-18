import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/farm/domain/entities/farm.dart';
import 'package:smartshrimp_app/features/farm/domain/repositories/farm_repository.dart';

/// Farm API boundary for inventory context and navigation widget tests.
class FarmContextRepository implements FarmRepository {
  FarmContextRepository({this.names = const {'farm-1': 'Trang trại Cà Mau'}});
  final Map<String, String> names;
  final List<String> requestedIds = [];
  Object? error;

  Farm _farm(String id) => Farm(id: id, ownerId: 'owner', name: names[id]!);

  @override
  Future<Farm> getFarm(String farmId) async {
    requestedIds.add(farmId);
    if (error != null) throw error!;
    if (!names.containsKey(farmId)) {
      throw const ApiException('Không tìm thấy trang trại.', statusCode: 404);
    }
    return _farm(farmId);
  }

  @override
  Future<List<Farm>> getFarms() async => names.keys.map(_farm).toList();

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}
