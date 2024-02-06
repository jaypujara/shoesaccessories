import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shoes_acces/Network/ApiUrls.dart';
import 'package:shoes_acces/utils/methods.dart';
import 'package:shoes_acces/widgets/Widgets.dart';

import '../../../Network/API.dart';
import '../../../utils/ColorConstants.dart';
import '../../../utils/Strings.dart';
import '../../users/dashboard/model/CategoryResponseModel.dart';

class AddCategoryController extends GetxController {
  final Rx<GlobalKey<FormState>> keyForm = GlobalKey<FormState>().obs;
  final TextEditingController controllerName = TextEditingController();
  RxBool isLoading = false.obs;
  File? image;

  CategoryModel? editModel;
  bool isForUpdate = false;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      isForUpdate = true;
      editModel = Get.arguments;
      controllerName.text = editModel!.catName ?? "";
      update();
    }
  }

  pickImageFromCamera() async {
    Get.back();
    final ImagePicker picker = ImagePicker();
    final XFile? img = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 10,
    );
    if (img != null) {
      print(img.path);
      image = File(img.path);
      update();
    }
  }

  pickImageFromGallery() async {
    Get.back();
    final ImagePicker picker = ImagePicker();
    XFile? img = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 10,
    );
    if (img != null) {
      print(img.path);
      image = File(img.path);
      update();
    }
  }

  onSaveOrUpdate() async {
    log("SAVE");

    if (isForUpdate) {
      if (keyForm.value.currentState != null &&
          keyForm.value.currentState!.validate()) {
        await updateCategory(controllerName.text);
        if (image != null) {
          updateImage(image!.path);
        }
      }
    } else {
      if (keyForm.value.currentState != null &&
          keyForm.value.currentState!.validate() &&
          image != null) {
        save(controllerName.text, image!.path);
      } else if (image == null) {
        showSnackBarWithText(Get.context, "Please select Image first!");
      }
    }
  }

  save(String name, String imagePath) async {
    try {
      isLoading.trigger(true);
      getOverlay();
      var postUri = getUrl(endCategorySave);
      var request = http.MultipartRequest("POST", postUri);
      request.fields['Cat_Id'] = '0';
      request.fields['Cat_Name'] = name;
      request.files
          .add(await http.MultipartFile.fromPath('FileName', imagePath));
      await request.send().then((response) {
        if (response.statusCode == 200) {
          print("SUCCESS");
          showSnackBarWithText(Get.context, "Category Added Successfully.",
              color: colorGreen);
          Get.back(result: true);
        } else {
          showSnackBarWithText(
              Get.context, response.reasonPhrase ?? "Image upload failed!");
        }
      });
    } catch (e) {
      print(e);
    } finally {
      isLoading.trigger(false);
      removeOverlay();
    }
  }

  updateCategory(String name) async {
    HttpRequestModel request = HttpRequestModel(
        url: endCategoryUpdate,
        authMethod: '',
        body: '',
        headerType: '',
        params: json.encode({
          "Cat_Id": editModel!.catId,
          "Cat_Name": name,
        }).toString(),
        method: 'POST');

    try {
      getOverlay();
      String response = await HttpService().init(request);
      if (response.isNotEmpty) {
        var responseJson = jsonDecode(response);
        if (responseJson["Status"] == "1") {
          showSnackBarWithText(Get.context, responseJson["Message"],
              color: colorGreen);
          removeOverlay();
          if (image == null) {
            Get.back(result: true);
          }
        } else {
          showSnackBarWithText(Get.context, responseJson["Message"]);
        }
      } else {
        showSnackBarWithText(Get.context, stringSomeThingWentWrong);
      }
    } catch (e) {
      log("ERROR: $endProductDelete ${e.toString()}");
      showSnackBarWithText(Get.context, stringSomeThingWentWrong);
    } finally {
      removeOverlay();
    }
  }

  updateImage(String imagePath) async {
    try {
      isLoading.trigger(true);
      getOverlay();
      var postUri = getUrl(endCategoryImageUpload);
      var request = http.MultipartRequest("POST", postUri);
      request.fields['Cat_Id'] = editModel!.catId ?? "";
      request.files
          .add(await http.MultipartFile.fromPath('FileName', imagePath));
      await request.send().then((response) async {
        if (response.statusCode == 200) {
          print("SUCCESS");
          showSnackBarWithText(Get.context, "Image Updated Successfully.",
              color: colorGreen);
          await CachedNetworkImage.evictFromCache(editModel!.imagePath ?? "");
          Get.back(result: true);
        } else {
          showSnackBarWithText(
              Get.context, response.reasonPhrase ?? "Image upload failed!");
        }
      });
    } catch (e) {
      print(e);
    } finally {
      isLoading.trigger(false);
      removeOverlay();
    }
  }
}
