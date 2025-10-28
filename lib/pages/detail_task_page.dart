import 'package:flutter/material.dart';
import 'package:flutter_cleancare/controllers/tasks_controller.dart';
import 'package:flutter_cleancare/core/theme/app_color.dart';
import 'package:flutter_cleancare/widgets/app_dialog.dart';
import 'package:flutter_cleancare/widgets/app_snackbar_raw.dart';
import 'package:get/get.dart';

class DetailTaskPage extends StatelessWidget {
  final int id;
  final String name;
  final int taskId;
  final String taskName;
  const DetailTaskPage({super.key, required this.id, required this.name, required this.taskId, required this.taskName});

  @override
  Widget build(BuildContext context) {
    final taskC = Get.find<TaskController>();

    final nameC = TextEditingController();
    final typeList = ['Cleaning','Non-Cleaning'];
    final selectedType = 'Cleaning'.obs;

    nameC.text = name;
    selectedType.value = taskName;

    final formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text(
          "Detail Tugas",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColor.primary,
      ),
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: formKey,
            child: Obx(() => ListView(
              children: [
                const SizedBox(height: 20),
                Text(
                  'Nama Tugas',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 5),
                TextFormField(
                  controller: nameC,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    hintText: "Masukkan Nama Tugas",
                  ),
                  validator: (val) =>
                      val == null || val.isEmpty ? 'Wajib diisi' : null,
                ),
                const SizedBox(height: 18),
                Text(
                'Tipe Tugas',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 5),
                DropdownButtonFormField<String>(
                  initialValue: selectedType.value,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                  ),
                  items: typeList
                      .map(
                        (type) =>
                            DropdownMenuItem(value: type, child: Text(type)),
                      )
                      .toList(),
                  onChanged: (val) {
                    if (val != null) selectedType.value = val;
                  },
                ),  
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.primaryBlue,
                            iconColor: Colors.white,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () async {
                            if (formKey.currentState!.validate()){
                              AppDialog.confirm(
                                title: "Edit Tugas",
                                message: "Apakah kamu yakin ingin mengedit tugas ini?",
                                confirmColor: Colors.blue,
                                icon: Icons.edit,
                                onConfirm: () async {
                                  final Map<String, dynamic> data = {};
                                  if (nameC.text != name) {
                                    data['name'] = nameC.text;
                                  }
                                  if (selectedType.value != taskName) {
                                    data['task_id'] = selectedType.value == 'Cleaning' ? 1 : 2;
                                  }
                                  final result = await taskC.updateById(id,data);
                                  if (result == 'ok'){
                                    Get.back(result: true);
                                    AppSnackbarRaw.success('Berhasil edit tugas!');
                                  }else{
                                    AppSnackbarRaw.error(result);
                                  }
                                },
                              );
                            }
                          },
                          icon: const Icon(Icons.edit),
                          label: const Text('Edit'),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            iconColor: Colors.white,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () async {
                            AppDialog.confirm(
                              title: "Hapus Tugas",
                              message: "Apakah kamu yakin ingin menghapus tugas ini?",
                              confirmColor: Colors.red,
                              icon: Icons.delete,
                              onConfirm: () async {
                                final result = await taskC.deleteById(id);
                                if (result == 'ok'){
                                  Get.back(result: true);
                                  AppSnackbarRaw.success('Berhasil hapus tugas!');
                                }else{
                                  AppSnackbarRaw.error(result);
                                }
                              },
                            );
                          },
                          icon: const Icon(Icons.delete),
                          label: const Text('Delete'),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),),
          ),
        ),
    );
  }
}
