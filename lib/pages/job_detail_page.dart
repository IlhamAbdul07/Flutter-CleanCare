import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_cleancare/controllers/auth_controller.dart';
import 'package:flutter_cleancare/controllers/comment_controller.dart';
import 'package:flutter_cleancare/controllers/job_controller.dart';
import 'package:flutter_cleancare/controllers/tasks_controller.dart';
import 'package:flutter_cleancare/core/theme/app_color.dart';
import 'package:flutter_cleancare/widgets/app_dialog.dart';
import 'package:flutter_cleancare/widgets/app_snackbar_raw.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class JobDetailPage extends StatelessWidget {
  final int jobId;
  const JobDetailPage({super.key, required this.jobId});

  @override
  Widget build(BuildContext context) {
    final authC = Get.find<AuthController>();
    final jobC = Get.put(JobController());
    final jobTypeC = Get.put(TaskController());
    final commentC = Get.put(CommentController());

    final isAdmin = authC.isAdmin;
    final userLogin = authC.currentUser.value!.id;
    final nameC = TextEditingController();
    final jobList = ['Cleaning', 'Non-Cleaning'];
    final floorList = List.generate(20, (index) => 'Lantai ${index + 1}');
    final selectedJob = ''.obs;
    final selectedJobType = ''.obs;
    final selectedFloor = ''.obs;
    final infoC = TextEditingController();
    final textCommentC = TextEditingController();
    final formKey = GlobalKey<FormState>();

    Future<void> loadData() async {
      await jobC.getById(jobId);
      await commentC.setFilterJob(jobId);
    }

    return FutureBuilder(
      future: loadData(),
      builder: (context, asyncSnapshot) {

        if (asyncSnapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              foregroundColor: Colors.white,
              title: const Text("Detail Pekerjaan"),
              backgroundColor: AppColor.primary,
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 80,
                        height: 80,
                        child: CircularProgressIndicator(
                          strokeWidth: 5,
                          color: AppColor.primary,
                        ),
                      ),
                      Image.asset(
                        'assets/images/logo.png',
                        width: 40,
                        height: 40,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Mohon tunggu, sedang menyiapkan data..",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        if (asyncSnapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              foregroundColor: Colors.white,
              title: const Text("Detail Pekerjaan"),
              backgroundColor: AppColor.primary,
            ),
            body: Center(
              child: Text("Terjadi kesalahan: ${asyncSnapshot.error}"),
            ),
          );
        }

        final singleJob = jobC.jobSingle.value;
        if (singleJob == null) {
          return Scaffold(
            appBar: AppBar(
              foregroundColor: Colors.white,
              title: const Text("Detail Pekerjaan"),
              backgroundColor: AppColor.primary,
            ),
            body: Center(child: Text("No job")),
          );
        }

        nameC.text = singleJob.userName;
        selectedJob.value = int.parse(singleJob.taskId) == 1 ? 'Cleaning' : 'Non-Cleaning';
        selectedJobType.value = singleJob.taskTypeName;
        selectedFloor.value = singleJob.floor;
        infoC.text = singleJob.info;
        jobC.imageBeforeC.value = singleJob.imageBefore;
        jobC.imageAfterC.value = singleJob.imageAfter;
        textCommentC.text = '';

        return Scaffold(
          appBar: AppBar(
            foregroundColor: Colors.white,
            title: const Text("Detail Pekerjaan"),
            backgroundColor: AppColor.primary,
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              await jobC.getById(jobId);
              await commentC.setFilterJob(jobId);
            },
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: formKey,
                child: Obx(() => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5),
                    Obx(() {
                      final isDone = jobC.imageAfterC.value != '';

                      return Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        decoration: BoxDecoration(
                          color: isDone ? Colors.green.shade50 : Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isDone ? Colors.green : Colors.orange,
                            width: 1.2,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              isDone ? Icons.check_circle : Icons.timelapse,
                              color: isDone ? Colors.green : Colors.orange,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              isDone ? 'Status: Pekerjaan Sudah Selesai' : 'Status: Pekerjaan Belum Selesai',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: isDone ? Colors.green.shade800 : Colors.orange.shade800,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 20),
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
                    const SizedBox(height: 20),
                    const Text(
                      'Pekerjaan',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    AbsorbPointer(
                      absorbing: isAdmin,
                      child: ButtonTheme(
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
                                (job) => DropdownMenuItem(
                                  enabled: !isAdmin,
                                  value: job,
                                  child: Text(job),
                                ),
                              )
                              .toList(),
                          onChanged: (val) async {
                            if (val != null) {
                              selectedJob.value = val;
                              await jobTypeC.setFilterTask(selectedJob.value == 'Cleaning' ? 1 : 2);
                              selectedJobType.value = jobTypeC.tasks.first.name;
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Jenis Pekerjaan',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    AbsorbPointer(
                      absorbing: isAdmin,
                      child: ButtonTheme(
                        alignedDropdown: true,
                        child: DropdownButtonFormField<String>(
                          isExpanded: true,
                          alignment: AlignmentDirectional.centerStart,
                          menuMaxHeight: 200,
                          initialValue: selectedJobType.value,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(8)),
                            ),
                          ),
                          items: jobTypeC.tasks.map((t) => DropdownMenuItem(value: t.name,enabled: !isAdmin,child: Text(t.name),)).toList(),
                          onChanged: (val) {
                            if (val != null) selectedJobType.value = val;
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Lokasi',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    AbsorbPointer(
                      absorbing: isAdmin,
                      child: ButtonTheme(
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
                                (floor) =>
                                    DropdownMenuItem(value: floor,enabled: !isAdmin, child: Text(floor)),
                              )
                              .toList(),
                          onChanged: (val) {
                            if (val != null) selectedFloor.value = val;
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Deskripsi',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    AbsorbPointer(
                      absorbing: isAdmin,
                      child: TextFormField(
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
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Foto Sebelum',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () {
                        if (!isAdmin){
                          jobC.pickImageBeforeEdit();
                        }
                      },
                      onLongPress: () {
                        final selected = jobC.selectedImageBeforeEdit.value;
                        final imageUrl = jobC.imageBeforeC.value;
                        if (selected != null) {
                          AppDialog.showImagePopup(context, selected.path, isLocal: true);
                        } else if (imageUrl.isNotEmpty) {
                          AppDialog.showImagePopup(context, imageUrl, isLocal: false);
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
                                final imageBeforeUrl = jobC.imageBeforeC.value;
                                if (selected != null) {
                                  return ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.file(
                                      File(selected.path),
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                    ),
                                  );
                                } else if (imageBeforeUrl.isNotEmpty) {
                                  return ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      imageBeforeUrl,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      errorBuilder: (context, error, stackTrace) => const Center(
                                        child: Icon(Icons.broken_image, size: 40, color: Colors.grey),
                                      ),
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
                                          (isAdmin ? 'Belum ada foto yang diunggah.' : 'Unggah Foto Sebelum Dikerjakan.'),
                                          style: TextStyle(color: Colors.black54),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              }),
                            ),
                          ),
                          // button delete image before
                          // const SizedBox(width: 8),
                          // IconButton(
                          //   onPressed: () => jobC.clearImageBeforeEdit(),
                          //   icon: const Icon(Icons.delete, color: Colors.red, size: 28),
                          // ),
                        ],
                      ),
                    ),
                    if (jobC.selectedImageBeforeEdit.value != null || jobC.imageBeforeC.value.isNotEmpty)...[
                      Padding(
                        padding: const EdgeInsets.only(top: 6, left: 4),
                        child: Text(
                          '* Tekan untuk melihat pratinjau',
                          style: const TextStyle(color: Colors.blue, fontSize: 13),
                        ),
                      )
                    ],
                    const SizedBox(height: 20),
                    const Text(
                      'Foto Sesudah',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () {
                        if (!isAdmin){
                          jobC.pickImageAfterEdit();
                        }
                      },
                      onLongPress: () {
                        final selected = jobC.selectedImageAfterEdit.value;
                        final imageUrl = jobC.imageAfterC.value;
                        if (selected != null) {
                          AppDialog.showImagePopup(context, selected.path, isLocal: true);
                        } else if (imageUrl.isNotEmpty) {
                          AppDialog.showImagePopup(context, imageUrl, isLocal: false);
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
                                final imageAfterUrl = jobC.imageAfterC.value;
                                if (selected != null) {
                                  return ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.file(
                                      File(selected.path),
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                    ),
                                  );
                                } else if (imageAfterUrl.isNotEmpty) {
                                  return ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      imageAfterUrl,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      errorBuilder: (context, error, stackTrace) => const Center(
                                        child: Icon(Icons.broken_image, size: 40, color: Colors.grey),
                                      ),
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
                                          (isAdmin ? 'Belum ada foto yang diunggah.' : 'Unggah Foto Sesudah Dikerjakan.'),
                                          style: TextStyle(color: Colors.black54),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              }),
                            ),
                          ),
                          // button delete image after
                          // const SizedBox(width: 8),
                          // IconButton(
                          //   onPressed: () => jobC.clearImageAfterEdit(),
                          //   icon: const Icon(Icons.delete, color: Colors.red, size: 28),
                          // ),
                        ],
                      ),
                    ),
                    if (jobC.selectedImageAfterEdit.value != null || jobC.imageAfterC.value.isNotEmpty)...[
                      Padding(
                        padding: const EdgeInsets.only(top: 6, left: 4),
                        child: Text(
                          '* Tekan untuk melihat pratinjau',
                          style: const TextStyle(color: Colors.blue, fontSize: 13),
                        ),
                      )
                    ],
                    const SizedBox(height: 15),
                    if (!isAdmin)...[
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
                                      title: "Simpan Data Pekerjaan",
                                      message: "Apakah kamu yakin ingin menyimpan perubahan?",
                                      confirmColor: Colors.blue,
                                      icon: Icons.save,
                                      onConfirm: () async {
                                        final Map<String, dynamic> data = {};
                                        XFile? imgBefore;
                                        XFile? imgAfter;
                                        String contentType = 'application/json';
                                        if (selectedJob.value != (singleJob.taskId == '1' ? 'Cleaning' : 'Non-Cleaning')) {
                                          data['task_id'] = selectedJob.value == 'Cleaning' ? 1 : 2;
                                        }
                                        if (selectedJobType.value != singleJob.taskTypeName) {
                                          data['task_type_id'] = int.parse(jobTypeC.tasks.where((task) => task.name == selectedJobType.value).first.id);
                                        }
                                        if (selectedFloor.value != singleJob.floor) {
                                          data['floor'] = selectedFloor.value;
                                        }
                                        if (infoC.text != singleJob.info) {
                                          data['info'] = infoC.text;
                                        }
                                        if (jobC.selectedImageBeforeEdit.value != null) {
                                          imgBefore = jobC.selectedImageBeforeEdit.value;
                                          contentType = 'multipart/form-data';
                                        } 
                                        // if (jobC.imageBeforeC.value.isEmpty && singleJob.imageBefore.isNotEmpty) {
                                        //   data['delete_image_before'] = 'yes';
                                        // }
                                        if (jobC.selectedImageAfterEdit.value != null) {
                                          imgAfter = jobC.selectedImageAfterEdit.value;
                                          contentType = 'multipart/form-data';
                                        } 
                                        // if (jobC.imageAfterC.value.isEmpty && singleJob.imageAfter.isNotEmpty) {
                                        //   data['delete_image_after'] = 'yes';
                                        // }
                                        jobC.setIsLoading(true);
                                        final result = await jobC.updateById(jobId,data,imgBefore,imgAfter,contentType);
                                        if (result == 'ok'){
                                          await jobC.getById(jobId);
                                          AppSnackbarRaw.success('Berhasil menyimpan data pekerjaan!');
                                        }else{
                                          AppSnackbarRaw.error(result);
                                        }
                                        jobC.setIsLoading(false);
                                      },
                                    );
                                  }
                                },
                                icon: jobC.isLoading.value
                                  ? const SizedBox(
                                      height: 18,
                                      width: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Icon(Icons.save),
                                label: jobC.isLoading.value
                                  ? const Text('Tunggu')
                                  : const Text('Simpan'),
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
                                    title: "Hapus Data Pekerjaan",
                                    message: "Apakah kamu yakin ingin menghapus pekerjaan ini?",
                                    confirmColor: Colors.red,
                                    icon: Icons.delete,
                                    onConfirm: () async {
                                      final result = await jobC.deleteById(jobId);
                                      if (result == 'ok'){
                                        Get.back(result: true);
                                        AppSnackbarRaw.success('Berhasil hapus data pekerjaan!');
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
                    const Divider(height: 32,thickness: 8,),
            
                    const Text(
                      'Komentar',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 12),
                    Obx(() {
                      final comments = commentC.comment;
                      if (comments.isEmpty) {
                        return const Center(
                          child: Text(
                            '💬 Belum ada komentar.',
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Colors.grey,
                            ),
                          ),
                        );
                      }

                      return Column(
                        children: comments.map((comment) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(12),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        comment.createdByName,
                                        softWrap: true,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                    if (comment.createdById == userLogin)...[
                                      IconButton(
                                        onPressed: () {
                                          AppDialog.editComment(
                                            initialValue: comment.comment,
                                            onSave: (newComment) async {
                                              final result = await commentC.updateById(
                                                int.parse(comment.id),
                                                newComment,
                                              );
                                              if (result == 'ok') {
                                                commentC.setFilterJob(jobId);
                                              } else {
                                                AppSnackbarRaw.error(result);
                                              }
                                            },
                                          );
                                        },
                                        icon: const Icon(Icons.edit_outlined),
                                        color: Colors.blueAccent,
                                        iconSize: 20,
                                        tooltip: "Edit Komentar",
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          AppDialog.confirm(
                                            title: "Konfirmasi Hapus",
                                            message: "Yakin ingin menghapus komentar ini?",
                                            confirmColor: Colors.red,
                                            icon: Icons.delete_outline,
                                            onConfirm: () async {
                                              final result = await commentC.deleteById(
                                                int.parse(comment.id),
                                              );
                                              if (result == 'ok') {
                                                commentC.setFilterJob(jobId);
                                              } else {
                                                AppSnackbarRaw.error(result);
                                              }
                                            },
                                          );
                                        },
                                        icon: const Icon(Icons.delete_outline),
                                        color: Colors.redAccent,
                                        iconSize: 20,
                                        tooltip: "Hapus Komentar",
                                      ),
                                    ],
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  comment.comment,
                                  softWrap: true,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    height: 1.4,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  width: double.infinity,
                                  height: 1,
                                  color: Colors.grey.shade200,
                                  margin: const EdgeInsets.only(top: 4),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      );
                    }),
                    const SizedBox(height: 12),
                    TextField(
                      controller: textCommentC,
                      decoration: InputDecoration(
                        hintText: "Tulis komentar...",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Colors.blueAccent,
                            width: 1.5,
                          ),
                        ),
                        suffixIcon: IconButton(
                          onPressed: () async {
                            if (textCommentC.text.isNotEmpty) {
                              final result = await commentC.create(jobId,textCommentC.text);
                              if (result == 'ok'){
                                textCommentC.text = '';
                                commentC.setFilterJob(jobId);
                              }else{
                                AppSnackbarRaw.error(result);
                              }
                            }
                          },
                          icon: const Icon(Icons.send_rounded),
                          color: Colors.blueAccent,
                          splashRadius: 24,
                        ),
                      ),
                    ),
                  ],
                ),),
              ),
            ),
          ),
        );
      }
    );
  }
}
