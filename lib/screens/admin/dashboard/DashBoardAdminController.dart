import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoes_acces/screens/users/dashboard/model/CategoryResponseModel.dart';

import '../../../Network/API.dart';
import '../../../Network/ApiUrls.dart';
import '../../../utils/Preferences.dart';
import '../../../utils/Strings.dart';
import '../../users/dashboard/model/AdvertisementResponseModel.dart';

class DashBoardAdminController extends GetxController {
  final GlobalKey<ScaffoldState> keyScaffold = GlobalKey<ScaffoldState>();

  RxList<CategoryModel> searchCategoryList = <CategoryModel>[].obs;
  List<CategoryModel> categoryList = [];
  RxString inProgressOrDataNotAvailable = "".obs;
  RxBool isLoading = false.obs;
  RxInt indexSlider = 0.obs;
  RxList imageList = [].obs;
  final TextEditingController textControllerSearch = TextEditingController();

  @override
  void onInit() {
    super.onInit();
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

  logout() async {
    await Preferences().setPrefString(Preferences.prefCustId, "");
    await Preferences().setPrefString(Preferences.prefEmail, "");
    await Preferences().setPrefString(Preferences.prefFullName, "");
    await Preferences().setPrefString(Preferences.prefPassword, "");
    await Preferences().setPrefString(Preferences.prefPhone, "");
    await Preferences().setPrefBool(Preferences.prefIsAdmin, false);
  }
}
