import 'package:dio/dio.dart';
import '../../../../core/utils/service_locator.dart';
import '../../../../core/network/api_client.dart';

class DashboardRepository {
  final Dio _dio;

  DashboardRepository() : _dio = sl<ApiClient>().dio;

  Future<Map<String, dynamic>> getDashboardStats() async {
    try {
      final response = await _dio.get('/dashboard/stats');
      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      }
      throw Exception('Failed to load dashboard statistics');
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['detail'] ?? 'Server error fetching statistics',
      );
    } catch (e) {
      throw Exception('Unexpected network error occurred');
    }
  }
}
