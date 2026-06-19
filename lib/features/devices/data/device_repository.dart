import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../../../core/utils/service_locator.dart';

class DeviceRepository {
  final ApiClient _apiClient = sl<ApiClient>();

  Future<List<dynamic>> getAllDevices() async {
    try {
      final response = await _apiClient.dio.get('/admin/devices');
      return response.data['devices'] ?? [];
    } on DioException catch (e) {
      throw Exception(e.response?.data['detail'] ?? 'Failed to fetch devices');
    }
  }

  Future<List<dynamic>> getBlacklistedDevices() async {
    try {
      final response = await _apiClient.dio.get('/admin/security/blacklist');
      return response.data['blacklisted_devices'] ?? [];
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['detail'] ?? 'Failed to fetch blacklist',
      );
    }
  }

  Future<void> unblockDevice(String hardwareId) async {
    try {
      await _apiClient.dio.delete('/admin/security/blacklist/$hardwareId');
    } on DioException catch (e) {
      throw Exception(e.response?.data['detail'] ?? 'Failed to unblock device');
    }
  }
}
