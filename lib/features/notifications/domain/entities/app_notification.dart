import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';

part 'app_notification.freezed.dart';
part 'app_notification.g.dart';

enum NotificationType {
  @JsonValue('SYSTEM')
  system,
  @JsonValue('MANAGED_ACCOUNT_ACTIVATED')
  managedAccountActivated,
  @JsonValue('ACCOUNT_STATUS_CHANGED')
  accountStatusChanged,
  @JsonValue('SEASON_ASSIGNMENT_CREATED')
  seasonAssignmentCreated,
  @JsonValue('SEASON_ASSIGNMENT_REPLACED')
  seasonAssignmentReplaced,
  @JsonValue('SEASON_STATUS_CHANGED')
  seasonStatusChanged,
  @JsonValue('OPERATION_DUE')
  operationDue,
  @JsonValue('OPERATION_OVERDUE')
  operationOverdue,
  @JsonValue('OPERATION_CANCELLED')
  operationCancelled,
  @JsonValue('SCHEDULE_GENERATION_FAILED')
  scheduleGenerationFailed,
  @JsonValue('WATER_THRESHOLD_EXCEEDED')
  waterThresholdExceeded,
  @JsonValue('TASK_ASSIGNED')
  taskAssigned,
  @JsonValue('TASK_UPDATED')
  taskUpdated,
  @JsonValue('TASK_DUE_SOON')
  taskDueSoon,
  @JsonValue('TASK_OVERDUE')
  taskOverdue,
  @JsonValue('TASK_COMPLETED')
  taskCompleted,
  @JsonValue('DISEASE_CASE_CREATED')
  diseaseCaseCreated,
  @JsonValue('DISEASE_CASE_RESPONSE')
  diseaseCaseResponse,
  @JsonValue('DISEASE_CASE_WAITING_INFO')
  diseaseCaseWaitingInfo,
  @JsonValue('DISEASE_CASE_MONITORING')
  diseaseCaseMonitoring,
  @JsonValue('DISEASE_CASE_RESOLVED')
  diseaseCaseResolved,
  @JsonValue('PRODUCTION_PROTOCOL_PENDING')
  productionProtocolPending,
  @JsonValue('PRODUCTION_PROTOCOL_REVIEWED')
  productionProtocolReviewed,
  @JsonValue('TREATMENT_PROTOCOL_PENDING')
  treatmentProtocolPending,
  @JsonValue('TREATMENT_PROTOCOL_REVIEWED')
  treatmentProtocolReviewed,
  @JsonValue('TREATMENT_PROTOCOL_ABORTED')
  treatmentProtocolAborted,
  @JsonValue('EMERGENCY_CASE_UPDATE')
  emergencyCaseUpdate,
  @JsonValue('TREATMENT_SCHEDULE_READY')
  treatmentScheduleReady,
  @JsonValue('TREATMENT_SCHEDULE_COMPLETED')
  treatmentScheduleCompleted,
  @JsonValue('INVENTORY_LOW')
  inventoryLow,
  @JsonValue('INVENTORY_INSUFFICIENT')
  inventoryInsufficient,
  @JsonValue('HARVEST_DUE')
  harvestDue,
  @JsonValue('SEASON_COMPLETED')
  seasonCompleted,
  unknown,
}

@freezed
abstract class AppNotification with _$AppNotification {
  const AppNotification._();

  const factory AppNotification({
    required String id,
    required String title,
    @JsonKey(unknownEnumValue: NotificationType.unknown)
    required NotificationType type,
    String? referenceType,
    String? referenceId,
    DateTime? readAt,
    required DateTime createdAt,
    String? content,
  }) = _AppNotification;

  factory AppNotification.fromJson(Map<String, dynamic> json) =>
      _$AppNotificationFromJson(json);

  static AppNotification parse(
    Map<String, dynamic> json, {
    bool detail = false,
  }) {
    if (json['id'] is! String ||
        (json['id'] as String).trim().isEmpty ||
        json['title'] is! String ||
        (json['title'] as String).trim().isEmpty ||
        json['type'] is! String ||
        json['createdAt'] is! String ||
        !json.containsKey('readAt') ||
        (json['readAt'] != null && json['readAt'] is! String) ||
        (detail && json['readAt'] == null) ||
        (json['referenceType'] != null && json['referenceType'] is! String) ||
        (json['referenceId'] != null && json['referenceId'] is! String) ||
        (detail && !json.containsKey('content')) ||
        (json['content'] != null && json['content'] is! String)) {
      throw const InvalidResponseException();
    }
    try {
      return AppNotification.fromJson(json);
    } on Object catch (_, stackTrace) {
      Error.throwWithStackTrace(const InvalidResponseException(), stackTrace);
    }
  }

  bool get isUnread => readAt == null;
}

@freezed
abstract class NotificationPage with _$NotificationPage {
  const NotificationPage._();

  const factory NotificationPage({
    required List<AppNotification> items,
    required int totalResults,
    required bool hasNextPage,
    String? nextCursor,
  }) = _NotificationPage;

  static NotificationPage parse(Object? data, Map<String, dynamic>? meta) {
    if (data is! List ||
        meta == null ||
        meta['limit'] is! int ||
        (meta['limit'] as int) < 1 ||
        (meta['limit'] as int) > 100 ||
        meta['totalResults'] is! int ||
        (meta['totalResults'] as int) < 0 ||
        meta['hasNextPage'] is! bool ||
        (meta['nextCursor'] != null && meta['nextCursor'] is! String) ||
        (meta['hasNextPage'] == true &&
            (meta['nextCursor'] is! String ||
                (meta['nextCursor'] as String).isEmpty))) {
      throw const InvalidResponseException();
    }
    final items = data
        .map((item) {
          if (item is! Map<String, dynamic>) {
            throw const InvalidResponseException();
          }
          return AppNotification.parse(item);
        })
        .toList(growable: false);
    if (meta['hasNextPage'] == true && items.isEmpty) {
      throw const InvalidResponseException();
    }
    return NotificationPage(
      items: items,
      totalResults: meta['totalResults'] as int,
      hasNextPage: meta['hasNextPage'] as bool,
      nextCursor: meta['nextCursor'] as String?,
    );
  }
}
