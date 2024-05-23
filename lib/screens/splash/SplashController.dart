import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shoes_acces/screens/splash/model/VersionModel.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Network/API.dart';
import '../../Network/ApiUrls.dart';
import '../../utils/ColorConstants.dart';
import '../../utils/Constants.dart';
import '../../utils/Preferences.dart';
import '../../utils/Strings.dart';
import '../../widgets/Widgets.dart';
import '../admin/dashboard/DashBoardAdmin.dart';
import '../login/LoginPage.dart';
import '../users/cart/CartController.dart';
import '../users/dashboard/DashBoardPage.dart';

class SplashController extends GetxController {
  RxBool animate = false.obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    animate.trigger(false);
    Future.delayed(
      const Duration(milliseconds: 200),
      () {
        animate.trigger(true);
      },
    );
    Future.delayed(
      const Duration(seconds: 3),
      () async {
        checkAppVersion();
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
          CartController cartController = Get.find(tag: "CartController");
          cartController.getData(false);
          isAdminLogin = jsonResponse["Data"]["IsAdmin"] == "1";
          print("ISADMIN : ${(jsonResponse["Data"]["IsAdmin"] == "1")}");
          Get.offAll(() => isAdminLogin ? DashBoardAdmin() : DashBoardPage());
        } else {
          Get.offAll(() => LoginPage());
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

  Future<void> checkAppVersion() async {
    HttpRequestModel request = HttpRequestModel(
        url: endAppVersion,
        authMethod: '',
        body: '',
        headerType: '',
        params: "",
        method: 'POST');

    try {
      // getOverlay(Get.context!);
      isLoading.trigger(true);
      String response = await HttpService().init(request);
      if (response.isNotEmpty) {
        var jsonResponse = jsonDecode(response);
        if (jsonResponse["Status"] == "1") {
          VersionModel versionModel =
              VersionModel.fromJson(jsonDecode(response));
          log(int.parse(versionModel.data!.verNo!.replaceAll(".", ""))
              .toString());
          log(int.parse(await getVersionNumber()).toString());
          if (int.parse(versionModel.data!.verNo!.replaceAll(".", "")) <
              int.parse(await getVersionNumber())) {
            showAppUpdateDialog(versionModel.data!.mandatory ?? false);
          } else {
            moveAhedAsParLoginActions();
          }
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

  Future<String> getVersionNumber() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    log("version ${packageInfo.buildNumber}");

    return packageInfo.buildNumber;
  }

  showAppUpdateDialog(bool isMandatory) {
    Get.dialog(
      PopScope(
        canPop: false,
        child: Dialog(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Material(
                      color: colorPrimary,
                      borderRadius: BorderRadius.circular(8),
                      child: const Padding(
                        padding: EdgeInsets.all(10),
                        child: Icon(
                          Icons.install_mobile_rounded,
                          color: colorWhite,
                          size: 30,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      "App Update",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: colorPrimary,
                        fontSize: 30,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                Divider(color: colorPrimary.shade100),
                const SizedBox(height: 20),
                Text(
                  "App update is available. Please update the app.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: colorPrimary.shade300,
                    fontSize: 18,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 20),
                Divider(color: colorPrimary.shade100),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          if (!await launchUrl(Uri.parse(
                              "market://details?id=com.shoes.shoes"))) {
                            showSnackBarWithText(Get.context,
                                "Can not launch store! please update manual on store");
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: colorRed,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: const Text(
                            "UPDATE",
                            style: TextStyle(
                              color: colorWhite,
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (!isMandatory) const SizedBox(width: 8),
                    if (!isMandatory)
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Get.back();
                            moveAhedAsParLoginActions();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: colorGreen,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: const Text(
                              "Later",
                              style: TextStyle(
                                color: colorWhite,
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    ).then((value) {});
  }

  moveAhedAsParLoginActions() async {
    String email = await Preferences().getPrefString(Preferences.prefEmail);
    log("EMAIL : $email");
    if (email.isEmpty) {
      if (!await Preferences().getPrefBool(Preferences.prefIsGuest)) {
        Get.offAll(() => LoginPage());
      } else {
        Get.offAll(() => DashBoardPage());
      }
    } else {
      String password =
          await Preferences().getPrefString(Preferences.prefPassword);
      signIn(email, password);
    }
  }
}
