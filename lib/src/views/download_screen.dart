import 'dart:developer';

import 'package:flutkit/loading_effect.dart';
import 'package:flutkit/src/controllers/global.dart';
import 'package:flutkit/src/views/resources/preview_doc.dart';
import 'package:flutkit/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../controllers/download_controller.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/local_storage.dart';

class DownloadScreen extends GetView<DownloadController> {
  const DownloadScreen({key});

  @override
  Widget build(BuildContext context) {
    String url1 =
        "https://www.moh.go.tz/storage/app/uploads/public/61b/084/21e/61b08421e2f71055061527.pdf";
    String url2 =
        "https://www.doctorsoftheworld.org.uk/wp-content/uploads/2020/06/Kiswahili-Covid19-Guidance.pdf";

    return Obx(
      () => controller.uiLoading.value
          ? Container(
              child: LoadingEffect.getSearchLoadingScreen(
              Get.context!,
            ))
          : SafeArea(
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
                  title: FxText.sh1(
                    "Resources",
                    textAlign: TextAlign.center,
                  ),

                  // const Text('Class Modules', style: TextStyle(color: controller.theme.colorScheme.primary)
                  // ),
                  centerTitle: true,
                ),
                body: SafeArea(
                    child: Container(
                  padding: const EdgeInsets.all(8),
                  child: ListView(
                    children: [
                      FxSpacing.height(8),
                      // notes list
                      Container(
                        child: ListTile(
                          onTap: () {
                            // print file path

                            // var base = ImageURL.trim();

                            // var filePath =
                            //     base + controller.notesList[index].file;
                            Global.download(url1);
                            Get.to(() => PDFViewerCachedFromUrl(
                                  url: url1,
                                  name: "Sera Ya Afya",
                                ));
                          },
                          // leadung image
                          leading: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                    image: AssetImage('assets/icons/pdf.png'),
                                    fit: BoxFit.cover)),
                          ),
                          title: FxText.bodyMedium(
                            "Sera Ya Afya",
                            fontWeight: 600,
                          ),
                          // trailing: controller.indexVar1.value == true
                          //     ? CircularPercentIndicator(
                          //         radius: 15.0,
                          //         lineWidth: 3.0,
                          //         percent: controller.percentage.value / 100,
                          //         center: Text(
                          //           "${controller.percentage.value.toString()}%",
                          //           style: TextStyle(fontSize: 12),
                          //         ),
                          //         progressColor: Colors.green,
                          //       )
                          //     : downLoadData.read("checkFilename") ==
                          //             "Sera Ya Afya"
                          //         ? IconButton(
                          //             icon: Icon(
                          //               FeatherIcons.file,
                          //               color: Theme.of(context).primaryColor,
                          //             ),
                          //             onPressed: () async {
                          //               log(downLoadData.read("Sera Ya Afya"));
                          //               // OpenFile.open("/sdcard/example.txt");
                          //             },
                          //           )
                          //         : IconButton(
                          //             icon: Icon(
                          //               FeatherIcons.download,
                          //               color: Theme.of(context).primaryColor,
                          //             ),
                          //             onPressed: () async {
                          //               log("message");
                          //               controller.permissionReady.value =
                          //                   await controller.checkPermission();
                          //               if (controller.permissionReady.value) {
                          //                 controller.downloadNow(
                          //                     url1, "Sera Ya Afya", 1);
                          //               }
                          //             },
                          //           ),
                          subtitle: const Text('Uploaded on 09-01-2023'),
                        ),
                      ),
                      FxSpacing.height(4),
                      Divider(),
                      FxSpacing.height(4),
                      Container(
                        child: ListTile(
                          onTap: () {
                            // print file path

                            // var base = ImageURL.trim();

                            // var filePath =
                            //     base + controller.notesList[index].file;

                            Get.to(() => PDFViewerCachedFromUrl(
                                  url: url2,
                                  name:
                                      "Mwongozo wa Virusi Vya Korona (COVID-19)",
                                ));

                            Global.download(url2);
                          },
                          // leadung image
                          leading: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                    image: AssetImage('assets/icons/pdf.png'),
                                    fit: BoxFit.cover)),
                          ),
                          title: FxText.bodyMedium(
                            "Mwongozo wa Virusi Vya Korona (COVID-19)",
                            fontWeight: 600,
                          ),
                          // trailing: controller.indexVar2.value == true
                          //     ? CircularPercentIndicator(
                          //         radius: 15.0,
                          //         lineWidth: 3.0,
                          //         percent: controller.percentage.value / 100,
                          //         center: Text(
                          //           "${controller.percentage.value.toString()}%",
                          //           style: TextStyle(fontSize: 12),
                          //         ),
                          //         progressColor: Colors.green,
                          //       )
                          //     : controller.indexVarComp2.value == true
                          //         ? IconButton(
                          //             icon: Icon(
                          //               FeatherIcons.file,
                          //               color: Theme.of(context).primaryColor,
                          //             ),
                          //             onPressed: () async {},
                          //           )
                          //         : IconButton(
                          //             icon: Icon(
                          //               FeatherIcons.download,
                          //               color: Theme.of(context).primaryColor,
                          //             ),
                          //             onPressed: () async {
                          //               controller.permissionReady.value =
                          //                   await controller.checkPermission();
                          //               if (controller.permissionReady.value) {
                          //                 controller.downloadNow(
                          //                     url1,
                          //                     "Mwongozo wa Virusi Vya Korona (COVID-19)",
                          //                     2);
                          //               }
                          //             },
                          //           ),
                          subtitle: const Text('Uploaded on 08-01-2023'),
                        ),
                      ),
                    ],
                  ),
                )),
              ),
            ),
    );
  }
}

