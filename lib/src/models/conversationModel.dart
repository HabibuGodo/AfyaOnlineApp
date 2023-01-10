class CoversatationModel {
  CoversatationModel({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.receiverName,
    required this.lastMessageTime,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  int? id;
  int? senderId;
  int? receiverId;
  String? receiverName;
  DateTime? lastMessageTime;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory CoversatationModel.fromMap(Map<String, dynamic> json) =>
      CoversatationModel(
        id: json["id"],
        senderId: json["sender_id"],
        receiverId: json["receiver_id"],
        receiverName: json["receiver_name"],
        lastMessageTime: DateTime.parse(json["last_message_time"]),
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "sender_id": senderId,
        "receiver_id": receiverId,
        "receiver_name": receiverName,
        "last_message_time": lastMessageTime?.toIso8601String(),
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
