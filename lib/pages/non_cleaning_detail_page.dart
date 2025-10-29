import 'package:flutter/material.dart';
import 'package:flutter_cleancare/pages/job_detail_page.dart';
import 'package:get/get.dart';
import 'package:flutter_cleancare/controllers/job_controller.dart';

class NonCleaningDetailPage extends StatelessWidget {
  final int taskId;
  final int userId;
  final String userName;

  const NonCleaningDetailPage({super.key, required this.taskId, required this.userId, required this.userName});

  @override
  Widget build(BuildContext context) {
    final jobC = Get.find<JobController>();

    Future.microtask(() {
      jobC.fetchJobs(userId, taskId, null, null, jobC.selectedDate.value);
    });

    return Scaffold(
      appBar: AppBar(title: Text(userName)),
      body: RefreshIndicator(
        onRefresh: () async {
          await jobC.fetchJobs(userId, taskId, null, null, jobC.selectedDate.value);
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
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: jobs.length,
            itemBuilder: (context, index) {
              final job = jobs[index];
              return ListTile(
                leading: const Icon(Icons.work),
                title: Text(job.taskTypeName,style: TextStyle(fontWeight: FontWeight.bold),),
                subtitle: Text(job.floor),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (job.unreadComment == true)
                      const Padding(
                        padding: EdgeInsets.only(right: 1),
                        child: Text(
                          'New Comment!',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 11,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    const Icon(Icons.arrow_forward_ios),
                  ],
                ),
                onTap: () async {
                  final result = await Get.to(() => JobDetailPage(jobId: int.parse(job.id),));
                  if (result == true) {
                    jobC.resetDetailJobState();
                    await jobC.fetchJobs(userId, taskId, null, null, jobC.selectedDate.value);
                  } else {
                    jobC.resetDetailJobState();
                    await jobC.fetchJobs(userId, taskId, null, null, jobC.selectedDate.value);
                  }
                },
              );
            },
          );
        }),
      ),
    );
  }
}
