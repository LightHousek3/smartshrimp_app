import 'package:smartshrimp_app/features/home/domain/entities/technician_dashboard.dart';

abstract interface class TechnicianDashboardRepository {
  Future<TechnicianDashboard> getOverview();
}
