import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoes_acces/Network/API.dart';
import 'package:shoes_acces/Network/ApiUrls.dart';
import 'package:shoes_acces/screens/login/LoginPage.dart';
import 'package:shoes_acces/utils/ColorConstants.dart';
import 'package:shoes_acces/utils/Constants.dart';
import 'package:shoes_acces/utils/Preferences.dart';
import 'package:shoes_acces/utils/Strings.dart';
import 'package:shoes_acces/widgets/Widgets.dart';

import '../cart/CartController.dart';
import 'model/AdvertisementResponseModel.dart';
import 'model/CategoryResponseModel.dart';

class DashBoardController extends GetxController {
  final GlobalKey<ScaffoldState> keyScaffold = GlobalKey<ScaffoldState>();
  RxList<CategoryModel> searchCategoryList = <CategoryModel>[].obs;
  List<CategoryModel> categoryList = [];
  RxString inProgressOrDataNotAvailable = "".obs;
  RxBool isLoading = false.obs;
  RxInt indexSlider = 0.obs;
  RxList imageList = [].obs;
  final TextEditingController textControllerSearch = TextEditingController();

  final GlobalKey<FormState> keyForm = GlobalKey<FormState>();
  final TextEditingController textControllerOldPass = TextEditingController();
  final TextEditingController textControllerNewPass = TextEditingController();
  final TextEditingController textControllerConfirmNewPass =
      TextEditingController();
  RxBool isChangePassLoading = false.obs;
  RxString error = "".obs;

  RxBool isAdmin = false.obs;
  static RxBool isGuest = false.obs;

  @override
  void onInit() {
    super.onInit();
    if (isAdminLogin) {
      isAdmin.trigger(true);
    }
    getData();
    getAdvertisement();
  }

  void search(String value) {
    searchCategoryList.clear();
    if (value.isNotEmpty) {
      searchCategoryList.value = categoryList
          .where((element) => element.catName != null
              ? element.catName
                  .toString()
                  .toLowerCase()
                  .contains(value.toLowerCase())
              : false)
          .toList();
    } else {
      searchCategoryList.addAll(categoryList);
    }
  }

  getData() async {
    isGuest.trigger(await Preferences().getPrefBool(Preferences.prefIsGuest));
    HttpRequestModel request = HttpRequestModel(
        url: endCategoryList,
        authMethod: '',
        body: '',
        headerType: '',
        params: '',
        method: 'POST');

    try {
      isLoading.trigger(true);
      String response = await HttpService().init(request);
      if (response.isNotEmpty) {
        CategoryResponseModel responseModel =
            CategoryResponseModel.fromJson(jsonDecode(response));
        if (responseModel.status == "1" && responseModel.list != null) {
          // prepareList(nearestStops.data!);
          // nearestApiCallTimer = Timer(Duration(seconds:), () { })
          categoryList.clear();
          searchCategoryList.clear();
          if (responseModel.list != null) {
            categoryList.addAll(responseModel.list!);
            searchCategoryList.addAll(categoryList);
          } else {
            inProgressOrDataNotAvailable.value = stringDataNotAvailable;
          }
          isLoading.trigger(false);
        } else {
          inProgressOrDataNotAvailable.value = stringDataNotAvailable;
        }
      } else {
        inProgressOrDataNotAvailable.value = stringDataNotAvailable;
      }
    } catch (e) {
      log("ERROR: NS ${e.toString()}");
      inProgressOrDataNotAvailable.value = stringDataNotAvailable;
    } finally {
      isLoading.trigger(false);
    }
  }

  getAdvertisement() async {
    HttpRequestModel request = HttpRequestModel(
        url: endAdvertisementList,
        authMethod: '',
        body: '',
        headerType: '',
        params: '',
        method: 'POST');

    try {
      String response = await HttpService().init(request);
      if (response.isNotEmpty) {
        AdvertisementResponseModel responseModel =
            AdvertisementResponseModel.fromJson(jsonDecode(response));
        if (responseModel.status == "1" &&
            responseModel.imagePathList != null) {
          imageList.clear();
          imageList.value = responseModel.imagePathList!
              .map((e) => e.imagePath ?? "")
              .toList();
        } else {
          imageList.clear();
          inProgressOrDataNotAvailable.value = stringDataNotAvailable;
        }
      } else {
        imageList.clear();
        inProgressOrDataNotAvailable.value = stringDataNotAvailable;
      }
    } catch (e) {
      log("ERROR: NS ${e.toString()}");
      imageList.clear();
      inProgressOrDataNotAvailable.value = stringDataNotAvailable;
    } finally {
      // isLoading.trigger(false);
    }
  }

  onChangePassword() async {
    if (keyForm.currentState != null && keyForm.currentState!.validate()) {
      log("CHANGE PASSWORD");
      String userId = await Preferences().getPrefString(Preferences.prefCustId);

      HttpRequestModel request = HttpRequestModel(
          url: endChangePassword,
          authMethod: '',
          body: '',
          headerType: '',
          params: json.encode({
            "Cus_Id": userId,
            "OldPassword": textControllerOldPass.text.trim(),
            "NewPassword": textControllerNewPass.text.trim(),
          }).toString(),
          method: 'POST');

      try {
        error.value = "";
        isChangePassLoading.trigger(true);
        String response = await HttpService().init(request);
        if (response.isNotEmpty) {
          var responseModel = jsonDecode(response);
          if (responseModel["Status"] == "1") {
            showSnackBarWithText(Get.context, responseModel["Message"],
                color: colorGreen);
            Preferences().setPrefString(
                Preferences.prefPassword, textControllerNewPass.text.trim());
            error.value = "";
            textControllerOldPass.text = "";
            textControllerNewPass.text = "";

            Get.back();
          } else {
            error.value = responseModel["Message"];
            // showSnackBarWithText(Get.context, responseModel["Message"]);
          }
        } else {
          error.value = stringSomeThingWentWrong;
          // showSnackBarWithText(Get.context, stringSomeThingWentWrong);
        }
      } catch (e) {
        log("ERROR: NS ${e.toString()}");
        error.value = stringSomeThingWentWrong;
        showSnackBarWithText(Get.context, stringSomeThingWentWrong);
      } finally {
        isChangePassLoading.trigger(false);
      }
    }
  }

  logout() async {
    await Preferences().setPrefString(Preferences.prefCustId, "");
    await Preferences().setPrefString(Preferences.prefEmail, "");
    await Preferences().setPrefString(Preferences.prefFullName, "");
    await Preferences().setPrefString(Preferences.prefPassword, "");
    await Preferences().setPrefString(Preferences.prefPhone, "");
    CartController cartController = Get.find(tag: "CartController");
    cartController.refresh();
    cartController.cartProductList.clear();
    cartController.searchedCartProductList.clear();
    Get.back();
    Get.offAll(() => LoginPage());
  }

  deleteAccount() async {
    await logout();
  }
}
