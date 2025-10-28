class JobSingle {
  final String id;
  final String floor;
  final String info;
  final String taskId;
  final String taskName;
  final String taskTypeId;
  final String taskTypeName;
  final String createdAt;
  final String updatedAt;
  final String userId;
  final String userName;
  final String userProfile;
  final String imageBefore;
  final String imageAfter;

  const JobSingle({
    required this.id,
    required this.floor,
    required this.info,
    required this.taskId,
    required this.taskName,
    required this.taskTypeId,
    required this.taskTypeName,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
    required this.userName,
    required this.userProfile,
    required this.imageBefore,
    required this.imageAfter,
  });

  factory JobSingle.fromJson(Map<String, dynamic> json) {
    return JobSingle(
      id: json['id']?.toString() ?? '',
      floor: json['floor'] ?? '',
      info: json['info'] ?? '',
      taskId: json['task']?['id']?.toString() ?? '',
      taskName: json['task']?['name'] ?? '',
      taskTypeId: json['task_type']?['id']?.toString() ?? '',
      taskTypeName: json['task_type']?['name'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      userId: json['user']?['id']?.toString() ?? '',
      userName: json['user']?['name'] ?? '',
      userProfile: json['user']?['profile']?['view'] ?? '',
      imageBefore: json['image_before']?['view'] ?? '',
      imageAfter: json['image_after']?['view'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'floor': floor,
      'info': info,
      'task_id': taskId,
      'task_name': taskName,
      'task_type_id': taskTypeId,
      'task_type_name': taskTypeName,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'user_id': userId,
      'user_name': userName,
      'user_profile': userProfile,
      'image_before': imageBefore,
      'image_after': imageAfter,
    };
  }
}