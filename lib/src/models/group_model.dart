class GroupModel {
  GroupModel({
    required this.id,
    required this.groupName,
    required this.profileImage,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  int? id;
  String? groupName;
  String? profileImage;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory GroupModel.fromMap(Map<String, dynamic> json) => GroupModel(
        id: json["id"],
        groupName: json["group_name"],
        profileImage: json["profile_image"],
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "group_name": groupName,
        "profile_image": profileImage,
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
