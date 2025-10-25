import 'package:flutter/material.dart';
import 'package:flutter_cleancare/core/theme/app_color.dart';
import 'package:flutter_cleancare/widgets/app_dialog.dart';

class JobDetailPage extends StatelessWidget {
  const JobDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final descC = TextEditingController();
    final commentC = TextEditingController();
    final jobTypeList = ['Cleaning', 'Non-Cleaning'];
    String selectedJobType = jobTypeList.first;
    final jobList = ['Dusting', 'Mopping'];
    String selectedJob = jobList.first;
    final floorList = ['1', '2', '3', '4', '5'];
    String selectedFloor = floorList.first;

    final formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text("Detail Pekerjaan"),
        backgroundColor: AppColor.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // --- Job Type ---
              const Text(
                'Pilih Jenis Pekerjaan',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              DropdownButtonFormField<String>(
                value: selectedJobType,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                ),
                items: jobTypeList
                    .map(
                      (jobType) => DropdownMenuItem(
                        value: jobType,
                        child: Text(jobType),
                      ),
                    )
                    .toList(),
                onChanged: (val) {
                  if (val != null) selectedJobType = val;
                },
              ),

              const SizedBox(height: 24),

              // --- Job Name ---
              const Text(
                'Pilih Pekerjaan',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              DropdownButtonFormField<String>(
                value: selectedJob,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                ),
                items: jobList
                    .map(
                      (job) => DropdownMenuItem(value: job, child: Text(job)),
                    )
                    .toList(),
                onChanged: (val) {
                  if (val != null) selectedJob = val;
                },
              ),

              const SizedBox(height: 24),

              // --- Floor ---
              const Text(
                'Pilih Lantai',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              DropdownButtonFormField<String>(
                value: selectedFloor,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                ),
                items: floorList
                    .map(
                      (floor) =>
                          DropdownMenuItem(value: floor, child: Text(floor)),
                    )
                    .toList(),
                onChanged: (val) {
                  if (val != null) selectedFloor = val;
                },
              ),

              const SizedBox(height: 24),

              // --- Description ---
              const Text(
                'Deskripsi Pekerjaan',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              TextFormField(
                controller: descC,
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

              const SizedBox(height: 24),

              // --- Upload Button ---
              const Text(
                'Upload Foto Pekerjaan',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
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
                  onPressed: () {},
                  child: const Text(
                    "SUBMIT",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),

              const SizedBox(height: 24),
              const Divider(height: 32),

              // --- Comment Section Title ---
              const Text(
                'COMMENT',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),

              // --- Grey Container for Comments ---
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Andi',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    AppDialog.editComment(
                                      initialValue: "Komentar lama di sini...",

                                      onSave: (newComment) {
                                        // 🔹 Aksi ketika tombol "Simpan" ditekan
                                        print("Komentar baru: $newComment");
                                      },
                                    );
                                  },
                                  icon: const Icon(Icons.edit),
                                  iconSize: 20,
                                  color: Colors.blueAccent,
                                ),
                                IconButton(
                                  onPressed: () {
                                    AppDialog.confirm(
                                      title: "Konfirmasi Hapus",
                                      message:
                                          "Apakah kamu yakin ingin menghapus komentar ini?",
                                      confirmColor: Colors.red,
                                      icon: Icons.delete,
                                      onConfirm: () {
                                        // aksi hapus komentar
                                      },
                                    );
                                  },
                                  icon: const Icon(Icons.delete),
                                  iconSize: 20,
                                  color: Colors.redAccent,
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Pekerjaannya sudah selesai, tinggal dicek ulang bagian pintu.',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.maxFinite,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Andi',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    // aksi edit di sini
                                  },
                                  icon: const Icon(Icons.edit),
                                  iconSize: 20,
                                  color: Colors.blueAccent,
                                ),
                                IconButton(
                                  onPressed: () {
                                    AppDialog.confirm(
                                      title: "Konfirmasi Hapus",
                                      message:
                                          "Apakah kamu yakin ingin menghapus komentar ini?",
                                      confirmColor: Colors.red,
                                      icon: Icons.delete,
                                      onConfirm: () {
                                        // aksi hapus komentar
                                      },
                                    );
                                  },
                                  icon: const Icon(Icons.delete),
                                  iconSize: 20,
                                  color: Colors.redAccent,
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        const Text('Siap Pak!'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: commentC,
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
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),

                      // 🔹 Icon tombol kirim di dalam TextField
                      suffixIcon: IconButton(
                        onPressed: () {
                          // aksi kirim komentar
                          // contoh: print(commentC.text);
                        },
                        icon: const Icon(Icons.send_rounded),
                        color: Colors.blueAccent,
                        splashRadius: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
