import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_cleancare/core/services/api_service.dart';
import 'package:flutter_cleancare/data/models/job_model.dart';
import 'package:flutter_cleancare/widgets/app_snackbar_raw.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class JobController extends GetxController {
  final selectedDate = Rxn<DateTime>();
  var isCleaning = true.obs;
  final cleaningSummaryList = <Map<String, dynamic>>[].obs;
  final nonCleaningSummaryList = <Map<String, dynamic>>[].obs;
  var jobs = <Jobs>[].obs;

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

  void refreshDashboard(bool cleaning, DateTime? date) {
    isCleaning.value = cleaning;
    selectedDate.value = date;
    cleaningSummary(1, selectedDate.value);
    cleaningSummary(2, selectedDate.value);
  }

  Future<void> exportJobs(DateTime? date) async {
    try {
      if (Platform.isAndroid) {
        final status = await Permission.storage.request();
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

  Future<void> fetchJobs(int? userId, int? taskId, int? taskTypeId, String? floor, DateTime? date) async {
    late Map<String, String> param = {};
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
}
