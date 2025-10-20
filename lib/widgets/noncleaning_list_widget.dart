// lib/widgets/noncleaning_list_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_cleancare/core/theme/app_color.dart';

class NonCleaningListWidget extends StatelessWidget {
  final Map<String, int> data;
  const NonCleaningListWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty)
      return const Center(child: Text('Tidak ada data non-cleaning.'));

    final names = data.keys.toList();

    return Expanded(
      child: ListView.builder(
        itemCount: names.length,
        itemBuilder: (context, index) {
          final name = names[index];
          final count = data[name];
          return ListTile(
            leading: const Icon(Icons.work, color: AppColor.primaryVariant),
            title: Text('$count pekerjaan'),
            subtitle: Text(name),
            trailing: const Icon(Icons.chevron_right),
          );
        },
      ),
    );
  }
}
