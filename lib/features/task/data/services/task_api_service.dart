import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/network/api_client.dart';
import 'package:smartshrimp_app/features/task/domain/entities/task_models.dart';

abstract interface class TaskRemoteDataSource {
  Future<TaskPage> list(TaskStatus status, int page);
  Future<TaskItem> detail(String id);
  Future<TaskOptions> options(String? farmId);
  Future<TaskItem> create(Map<String, dynamic> body);
  Future<TaskItem> update(String id, Map<String, dynamic> body);
  Future<TaskItem> cancel(String id, String reason);
}

abstract interface class AssignedTaskRemoteDataSource {
  Future<TaskPage> listAssigned(String group, int page);
  Future<TaskItem> assignedDetail(String id);
  Future<TaskItem> updateStatus(String id, TaskStatus status);
}

final class TaskApiService
    implements TaskRemoteDataSource, AssignedTaskRemoteDataSource {
  TaskApiService(this._client);
  final ApiClient _client;
  static const _path = '/owner/tasks';

  @override
  Future<TaskPage> listAssigned(String group, int page) async {
    final response = await _client.get(
      '/me/tasks',
      authenticated: true,
      queryParameters: {'group': group, 'page': page, 'limit': 20},
    );
    if (response.meta == null) throw const InvalidResponseException();
    return TaskPage.fromJson({
      ...response.meta!,
      'items': response.requireListData(),
    });
  }

  TaskItem _assignedDetail(Map<String, dynamic> json) {
    // A compact list omits identities; detail must contain every assignment fact.
    for (final key in ['assigner', 'assignee', 'farm']) {
      if (json[key] is! Map<String, dynamic>) {
        throw const InvalidResponseException();
      }
    }
    if (json['createdAt'] is! String || json['canOpenRelatedSeason'] is! bool) {
      throw const InvalidResponseException();
    }
    return TaskItem.fromJson(json);
  }

  @override
  Future<TaskItem> assignedDetail(String id) async => _assignedDetail(
    (await _client.get('/me/tasks/$id', authenticated: true)).requireMapData(),
  );

  @override
  Future<TaskItem> updateStatus(String id, TaskStatus status) async =>
      _assignedDetail(
        (await _client.patch(
          '/me/tasks/$id/status',
          authenticated: true,
          data: {'status': taskStatusApiValue(status)},
        )).requireMapData(),
      );

  @override
  Future<TaskPage> list(TaskStatus status, int page) async {
    final response = await _client.get(
      _path,
      authenticated: true,
      queryParameters: {
        'status': taskStatusApiValue(status),
        'page': page,
        'limit': 20,
      },
    );
    final meta = response.meta;
    if (meta == null) throw const InvalidResponseException();
    return TaskPage.fromJson({...meta, 'items': response.requireListData()});
  }

  @override
  Future<TaskItem> detail(String id) async => TaskItem.fromJson(
    (await _client.get('$_path/$id', authenticated: true)).requireMapData(),
  );
  @override
  Future<TaskOptions> options(String? farmId) async => TaskOptions.fromJson(
    (await _client.get(
      '$_path/form-options',
      authenticated: true,
      queryParameters: {'farmId': ?farmId},
    )).requireMapData(),
  );
  @override
  Future<TaskItem> create(Map<String, dynamic> body) async => TaskItem.fromJson(
    (await _client.post(
      _path,
      authenticated: true,
      data: body,
    )).requireMapData(),
  );
  @override
  Future<TaskItem> update(String id, Map<String, dynamic> body) async =>
      TaskItem.fromJson(
        (await _client.patch(
          '$_path/$id',
          authenticated: true,
          data: body,
        )).requireMapData(),
      );
  @override
  Future<TaskItem> cancel(String id, String reason) async => TaskItem.fromJson(
    (await _client.patch(
      '$_path/$id/cancel',
      authenticated: true,
      data: {'reason': reason},
    )).requireMapData(),
  );
}
