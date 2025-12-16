import 'package:flutter/material.dart';
import 'package:flutter_cleancare/controllers/auth_controller.dart';
import 'package:flutter_cleancare/controllers/job_controller.dart';
import 'package:flutter_cleancare/core/services/general_service.dart';
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
      jobC.fetchJobs(null, int.parse(authC.currentUser.value!.id),null,null,null,null,{'order':'created_at','order_by':'asc'});
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
                          await jobC.fetchJobs(null, int.parse(authC.currentUser.value!.id),null,null,null,null,{'order':'created_at','order_by':'asc'});
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
                                  return Stack(
                                    children: [
                                      Card(
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
                                          leading: Icon(
                                            job.taskName.toLowerCase() == 'cleaning' ? Icons.cleaning_services_rounded : Icons.work_outline_rounded,
                                            color: job.taskName.toLowerCase() == 'cleaning' ? Colors.teal : Colors.orange,
                                            size: 30,
                                          ),
                                          title: Text(job.taskTypeName,style: TextStyle(fontWeight: FontWeight.bold),),
                                          subtitle: Wrap(
                                            children: [
                                              Text(
                                                "${job.taskName} • ${job.floor}\n",
                                              ),
                                              Text(
                                                GeneralService.formatTanggalIndo(job.createdAt),
                                                style: const TextStyle(fontStyle: FontStyle.italic,fontSize: 12),
                                              ),
                                            ],
                                          ),
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
                                              const Icon(Icons.arrow_forward_ios_rounded),
                                            ],
                                          ),
                                          onTap: () async {
                                            final result = await Get.to(() => JobDetailPage(jobId: int.parse(job.id),));
                                            if (result == true) {
                                              jobC.resetDetailJobState();
                                              await jobC.fetchJobs(null, int.parse(authC.currentUser.value!.id),null,null,null,null,{'order':'created_at','order_by':'asc'});
                                            } else {
                                              jobC.resetDetailJobState();
                                              await jobC.fetchJobs(null, int.parse(authC.currentUser.value!.id),null,null,null,null,{'order':'created_at','order_by':'asc'});
                                            }
                                          },
                                        ),
                                      ),
                                      Positioned(
                                        top: 6,
                                        left: 2,
                                        child: Icon(
                                          job.isDone ? Icons.check_circle : Icons.timelapse,
                                          color: job.isDone ? Colors.green : Colors.orange,
                                          size: 25,
                                        ),
                                      ),
                                    ],
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
                        await jobC.fetchJobs(null, int.parse(authC.currentUser.value!.id),null,null,null,null,{'order':'created_at','order_by':'asc'});
                      } else {
                        jobC.resetDetailJobState();
                        await jobC.fetchJobs(null, int.parse(authC.currentUser.value!.id),null,null,null,null,{'order':'created_at','order_by':'asc'});
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


