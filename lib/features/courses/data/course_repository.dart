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

  Future<void> createCourse(
    String title,
    String watermarkText,
    String watermarkColor,
  ) async {
    await _apiClient.dio.post(
      '/course/admin/create',
      data: {
        'title': title,
        'watermark_text': watermarkText,
        'watermark_color': watermarkColor,
        'is_active': true,
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
    String? videoUrl,
    int? duration,
    String? attachmentUrl,
    int? vaultId,
  }) async {
    await _apiClient.dio.post(
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
    await _apiClient.dio.put(
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
  }

  Future<void> deleteNode(int nodeId) async {
    await _apiClient.dio.delete('/course/admin/node/delete/$nodeId');
  }

  Future<void> autoBuildCourse(int courseId, String batchName) async {
    await _apiClient.dio.post(
      '/course/admin/autobuild',
      data: {'course_id': courseId, 'batch_name': batchName},
    );
  }

  Future<Map<String, dynamic>> exportVault() async {
    final res = await _apiClient.dio.get('/course/admin/export');
    return res.data;
  }

  Future<void> importVault(Map<String, dynamic> data) async {
    await _apiClient.dio.post('/course/admin/import', data: data);
  }
}
