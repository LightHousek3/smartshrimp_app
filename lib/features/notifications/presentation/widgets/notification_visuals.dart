import 'package:flutter/material.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/features/notifications/domain/entities/app_notification.dart';

final class NotificationVisuals {
  const NotificationVisuals._();

  static String label(NotificationType type) => switch (type) {
    NotificationType.waterThresholdExceeded ||
    NotificationType.scheduleGenerationFailed => 'Cảnh báo sớm',
    NotificationType.operationDue ||
    NotificationType.operationOverdue ||
    NotificationType.operationCancelled => 'Vận hành',
    NotificationType.diseaseCaseCreated ||
    NotificationType.diseaseCaseResponse ||
    NotificationType.diseaseCaseWaitingInfo ||
    NotificationType.diseaseCaseMonitoring ||
    NotificationType.diseaseCaseResolved ||
    NotificationType.emergencyCaseUpdate => 'Ca bệnh',
    NotificationType.taskAssigned ||
    NotificationType.taskUpdated ||
    NotificationType.taskDueSoon ||
    NotificationType.taskOverdue ||
    NotificationType.taskCompleted => 'Nhiệm vụ',
    NotificationType.productionProtocolPending ||
    NotificationType.productionProtocolReviewed ||
    NotificationType.treatmentProtocolPending ||
    NotificationType.treatmentProtocolReviewed ||
    NotificationType.treatmentProtocolAborted ||
    NotificationType.treatmentScheduleReady ||
    NotificationType.treatmentScheduleCompleted => 'Phác đồ',
    NotificationType.inventoryLow ||
    NotificationType.inventoryInsufficient => 'Kho vật tư',
    NotificationType.seasonAssignmentCreated ||
    NotificationType.seasonAssignmentReplaced ||
    NotificationType.seasonStatusChanged ||
    NotificationType.harvestDue ||
    NotificationType.seasonCompleted => 'Vụ nuôi',
    NotificationType.managedAccountActivated ||
    NotificationType.accountStatusChanged => 'Nhân sự',
    NotificationType.system || NotificationType.unknown => 'Hệ thống',
  };

  static IconData icon(NotificationType type) => switch (type) {
    NotificationType.waterThresholdExceeded ||
    NotificationType.scheduleGenerationFailed => Icons.warning_amber_rounded,
    NotificationType.operationDue ||
    NotificationType.operationOverdue ||
    NotificationType.operationCancelled => Icons.settings_rounded,
    NotificationType.diseaseCaseCreated ||
    NotificationType.diseaseCaseResponse ||
    NotificationType.diseaseCaseWaitingInfo ||
    NotificationType.diseaseCaseMonitoring ||
    NotificationType.diseaseCaseResolved ||
    NotificationType.emergencyCaseUpdate => Icons.health_and_safety_rounded,
    NotificationType.taskAssigned ||
    NotificationType.taskUpdated ||
    NotificationType.taskDueSoon ||
    NotificationType.taskOverdue ||
    NotificationType.taskCompleted => Icons.checklist_rounded,
    NotificationType.productionProtocolPending ||
    NotificationType.productionProtocolReviewed ||
    NotificationType.treatmentProtocolPending ||
    NotificationType.treatmentProtocolReviewed ||
    NotificationType.treatmentProtocolAborted ||
    NotificationType.treatmentScheduleReady ||
    NotificationType.treatmentScheduleCompleted => Icons.assignment_rounded,
    NotificationType.inventoryLow ||
    NotificationType.inventoryInsufficient => Icons.inventory_2_rounded,
    NotificationType.seasonAssignmentCreated ||
    NotificationType.seasonAssignmentReplaced ||
    NotificationType.seasonStatusChanged ||
    NotificationType.harvestDue ||
    NotificationType.seasonCompleted => Icons.layers_rounded,
    NotificationType.managedAccountActivated ||
    NotificationType.accountStatusChanged => Icons.groups_rounded,
    NotificationType.system ||
    NotificationType.unknown => Icons.notifications_rounded,
  };

