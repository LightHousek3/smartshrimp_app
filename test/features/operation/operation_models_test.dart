import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/features/operation/domain/entities/operation_models.dart';

void main() {
  group('OperationEnums', () {
    test('OperationType parsing and displayName', () {
      expect(OperationType.parse('FEEDING'), OperationType.feeding);
      expect(OperationType.parse('MINERAL'), OperationType.mineral);
      expect(OperationType.parse('CHEMICAL'), OperationType.chemical);
      expect(OperationType.parse('MEDICINE'), OperationType.medicine);
      expect(OperationType.parse('UNKNOWN'), OperationType.other);
      expect(OperationType.parse(null), OperationType.other);

      expect(OperationType.feeding.displayName, 'Cho ăn');
      expect(OperationType.mineral.displayName, 'Khoáng');
      expect(OperationType.chemical.displayName, 'Hóa chất');
      expect(OperationType.medicine.displayName, 'Thuốc điều trị');
      expect(OperationType.other.displayName, 'Khác');
    });

    test('OperationStatus parsing and displayName', () {
      expect(OperationStatus.parse('PLANNED'), OperationStatus.planned);
      expect(OperationStatus.parse('COMPLETED'), OperationStatus.completed);
      expect(OperationStatus.parse('CANCELLED'), OperationStatus.cancelled);
      expect(OperationStatus.parse('UNKNOWN'), OperationStatus.planned);
      expect(OperationStatus.parse(null), OperationStatus.planned);

      expect(OperationStatus.planned.displayName, 'Đã lên lịch');
      expect(OperationStatus.completed.displayName, 'Đã thực hiện');
      expect(OperationStatus.cancelled.displayName, 'Đã hủy');
    });
  });

  group('OperationModels JSON parsing', () {
    test('parses OperationProduct correctly', () {
      final json = <String, dynamic>{
        'id': 'prod-1',
        'name': 'Thức ăn CP 01',
        'category': 'FEED',
        'unit': 'kg',
      };
      final product = OperationProduct.fromJson(json);
      expect(product.id, 'prod-1');
      expect(product.name, 'Thức ăn CP 01');
      expect(product.category, 'FEED');
      expect(product.unit, 'kg');
    });

    test('parses OperationProtocol and ProtocolItem correctly', () {
      final protocolJson = <String, dynamic>{
        'id': 'proto-1',
        'title': 'Quy trình nuôi tôm thẻ',
        'versionNo': 1,
        'allowedVariancePct': 10.0,
        'protocolType': 'STANDARD',
      };
      final itemJson = <String, dynamic>{
        'id': 'item-1',
        'mealNumber': 2,
        'plannedTime': '09:00',
        'instructions': 'Rải đều quanh quạt nước',
        'recommendedProductName': 'Thức ăn CP',
        'protocol': protocolJson,
      };

      final item = OperationProtocolItem.fromJson(itemJson);
      expect(item.id, 'item-1');
      expect(item.mealNumber, 2);
      expect(item.plannedTime, '09:00');
      expect(item.instructions, 'Rải đều quanh quạt nước');
      expect(item.recommendedProductName, 'Thức ăn CP');
      expect(item.protocol, isNotNull);
      expect(item.protocol!.title, 'Quy trình nuôi tôm thẻ');
      expect(item.protocol!.allowedVariancePct, 10.0);
    });

    test('parses OperationExecution correctly', () {
      final json = <String, dynamic>{
        'id': 'exec-1',
        'actualQuantity': 52.5,
        'executedAt': '2026-10-08T07:30:00Z',
        'actualProductId': 'prod-1',
        'note': 'Tôm ăn mạnh, tăng 5%',
        'varianceReason': 'Tăng thức ăn do tôm ăn hết sớm',
        'actualProduct': {
          'id': 'prod-1',
          'name': 'Thức ăn CP 01',
          'unit': 'kg',
        },
      };

      final exec = OperationExecution.fromJson(json);
      expect(exec.id, 'exec-1');
      expect(exec.actualQuantity, 52.5);
      expect(exec.note, 'Tôm ăn mạnh, tăng 5%');
      expect(exec.varianceReason, 'Tăng thức ăn do tôm ăn hết sớm');
      expect(exec.actualProduct?.name, 'Thức ăn CP 01');
    });

    test('parses OperationSchedule in planned state', () {
      final json = <String, dynamic>{
        'id': 'sched-1',
        'seasonId': 'season-1',
        'protocolItemId': 'item-1',
        'operationType': 'FEEDING',
        'scheduledAt': '2026-10-08T07:00:00Z',
        'plannedQuantity': 50.0,
        'unit': 'kg',
        'doseBasisSnapshot': 'PERCENT_BIOMASS',
        'doseValueSnapshot': 3.5,
        'calculationVersion': 'v1',
        'status': 'PLANNED',
        'basisQuantity': 1428.5,
        'basisUnit': 'kg',
        'product': {'id': 'prod-1', 'name': 'Thức ăn CP 01', 'unit': 'kg'},
      };

      final schedule = OperationSchedule.fromJson(json);
      expect(schedule.id, 'sched-1');
      expect(schedule.operationType, OperationType.feeding);
      expect(schedule.status, OperationStatus.planned);
      expect(schedule.plannedQuantity, 50.0);
      expect(schedule.doseBasisDescription, 'Theo % sinh khối');
      expect(schedule.productName, 'Thức ăn CP 01');
      expect(schedule.cancellationType, isNull);
    });



    test('parses OperationSchedule with season and pond names', () {
      final json = <String, dynamic>{
        'id': 'sched-season-info',
        'seasonId': 'season-1',
        'protocolItemId': 'item-1',
        'operationType': 'FEEDING',
        'scheduledAt': '2026-10-08T06:00:00Z',
        'plannedQuantity': 47.2,
        'unit': 'kg',
        'doseBasisSnapshot': 'PERCENT_BIOMASS',
        'doseValueSnapshot': 0.973,
        'calculationVersion': 'dose-v1',
        'status': 'COMPLETED',
        'season': {
          'id': 'season-1',
          'name': 'Vụ test - Đang nuôi mới',
          'pond': {
            'id': 'pond-1',
            'name': 'Ao Làng Óng',
          },
        },
      };

      final schedule = OperationSchedule.fromJson(json);
      expect(schedule.seasonName, 'Vụ test - Đang nuôi mới');
      expect(schedule.pondName, 'Ao Làng Óng');
    });

    test('parses OperationSchedule in cancelled state', () {
      final json = <String, dynamic>{
        'id': 'sched-cancelled',
        'seasonId': 'season-1',
        'protocolItemId': 'item-2',
        'operationType': 'CHEMICAL',
        'scheduledAt': '2026-10-08T10:00:00Z',
        'plannedQuantity': 10.0,
        'unit': 'lít',
        'doseBasisSnapshot': 'PER_M3_WATER',
        'doseValueSnapshot': 2.0,
        'calculationVersion': 'v1',
        'status': 'CANCELLED',
        'cancellationType': 'TREATMENT_ABORTED',
        'cancellationReason': 'Nước đã ổn định, hủy liều xử lý',
        'cancelledAt': '2026-10-08T09:15:00Z',
      };

      final schedule = OperationSchedule.fromJson(json);
      expect(schedule.id, 'sched-cancelled');
      expect(schedule.status, OperationStatus.cancelled);
      expect(schedule.cancellationType, 'TREATMENT_ABORTED');
      expect(schedule.cancellationReason, 'Nước đã ổn định, hủy liều xử lý');
      expect(schedule.cancelledAt, isNotNull);
      expect(schedule.doseBasisDescription, 'Theo m³ nước');
    });

    test('parses OperationListResult and OperationStats', () {
      final listJson = <String, dynamic>{
        'summary': {'planned': 5, 'completed': 3, 'cancelled': 1, 'total': 9},
        'banner': {
          'hasBiomassWarning': true,
          'message': 'Chưa cập nhật sinh khối quá 3 ngày',
        },
        'schedules': <dynamic>[],
        'season': {
          'id': 'season-1',
          'name': 'Vụ 1 - Nuôi thương phẩm',
          'pond': {'id': 'pond-1', 'name': 'Ao A1'},
        },
      };

      final result = OperationListResult.fromJson(listJson);
      expect(result.summary.planned, 5);
      expect(result.summary.completed, 3);
      expect(result.summary.cancelled, 1);
      expect(result.summary.total, 9);
      expect(result.banner.hasBiomassWarning, isTrue);
      expect(result.banner.message, 'Chưa cập nhật sinh khối quá 3 ngày');
      expect(result.seasonName, 'Vụ 1 - Nuôi thương phẩm');
      expect(result.pondName, 'Ao A1');

      final statsJson = <String, dynamic>{
        'total': 10,
        'planned': 4,
        'completed': 5,
        'cancelled': 1,
        'overdue': 1,
        'completionRate': 50.0,
        'byType': {
          'FEEDING': {'total': 6, 'planned': 2, 'completed': 4, 'cancelled': 0},
          'MINERAL': {'total': 4, 'planned': 2, 'completed': 1, 'cancelled': 1},
        },
      };

      final stats = OperationStats.fromJson(statsJson);
      expect(stats.total, 10);
      expect(stats.completionRate, 50.0);
      expect(stats.byType['FEEDING']?.completed, 4);
      expect(stats.byType['MINERAL']?.cancelled, 1);
    });

    test(
      'parses numbers formatted as String (from Prisma Decimal serialization) safely',
      () {
        final scheduleJson = <String, dynamic>{
          'id': 'sched-string-1',
          'seasonId': 'season-1',
          'protocolItemId': 'item-1',
          'operationType': 'FEEDING',
          'scheduledAt': '2026-10-08T07:00:00Z',
          'plannedQuantity': '45.000',
          'unit': 'kg',
          'doseBasisSnapshot': 'PERCENT_BIOMASS',
          'doseValueSnapshot': '3.500',
          'calculationVersion': 'v1',
          'status': 'PLANNED',
          'basisQuantity': '1420.500',
        };
        final schedule = OperationSchedule.fromJson(scheduleJson);
        expect(schedule.plannedQuantity, 45.0);
        expect(schedule.doseValueSnapshot, 3.5);
        expect(schedule.basisQuantity, 1420.5);

        final execJson = <String, dynamic>{
          'id': 'exec-string-1',
          'actualQuantity': '48.25',
          'executedAt': '2026-10-08T07:15:00Z',
        };
        final exec = OperationExecution.fromJson(execJson);
        expect(exec.actualQuantity, 48.25);
      },
    );
  });
}
