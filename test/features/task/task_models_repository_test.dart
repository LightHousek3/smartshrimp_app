import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/task/domain/entities/task_models.dart';
import 'package:smartshrimp_app/features/task/data/repositories/task_repository_impl.dart';
import 'package:smartshrimp_app/features/task/data/services/task_api_service.dart';
import 'task_fixtures.dart';

Map<String, dynamic> jsonTask() => {
  'id': 'task',
  'title': 'Kiểm tra ao',
  'priority': 'NORMAL',
  'status': 'PENDING',
  'assignee': {'id': 'tech', 'name': 'KTV'},
  'dueAt': '2026-10-19T01:00:00Z',
};
TaskInput input({
  String title = '  Kiểm tra ao  ',
  String? description,
  TaskPriority priority = TaskPriority.normal,
  String? seasonId,
  String? assignedTo = 'tech',
}) => TaskInput(
  dueAt: DateTime.now().add(const Duration(hours: 1)),
  title: title,
  description: description,
  priority: priority,
  farmId: 'farm',
  seasonId: seasonId,
  assignedTo: assignedTo,
);

class CaptureTaskRemote implements TaskRemoteDataSource {
  Map<String, dynamic>? body;
  String? reason, updatedId;
  @override
  Future<TaskItem> create(Map<String, dynamic> body) async {
    this.body = body;
    return pendingTask;
  }

  @override
  Future<TaskItem> update(String id, Map<String, dynamic> body) async {
    updatedId = id;
    this.body = body;
    return pendingTask;
  }

