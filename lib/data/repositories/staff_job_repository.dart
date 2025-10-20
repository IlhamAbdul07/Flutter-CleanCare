import '../models/staff_job_model.dart';

class StaffJobRepository {
  final List<StaffJobModel> _jobs = [
    StaffJobModel(
      id: 'J001',
      jobName: 'Pembersihan Lobby',
      jobType: 'Cleaning',
      location: 'Gedung A - Lantai 1',
      completedAt: DateTime(2025, 10, 15, 14, 30),
      notes: 'Membersihkan area lobby dan resepsionis',
    ),
    StaffJobModel(
      id: 'J002',
      jobName: 'Pembersihan Toilet',
      jobType: 'Cleaning',
      location: 'Gedung A - Lantai 2',
      completedAt: DateTime(2025, 10, 15, 15, 00),
      notes: 'Membersihkan dan mensterilkan toilet',
    ),
    StaffJobModel(
      id: 'J003',
      jobName: 'Pembersihan Kantin',
      jobType: 'Cleaning',
      location: 'Gedung B - Lantai 1',
      completedAt: DateTime(2025, 10, 15, 16, 00),
      notes: 'Membersihkan area makan dan dapur',
    ),
    StaffJobModel(
      id: 'J004',
      jobName: 'Pembersihan Ruang Meeting',
      jobType: 'Cleaning',
      location: 'Gedung A - Lantai 3',
      completedAt: DateTime(2025, 10, 16, 09, 00),
      notes: 'Membersihkan ruang rapat utama',
    ),
    StaffJobModel(
      id: 'J005',
      jobName: 'Pembersihan Parkir',
      jobType: 'Cleaning',
      location: 'Basement',
      completedAt: DateTime(2025, 10, 16, 10, 00),
      notes: 'Membersihkan area parkir basement',
    ),
    StaffJobModel(
      id: 'J006',
      jobName: 'Perbaikan AC',
      jobType: 'Maintenance',
      location: 'Gedung B - Lantai 2',
      completedAt: DateTime(2025, 10, 16, 11, 00),
      notes: 'Pemeriksaan dan perbaikan unit AC',
    ),
    StaffJobModel(
      id: 'J007',
      jobName: 'Perbaikan Listrik',
      jobType: 'Maintenance',
      location: 'Gedung A - Lantai 4',
      completedAt: DateTime(2025, 10, 16, 13, 00),
      notes: 'Pengecekan instalasi listrik',
    ),
    StaffJobModel(
      id: 'J008',
      jobName: 'Perbaikan Lift',
      jobType: 'Maintenance',
      location: 'Gedung B',
      completedAt: DateTime(2025, 10, 16, 14, 00),
      notes: 'Maintenance rutin lift utama',
    ),
    StaffJobModel(
      id: 'J009',
      jobName: 'Perbaikan Plumbing',
      jobType: 'Maintenance',
      location: 'Gedung A - Lantai 2',
      completedAt: DateTime(2025, 10, 16, 15, 00),
      notes: 'Perbaikan sistem pemipaan',
    ),
    StaffJobModel(
      id: 'J010',
      jobName: 'Perbaikan Pintu',
      jobType: 'Maintenance',
      location: 'Gedung B - Lantai 1',
      completedAt: DateTime(2025, 10, 16, 16, 00),
      notes: 'Perbaikan pintu otomatis lobby',
    ),
  ];

  List<StaffJobModel> getAllJobs() => _jobs;

  void addJob(StaffJobModel job) {
    _jobs.add(job);
  }

  void removeJob(String id) {
    _jobs.removeWhere((j) => j.id == id);
  }
}
