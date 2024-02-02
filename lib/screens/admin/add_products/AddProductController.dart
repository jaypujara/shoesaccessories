import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shoes_acces/Network/ApiUrls.dart';
import 'package:shoes_acces/screens/admin/dashboard/DashBoardAdminController.dart';
import 'package:shoes_acces/screens/users/dashboard/model/CategoryResponseModel.dart';
import 'package:shoes_acces/utils/methods.dart';
import 'package:shoes_acces/widgets/Widgets.dart';

class AddProductController extends GetxController {
  final Rx<GlobalKey<FormState>> keyForm = GlobalKey<FormState>().obs;
  final TextEditingController controllerName = TextEditingController();
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

  DashBoardAdminController controllerDashboard =
      Get.find(tag: "DashBoardAdminController");

  @override
  void onInit() {
    super.onInit();
    print("${controllerDashboard.categoryList.length}");
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

  onSave() {
    log("SAVE");
    if (keyForm.value.currentState != null &&
        keyForm.value.currentState!.validate() &&
        image != null &&
        selectedCategory != null) {
      save();
    } else if (image == null) {
      showSnackBarWithText(Get.context, "Please select Image first!");
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
          showSnackBarWithText(Get.context, "Product Added SuccessFully");
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
