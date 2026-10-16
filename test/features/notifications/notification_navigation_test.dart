import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/features/auth/domain/entities/auth_account.dart';
import 'package:smartshrimp_app/features/notifications/domain/entities/app_notification.dart';
import 'package:smartshrimp_app/features/notifications/presentation/notification_navigation.dart';

AppNotification notice(
  String? reference, {
  NotificationType type = NotificationType.system,
  String? id = 'resource',
}) => AppNotification(
  id: 'notification',
  title: 'Thông báo',
  type: type,
  referenceType: reference,
  referenceId: id,
  createdAt: DateTime(2026),
);
const context = {
  'farmId': 'farm',
  'pondId': 'pond',
  'seasonId': 'season',
  'productId': 'product',
  'scheduleId': 'schedule',
};

void main() {
  for (final reference in [
    'protocol',
    'production_protocol',
    'treatment_protocol',
  ]) {
    test(
      'Owner $reference opens the protocol after resolving accessible context',
      () {
        final n = notice(reference, id: 'protocol/id?version=2');
        expect(
          notificationNeedsReferenceContext(n, AccountRole.farmOwner),
          isTrue,
        );
        expect(
          notificationDestination(
            n,
            AccountRole.farmOwner,
            referenceContext: context,
          ),
          '/protocols/protocol%2Fid%3Fversion%3D2',
        );
        expect(notificationDestination(n, AccountRole.farmOwner), isNull);
        expect(
          notificationActionLabel(n, AccountRole.farmOwner),
          'Xem phác đồ',
        );
      },
    );
  }
  test('owner inventory notification opens the referenced product', () {
    final n = notice('PRODUCT', type: NotificationType.inventoryLow);
    expect(notificationNeedsReferenceContext(n, AccountRole.farmOwner), isTrue);
    expect(
      notificationDestination(
        n,
        AccountRole.farmOwner,
        referenceContext: context,
      ),
      '/farms/farm/inventory/product',
    );
    expect(notificationDestination(n, AccountRole.farmOwner), isNull);
    expect(
      notificationDestination(
        n,
        AccountRole.technician,
        referenceContext: context,
      ),
      isNull,
    );
  });
  test('legacy farm inventory references still open that farm inventory', () {
    expect(
      notificationDestination(
        notice('farm', type: NotificationType.inventoryLow),
        AccountRole.farmOwner,
      ),
      '/farms/resource/inventory',
    );
  });
  test('owner pond references open pond details, not a generic farm list', () {
    final n = notice(' POND ');
    expect(
      notificationDestination(
        n,
        AccountRole.farmOwner,
        referenceContext: context,
      ),
      '/farms/farm/ponds/pond',
    );
    expect(notificationActionLabel(n, AccountRole.farmOwner), 'Xem ao');
    expect(
      notificationDestination(
        n,
        AccountRole.technician,
        referenceContext: context,
      ),
      '/seasons/season',
    );
  });
  test('season references follow owner and assigned-personnel routes', () {
    final n = notice('aquaculture_season');
    expect(
      notificationDestination(
        n,
        AccountRole.farmOwner,
        referenceContext: context,
      ),
      '/farms/farm/ponds/pond/seasons/season',
    );
    expect(
      notificationDestination(n, AccountRole.technician),
      '/seasons/resource',
    );
    expect(notificationDestination(n, AccountRole.expert), '/seasons/resource');
    expect(
      notificationNeedsReferenceContext(n, AccountRole.technician),
      isFalse,
    );
  });
  test('water alerts resolve from a water log to an accessible season', () {
    final n = notice(
      'water_quality_log',
      type: NotificationType.waterThresholdExceeded,
    );
    expect(
      notificationDestination(
        n,
        AccountRole.technician,
        referenceContext: context,
      ),
      '/seasons/season/water-logs',
    );
    expect(
      notificationDestination(
        n,
        AccountRole.farmOwner,
        referenceContext: context,
      ),
      '/farms/farm/ponds/pond/seasons/season',
    );
    expect(notificationDestination(n, AccountRole.farmOwner), isNull);
  });
  test(
    'technician insufficient-stock notification opens the operation it blocked',
    () {
      final n = notice(
        'operation_schedule',
        type: NotificationType.inventoryInsufficient,
      );
      expect(
        notificationDestination(
          n,
          AccountRole.technician,
          referenceContext: context,
        ),
        '/seasons/season/operations/schedule',
      );
      expect(
        notificationActionLabel(n, AccountRole.technician),
        'Xem hoạt động',
      );
      expect(
        notificationDestination(
          n,
          AccountRole.farmOwner,
          referenceContext: context,
        ),
        '/farms/farm/ponds/pond/seasons/season',
      );
    },
  );
  for (final type in [
    NotificationType.taskAssigned,
    NotificationType.taskUpdated,
    NotificationType.taskDueSoon,
    NotificationType.taskOverdue,
    NotificationType.taskCompleted,
  ]) {
    test('${type.name} opens the existing tasks tab', () {
      expect(
        notificationDestination(
          notice(null, type: type, id: null),
          AccountRole.technician,
        ),
        '/tasks',
      );
    });
  }
  test('protocol and disease notifications use the existing season screen', () {
    for (final reference in ['protocol', 'disease_case']) {
      final n = notice(reference);
      expect(
        notificationDestination(
          n,
          AccountRole.technician,
          referenceContext: context,
        ),
        '/seasons/season',
      );
      expect(notificationActionLabel(n, AccountRole.technician), 'Xem vụ nuôi');
    }
  });
  test(
    'personnel activation preserves both detail and missing-reference fallback',
    () {
      expect(
        notificationDestination(
          notice('account', type: NotificationType.managedAccountActivated),
          AccountRole.farmOwner,
        ),
        '/personnel/resource',
      );
      expect(
        notificationDestination(
          notice(
            null,
            type: NotificationType.managedAccountActivated,
            id: null,
          ),
          AccountRole.farmOwner,
        ),
        '/personnel',
      );
    },
  );
  test('account changes for technicians go to their own account', () {
    expect(
      notificationDestination(
        notice('account', type: NotificationType.accountStatusChanged),
        AccountRole.technician,
      ),
      '/account',
    );
  });
  test('unknown targets and signed-out users cannot navigate', () {
    expect(
      notificationDestination(notice('future_resource'), AccountRole.farmOwner),
      isNull,
    );
    expect(
      notificationDestination(
        notice('product'),
        null,
        referenceContext: context,
      ),
      isNull,
    );
  });
  test('reference IDs are encoded as route segments', () {
    expect(
      notificationDestination(
        notice('account', id: 'staff/id?x=1'),
        AccountRole.farmOwner,
      ),
      '/personnel/staff%2Fid%3Fx%3D1',
    );
  });
}
