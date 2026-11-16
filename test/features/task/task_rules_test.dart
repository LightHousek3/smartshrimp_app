import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/task/domain/task_rules.dart';
import 'package:smartshrimp_app/features/task/domain/entities/task_models.dart';
import 'package:smartshrimp_app/features/task/data/repositories/task_repository_impl.dart';
import 'package:smartshrimp_app/features/task/presentation/widgets/task_ui.dart';
import 'task_fixtures.dart';
import 'task_models_repository_test.dart' show CaptureTaskRemote;

void main() {
  test(
    'N/A: automatic season assignment and manual staff selection have distinct validation',
    () {
      const warning =
          'Vụ nuôi chưa có kỹ thuật viên đang phụ trách. Vui lòng phân công trước khi giao nhiệm vụ.';
      expect(TaskRules.assigneeError(null, hasSeason: true), warning);
      expect(
        TaskRules.assigneeError(null, hasSeason: false),
        'Vui lòng chọn nhân sự.',
      );
      expect(TaskRules.assigneeError('technician', hasSeason: true), isNull);
      expect(TaskRules.assigneeError('technician', hasSeason: false), isNull);
    },
  );
  test('N/A/B: evidence count, URLs, signatures and five MB boundary', () {
    final urls = List.generate(5, (index) => 'https://images.test/$index.jpg');
    TaskRules.validateEvidenceUrls([]);
    TaskRules.validateEvidenceUrls(urls);
    for (final invalid in [
      [...urls, 'https://images.test/6.jpg'],
      [urls.first, urls.first],
      ['http://images.test/a.jpg'],
      ['data:image/png;base64,AA'],
      ['https://images.test/${'a' * 2048}'],
    ]) {
      expect(
        () => TaskRules.validateEvidenceUrls(invalid),
        throwsA(isA<ApiException>()),
      );
    }
    for (final valid in [
      [0xff, 0xd8, 0xff],
      [137, 80, 78, 71, 13, 10, 26, 10],
      [82, 73, 70, 70, 0, 0, 0, 0, 87, 69, 66, 80],
    ]) {
      TaskRules.validateEvidenceImage(Uint8List.fromList(valid));
    }
    final maximum = Uint8List(TaskRules.maxEvidenceImageBytes)
      ..setAll(0, [0xff, 0xd8, 0xff]);
    TaskRules.validateEvidenceImage(maximum);
    for (final bytes in [
      Uint8List(0),
      Uint8List.fromList([0xff, 0xd8]),
      Uint8List.fromList([1, 2, 3]),
      Uint8List(TaskRules.maxEvidenceImageBytes + 1)
        ..setAll(0, [0xff, 0xd8, 0xff]),
    ]) {
      expect(
        () => TaskRules.validateEvidenceImage(bytes),
        throwsA(isA<ApiException>()),
      );
    }
  });
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
          progressTask.dueAt!,
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
      expect(TaskRules.cancellationReasonError(character * 500), isNull);
      expect(TaskRules.cancellationReasonError(character * 501), isNotNull);
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
