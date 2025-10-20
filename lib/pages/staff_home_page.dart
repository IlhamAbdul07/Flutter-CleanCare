import 'package:flutter/material.dart';
import 'package:flutter_cleancare/controllers/auth_controller.dart';
import 'package:flutter_cleancare/controllers/staff_job_controller.dart';
import 'package:flutter_cleancare/widgets/cleaning_staff_widget.dart';
import 'package:flutter_cleancare/widgets/noncleaning_staff_widget.dart';
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
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          titleSpacing: 16,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              const Text(
                'Dashboard',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 26,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Welcome, ${currentUser.userId} (${currentUser.role})',
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ],
          ),
        ),
        body: Expanded(
          child: Obx(() {
            return jobC.isCleaning.value
                ? CleaningStaffWidget(data: jobC.cleaningSummary)
                : NonCleaningStaffWidget(data: jobC.nonCleaningSummary);
          }),
        ),
      );
    });
  }
}
