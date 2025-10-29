// lib/pages/admin/cleaning_detail_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_cleancare/pages/job_detail_page.dart';
import 'package:get/get.dart';
import 'package:flutter_cleancare/controllers/job_controller.dart';

class CleaningDetailPage extends StatelessWidget {
  final int taskId;
  final String floor;

  const CleaningDetailPage({super.key, required this.taskId, required this.floor});

  @override
  Widget build(BuildContext context) {
    final jobC = Get.find<JobController>();

    Future.microtask(() {
      jobC.fetchJobs(null, taskId, null, floor, jobC.selectedDate.value,null);
    });

    return Scaffold(
      appBar: AppBar(title: Text(floor)),
      body: RefreshIndicator(
        onRefresh: () async {
          await jobC.fetchJobs(null, taskId, null, floor, jobC.selectedDate.value,null);
        },
        child: Obx(() {
          final jobs = jobC.jobs;
        
          if (jobs.isEmpty) {
            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: const [
                SizedBox(
                  height: 300,
                  child: Center(child: Text("Belum ada data pekerjaan.")),
                ),
              ],
            );
          }
        
          return ListView.builder(
            padding: const EdgeInsets.all(5),
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: jobs.length,
            itemBuilder: (context, index) {
              final job = jobs[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 5),
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
                  leading: const Icon(Icons.cleaning_services),
                  title: Text(job.taskTypeName,style: TextStyle(fontWeight: FontWeight.bold),),
                  subtitle: Text(job.userName),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (job.unreadComment == true)
                        const Padding(
                          padding: EdgeInsets.only(right: 1),
                          child: Icon(
                            Icons.chat_sharp,
                            color: Colors.red,
                            size: 20,
                          ),
                        ),
                      const Icon(Icons.arrow_forward_ios),
                    ],
                  ),
                  onTap: () async {
                    final result = await Get.to(() => JobDetailPage(jobId: int.parse(job.id),));
                    if (result == true) {
                      jobC.resetDetailJobState();
                      await jobC.fetchJobs(null, taskId, null, floor, jobC.selectedDate.value,null);
                    } else {
                      jobC.resetDetailJobState();
                      await jobC.fetchJobs(null, taskId, null, floor, jobC.selectedDate.value,null);
                    }
                  },
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
