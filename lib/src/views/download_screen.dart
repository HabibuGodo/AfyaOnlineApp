import 'package:flutkit/loading_effect.dart';
import 'package:flutkit/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';

import '../controllers/download_controller.dart';

class DownloadScreen extends GetView<DownloadController> {
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
