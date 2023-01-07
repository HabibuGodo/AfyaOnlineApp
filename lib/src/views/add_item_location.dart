import 'dart:developer';

import 'package:flutkit/src/models/regions_model.dart';
import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';

import '../../../theme/constant.dart';
import '../controllers/add_item_controller.dart';

class AddItemLocationScreen extends GetView<AddItemController> {
  const AddItemLocationScreen({key});
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
              'Fill Item Location',
              fontWeight: 700,
              color: controller.theme.colorScheme.primary,
            ),
            FxSpacing.height(30),
            Form(
              key: controller.addItemLocationKey.value,
              child: Column(
                children: [
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
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      child: DropdownButtonFormField<RegionModel>(
                        dropdownColor: Colors.white,
                        decoration: InputDecoration(
                          hintText: "Region",
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: controller.theme.primaryColor),
                          ),
                        ),
                        isExpanded: true,
                        items: controller.regionsList.map((item) {
                          return DropdownMenuItem<RegionModel>(
                            value: item,
                            child: Text(item.name.toUpperCase()),
                          );
                        }).toList(),
                        onChanged: (RegionModel? region) {
                          // controller.selectedDistrictIndex = null;
                          // controller.selectedWardIndex = null;
                          // controller.districtList.clear();

                          // controller.districtList = controller
                          //     .regionsList[int.parse(value.toString()) - 1]
                          //     .districts
                          //     .where((i) => i.regionId == int.parse(value!))
                          //     .toList()
                          //     .obs;

                          controller.selectedRegion(region: region!);
                        },
                      ),
                    ),
                  ),
                  controller.districtList.isNotEmpty
                      ? FxSpacing.height(20)
                      : Container(),
                  controller.districtList.isNotEmpty
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
                            child: DropdownButtonFormField<DistrictModel>(
                              dropdownColor: Colors.white,
                              decoration: InputDecoration(
                                hintText: "District",
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: controller.theme.primaryColor),
                                ),
                              ),
                              isExpanded: true,
                              items: controller.districtList.map((item) {
                                return DropdownMenuItem<DistrictModel>(
                                  value: item,
                                  child: Text(item.name.toUpperCase()),
                                );
                              }).toList(),
                              onChanged: (DistrictModel? district) {
                                controller.selectedDistrict(
                                    district: district!);
                              },
                              // validator: (value) =>
                              //     controller.validateModule(value.toString()),
                            ),
                          ),
                        )
                      : Container(),
                  controller.wardList.isNotEmpty
                      ? FxSpacing.height(20)
                      : Container(),
                  controller.wardList.isNotEmpty
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
                                hintText: "Ward",
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: controller.theme.primaryColor),
                                ),
                              ),
                              isExpanded: true,
                              value: controller.ward.value,
                              items: controller.wardList.map((item) {
                                return DropdownMenuItem<String>(
                                  value: item.id,
                                  child: Text(item.name.toUpperCase()),
                                );
                              }).toList(),
                              onChanged: (String? value) {
                                controller.ward.value = value!;
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please select ward";
                                }
                                return null;
                              },
                              onSaved: (String? value) =>
                                  controller.ward.value = value!.toString(),
                            ),
                          ),
                        )
                      : Container(),
                  controller.wardList.isNotEmpty
                      ? FxSpacing.height(20)
                      : Container(),
                  controller.wardList.isNotEmpty
                      ? TextFormField(
                          style: FxTextStyle.bodyMedium(),
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              filled: true,
                              isDense: true,
                              fillColor: controller.theme.primaryColor
                                  .withOpacity(0.4),
                              hintText: "Street",
                              enabledBorder: controller.outlineInputBorder,
                              focusedBorder: controller.outlineInputBorder,
                              border: controller.outlineInputBorder,
                              contentPadding: FxSpacing.all(16),
                              hintStyle: FxTextStyle.bodyMedium(),
                              isCollapsed: true),
                          maxLines: 1,
                          controller: controller.streetTE,
                          validator: controller.validateStreet,
                          cursorColor:
                              controller.theme.colorScheme.onBackground,
                          onSaved: (value) {
                            controller.street.value = value.toString();
                          },
                        )
                      : Container(),
                  FxSpacing.height(20),
                ],
              ),
            ),
            FxSpacing.height(20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FxButton.medium(
                  elevation: 0,
                  borderRadiusAll: Constant.buttonRadius.large,
                  onPressed: () {
                    Get.back();
                  },
                  splashColor:
                      controller.theme.colorScheme.onPrimary.withAlpha(30),
                  backgroundColor: controller.theme.colorScheme.primary,
                  child: FxText.labelLarge(
                    "Back",
                    color: controller.theme.colorScheme.onPrimary,
                  ),
                ),
                FxButton.medium(
                  elevation: 0,
                  borderRadiusAll: Constant.buttonRadius.large,
                  onPressed: () {
                    controller.checkValidation2();
                    if (controller.validated2.value == true) {
                      Get.toNamed('/add_item_images');
                      controller.validated2.value = true;
                    }
                  },
                  splashColor:
                      controller.theme.colorScheme.onPrimary.withAlpha(30),
                  backgroundColor: controller.theme.colorScheme.primary,
                  child: FxText.labelLarge(
                    "Continue",
                    color: controller.theme.colorScheme.onPrimary,
                  ),
                ),
              ],
            ),
            FxSpacing.height(16),
          ],
        ),
      ),
    );
  }
}
