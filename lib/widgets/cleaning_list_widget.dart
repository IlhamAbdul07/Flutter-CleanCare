import 'package:flutter/material.dart';
import 'package:flutter_cleancare/controllers/job_controller.dart';
import 'package:flutter_cleancare/core/theme/app_color.dart';
import 'package:flutter_cleancare/pages/cleaning_detail_page.dart';
import 'package:get/get.dart';

class CleaningListWidget extends StatelessWidget {
  const CleaningListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final jobC = Get.find<JobController>();

    return Expanded(
      child: Obx(() {
        final data = jobC.cleaningSummaryList;

        if (data.isEmpty) {
          return ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: const [
              SizedBox(
                height: 300,
                child: Center(
                  child: Text('Belum ada data cleaning.'),
                ),
              ),
            ],
          );
        }

        return ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: data.length,
          itemBuilder: (context, index) {
            final item = data[index];
            final floor = item['floor'] ?? 'Tidak diketahui';
            final count = item['count'] ?? 0;

            return ListTile(
              leading: const Icon(
                Icons.cleaning_services,
                color: AppColor.primaryVariant,
              ),
              title: Text(floor,style: TextStyle(fontSize: 13),),
              subtitle: Text(
                '$count Pekerjaan',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () async {
                final result = await Get.to(() => CleaningDetailPage(taskId: 1, floor: floor.toString()));
                if (result == true) {
                  jobC.refreshDashboard(jobC.isCleaning.value, jobC.selectedDate.value);
                } else {
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
