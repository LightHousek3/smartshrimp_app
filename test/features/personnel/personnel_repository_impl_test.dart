import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/features/auth/domain/entities/auth_account.dart';
import 'package:smartshrimp_app/features/personnel/data/repositories/personnel_repository_impl.dart';
import 'package:smartshrimp_app/features/personnel/data/services/personnel_api_service.dart';
import 'package:smartshrimp_app/features/personnel/domain/entities/managed_personnel.dart';

void main() {
  test('normalizes and maps list filters to the backend contract', () async {
    final remote = _FakePersonnelRemoteDataSource();
    final repository = PersonnelRepositoryImpl(remote);

    await repository.getPersonnel(
      cursor: 'cursor-1',
      limit: 100,
      role: AccountRole.expert,
      status: AccountStatus.pendingActivation,
      search: '  chuyên gia  ',
    );

    expect(remote.lastQuery, <String, dynamic>{
      'limit': 100,
      'sortBy': 'identity',
      'sortOrder': 'asc',
      'cursor': 'cursor-1',
      'role': 'EXPERT',
      'status': 'PENDING_ACTIVATION',
      'search': 'chuyên gia',
    });
  });

  test('omits empty optional filters and forwards detail ids', () async {
    final remote = _FakePersonnelRemoteDataSource();
    final repository = PersonnelRepositoryImpl(remote);

    await repository.getPersonnel(search: '   ');
    await repository.getPersonnelById('personnel-1');

    expect(remote.lastQuery, <String, dynamic>{
      'limit': 20,
      'sortBy': 'identity',
      'sortOrder': 'asc',
    });
    expect(remote.lastPersonnelId, 'personnel-1');
  });
}

final _personnel = ManagedPersonnel(
  id: 'personnel-1',
  email: 'technician@smartshrimp.vn',
  role: AccountRole.technician,
  status: AccountStatus.active,
  currentSeasonAssignments: 0,
  createdAt: _createdAt,
);
final _createdAt = DateTime(2026, 9, 1);

final class _FakePersonnelRemoteDataSource
    implements PersonnelRemoteDataSource {
  Map<String, dynamic>? lastQuery;
  String? lastPersonnelId;

  @override
  Future<ManagedPersonnelPage> getPersonnel(Map<String, dynamic> query) async {
    lastQuery = query;
    return ManagedPersonnelPage(
      items: <ManagedPersonnel>[_personnel],
      limit: 20,
      totalResults: 1,
      hasNextPage: false,
    );
  }

  @override
  Future<ManagedPersonnel> getPersonnelById(String personnelId) async {
    lastPersonnelId = personnelId;
    return _personnel;
  }
}
