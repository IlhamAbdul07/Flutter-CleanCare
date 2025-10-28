import 'package:flutter_cleancare/core/services/api_service.dart';
import 'package:flutter_cleancare/data/models/comment_model.dart';
import 'package:flutter_cleancare/widgets/app_snackbar_raw.dart';
import 'package:get/get.dart';

class CommentController extends GetxController {
  var comment = <Comment>[].obs;
  var filterJob = 0.obs;

  Future<void> setFilterJob(int jobId) async {
    filterJob.value = jobId;
    await refreshComment();
  }

  Future<void> refreshComment() async {
    late Map<String, String> param = {
      'no_paging': 'yes',
      'order': 'created_at',
      'order_by': 'asc',
    };
    int? workId;
    if (filterJob.value!=0){
      workId = filterJob.value;
    }
    final response = await ApiService.handleComment(
      method: 'GET',
      commentId: workId,
      params: param,
    );
    if (response != null && response['success'] == true) {
      final data = response['data'];
      final List<dynamic> commentList = data['data'] ?? [];
      final commentData = commentList.map((e) => Comment.fromJson(e)).toList();
      comment.value = commentData;
    } else {
      final errorData = response?['data'];
      final message = errorData?['message'] ?? 'Terjadi kesalahan tidak diketahui';
      AppSnackbarRaw.error(message);
    }
  }

  Future<String> create(int workId, String comment) async {
    final Map<String, dynamic> data = {
      'work_id': workId,
      'comment': comment,
    };
    final response = await ApiService.handleComment(
      method: 'POST',
      data: data,
    );
    if (response != null && response['success'] == true) {
      return 'ok';
    } else {
      final errorMessage = response!['data']?['message'] ??
        response['message'] ??
        'Terjadi kesalahan saat registrasi.';
      return errorMessage;
    }
  }

  Future<String> deleteById(int id) async {
    final response = await ApiService.handleComment(
      method: 'DELETE',
      commentId: id,
    );
    if (response != null && response['success'] == true) {
      return 'ok';
    } else {
      final errorMessage = response!['data']?['message'] ??
        response['message'] ??
        'Terjadi kesalahan saat registrasi.';
      return errorMessage;
    }
  }

  Future<String> updateById(int id, String comment) async {
    final Map<String, dynamic> data = {
      'comment': comment,
    };
    final response = await ApiService.handleComment(
      method: 'PUT',
      commentId: id,
      data: data,
    );
    if (response != null && response['success'] == true) {
      return 'ok';
    } else {
      final errorMessage = response!['data']?['message'] ??
        response['message'] ??
        'Terjadi kesalahan saat registrasi.';
      return errorMessage;
    }
  }
}
