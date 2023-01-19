import 'dart:convert' as convert;
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:flutkit/src/models/newsfeed_model.dart';
import 'package:flutkit/src/services/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:image_pickers/image_pickers.dart';

import '../../theme/app_theme.dart';
import '../../theme/constant.dart';
import '../services/base_service.dart';

class AddINewsController extends GetxController {
  final addItemKey = GlobalKey<FormState>().obs;

  var showLoading = true.obs, uiLoading = true.obs;

  late TextEditingController titleTE, descriptionTE;

  var newsFeeds = <NewsFeedModel>[].obs;

  var listImagePaths = <Media>[].obs;

  late ThemeData theme;
  late OutlineInputBorder outlineInputBorder;
  var myPhoto1 = ''.obs;
  var newsTitle = ''.obs;
  var description = ''.obs;

  var notesFile = " ".obs;
  var fileSize = ''.obs;

  var validated1 = false.obs;

  @override
  void onInit() {
    notesFile.value = "";
    titleTE = TextEditingController();
    descriptionTE = TextEditingController();

    theme = AppTheme.communityTBTheme;
    outlineInputBorder = OutlineInputBorder(
      borderRadius:
          BorderRadius.all(Radius.circular(Constant.textFieldRadius.medium)),
      borderSide: BorderSide(
        color: Colors.transparent,
      ),
    );
    getNewsFeeds();
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
    titleTE.dispose();
    descriptionTE.dispose();
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

  void checkValidation1() async {
    final isValid = addItemKey.value.currentState!.validate();
    if (!isValid) {
      print('Form has Errors....');
    } else {
      addItemKey.value.currentState!.save();
      validated1.value = true;
    }
  }

  // pick file from device
  Future<void> pickFile() async {
    // ask for permission
    FilePickerResult? file = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'pdf',
        'doc',
        'docx',
        'ppt',
        'pptx',
        'txt',
        'xls',
        'xlsx'
      ],
    );
    // check file extension
    if (file != null) {
      // check file allowedExtensions is pdf, xls, xlsx, doc, docx
      if (file.files.single.extension != 'pdf' &&
          file.files.single.extension != 'doc' &&
          file.files.single.extension != 'docx' &&
          file.files.single.extension != 'ppt' &&
          file.files.single.extension != 'pptx' &&
          file.files.single.extension != 'txt' &&
          file.files.single.extension != 'xls' &&
          file.files.single.extension != 'xlsx') {
        Get.snackbar('Error', 'File type not allowed',
            backgroundColor: Colors.red,
            colorText: theme.colorScheme.onPrimary,
            snackPosition: SnackPosition.TOP);
      } else {
        // file size in KB
        var size = file.files.single.size / 1024;
        // file size in MB
        var sizeInMB = (size / 1024);

        if (sizeInMB > 10) {
          Get.snackbar('File size', 'File size should be less than 5MB',
              backgroundColor: Colors.red,
              colorText: theme.colorScheme.onPrimary,
              snackPosition: SnackPosition.TOP);
        } else {
          notesFile.value = file.files.single.path.toString();
        }
        // convers double to string
        fileSize = (sizeInMB).toStringAsFixed(2).obs;
      }
    } else {
      Get.snackbar('Not Attached', 'You have not Selected any File',
          snackPosition: SnackPosition.TOP);
    }
    // notesFile.value = file.path;
  }

  // fetch all News feed
  Future<void> getNewsFeeds() async {
    try {
      Dio dio = Dio();
      DioCacheManager _dioCacheManager = DioCacheManager(CacheConfig());
      Options cacheOptions = buildCacheOptions(Duration(days: 30),
          forceRefresh: true,
          options: Options(extra: {"context": "all_newsfeed"}));
      dio.options.headers["Content-Type"] = 'application/json';
      dio.interceptors.add(_dioCacheManager.interceptor);

      var response = await dio.get("$baseURL/newsfeed", options: cacheOptions);

      if (response.statusCode == 200) {
        List<dynamic> dataEx = response.data['data'];

        newsFeeds.value =
            (dataEx).map((e) => NewsFeedModel.fromMap(e)).toList().obs;
      } else {
        return;
      }
    } catch (e) {
      print(e);
    } finally {
      showLoading.value = false;
      uiLoading.value = false;
    }
  }

  Future<void> postNews() async {
    try {
      var request =
          http.MultipartRequest('POST', Uri.parse('$baseURL/createFeed'));
      request.fields['title'] = newsTitle.value;
      request.fields['description'] = description.value.toString();
      request.fields['userId'] = authData.read('user_id').toString();
      request.fields['image'] = myPhoto1.value;
      request.fields['file'] = notesFile.value;
      request.headers['Accept'] = 'application/json';

      if (myPhoto1.value != '') {
        final File _file = File(myPhoto1.value);
        request.files.add(
          http.MultipartFile(
            'image',
            _file.readAsBytes().asStream(),
            _file.lengthSync(),
            filename: _file.path.split('/').last,
          ),
        );
      } else {}

      if (notesFile.value != '') {
        final File attachment = File(notesFile.value);

        request.files.add(http.MultipartFile(
          'file',
          attachment.readAsBytes().asStream(),
          attachment.lengthSync(),
          filename: attachment.path.split('/').last,
        ));
      }

      var response = await request.send();
      var data = await http.Response.fromStream(response);

      if (response.statusCode == 200) {
        var jsonResponse = convert.jsonDecode(data.body);

        // snackbar
        Get.snackbar('Posted!', 'Successfully Posted News Feed!',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            icon: Icon(
              Icons.check_circle,
              color: Colors.white,
            ));
        getNewsFeeds();
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
            myPhoto1.value = media.path!;
            log(myPhoto1.value);
          });
          Get.back();
        }
      } else {
        Get.snackbar('Error', 'No image selected');
      }
    } on PlatformException {}
  }
}
