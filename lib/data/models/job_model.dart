class Job {
  final String workerName;
  final String jobType;
  final int floor;
  final String description;
  final bool isCleaning;

  const Job({
    required this.workerName,
    required this.jobType,
    required this.floor,
    required this.description,
    required this.isCleaning,
  });
}
