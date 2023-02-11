// To parse this JSON data, do
//
//     final newsFeedModel = newsFeedModelFromMap(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

NewsFeedModel newsFeedModelFromMap(String str) =>
    NewsFeedModel.fromMap(json.decode(str));

String newsFeedModelToMap(NewsFeedModel data) => json.encode(data.toMap());

class NewsFeedModel {
  NewsFeedModel({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.file,
    required this.video,
    required this.audio,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  String title;
  String description;
  String image;
  String file;
  String video;
  String audio;
  int userId;
  DateTime createdAt;
  DateTime updatedAt;

  factory NewsFeedModel.fromMap(Map<String, dynamic> json) => NewsFeedModel(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        image: json["image"],
        file: json["file"] ?? "",
        video: json["video"] ?? "",
        audio: json["audio"] ?? "",
        userId: json["user_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "description": description,
        "image": image,
        "file": file,
        "video": video,
        "audio": audio,
        "user_id": userId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
