import 'package:smartshrimp_app/features/home/domain/entities/owner_dashboard.dart';

abstract interface class OwnerDashboardRepository {
  Future<OwnerDashboard> getOverview();
  Future<OwnerFinance> getFinance(FinanceFilter filter);
}
