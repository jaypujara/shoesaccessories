import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoes_acces/utils/Preferences.dart';

import '../../../Network/API.dart';
import '../../../Network/ApiUrls.dart';
import '../../../utils/ColorConstants.dart';
import '../../../utils/Strings.dart';
import '../../../widgets/Widgets.dart';
import '../dashboard/DashBoardPage.dart';

class RegisterController extends GetxController {
  final Rx<GlobalKey<FormState>> keyForm = GlobalKey<FormState>().obs;
  final TextEditingController controllerName = TextEditingController();
  final TextEditingController controllerNumber = TextEditingController();
  final TextEditingController controllerEmail = TextEditingController();
  final TextEditingController controllerPassword = TextEditingController();
  final TextEditingController controllerConfirmPassword =
      TextEditingController();

  RxBool isGenderMale = true.obs;
  RxBool isLoading = false.obs;

  onRegister() {
    log("Register");
    if (keyForm.value.currentState != null &&
        keyForm.value.currentState!.validate()) {
      register(controllerName.text, controllerNumber.text, isGenderMale.value,
          controllerEmail.text, controllerPassword.text);
    }
  }

  register(String fullName, String number, bool isGenderMale, String email,
      String password) async {
    HttpRequestModel request = HttpRequestModel(
        url: endRegister,
        authMethod: '',
        body: '',
        headerType: '',
        params: json.encode({
          "Cus_Id": "0",
          "Cus_FullName": fullName,
          "Cus_MobileNo": number,
          "Cus_EmailID": email,
          "Cus_Password": password,
          "Cus_Gender": isGenderMale ? "Male" : "Female",
          "Cus_CreatedBy": "System",
        }).toString(),
        method: 'POST');

    try {
      // getOverlay(Get.context!);
      isLoading.trigger(true);
      String response = await HttpService().init(request);
      if (response.isNotEmpty) {
        var jsonResponse = json.decode(response);
        if (jsonResponse["Status"] == "1") {
          showSnackBarWithText(Get.context, jsonResponse["Message"],
              color: colorGreen);
          await Preferences().setPrefString(Preferences.prefEmail, email);
          await Preferences().setPrefString(Preferences.prefPassword, password);
          await Preferences().setPrefString(Preferences.prefFullName, fullName);
          await Preferences().setPrefString(Preferences.prefPhone, number);
          signIn(email, password);
        } else {
          showSnackBarWithText(Get.context, jsonResponse["Message"]);
        }
      } else {
        showSnackBarWithText(Get.context, stringSomeThingWentWrong);
      }
    } catch (e) {
      log("ERROR: NS ${e.toString()}");
      showSnackBarWithText(Get.context, stringSomeThingWentWrong);
    } finally {
      isLoading.trigger(false);
      // removeOverlay();
    }
  }

  signIn(String email, String password) async {
    HttpRequestModel request = HttpRequestModel(
        url: endLogin,
        authMethod: '',
        body: '',
        headerType: '',
        params:
            json.encode({"Loginuser": email, "Password": password}).toString(),
        method: 'POST');

    try {
      isLoading.trigger(true);
      String response = await HttpService().init(request);
      if (response.isNotEmpty) {
        var jsonResponse = json.decode(response);
        if (jsonResponse["Status"] == "1") {
          showSnackBarWithText(Get.context, jsonResponse["Message"],
              color: colorGreen);
          await Preferences().setPrefString(
              Preferences.prefCustId, jsonResponse["Data"]["Cus_Id"]);
          await Preferences().setPrefString(Preferences.prefFullName, jsonResponse["Data"]["Cus_FullName"]);
          await Preferences().setPrefString(Preferences.prefEmail, email);
          await Preferences().setPrefString(Preferences.prefPassword, password);

          Get.offAll(() => DashBoardPage());
        } else {
          showSnackBarWithText(Get.context, jsonResponse["Message"]);
        }
      } else {
        showSnackBarWithText(Get.context, stringSomeThingWentWrong);
      }
    } catch (e) {
      log("ERROR: NS ${e.toString()}");
      showSnackBarWithText(Get.context, stringSomeThingWentWrong);
    } finally {
      isLoading.trigger(false);
    }
  }
}
