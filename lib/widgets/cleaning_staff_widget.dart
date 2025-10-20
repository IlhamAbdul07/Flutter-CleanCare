import 'package:flutter/material.dart';
import 'package:flutter_cleancare/data/models/staff_job_model.dart';
import 'package:intl/intl.dart';
import '../core/theme/app_color.dart';

class CleaningStaffWidget extends StatelessWidget {
  final List<StaffJobModel> data;
  const CleaningStaffWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy, HH:mm');

    if (data.isEmpty) {
      return const Center(child: Text('Belum ada pekerjaan Cleaning.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: data.length,
      itemBuilder: (context, index) {
        final job = data[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: const Icon(Icons.cleaning_services, color: Colors.green),
            title: Text(
              job.location,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Selesai: ${dateFormat.format(job.completedAt)}'),
                Text('Catatan: ${job.notes}'),
              ],
            ),
            trailing: Text(
              'ID: ${job.id}',
              style: TextStyle(
                color: AppColor.primaryBlue,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      },
    );
  }
}
