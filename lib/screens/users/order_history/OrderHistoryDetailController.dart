import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoes_acces/screens/admin/order_history/OrderHistoryListControllerAdmin.dart';
import 'package:shoes_acces/screens/users/order_history/model/OrderHistoryListResponseModel_V2.dart';
import 'package:shoes_acces/screens/users/order_history/model/OrderStatusUpdateResponseModel.dart';
import 'package:shoes_acces/utils/Strings.dart';
import 'package:shoes_acces/widgets/Widgets.dart';

import '../../../Network/API.dart';
import '../../../Network/ApiUrls.dart';
import '../../../utils/methods.dart';

class OrderHistoryDetailController extends GetxController {
  Orders? model;
  bool isAdmin = false;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      model = (await Get.arguments["model"]);
      isAdmin = await Get.arguments["isAdmin"];
      update();
      print(Get.arguments);
      update();
    });
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
        OrderStatusUpdateResponseModel responseModel =
            OrderStatusUpdateResponseModel.fromJson(jsonDecode(response));
        if (responseModel.status == "1") {
          showSnackBarWithText(Get.context, jsonDecode(response)["Message"],
              color: Colors.green);
          Get.back();
        } else {
          showSnackBarWithText(Get.context, jsonDecode(response)["Message"]);
        }
      } else {
        showSnackBarWithText(Get.context, stringSomeThingWentWrong);
      }
    } catch (e) {
      log("ERROR: NS ${e.toString()}");
      showSnackBarWithText(Get.context, stringSomeThingWentWrong);
    } finally {
      removeOverlay();
    }
  }
}
