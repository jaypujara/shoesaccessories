import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Network/API.dart';
import '../../../Network/ApiUrls.dart';
import '../../../utils/Preferences.dart';
import '../../../utils/Strings.dart';
import 'model/OrderHistoryListResponseModel.dart';



class OrderHistoryListController extends GetxController {
  List<OrderModel> orderList = <OrderModel>[];
  RxList<OrderModel> searchOrderList = <OrderModel>[].obs;

  RxString inProgressOrDataNotAvailable = "".obs;
  RxBool isLoading = false.obs;
  final TextEditingController textControllerSearch = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    getData();
  }

  void search(String value) {
    searchOrderList.clear();
    if (value.isNotEmpty) {
      searchOrderList.value = orderList
          .where((element) =>
              (element.productName != null &&
                  element.productName
                      .toString()
                      .toLowerCase()
                      .contains(value.toLowerCase())) ||
              (element.orderId != null &&
                  element.orderId
                      .toString()
                      .toLowerCase()
                      .contains(value.toLowerCase())) ||
              (element.totalAmount != null &&
                  element.totalAmount
                      .toString()
                      .toLowerCase()
                      .contains(value.toLowerCase())))
          .toList();
    } else {
      searchOrderList.addAll(orderList);
    }
  }

  getData() async {
    String userId = await Preferences().getPrefString(Preferences.prefCustId);
    HttpRequestModel request = HttpRequestModel(
        url: endOrderHistoryList,
        authMethod: '',
        body: '',
        headerType: '',
        params: {"UserId": userId}.toString(),
        method: 'POST');

    try {
      isLoading.trigger(true);
      String response = await HttpService().init(request);
      if (response.isNotEmpty) {
        OrderHistoryListResponseModel responseModel =
            OrderHistoryListResponseModel.fromJson(jsonDecode(response));
        if (responseModel.status == "1" && responseModel.data != null) {
          orderList.clear();
          searchOrderList.clear();
          if (responseModel.data != null) {
            orderList.addAll(responseModel.data!);
            searchOrderList.addAll(orderList);
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
