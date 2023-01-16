import 'package:flutkit/src/controllers/chats/all_inside_chat_controller.dart';
import 'package:flutkit/src/views/chats/single_user_convo_list.dart';
import 'package:flutkit/src/views/chats/single_users_list.dart';
import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';

import 'group_list_screen.dart';

class AllChats extends StatelessWidget {
  AllChats({key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
            ),
            onPressed: () {
              Get.back();
            },
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          title: FxText.bodyMedium(
            "Chats",
            fontWeight: 900,
            fontSize: 17,
          ),
          centerTitle: true,
          bottom: TabBar(
            indicatorColor: Theme.of(context).primaryColor,
            automaticIndicatorColorAdjustment: true,
            tabs: [
              Tab(
                child: Text(
                  'Single',
                ),
              ),
              Tab(
                child: Text(
                  'Groups',
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [SingleUserConvoListScreen(), GroupListScreen()],
        ),
      ),
    );
  }
}
