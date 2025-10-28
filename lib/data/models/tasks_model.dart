class Tasks {
  final String id;
  final String name;
  final String taskId;
  final String taskName;

  const Tasks({
    required this.id,
    required this.name,
    required this.taskId,
    required this.taskName,
  });

  factory Tasks.fromJson(Map<String, dynamic> json) {
    return Tasks(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      taskId: json['task_id']?.toString() ?? '',
      taskName: json['task_name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'task_id': taskId,
      'task_name': taskName,
    };
  }
}