import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Network/API.dart';
import '../../Network/ApiUrls.dart';
import '../../utils/Preferences.dart';
import '../../utils/Strings.dart';
import '../../widgets/Widgets.dart';
import 'model/CartListResponseModel.dart';

class CartController extends GetxController {
  RxList<CartProductModel> searchedCartProductList = <CartProductModel>[].obs;
  List<CartProductModel> cartProductList = [];
  RxString inProgressOrDataNotAvailable = "".obs;
  RxBool isLoading = false.obs;
  RxBool isAddCartLoading = false.obs;
  RxDouble total = 0.0.obs;
  final TextEditingController textControllerSearch = TextEditingController();

  void search(String value) {
    searchedCartProductList.clear();
    if (value.isNotEmpty) {
      searchedCartProductList.value = cartProductList
          .where((element) => element.proName != null
              ? element.proName
                  .toString()
                  .toLowerCase()
                  .contains(value.toLowerCase())
              : false)
          .toList();
    } else {
      searchedCartProductList.addAll(cartProductList);
    }
  }

  @override
  void onInit() {
    super.onInit();
    getData();
  }

  checkIfIdExist(String productId) {
    print(productId);
    for (CartProductModel model in cartProductList) {
      if (model.proId == productId) {
        return true;
      }
    }
    return false;
  }

  String getGrandTotal() {
    total.value = 0;
    for (CartProductModel model in cartProductList) {
      total.value += model.proPrice ?? 0;
    }
    return total.toStringAsFixed(2);
  }

  getData() async {
    String userId = await Preferences().getPrefString(Preferences.prefCustId);
    HttpRequestModel request = HttpRequestModel(
        url: endCartList,
        authMethod: '',
        body: '',
        headerType: '',
        params: {"Cus_Id": userId}.toString(),
        method: 'POST');

    try {
      isLoading.trigger(true);
      String response = await HttpService().init(request);
      if (response.isNotEmpty) {
        CartListResponseModel responseModel =
            CartListResponseModel.fromJson(jsonDecode(response));
        if (responseModel.status == "1" &&
            responseModel.cartProductLis != null) {
          cartProductList.clear();
          searchedCartProductList.clear();
          if (responseModel.cartProductLis != null) {
            cartProductList.addAll(responseModel.cartProductLis!);
            searchedCartProductList.addAll(cartProductList);
            getGrandTotal();
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

  increaseQuantityItem(){

  }

  decreaseQuantityItem(){

  }

  addToCart(String productId) async {
    String userId = await Preferences().getPrefString(Preferences.prefCustId);
    HttpRequestModel request = HttpRequestModel(
        url: endAddCart,
        authMethod: '',
        body: '',
        headerType: '',
        params: json.encode({
          "CartId": "0",
          "CustId": userId,
          "ProId": productId,
        }).toString(),
        method: 'POST');

    try {
      isAddCartLoading.trigger(true);
      String response = await HttpService().init(request);
      if (response.isNotEmpty) {
        var responseJson = jsonDecode(response);
        if (responseJson["Status"] == "1") {
          showSnackBarWithText(Get.context, responseJson["Message"]);
          await getData();
        } else {
          showSnackBarWithText(Get.context, responseJson["Message"]);
        }
      } else {
        showSnackBarWithText(Get.context, stringSomeThingWentWrong);
      }
    } catch (e) {
      log("ERROR: NS ${e.toString()}");
      showSnackBarWithText(Get.context, stringSomeThingWentWrong);
    } finally {
      isAddCartLoading.trigger(false);
    }
  }
}
