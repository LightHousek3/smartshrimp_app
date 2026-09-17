// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppNotification _$AppNotificationFromJson(Map<String, dynamic> json) =>
    _AppNotification(
      id: json['id'] as String,
      title: json['title'] as String,
      type: $enumDecode(
        _$NotificationTypeEnumMap,
        json['type'],
        unknownValue: NotificationType.unknown,
      ),
      referenceType: json['referenceType'] as String?,
      referenceId: json['referenceId'] as String?,
      readAt: json['readAt'] == null
          ? null
          : DateTime.parse(json['readAt'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      content: json['content'] as String?,
    );

Map<String, dynamic> _$AppNotificationToJson(_AppNotification instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'type': _$NotificationTypeEnumMap[instance.type]!,
      'referenceType': instance.referenceType,
      'referenceId': instance.referenceId,
      'readAt': instance.readAt?.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'content': instance.content,
    };

const _$NotificationTypeEnumMap = {
  NotificationType.system: 'SYSTEM',
  NotificationType.managedAccountActivated: 'MANAGED_ACCOUNT_ACTIVATED',
  NotificationType.accountStatusChanged: 'ACCOUNT_STATUS_CHANGED',
  NotificationType.seasonAssignmentCreated: 'SEASON_ASSIGNMENT_CREATED',
  NotificationType.seasonAssignmentReplaced: 'SEASON_ASSIGNMENT_REPLACED',
  NotificationType.seasonStatusChanged: 'SEASON_STATUS_CHANGED',
  NotificationType.operationDue: 'OPERATION_DUE',
  NotificationType.operationOverdue: 'OPERATION_OVERDUE',
  NotificationType.operationCancelled: 'OPERATION_CANCELLED',
  NotificationType.scheduleGenerationFailed: 'SCHEDULE_GENERATION_FAILED',
  NotificationType.waterThresholdExceeded: 'WATER_THRESHOLD_EXCEEDED',
  NotificationType.taskAssigned: 'TASK_ASSIGNED',
  NotificationType.taskUpdated: 'TASK_UPDATED',
  NotificationType.taskDueSoon: 'TASK_DUE_SOON',
  NotificationType.taskOverdue: 'TASK_OVERDUE',
  NotificationType.taskCompleted: 'TASK_COMPLETED',
  NotificationType.diseaseCaseCreated: 'DISEASE_CASE_CREATED',
  NotificationType.diseaseCaseResponse: 'DISEASE_CASE_RESPONSE',
  NotificationType.diseaseCaseWaitingInfo: 'DISEASE_CASE_WAITING_INFO',
  NotificationType.diseaseCaseMonitoring: 'DISEASE_CASE_MONITORING',
  NotificationType.diseaseCaseResolved: 'DISEASE_CASE_RESOLVED',
  NotificationType.productionProtocolPending: 'PRODUCTION_PROTOCOL_PENDING',
  NotificationType.productionProtocolReviewed: 'PRODUCTION_PROTOCOL_REVIEWED',
  NotificationType.treatmentProtocolPending: 'TREATMENT_PROTOCOL_PENDING',
  NotificationType.treatmentProtocolReviewed: 'TREATMENT_PROTOCOL_REVIEWED',
  NotificationType.treatmentProtocolAborted: 'TREATMENT_PROTOCOL_ABORTED',
  NotificationType.emergencyCaseUpdate: 'EMERGENCY_CASE_UPDATE',
  NotificationType.treatmentScheduleReady: 'TREATMENT_SCHEDULE_READY',
  NotificationType.treatmentScheduleCompleted: 'TREATMENT_SCHEDULE_COMPLETED',
  NotificationType.inventoryLow: 'INVENTORY_LOW',
  NotificationType.inventoryInsufficient: 'INVENTORY_INSUFFICIENT',
  NotificationType.harvestDue: 'HARVEST_DUE',
  NotificationType.seasonCompleted: 'SEASON_COMPLETED',
  NotificationType.unknown: 'unknown',
};
