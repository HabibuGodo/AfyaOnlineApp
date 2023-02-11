class GroupModel {
  GroupModel({
    required this.id,
    required this.groupName,
    required this.profileImage,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.groupTokens,
  });

  int? id;
  String? groupName;
  String? profileImage;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic groupTokens;

  factory GroupModel.fromMap(Map<String, dynamic> json) {
    return GroupModel(
      id: json["id"],
      groupName: json["group_name"],
      profileImage: json["profile_image"],
      status: json["status"],
      createdAt: DateTime.parse(json["created_at"]),
      updatedAt: DateTime.parse(json["updated_at"]),
      groupTokens: json["group_tokens"],
    );
  }

  Map<String, dynamic> toMap() => {
        "id": id,
        "group_name": groupName,
        "profile_image": profileImage,
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "group_tokens": groupTokens,
      };
}
