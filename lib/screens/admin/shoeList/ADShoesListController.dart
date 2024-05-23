import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Network/API.dart';
import '../../../Network/ApiUrls.dart';
import '../../../utils/ColorConstants.dart';
import '../../../utils/Strings.dart';
import '../../../utils/methods.dart';
import '../../../widgets/Widgets.dart';
import '../../users/shoeList/model/ProductResponseModel.dart';

class ADShoesListController extends GetxController {
  List<Product> shoesList = <Product>[];
  RxList<Product> searchShoesList = <Product>[].obs;

  RxString inProgressOrDataNotAvailable = "".obs;
  RxBool isLoading = false.obs;
  final TextEditingController textControllerSearch = TextEditingController();

  String catId = "0";

  @override
  void onInit() {
    super.onInit();
    getData();
  }

  void search(String value) {
    searchShoesList.clear();
    if (value.isNotEmpty) {
      searchShoesList.value = shoesList
          .where((element) => element.proName != null
              ? element.proName
                  .toString()
                  .toLowerCase()
                  .contains(value.toLowerCase())
              : false)
          .toList();
    } else {
      searchShoesList.addAll(shoesList);
    }
  }

  getData() async {
    log("ARGUMENTS :  ${Get.arguments}   ");
    if (Get.arguments != null) {
      catId = Get.arguments["cat_id"].toString();
    }
    HttpRequestModel request = HttpRequestModel(
        url: endProductList,
        authMethod: '',
        body: '',
        headerType: '',
        params: {"Cat_Id": catId}.toString(),
        method: 'POST');

    try {
      isLoading.trigger(true);
      String response = await HttpService().init(request);
      if (response.isNotEmpty) {
        ProductResponseModel responseModel =
            ProductResponseModel.fromJson(jsonDecode(response));
        shoesList.clear();
        searchShoesList.clear();
        if (responseModel.status == "1" && responseModel.productList != null) {
          if (responseModel.productList != null) {
            shoesList.addAll(responseModel.productList!);
            searchShoesList.addAll(shoesList);
          } else {
            inProgressOrDataNotAvailable.value = stringDataNotAvailable;
          }
          isLoading.trigger(false);
        } else {
          inProgressOrDataNotAvailable.value = jsonDecode(response)["Message"];
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

  deleteProduct(String categoryId) async {
    HttpRequestModel request = HttpRequestModel(
        url: endProductDelete,
        authMethod: '',
        body: '',
        headerType: '',
        params: json.encode({
          "Pro_ID": categoryId,
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
          await getData();
          removeOverlay();
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
}