  @override
  Future<TaskItem> cancel(String id, String reason) async {
    this.reason = reason;
    return cancelledTask;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  test(
    'N/A/B: counts map every database status and reject incomplete or invalid totals',
    () {
      final json = {
        'PENDING': 5,
        'IN_PROGRESS': 2,
        'COMPLETED': 0,
        'CANCELLED': 1,
      };
      final counts = TaskCounts.fromJson(json);
      expect(counts.forStatus(TaskStatus.pending), 5);
      expect(counts.forStatus(TaskStatus.inProgress), 2);
      expect(counts.forStatus(TaskStatus.completed), 0);
      expect(counts.forStatus(TaskStatus.cancelled), 1);
      for (final invalid in [
        {...json}..remove('CANCELLED'),
        {...json, 'PENDING': -1},
        {...json, 'PENDING': 1.5},
        {...json, 'PENDING': '5'},
      ]) {
        expect(
          () => TaskCounts.fromJson(invalid),
          throwsA(isA<InvalidResponseException>()),
        );
      }
    },
  );
  test('N/B: required data, enum mapping and overdue boundary', () {
    final task = TaskItem.fromJson(jsonTask());
    expect(task.status, TaskStatus.pending);
    expect(task.priority, TaskPriority.normal);
    expect(task.overdueAt(task.dueAt), isFalse);
    expect(
      task.overdueAt(task.dueAt.add(const Duration(microseconds: 1))),
      isTrue,
    );
    expect(
      task.copyWith(status: TaskStatus.completed).overdueAt(taskNow),
      isFalse,
    );
    expect(task.copyWith(status: TaskStatus.cancelled).canEdit, isFalse);
    expect(
      () => TaskItem.fromJson({...jsonTask(), 'dueAt': null}),
      throwsA(isA<InvalidResponseException>()),
    );
  });
  test('A: unknown server states cannot accidentally enable editing', () {
    final task = TaskItem.fromJson({
      ...jsonTask(),
      'status': 'NEW_STATE',
      'priority': 'NEW_PRIORITY',
    });
    expect(task.status, TaskStatus.unknown);
    expect(task.priority, TaskPriority.unknown);
    expect(task.canEdit, isFalse);
  });
  for (final key in ['id', 'title', 'priority', 'status', 'assignee']) {
    test('A: missing required $key throws InvalidResponseException', () {
      final json = jsonTask()..remove(key);
      expect(
        () => TaskItem.fromJson(json),
        throwsA(isA<InvalidResponseException>()),
      );
    });
  }
  for (final invalid in [
    {'title': ''},
    {'id': 10},
    {'dueAt': 'invalid'},
    {
      'assignee': {'id': 'x'},
    },
    {'season': 'bad'},
    {'cancelledAt': 2},
  ]) {
    test('A: invalid task shape $invalid fails safely', () {
      expect(
        () => TaskItem.fromJson({...jsonTask(), ...invalid}),
        throwsA(isA<InvalidResponseException>()),
      );
    });
  }
  test('A: invalid options and page metadata fail safely', () {
    expect(
      () => TaskOptions.fromJson({
        'farms': [],
        'technicians': null,
        'seasons': [],
      }),
      throwsA(isA<InvalidResponseException>()),
    );
    expect(
      () => TaskPage.fromJson({
        'items': [],
        'page': 0,
        'totalResults': 0,
        'hasNextPage': false,
        'counts': {'todo': 0, 'overdue': 0},
        'serverNow': '2026-10-19T00:00:00Z',
      }),
      throwsA(isA<InvalidResponseException>()),
    );
  });
  test(
    'N: standalone create trims boundary strings and sends UTC deadline',
    () async {
      final remote = CaptureTaskRemote();
      await TaskRepositoryImpl(remote).save(
        input(
          description: ' ghi chú ',
        ).copyWith(dueAt: DateTime.now().add(const Duration(hours: 1))),
      );
      expect(remote.body, containsPair('title', 'Kiểm tra ao'));
      expect(remote.body, containsPair('description', 'ghi chú'));
      expect(
        DateTime.parse(remote.body!['dueAt'] as String).isAfter(DateTime.now()),
        isTrue,
      );
      expect(remote.body, containsPair('assignedTo', 'tech'));
    },
  );
  test('N: season create delegates assignee resolution to BE', () async {
    final remote = CaptureTaskRemote();
    await TaskRepositoryImpl(remote).save(input(seasonId: 'season'));
    expect(remote.body, isNot(contains('assignedTo')));
    expect(remote.body!['seasonId'], 'season');
  });
  test('N: in-progress edit transmits only changed allowed fields', () async {
    final remote = CaptureTaskRemote();
    await TaskRepositoryImpl(remote).save(
      input(title: progressTask.title, description: 'Mô tả mới'),
      original: progressTask,
    );
    expect(remote.updatedId, progressTask.id);
    expect(
      remote.body!.keys,
      unorderedEquals(['description', 'priority', 'dueAt']),
    );
    expect(remote.body!['dueAt'], isNotNull);
  });
  for (final status in [
    TaskStatus.completed,
    TaskStatus.cancelled,
    TaskStatus.unknown,
  ]) {
    test('A: $status cannot be saved', () async {
      final remote = CaptureTaskRemote();
      expect(
        () => TaskRepositoryImpl(
          remote,
        ).save(input(), original: pendingTask.copyWith(status: status)),
        throwsA(isA<ApiException>()),
      );
      expect(remote.body, isNull);
    });
  }
  for (final title in ['', ' ', 'a' * 256, '😀' * 256]) {
    test(
      'A/B: invalid title length ${title.length} rejected before network',
      () {
        final remote = CaptureTaskRemote();
        expect(
          () => TaskRepositoryImpl(remote).save(input(title: title)),
          throwsA(isA<ApiException>()),
        );
        expect(remote.body, isNull);
      },
    );
  }
  for (final length in [1, 255]) {
    test('B: valid title length $length accepted', () async {
      final remote = CaptureTaskRemote();
      await TaskRepositoryImpl(remote).save(input(title: 'a' * length));
      expect(remote.body!['title'], hasLength(length));
    });
  }
  test(
    'N/A/B: cancellation trims, rejects blank and enforces backend character limit',
    () async {
      final remote = CaptureTaskRemote();
      final repo = TaskRepositoryImpl(remote);
      for (final reason in ['', '  ', 'a' * 256, '😀' * 256]) {
        expect(() => repo.cancel('task', reason), throwsA(isA<ApiException>()));
      }
      await repo.cancel('task', ' Lý do rõ ràng ');
      expect(remote.reason, 'Lý do rõ ràng');
      await repo.cancel('task', 'a' * 255);
      expect(remote.reason, hasLength(255));
    },
  );
}
