import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Network/API.dart';
import '../../../Network/ApiUrls.dart';
import '../../../utils/Strings.dart';
import '../cart/CartController.dart';
import '../cart/model/CartListResponseModel.dart';
import 'model/ProductResponseModel.dart';

class ShoesListController extends GetxController {
  List<Product> shoesList = <Product>[];
  RxList<Product> searchShoesList = <Product>[].obs;

  RxString inProgressOrDataNotAvailable = "".obs;
  RxBool isLoading = false.obs;
  final TextEditingController textControllerSearch = TextEditingController();

  CartController cartController = Get.find(tag: "CartController");

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

  mapWithCartList() {
    log("ListMap");
    for (CartProductModel cartModel in cartController.cartProductList) {
      for (Product model in shoesList) {
        if (model.proId == cartModel.proId) {
          model.model = cartModel;
        }
      }
      for (Product model in searchShoesList) {
        if (model.proId == cartModel.proId) {
          model.model = cartModel;
        }
      }
    }
    search("");
  }

  getData() async {
    log("ARGUMENTS :  ${Get.arguments}   ");
    HttpRequestModel request = HttpRequestModel(
        url: endProductList,
        authMethod: '',
        body: '',
        headerType: '',
        params: {"Cat_Id": Get.arguments["cat_id"].toString()}.toString(),
        method: 'POST');

    try {
      isLoading.trigger(true);
      String response = await HttpService().init(request);
      if (response.isNotEmpty) {
        ProductResponseModel responseModel =
            ProductResponseModel.fromJson(jsonDecode(response));
        if (responseModel.status == "1" && responseModel.productList != null) {
          shoesList.clear();
          searchShoesList.clear();
          if (responseModel.productList != null) {
            shoesList.addAll(responseModel.productList!);
            searchShoesList.addAll(shoesList);
            mapWithCartList();
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
}
