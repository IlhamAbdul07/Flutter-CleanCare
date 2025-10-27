import 'package:flutter/material.dart';
import 'package:flutter_cleancare/controllers/auth_controller.dart';
import 'package:flutter_cleancare/controllers/job_controller.dart';
import 'package:flutter_cleancare/core/theme/app_color.dart';
import 'package:flutter_cleancare/widgets/cleaning_list_widget.dart';
import 'package:flutter_cleancare/widgets/noncleaning_list_widget.dart';
import 'package:get/get.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authC = Get.find<AuthController>();
    final jobC = Get.put(JobController());

    return Obx(() {
      final currentUser = authC.currentUser.value;
      if (currentUser == null) {
        return const Scaffold(body: Center(child: Text('No user.')));
      }
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.background,
          elevation: 0,
          toolbarHeight: 60,
          titleSpacing: 16,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text(
                'Dashboard',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 26,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Halo ${currentUser.name.replaceAll(" (Pest Control)", "")}, semoga harimu menyenangkan.',
                style: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.primary,),
              ),
            ],
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            jobC.refreshDashboard(jobC.isCleaning.value, jobC.selectedDate.value);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SizedBox(height: 15),
                Row(
                  children: [
                    // Tombol kiri: pilih tanggal
                    Expanded(
                      child: Obx(() {
                        final selectedDate = jobC.selectedDate.value;
                        final formattedDate = selectedDate != null
                            ? "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}"
                            : "Pilih Tanggal";
          
                        return TextField(
                          readOnly: true,
                          onTap: () => jobC.pickDate(context),
                          decoration: InputDecoration(
                            hintText: formattedDate,
                            prefixIcon: const Icon(Icons.calendar_today),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 14,
                              horizontal: 10,
                            ),
                          ),
                        );
                      }),
                    ),
          
                    const SizedBox(width: 10),
          
                    // Tombol kanan: download
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          jobC.exportJobs(jobC.selectedDate.value);
                        },
                        icon: const Icon(Icons.download, color: Colors.white),
                        label: const Text(
                          "Download",
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.secondary,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Obx(
                      () => ElevatedButton(
                        onPressed: () => jobC.setCleaning(true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: jobC.isCleaning.value
                              ? AppColor.primaryBlue
                              : Colors.grey[300],
                          foregroundColor: jobC.isCleaning.value
                              ? Colors.white
                              : Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('Cleaning'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Obx(
                      () => ElevatedButton(
                        onPressed: () => jobC.setCleaning(false),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: !jobC.isCleaning.value
                              ? AppColor.primaryBlue
                              : Colors.grey[300],
                          foregroundColor: !jobC.isCleaning.value
                              ? Colors.white
                              : Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('Non-Cleaning'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Obx(() {
                  return jobC.isCleaning.value
                      ? CleaningListWidget()
                      : NonCleaningListWidget();
                }),
              ],
            ),
          ),
        ),
      );
    });
  }
}
