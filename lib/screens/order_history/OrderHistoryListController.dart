import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoes_acces/screens/order_history/model/OrderHistoryListResponseModel.dart';

import '../../Network/API.dart';
import '../../Network/ApiUrls.dart';
import '../../utils/Preferences.dart';
import '../../utils/Strings.dart';

class OrderHistoryListController extends GetxController {
  List<Order> orderList = <Order>[];
  RxList<Order> searchOrderList = <Order>[].obs;

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
        if (responseModel.status == "1" && responseModel.orderList != null) {
          orderList.clear();
          searchOrderList.clear();
          if (responseModel.orderList != null) {
            orderList.addAll(responseModel.orderList!);
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
