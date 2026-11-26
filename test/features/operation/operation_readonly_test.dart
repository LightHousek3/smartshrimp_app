import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/core/widgets/gradient_button.dart';
import 'package:smartshrimp_app/features/operation/presentation/widgets/operation_schedule_card.dart';
import 'package:smartshrimp_app/features/operation/presentation/widgets/operation_type_badge.dart';
import 'package:smartshrimp_app/features/assigned_season/presentation/view_models/assigned_season_controller.dart';
import 'package:smartshrimp_app/features/operation/domain/entities/operation_models.dart';
import 'package:smartshrimp_app/features/operation/domain/repositories/operation_repository.dart';
import 'package:smartshrimp_app/features/operation/presentation/pages/operation_detail_page.dart';
import 'package:smartshrimp_app/features/operation/presentation/view_models/operation_controller.dart';

void main() {
  for (final (quantity, label) in [(.1, '0,1 ml'), (.000001, '0,000001 ml')]) {
    testWidgets('completed execution preserves the recorded amount $label', (
      tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            assignedSeasonCanWriteProvider(
              'season',
            ).overrideWith((ref) => true),
            operationRepositoryProvider.overrideWithValue(
              _Operations(actualQuantity: quantity),
            ),
          ],
          child: const MaterialApp(
            home: OperationDetailPage(
              seasonId: 'season',
              scheduleId: 'schedule',
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Đã dùng $label'), findsOneWidget);
      expect(find.text(label), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

  for (final restriction in ['future', 'stock']) {
    testWidgets('active season checks $restriction at the appropriate step', (
      tester,
    ) async {
      final repository = _Operations(
        scheduledAt: restriction == 'future'
            ? DateTime.now().add(const Duration(hours: 2))
            : DateTime.now().subtract(const Duration(hours: 2)),
        stock: restriction == 'stock' ? 1 : 100,
      );
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            assignedSeasonCanWriteProvider(
              'season',
            ).overrideWith((ref) => true),
            operationRepositoryProvider.overrideWithValue(repository),
          ],
          child: const MaterialApp(
            home: OperationDetailPage(
              seasonId: 'season',
              scheduleId: 'schedule',
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final button = tester.widget<GradientButton>(find.byType(GradientButton));
      expect(button.onPressed, restriction == 'future' ? isNull : isNotNull);
      expect(
        button.label,
        restriction == 'future'
            ? 'Chưa đến giờ thực hiện'
            : 'Ghi nhận thực hiện',
      );
      expect(tester.takeException(), isNull);
    });
  }

  for (final overdue in [false, true]) {
    testWidgets(
      'custom card keeps its shape and shadow while preserving overdue warning: $overdue',
      (tester) async {
        final schedule = await _Operations(
          scheduledAt: DateTime.now().add(Duration(hours: overdue ? -2 : 2)),
        ).getSchedule('schedule');
        final customDecoration = BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.blue),
          boxShadow: const [BoxShadow(blurRadius: 16, offset: Offset(0, 8))],
        );
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: OperationScheduleCard(
                schedule: schedule,
                onTap: () {},
                decoration: customDecoration,
              ),
            ),
          ),
        );
        final card = tester.widget<Container>(
          find
              .descendant(
                of: find.byType(OperationScheduleCard),
                matching: find.byType(Container),
              )
              .first,
        );
        final decoration = card.decoration! as BoxDecoration;
        expect(decoration.borderRadius, customDecoration.borderRadius);
        expect(decoration.boxShadow, customDecoration.boxShadow);
        expect(
          decoration.color,
          overdue ? OperationOverdueBadge.cardSurface : Colors.white,
        );
        expect(
          decoration.border,
          overdue
              ? Border.all(
                  color: OperationOverdueBadge.cardBorder.withValues(
                    alpha: 0.85,
                  ),
                )
              : customDecoration.border,
        );
        expect(find.text('Quá hạn'), overdue ? findsOneWidget : findsNothing);
        expect(tester.takeException(), isNull);
      },
    );
  }

  for (final canWrite in [false, true]) {
    testWidgets(
      'planned schedule execution visibility follows season write access: $canWrite',
      (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              assignedSeasonCanWriteProvider(
                'season',
              ).overrideWith((ref) => canWrite),
              operationRepositoryProvider.overrideWithValue(_Operations()),
            ],
            child: const MaterialApp(
              home: OperationDetailPage(
                seasonId: 'season',
                scheduleId: 'schedule',
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(
          find.text('Ghi nhận thực hiện'),
          canWrite ? findsOneWidget : findsNothing,
        );
        expect(find.byType(CircularProgressIndicator), findsNothing);
        expect(tester.takeException(), isNull);
      },
    );
  }
}

class _Operations implements OperationRepository {
  _Operations({this.scheduledAt, this.stock = 100, this.actualQuantity});
  final DateTime? scheduledAt;
  final double stock;
  final double? actualQuantity;

  @override
  Future<OperationListResult> getSchedules(
    String seasonId, {
    String? status,
    String? operationType,
    String? date,
    int? page,
    int? limit,
  }) async => OperationListResult.fromJson({});

  @override
  Future<OperationSchedule> getSchedule(String scheduleId) async =>
      OperationSchedule(
        id: scheduleId,
        seasonId: 'season',
        protocolItemId: 'item',
        operationType: OperationType.feeding,
        scheduledAt:
            scheduledAt ?? DateTime.now().subtract(const Duration(hours: 1)),
        plannedQuantity: 10,
        unit: actualQuantity == null ? 'KG' : 'ML',
        doseBasisSnapshot: 'FIXED_QUANTITY',
        doseValueSnapshot: 10,
        calculationVersion: 'v1',
        status: actualQuantity == null
            ? OperationStatus.planned
            : OperationStatus.completed,
        availableStock: stock,
        execution: actualQuantity == null
            ? null
            : OperationExecution(
                id: 'execution',
                actualQuantity: actualQuantity!,
                executedAt: DateTime.now(),
              ),
        protocolItem: const OperationProtocolItem(id: 'item', dueAtMinutes: 30),
      );
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
