import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SharedFunctionController {
  //wilpop scope
  static Future<bool> onWillPop() async {
    return (await showDialog(
          context: Get.context!,
          builder: (context) => AlertDialog(
            title: const Text(
              'Close App',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: const Text(
              'Are you sure you want to close the app?',
              textAlign: TextAlign.center,
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }
}
