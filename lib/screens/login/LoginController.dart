import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shoes_acces/screens/admin/dashboard/DashBoardAdmin.dart';
import 'package:shoes_acces/screens/users/cart/CartController.dart';
import 'package:shoes_acces/screens/users/dashboard/DashBoardPage.dart';
import 'package:shoes_acces/utils/ColorConstants.dart';
import 'package:shoes_acces/utils/Constants.dart';
import 'package:shoes_acces/utils/Strings.dart';
import 'package:shoes_acces/widgets/Widgets.dart';

import '../../../Network/API.dart';
import '../../../Network/ApiUrls.dart';
import '../../../utils/Preferences.dart';
import '../../utils/methods.dart';

class LoginController extends GetxController {
  final GlobalKey<FormState> keyForm = GlobalKey<FormState>();
  final TextEditingController controllerEmail = TextEditingController();
  final TextEditingController controllerPassword = TextEditingController();

  final TextEditingController controllerForgotNumber = TextEditingController();

  RxBool isLoading = false.obs;
  RxBool isForgotLoading = false.obs;

  onLogin() {
    if (keyForm.currentState != null && keyForm.currentState!.validate()) {
      signIn(controllerEmail.text, controllerPassword.text);
    }
  }

  onForgotSend() async {
    Get.back();
    await forgotPassword(controllerForgotNumber.text);
    controllerForgotNumber.text = "";
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
          await Preferences().setPrefBool(Preferences.prefIsGuest, false);
          // await Preferences().setPrefBool(
          //     Preferences.prefIsAdmin, jsonResponse["Data"]["IsAdmin"] == "1");
          isAdminLogin = jsonResponse["Data"]["IsAdmin"] == "1";
          CartController cartController = Get.find(tag: "CartController");
          cartController.getData(false);
          Get.offAll(() => isAdminLogin ? DashBoardAdmin() : DashBoardPage());
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

  forgotPassword(String data) async {
    HttpRequestModel request = HttpRequestModel(
        url: endForgotCustomerPassowrd,
        authMethod: '',
        body: '',
        headerType: '',
        params: json.encode({"UserDet": data}).toString(),
        method: 'POST');

    try {
      getOverlay();
      String response = await HttpService().init(request);
      if (response.isNotEmpty) {
        var jsonResponse = json.decode(response);
        if (jsonResponse["Status"] == "1") {
          showSnackBarWithText(Get.context, jsonResponse["Message"],
              color: colorGreen);
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
      removeOverlay();
    }
  }

  Future<void> signWithGoogle() async {
   // final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
   // final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;


  }

  Future<void> signWithFacebook() async {
    // Trigger the sign-in flow
    //final LoginResult loginResult = await FacebookAuth.instance.login();

    // Create a credential from the access token
    // final facebookAuthCredential = FacebookAuthProvider.credential(loginResult.accessToken?.);

    // Once signed in, return the UserCredential
    // return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  }

}
