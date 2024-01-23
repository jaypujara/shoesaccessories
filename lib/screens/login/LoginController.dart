import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shoes_acces/screens/dashboard/DashBoardPage.dart';
import 'package:shoes_acces/utils/ColorConstants.dart';
import 'package:shoes_acces/utils/Strings.dart';
import 'package:shoes_acces/utils/methods.dart';
import 'package:shoes_acces/widgets/Widgets.dart';

import '../../Network/API.dart';
import '../../Network/ApiUrls.dart';
import '../../utils/Preferences.dart';

class LoginController extends GetxController {
  final GlobalKey<FormState> keyForm = GlobalKey<FormState>();
  final TextEditingController controllerEmail = TextEditingController();
  final TextEditingController controllerPassword = TextEditingController();

  final TextEditingController controllerForgotNumber = TextEditingController();

  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  onLogin() {
    if (keyForm.currentState != null && keyForm.currentState!.validate()) {
      signIn(controllerEmail.text, controllerPassword.text);
    }
  }

  onForgotSend() {
    // if (keyForm.currentState != null && keyForm.currentState!.validate()) {
    //   signIn(controllerEmail.text, controllerPassword.text);
    // }
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
      // getOverlay(Get.context!);
      isLoading.trigger(true);
      String response = await HttpService().init(request);
      if (response.isNotEmpty) {
        var jsonResponse = json.decode(response);
        if (jsonResponse["Status"] == "1") {
          showSnackBarWithText(Get.context, jsonResponse["Message"],
              color: colorGreen);
          await Preferences().setPrefString(
              Preferences.prefCustId, jsonResponse["Data"]["Cus_Id"]);
          await Preferences().setPrefString(
              Preferences.prefFullName, jsonResponse["Data"]["Cus_FullName"]);
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
