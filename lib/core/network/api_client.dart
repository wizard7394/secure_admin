import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiClient {
  final Dio _dio;
  final FlutterSecureStorage _storage;

  ApiClient()
    : _storage = const FlutterSecureStorage(),
      _dio = Dio(
        BaseOptions(
          baseUrl: 'https://api.devstorage.site/api/v1',
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
          headers: {'Content-Type': 'application/json'},
        ),
      ) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // خواندن مستقیم و زنده از استوریج در لحظه شلیک درخواست
          final token = await _storage.read(key: 'admin_access_token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) async {
          // اگر ارور 401 بود و یوزر واقعاً توکن داشت، یعنی توکن منقضی شده
          if (e.response?.statusCode == 401) {
            final hasToken =
                await _storage.read(key: 'admin_access_token') != null;
            if (hasToken) {
              await _storage.delete(key: 'admin_access_token');
            }
          }
          return handler.next(e);
        },
      ),
    );
  }

  Dio get dio => _dio;
}
