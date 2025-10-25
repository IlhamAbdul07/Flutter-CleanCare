import 'package:flutter/material.dart';
import 'package:flutter_cleancare/controllers/auth_controller.dart';
import 'package:flutter_cleancare/controllers/staff_job_controller.dart';
import 'package:flutter_cleancare/data/models/staff_job_model.dart';
import 'package:flutter_cleancare/pages/add_detail_job.dart';
import 'package:flutter_cleancare/pages/job_detail_page.dart';
// import 'package:flutter_cleancare/widgets/cleaning_staff_widget.dart';
// import 'package:flutter_cleancare/widgets/noncleaning_staff_widget.dart';
import 'package:get/get.dart';

class StaffHomePage extends StatelessWidget {
  const StaffHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authC = Get.find<AuthController>();
    final jobC = Get.put(StaffJobController());
    return Obx(() {
      final currentUser = authC.currentUser.value;
      if (currentUser == null) {
        return const Scaffold(body: Center(child: Text('No user.')));
      }
      return Scaffold(
        backgroundColor: context.theme.colorScheme.background,
        appBar: AppBar(
          backgroundColor: context.theme.colorScheme.background,
          elevation: 0,
          titleSpacing: 16,
          title: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    'Dashboard',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                      color: context.theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Welcome, ${currentUser.name} (${currentUser.roleName})',
                    style: TextStyle(
                      fontSize: 14,
                      color: context.theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: Obx(() {
                      final jobs = jobC.isCleaning.value
                          ? jobC.cleaningSummary
                          : jobC.nonCleaningSummary;

                      return RefreshIndicator(
                        onRefresh: () async {
                          jobC.fetchJobs();
                        },
                        child: jobs.isEmpty
                            ? const Center(child: Text("Belum ada pekerjaan."))
                            : ListView.builder(
                                padding: const EdgeInsets.only(bottom: 80),
                                itemCount: jobs.length,
                                itemBuilder: (context, index) {
                                  final job = jobs[index];
                                  return _buildJobCard(job);
                                },
                              ),
                      );
                    }),
                  ),
                ],
              ),
              Positioned(
                bottom: 16,
                right: 5,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(2, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    color: Colors.white,
                    iconSize: 28,
                    icon: const Icon(Icons.add),
                    tooltip: 'Tambah User',
                    onPressed: () => Get.to(() => const AddDetailJob()),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildJobCard(StaffJobModel job) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Colors.grey.shade400,
          width: 1.0,
          style: BorderStyle.solid,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        title: Text(job.jobName),
        subtitle: Text("${job.jobType} • ${job.location}"),
        trailing: const Icon(Icons.arrow_forward_ios_rounded),
        onTap: () {
          Get.to(() => JobDetailPage());
        },
      ),
    );
  }
}


