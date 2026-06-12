import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../core/utils/service_locator.dart';
import '../../../../core/network/api_client.dart';

class AuthRepository {
  final Dio _dio;
  final FlutterSecureStorage _storage;

  AuthRepository()
    : _dio = sl<ApiClient>().dio,
      _storage = const FlutterSecureStorage();

  Future<bool> login(String username, String password) async {
    try {
      final formData = FormData.fromMap({
        'username': username,
        'password': password,
      });

      final response = await _dio.post('/auth/admin/login', data: formData);

      if (response.statusCode == 200) {
        final token = response.data['access_token'];
        await _storage.write(key: 'admin_access_token', value: token);
        return true;
      }
      return false;
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['detail'] ?? 'Login failed due to server error',
      );
    } catch (e) {
      throw Exception('An unexpected network error occurred');
    }
  }

  Future<void> logout() async {
    await _storage.delete(key: 'admin_access_token');
  }

  Future<bool> isAuthenticated() async {
    final token = await _storage.read(key: 'admin_access_token');
    return token != null;
  }
}
