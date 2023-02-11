import 'dart:developer';

class MessageModel {
  MessageModel({
    required this.id,
    required this.groupId,
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.senderRead,
    required this.receiverRead,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.senderName,
  });

  int? id;
  int? groupId;
  int? senderId;
  String? senderName;
  String? receiverId;
  String? message;
  int? senderRead;
  int? receiverRead;
  String? status;
  String? createdAt;
  String? updatedAt;

  factory MessageModel.fromMap(Map<String, dynamic> json) {
    return MessageModel(
      id: json["id"],
      groupId: json["group_id"],
      senderId: json["sender_id"],
      senderName: json['sender_name'],
      receiverId: json["receiver_id"],
      message: json["message"],
      senderRead: json["sender_read"],
      receiverRead: json["receiver_read"],
      status: json["status"],
      createdAt: json["created_at"],
      updatedAt: json["updated_at"],
    );
  }
  // MessageModel(
  //       id: json["id"],
  //       groupId: json["group_id"],
  //       senderId: json["sender_id"],
  //       senderName: json['sender_name'],
  //       receiverId: json["receiver_id"],
  //       message: json["message"],
  //       senderRead: json["sender_read"],
  //       receiverRead: json["receiver_read"],
  //       status: json["status"],
  //       createdAt: json["created_at"],
  //       updatedAt: json["updated_at"],
  //     );

  Map<String, dynamic> toMap() => {
        "id": id,
        "group_id": groupId,
        "sender_id": senderId,
        "sender_name": senderName,
        "receiver_id": receiverId,
        "message": message,
        "sender_read": senderRead,
        "receiver_read": receiverRead,
        "status": status,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
