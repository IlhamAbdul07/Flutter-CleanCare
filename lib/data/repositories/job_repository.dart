import 'package:flutter_cleancare/data/models/job_model.dart';

class JobRepository {
  // Dummy data simulasi dari API
  final List<Job> _jobs = const [
    Job(
      workerName: "Andi",
      jobType: "cleaning",
      floor: 1,
      description: "cleaning",
      isCleaning: true,
    ),
    Job(
      workerName: "Budi",
      jobType: "cleaning",
      floor: 1,
      description: "Lorong utama",
      isCleaning: true,
    ),
    Job(
      workerName: "Citra",
      jobType: "cleaning",
      floor: 2,
      description: "non-cleaning",
      isCleaning: true,
    ),
    Job(
      workerName: "Dian",
      jobType: "non-cleaning",
      floor: 2,
      description: "Ruang rapat",
      isCleaning: false,
    ),
    Job(
      workerName: "Eko",
      jobType: "non-cleaning",
      floor: 3,
      description: "Ruang meeting",
      isCleaning: false,
    ),
    Job(
      workerName: "Andi",
      jobType: "non-cleaning",
      floor: 1,
      description: "Lorong timur",
      isCleaning: true,
    ),
  ];

  List<Job> getAllJobs() => _jobs;
}