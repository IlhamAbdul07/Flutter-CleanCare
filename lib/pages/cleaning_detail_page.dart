// lib/pages/admin/cleaning_detail_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_cleancare/data/models/job_model.dart';
import 'package:get/get.dart';
import 'package:flutter_cleancare/controllers/job_controller.dart';

class CleaningDetailPage extends StatelessWidget {
  final String floor; // dikirim dari halaman sebelumnya

  const CleaningDetailPage({super.key, required this.floor});

  @override
  Widget build(BuildContext context) {
    final jobC = Get.find<JobController>();

    // ambil semua pekerjaan cleaning di lantai ini
    final List<Job> jobs = jobC.cleaningJobs
        .where((job) => job.floor == floor)
        .toList();

    return Scaffold(
      appBar: AppBar(title: Text('Lantai $floor')),
      body: ListView.builder(
        itemCount: jobs.length,
        itemBuilder: (context, index) {
          final job = jobs[index];
          return ListTile(
            leading: const Icon(Icons.cleaning_services),
            title: Text(job.jobType),
            subtitle: Text(job.description),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Get.to(() => CleaningDetailPage(floor: floor));
            },
          );
        },
      ),
    );
  }
}
