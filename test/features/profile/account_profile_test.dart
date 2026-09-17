import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/auth/domain/entities/auth_account.dart';
import 'package:smartshrimp_app/features/profile/domain/entities/account_profile.dart';

void main() {
  test('parses a technician profile returned by the backend', () {
    final profile = AccountProfile.parse(<String, dynamic>{
      'id': 'account-1',
      'email': 'bao@smartshrimp.vn',
      'fullName': 'Cô Thái Bảo',
      'phone': '0912345678',
      'avatarUrl': 'https://res.cloudinary.com/demo/avatar.jpg',
      'role': 'TECHNICIAN',
      'status': 'ACTIVE',
      'managedByOwnerId': 'owner-1',
      'managedByOwner': <String, dynamic>{
        'id': 'owner-1',
        'email': 'owner@smartshrimp.vn',
        'fullName': 'Nguyễn Văn Chủ',
        'avatarUrl': null,
      },
      'technicianKpi': <String, dynamic>{
        'seasonsParticipated': 6,
        'completedTasks': 148,
        'onTimeCompletedTasks': 139,
        'onTimeCompletionRatePct': 93.92,
      },
      'activatedAt': '2024-11-01T00:00:00.000Z',
      'lastLoginAt': null,
      'createdAt': '2024-10-01T00:00:00.000Z',
      'updatedAt': '2026-09-11T00:00:00.000Z',
    });

    expect(profile.role, AccountRole.technician);
    expect(profile.status, AccountStatus.active);
    expect(profile.roleLabel, 'Kỹ thuật viên');
    expect(profile.displayName, 'Cô Thái Bảo');
    expect(profile.initials, 'CB');
    expect(profile.activatedAt, DateTime.utc(2024, 11));
    expect(profile.managedByOwner?.displayName, 'Nguyễn Văn Chủ');
    expect(profile.technicianKpi?.seasonsParticipated, 6);
    expect(profile.technicianKpi?.completedTasks, 148);
    expect(profile.technicianKpi?.onTimeCompletionRatePct, 93.92);
  });

  test('maps farm owner role and falls back to email when name is absent', () {
    final profile = AccountProfile.parse(<String, dynamic>{
      'id': 'owner-1',
      'email': 'owner@smartshrimp.vn',
      'fullName': null,
      'role': 'FARM_OWNER',
      'status': 'ACTIVE',
    });

    expect(profile.role, AccountRole.farmOwner);
    expect(profile.roleLabel, 'Chủ trang trại');
    expect(profile.displayName, 'owner@smartshrimp.vn');
    expect(profile.initials, 'O');
    expect(profile.managedByOwner, isNull);
    expect(profile.technicianKpi, isNull);
  });

  test('parses Farm Owner and Expert role-specific KPI contracts', () {
    final owner = AccountProfile.parse(<String, dynamic>{
      'id': 'owner-1',
      'email': 'owner@smartshrimp.vn',
      'role': 'FARM_OWNER',
      'status': 'ACTIVE',
      'farmOwnerKpi': <String, dynamic>{
        'farmsOwned': 2,
        'pondsManaged': 8,
        'activeSeasons': 3,
      },
    });
    final expert = AccountProfile.parse(<String, dynamic>{
      'id': 'expert-1',
      'email': 'expert@smartshrimp.vn',
      'role': 'EXPERT',
      'status': 'ACTIVE',
      'expertKpi': <String, dynamic>{
        'seasonsParticipated': 7,
        'diseaseCasesHandled': 12,
        'diseaseCasesResolved': 9,
        'avgResolutionHours': 18.5,
      },
    });

    expect(owner.farmOwnerKpi?.farmsOwned, 2);
    expect(owner.farmOwnerKpi?.pondsManaged, 8);
    expect(owner.farmOwnerKpi?.activeSeasons, 3);
    expect(expert.expertKpi?.seasonsParticipated, 7);
    expect(expert.expertKpi?.diseaseCasesHandled, 12);
    expect(expert.expertKpi?.diseaseCasesResolved, 9);
    expect(expert.expertKpi?.avgResolutionHours, 18.5);
  });

  test('generated copyWith can explicitly clear nullable profile fields', () {
    const profile = AccountProfile(
      id: 'account-1',
      email: 'owner@smartshrimp.vn',
      fullName: 'Chủ ao',
      phone: '0912345678',
      role: AccountRole.farmOwner,
      status: AccountStatus.active,
    );

    final cleared = profile.copyWith(phone: null);

    expect(cleared.phone, isNull);
    expect(profile.phone, '0912345678');
  });

  test('serializes nested Freezed models as backend-shaped JSON maps', () {
    const profile = AccountProfile(
      id: 'technician-1',
      email: 'technician@smartshrimp.vn',
      role: AccountRole.technician,
      status: AccountStatus.active,
      managedByOwner: ManagedOwner(
        id: 'owner-1',
        email: 'owner@smartshrimp.vn',
      ),
      technicianKpi: TechnicianKpi(
        seasonsParticipated: 2,
        completedTasks: 10,
        onTimeCompletedTasks: 9,
        onTimeCompletionRatePct: 90,
      ),
      expertKpi: ExpertKpi(
        seasonsParticipated: 7,
        diseaseCasesHandled: 12,
        diseaseCasesResolved: 9,
        avgResolutionHours: 18.5,
      ),
      farmOwnerKpi: FarmOwnerKpi(
        farmsOwned: 2,
        pondsManaged: 8,
        activeSeasons: 3,
      ),
    );

    final json = profile.toJson();

    expect(json['role'], 'TECHNICIAN');
    expect(json['status'], 'ACTIVE');
    expect(json['managedByOwner'], isA<Map<String, dynamic>>());
    expect(json['technicianKpi'], isA<Map<String, dynamic>>());
    expect(json['expertKpi'], isA<Map<String, dynamic>>());
    expect(json['farmOwnerKpi'], isA<Map<String, dynamic>>());
  });

  test('rejects malformed nested profile data at the parsing boundary', () {
    expect(
      () => AccountProfile.parse(<String, dynamic>{
        'id': 'account-1',
        'email': 'owner@smartshrimp.vn',
        'role': 'FARM_OWNER',
        'status': 'ACTIVE',
        'managedByOwner': <String, dynamic>{'id': 1},
      }),
      throwsA(isA<InvalidResponseException>()),
    );
  });
}
