class StaffJobModel {
  final String id;
  final String jobName;
  final String jobType; // e.g., Cleaning, Maintenance, etc.
  final String location;
  final DateTime completedAt;
  final String notes;

  StaffJobModel({
    required this.id,
    required this.jobName,
    required this.jobType,
    required this.location,
    required this.completedAt,
    required this.notes,
  });
}
