import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shoes_acces/Network/ApiUrls.dart';
import 'package:shoes_acces/screens/admin/dashboard/DashBoardAdminController.dart';
import 'package:shoes_acces/screens/users/dashboard/model/CategoryResponseModel.dart';
import 'package:shoes_acces/utils/ColorConstants.dart';
import 'package:shoes_acces/utils/methods.dart';
import 'package:shoes_acces/widgets/Widgets.dart';

import '../../../Network/API.dart';
import '../../../utils/Strings.dart';
import '../../users/shoeList/model/ProductResponseModel.dart';

class AddProductController extends GetxController {
  final Rx<GlobalKey<FormState>> keyForm = GlobalKey<FormState>().obs;
  final TextEditingController controllerName = TextEditingController();
  final TextEditingController controllerProductCode = TextEditingController();
  final TextEditingController controllerPrice = TextEditingController();
  final TextEditingController controllerPriceDiscount = TextEditingController();
  final TextEditingController controllerSGST = TextEditingController();
  final TextEditingController controllerCGST = TextEditingController();
  final TextEditingController controllerCourierCharges =
      TextEditingController();
  final TextEditingController controllerWeight = TextEditingController();
  CategoryModel? selectedCategory;

  RxBool isLoading = false.obs;
  File? image;

  int catId = 0;
  Product? editModel;
  bool isForUpdate = false;

  DashBoardAdminController controllerDashboard =
      Get.find(tag: "DashBoardAdminController");

  @override
  void onInit() {
    super.onInit();
    print("${controllerDashboard.categoryList.length}");
    if (Get.arguments != null) {
      isForUpdate = true;
      editModel = Get.arguments["model"];
      catId = Get.arguments["catId"];
      controllerName.text = editModel!.proName ?? "";
      controllerProductCode.text = editModel!.proCode ?? "";
      controllerPrice.text = (editModel!.proPrice ?? 0).toString();
      controllerPriceDiscount.text = (editModel!.proDiscount ?? 0).toString();
      controllerSGST.text = (editModel!.proSGST ?? 0).toString();
      controllerCGST.text = (editModel!.proCGST ?? 0).toString();
      controllerWeight.text = (editModel!.proWeight ?? 0).toString();
      controllerCourierCharges.text =
          (editModel!.proCourierCharges ?? 0).toString();
      selectedCategory = controllerDashboard.categoryList
          .where((element) => int.parse(element.catId ?? "0") == catId)
          .toList()
          .first;
      update();
    }
  }

  pickImageFromCamera() async {
    Get.back();
    final ImagePicker picker = ImagePicker();
    final XFile? img = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
    );
    if (img != null) {
      image = await sendForCrop(img.path);
      update();
    }
  }

  pickImageFromGallery() async {
    Get.back();
    final ImagePicker picker = ImagePicker();
    XFile? img = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    if (img != null) {
      image = await sendForCrop(img.path);
      update();
    }
  }

  onSave() async {
    log("SAVE");
    if (isForUpdate) {
      if (keyForm.value.currentState != null &&
          keyForm.value.currentState!.validate()) {
        await updateProduct(controllerName.text);
        if (image != null) {
          updateImage(image!.path);
        }
      }
    } else {
      if (keyForm.value.currentState != null &&
          keyForm.value.currentState!.validate() &&
          image != null) {
        save();
      } else if (image == null) {
        showSnackBarWithText(Get.context, "Please select Image first!");
      }
    }
  }

  save() async {
    try {
      isLoading.trigger(true);
      getOverlay();
      var postUri = getUrl(endProductSave);
      var request = http.MultipartRequest("POST", postUri);
      request.fields['Pro_Id'] = '0';
      request.fields['Pro_Name'] = controllerName.text.trim();
      request.fields['Pro_Code'] = controllerProductCode.text.trim();
      request.fields['Pro_Cat_Id'] = selectedCategory!.catId.toString();
      request.fields['Pro_Price'] = controllerPrice.text.trim();
      request.fields['Pro_Discount'] = controllerPriceDiscount.text.trim();
      request.fields['Pro_SGST'] = controllerSGST.text.trim();
      request.fields['Pro_CGST'] = controllerCGST.text.trim();
      request.fields['Pro_Courier_Charges'] =
          controllerCourierCharges.text.trim();
      request.fields['Pro_Weight'] = controllerWeight.text.trim();
      request.files
          .add(await http.MultipartFile.fromPath('FileName', image!.path));
      await request.send().then((response) {
        if (response.statusCode == 200) {
          print("SUCCESS");
          showSnackBarWithText(Get.context, "Product Added SuccessFully",
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

  updateProduct(String name) async {
    HttpRequestModel request = HttpRequestModel(
        url: endProductUpdate,
        authMethod: '',
        body: '',
        headerType: '',
        params: json.encode({
          "Pro_Id": editModel!.proId,
          "Pro_Name": controllerName.text.trim(),
          "Pro_Code": controllerProductCode.text.trim(),
          'Pro_Cat_Id': selectedCategory!.catId.toString(),
          'Pro_Price': controllerPrice.text.trim(),
          'Pro_Discount': controllerPriceDiscount.text.trim(),
          'Pro_SGST': controllerSGST.text.trim(),
          'Pro_CGST': controllerCGST.text.trim(),
          'Pro_Courier_Charges': controllerCourierCharges.text.trim(),
          'Pro_Weight': controllerWeight.text.trim()
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
      var postUri = getUrl(endUpdateProductImage);
      var request = http.MultipartRequest("POST", postUri);
      request.fields['Pro_Id'] = editModel!.proId ?? "";
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
