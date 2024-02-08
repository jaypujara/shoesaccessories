import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';

import '../../Network/API.dart';
import '../../Network/ApiUrls.dart';
import '../../utils/ColorConstants.dart';
import '../../utils/Constants.dart';
import '../../utils/Preferences.dart';
import '../../utils/Strings.dart';
import '../../widgets/Widgets.dart';
import '../admin/dashboard/DashBoardAdmin.dart';
import '../login/LoginPage.dart';
import '../users/dashboard/DashBoardPage.dart';

class SplashController extends GetxController {
  RxBool animate = false.obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    Future.delayed(
      const Duration(seconds: 3),
      () async {
        String email = await Preferences().getPrefString(Preferences.prefEmail);
        log("EMAIL : $email");
        if (email.isEmpty) {
          Get.offAll(() => LoginPage());
        } else {
          String password =
              await Preferences().getPrefString(Preferences.prefPassword);
          signIn(email, password);
        }
      },
    );
    animate.trigger(false);
    Future.delayed(
      const Duration(milliseconds: 200),
      () {
        animate.trigger(true);
      },
    );
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
          // await Preferences().setPrefBool(Preferences.prefIsAdmin,
          //     (jsonResponse["Data"]["IsAdmin"] == "1"));
          isAdminLogin = jsonResponse["Data"]["IsAdmin"] == "1";
          print("ISADMIN : ${(jsonResponse["Data"]["IsAdmin"] == "1")}");
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
}
