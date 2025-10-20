// lib/pages/admin/non_cleaning_detail_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_cleancare/data/models/job_model.dart';
import 'package:flutter_cleancare/data/repositories/job_repository.dart';
import 'package:get/get.dart';
import 'package:flutter_cleancare/controllers/job_controller.dart';

class NonCleaningDetailPage extends StatelessWidget {
  final String workerName;

  const NonCleaningDetailPage({super.key, required this.workerName});

  @override
  Widget build(BuildContext context) {
    final jobC = Get.find<JobController>();

    final List<Job> jobs = jobC.nonCleaningJobs
        .where((job) => job.workerName == workerName)
        .toList();

    return Scaffold(
      appBar: AppBar(title: Text(workerName)),
      body: ListView.builder(
        itemCount: jobs.length,
        itemBuilder: (context, index) {
          final job = jobs[index];
          return ListTile(
            leading: const Icon(Icons.build),
            title: Text(job.jobType),
            subtitle: Text(job.description),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Get.to(() => NonCleaningDetailPage(workerName: workerName));
            },
          );
        },
      ),
    );
  }
}
