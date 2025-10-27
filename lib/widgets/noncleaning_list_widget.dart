import 'package:flutter/material.dart';
import 'package:flutter_cleancare/controllers/job_controller.dart';
import 'package:flutter_cleancare/core/theme/app_color.dart';
import 'package:flutter_cleancare/pages/non_cleaning_detail_page.dart';
import 'package:get/get.dart';

class NonCleaningListWidget extends StatelessWidget {
  const NonCleaningListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final jobC = Get.find<JobController>();

    return Expanded(
      child: Obx(() {
        final data = jobC.nonCleaningSummaryList;

        if (data.isEmpty) {
          return ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: const [
              SizedBox(
                height: 300,
                child: Center(
                  child: Text('Belum ada data non-cleaning.'),
                ),
              ),
            ],
          );
        }

        return  ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: data.length,
          itemBuilder: (context, index) {
            final item = data[index];
            final name = item['name'] ?? 'Tidak diketahui';
            final count = item['count'] ?? 0;
            final userId = item['user_id'] ?? 0;
        
            return ListTile(
            leading: const Icon(Icons.work, color: AppColor.primaryVariant),
            title: Text('$count Pekerjaan',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
            subtitle: Text(name,style: TextStyle(fontSize: 13),),
            trailing: const Icon(Icons.chevron_right),
            onTap: () async {
              final result = await Get.to(() => NonCleaningDetailPage(taskId: 2,userId: int.parse(userId.toString()),userName: name,));
              if (result == true) {
                jobC.refreshDashboard(jobC.isCleaning.value, jobC.selectedDate.value);
              }else{
                jobC.refreshDashboard(jobC.isCleaning.value, jobC.selectedDate.value);
              }
            },
          );
          },
        );
      }),
    );
  }
}
