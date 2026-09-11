import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/features/auth/domain/entities/auth_user.dart';
import 'package:smartshrimp_app/features/profile/domain/entities/user_profile.dart';

void main() {
  test('parses a technician profile returned by the backend', () {
    final profile = UserProfile.fromJson(<String, dynamic>{
      'id': 'user-1',
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

    expect(profile.role, AppUserRole.technician);
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
    final profile = UserProfile.fromJson(<String, dynamic>{
      'id': 'owner-1',
      'email': 'owner@smartshrimp.vn',
      'fullName': null,
      'role': 'FARM_OWNER',
      'status': 'ACTIVE',
    });

    expect(profile.role, AppUserRole.farmOwner);
    expect(profile.roleLabel, 'Chủ trang trại');
    expect(profile.displayName, 'owner@smartshrimp.vn');
    expect(profile.initials, 'O');
    expect(profile.managedByOwner, isNull);
    expect(profile.technicianKpi, isNull);
  });
}
