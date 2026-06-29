import '../../../../core/network/api_client.dart';

class AdminCourseRepository {
  final ApiClient _apiClient;

  AdminCourseRepository(this._apiClient);

  Future<List<dynamic>> getCourses() async {
    final res = await _apiClient.dio.get('/course/admin/list');
    return res.data as List<dynamic>? ?? [];
  }

  Future<Map<String, dynamic>> getCourseTree(int courseId) async {
    final res = await _apiClient.dio.get('/course/admin/view/$courseId');
    return res.data;
  }

  Future<void> createCourse(String title, String baseStreamUrl) async {
    await _apiClient.dio.post(
      '/course/admin/create',
      data: {
        'title': title,
        'base_stream_url': baseStreamUrl,
        'is_active': true,
      },
    );
  }

  Future<void> updateCourse(
    int courseId,
    String title,
    String baseStreamUrl,
    bool isActive,
  ) async {
    await _apiClient.dio.put(
      '/course/admin/update/$courseId',
      data: {
        'title': title,
        'base_stream_url': baseStreamUrl,
        'is_active': isActive,
      },
    );
  }

  Future<void> deleteCourse(int courseId) async {
    await _apiClient.dio.delete('/course/admin/delete/$courseId');
  }

  Future<void> createNode(
    int courseId,
    int? parentId,
    String itemType,
    String title,
    int sortOrder, {
    int? duration,
  }) async {
    await _apiClient.dio.post(
      '/course/admin/node/create',
      data: {
        'course_id': courseId,
        'parent_id': parentId,
        'item_type': itemType,
        'title': title,
        'sort_order': sortOrder,
        'duration': duration,
      },
    );
  }

  Future<void> updateNode(
    int nodeId,
    String title,
    int sortOrder, {
    int? duration,
  }) async {
    await _apiClient.dio.put(
      '/course/admin/node/update/$nodeId',
      data: {'title': title, 'sort_order': sortOrder, 'duration': duration},
    );
  }

  Future<void> deleteNode(int nodeId) async {
    await _apiClient.dio.delete('/course/admin/node/delete/$nodeId');
  }

  Future<void> injectEncryptorKeys(Map<String, dynamic> data) async {
    await _apiClient.dio.post('/admin/vault/bulk', data: data);
  }

  Future<void> autoBuildCourse(int courseId, String batchName) async {
    await _apiClient.dio.post(
      '/admin/vault/trigger-autobuild/$courseId',
      data: {'batch_name': batchName},
    );
  }

  Future<void> reorderNodes(List<Map<String, dynamic>> reorderData) async {
    await _apiClient.dio.post('/course/admin/node/reorder', data: reorderData);
  }
}
