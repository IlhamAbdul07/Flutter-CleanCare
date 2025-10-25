import 'package:flutter/material.dart';
import 'package:flutter_cleancare/core/theme/app_color.dart';

class AddDetailJob extends StatelessWidget {
  const AddDetailJob({super.key});

  @override
  Widget build(BuildContext context) {
    final descC = TextEditingController();
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
          child: ListView(
            children: [
              const SizedBox(height: 20),
              Text(
                'Pilih Jenis Pekerjaan',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                textAlign: TextAlign.left,
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
              //
              const SizedBox(height: 24),
              Text(
                'Pilih Pekerjaan',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                textAlign: TextAlign.left,
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
              //
              const SizedBox(height: 24),
              Text(
                'Pilih Lantai',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                textAlign: TextAlign.left,
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
              //
              const SizedBox(height: 24),
              Text(
                'Deskripsi Pekerjaan',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                textAlign: TextAlign.left,
              ),
              TextFormField(
                controller: descC,
                minLines: 3,
                maxLines: 5,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  hintText: "Masukkan Email",
                ),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 18),
              Text(
                'Upload Foto Pekerjaan',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                textAlign: TextAlign.left,
              ),

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
                    "SUBMIT",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