class DownloadScreen1 extends GetView<DownloadController> {
  List<Widget> _buildDownloadMovieList() {
    List<Widget> list = [];
    list.add(_buildSingleDownloadMovie());
    // for (DownloadMovie downloadMovie in controller.downloadMovies!) {
    //   list.add(_buildSingleDownloadMovie(downloadMovie));
    //   list.add(FxSpacing.height(20));
    // }
    return list;
  }

  Widget _buildSingleDownloadMovie() {
    return FxContainer(
      borderRadiusAll: 4,
      child: Row(
        children: [
          // FxContainer(
          //   height: 80,
          //   width: 80,
          //   paddingAll: 0,
          //   borderRadiusAll: 4,
          //   clipBehavior: Clip.antiAliasWithSaveLayer,
          //   child: Image(
          //     image: AssetImage(downloadMovie.movie.image),
          //     fit: BoxFit.cover,
          //   ),
          // ),
          FxSpacing.width(12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FxText.bodyMedium(
                "Sera Ya Afya",
                fontWeight: 600,
              ),
              // FxSpacing.height(4),
              // FxText.labelMedium(downloadMovie.movie.production),
              FxSpacing.height(6),
              Row(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          FxText.bodySmall(
                            "591.88 KB",
                            color: controller.customTheme.muviPrimary,
                          ),
                          FxSpacing.width(48),
                          FxText.bodySmall(
                            "591.88 KB",
                            color: controller.customTheme.muviPrimary,
                          ),
                        ],
                      ),
                      FxSpacing.height(2),
                      FxProgressBar(
                        height: 2,
                        activeColor: controller.customTheme.muviPrimary,
                        inactiveColor: controller.theme.colorScheme.onBackground
                            .withAlpha(30),
                        progress: (70 / 100),
                        width: MediaQuery.of(Get.context!).size.width - 224,
                      ),
                    ],
                  ),
                  FxSpacing.width(12),
                  Icon(
                    Icons.pause_circle_outline,
                    size: 20,
                    color: controller.theme.colorScheme.onBackground,
                  ),
                  FxSpacing.width(8),
                  Icon(
                    Icons.more_vert,
                    size: 20,
                    color: controller.theme.colorScheme.onBackground,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => _buildBody());
  }

  Widget _buildBody() {
    if (controller.uiLoading.value) {
      return Scaffold(
        body: Container(
          margin: FxSpacing.top(FxSpacing.safeAreaTop(Get.context!) + 20),
          child: LoadingEffect.getSearchLoadingScreen(
            Get.context!,
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: FxText.titleMedium(
            'Downloads',
            fontWeight: 600,
          ),
          centerTitle: true,
          elevation: 0,
          automaticallyImplyLeading: false,
        ),
        body: Container(
          margin: FxSpacing.x(20),
          child: Column(
            children: _buildDownloadMovieList(),
          ),
        ),
      );
    }
  }
}
