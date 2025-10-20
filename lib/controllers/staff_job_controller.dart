import 'package:flutter_cleancare/data/models/staff_job_model.dart';
import 'package:flutter_cleancare/data/repositories/staff_job_repository.dart';
import 'package:get/get.dart';

class StaffJobController extends GetxController {
  final StaffJobRepository _repo = StaffJobRepository();

  final RxList<StaffJobModel> jobList = <StaffJobModel>[].obs;
  RxBool isCleaning = true.obs;
  RxList<StaffJobModel> cleaningSummary = <StaffJobModel>[].obs;
  RxList<StaffJobModel> nonCleaningSummary = <StaffJobModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchJobs();
  }

  void fetchJobs() {
    final all = _repo.getAllJobs();
    cleaningSummary.assignAll(all.where((e) => e.jobType == 'Cleaning'));
    nonCleaningSummary.assignAll(all.where((e) => e.jobType == 'Non-Cleaning'));
  }

  void addJob({
    required String id,
    required String jobName,
    required String jobType,
    required String location,
    required DateTime completedAt,
    required String notes,
  }) {
    _repo.addJob(
      StaffJobModel(
        id: id,
        jobName: jobName,
        jobType: jobType,
        location: location,
        completedAt: completedAt,
        notes: notes,
      ),
    );
    fetchJobs();
  }

  void deleteJob(String id) {
    _repo.removeJob(id);
    fetchJobs();
  }
}
