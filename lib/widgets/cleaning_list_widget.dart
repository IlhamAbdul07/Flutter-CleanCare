// lib/widgets/cleaning_list_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_cleancare/controllers/job_controller.dart';
import 'package:flutter_cleancare/core/theme/app_color.dart';
import 'package:flutter_cleancare/pages/cleaning_detail_page.dart';
import 'package:get/get.dart';

class CleaningListWidget extends StatelessWidget {
  final Map<int, int> data;
  const CleaningListWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final jobC = Get.find<JobController>();

    if (data.isEmpty) {
      return const Expanded(
        child: Center(child: Text('Tidak ada data cleaning.')),
      );
    }

    final floors = data.keys.toList();

    return Expanded(
      child: RefreshIndicator(
        onRefresh: jobC.refreshJobs, // 🔹 memanggil fungsi di controller
        child: ListView.builder(
          physics:
              const AlwaysScrollableScrollPhysics(), // 🔹 penting untuk bisa di-refresh walau datanya sedikit
          itemCount: floors.length,
          itemBuilder: (context, index) {
            final floor = floors[index];
            final count = data[floor];
            return ListTile(
              leading: const Icon(
                Icons.cleaning_services,
                color: AppColor.primaryVariant,
              ),
              title: Text('$count pekerjaan'),
              subtitle: Text('Lantai $floor'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // contoh navigasi ke detail page
                Get.to(() => CleaningDetailPage(floor: floor.toString()));
              },
            );
          },
        ),
      ),
    );
  }
}
