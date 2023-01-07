// MyFavorite

import 'package:flutkit/src/models/items_model.dart';
import 'package:flutkit/src/services/base_service.dart';
import 'package:flutkit/theme/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:flutkit/loading_effect.dart';
import 'package:flutkit/theme/app_theme.dart';
import 'package:get/get.dart';

import '../controllers/my_favorite_controller.dart';
import '../models/category.dart';
import '../models/favorite_model.dart';
import '../services/local_storage.dart';

class MyFavorite extends GetView<MyFavoriteController> {
  MyFavorite({Key? key}) : super(key: key);

  // List<Widget> _buildCategoryList() {
  //   List<Widget> list = [];
  //   list.add(FxSpacing.width(24));

  //   for (Category category in controller.categories) {
  //     list.add(_buildSingleCategory(category));
  //   }
  //   return list;
  // }

  // List<Widget> _buildFilterCategoryList() {
  //   List<Widget> list = [];
  //   list.add(FxSpacing.width(24));
  //   for (Category category in controller.categories) {
  //     list.add(_buildFilterCategory(category));
  //   }
  //   return list;
  // }

  List<Widget> _buildHouseList() {
    List<Widget> list = [];
    list.add(FxSpacing.width(24));
    if (controller.favorite.isEmpty) {
      return list;
    } else {
      controller.favorite.forEach((element) {
        list.add(_buildSingleHouse(element));
      });
      return list;
    }
  }

