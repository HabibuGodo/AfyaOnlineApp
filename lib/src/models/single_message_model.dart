// To parse this JSON data, do
//
//     final singleMessageModel = singleMessageModelFromMap(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

SingleMessageModel? singleMessageModelFromMap(String str) => SingleMessageModel.fromMap(json.decode(str));

String singleMessageModelToMap(SingleMessageModel? data) => json.encode(data!.toMap());

class SingleMessageModel {
    SingleMessageModel({
        required this.id,
        required this.conversationId,
        required this.senderId,
        required this.receiverId,
        required this.message,
        required this.senderRead,
        required this.receiverRead,
        required this.status,
        required this.createdAt,
        required this.updatedAt,
    });

    int? id;
    int? conversationId;
    int? senderId;
    int? receiverId;
    String? message;
    int? senderRead;
    int? receiverRead;
    String? status;
    String? createdAt;
    String? updatedAt;

    factory SingleMessageModel.fromMap(Map<String, dynamic> json) => SingleMessageModel(
        id: json["id"],
        conversationId: json["conversation_id"],
        senderId: json["sender_id"],
        receiverId: json["receiver_id"],
        message: json["message"],
        senderRead: json["sender_read"],
        receiverRead: json["receiver_read"],
        status: json["status"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "conversation_id": conversationId,
        "sender_id": senderId,
        "receiver_id": receiverId,
        "message": message,
        "sender_read": senderRead,
        "receiver_read": receiverRead,
        "status": status,
        "created_at": createdAt,
        "updated_at": updatedAt,
    };
}
