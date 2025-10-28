import 'package:flutter/material.dart';
import 'package:flutter_cleancare/controllers/tasks_controller.dart';
import 'package:flutter_cleancare/core/theme/app_color.dart';
import 'package:flutter_cleancare/widgets/app_snackbar_raw.dart';
import 'package:get/get.dart';

class AddTaskPage extends StatelessWidget {
  const AddTaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    final taskC = Get.find<TaskController>();

    final nameC = TextEditingController();
    final typeList = ['Cleaning','Non-Cleaning'];
    final selectedType = 'Cleaning'.obs;

    final formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text(
          "Tambah Tugas Baru",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColor.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
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
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primaryVariant,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Tambah Tugas",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      final result = await taskC.create(selectedType.value == 'Cleaning' ? 1 : 2, nameC.text);
                      if (result == 'ok'){
                        Get.back(result: true);
                        AppSnackbarRaw.success('Berhasil tambah tugas!');
                      }else{
                        AppSnackbarRaw.error(result);
                      }
                    }
                  },
                ),
              ),
            ],
          )),
        ),
      ),
    );
  }
}
