import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutx/flutx.dart';
import 'package:flutkit/loading_effect.dart';
import 'package:flutkit/theme/app_theme.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';

import '../../theme/constant.dart';
import '../controllers/single_house_controller.dart';
import '../models/house.dart';
import 'package:flutter/material.dart';

import '../services/base_service.dart';

class SingleHouseScreen extends GetView<SingleHouseController> {
  const SingleHouseScreen({key});

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
                          color: controller.theme.primaryColor,
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
      return Container(
        padding: FxSpacing.fromLTRB(24, 8, 24, 0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                Expanded(
                  child: FxText.bodyLarge(
                    'Details',
                    fontWeight: 700,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView(
                padding: FxSpacing.y(16),
                children: [
                  FxContainer(
                      paddingAll: 0,
                      borderRadiusAll: Constant.containerRadius.large,
                      clipBehavior: Clip.hardEdge,
                      child: CarouselSlider(
                          options:
                              CarouselOptions(viewportFraction: 1, height: 230),
                          items: controller.house.images.length == 0
                              ? [
                                  FxContainer(
                                    paddingAll: 0,
                                    borderRadiusAll:
                                        Constant.containerRadius.large,
                                    clipBehavior: Clip.hardEdge,
                                    child: Center(
                                      child: Image(
                                          fit: BoxFit.fill,
                                          image: AssetImage(
                                              "assets/images/apps/estate/estate7.jpg"),
                                          width: 1000),
                                    ),
                                  )
                                ]
                              : controller.house.images
                                  .map((e) => FxContainer(
                                        paddingAll: 0,
                                        borderRadiusAll:
                                            Constant.containerRadius.large,
                                        clipBehavior: Clip.hardEdge,
                                        child: Center(
                                          child: Image.network(
                                            imageURL + e.url,
                                            fit: BoxFit.fill,
                                            width: double.infinity,
                                          ),

                                          // Image(
                                          //     fit: BoxFit.fill,
                                          //     image: NetworkImage(),
                                          //     width: 1000),
                                        ),
                                      ))
                                  .toList())),
                  FxSpacing.height(16),
                  FxContainer(
                    onTap: () {
                      Get.toNamed('/single_agent', arguments: {
                        'agent': controller.house.user,
                        'item': controller.house
                      });
                    },
                    color: controller.theme.primaryColor,
                    paddingAll: 8,
                    borderRadiusAll: Constant.containerRadius.medium,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FxContainer(
                          paddingAll: 0,
                          borderRadiusAll: Constant.containerRadius.medium,
                          clipBehavior: Clip.hardEdge,

                          child: Image(
                            height: 52,
                            fit: BoxFit.cover,
                            image: controller.house.user.imageUrl == null
                                ? AssetImage(
                                        "assets/images/profile/avatar_place.png")
                                    as ImageProvider
                                : //network image with host

                                NetworkImage(
                                    "$imageURL${controller.house.user.imageUrl}"),
                          ),

                          //  Image(
                          //   height: 52,
                          //   fit: BoxFit.cover,
                          //   image: AssetImage(controller.house.user.imageUrl ?? ),                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FxText.bodyMedium(
                              controller.house.user.name.capitalize!,
                              fontWeight: 700,
                              color: controller.theme.colorScheme.onPrimary,
                            ),
                            FxSpacing.height(8),
                            FxText.bodySmall(
                              'View Agent Profile',
                              xMuted: true,
                              color: controller.theme.colorScheme.onPrimary,
                            ),
                          ],
                        ),
                        FxSpacing.width(60),
                        Icon(
                          Icons.chevron_right_sharp,
                          color: controller.theme.colorScheme.onPrimary,
                        ),
                      ],
                    ),
                  ),
                  FxSpacing.height(16),
                  FxContainer(
                    paddingAll: 16,
                    borderRadiusAll: Constant.containerRadius.medium,
                    color: controller.theme.primaryColor,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            FxText.bodyLarge(
                              controller.house.name.capitalize!,
                              fontWeight: 700,
                              color: controller.theme.colorScheme.onPrimary,
                            ),
                            FxText.bodyMedium(
                              "\Tsh" + controller.house.price.toString(),
                              fontWeight: 600,
                              color: controller.theme.colorScheme.secondary,
                            ),
                          ],
                        ),
                        FxSpacing.height(8),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 16,
                              color: controller.theme.colorScheme.onPrimary,
                            ),
                            FxSpacing.width(4),
                            FxText.bodySmall(
                              "${controller.house.ward.name}, ${controller.house.ward.district.name}",
                              xMuted: true,
                              color: controller.theme.colorScheme.onPrimary,
                            ),
                          ],
                        ),
                        FxSpacing.height(8),
                        Row(
                          children: [
                            Expanded(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.streetview,
                                    size: 16,
                                    color:
                                        controller.theme.colorScheme.onPrimary,
                                  ),
                                  FxSpacing.width(4),
                                  FxText.bodySmall(
                                    "${controller.house.ward.district.region.name}",
                                    xMuted: true,
                                    color:
                                        controller.theme.colorScheme.onPrimary,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        FxSpacing.height(8),
                        Row(
                          children: [
                            Expanded(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.category,
                                    size: 16,
                                    color:
                                        controller.theme.colorScheme.onPrimary,
                                  ),
                                  FxSpacing.width(4),
                                  FxText.bodySmall(
                                    controller.house.subcategory.name,
                                    xMuted: true,
                                    color:
                                        controller.theme.colorScheme.onPrimary,
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.type_specimen,
                                    size: 16,
                                    color:
                                        controller.theme.colorScheme.onPrimary,
                                  ),
                                  FxSpacing.width(4),
                                  FxText.bodySmall(
                                    controller.house.subcategory.category.name,
                                    xMuted: true,
                                    color:
                                        controller.theme.colorScheme.onPrimary,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        FxSpacing.height(20),
                        FxText.bodyLarge(
                          'Description',
                          fontWeight: 700,
                          color: controller.theme.colorScheme.onPrimary,
                        ),
                        FxSpacing.height(8),
                        RichText(
                          text: TextSpan(children: <TextSpan>[
                            TextSpan(
                                text: controller
                                    .house.description.capitalizeFirst,
                                style: FxTextStyle.bodyMedium(
                                  color: controller.theme.colorScheme.onPrimary,
                                  xMuted: true,
                                  height: 1.5,
                                )),
                            // TextSpan(
                            //   text: " Read more",
                            //   style: FxTextStyle.bodyMedium(
                            //     color: controller.theme.colorScheme.secondary,
                            //   ),
                            // ),
                          ]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            FxSpacing.height(16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FxButton.medium(
                  onPressed: () {
                    var phone =
                        controller.house.user.phone.replaceRange(0, 3, "0");

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
                FxButton.medium(
                  onPressed: () {
                    controller.favoriteProduct(controller.house.id.toString());
                  },
                  child: FxText.bodyMedium(
                    'Add to favorite',
                    color: controller.theme.colorScheme.onPrimary,
                    fontWeight: 700,
                  ),
                  backgroundColor: controller.theme.colorScheme.error,
                  borderRadiusAll: Constant.containerRadius.large,
                  elevation: 0,
                ),
              ],
            ),
            FxSpacing.height(16),
          ],
        ),
      );
    }
  }
}
