// ignore_for_file: prefer_const_constructors, non_constant_identifier_names

import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutkit/src/services/base_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show json;

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialize(BuildContext context) {
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: AndroidInitializationSettings("@mipmap/ic_launcher"));

    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  static Future<void> displayNotification(RemoteMessage message) async {
    try {} on Exception catch (e) {
      print(e.toString());
    }
    final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
      "afya_id",
      "afya_id channel",
      importance: Importance.max,
      priority: Priority.high,
    ));

    await flutterLocalNotificationsPlugin.show(id, message.notification?.title,
        message.notification?.body, notificationDetails,
        payload: message.data['payload']);
  }

  static Future<dynamic> send_push_notification(
      String peerToken, String title, dynamic payloadData, String body) async {
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Key=$firebaseServerKey'
    };
    var request =
        http.Request('POST', Uri.parse('https://fcm.googleapis.com/fcm/send'));
    request.body = json.encode({
      "to": peerToken,
      "notification": {
        "title": title,
        "body": body,
        "content_available": true,
        "priority": "high",
      },
      "data": payloadData
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }

  static Future<dynamic> send_push_notificationToMany(
      List peerTokens, String title, dynamic payloadData, String body) async {
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Key=$firebaseServerKey'
    };
    var request =
        http.Request('POST', Uri.parse('https://fcm.googleapis.com/fcm/send'));
    request.body = json.encode({
      "registration_ids": peerTokens,
      "notification": {
        "title": title,
        "body": body,
        "content_available": true,
        "priority": "high",
      },
      "data": payloadData
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }
}
