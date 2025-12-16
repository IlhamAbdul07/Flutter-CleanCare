import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_cleancare/core/services/api_service.dart';
import 'package:flutter_cleancare/data/models/job_model.dart';
import 'package:flutter_cleancare/data/models/job_single_model.dart';
import 'package:flutter_cleancare/widgets/app_snackbar_raw.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

class JobController extends GetxController {
  final selectedDate = Rxn<DateTime>();
  var isCleaning = true.obs;
  final cleaningSummaryList = <Map<String, dynamic>>[].obs;
  final nonCleaningSummaryList = <Map<String, dynamic>>[].obs;
  var jobs = <Jobs>[].obs;
  var jobSingle = Rxn<JobSingle>();
  var selectedImageBeforeEdit = Rx<XFile?>(null);
  var selectedImageAfterEdit = Rx<XFile?>(null);
  final imageBeforeC = ''.obs;
  final imageAfterC = ''.obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    selectedDate.value = DateTime.now();
    cleaningSummary(1, selectedDate.value);
    cleaningSummary(2, selectedDate.value);
  }

  void pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value ?? DateTime.now(),
      firstDate: DateTime(2025, 1, 1),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      selectedDate.value = picked;
      cleaningSummary(1, selectedDate.value);
      cleaningSummary(2, selectedDate.value);
    }
  }

  void setCleaning(bool value) {
    isCleaning.value = value;
  }

  Future<void> refreshDashboard(bool cleaning, DateTime? date) async {
    isCleaning.value = cleaning;
    selectedDate.value = date;
    await cleaningSummary(1, selectedDate.value);
    await cleaningSummary(2, selectedDate.value);
  }

  Future<void> exportJobs(DateTime? date) async {
    try {
      if (Platform.isAndroid) {
        final status = await Permission.manageExternalStorage.request();
        if (!status.isGranted) {
          AppSnackbarRaw.error('Izin penyimpanan ditolak.');
          return;
        }
      }

      final response = await ApiService.exportWorks(date);
      if (response.statusCode == 200) {
        String filename = 'works.pdf';
        final contentDisposition = response.headers['content-disposition'];
        if (contentDisposition != null) {
          final regex = RegExp(r'filename="?([^"]+)"?');
          final match = regex.firstMatch(contentDisposition);
          if (match != null) filename = match.group(1)!;
        }
        Directory? downloadsDir;
        if (Platform.isAndroid) {
          downloadsDir = Directory('/storage/emulated/0/Download');
        } else {
          downloadsDir = await getDownloadsDirectory();
        }

        if (downloadsDir == null || !downloadsDir.existsSync()) {
          AppSnackbarRaw.error('Folder Download tidak ditemukan.');
          return;
        }

        final filePath = '${downloadsDir.path}/$filename';
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
        AppSnackbarRaw.success('File tersimpan di folder Download: $filename');
      } else {
        AppSnackbarRaw.error('Gagal export (${response.statusCode})');
      }
    } catch (e) {
      AppSnackbarRaw.error('Terjadi kesalahan: $e');
    }
  }

  Future<void> cleaningSummary(int taskId, DateTime? date) async {
    final createdDate = ApiService.formatDateRange(date);
    final response = await ApiService.handleWork(
      method: 'GET',
      dashboardAdmin: true,
      params: {
        'task_id': taskId.toString(),
        'created_at': createdDate,
      },
    );

    if (response != null && response['success'] == true) {
      final data = response['data'];
      final List<dynamic>? dataList = data['data'];

      final List<Map<String, dynamic>> result = dataList != null
          ? dataList.map((e) => Map<String, dynamic>.from(e)).toList()
          : [];

      if (taskId == 1) {
        cleaningSummaryList.value = result;
      } else {
        nonCleaningSummaryList.value = result;
      }
    } else {
      AppSnackbarRaw.error("Gagal memuat data");
    }
  }

  Future<void> fetchJobs(bool? notFinished, int? userId, int? taskId, int? taskTypeId, String? floor, DateTime? date, Map<String, String>? order) async {
    late Map<String, String> param = {};
    if (notFinished != null){
      param['not_finished'] = 'yes';
    }
    if (userId != null){
      param['user_id'] = userId.toString();
    }
    if (taskId != null){
      param['task_id'] = taskId.toString();
    }
    if (taskTypeId != null){
      param['task_type_id'] = taskTypeId.toString();
    }
    if (floor != null){
      param['floor'] = floor;
    }
    if (date != null){
      final createdDate = ApiService.formatDateRange(date);
      param['created_at'] = createdDate;
    }
    if (order != null){
      param['order'] = order['order'].toString();
      param['order_by'] = order['order_by'].toString();
    }
    final response = await ApiService.handleWork(
      method: 'GET',
      params: param,
    );
    if (response != null && response['success'] == true) {
      final data = response['data'];
      final List<dynamic> jobList = data['data'] ?? [];
      final jobsData = jobList.map((e) => Jobs.fromJson(e)).toList();
      jobs.value = jobsData;
    } else {
      final errorData = response?['data'];
      final message = errorData?['message'] ?? 'Terjadi kesalahan tidak diketahui';
      AppSnackbarRaw.error(message);
    }
  }

  Future<void> getById(int id) async {
    final response = await ApiService.handleWork(
      method: 'GET',
      workId: id,
    );
    if (response != null && response['success'] == true) {
      final data = response['data']['data'];
      if (data != null) {
        final singleJob = JobSingle.fromJson(data);
        jobSingle.value = singleJob;
      }else{
        jobSingle.value = null;
        final errorMessage = response!['data']?['message'] ??
        response['message'] ??
        'Terjadi kesalahan saat registrasi.';
        AppSnackbarRaw.error(errorMessage);
      }
    }
  }

  void pickImageBeforeEdit() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedImageBeforeEdit.value = image;
    }
  }

  void clearImageBeforeEdit() {
    selectedImageBeforeEdit.value = null;
    imageBeforeC.value = '';
  }

  void pickImageAfterEdit() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedImageAfterEdit.value = image;
    }
  }

  void clearImageAfterEdit() {
    selectedImageAfterEdit.value = null;
    imageAfterC.value = '';
  }

  void setIsLoading(bool value) {
    isLoading.value = value;
  }

  void resetDetailJobState() {
    jobSingle.value = null;
    selectedImageBeforeEdit.value = null;
    selectedImageAfterEdit.value = null;
    imageBeforeC.value = '';
    imageAfterC.value = '';
    isLoading.value = false;
  }

  Future<String> updateById(int id, Map<String, dynamic> data, XFile? imgBefore, XFile? imgAfter, String contentType) async {
    final List<http.MultipartFile> files = [];
    if (imgBefore != null) {
      final file = await http.MultipartFile.fromPath('image_before', imgBefore.path);
      files.add(file);
    }
    if (imgAfter != null) {
      final file = await http.MultipartFile.fromPath('image_after', imgAfter.path);
      files.add(file);
    }

    final response = await ApiService.handleWork(
      method: 'PUT',
      workId: id,
      data: data,
      listFile: files,
      contentType: contentType
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
    final response = await ApiService.handleWork(
      method: 'DELETE',
      workId: id,
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

  Future<String> create(int taskId, int taskTypeId, String floor, String info, XFile? imgBefore, XFile? imgAfter)  async {
    final List<http.MultipartFile> files = [];
    if (imgBefore != null) {
      final file = await http.MultipartFile.fromPath('image_before', imgBefore.path);
      files.add(file);
    }
    if (imgAfter != null) {
      final file = await http.MultipartFile.fromPath('image_after', imgAfter.path);
      files.add(file);
    }

    final Map<String, dynamic> data = {
      'task_id': taskId,
      'task_type_id': taskTypeId,
      'floor': floor,
      'info': info,
    };

    final response = await ApiService.handleWork(
      method: 'POST',
      data: data,
      listFile: files,
      contentType: 'multipart/form-data'
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