  Widget _buildSingleCategory(Category category) {
    return Container(
      margin: FxSpacing.right(16),
      child: Column(
        children: [
          FxContainer.rounded(
            color: controller.theme.primaryColor,
            child: Icon(
              category.categoryIcon,
              color: controller.theme.colorScheme.primary,
            ),
          ),
          FxSpacing.height(8),
          FxText.bodySmall(
            category.category,
            xMuted: true,
            fontSize: 12,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterCategory(Category category) {
    return FxContainer.bordered(
      paddingAll: 8,
      borderRadiusAll: Constant.containerRadius.small,
      margin: FxSpacing.right(8),
      border: Border.all(color: controller.theme.colorScheme.primary, width: 1),
      splashColor: controller.theme.primaryColor,
      color: controller.theme.primaryColor,
      child: Row(
        children: [
          Icon(
            category.categoryIcon,
            color: controller.theme.colorScheme.primary,
            size: 16,
          ),
          FxSpacing.width(8),
          FxText.bodySmall(
            category.category,
            fontWeight: 600,
            color: controller.theme.colorScheme.onPrimary,
          ),
        ],
      ),
    );
  }

  Widget _buildSingleHouse(FavoriteModel item) {
    return FxContainer(
      onTap: () {
        Get.toNamed("/single_favorite_item", arguments: {'house': item});
      },
      margin: FxSpacing.nTop(24),
      paddingAll: 0,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      borderRadiusAll: Constant.containerRadius.medium,
      child: Column(
        children: [
          Image(
            image: item.product.images.isEmpty
                ? AssetImage("assets/images/apps/estate/estate7.jpg")
                    as ImageProvider
                : //network image with host

                NetworkImage("$imageURL${item.product.images[0].url}"),
            fit: BoxFit.fitWidth,
          ),
          FxContainer(
            paddingAll: 16,
            color: controller.theme.primaryColor,
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(Constant.containerRadius.medium),
                bottomRight: Radius.circular(Constant.containerRadius.medium)),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FxText.bodyLarge(
                      item.product.name,
                      fontWeight: 700,
                      color: controller.theme.colorScheme.onPrimary,
                    ),
                    FxText.bodyMedium(
                      "\Tsh" + item.product.price.toString(),
                      fontWeight: 600,
                      color: controller.theme.colorScheme.secondary,
                    ),
                  ],
                ),
                FxSpacing.height(4),
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 16,
                      color: controller.theme.colorScheme.onPrimary,
                    ),
                    FxSpacing.width(4),
                    FxText.bodySmall(
                        "${item.product.ward.name}, ${item.product.ward.district.name}",
                        xMuted: true,
                        color: controller.theme.colorScheme.onPrimary),
                  ],
                ),
                FxSpacing.height(8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.streetview,
                            size: 16,
                            color: controller.theme.colorScheme.onPrimary,
                          ),
                          FxSpacing.width(4),
                          FxText.bodySmall(
                            item.product.ward.district.region.name,
                            xMuted: true,
                            color: controller.theme.colorScheme.onPrimary,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                FxSpacing.height(8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.category,
                            size: 16,
                            color: controller.theme.colorScheme.onPrimary,
                          ),
                          FxSpacing.width(4),
                          FxText.bodySmall(
                            item.product.subcategory.name,
                            xMuted: true,
                            color: controller.theme.colorScheme.onPrimary,
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
                            color: controller.theme.colorScheme.onPrimary,
                          ),
                          FxSpacing.width(4),
                          FxText.bodySmall(
                            item.product.subcategory.category.name,
                            xMuted: true,
                            color: controller.theme.colorScheme.onPrimary,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
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
          body: Container(
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

          // floating action button
          floatingActionButton: authData.read("role") == "Mteja"
              ? Container()
              : FloatingActionButton(
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
                      fontSize: 16,
                    ),
                    FxSpacing.height(4),
                    Row(
                      children: [
                        Icon(
                          Icons.person,
                          color: controller.theme.colorScheme.primary,
                          size: 18,
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
          // Padding(
          //   padding: FxSpacing.horizontal(24),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       FxText.bodyLarge(
          //         'Recommended',
          //         fontWeight: 600,
          //       ),
          //       FxText.bodySmall(
          //         'More',
          //         xMuted: true,
          //       ),
          //     ],
          //   ),
          // ),
          // FxSpacing.height(16),
          controller.favorite.length == 0
              ? Container(
                  margin: FxSpacing.top(200),
                  child: Center(
                    child: FxText.sh1(
                      "You don't have any favorite item",
                      color: controller.theme.colorScheme.onBackground,
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : Column(
                  children: _buildHouseList(),
                ),
        ],
      );
    }
  }

  void _selectSizeSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext buildContext) {
          return StatefulBuilder(
            builder: (BuildContext context,
                void Function(void Function()) setState) {
              return FxContainer(
                padding: FxSpacing.top(24),
                child: ListView(
                  children: <Widget>[
                    Padding(
                      padding: FxSpacing.horizontal(24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          FxContainer.rounded(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            paddingAll: 6,
                            color: controller.theme.colorScheme.secondary,
                            child: Icon(
                              Icons.close,
                              size: 16,
                              color: controller
                                  .theme.colorScheme.secondaryContainer,
                            ),
                          ),
                          FxText.bodyMedium(
                            'Filters',
                            fontWeight: 600,
                          ),
                          FxText.bodySmall(
                            'Reset',
                            color: controller.theme.colorScheme.primary,
                          ),
                        ],
                      ),
                    ),
                    FxSpacing.height(8),
                    Padding(
                      padding: FxSpacing.horizontal(24),
                      child: FxText.bodyMedium(
                        'Category',
                        fontWeight: 700,
                      ),
                    ),
                    FxSpacing.height(8),
                    // SingleChildScrollView(
                    //   scrollDirection: Axis.horizontal,
                    //   child: Row(
                    //     children: _buildFilterCategoryList(),
                    //   ),
                    // ),
                    FxSpacing.height(16),
                    Padding(
                      padding: FxSpacing.horizontal(24),
                      child: FxText.bodyMedium(
                        'Price Range ( ' +
                            '${controller.selectedRange.value.toString()} - ' +
                            '${controller.selectedRange.value.toString()} )',
                        fontWeight: 700,
                      ),
                    ),
                    RangeSlider(
                        activeColor: controller.theme.colorScheme.primary,
                        inactiveColor:
                            controller.theme.colorScheme.primary.withAlpha(100),
                        max: 10000,
                        min: 0,
                        values: controller.selectedRange.value,
                        onChanged: (RangeValues newRange) {
                          setState(
                              () => controller.selectedRange.value = newRange);
                        }),
                    // Padding(
                    //   padding: FxSpacing.horizontal(24),
                    //   child: FxText.bodyMedium(
                    //     'Bed Rooms',
                    //     fontWeight: 700,
                    //   ),
                    // ),
                    // FxSpacing.height(8),
                    // SingleChildScrollView(
                    //   padding: FxSpacing.x(24),
                    //   scrollDirection: Axis.horizontal,
                    //   child: Row(
                    //       children:
                    //           ['Any', '1', '2', '3', '4', '5'].map((element) {
                    //     return InkWell(
                    //         onTap: () {
                    //           setState(() {
                    //             if (controller.selectedBedRooms
                    //                 .contains(element)) {
                    //               controller.selectedBedRooms.remove(element);
                    //             } else {
                    //               controller.selectedBedRooms.add(element);
                    //             }
                    //           });
                    //         },
                    //         child: SingleBed(
                    //           bed: element,
                    //           selected:
                    //               controller.selectedBedRooms.contains(element),
                    //         ));
                    //   }).toList()),
                    // ),
                    FxSpacing.height(16),
                    // Padding(
                    //   padding: FxSpacing.horizontal(24),
                    //   child: FxText.bodyMedium(
                    //     'Bath Rooms',
                    //     fontWeight: 700,
                    //   ),
                    // ),
                    // FxSpacing.height(8),
                    // SingleChildScrollView(
                    //   padding: FxSpacing.x(24),
                    //   scrollDirection: Axis.horizontal,
                    //   child: Row(
                    //       children:
                    //           ['Any', '1', '2', '3', '4', '5'].map((element) {
                    //     return InkWell(
                    //         onTap: () {
                    //           setState(() {
                    //             if (controller.selectedBathRooms
                    //                 .contains(element)) {
                    //               controller.selectedBathRooms.remove(element);
                    //             } else {
                    //               controller.selectedBathRooms.add(element);
                    //             }
                    //           });
                    //         },
                    //         child: SingleBath(
                    //           bath: element,
                    //           selected: controller.selectedBathRooms
                    //               .contains(element),
                    //         ));
                    //   }).toList()),
                    // ),
                    // FxSpacing.height(16),
                    Padding(
                      padding: FxSpacing.horizontal(24),
                      child: FxButton.block(
                        borderRadiusAll: 8,
                        elevation: 0,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        backgroundColor: controller.theme.colorScheme.primary,
                        child: FxText.titleSmall(
                          "Apply Filters",
                          fontWeight: 700,
                          color: controller.theme.colorScheme.onPrimary,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ),
                    FxSpacing.height(16),
                  ],
                ),
              );
            },
          );
        });
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
    theme = AppTheme.reconSpotTheme;
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
    theme = AppTheme.reconSpotTheme;
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
