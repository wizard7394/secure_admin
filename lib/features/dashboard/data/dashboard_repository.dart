import '../../../core/network/api_client.dart';

class DashboardRepository {
  final ApiClient apiClient;

  DashboardRepository(this.apiClient);

  Future<Map<String, dynamic>> getDashboardStats() async {
    try {
      final response = await apiClient.dio.get('/dashboard/stats');

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        throw Exception('Server returned status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error or server unreachable: $e');
    }
  }
}
