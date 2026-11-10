import 'package:smartshrimp_app/core/network/api_client.dart';
import 'package:smartshrimp_app/features/home/domain/entities/technician_dashboard.dart';
import 'package:smartshrimp_app/features/home/domain/repositories/technician_dashboard_repository.dart';

/// Read-only adapter; authentication, envelope and retries remain owned by ApiClient.
final class TechnicianDashboardApiService
    implements TechnicianDashboardRepository {
  TechnicianDashboardApiService(this._client);
  final ApiClient _client;

  @override
  Future<TechnicianDashboard> getOverview() async => TechnicianDashboard.parse(
    (await _client.get(
      '/technician/dashboard',
      authenticated: true,
    )).requireMapData(),
  );
}
