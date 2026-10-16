import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartshrimp_app/app/router/app_router.dart';
import 'package:smartshrimp_app/core/di/core_providers.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/auth/domain/entities/auth_account.dart';
import 'package:smartshrimp_app/features/auth/presentation/view_models/auth_controller.dart';
import 'package:smartshrimp_app/features/notifications/domain/entities/app_notification.dart';
import 'package:smartshrimp_app/features/notifications/presentation/widgets/notification_visuals.dart';

final notificationReferenceContextProvider = FutureProvider.autoDispose
    .family<Map<String, String>, String>((ref, notificationId) async {
      if (ref.watch(
            authControllerProvider.select((state) => state.value?.id),
          ) ==
          null) {
        throw const SessionExpiredException();
      }
      final response = await ref
          .read(apiClientProvider)
          .get(
            '/notifications/${Uri.encodeComponent(notificationId)}/reference-context',
            authenticated: true,
          );
      final data = response.requireMapData();
      final result = <String, String>{};
      for (final key in [
        'farmId',
        'pondId',
        'seasonId',
        'productId',
        'scheduleId',
      ]) {
        final value = data[key];
        if (value != null && (value is! String || value.trim().isEmpty)) {
          throw const InvalidResponseException();
        }
        if (value is String) result[key] = value.trim();
      }
      return result;
    }, retry: (_, _) => null);

String notificationReferenceType(AppNotification notification) =>
    notification.referenceType?.trim().toLowerCase() ?? '';

bool notificationNeedsReferenceContext(
  AppNotification notification,
  AccountRole? role,
) {
  if (notification.referenceId?.trim().isNotEmpty != true) return false;
  return switch (notificationReferenceType(notification)) {
    'product' => role == AccountRole.farmOwner,
    'season' || 'aquaculture_season' => role == AccountRole.farmOwner,
    'pond' ||
    'water_log' ||
    'water_quality_log' ||
    'operation_schedule' ||
    'operation_execution' ||
    'protocol' ||
    'production_protocol' ||
    'treatment_protocol' ||
    'disease_case' => role != null,
    _ => false,
  };
}

String? notificationDestination(
  AppNotification notification,
  AccountRole? role, {
  Map<String, String> referenceContext = const {},
}) {
  if (role == null) return null;
  final owner = role == AccountRole.farmOwner;
  final id = notification.referenceId?.trim();
  final reference = notificationReferenceType(notification);
  String? segment(String key) {
    final value = referenceContext[key]?.trim();
    return value == null || value.isEmpty ? null : Uri.encodeComponent(value);
  }

  final farmId = segment('farmId');
  final pondId = segment('pondId');
  final seasonId = segment('seasonId');
  final scheduleId = segment('scheduleId');
  String? seasonDestination() => owner
      ? farmId != null && pondId != null && seasonId != null
            ? '${AppRoutes.farms}/$farmId/ponds/$pondId/seasons/$seasonId'
            : null
      : seasonId != null
      ? '${AppRoutes.seasons}/$seasonId'
      : null;

  if (notification.type == NotificationType.managedAccountActivated && owner) {
    return reference == 'account' && id != null && id.isNotEmpty
        ? '${AppRoutes.personnel}/${Uri.encodeComponent(id)}'
        : AppRoutes.personnel;
  }
  if (id != null && id.isNotEmpty) {
    final encodedId = Uri.encodeComponent(id);
    switch (reference) {
      case 'product':
        return owner && farmId != null && segment('productId') != null
            ? '${AppRoutes.farms}/$farmId/inventory/${segment('productId')}'
            : null;
      case 'farm':
        if (!owner) return AppRoutes.seasons;
        return notification.type == NotificationType.inventoryLow ||
                notification.type == NotificationType.inventoryInsufficient
            ? '${AppRoutes.farms}/$encodedId/inventory'
            : '${AppRoutes.farms}/$encodedId';
      case 'pond':
        return owner && farmId != null && pondId != null
            ? '${AppRoutes.farms}/$farmId/ponds/$pondId'
            : seasonDestination();
      case 'season':
      case 'aquaculture_season':
        return owner ? seasonDestination() : '${AppRoutes.seasons}/$encodedId';
      case 'water_log':
      case 'water_quality_log':
        return role == AccountRole.technician && seasonId != null
            ? '${AppRoutes.seasons}/$seasonId/water-logs'
            : seasonDestination();
      case 'operation_schedule':
      case 'operation_execution':
        return role == AccountRole.technician &&
                seasonId != null &&
                scheduleId != null
            ? '${AppRoutes.seasons}/$seasonId/operations/$scheduleId'
            : seasonDestination();
      case 'protocol':
      case 'production_protocol':
      case 'treatment_protocol':
        return owner
            ? seasonId != null
                  ? '/protocols/$encodedId'
                  : null
            : seasonDestination();
      case 'disease_case':
        // Clinical case details are not implemented in the mobile router yet.
        return seasonDestination();
      case 'task':
        return AppRoutes.tasks;
      case 'account':
        return owner ? '${AppRoutes.personnel}/$encodedId' : AppRoutes.account;
    }
  }
  return switch (notification.type) {
    NotificationType.taskAssigned ||
    NotificationType.taskUpdated ||
    NotificationType.taskDueSoon ||
    NotificationType.taskOverdue ||
    NotificationType.taskCompleted => AppRoutes.tasks,
    NotificationType.inventoryLow || NotificationType.inventoryInsufficient
        when owner && !notificationNeedsReferenceContext(notification, role) =>
      AppRoutes.farms,
    NotificationType.accountStatusChanged when !owner => AppRoutes.account,
    _ => null,
  };
}

String notificationActionLabel(
  AppNotification notification,
  AccountRole? role,
) => switch (notificationReferenceType(notification)) {
  'pond' => role == AccountRole.farmOwner ? 'Xem ao' : 'Xem vụ nuôi',
  'farm'
      when notification.type != NotificationType.inventoryLow &&
          notification.type != NotificationType.inventoryInsufficient =>
    'Xem trang trại',
  'operation_schedule' || 'operation_execution' =>
    role == AccountRole.technician ? 'Xem hoạt động' : 'Xem vụ nuôi',
  'water_log' || 'water_quality_log' =>
    role == AccountRole.technician ? 'Xem nhật ký nước' : 'Xem vụ nuôi',
  'protocol' || 'production_protocol' || 'treatment_protocol' =>
    role == AccountRole.farmOwner ? 'Xem phác đồ' : 'Xem vụ nuôi',
  'disease_case' => 'Xem vụ nuôi',
  'account' when role != AccountRole.farmOwner => 'Xem tài khoản',
  _ => NotificationVisuals.actionLabel(notification.type),
};
