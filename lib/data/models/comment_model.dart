class Comment {
  final String id;
  final String workId;
  final String comment;
  final String createdAt;
  final String createdById;
  final String createdByName;
  final String updatedAt;
  final String updatedById;
  final String updatedByName;

  const Comment({
    required this.id,
    required this.workId,
    required this.comment,
    required this.createdAt,
    required this.createdById,
    required this.createdByName,
    required this.updatedAt,
    required this.updatedById,
    required this.updatedByName,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id']?.toString() ?? '',
      workId: json['work_id']?.toString() ?? '',
      comment: json['comment'] ?? '',
      createdAt: json['created_at'] ?? '',
      createdById: json['created_by']?['id']?.toString() ?? '',
      createdByName: json['created_by']?['name'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      updatedById: json['updated_by']?['id']?.toString() ?? '',
      updatedByName: json['updated_by']?['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'work_id': workId,
      'comment': comment,
      'created_at': createdAt,
      'created_by_id': createdById,
      'created_by_name': createdByName,
      'updated_at': updatedAt,
      'updated_by_id': updatedById,
      'updated_by_name': updatedByName,
    };
  }
}