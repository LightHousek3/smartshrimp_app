import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/auth/domain/entities/auth_account.dart';
import 'package:smartshrimp_app/features/personnel/domain/entities/managed_personnel.dart';

void main() {
  test('parses list and detail personnel projections', () {
    final listItem = ManagedPersonnel.parse(_personnelJson());
    final detail = ManagedPersonnel.parse(
      _personnelJson(
        updatedAt: '2026-09-22T08:30:00.000Z',
        activatedAt: '2026-09-02T08:30:00.000Z',
      ),
      detail: true,
    );

    expect(listItem.role, AccountRole.technician);
    expect(listItem.status, AccountStatus.active);
    expect(listItem.displayName, 'Nguyễn Văn Kỹ Thuật');
    expect(listItem.initials, 'NT');
    expect(listItem.currentSeasonAssignments, 2);
    expect(detail.updatedAt, DateTime.utc(2026, 9, 22, 8, 30));
    expect(detail.activatedAt, DateTime.utc(2026, 9, 2, 8, 30));
  });

  test('uses safe enum fallbacks for future backend values', () {
    final personnel = ManagedPersonnel.parse(
      _personnelJson(role: 'NEW_ROLE', status: 'NEW_STATUS'),
    );

    expect(personnel.role, AccountRole.unknown);
    expect(personnel.status, AccountStatus.unknown);
  });

  test('rejects malformed required fields and invalid assignment counts', () {
    expect(
      () => ManagedPersonnel.parse(_personnelJson(id: 1)),
      throwsA(isA<InvalidResponseException>()),
    );
    expect(
      () => ManagedPersonnel.parse(_personnelJson(assignments: -1)),
      throwsA(isA<InvalidResponseException>()),
    );
    expect(
      () => ManagedPersonnel.parse(_personnelJson(), detail: true),
      throwsA(isA<InvalidResponseException>()),
    );
  });

  test('validates cursor pagination metadata', () {
    final page = ManagedPersonnelPage.parse(
      <Object?>[_personnelJson()],
      {
        'limit': 20,
        'totalResults': 21,
        'hasNextPage': true,
        'nextCursor': 'personnel-1',
      },
    );

    expect(page.items, hasLength(1));
    expect(page.nextCursor, 'personnel-1');
    expect(
      () => ManagedPersonnelPage.parse(<Object?>[], {
        'limit': 20,
        'totalResults': 21,
        'hasNextPage': true,
        'nextCursor': null,
      }),
      throwsA(isA<InvalidResponseException>()),
    );
  });
}

Map<String, dynamic> _personnelJson({
  Object id = 'personnel-1',
  String role = 'TECHNICIAN',
  String status = 'ACTIVE',
  int assignments = 2,
  String? activatedAt,
  String? updatedAt,
}) => <String, dynamic>{
  'id': id,
  'email': 'technician@smartshrimp.vn',
  'phone': '0912345678',
  'fullName': 'Nguyễn Văn Kỹ Thuật',
  'avatarUrl': null,
  'role': role,
  'status': status,
  'currentSeasonAssignments': assignments,
  'createdAt': '2026-09-01T08:30:00.000Z',
  'lastLoginAt': null,
  'activatedAt': ?activatedAt,
  'updatedAt': ?updatedAt,
};
