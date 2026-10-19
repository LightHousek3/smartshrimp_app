// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TaskChoice _$TaskChoiceFromJson(Map<String, dynamic> json) =>
    _TaskChoice(id: json['id'] as String, name: json['name'] as String);

Map<String, dynamic> _$TaskChoiceToJson(_TaskChoice instance) =>
    <String, dynamic>{'id': instance.id, 'name': instance.name};

_TaskItem _$TaskItemFromJson(Map<String, dynamic> json) => _TaskItem(
  id: json['id'] as String,
  title: json['title'] as String,
  priority: $enumDecode(
    _$TaskPriorityEnumMap,
    json['priority'],
    unknownValue: TaskPriority.unknown,
  ),
  status: $enumDecode(
    _$TaskStatusEnumMap,
    json['status'],
    unknownValue: TaskStatus.unknown,
  ),
  assignee: TaskChoice.fromJson(json['assignee'] as Map<String, dynamic>),
  dueAt: DateTime.parse(json['dueAt'] as String),
  description: json['description'] as String?,
  farmId: json['farmId'] as String?,
  seasonId: json['seasonId'] as String?,
  assignedTo: json['assignedTo'] as String?,
  season: json['season'] == null
      ? null
      : TaskChoice.fromJson(json['season'] as Map<String, dynamic>),
  farm: json['farm'] == null
      ? null
      : TaskChoice.fromJson(json['farm'] as Map<String, dynamic>),
  startedAt: json['startedAt'] == null
      ? null
      : DateTime.parse(json['startedAt'] as String),
  completedAt: json['completedAt'] == null
      ? null
      : DateTime.parse(json['completedAt'] as String),
  cancellationReason: json['cancellationReason'] as String?,
  cancelledAt: json['cancelledAt'] == null
      ? null
      : DateTime.parse(json['cancelledAt'] as String),
  cancelledBy: json['cancelledBy'] == null
      ? null
      : TaskChoice.fromJson(json['cancelledBy'] as Map<String, dynamic>),
);

Map<String, dynamic> _$TaskItemToJson(_TaskItem instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'priority': _$TaskPriorityEnumMap[instance.priority]!,
  'status': _$TaskStatusEnumMap[instance.status]!,
  'assignee': instance.assignee,
  'dueAt': instance.dueAt.toIso8601String(),
  'description': instance.description,
  'farmId': instance.farmId,
  'seasonId': instance.seasonId,
  'assignedTo': instance.assignedTo,
  'season': instance.season,
  'farm': instance.farm,
  'startedAt': instance.startedAt?.toIso8601String(),
  'completedAt': instance.completedAt?.toIso8601String(),
  'cancellationReason': instance.cancellationReason,
  'cancelledAt': instance.cancelledAt?.toIso8601String(),
  'cancelledBy': instance.cancelledBy,
};

const _$TaskPriorityEnumMap = {
  TaskPriority.low: 'LOW',
  TaskPriority.normal: 'NORMAL',
  TaskPriority.high: 'HIGH',
  TaskPriority.urgent: 'URGENT',
  TaskPriority.unknown: 'unknown',
};

const _$TaskStatusEnumMap = {
  TaskStatus.pending: 'PENDING',
  TaskStatus.inProgress: 'IN_PROGRESS',
  TaskStatus.completed: 'COMPLETED',
  TaskStatus.cancelled: 'CANCELLED',
  TaskStatus.unknown: 'unknown',
};

_TaskSeasonChoice _$TaskSeasonChoiceFromJson(Map<String, dynamic> json) =>
    _TaskSeasonChoice(
      id: json['id'] as String,
      name: json['name'] as String,
      pondName: json['pondName'] as String,
      technician: json['technician'] == null
          ? null
          : TaskChoice.fromJson(json['technician'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TaskSeasonChoiceToJson(_TaskSeasonChoice instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'pondName': instance.pondName,
      'technician': instance.technician,
    };

_TaskOptions _$TaskOptionsFromJson(Map<String, dynamic> json) => _TaskOptions(
  farms: (json['farms'] as List<dynamic>)
      .map((e) => TaskChoice.fromJson(e as Map<String, dynamic>))
      .toList(),
  technicians: (json['technicians'] as List<dynamic>)
      .map((e) => TaskChoice.fromJson(e as Map<String, dynamic>))
      .toList(),
  seasons: (json['seasons'] as List<dynamic>)
      .map((e) => TaskSeasonChoice.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$TaskOptionsToJson(_TaskOptions instance) =>
    <String, dynamic>{
      'farms': instance.farms,
      'technicians': instance.technicians,
      'seasons': instance.seasons,
    };

_TaskCounts _$TaskCountsFromJson(Map<String, dynamic> json) => _TaskCounts(
  pending: (json['PENDING'] as num).toInt(),
  inProgress: (json['IN_PROGRESS'] as num).toInt(),
  completed: (json['COMPLETED'] as num).toInt(),
  cancelled: (json['CANCELLED'] as num).toInt(),
);

Map<String, dynamic> _$TaskCountsToJson(_TaskCounts instance) =>
    <String, dynamic>{
      'PENDING': instance.pending,
      'IN_PROGRESS': instance.inProgress,
      'COMPLETED': instance.completed,
      'CANCELLED': instance.cancelled,
    };

_TaskPage _$TaskPageFromJson(Map<String, dynamic> json) => _TaskPage(
  items: (json['items'] as List<dynamic>)
      .map((e) => TaskItem.fromJson(e as Map<String, dynamic>))
      .toList(),
  page: (json['page'] as num).toInt(),
  hasNextPage: json['hasNextPage'] as bool,
  totalResults: (json['totalResults'] as num).toInt(),
  counts: TaskCounts.fromJson(json['counts'] as Map<String, dynamic>),
  serverNow: DateTime.parse(json['serverNow'] as String),
);

Map<String, dynamic> _$TaskPageToJson(_TaskPage instance) => <String, dynamic>{
  'items': instance.items,
  'page': instance.page,
  'hasNextPage': instance.hasNextPage,
  'totalResults': instance.totalResults,
  'counts': instance.counts,
  'serverNow': instance.serverNow.toIso8601String(),
};

_TaskInput _$TaskInputFromJson(Map<String, dynamic> json) => _TaskInput(
  title: json['title'] as String,
  description: json['description'] as String?,
  priority: $enumDecode(_$TaskPriorityEnumMap, json['priority']),
  dueAt: DateTime.parse(json['dueAt'] as String),
  farmId: json['farmId'] as String,
  seasonId: json['seasonId'] as String?,
  assignedTo: json['assignedTo'] as String?,
);

Map<String, dynamic> _$TaskInputToJson(_TaskInput instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'priority': _$TaskPriorityEnumMap[instance.priority]!,
      'dueAt': instance.dueAt.toIso8601String(),
      'farmId': instance.farmId,
      'seasonId': instance.seasonId,
      'assignedTo': instance.assignedTo,
    };
