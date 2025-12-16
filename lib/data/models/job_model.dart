class Jobs {
  final String id;
  final String floor;
  final String info;
  final String taskId;
  final String taskName;
  final String taskTypeId;
  final String taskTypeName;
  final bool unreadComment;
  final String createdAt;
  final String updatedAt;
  final String userId;
  final String userName;
  final String userProfile;
  final bool isDone;

  const Jobs({
    required this.id,
    required this.floor,
    required this.info,
    required this.taskId,
    required this.taskName,
    required this.taskTypeId,
    required this.taskTypeName,
    required this.unreadComment,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
    required this.userName,
    required this.userProfile,
    required this.isDone,
  });

  factory Jobs.fromJson(Map<String, dynamic> json) {
    return Jobs(
      id: json['id']?.toString() ?? '',
      floor: json['floor'] ?? '',
      info: json['info'] ?? '',
      taskId: json['task']?['id']?.toString() ?? '',
      taskName: json['task']?['name'] ?? '',
      taskTypeId: json['task_type']?['id']?.toString() ?? '',
      taskTypeName: json['task_type']?['name'] ?? '',
      unreadComment: json['unread_comment'] ?? false,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      userId: json['user']?['id']?.toString() ?? '',
      userName: json['user']?['name'] ?? '',
      userProfile: json['user']?['profile']?['view'] ?? '',
      isDone: json['is_done'] ?? false,
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
      'unread_comment': unreadComment,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'user_id': userId,
      'user_name': userName,
      'user_profile': userProfile,
      'is_done': isDone,
    };
  }
}