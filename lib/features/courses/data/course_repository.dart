import '../../../core/network/api_client.dart';

class AdminCourseRepository {
  final ApiClient apiClient;

  AdminCourseRepository(this.apiClient);

  Future<List<Map<String, dynamic>>> getAllCourses() async {
    try {
      final response = await apiClient.dio.get('/course/admin/list');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((e) => e as Map<String, dynamic>).toList();
      }
      throw Exception('Failed to load courses: ${response.statusCode}');
    } catch (e) {
      throw Exception('Error fetching admin courses: $e');
    }
  }

  Future<Map<String, dynamic>> createCourse(
    String title,
    String watermarkText,
    String watermarkColor,
  ) async {
    try {
      final response = await apiClient.dio.post(
        '/course/admin/create',
        data: {
          'title': title,
          'watermark_text': watermarkText,
          'watermark_color': watermarkColor,
          'is_active': true,
        },
      );
      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      }
      throw Exception('Failed to create course');
    } catch (e) {
      throw Exception('Error creating course: $e');
    }
  }

  Future<Map<String, dynamic>> updateCourse(
    int courseId,
    Map<String, dynamic> courseData,
  ) async {
    try {
      final response = await apiClient.dio.put(
        '/course/admin/update/$courseId',
        data: courseData,
      );
      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      }
      throw Exception('Failed to update course');
    } catch (e) {
      throw Exception('Error updating course: $e');
    }
  }

  Future<void> deleteCourse(int courseId) async {
    try {
      await apiClient.dio.delete('/course/admin/delete/$courseId');
    } catch (e) {
      throw Exception('Error deleting course: $e');
    }
  }

  Future<Map<String, dynamic>> getCourseTree(int courseId) async {
    try {
      final response = await apiClient.dio.get('/course/view/$courseId');
      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      }
      throw Exception('Failed to load course details');
    } catch (e) {
      throw Exception('Error fetching course tree: $e');
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
    String? attachmentUrl,
    int? vaultId,
  }) async {
    try {
      await apiClient.dio.post(
        '/course/admin/node/create',
        data: {
          'course_id': courseId,
          'parent_id': parentId,
          'item_type': itemType,
          'title': title,
          'sort_order': sortOrder,
          'video_url': videoUrl,
          'duration': duration,
          'attachment_url': attachmentUrl,
          'vault_id': vaultId,
        },
      );
    } catch (e) {
      throw Exception('Error creating node: $e');
    }
  }

  Future<void> updateNode(
    int nodeId,
    String title,
    int sortOrder, {
    String? videoUrl,
    int? duration,
    String? attachmentUrl,
    int? vaultId,
  }) async {
    try {
      await apiClient.dio.put(
        '/course/admin/node/update/$nodeId',
        data: {
          'title': title,
          'sort_order': sortOrder,
          'video_url': videoUrl,
          'duration': duration,
          'attachment_url': attachmentUrl,
          'vault_id': vaultId,
        },
      );
    } catch (e) {
      throw Exception('Error updating node: $e');
    }
  }

  Future<void> deleteNode(int nodeId) async {
    try {
      await apiClient.dio.delete('/course/admin/node/delete/$nodeId');
    } catch (e) {
      throw Exception('Error deleting node: $e');
    }
  }

  Future<void> autoBuildCourse(int courseId, String batchName) async {
    try {
      await apiClient.dio.post(
        '/course/admin/autobuild',
        data: {'course_id': courseId, 'batch_name': batchName},
      );
    } catch (e) {
      throw Exception('Error autobuilding course: $e');
    }
  }
}
