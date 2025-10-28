import 'package:flutter_cleancare/core/services/api_service.dart';
import 'package:flutter_cleancare/widgets/app_snackbar_raw.dart';
import 'package:get/get.dart';
import 'package:flutter_cleancare/data/models/tasks_model.dart';

class TaskController extends GetxController {
  var tasks = <Tasks>[].obs;
  var searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    refreshTasks();
  }

  void searchTask(String query) {
    searchQuery.value = query;
    refreshTasks();
  }

  Future<void> refreshTasks() async {
    late Map<String, String> param = {
      'no_paging': 'yes',
    };
    if (searchQuery.value!=''){
      param['search'] = searchQuery.value;
    }
    final response = await ApiService.handleTaskType(
      method: 'GET',
      params: param,
    );
    if (response != null && response['success'] == true) {
      final data = response['data'];
      final List<dynamic> userList = data['data'] ?? [];
      final tasksData = userList.map((e) => Tasks.fromJson(e)).toList();
      tasks.value = tasksData;
    } else {
      final errorData = response?['data'];
      final message = errorData?['message'] ?? 'Terjadi kesalahan tidak diketahui';
      AppSnackbarRaw.error(message);
    }
  }

  Future<String> create(int taskId, String name) async {
    final Map<String, dynamic> data = {
      'task_id': taskId,
      'name': name,
    };

    final response = await ApiService.handleTaskType(
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
    final response = await ApiService.handleTaskType(
      method: 'DELETE',
      taskTypeId: id,
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

  Future<String> updateById(int id, Map<String, dynamic> data) async {
    final response = await ApiService.handleTaskType(
      method: 'PUT',
      taskTypeId: id,
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
