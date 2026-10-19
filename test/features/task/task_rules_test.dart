import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/task/domain/task_rules.dart';
import 'package:smartshrimp_app/features/task/domain/entities/task_models.dart';
import 'package:smartshrimp_app/features/task/data/repositories/task_repository_impl.dart';
import 'package:smartshrimp_app/features/task/presentation/widgets/task_ui.dart';
import 'task_fixtures.dart';
import 'task_models_repository_test.dart' show CaptureTaskRemote;

void main() {
  final now = DateTime(2026, 10, 19, 10, 5);
  TaskInput draft(DateTime dueAt) => TaskInput(
    title: 'Kiểm tra',
    priority: TaskPriority.normal,
    dueAt: dueAt,
    farmId: taskFarm.id,
    assignedTo: taskTechnician.id,
  );

  test('A: deadline is required', () {
    expect(TaskRules.deadlineError(null, now), isNotNull);
  });
  for (final milliseconds in [-1, 0, 599999, 600000]) {
    test(
      'B: deadline offset $milliseconds cannot be selected or submitted',
      () {
        final dueAt = now.add(Duration(milliseconds: milliseconds));
        expect(TaskRules.deadlineError(dueAt, now), TaskRules.deadlineMessage);
        final remote = CaptureTaskRemote();
        expect(
          () => TaskRepositoryImpl(remote, now: () => now).save(draft(dueAt)),
          throwsA(isA<ApiException>()),
        );
        expect(remote.body, isNull);
      },
    );
  }
  test('B: a deadline one millisecond beyond ten minutes is valid', () async {
    final dueAt = now.add(const Duration(minutes: 10, milliseconds: 1));
    expect(TaskRules.deadlineError(dueAt, now), isNull);
    final remote = CaptureTaskRemote();
    await TaskRepositoryImpl(remote, now: () => now).save(draft(dueAt));
    expect(remote.body!['dueAt'], dueAt.toUtc().toIso8601String());
  });
  test(
    'B: picker initial time is a full minute strictly beyond the threshold',
    () {
      final first = TaskRules.firstSelectableDeadline(now);
      expect(first, DateTime(2026, 10, 19, 10, 16));
      expect(first.second, 0);
      expect(first.isAfter(now.add(TaskRules.deadlineLead)), isTrue);
    },
  );
  test(
    'N: editing a description preserves an existing overdue deadline',
    () async {
      final remote = CaptureTaskRemote();
      await TaskRepositoryImpl(remote, now: () => now).save(
        draft(
          progressTask.dueAt,
        ).copyWith(title: progressTask.title, description: 'Theo dõi thêm'),
        original: progressTask,
      );
      expect(remote.body, isNot(contains('dueAt')));
    },
  );
  for (final character in ['a', '😀']) {
    test('B: UI limits agree with PostgreSQL characters for $character', () {
      expect(TaskRules.titleError(character * 255), isNull);
      expect(TaskRules.titleError(character * 256), isNotNull);
      expect(TaskRules.descriptionError(character * 500), isNull);
      expect(TaskRules.descriptionError(character * 501), isNotNull);
      expect(TaskRules.cancellationReasonError(character * 255), isNull);
      expect(TaskRules.cancellationReasonError(character * 256), isNotNull);
    });
  }
  test('N/B: deadline input uses day/month/year and twelve-hour time', () {
    expect(
      taskDeadlineInput(DateTime(2026, 10, 20, 0, 5)),
      '20/10/2026 12:05 AM',
    );
    expect(
      taskDeadlineInput(DateTime(2026, 10, 20, 12, 5)),
      '20/10/2026 12:05 PM',
    );
    expect(
      taskDeadlineInput(DateTime(2026, 10, 20, 23, 5)),
      '20/10/2026 11:05 PM',
    );
  });
}
