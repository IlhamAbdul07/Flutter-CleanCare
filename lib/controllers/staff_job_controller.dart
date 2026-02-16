import 'package:flutter_cleancare/core/services/api_service.dart';
import 'package:flutter_cleancare/data/models/job_model.dart';
import 'package:flutter_cleancare/widgets/app_snackbar_raw.dart';
import 'package:get/get.dart';

class StaffJobController extends GetxController {
  var jobs = <Jobs>[].obs;

  // @override
  // void onInit() {
  //   super.onInit();
  // }

  Future<void> fetchJobs(
    int? userId,
    int? taskId,
    int? taskTypeId,
    String? floor,
    DateTime? date,
  ) async {
    late Map<String, String> param = {'no_paging': 'yes'};
    if (userId != null) {
      param['user_id'] = userId.toString();
    }
    if (taskId != null) {
      param['task_id'] = taskId.toString();
    }
    if (taskTypeId != null) {
      param['task_type_id'] = taskTypeId.toString();
    }
    if (floor != null) {
      param['floor'] = floor;
    }
    if (date != null) {
      final createdDate = ApiService.formatDateRange(date);
      param['created_at'] = createdDate;
    }
    final response = await ApiService.handleWork(method: 'GET', params: param);
    if (response != null && response['success'] == true) {
      final data = response['data'];
      final List<dynamic> jobList = data['data'] ?? [];
      final jobsData = jobList.map((e) => Jobs.fromJson(e)).toList();
      jobs.value = jobsData;
    } else {
      final errorData = response?['data'];
      final message =
          errorData?['message'] ?? 'Terjadi kesalahan tidak diketahui';
      AppSnackbarRaw.error(message);
    }
  }
}
