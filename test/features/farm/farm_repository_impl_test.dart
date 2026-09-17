import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/features/farm/data/repositories/farm_repository_impl.dart';
import 'package:smartshrimp_app/features/farm/data/services/farm_api_service.dart';
import 'package:smartshrimp_app/features/farm/domain/entities/farm.dart';

void main() {
  late _FakeFarmRemoteDataSource remote;
  late FarmRepositoryImpl repository;

  setUp(() {
    remote = _FakeFarmRemoteDataSource();
    repository = FarmRepositoryImpl(remote);
  });

  test(
    'normalizes create payload and explicitly clears optional fields',
    () async {
      await repository.createFarm(
        name: '  Trại   Cà Mau  ',
        address: '   ',
        totalAreaHectares: null,
      );

      expect(remote.lastData, <String, dynamic>{
        'name': 'Trại Cà Mau',
        'address': null,
        'totalAreaHectares': null,
      });
    },
  );

  test('loads the complete farm collection without query concerns', () async {
    final farms = await repository.getFarms();

    expect(remote.getCalls, 1);
    expect(farms, const <Farm>[_farm]);
  });
}

const _farm = Farm(id: 'farm-1', ownerId: 'owner-1', name: 'Trại Cà Mau');

final class _FakeFarmRemoteDataSource implements FarmRemoteDataSource {
  Map<String, dynamic>? lastData;
  int getCalls = 0;

  @override
  Future<Farm> archiveFarm(String farmId) async => _farm;

  @override
  Future<Farm> createFarm(Map<String, dynamic> data) async {
    lastData = data;
    return _farm;
  }

  @override
  Future<Farm> getFarm(String farmId) async => _farm;

  @override
  Future<List<Farm>> getFarms() async {
    getCalls++;
    return const <Farm>[_farm];
  }

  @override
  Future<Farm> restoreFarm(String farmId) async => _farm;

  @override
  Future<Farm> updateFarm(String farmId, Map<String, dynamic> data) async {
    lastData = data;
    return _farm;
  }
}
