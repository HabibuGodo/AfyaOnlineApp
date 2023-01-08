import 'dart:convert' as convert;
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:flutkit/src/models/regions_model.dart';
import 'package:flutkit/src/services/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
// import 'package:image_cropper/image_cropper.dart';
import 'package:image_pickers/image_pickers.dart';

import '../../theme/app_theme.dart';
import '../../theme/constant.dart';
import '../models/categories_model.dart';
import '../models/items_model.dart';
import '../models/uploadImageModel.dart';
import '../services/base_service.dart';

class AddItemController extends GetxController {
  final addItemKey = GlobalKey<FormState>().obs;
  final addItemLocationKey = GlobalKey<FormState>().obs;
  final addItemImagesKey = GlobalKey<FormState>().obs;
  var showLoading = true.obs, uiLoading = true.obs;

  late TextEditingController titleTE,
      regionTE,
      streetTE,
      descriptionTE,
      priceTE;
  var regionsList = <RegionModel>[].obs;
  var districtList = <DistrictModel>[].obs;
  var wardList = <WardModel>[].obs;
  var subcategoryList = <Subcategory2>[].obs;
  var imageList = <UploadedImage>[].obs;

  var items = <ItemsModel>[].obs;
  List selectedBedRooms = [].obs;
  List selectedBathRooms = [].obs;

  var listImagePaths = <Media>[].obs;

  var selectedRegionIndex;
  var selectedDistrictIndex;
  var selectedWardIndex;

  var categoriesList = <AllCategoryModel>[].obs;
  late ThemeData theme;
  late OutlineInputBorder outlineInputBorder;
  var myPhoto1 = ''.obs;
  var myPhoto2 = ''.obs;
  var myPhoto3 = ''.obs;
  var myPhoto4 = ''.obs;

  var itemTitle = ''.obs;
  var price = 0.obs;
  var street = ''.obs;
  var itemType = ''.obs;
  var description = ''.obs;
  var region = ''.obs;
  var district = DistrictModel(name: '', id: '', regionId: '', wards: []).obs;
  var ward = ''.obs;
  var subCategory = ''.obs;

  var validated1 = false.obs;
  var validated2 = false.obs;
  var validated3 = false.obs;
  var firstTime = true.obs;

  @override
  void onInit() {
    titleTE = TextEditingController();
    regionTE = TextEditingController();
    streetTE = TextEditingController();
    descriptionTE = TextEditingController();
    priceTE = TextEditingController();
    theme = AppTheme.communityTBTheme;
    outlineInputBorder = OutlineInputBorder(
      borderRadius:
          BorderRadius.all(Radius.circular(Constant.textFieldRadius.medium)),
      borderSide: BorderSide(
        color: Colors.transparent,
      ),
    );
    getRegions();
    getCategories();
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
    titleTE.dispose();
    regionTE.dispose();
    streetTE.dispose();
    descriptionTE.dispose();
    priceTE.dispose();
  }

  String? validateDescription(String? text) {
    if (text == null || text.isEmpty) {
      return "Please enter item description";
    }
    return null;
  }

  String? validateTitle(String? text) {
    if (text == null || text.isEmpty) {
      return "Please enter item title";
    }
    return null;
  }

  String? validatePrice(var text) {
    if (text == null || text.isEmpty) {
      return "Please enter item price";
    }
    return null;
  }

  String? validateStreet(var text) {
    if (text == null || text.isEmpty) {
      return "Please enter street";
    }
    return null;
  }

  String? validateItemType(String? text) {
    if (text == null || text.isEmpty) {
      return "Please select your item type.";
    }
    return null;
  }

  void checkValidation1() async {
    final isValid = addItemKey.value.currentState!.validate();
    if (!isValid) {
      firstTime.value = false;
      print('Form has Errors....');
    } else {
      addItemKey.value.currentState!.save();

      validated1.value = true;
    }
  }

  void checkValidation2() async {
    final isValid = addItemLocationKey.value.currentState!.validate();
    if (!isValid) {
      firstTime.value = false;
      print('Form has Errors....');
    } else {
      addItemLocationKey.value.currentState!.save();

      validated2.value = true;
    }
  }

  // fetch all regions, district and wards
  Future<void> getRegions() async {
    try {
      var response = await http.get(Uri.parse("$baseURL/regions"));

      if (response.statusCode == 200) {
        var jsonResponse = convert.jsonDecode(response.body);

        regionsList.value = (jsonResponse as List)
            .map((e) => RegionModel.fromJson(e))
            .toList()
            .obs;
      } else {
        return;
      }
    } catch (e) {
      print(e);
    }
  }

