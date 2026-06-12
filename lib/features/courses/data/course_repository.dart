import 'package:dio/dio.dart';
import '../../../../core/utils/service_locator.dart';
import '../../../../core/network/api_client.dart';

class AdminCourseRepository {
  final Dio _dio;

  AdminCourseRepository() : _dio = sl<ApiClient>().dio;

  Future<List<dynamic>> getAllCourses() async {
    try {
      final response = await _dio.get('/admin/courses');
      if (response.statusCode == 200) {
        return response.data['courses'] as List<dynamic>;
      }
      throw Exception('Failed to load courses');
    } on DioException catch (e) {
      throw Exception(e.response?.data['detail'] ?? 'Network error');
    }
  }

  Future<void> createCourse(
    String title,
    String watermarkText,
    String watermarkColor,
  ) async {
    try {
      await _dio.post(
        '/admin/course',
        data: {
          'title': title,
          'watermark_text': watermarkText,
          'watermark_color': watermarkColor,
        },
      );
    } on DioException catch (e) {
      throw Exception(e.response?.data['detail'] ?? 'Failed to create course');
    }
  }

  Future<void> deleteCourse(int courseId) async {
    try {
      await _dio.delete('/admin/course/$courseId');
    } on DioException catch (e) {
      throw Exception(e.response?.data['detail'] ?? 'Failed to delete course');
    }
  }

  Future<Map<String, dynamic>> getCourseTree(int courseId) async {
    try {
      final response = await _dio.get('/admin/course/$courseId');
      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      }
      throw Exception('Failed to load course details');
    } on DioException catch (e) {
      throw Exception(e.response?.data['detail'] ?? 'Network error');
    }
  }

  Future<void> createNode(
    int courseId,
    int? parentId,
    String itemType,
    String title,
    int sortOrder, {
    String? videoUrl,
    int? duration,
  }) async {
    try {
      await _dio.post(
        '/admin/node',
        data: {
          'course_id': courseId,
          'parent_id': parentId,
          'item_type': itemType,
          'title': title,
          'sort_order': sortOrder,
          'video_url': videoUrl,
          'duration': duration,
        },
      );
    } on DioException catch (e) {
      throw Exception(e.response?.data['detail'] ?? 'Failed to create node');
    }
  }

  Future<void> updateNode(
    int nodeId,
    String title,
    int sortOrder, {
    String? videoUrl,
    int? duration,
  }) async {
    try {
      await _dio.put(
        '/admin/node/$nodeId',
        data: {
          'title': title,
          'sort_order': sortOrder,
          'video_url': videoUrl,
          'duration': duration,
        },
      );
    } on DioException catch (e) {
      throw Exception(e.response?.data['detail'] ?? 'Failed to update node');
    }
  }

  Future<void> deleteNode(int nodeId) async {
    try {
      await _dio.delete('/admin/node/$nodeId');
    } on DioException catch (e) {
      throw Exception(e.response?.data['detail'] ?? 'Failed to delete node');
    }
  }
}
