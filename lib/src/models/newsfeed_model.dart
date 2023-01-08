class NewsFeedModel {
  NewsFeedModel({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  int? id;
  String? title;
  String? description;
  String? image;
  int? userId;
  dynamic createdAt;
  dynamic updatedAt;

  factory NewsFeedModel.fromMap(Map<String, dynamic> json) => NewsFeedModel(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        image: json["image"],
        userId: json["user_id"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "description": description,
        "image": image,
        "user_id": userId,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
