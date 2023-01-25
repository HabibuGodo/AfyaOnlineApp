class CoversatationModel {
  CoversatationModel({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.lastMessageTime,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.receiverName,
    required this.totalUnread,
    required this.lastMessage,
    required this.lastMsgReceiverId,
    required this.receiverProfile,
    required this.readStatus,
    required this.firebaseToken,
  });

  int? id;
  int? senderId;
  int? receiverId;
  DateTime? lastMessageTime;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? receiverName;
  int? totalUnread;
  String? lastMessage;
  int? lastMsgReceiverId;
  dynamic receiverProfile;
  int? readStatus;
  String firebaseToken;

  factory CoversatationModel.fromMap(Map<String, dynamic> json) =>
      CoversatationModel(
        id: json["id"],
        senderId: json["sender_id"],
        receiverId: json["receiver_id"],
        lastMessageTime: DateTime.parse(json["last_message_time"]),
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        receiverName: json["receiver_name"],
        totalUnread: json["totalUnread"],
        lastMessage: json["last_message"],
        lastMsgReceiverId: json["lastMsgReceiverId"],
        receiverProfile: json["receiver_profile"],
        readStatus: json["readStatus"],
        firebaseToken: json["firebaseToken"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "sender_id": senderId,
        "receiver_id": receiverId,
        "last_message_time": lastMessageTime?.toIso8601String(),
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "receiver_name": receiverName,
        "totalUnread": totalUnread,
        "last_message": lastMessage,
        "lastMsgReceiverId": lastMsgReceiverId,
        "receiver_profile": receiverProfile,
        "readStatus": readStatus,
        "firebaseToken": firebaseToken,
      };
}
