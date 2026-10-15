import 'package:smartshrimp_app/core/network/api_client.dart';
import 'package:smartshrimp_app/features/home/domain/entities/owner_dashboard.dart';
import 'package:smartshrimp_app/features/home/domain/repositories/owner_dashboard_repository.dart';

/// Read-only repository: the API client owns envelope, refresh and error policy.
final class OwnerDashboardApiService implements OwnerDashboardRepository {
  OwnerDashboardApiService(this._client);
  final ApiClient _client;

  @override
  Future<OwnerDashboard> getOverview() async {
    final response = await _client.get('/owner/dashboard', authenticated: true);
    return OwnerDashboard.parse(response.requireMapData());
  }

  @override
  Future<OwnerFinance> getFinance(FinanceFilter filter) async {
    final response = await _client.get(
      '/owner/dashboard/finance',
      queryParameters: filter.toQuery(),
      authenticated: true,
    );
    return OwnerFinance.parse(response.requireMapData());
  }
}
