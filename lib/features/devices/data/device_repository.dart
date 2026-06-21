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

  Future<void> toggleDeviceBlock(
    int deviceId,
    bool isBlocked,
    String reason,
  ) async {
    try {
      await _apiClient.dio.put(
        '/admin/devices/$deviceId/block',
        data: {'is_blocked': isBlocked, 'reason': reason}, // <--- دلیل اضافه شد
      );
    } on DioException catch (e) {
      throw Exception(e.response?.data['detail'] ?? 'Failed to toggle status');
    }
  }

  Future<void> unblockDevice(String hardwareId, String reason) async {
    try {
      // <--- متد به POST تغییر کرد و بادی می‌گیره
      await _apiClient.dio.post(
        '/admin/security/blacklist/$hardwareId/unblock',
        data: {'reason': reason},
      );
    } on DioException catch (e) {
      throw Exception(e.response?.data['detail'] ?? 'Failed to unblock device');
    }
  }
}
