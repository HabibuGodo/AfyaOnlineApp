import 'package:flutkit/src/models/items_model.dart';
import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:flutkit/loading_effect.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../theme/constant.dart';
import '../controllers/single_agent_controller.dart';
import '../services/base_service.dart';

class SingleAgentScreen extends GetView<SingleAgentController> {
  const SingleAgentScreen({key});
  Widget _buildSingleHouse(ItemsModel item) {
    return FxContainer(
      onTap: () {
        Get.toNamed("/single_house", arguments: {'house': item});
      },
      margin: FxSpacing.right(16),
      width: 200,
      paddingAll: 16,
      borderRadiusAll: Constant.containerRadius.medium,
      color: controller.theme.colorScheme.secondaryContainer,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FxContainer(
            paddingAll: 0,
            borderRadiusAll: Constant.containerRadius.medium,
            clipBehavior: Clip.hardEdge,
            child: Image(
              fit: BoxFit.fill,
              width: 200,
              height: 120,
              image: item.images.length == 0
                  ? AssetImage("assets/images/apps/estate/estate7.jpg")
                      as ImageProvider
                  : //network image with host

                  NetworkImage("$imageURL${item.images[0].url}"),
            ),
          ),
          FxSpacing.height(8),
          FxText.bodyLarge(
            item.name,
            fontWeight: 700,
            color: controller.theme.colorScheme.onSecondaryContainer,
          ),
          FxSpacing.height(4),
          FxText.bodySmall(
            "${item.ward.name}, ${item.ward.district.name}",
            xMuted: true,
            color: controller.theme.colorScheme.onSecondaryContainer,
          ),
          FxSpacing.height(4),
          FxText.bodySmall(
            "Tsh${item.price.toString()}",
            color: controller.theme.colorScheme.onSecondaryContainer,
          ),
        ],
      ),
    );
  }

  List<Widget> _buildHouseList() {
    List<Widget> list = [];
    list.add(FxSpacing.width(24));

    for (ItemsModel item in controller.items) {
      list.add(_buildSingleHouse(item));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Theme(
        data: controller.theme.copyWith(
            colorScheme: controller.theme.colorScheme
                .copyWith(secondary: controller.theme.primaryColor)),
        child: Scaffold(
          body: Padding(
            padding: FxSpacing.top(FxSpacing.safeAreaTop(context)),
            child: Column(
              children: [
                Container(
                  height: 2,
                  child: controller.showLoading.value
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
      ),
    );
  }

  Widget _buildBody() {
    if (controller.uiLoading.value) {
      return Container(
          margin: FxSpacing.top(16),
          child: LoadingEffect.getSearchLoadingScreen(
            Get.context!,
          ));
    } else {
      return ListView(
        padding: FxSpacing.fromLTRB(0, 8, 0, 20),
        children: [
          Padding(
            padding: FxSpacing.horizontal(24),
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(Get.context!);
                  },
                  child: FxContainer(
                    paddingAll: 4,
                    color: controller.theme.primaryColor,
                    child: Icon(
                      Icons.chevron_left_outlined,
                      color: controller.theme.colorScheme.onPrimary,
                    ),
                  ),
                ),
                FxSpacing.width(64),
                FxText.bodyLarge(
                  'Agent Profile',
                  fontWeight: 700,
                ),
              ],
            ),
          ),
          FxSpacing.height(24),
          Padding(
            padding: FxSpacing.horizontal(24),
            child: FxContainer(
              paddingAll: 12,
              borderRadiusAll: Constant.containerRadius.large,
              color: controller.theme.primaryColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      FxContainer(
                        paddingAll: 0,
                        borderRadiusAll: Constant.containerRadius.medium,
                        clipBehavior: Clip.hardEdge,
                        child: Image(
                          height: 56,
                          fit: BoxFit.cover,
                          image: controller.agent.imageUrl == null
                              ? AssetImage(
                                      "assets/images/profile/avatar_place.png")
                                  as ImageProvider
                              : //network image with host

                              NetworkImage(
                                  "$imageURL${controller.agent.imageUrl}"),
                        ),
                      ),
                      FxSpacing.width(16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FxText.bodyLarge(
                            controller.agent.name,
                            fontWeight: 700,
                            color: controller.theme.colorScheme.onPrimary,
                          ),
                          FxSpacing.height(8),
                          Row(
                            children: [
                              Icon(
                                Icons.phone,
                                size: 16,
                                color: controller.theme.colorScheme.onPrimary,
                              ),
                              FxSpacing.width(4),
                              FxText.bodySmall(
                                controller.agent.phone,
                                xMuted: true,
                                color: controller.theme.colorScheme.onPrimary,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  FxSpacing.height(16),
                  FxText.bodyMedium(
                    'Information',
                    fontWeight: 700,
                    color: controller.theme.colorScheme.onPrimary,
                  ),
                  FxSpacing.height(8),
                  Row(
                    children: [
                      FxContainer.rounded(
                          paddingAll: 4,
                          color: controller.theme.colorScheme.primary
                              .withAlpha(40),
                          child: Icon(
                            Icons.mail,
                            color: controller.theme.colorScheme.onPrimary,
                            size: 14,
                          )),
                      FxSpacing.width(12),
                      FxText.bodySmall(
                        controller.agent.email,
                        color: controller.theme.colorScheme.onPrimary,
                      ),
                    ],
                  ),
                  FxSpacing.height(8),
                  Row(
                    children: [
                      FxContainer.rounded(
                          paddingAll: 4,
                          color: controller.theme.colorScheme.primary
                              .withAlpha(40),
                          child: Icon(
                            Icons.house,
                            color: controller.theme.colorScheme.onPrimary,
                            size: 14,
                          )),
                      FxSpacing.width(12),
                      FxText.bodySmall(
                        controller.agent.role,
                        color: controller.theme.colorScheme.onPrimary,
                      ),
                    ],
                  ),
                  FxSpacing.height(16),
                  // FxText.bodyMedium(
                  //   'About Me',
                  //   fontWeight: 700,
                  //   color: controller.theme.colorScheme.onPrimary,
                  // ),
                  // FxSpacing.height(8),
                  // RichText(
                  //   text: TextSpan(children: <TextSpan>[
                  //     TextSpan(
                  //         text: controller.agent.name,
                  //         style: FxTextStyle.bodySmall(
                  //           color:
                  //               controller.theme.colorScheme.onPrimary,
                  //           xMuted: true,
                  //           height: 1.5,
                  //         )),
                  //     TextSpan(
                  //       text: " Read more",
                  //       style: FxTextStyle.bodySmall(
                  //         color: controller.theme.colorScheme.secondary,
                  //       ),
                  //     ),
                  //   ]),
                  // ),
                ],
              ),
            ),
          ),
          FxSpacing.height(16),
          FxSpacing.height(20),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: FxButton.block(
              padding: FxSpacing.symmetric(horizontal: 24, vertical: 16),
              onPressed: () {
                var phone = controller.agent.phone.replaceRange(0, 3, "0");

                launch("tel://$phone");
              },
              child: FxText.bodyMedium(
                'Call Agent',
                color: controller.theme.colorScheme.onPrimary,
                fontWeight: 700,
              ),
              backgroundColor: controller.theme.colorScheme.primary,
              borderRadiusAll: Constant.containerRadius.large,
              elevation: 0,
            ),
          ),
          // Padding(
          //   padding: FxSpacing.horizontal(24),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       FxText.bodyMedium(
          //         'Agent Listings',
          //         fontWeight: 700,
          //       ),
          //       FxText.bodySmall(
          //         'See All',
          //         xMuted: true,
          //         fontSize: 10,
          //       ),
          //     ],
          //   ),
          // ),
          // FxSpacing.height(16),
          // SingleChildScrollView(
          //   scrollDirection: Axis.horizontal,
          //   child: Row(
          //     children: _buildHouseList(),
          //   ),
          // ),
        ],
      );
    }
  }
}
