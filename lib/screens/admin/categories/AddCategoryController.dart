import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shoes_acces/Network/ApiUrls.dart';
import 'package:shoes_acces/utils/methods.dart';
import 'package:shoes_acces/widgets/Widgets.dart';

class AddCategoryController extends GetxController {
  final Rx<GlobalKey<FormState>> keyForm = GlobalKey<FormState>().obs;
  final TextEditingController controllerName = TextEditingController();
  RxBool isLoading = false.obs;
  File? image;

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
        image != null) {
      save(controllerName.text, image!.path);
    } else if (image == null) {
      showSnackBarWithText(Get.context, "Please select Image first!");
    }
  }

  save(String name, String imagepath) async {
    try {
      isLoading.trigger(true);
      getOverlay();
      var postUri = getUrl(endCategorySave);
      var request = http.MultipartRequest("POST", postUri);
      request.fields['Cat_Id'] = '0';
      request.fields['Cat_Name'] = name;
      request.files
          .add(await http.MultipartFile.fromPath('FileName', imagepath));
      await request.send().then((response) {
        if (response.statusCode == 200) {
          print("SUCCESS");
          showSnackBarWithText(Get.context, "Category Added SuccessFully");
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

// register(String name, String imagePath) async {
//   HttpRequestModel request = HttpRequestModel(
//       url: endRegister,
//       authMethod: '',
//       body: '',
//       headerType: '',
//       params: json.encode({
//         "Cat_Id": "0",
//         "Cat_Name": name,
//         "FileName": ,
//         "Cus_EmailID": email,
//         "Cus_Password": password,
//         "Cus_Gender": isGenderMale ? "Male" : "Female",
//         "Cus_CreatedBy": "System",
//       }).toString(),
//       method: 'POST');
//
//   try {
//     // getOverlay(Get.context!);
//     // isLoading.trigger(true);
//     String response = await HttpService().init(request);
//     if (response.isNotEmpty) {
//       var jsonResponse = json.decode(response);
//       if (jsonResponse["Status"] == "1") {
//         showSnackBarWithText(Get.context, jsonResponse["Message"],
//             color: colorGreen);
//         await Preferences().setPrefString(Preferences.prefEmail, email);
//         await Preferences().setPrefString(Preferences.prefPassword, password);
//         await Preferences().setPrefString(Preferences.prefFullName, fullName);
//         await Preferences().setPrefString(Preferences.prefPhone, number);
//         signIn(email, password);
//       } else {
//         showSnackBarWithText(Get.context, jsonResponse["Message"]);
//       }
//     } else {
//       showSnackBarWithText(Get.context, stringSomeThingWentWrong);
//     }
//   } catch (e) {
//     log("ERROR: NS ${e.toString()}");
//     showSnackBarWithText(Get.context, stringSomeThingWentWrong);
//   } finally {
//     isLoading.trigger(false);
//     // removeOverlay();
//   }
// }
}
