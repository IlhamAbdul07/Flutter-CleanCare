// lib/controllers/job_controller.dart
import 'package:flutter/material.dart';
import 'package:flutter_cleancare/data/models/job_model.dart';
import 'package:flutter_cleancare/data/repositories/job_repository.dart';
import 'package:get/get.dart';

class JobController extends GetxController {
  final _repo = JobRepository();

  var isCleaning = true.obs; // default: tampilkan cleaning
  var jobs = <Job>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchJobs(); // ambil data awal
  }

  // 🔹 Ambil semua data dari repository
  void fetchJobs() {
    jobs.value = _repo.getAllJobs();
  }

  // 🔹 Refresh data (misal dari pull-to-refresh)
  Future<void> refreshJobs() async {
    await Future.delayed(const Duration(milliseconds: 500)); // simulasi delay
    fetchJobs();
  }

  // 🔹 Ganti mode tampilan Cleaning / Non-Cleaning
  void setCleaning(bool value) {
    isCleaning.value = value;
  }

  // 🔹 Ambil hanya cleaning jobs
  List<Job> get cleaningJobs =>
      jobs.where((j) => j.jobType == 'cleaning').toList();

  // 🔹 Ambil hanya non-cleaning jobs
  List<Job> get nonCleaningJobs =>
      jobs.where((j) => j.jobType == 'non-cleaning').toList();

  // 🔹 Group data cleaning by floor
  Map<int, int> get cleaningSummary {
    final cleaningJobs = jobs.where((j) => j.jobType == 'cleaning');
    final Map<int, int> grouped = {};
    for (var job in cleaningJobs) {
      grouped[job.floor] = (grouped[job.floor] ?? 0) + 1;
    }
    return grouped;
  }

  // 🔹 Group data non-cleaning by worker name
  Map<String, int> get nonCleaningSummary {
    final nonCleaningJobs = jobs.where((j) => j.jobType == 'non-cleaning');
    final Map<String, int> grouped = {};
    for (var job in nonCleaningJobs) {
      grouped[job.workerName] = (grouped[job.workerName] ?? 0) + 1;
    }
    return grouped;
  }

  // 🔹 Ambil semua cleaning jobs berdasarkan floor
  List<Job> getCleaningJobsByFloor(int floor) {
    return jobs
        .where((j) => j.jobType == 'cleaning' && j.floor == floor)
        .toList();
  }

  // 🔹 Ambil semua non-cleaning jobs berdasarkan worker
  List<Job> getNonCleaningJobsByWorker(String workerName) {
    return jobs
        .where((j) => j.jobType == 'non-cleaning' && j.workerName == workerName)
        .toList();
  }

  // 🔹 Filter berdasarkan tanggal (optional, buat filter ke depan)
  var selectedDate = Rxn<DateTime>(); // Rxn artinya nullable observable

  void pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      selectedDate.value = picked;
    }
  }
}
