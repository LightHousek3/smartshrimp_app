import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/pond/data/repositories/pond_repository_impl.dart';
import 'package:smartshrimp_app/features/pond/data/services/pond_api_service.dart';
import 'package:smartshrimp_app/features/pond/domain/entities/pond.dart';

void main() {
  test('creation retains dimensions and omits an unspecified volume', () async {
    final remote = _RecordingRemote();
    await PondRepositoryImpl(remote).createPond(
      farmId: 'farm',
      name: '  Ao   1 ',
      areaM2: 1000,
      depthM: 1.5,
      type: PondType.aquaculture,
      status: PondStatus.available,
    );
    expect(remote.operation, 'create');
    expect(remote.farmId, 'farm');
    expect(remote.data, {
      'name': 'Ao 1',
      'areaM2': 1000,
      'depthM': 1.5,
      'type': 'AQUACULTURE',
      'status': 'AVAILABLE',
    });
  });

  for (final volume in <double?>[null, 0.01, 1400, 1500]) {
    test('update volume=$volume excludes immutable dimensions', () async {
      final remote = _RecordingRemote();
      await PondRepositoryImpl(remote).updatePond(
        farmId: 'farm',
        pondId: 'pond',
        name: '  Ao   1 ',
        volumeM3: volume,
        type: PondType.aquaculture,
        status: PondStatus.available,
      );
      expect(remote.operation, 'update');
      expect(remote.farmId, 'farm');
      expect(remote.pondId, 'pond');
      expect(remote.data, {
        'name': 'Ao 1',
        'volumeM3': ?volume,
        'type': 'AQUACULTURE',
        'status': 'AVAILABLE',
      });
    });
  }

  test('update preserves backend error message and status', () async {
    final error = const ApiException('Capacity exceeded', statusCode: 400);
    final remote = _RecordingRemote()..error = error;
    await expectLater(
      PondRepositoryImpl(remote).updatePond(
        farmId: 'farm',
        pondId: 'pond',
        name: 'Ao',
        volumeM3: 1600,
        type: PondType.aquaculture,
        status: PondStatus.available,
      ),
      throwsA(same(error)),
    );
  });
}

final class _RecordingRemote implements PondRemoteDataSource {
  String? operation;
  String? farmId;
  String? pondId;
  Map<String, dynamic>? data;
  AppException? error;

  @override
  Future<Pond> createPond(String farmId, Map<String, dynamic> data) async {
    operation = 'create';
    this.farmId = farmId;
    this.data = data;
    return _pond;
  }

  @override
  Future<Pond> updatePond(
    String farmId,
    String pondId,
    Map<String, dynamic> data,
  ) async {
    operation = 'update';
    this.farmId = farmId;
    this.pondId = pondId;
    this.data = data;
    if (error != null) throw error!;
    return _pond;
  }

  static const _pond = Pond(
    id: 'pond',
    farmId: 'farm',
    name: 'Ao',
    type: PondType.aquaculture,
    status: PondStatus.available,
  );

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
