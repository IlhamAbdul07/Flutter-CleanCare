import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_cleancare/controllers/auth_controller.dart';
import 'package:flutter_cleancare/controllers/job_controller.dart';
import 'package:flutter_cleancare/controllers/tasks_controller.dart';
import 'package:flutter_cleancare/core/theme/app_color.dart';
import 'package:flutter_cleancare/widgets/app_dialog.dart';
import 'package:flutter_cleancare/widgets/app_snackbar_raw.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AddDetailJob extends StatelessWidget {
  const AddDetailJob({super.key});

  @override
  Widget build(BuildContext context) {
    final authC = Get.find<AuthController>();
    final jobC = Get.put(JobController());
    final jobTypeC = Get.put(TaskController());
    final taskLoading = false.obs;

    final userLogin = authC.currentUser.value;
    final nameC = TextEditingController();
    final jobList = ['Cleaning', 'Non-Cleaning'];
    final floorList = List.generate(20, (index) => 'Lantai ${index + 1}');
    final selectedJob = ''.obs;
    final selectedJobType = ''.obs;
    final selectedFloor = ''.obs;
    final infoC = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final selectedImageBeforeError = ''.obs;

    nameC.text = userLogin!.name;
    selectedJob.value = jobList.first;
    selectedFloor.value = floorList.first;
    taskLoading.value = true;
    Future.microtask(() {
      jobTypeC.setFilterTask(selectedJob.value == 'Cleaning' ? 1 : 2).then((
        value,
      ) {
        selectedJobType.value = jobTypeC.tasks.first.name;
      });
    });
    taskLoading.value = false;

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text(
          "Tambah Pekerjaan",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColor.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Obx(
            () => ListView(
              children: [
                const SizedBox(height: 15),
                const Text(
                  'Nama Petugas',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                AbsorbPointer(
                  absorbing: true,
                  child: TextFormField(
                    controller: nameC,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      hintText: "",
                    ),
                  ),
                ),
                //
                const SizedBox(height: 24),
                Text(
                  'Pilih Pekerjaan',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.left,
                ),
                ButtonTheme(
                  alignedDropdown: true,
                  child: DropdownButtonFormField<String>(
                    initialValue: selectedJob.value,
                    isExpanded: true,
                    alignment: AlignmentDirectional.centerStart,
                    menuMaxHeight: 200,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                    ),
                    items: jobList
                        .map(
                          (job) =>
                              DropdownMenuItem(value: job, child: Text(job)),
                        )
                        .toList(),
                    onChanged: (val) async {
                      if (val != null) {
                        selectedJob.value = val;
                        await jobTypeC.setFilterTask(
                          selectedJob.value == 'Cleaning' ? 1 : 2,
                        );
                        selectedJobType.value = jobTypeC.tasks.first.name;
                      }
                    },
                  ),
                ),
                //
                const SizedBox(height: 24),
                Text(
                  'Pilih Jenis Pekerjaan',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.left,
                ),
                taskLoading.value
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : ButtonTheme(
                        alignedDropdown: true,
                        child: DropdownButtonFormField<String>(
                          initialValue: selectedJobType.value,
                          isExpanded: true,
                          alignment: AlignmentDirectional.centerStart,
                          menuMaxHeight: 200,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                              ),
                            ),
                          ),
                          items: jobTypeC.tasks
                              .map(
                                (t) => DropdownMenuItem(
                                  value: t.name,
                                  child: Text(t.name),
                                ),
                              )
                              .toList(),
                          onChanged: (val) {
                            if (val != null) selectedJobType.value = val;
                          },
                        ),
                      ),
                //
                const SizedBox(height: 24),
                Text(
                  'Pilih Lokasi',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.left,
                ),
                ButtonTheme(
                  alignedDropdown: true,
                  child: DropdownButtonFormField<String>(
                    initialValue: selectedFloor.value,
                    isExpanded: true,
                    alignment: AlignmentDirectional.centerStart,
                    menuMaxHeight: 200,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                    ),
                    items: floorList
                        .map(
                          (floor) => DropdownMenuItem(
                            value: floor,
                            child: Text(floor),
                          ),
                        )
                        .toList(),
                    onChanged: (val) {
                      if (val != null) selectedFloor.value = val;
                    },
                  ),
                ),
                //
                const SizedBox(height: 24),
                Text(
                  'Deskripsi Pekerjaan',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.left,
                ),
                TextFormField(
                  controller: infoC,
                  minLines: 3,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    hintText: "Masukkan Deskripsi Pekerjaan",
                  ),
                  validator: (val) =>
                      val == null || val.isEmpty ? 'Wajib diisi' : null,
                ),
                //
                const SizedBox(height: 24),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Foto Sebelum',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ), // jarak antara teks utama dan error
                    if (selectedImageBeforeError.isNotEmpty)
                      Flexible(
                        child: Text(
                          selectedImageBeforeError.value,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 13,
                          ),
                          overflow:
                              TextOverflow.ellipsis, // biar gak kepanjangan
                        ),
                      ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    jobC.pickImageBeforeEdit();
                    selectedImageBeforeError.value = '';
                  },
                  onLongPress: () {
                    final selected = jobC.selectedImageBeforeEdit.value;
                    if (selected != null) {
                      AppDialog.showImagePopup(
                        context,
                        selected.path,
                        isLocal: true,
                      );
                    }
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          height: 140,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.transparent),
                          ),
                          child: Obx(() {
                            final selected = jobC.selectedImageBeforeEdit.value;
                            if (selected != null) {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.file(
                                  File(selected.path),
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                              );
                            } else {
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.upload_file, size: 40),
                                    SizedBox(height: 6),
                                    Text(
                                      'Unggah Foto Sebelum Dikerjakan.',
                                      style: TextStyle(color: Colors.black54),
                                    ),
                                  ],
                                ),
                              );
                            }
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
                if (jobC.selectedImageBeforeEdit.value != null) ...[
                  Padding(
                    padding: const EdgeInsets.only(top: 6, left: 4),
                    child: Text(
                      '* Tekan untuk melihat pratinjau',
                      style: const TextStyle(color: Colors.blue, fontSize: 13),
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                const Text(
                  'Foto Sesudah',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                GestureDetector(
                  onTap: () {
                    jobC.pickImageAfterEdit();
                  },
                  onLongPress: () {
                    final selected = jobC.selectedImageAfterEdit.value;
                    if (selected != null) {
                      AppDialog.showImagePopup(
                        context,
                        selected.path,
                        isLocal: true,
                      );
                    }
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          height: 140,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.transparent),
                          ),
                          child: Obx(() {
                            final selected = jobC.selectedImageAfterEdit.value;
                            if (selected != null) {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.file(
                                  File(selected.path),
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                              );
                            } else {
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.upload_file, size: 40),
                                    SizedBox(height: 6),
                                    Text(
                                      'Unggah Foto Sesudah Dikerjakan.',
                                      style: TextStyle(color: Colors.black54),
                                    ),
                                  ],
                                ),
                              );
                            }
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
                if (jobC.selectedImageAfterEdit.value != null) ...[
                  Padding(
                    padding: const EdgeInsets.only(top: 6, left: 4),
                    child: Text(
                      '* Tekan untuk melihat pratinjau',
                      style: const TextStyle(color: Colors.blue, fontSize: 13),
                    ),
                  ),
                ],
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
                    child: jobC.isLoading.value
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            "Submit",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        if (jobC.selectedImageBeforeEdit.value == null) {
                          selectedImageBeforeError.value = '(Wajib diunggah)';
                          return;
                        }
                        AppDialog.confirm(
                          title: "Simpan Data Pekerjaan",
                          message:
                              "Apakah kamu yakin ingin menyimpan data pekerjaan?",
                          confirmColor: Colors.blueAccent,
                          icon: Icons.create,
                          onConfirm: () async {
                            XFile? imgBefore;
                            XFile? imgAfter;
                            if (jobC.selectedImageBeforeEdit.value != null) {
                              imgBefore = jobC.selectedImageBeforeEdit.value;
                            }
                            if (jobC.selectedImageAfterEdit.value != null) {
                              imgAfter = jobC.selectedImageAfterEdit.value;
                            }
                            jobC.setIsLoading(true);
                            final result = await jobC.create(
                              selectedJob.value == 'Cleaning' ? 1 : 2,
                              int.parse(
                                jobTypeC.tasks
                                    .where(
                                      (task) =>
                                          task.name == selectedJobType.value,
                                    )
                                    .first
                                    .id,
                              ),
                              selectedFloor.value,
                              infoC.text,
                              imgBefore,
                              imgAfter,
                            );
                            if (result == 'ok') {
                              Get.back(result: true);
                              AppSnackbarRaw.success(
                                'Berhasil menambah data pekerjaan!',
                              );
                            } else {
                              AppSnackbarRaw.error(result);
                            }
                            jobC.setIsLoading(false);
                          },
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