  // fetch all categories
  Future<void> getCategories() async {
    try {
      Dio dio = Dio();
      DioCacheManager _dioCacheManager = DioCacheManager(CacheConfig());
      Options cacheOptions = buildCacheOptions(Duration(days: 30),
          forceRefresh: true,
          options: Options(extra: {"context": "all_categories"}));
      dio.options.headers["Authorization"] = "Bearer ${authData.read("token")}";
      dio.options.headers["Content-Type"] = 'application/json';
      dio.options.headers["Accept"] = "Bearer ${authData.read("token")}";
      dio.interceptors.add(_dioCacheManager.interceptor);

      // var response = await http.get(
      //   Uri.parse('$baseURL/category'),
      //   headers: {
      //     'Content-Type': 'application/json',
      //     'Accept': 'application/json',
      //     'Authorization': 'Bearer ${authData.read('token')}',
      //   },
      // );

      var response = await dio.get("$baseURL/category", options: cacheOptions);

      if (response.statusCode == 200) {
        var jsonResponse = response.data;

        categoriesList.value = (jsonResponse as List)
            .map((e) => AllCategoryModel.fromJson(e))
            .toList();
      } else {
        return;
      }
    } catch (e) {
      print(e);
    }
  }

  selectedCategory({required AllCategoryModel category}) {
    subCategory = "".obs;
    subcategoryList.clear();
    subcategoryList.value = category.subcategories;

    subcategoryList
        .add(Subcategory2(id: '', name: 'select subcategory', categoryId: ''));

    // var fggv = subcategoryList.reversed;
    // subcategoryList.value = fggv.toList();
  }

  selectedRegion({required RegionModel region}) {
    district.value =
        DistrictModel(id: '', name: 'select District', regionId: '', wards: []);
    districtList.clear();

    districtList.value = region.districts;

    districtList.add(DistrictModel(
        id: '', name: 'select District', regionId: '', wards: []));

    // var fggv = subcategoryList.reversed;
    // subcategoryList.value = fggv.toList();
  }

  selectedDistrict({required DistrictModel district}) {
    ward.value = '';
    wardList.clear();

    wardList.value = district.wards;

    wardList.add(WardModel(
      id: '',
      name: 'select Ward',
      districtId: '',
    ));

    // var fggv = subcategoryList.reversed;
    // subcategoryList.value = fggv.toList();
  }

  // void uploadPhoto(ImageSource imageSource, String imageNumber) async {
  //   // pick the image here
  //   final profileImage = await ImagePicker().pickImage(source: imageSource);

  //   // set the path to the image

  //   if (profileImage != null) {
  //     if (imageNumber == "1") {
  //       File? image = File(profileImage.path);

  //       myPhoto1.value = image.path;

  //       final File imageFile = File(myPhoto1.value);
  //       var img1 = await uploadImage(image: imageFile);
  //       imageList.add(img1);
  //     }
  //     if (imageNumber == "2") {
  //       // File? image = await cropImage(imagefile: File(profileImage.path));
  //       File? image = File(profileImage.path);
  //       myPhoto2.value = image.path;
  //       final File imageFile = File(myPhoto2.value);
  //       var img2 = await uploadImage(image: imageFile);
  //       log(img2.imagePath.toString());
  //       imageList.add(img2);
  //     }
  //     if (imageNumber == "3") {
  //       // File? image = await cropImage(imagefile: File(profileImage.path));
  //       File? image = File(profileImage.path);

  //       myPhoto3.value = image.path;
  //       final File imageFile = File(myPhoto3.value);

  //       var img3 = await uploadImage(image: imageFile);
  //       log(img3.imagePath.toString());

  //       imageList.add(img3);
  //     }
  //     if (imageNumber == "4") {
  //       // File? image = await cropImage(imagefile: File(profileImage.path));
  //       File? image = File(profileImage.path);

  //       myPhoto4.value = image.path;
  //       final File imageFile = File(myPhoto4.value);

  //       var img4 = await uploadImage(image: imageFile);
  //       imageList.add(img4);
  //     }

  //     Get.back();
  //   } else {
  //     // get the snackbar here
  //     Get.snackbar('Error', 'No image selected');
  //   }
  // }

  // Future<File?> cropImage({required File imagefile}) async {
  //   CroppedFile? croppedImage =
  //       await ImageCropper().cropImage(sourcePath: imagefile.path);
  //   if (croppedImage == null) return null;
  //   return File(croppedImage.path);
  // }

