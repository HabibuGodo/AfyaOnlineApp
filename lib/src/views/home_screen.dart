import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutkit/assets.dart';
import 'package:flutkit/src/controllers/global.dart';
import 'package:flutkit/src/models/newsfeed_model.dart';
import 'package:flutkit/src/services/local_storage.dart';
import 'package:flutkit/src/views/resources/audioPlayer.dart';
import 'package:flutkit/src/views/resources/preview_doc.dart';
import 'package:flutkit/src/views/resources/videoPalyer.dart';
import 'package:flutkit/theme/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:flutkit/loading_effect.dart';
import 'package:flutkit/theme/app_theme.dart';
import 'package:get/get.dart';

import '../controllers/share_controller.dart';
import '../services/base_service.dart';

class HomeScreen extends GetView<ShareController> {
  HomeScreen({Key? key}) : super(key: key);

  List<Widget> _buildNewsList() {
    List<Widget> list = [];

    if (controller.newsFeeds.isEmpty) {
      return list;
    } else {
      list.add(FxSpacing.width(24));
      controller.newsFeeds.forEach((element) {
        list.add(_buildSingleNewsFeed(element));
      });

      return list;
    }
  }

  Widget _buildSingleNewsFeed(NewsFeedModel news) {
    return FxContainer(
      onTap: () {
        // Get.toNamed("/single_house", arguments: {'house': news});
      },
      margin: FxSpacing.nTop(24),
      paddingAll: 0,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      borderRadiusAll: Constant.containerRadius.medium,
      child: Column(
        children: [
          authData.read('role') != 1
              ? Container()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () async {
                        ArtDialogResponse response = await ArtSweetAlert.show(
                            barrierDismissible: false,
                            context: Get.context!,
                            artDialogArgs: ArtDialogArgs(
                                denyButtonText: "No, Don't",
                                denyButtonColor: Colors.red,
                                confirmButtonColor:
                                    controller.theme.colorScheme.primary,
                                title: 'Delete',
                                text:
                                    "Are you sure, you want to delete this this news?",
                                confirmButtonText: "Yes, delete",
                                type: ArtSweetAlertType.warning));

                        if (response.isTapConfirmButton) {
                          controller.deleteNewsFeed(id: news.id.toString());
                        }
                      },
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
          news.image.isEmpty
              ? Container()
              : Image(
                  image: NetworkImage(
                    "$imageURL${news.image}",
                  ),
                  fit: BoxFit.cover,
                  height: 250,
                  width: double.infinity,
                ),
          FxContainer(
            paddingAll: 16,
            // color: controller.theme.primaryColor.withOpacity(0.8),
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(Constant.containerRadius.medium),
                bottomRight: Radius.circular(Constant.containerRadius.medium)),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FxText.bodyLarge(
                      news.title.capitalizeFirst!,
                      fontWeight: 900,
                      // color: controller.theme.colorScheme.onPrimary,
                    ),
                  ],
                ),
                FxSpacing.height(8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: FxText.bodyMedium(
                              news.description.capitalizeFirst!,
                              // color: controller.theme.colorScheme.onPrimary,
                              fontSize: 15,
                              maxLines: 50,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                FxSpacing.height(8),
                news.file == ''
                    ? Container()
                    : Container(
                        margin: const EdgeInsets.only(
                          bottom: 10,
                        ),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 0,
                                  blurRadius: 1,
                                  offset: const Offset(0, 0))
                            ]),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 4.0, left: 20),
                              child: Text(
                                "File",
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            ListTile(
                              // onTap: () {
                              //   var base = imageURL.trim();

                              //   var filePath = base + news.file;

                              //   Global.download(filePath);
                              //   Get.to(() => PDFViewerCachedFromUrl(
                              //         url: filePath,
                              //         name: news.title.toString(),
                              //       ));
                              // },
                              // leadung image
                              leading: Container(
                                height: 40,
                                width: 40,
                                child: InkWell(
                                  onTap: () {
                                    var base = imageURL.trim();
                                    var filePath = base + news.file;
                                    Get.to(() => PDFViewerCachedFromUrl(
                                          url: filePath,
                                          name: news.title.toString(),
                                        ));
                                  },
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.preview,
                                        size: 40,
                                        color: Colors.blue,
                                      ),
                                      // Text("Play"),
                                    ],
                                  ),
                                ),
                              ),
                              // leading: Container(
                              //   height: 40,
                              //   width: 40,
                              //   decoration: BoxDecoration(
                              //       borderRadius: BorderRadius.circular(8),
                              //       image: const DecorationImage(
                              //           image: AssetImage(file),
                              //           fit: BoxFit.cover)),
                              // ),

