import 'package:flutter/material.dart';
import 'package:flutter_cleancare/controllers/auth_controller.dart';
import 'package:flutter_cleancare/controllers/job_controller.dart';
import 'package:flutter_cleancare/pages/add_detail_job.dart';
import 'package:flutter_cleancare/pages/job_detail_page.dart';
import 'package:get/get.dart';

class StaffHomePage extends StatelessWidget {
  const StaffHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authC = Get.find<AuthController>();
    final jobC = Get.put(JobController());

    Future.microtask(() {
      jobC.fetchJobs(int.parse(authC.currentUser.value!.id),null,null,null,null);
    });

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
          toolbarHeight: 70,
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
                    'Halo ${currentUser.name.replaceAll(" (Pest Control)", "")}, semoga harimu menyenangkan.',
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
                      final jobs = jobC.jobs;

                      return RefreshIndicator(
                        onRefresh: () async {
                          await jobC.fetchJobs(int.parse(authC.currentUser.value!.id),null,null,null,null);
                        },
                        child: jobs.isEmpty
                            ? ListView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                children: const [
                                  SizedBox(
                                    height: 300,
                                    child: Center(child: Text("Belum ada data pekerjaan.")),
                                  ),
                                ],
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.only(bottom: 80),
                                itemCount: jobs.length,
                                itemBuilder: (context, index) {
                                  final job = jobs[index];
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
                                      title: Text(job.taskTypeName,style: TextStyle(fontWeight: FontWeight.bold),),
                                      subtitle: Text("${job.taskName} • ${job.floor}"),
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
                                          const Icon(Icons.arrow_forward_ios_rounded),
                                        ],
                                      ),
                                      onTap: () async {
                                        final result = await Get.to(() => JobDetailPage(jobId: int.parse(job.id),));
                                        if (result == true) {
                                          jobC.resetDetailJobState();
                                          await jobC.fetchJobs(int.parse(authC.currentUser.value!.id),null,null,null,null);
                                        } else {
                                          jobC.resetDetailJobState();
                                          await jobC.fetchJobs(int.parse(authC.currentUser.value!.id),null,null,null,null);
                                        }
                                      },
                                    ),
                                  );
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
                    tooltip: 'Tambah Pekerjaan',
                    onPressed: () async {
                      final result = await Get.to(() => const AddDetailJob());
                      if (result == true) {
                        jobC.resetDetailJobState();
                        await jobC.fetchJobs(int.parse(authC.currentUser.value!.id),null,null,null,null);
                      } else {
                        jobC.resetDetailJobState();
                        await jobC.fetchJobs(int.parse(authC.currentUser.value!.id),null,null,null,null);
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}