  Future<UploadedImage> uploadImage({required Media image}) async {
    final token = await authData.read('token');

    final headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    try {
      EasyLoading.show(
        status: 'Uploading...',
        maskType: EasyLoadingMaskType.black,
      );
      final url = Uri.parse('$baseURL/uploadDocument');

      final request = http.MultipartRequest("POST", url);

      final File _file = File(image.path!);

      request.files.add(
        http.MultipartFile(
          'file',
          _file.readAsBytes().asStream(),
          _file.lengthSync(),
          filename: _file.path.split('/').last,
        ),
      );

      request.headers.addAll(headers);

      final streamedResponse = await request.send();

      final response = await http.Response.fromStream(streamedResponse);

      if (streamedResponse.statusCode == 200) {
        EasyLoading.dismiss();
        var dta = UploadedImage.fromJson(
            convert.jsonDecode(response.body) as Map<String, dynamic>);
        return dta;
      }
      EasyLoading.dismiss();
    } catch (e) {
      print("TESTII9INH ${e.toString()}");
      EasyLoading.dismiss();
    }
    EasyLoading.dismiss();

    return UploadedImage(imagePath: '', imageUrl: '');
  }

  Future<void> postProduct() async {
    try {
      final response = await http.post(
        Uri.parse('$baseURL/product'),
        body: {
          'subcategory': subCategory.value,
          'name': itemTitle.value,
          'price': price.value.toString(),
          'ward': ward.value,
          'street': street.value,
          'status': "Active",
          'type': itemType.value.toString(),
          'description': description.value.toString(),
        },
        headers: {
          'Authorization': 'Bearer ${authData.read('token')}',
        },
      );

      if (response.statusCode == 200) {
        var jsonResponse = convert.jsonDecode(response.body);

        // imageList
        for (var i = 0; i < imageList.length; i++) {
          final imgResponse = await http.post(
            Uri.parse('$baseURL/image'),
            body: {
              'url': imageList[i].imageUrl,
              'path': imageList[i].imagePath,
              'product': jsonResponse['id'].toString(),
            },
            headers: {
              'Authorization': 'Bearer ${authData.read('token')}',
            },
          );
        }
        getItems();
        Get.offAndToNamed('/home');
        EasyLoading.dismiss();
      }
    } catch (e) {
      log("EROOOOOR ${e.toString()}");
    }
  }

  Future<void> selectImages(var mode) async {
    try {
      if (mode == "gallery") {
        listImagePaths.value = await ImagePickers.pickerPaths(
          galleryMode: GalleryMode.image,
          showGif: true,
          selectCount: 10,
          showCamera: true,
          cropConfig: CropConfig(enableCrop: true, height: 1, width: 1),
          compressSize: 500,
          uiConfig: UIConfig(
            uiThemeColor: Color(0xffff0000),
          ),
        );
      }
      if (mode == "camera") {
        ImagePickers.openCamera(
                cropConfig: CropConfig(enableCrop: true, width: 2, height: 3))
            .then((Media? media) {
          listImagePaths.clear();
          if (media != null) {
            listImagePaths.add(media);
          }
        });
      }

      if (listImagePaths.isNotEmpty) {
        if (listImagePaths.length > 0) {
          listImagePaths.forEach((media) async {
            var img4 = await uploadImage(image: media);
            imageList.add(img4);
          });
          Get.back();
        }
      } else {
        Get.snackbar('Error', 'No image selected');
      }
    } on PlatformException {}
  }

  Future<void> getItems() async {
    try {
      // categories.value = Category.categoryList();

      Dio dio = Dio();

      DioCacheManager _dioCacheManager = DioCacheManager(CacheConfig());
      Options cacheOptions = buildCacheOptions(Duration(days: 30),
          forceRefresh: true,
          options: Options(extra: {"context": "all_items"}));
      dio.options.headers["Authorization"] = "Bearer ${authData.read("token")}";
      dio.interceptors.add(_dioCacheManager.interceptor);

      showLoading.value = true;
      uiLoading.value = true;
      var response = await dio.get(
        '$baseURL/product',
        options: cacheOptions,
      );

      if (response.statusCode == 200) {
        // decode response to observable list
        var jsonResponse = response.data;

        List<dynamic> dataEx = jsonResponse;

        items.value = (dataEx).map((e) => ItemsModel.fromMap(e)).toList().obs;
        showLoading.value = false;
        uiLoading.value = false;
      } else {
        return;
      }

      // }
    } catch (e) {
      log("errrroo ${e.toString()}");
    } finally {
      showLoading.value = false;
      uiLoading.value = false;
    }
  }
}
