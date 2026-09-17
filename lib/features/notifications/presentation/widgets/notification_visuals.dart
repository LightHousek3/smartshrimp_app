import 'package:flutter/material.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/features/notifications/domain/entities/app_notification.dart';

final class NotificationVisuals {
  const NotificationVisuals._();

  static String label(NotificationType type) => switch (type) {
    NotificationType.taskAssigned ||
    NotificationType.taskUpdated ||
    NotificationType.taskDueSoon ||
    NotificationType.taskOverdue ||
    NotificationType.taskCompleted => 'Nhiệm vụ',
    NotificationType.operationDue ||
    NotificationType.operationOverdue ||
    NotificationType.operationCancelled ||
    NotificationType.scheduleGenerationFailed => 'Lịch vận hành',
    NotificationType.waterThresholdExceeded => 'Môi trường',
    NotificationType.diseaseCaseCreated ||
    NotificationType.diseaseCaseResponse ||
    NotificationType.diseaseCaseWaitingInfo ||
    NotificationType.diseaseCaseMonitoring ||
    NotificationType.diseaseCaseResolved ||
    NotificationType.emergencyCaseUpdate => 'Sức khỏe ao nuôi',
    NotificationType.productionProtocolPending ||
    NotificationType.productionProtocolReviewed => 'Quy trình sản xuất',
    NotificationType.treatmentProtocolPending ||
    NotificationType.treatmentProtocolReviewed ||
    NotificationType.treatmentProtocolAborted ||
    NotificationType.treatmentScheduleReady ||
    NotificationType.treatmentScheduleCompleted => 'Phác đồ điều trị',
    NotificationType.inventoryLow ||
    NotificationType.inventoryInsufficient => 'Kho vật tư',
    NotificationType.seasonAssignmentCreated ||
    NotificationType.seasonAssignmentReplaced ||
    NotificationType.seasonStatusChanged ||
    NotificationType.harvestDue ||
    NotificationType.seasonCompleted => 'Vụ nuôi',
    NotificationType.managedAccountActivated ||
    NotificationType.accountStatusChanged => 'Tài khoản',
    NotificationType.system || NotificationType.unknown => 'Hệ thống',
  };

  static IconData icon(NotificationType type) => switch (type) {
    NotificationType.taskAssigned ||
    NotificationType.taskUpdated ||
    NotificationType.taskDueSoon ||
    NotificationType.taskOverdue ||
    NotificationType.taskCompleted => Icons.assignment_outlined,
    NotificationType.operationDue ||
    NotificationType.operationOverdue ||
    NotificationType.operationCancelled ||
    NotificationType.scheduleGenerationFailed => Icons.event_note_rounded,
    NotificationType.waterThresholdExceeded => Icons.water_drop_outlined,
    NotificationType.diseaseCaseCreated ||
    NotificationType.diseaseCaseResponse ||
    NotificationType.diseaseCaseWaitingInfo ||
    NotificationType.diseaseCaseMonitoring ||
    NotificationType.diseaseCaseResolved ||
    NotificationType.emergencyCaseUpdate => Icons.health_and_safety_outlined,
    NotificationType.inventoryLow ||
    NotificationType.inventoryInsufficient => Icons.inventory_2_outlined,
    NotificationType.seasonAssignmentCreated ||
    NotificationType.seasonAssignmentReplaced ||
    NotificationType.seasonStatusChanged ||
    NotificationType.harvestDue ||
    NotificationType.seasonCompleted => Icons.spa_outlined,
    NotificationType.managedAccountActivated ||
    NotificationType.accountStatusChanged => Icons.person_outline_rounded,
    NotificationType.system ||
    NotificationType.unknown => Icons.notifications_none_rounded,
    _ => Icons.medical_services_outlined,
  };

  static Color color(NotificationType type) => switch (type) {
    NotificationType.operationOverdue ||
    NotificationType.taskOverdue ||
    NotificationType.waterThresholdExceeded ||
    NotificationType.emergencyCaseUpdate ||
    NotificationType.inventoryInsufficient => const Color(0xFFC24A54),
    NotificationType.operationDue ||
    NotificationType.taskDueSoon ||
    NotificationType.harvestDue ||
    NotificationType.inventoryLow => const Color(0xFFB66A21),
    NotificationType.diseaseCaseResolved ||
    NotificationType.taskCompleted ||
    NotificationType.seasonCompleted ||
    NotificationType.treatmentScheduleCompleted => const Color(0xFF16806B),
    _ => AppColors.ocean,
  };

  static String shortTime(DateTime value, DateTime now) {
    final local = value.toLocal();
    final difference = now.difference(local);
    if (!difference.isNegative) {
      if (difference.inMinutes < 1) {
        return 'Vừa xong';
      }
      if (difference.inMinutes < 60) {
        return '${difference.inMinutes} phút trước';
      }
      if (difference.inHours < 24) {
        return '${difference.inHours} giờ trước';
      }
    }
    return '${_two(local.day)}/${_two(local.month)}/${local.year}';
  }

  static String fullTime(DateTime value) {
    final local = value.toLocal();
    return '${_two(local.hour)}:${_two(local.minute)} · '
        '${_two(local.day)}/${_two(local.month)}/${local.year}';
  }

  static String _two(int value) => value.toString().padLeft(2, '0');
}
