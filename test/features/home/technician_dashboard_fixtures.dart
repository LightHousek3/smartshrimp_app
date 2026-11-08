import 'package:smartshrimp_app/features/home/domain/entities/technician_dashboard.dart';
import 'package:smartshrimp_app/features/home/domain/repositories/technician_dashboard_repository.dart';

Map<String, dynamic> technicianDashboardJson() => {
  'date': '2026-11-08',
  'serverNow': '2026-11-08T08:00:00Z',
  'dayEndExclusive': '2026-11-08T17:00:00Z',
  'summary': {
    'activeSeasonCount': 4,
    'openTaskCount': 8,
    'unresolvedActiveSeasonCaseCount': 2,
  },
  'alerts': <Map<String, dynamic>>[],
  'tasks': [
    {
      'id': 'task-1',
      'title': 'Kiểm tra quạt nước',
      'priority': 'HIGH',
      'status': 'PENDING',
      'dueAt': null,
    },
  ],
  'operationGroups': [
    for (final id in ['a', 'b', 'c', 'd'])
      {
        'seasonId': id,
        'seasonName': 'Vụ $id',
        'pondName': 'Ao ${id.toUpperCase()}',
        'farmName': 'Trại Cà Mau',
        'items': [
          for (var i = 0; i < 8; i++)
            {
              'id': 'operation-$id-$i',
              'operationType': 'FEEDING',
              'scheduledAt':
                  '2026-11-08T${(9 + i).toString().padLeft(2, '0')}:00:00Z',
              'productName': 'Thức ăn $i',
              'plannedQuantity': i == 0 ? 0.00001 : 12.345,
              'unit': 'KG',
            },
        ],
      },
  ],
  'seasons': [
    for (final id in ['a', 'b', 'c'])
      {
        'seasonId': id,
        'seasonName': 'Vụ $id',
        'pondName': 'Ao ${id.toUpperCase()}',
        'farmName': 'Trại Cà Mau',
        'cultureDay': 60,
        'biomassState': id == 'a' ? 'RECORDED' : 'MISSING',
        'biomassKg': id == 'a' ? 1234.567 : null,
        'biomassRecordedAt': id == 'a' ? '2026-11-07T07:00:00Z' : null,
      },
  ],
};

class TechnicianFixtureRepository implements TechnicianDashboardRepository {
  int overviewCalls = 0;
  @override
  Future<TechnicianDashboard> getOverview() async {
    overviewCalls++;
    return TechnicianDashboard.parse(technicianDashboardJson());
  }
}
