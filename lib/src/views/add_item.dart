import 'package:flutkit/src/models/categories_model.dart';
import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';

import '../../../theme/constant.dart';
import '../controllers/add_item_controller.dart';

class AddItemScreen extends GetView<AddItemController> {
  const AddItemScreen({key});

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  Widget _buildBody() {
    return Obx(
      () => Scaffold(
        body: ListView(
          padding: FxSpacing.fromLTRB(
              20, FxSpacing.safeAreaTop(Get.context!) + 36, 20, 20),
          children: [
            FxText.displaySmall(
              'Fill Item Details',
              fontWeight: 700,
              color: controller.theme.colorScheme.primary,
            ),
            FxSpacing.height(30),
            Form(
              key: controller.addItemKey.value,
              child: Column(
                children: [
                  FxSpacing.height(20),
                  Container(
                    decoration: BoxDecoration(
                      color: controller.theme.primaryColor.withOpacity(0.5),
                      border: Border.all(
                        width: 1,
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      child: DropdownButtonFormField<AllCategoryModel>(
                        dropdownColor: Colors.white,
                        decoration: InputDecoration(
                          hintText: "Category",
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: controller.theme.colorScheme.onPrimary),
                          ),
                        ),
                        isExpanded: true,
                        items: controller.categoriesList.map((item) {
                          return DropdownMenuItem<AllCategoryModel>(
                            value: item,
                            child: Text(item.name.toUpperCase()),
                          );
                        }).toList(),
                        onChanged: (AllCategoryModel? category) {
                          controller.subCategory.value = '';
                          controller.selectedCategory(category: category!);

                          // log("OLDDD ${controller.subCategory.value.toString()}");
                        },
                      ),
                    ),
                  ),
                  controller.subcategoryList.isNotEmpty
                      ? FxSpacing.height(20)
                      : Container(),
                  controller.subcategoryList.isNotEmpty
                      ? Container(
                          decoration: BoxDecoration(
                            color:
                                controller.theme.primaryColor.withOpacity(0.4),
                            border: Border.all(
                              width: 1,
                              color: Colors.white,
                            ),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 15),
                            child: DropdownButtonFormField<String>(
                              dropdownColor: Colors.white,
                              decoration: InputDecoration(
                                hintText: "Subcategory",
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: controller.theme.primaryColor
                                        ..withOpacity(0.4)),
                                ),
                              ),
                              isExpanded: true,
                              items:
                                  controller.subcategoryList.value.map((item) {
                                return DropdownMenuItem<String>(
                                  value: item.id.toString(),
                                  child: Text(item.name.toUpperCase()),
                                );
                              }).toList(),
                              value: controller.subCategory.value,
                              onChanged: (String? value) {
                                controller.subCategory.value = value!;
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please select a subcategory";
                                }
                                return null;
                              },
                              onSaved: (newValue) =>
                                  controller.subCategory.value = newValue!,
                            ),
                          ),
                        )
                      : Container(),
                  FxSpacing.height(20),
                  TextFormField(
                    style: FxTextStyle.bodyMedium(),
                    decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        isDense: true,
                        filled: true,
                        fillColor:
                            controller.theme.primaryColor.withOpacity(0.4),
                        hintText: "Item Title",
                        enabledBorder: controller.outlineInputBorder,
                        focusedBorder: controller.outlineInputBorder,
                        border: controller.outlineInputBorder,
                        contentPadding: FxSpacing.all(16),
                        hintStyle: FxTextStyle.bodyMedium(),
                        isCollapsed: true),
                    maxLines: 1,
                    controller: controller.titleTE,
                    validator: controller.validateTitle,
                    cursorColor: controller.theme.colorScheme.onBackground,
                    onSaved: (value) {
                      controller.itemTitle.value = value.toString();
                    },
                  ),
                  FxSpacing.height(20),
                  TextFormField(
                    style: FxTextStyle.bodyMedium(),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        isDense: true,
                        filled: true,
                        fillColor:
                            controller.theme.primaryColor.withOpacity(0.4),
                        hintText: "Price",
                        enabledBorder: controller.outlineInputBorder,
                        focusedBorder: controller.outlineInputBorder,
                        border: controller.outlineInputBorder,
                        contentPadding: FxSpacing.all(16),
                        hintStyle: FxTextStyle.bodyMedium(),
                        isCollapsed: true),
                    maxLines: 1,
                    controller: controller.priceTE,
                    validator: controller.validatePrice,
                    cursorColor: controller.theme.colorScheme.onBackground,
                    onSaved: (value) {
                      controller.price.value = int.parse(value.toString());
                    },
                  ),
                  FxSpacing.height(20),
                  TextFormField(
                    style: FxTextStyle.bodyMedium(),
                    decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        isDense: true,
                        filled: true,
                        fillColor:
                            controller.theme.primaryColor.withOpacity(0.4),
                        hintText: "Description",
                        enabledBorder: controller.outlineInputBorder,
                        focusedBorder: controller.outlineInputBorder,
                        border: controller.outlineInputBorder,
                        contentPadding: FxSpacing.all(16),
                        hintStyle: FxTextStyle.bodyMedium(),
                        isCollapsed: true),
                    maxLines: 5,
                    keyboardType: TextInputType.text,
                    controller: controller.descriptionTE,
                    cursorColor: controller.theme.colorScheme.onBackground,
                    validator: (value) => controller.validateDescription(value),
                    onSaved: (value) {
                      controller.description.value = value.toString();
                    },
                  ),
                ],
              ),
            ),
            FxSpacing.height(20),
            Container(
              decoration: BoxDecoration(
                color: controller.theme.primaryColor.withOpacity(0.4),
                border: Border.all(
                  width: 1,
                  color: Colors.white,
                ),
                borderRadius: BorderRadius.circular(18),
              ),
              child: DropdownButtonFormField(
                dropdownColor: Colors.white,
                decoration: InputDecoration(
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  hintText: "Select Item Type ",
                  filled: true,
                  prefixIcon: Icon(Icons.card_membership),
                ),
                isExpanded: true,
                items: [
                  DropdownMenuItem(
                    child: Text(
                      "Normal",
                      style: FxTextStyle.bodyMedium(),
                    ),
                    value: "Normal",
                  ),
                  DropdownMenuItem(
                    child: Text(
                      "Gold",
                      style: FxTextStyle.bodyMedium(),
                    ),
                    value: "Gold",
                  ),
                  DropdownMenuItem(
                    child: Text(
                      "Diamond",
                      style: FxTextStyle.bodyMedium(),
                    ),
                    value: "Diamond",
                  ),
                ],
                onChanged: (String? value) {
                  controller.itemType.value = value!.toString();
                },
                validator: (value) =>
                    controller.validateItemType(value.toString()),
                onSaved: (newValue) =>
                    controller.itemType.value = newValue!.toString(),
              ),
            ),
            FxSpacing.height(10),

            controller.itemType.value == '' &&
                    controller.firstTime.value == false
                ? Container(
                    margin: EdgeInsets.only(left: 15),
                    child: Text(
                      "You must select item type",
                      style: TextStyle(color: Colors.red),
                    ),
                  )
                : Container(),

            // TextFormField(
            //         style: FxTextStyle.bodyMedium(),
            //         decoration: InputDecoration(
            //             floatingLabelBehavior: FloatingLabelBehavior.never,
            //             filled: true,
            //             isDense: true,
            //             fillColor:
            //                 controller.theme.primaryColor,
            //             // prefixIcon: Icon(
            //             //   FeatherIcons.di,
            //             //   color: theme.colorScheme.onBackground,
            //             // ),
            //             hintText: "Id Number",
            //             enabledBorder: controller.outlineInputBorder,
            //             focusedBorder: controller.outlineInputBorder,
            //             border: controller.outlineInputBorder,
            //             contentPadding: FxSpacing.all(16),
            //             hintStyle: FxTextStyle.bodyMedium(),
            //             isCollapsed: true),
            //         maxLines: 1,
            //         controller: controller.idNumberTE,
            //         cursorColor: controller.theme.colorScheme.onBackground,
            //         validator: controller.validateIdNumber,
            //         onSaved: (value) {
            //           controller.idNumber.value = value.toString();
            //         },
            //       ),

            FxSpacing.height(20),
            FxButton.block(
              elevation: 0,
              borderRadiusAll: Constant.buttonRadius.large,
              onPressed: () {
                controller.checkValidation1();
                if (controller.validated1.value == true) {
                  Get.toNamed('/add_item_location');
                  // controller.postPhoneNumber();
                  controller.validated1.value = true;
                }
              },
              splashColor: controller.theme.colorScheme.onPrimary.withAlpha(30),
              backgroundColor: controller.theme.colorScheme.primary,
              child: FxText.labelLarge(
                "Continue",
                color: controller.theme.colorScheme.onPrimary,
              ),
            ),
            FxSpacing.height(16),
          ],
        ),
      ),
    );
  }
}