                              // title: Row(
                              //   children: [
                              //     Icon(Icons.download_rounded),
                              //     Text("File"),
                              //   ],
                              // ),

                              title: Container(
                                margin: EdgeInsets.only(left: 30),
                                height: 40,
                                width: 40,
                                child: InkWell(
                                  onTap: () {
                                    var base = imageURL.trim();
                                    var filePath = base + news.file;
                                    Global.download(filePath);
                                  },
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.download,
                                        size: 40,
                                        color: Colors.green,
                                      ),
                                      // Text("Play"),
                                    ],
                                  ),
                                ),
                              ),
                              trailing: authData.read('role') != 1
                                  ? Container(
                                      child: Text(""),
                                    )
                                  : IconButton(
                                      onPressed: () async {
                                        ArtDialogResponse
                                            response =
                                            await ArtSweetAlert.show(
                                                barrierDismissible: false,
                                                context: Get.context!,
                                                artDialogArgs: ArtDialogArgs(
                                                    denyButtonText: "No, Don't",
                                                    denyButtonColor: Colors.red,
                                                    confirmButtonColor:
                                                        controller.theme
                                                            .colorScheme.primary,
                                                    title: 'Delete',
                                                    text:
                                                        "Are you sure, you want to delete this this file?",
                                                    confirmButtonText:
                                                        "Yes, delete",
                                                    type: ArtSweetAlertType
                                                        .warning));

                                        if (response.isTapConfirmButton) {
                                          controller.editNewsFeed(
                                            id: news.id.toString(),
                                            title: news.title,
                                            description: news.description,
                                            imageFile: news.image,
                                            docFile: '',
                                            videoFile: news.video,
                                            audioFile: news.audio,
                                          );
                                        }
                                      },
                                      icon: Icon(
                                        Icons.remove_circle,
                                        color: Colors.red,
                                      )),
                              // subtitle: const Text('Uploaded on 2021-05-05'),
                            ),
                          ],
                        ),
                      ),
                news.video == ''
                    ? Container()
                    : Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 0,
                                  blurRadius: 1,
                                  offset: const Offset(0, 0))
                            ]),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 4.0, left: 20),
                              child: Text(
                                "Video",
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            ListTile(
                              // leadung image
                              leading: Container(
                                height: 40,
                                width: 40,
                                child: InkWell(
                                  onTap: () {
                                    var base = imageURL.trim();
                                    var videoPath = base + news.video;
                                    Navigator.push(
                                        Get.context!,
                                        MaterialPageRoute(
                                            builder: (context) => VideoApp(
                                                  title: news.title,
                                                  videoUrl: videoPath,
                                                )));
                                  },
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.play_circle,
                                        size: 40,
                                        color: Colors.blue,
                                      ),
                                      // Text("Play"),
                                    ],
                                  ),
                                ),
                              ),

                              title: Container(
                                margin: EdgeInsets.only(left: 30),
                                height: 40,
                                width: 40,
                                child: InkWell(
                                  onTap: () {
                                    var base = imageURL.trim();
                                    var videoPath = base + news.video;
                                    Global.download(videoPath);
                                  },
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.download,
                                        size: 40,
                                        color: Colors.green,
                                      ),
                                      // Text("Play"),
                                    ],
                                  ),
                                ),
                              ),
                              trailing: authData.read('role') != 1
                                  ? Container(
                                      child: Text(""),
                                    )
                                  : IconButton(
                                      onPressed: () async {
                                        ArtDialogResponse
                                            response =
                                            await ArtSweetAlert.show(
                                                barrierDismissible: false,
                                                context: Get.context!,
                                                artDialogArgs: ArtDialogArgs(
                                                    denyButtonText: "No, Don't",
                                                    denyButtonColor: Colors.red,
                                                    confirmButtonColor:
                                                        controller.theme
                                                            .colorScheme.primary,
                                                    title: 'Delete',
                                                    text:
                                                        "Are you sure, you want to delete this this video?",
                                                    confirmButtonText:
                                                        "Yes, Delete",
                                                    type: ArtSweetAlertType
                                                        .warning));

                                        if (response.isTapConfirmButton) {
                                          controller.editNewsFeed(
                                            id: news.id.toString(),
                                            title: news.title,
                                            description: news.description,
                                            imageFile: news.image,
                                            docFile: news.file,
                                            videoFile: '',
                                            audioFile: news.audio,
                                          );
                                        }
                                      },
                                      icon: Icon(
                                        Icons.remove_circle,
                                        color: Colors.red,
                                      )),
                              // subtitle: const Text('Uploaded on 2021-05-05'),
                            ),
                          ],
                        ),
                      ),
                news.audio == ''
                    ? Container()
                    : Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 0,
                                  blurRadius: 1,
                                  offset: const Offset(0, 0))
                            ]),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 4.0, left: 20),
                              child: Text(
                                "Audio",
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            ListTile(
                              // leadung image
                              leading: Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    image: const DecorationImage(
                                        image: AssetImage(file),
                                        fit: BoxFit.cover)),
                              ),

                              // Container(
                              //   height: 40,
                              //   width: 40,
                              //   child: InkWell(
                              //     onTap: () {
                              //       var base = imageURL.trim();
                              //       var audioPath = base + news.audio;
                              //       Navigator.push(
                              //           Get.context!,
                              //           MaterialPageRoute(
                              //               builder: (context) =>
                              //                   AudioPlayerApp(
                              //                     title: news.title,
                              //                     audioUrl: audioPath,
                              //                   )));
                              //     },
                              //     child: Row(
                              //       children: [
                              //         Icon(
                              //           Icons.play_circle,
                              //           size: 40,
                              //           color: Colors.blue,
                              //         ),
                              //         // Text("Play"),
                              //       ],
                              //     ),
                              //   ),
                              // ),

                              title: Container(
                                margin: EdgeInsets.only(left: 30),
                                height: 40,
                                width: 40,
                                child: InkWell(
                                  onTap: () {
                                    var base = imageURL.trim();
                                    var audioPath = base + news.audio;
                                    Global.download(audioPath);
                                  },
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.download,
                                        size: 40,
                                        color: Colors.green,
                                      ),
                                      // Text("Play"),
                                    ],
                                  ),
                                ),
                              ),
                              trailing: authData.read('role') != 1
                                  ? Container(
                                      child: Text(""),
                                    )
                                  : IconButton(
                                      onPressed: () async {
                                        ArtDialogResponse
                                            response =
                                            await ArtSweetAlert.show(
                                                barrierDismissible: false,
                                                context: Get.context!,
                                                artDialogArgs: ArtDialogArgs(
                                                    denyButtonText: "No, Don't",
                                                    denyButtonColor: Colors.red,
                                                    confirmButtonColor:
                                                        controller.theme
                                                            .colorScheme.primary,
                                                    title: 'Delete',
                                                    text:
                                                        "Are you sure, you want to delete this this audio?",
                                                    confirmButtonText:
                                                        "Yes, Delete",
                                                    type: ArtSweetAlertType
                                                        .warning));

                                        if (response.isTapConfirmButton) {
                                          controller.editNewsFeed(
                                            id: news.id.toString(),
                                            title: news.title,
                                            description: news.description,
                                            imageFile: news.image,
                                            docFile: news.file,
                                            videoFile: news.video,
                                            audioFile: '',
                                          );
                                        }
                                      },
                                      icon: Icon(
                                        Icons.remove_circle,
                                        color: Colors.red,
                                      )),
                              // subtitle: const Text('Uploaded on 2021-05-05'),
                            ),
                          ],
                        ),
                      )
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Theme(
        data: controller.theme.copyWith(
            colorScheme: controller.theme.colorScheme
                .copyWith(secondary: controller.theme.primaryColor)),
        child: Scaffold(
          body: RefreshIndicator(
            onRefresh: () async {
              controller.getNewsFeeds();
            },
            child: Container(
              padding: FxSpacing.top(FxSpacing.safeAreaTop(context)),
              child: Column(
                children: [
                  Container(
                    height: 2,
                    child: controller.showLoading.value == true
                        ? LinearProgressIndicator(
                            color: controller.theme.colorScheme.primary,
                            minHeight: 2,
                          )
                        : Container(
                            height: 2,
                          ),
                  ),
                  Expanded(
                    child: _buildBody(),
                  ),
                ],
              ),
            ),
          ),
          // floating action button
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              // Get.to(() => Chat(),
              //     transition: Transition.rightToLeftWithFade);

              Get.toNamed('/add_item');
            },
            backgroundColor: controller.theme.colorScheme.primary,
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (controller.uiLoading.value) {
      return Container(
          child: LoadingEffect.getSearchLoadingScreen(
        Get.context!,
      ));
    } else {
      return ListView(
        padding: FxSpacing.top(20),
        children: [
          Padding(
            padding: FxSpacing.horizontal(24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FxText.bodySmall(
                      'Welcome',
                      xMuted: true,
                    ),
                    FxSpacing.height(4),
                    Row(
                      children: [
                        Icon(
                          Icons.person,
                          color: controller.theme.colorScheme.primary,
                          size: 14,
                        ),
                        FxSpacing.width(4),
                        FxText.bodyMedium(
                          authData.read("name").toString().capitalize!,
                          fontWeight: 600,
                          fontSize: 18,
                        ),
                      ],
                    ),
                  ],
                ),
                // FxContainer(
                //   onTap: () {
                //     _selectSizeSheet(Get.context!);
                //   },
                //   color: controller.theme.colorScheme.secondaryContainer,
                //   paddingAll: 6,
                //   child: Icon(
                //     Icons.more_horiz_outlined,
                //     color: controller.theme.colorScheme.secondary,
                //   ),
                // ),
              ],
            ),
          ),
          FxSpacing.height(24),
          // SingleChildScrollView(
          //   scrollDirection: Axis.horizontal,
          //   child: Row(
          //     children: _buildCategoryList(),
          //   ),
          // ),
          FxSpacing.height(24),
          Padding(
            padding: FxSpacing.horizontal(24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FxText.bodyLarge(
                  'News Feeds',
                  fontWeight: 600,
                ),
                // FxText.bodySmall(
                //   'More',
                //   xMuted: true,
                // ),
              ],
            ),
          ),
          FxSpacing.height(16),
          controller.newsFeeds.length == 0
              ? Container(
                  margin: FxSpacing.top(200),
                  child: Center(
                    child: FxText.sh1(
                      "No any news feed",
                      color: controller.theme.colorScheme.onBackground,
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : Column(
                  children: _buildNewsList(),
                ),
        ],
      );
    }
  }
}

