import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoes_acces/screens/users/order_history/model/OrderHistoryListResponseModel_V2.dart';
import 'package:shoes_acces/utils/methods.dart';

import '../../../Network/API.dart';
import '../../../Network/ApiUrls.dart';
import '../../../utils/Strings.dart';

class OrderHistoryListControllerAdmin extends GetxController {
  List<Orders> orderList = <Orders>[];
  RxList<Orders> searchOrderList = <Orders>[].obs;

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
      // searchOrderList.value = orderList
      //     .where((element) =>
      //         (element.productName != null &&
      //             element.productName
      //                 .toString()
      //                 .toLowerCase()
      //                 .contains(value.toLowerCase())) ||
      //         (element.orderId != null &&
      //             element.orderId
      //                 .toString()
      //                 .toLowerCase()
      //                 .contains(value.toLowerCase())) ||
      //         (element.totalAmount != null &&
      //             element.totalAmount
      //                 .toString()
      //                 .toLowerCase()
      //                 .contains(value.toLowerCase())))
      //     .toList();
    } else {
      searchOrderList.addAll(orderList);
    }
  }

  getData() async {
    String userId = '0';
    HttpRequestModel request = HttpRequestModel(
        url: endOrderHistoryList_V2,
        authMethod: '',
        body: '',
        headerType: '',
        params: {"UserId": userId}.toString(),
        method: 'POST');

    try {
      isLoading.trigger(true);
      String response = await HttpService().init(request);
      if (response.isNotEmpty) {
        OrderHistoryListResponseModel_V2 responseModel =
            OrderHistoryListResponseModel_V2.fromJson(jsonDecode(response));
        if (responseModel.status == "1" && responseModel.orders != null) {
          orderList.clear();
          searchOrderList.clear();
          if (responseModel.orders != null) {
            orderList.addAll(responseModel.orders!);
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

  Future<void> updateOrderStatus(
      {required int orderId, required int state}) async {
    HttpRequestModel request = HttpRequestModel(
        url: endOrderStatusChange,
        authMethod: '',
        body: '',
        headerType: '',
        params: {
          "OrderId": orderId,
          "Status": state,
        }.toString(),
        //OrderId,Status
        method: 'POST');

    try {
      getOverlay();
      String response = await HttpService().init(request);
      if (response.isNotEmpty) {
        OrderHistoryListResponseModel_V2 responseModel =
            OrderHistoryListResponseModel_V2.fromJson(jsonDecode(response));
        if (responseModel.status == "1" && responseModel.orders != null) {
          getData();
          //isLoading.trigger(false);
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
      removeOverlay();
    }
  }
}