  static Color color(NotificationType type) => switch (type) {
    NotificationType.waterThresholdExceeded ||
    NotificationType.scheduleGenerationFailed => const Color(0xFFD98314),
    NotificationType.operationDue ||
    NotificationType.operationOverdue ||
    NotificationType.operationCancelled => const Color(0xFF0F9B8E),
    NotificationType.diseaseCaseCreated ||
    NotificationType.diseaseCaseResponse ||
    NotificationType.diseaseCaseWaitingInfo ||
    NotificationType.diseaseCaseMonitoring ||
    NotificationType.diseaseCaseResolved ||
    NotificationType.emergencyCaseUpdate => const Color(0xFFD43B57),
    NotificationType.productionProtocolPending ||
    NotificationType.productionProtocolReviewed ||
    NotificationType.treatmentProtocolPending ||
    NotificationType.treatmentProtocolReviewed ||
    NotificationType.treatmentProtocolAborted ||
    NotificationType.treatmentScheduleReady ||
    NotificationType.treatmentScheduleCompleted => const Color(0xFF7B5BD6),
    NotificationType.inventoryLow ||
    NotificationType.inventoryInsufficient ||
    NotificationType.seasonAssignmentCreated ||
    NotificationType.seasonAssignmentReplaced ||
    NotificationType.seasonStatusChanged ||
    NotificationType.harvestDue ||
    NotificationType.seasonCompleted ||
    NotificationType.system ||
    NotificationType.unknown => const Color(0xFF64748B),
    _ => AppColors.ocean,
  };

  static Color badgeTextColor(NotificationType type) => switch (type) {
    NotificationType.taskAssigned ||
    NotificationType.taskUpdated ||
    NotificationType.taskDueSoon ||
    NotificationType.taskOverdue ||
    NotificationType.taskCompleted ||
    NotificationType.managedAccountActivated ||
    NotificationType.accountStatusChanged => const Color(0xFF0C4E8F),
    _ => color(type),
  };

  static Color backgroundColor(NotificationType type) => switch (type) {
    NotificationType.waterThresholdExceeded ||
    NotificationType.scheduleGenerationFailed => const Color(0xFFFBF0DC),
    NotificationType.operationDue ||
    NotificationType.operationOverdue ||
    NotificationType.operationCancelled => const Color(0xFFE2F6F3),
    NotificationType.diseaseCaseCreated ||
    NotificationType.diseaseCaseResponse ||
    NotificationType.diseaseCaseWaitingInfo ||
    NotificationType.diseaseCaseMonitoring ||
    NotificationType.diseaseCaseResolved ||
    NotificationType.emergencyCaseUpdate => const Color(0xFFFBE6EA),
    NotificationType.productionProtocolPending ||
    NotificationType.productionProtocolReviewed ||
    NotificationType.treatmentProtocolPending ||
    NotificationType.treatmentProtocolReviewed ||
    NotificationType.treatmentProtocolAborted ||
    NotificationType.treatmentScheduleReady ||
    NotificationType.treatmentScheduleCompleted => const Color(0xFFEFEAFC),
    NotificationType.inventoryLow ||
    NotificationType.inventoryInsufficient ||
    NotificationType.seasonAssignmentCreated ||
    NotificationType.seasonAssignmentReplaced ||
    NotificationType.seasonStatusChanged ||
    NotificationType.harvestDue ||
    NotificationType.seasonCompleted ||
    NotificationType.system ||
    NotificationType.unknown => const Color(0xFFEEF1F6),
    _ => const Color(0xFFEAF4FF),
  };

  static bool isWarning(NotificationType type) => switch (type) {
    NotificationType.waterThresholdExceeded ||
    NotificationType.scheduleGenerationFailed => true,
    _ => false,
  };

  static String shortTime(DateTime value, DateTime now) {
    final local = value.toLocal();
    final difference = now.difference(local);
    if (!difference.isNegative) {
      if (difference.inMinutes < 1) return 'Vừa xong';
      if (difference.inMinutes < 60) {
        return '${difference.inMinutes} phút trước';
      }
      if (difference.inHours < 24) return '${difference.inHours} giờ trước';
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