class SingleBed extends StatefulWidget {
  final String bed;
  final bool selected;

  const SingleBed({Key? key, required this.bed, required this.selected})
      : super(key: key);

  @override
  _SingleBedState createState() => _SingleBedState();
}

class _SingleBedState extends State<SingleBed> {
  late ThemeData theme;

  @override
  void initState() {
    super.initState();
    theme = AppTheme.communityTBTheme;
  }

  @override
  Widget build(BuildContext context) {
    bool selected = widget.selected;

    return FxContainer(
      padding: FxSpacing.symmetric(horizontal: 16, vertical: 8),
      borderRadiusAll: 8,
      margin: FxSpacing.right(12),
      bordered: true,
      border: Border.all(
          color:
              selected ? theme.colorScheme.primary : theme.colorScheme.primary),
      splashColor: theme.primaryColor,
      color: selected ? theme.colorScheme.primary : theme.primaryColor,
      child: FxText.bodySmall(
        widget.bed,
        fontWeight: 600,
        color: selected
            ? theme.colorScheme.onPrimary
            : theme.colorScheme.onPrimary,
      ),
    );
  }
}

class SingleBath extends StatefulWidget {
  final String bath;
  final bool selected;

  const SingleBath({Key? key, required this.bath, required this.selected})
      : super(key: key);

  @override
  _SingleBathState createState() => _SingleBathState();
}

class _SingleBathState extends State<SingleBath> {
  late ThemeData theme;

  @override
  void initState() {
    super.initState();
    theme = AppTheme.communityTBTheme;
  }

  @override
  Widget build(BuildContext context) {
    bool selected = widget.selected;

    return FxContainer(
      padding: FxSpacing.symmetric(horizontal: 16, vertical: 8),
      borderRadiusAll: 8,
      margin: FxSpacing.right(12),
      bordered: true,
      border: Border.all(
          color:
              selected ? theme.colorScheme.primary : theme.colorScheme.primary),
      splashColor: theme.primaryColor,
      color: selected ? theme.colorScheme.primary : theme.primaryColor,
      child: FxText.bodySmall(
        widget.bath,
        fontWeight: 600,
        color: selected
            ? theme.colorScheme.onPrimary
            : theme.colorScheme.onPrimary,
      ),
    );
  }
}
