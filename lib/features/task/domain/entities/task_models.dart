import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';

part 'task_models.freezed.dart';
part 'task_models.g.dart';

enum TaskStatus {
  @JsonValue('PENDING')
  pending,
  @JsonValue('IN_PROGRESS')
  inProgress,
  @JsonValue('COMPLETED')
  completed,
  @JsonValue('CANCELLED')
  cancelled,
  unknown,
}

enum TaskPriority {
  @JsonValue('LOW')
  low,
  @JsonValue('NORMAL')
  normal,
  @JsonValue('HIGH')
  high,
  @JsonValue('URGENT')
  urgent,
  unknown,
}

@Freezed(fromJson: true, toJson: true)
abstract class TaskChoice with _$TaskChoice {
  const factory TaskChoice({required String id, required String name}) =
      _TaskChoice;
  factory TaskChoice.fromJson(Map<String, dynamic> json) {
    if (json['id'] is! String ||
        (json['id'] as String).isEmpty ||
        json['name'] is! String ||
        (json['name'] as String).isEmpty) {
      throw const InvalidResponseException();
    }
    return _$TaskChoiceFromJson(json);
  }
}

@Freezed(fromJson: true, toJson: true)
abstract class TaskItem with _$TaskItem {
  const TaskItem._();
  const factory TaskItem({
    required String id,
    required String title,
    @JsonKey(unknownEnumValue: TaskPriority.unknown)
    required TaskPriority priority,
    @JsonKey(unknownEnumValue: TaskStatus.unknown) required TaskStatus status,
    required TaskChoice assignee,
    required DateTime dueAt,
    String? description,
    String? farmId,
    String? seasonId,
    String? assignedTo,
    TaskChoice? season,
    TaskChoice? farm,
    DateTime? startedAt,
    DateTime? completedAt,
    String? cancellationReason,
    DateTime? cancelledAt,
    TaskChoice? cancelledBy,
  }) = _TaskItem;
  factory TaskItem.fromJson(Map<String, dynamic> json) {
    for (final key in ['id', 'title', 'status', 'priority']) {
      if (json[key] is! String || (json[key] as String).isEmpty) {
        throw const InvalidResponseException();
      }
    }
    try {
      return _$TaskItemFromJson(json);
    } on InvalidResponseException {
      rethrow;
    } catch (_) {
      throw const InvalidResponseException();
    }
  }
  bool get canEdit =>
      status == TaskStatus.pending || status == TaskStatus.inProgress;
  bool overdueAt(DateTime now) => canEdit && dueAt.isBefore(now);
}

@Freezed(fromJson: true, toJson: true)
abstract class TaskSeasonChoice with _$TaskSeasonChoice {
  const factory TaskSeasonChoice({
    required String id,
    required String name,
    required String pondName,
    TaskChoice? technician,
  }) = _TaskSeasonChoice;
  factory TaskSeasonChoice.fromJson(Map<String, dynamic> json) {
    for (final key in ['id', 'name', 'pondName']) {
      if (json[key] is! String || (json[key] as String).isEmpty) {
        throw const InvalidResponseException();
      }
    }
    return _$TaskSeasonChoiceFromJson(json);
  }
}

@Freezed(fromJson: true, toJson: true)
abstract class TaskOptions with _$TaskOptions {
  const factory TaskOptions({
    required List<TaskChoice> farms,
    required List<TaskChoice> technicians,
    required List<TaskSeasonChoice> seasons,
  }) = _TaskOptions;
  factory TaskOptions.fromJson(Map<String, dynamic> json) {
    try {
      return _$TaskOptionsFromJson(json);
    } catch (_) {
      throw const InvalidResponseException();
    }
  }
}

@Freezed(fromJson: true, toJson: true)
abstract class TaskCounts with _$TaskCounts {
  const TaskCounts._();
  const factory TaskCounts({
    @JsonKey(name: 'PENDING') required int pending,
    @JsonKey(name: 'IN_PROGRESS') required int inProgress,
    @JsonKey(name: 'COMPLETED') required int completed,
    @JsonKey(name: 'CANCELLED') required int cancelled,
  }) = _TaskCounts;

  factory TaskCounts.fromJson(Map<String, dynamic> json) {
    for (final status in TaskStatus.values.where(
      (s) => s != TaskStatus.unknown,
    )) {
      final count = json[taskStatusApiValue(status)];
      if (count is! int || count < 0) {
        throw const InvalidResponseException();
      }
    }
    return _$TaskCountsFromJson(json);
  }

  int forStatus(TaskStatus status) => switch (status) {
    TaskStatus.pending => pending,
    TaskStatus.inProgress => inProgress,
    TaskStatus.completed => completed,
    TaskStatus.cancelled => cancelled,
    TaskStatus.unknown => throw ArgumentError.value(status, 'status'),
  };
}

@Freezed(fromJson: true, toJson: true)
abstract class TaskPage with _$TaskPage {
  const factory TaskPage({
    required List<TaskItem> items,
    required int page,
    required bool hasNextPage,
    required int totalResults,
    required TaskCounts counts,
    required DateTime serverNow,
  }) = _TaskPage;
  factory TaskPage.fromJson(Map<String, dynamic> json) {
    if (json['page'] is! int || json['totalResults'] is! int) {
      throw const InvalidResponseException();
    }
    try {
      final page = _$TaskPageFromJson(json);
      if (page.page < 1 || page.totalResults < 0) {
        throw const InvalidResponseException();
      }
      return page;
    } catch (_) {
      throw const InvalidResponseException();
    }
  }
}

@Freezed(fromJson: true, toJson: true)
abstract class TaskInput with _$TaskInput {
  const factory TaskInput({
    required String title,
    String? description,
    required TaskPriority priority,
    required DateTime dueAt,
    required String farmId,
    String? seasonId,
    String? assignedTo,
  }) = _TaskInput;
  factory TaskInput.fromJson(Map<String, dynamic> json) =>
      _$TaskInputFromJson(json);
}

String taskPriorityLabel(TaskPriority priority) => switch (priority) {
  TaskPriority.low => 'Thấp',
  TaskPriority.normal => 'Bình thường',
  TaskPriority.high => 'Cao',
  TaskPriority.urgent => 'Khẩn',
  TaskPriority.unknown => 'Không xác định',
};
String taskStatusLabel(TaskStatus status) => switch (status) {
  TaskStatus.pending => 'Chờ làm',
  TaskStatus.inProgress => 'Đang làm',
  TaskStatus.completed => 'Hoàn thành',
  TaskStatus.cancelled => 'Đã hủy',
  TaskStatus.unknown => 'Không xác định',
};

String taskStatusApiValue(TaskStatus status) => switch (status) {
  TaskStatus.pending => "PENDING",
  TaskStatus.inProgress => "IN_PROGRESS",
  TaskStatus.completed => "COMPLETED",
  TaskStatus.cancelled => "CANCELLED",
  TaskStatus.unknown => throw ArgumentError.value(status, "status"),
};
