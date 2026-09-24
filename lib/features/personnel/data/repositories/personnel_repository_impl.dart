import 'package:smartshrimp_app/features/auth/domain/entities/auth_account.dart';
import 'package:smartshrimp_app/features/personnel/data/services/personnel_api_service.dart';
import 'package:smartshrimp_app/features/personnel/domain/entities/managed_personnel.dart';
import 'package:smartshrimp_app/features/personnel/domain/repositories/personnel_repository.dart';

final class PersonnelRepositoryImpl implements PersonnelRepository {
  PersonnelRepositoryImpl(this._remoteDataSource);

  final PersonnelRemoteDataSource _remoteDataSource;

  @override
  Future<ManagedPersonnelPage> getPersonnel({
    String? cursor,
    int limit = 20,
    AccountRole? role,
    AccountStatus? status,
    String? search,
  }) {
    final normalizedSearch = search?.trim();
    return _remoteDataSource.getPersonnel(<String, dynamic>{
      'limit': limit,
      'sortBy': 'identity',
      'sortOrder': 'asc',
      'cursor': ?cursor,
      if (role != null) 'role': _roleValue(role),
      if (status != null) 'status': _statusValue(status),
      if (normalizedSearch != null && normalizedSearch.isNotEmpty)
        'search': normalizedSearch,
    });
  }

  @override
  Future<ManagedPersonnel> getPersonnelById(String personnelId) =>
      _remoteDataSource.getPersonnelById(personnelId);

  static String _roleValue(AccountRole role) => switch (role) {
    AccountRole.technician => 'TECHNICIAN',
    AccountRole.expert => 'EXPERT',
    _ => throw ArgumentError.value(role, 'role', 'Unsupported personnel role'),
  };

  static String _statusValue(AccountStatus status) => switch (status) {
    AccountStatus.pendingActivation => 'PENDING_ACTIVATION',
    AccountStatus.active => 'ACTIVE',
    AccountStatus.inactive => 'INACTIVE',
    AccountStatus.blocked => 'BLOCKED',
    AccountStatus.unknown => throw ArgumentError.value(
      status,
      'status',
      'Unsupported account status',
    ),
  };
}
