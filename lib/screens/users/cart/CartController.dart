import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shoes_acces/Network/API.dart';
import 'package:shoes_acces/Network/ApiUrls.dart';
import 'package:shoes_acces/utils/ColorConstants.dart';
import 'package:shoes_acces/utils/Preferences.dart';
import 'package:shoes_acces/utils/Strings.dart';
import 'package:shoes_acces/utils/methods.dart';
import 'package:shoes_acces/widgets/Widgets.dart';

import '../addressList/model/AddressListResponseModel.dart';
import 'model/CartListResponseModel.dart';

class CartController extends GetxController {
  RxList<CartProductModel> searchedCartProductList = <CartProductModel>[].obs;
  RxList<CartProductModel> cartProductList = <CartProductModel>[].obs;
  RxString inProgressOrDataNotAvailable = "".obs;
  RxBool isLoading = false.obs;
  RxBool isOrderPlacementLoading = false.obs;
  RxBool isOrderPlacementSuccessFull = false.obs;
  RxDouble total = 0.0.obs;
  RxDouble subTotal = 0.0.obs;
  final TextEditingController textControllerSearch = TextEditingController();

  final TextEditingController textControllerAddressSearch =
      TextEditingController();
  RxList<AddressModel> searchAddressList = <AddressModel>[].obs;
  List<AddressModel> addressList = [];
  RxInt selectedAddressIndex = (-1).obs;
  RxBool isAddressLoading = false.obs;

  void searchAddress(String value) {
    searchAddressList.clear();
    if (value.isNotEmpty) {
      searchAddressList.value = addressList
          .where((element) =>
              (element.add1 != null &&
                  element.add1
                      .toString()
                      .toLowerCase()
                      .contains(value.toLowerCase())) ||
              (element.add2 != null &&
                  element.add2
                      .toString()
                      .toLowerCase()
                      .contains(value.toLowerCase())) ||
              (element.add3 != null &&
                  element.add3
                      .toString()
                      .toLowerCase()
                      .contains(value.toLowerCase())) ||
              (element.city != null &&
                  element.city
                      .toString()
                      .toLowerCase()
                      .contains(value.toLowerCase())) ||
              (element.area != null &&
                  element.area
                      .toString()
                      .toLowerCase()
                      .contains(value.toLowerCase())) ||
              (element.pinCode != null &&
                  element.pinCode
                      .toString()
                      .toLowerCase()
                      .contains(value.toLowerCase())))
          .toList();
    } else {
      searchAddressList.addAll(addressList);
    }
  }

  getAddressData() async {
    String userId = await Preferences().getPrefString(Preferences.prefCustId);

    HttpRequestModel request = HttpRequestModel(
        url: endAddressList,
        authMethod: '',
        body: '',
        headerType: '',
        params: {"UserId": userId}.toString(),
        method: 'POST');

    try {
      isAddressLoading.trigger(true);
      String response = await HttpService().init(request);
      if (response.isNotEmpty) {
        AddressListResponseModel responseModel =
            AddressListResponseModel.fromJson(jsonDecode(response));
        if (responseModel.status == "1" &&
            responseModel.addressModelList != null) {
          addressList.clear();
          searchAddressList.clear();
          if (responseModel.addressModelList != null) {
            addressList.addAll(responseModel.addressModelList!);
            searchAddressList.addAll(addressList);
          } else {
            inProgressOrDataNotAvailable.value = stringDataNotAvailable;
          }
          isAddressLoading.trigger(false);
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
      isAddressLoading.trigger(false);
    }
  }

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
    // getData(true);
  }

  checkIfIdExist(String productId) {
    log(productId);
    for (CartProductModel model in cartProductList) {
      if (model.proId == productId) {
        return true;
      }
    }
    return false;
  }

  String getTotal() {
    total.value = 0;
    subTotal.value = 0;
    for (CartProductModel model in cartProductList) {
      if (model.proDiscount != null && model.proDiscount != 0.0) {
        total.value += (model.proDiscount ?? 0) * (model.proQty ?? 0);
      } else {
        total.value += (model.proPrice ?? 0) * (model.proQty ?? 0);
      }
      total.value += (model.proSGST ?? 0) * (model.proQty ?? 0) +
          (model.proCGST ?? 0) * (model.proQty ?? 0);
      subTotal.value += (model.proPrice ?? 0) * (model.proQty ?? 0) +
          (model.proSGST ?? 0) * (model.proQty ?? 0) +
          (model.proCGST ?? 0) * (model.proQty ?? 0);
    }
    return total.toStringAsFixed(2);
  }

  getData(bool isWithLoader) async {
    String userId = await Preferences().getPrefString(Preferences.prefCustId);
    if (userId != null && userId.isNotEmpty) {
      HttpRequestModel request = HttpRequestModel(
          url: endCartList,
          authMethod: '',
          body: '',
          headerType: '',
          params: {"Cus_Id": userId}.toString(),
          method: 'POST');

      try {
        if (isWithLoader) {
          isLoading.trigger(true);
        }
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
              getTotal();
            } else {
              inProgressOrDataNotAvailable.value = stringDataNotAvailable;
            }
            if (isWithLoader) {
              isLoading.trigger(false);
            }
          } else {
            cartProductList.clear();
            searchedCartProductList.clear();
            subTotal.value = 0;
            total.value = 0;
            inProgressOrDataNotAvailable.value =
                jsonDecode(response)["Message"];
          }
        } else {
          inProgressOrDataNotAvailable.value = stringDataNotAvailable;
        }
      } catch (e) {
        log("ERROR: NS ${e.toString()}");
        inProgressOrDataNotAvailable.value = stringDataNotAvailable;
      } finally {
        if (isWithLoader) {
          isLoading.trigger(false);
        }
      }
    }
  }

  addToCart(
      {required String productId,
      String cartId = "0",
      int quantity = 1}) async {
    String userId = await Preferences().getPrefString(Preferences.prefCustId);
    HttpRequestModel request = HttpRequestModel(
        url: endAddCart,
        authMethod: '',
        body: '',
        headerType: '',
        params: json.encode({
          "CartId": cartId,
          "CustId": userId,
          "ProId": productId,
          "Qty": quantity.toString(),
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
          await getData(false);
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
      removeOverlay();
    }
  }

  deleteFromCart(String cartId) async {
    HttpRequestModel request = HttpRequestModel(
        url: endDeleteCart,
        authMethod: '',
        body: '',
        headerType: '',
        params: json.encode({
          "CartId": cartId,
        }).toString(),
        method: 'POST');

    try {
      // isAddCartLoading.trigger(true);
      getOverlay();
      String response = await HttpService().init(request);
      if (response.isNotEmpty) {
        var responseJson = jsonDecode(response);
        if (responseJson["Status"] == "1") {
          showSnackBarWithText(Get.context, responseJson["Message"],
              color: colorGreen);
          await getData(false);
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
      removeOverlay();
      // isAddCartLoading.trigger(false);
    }
  }

  placeOrder({required int addressId}) async {
    isOrderPlacementLoading.trigger(true);
    isOrderPlacementSuccessFull.trigger(false);
    String userId = await Preferences().getPrefString(Preferences.prefCustId);
    String productIds = "";
    String productNames = "";
    String productQty = "";
    String productTotal = "";
    String SGST = "";
    String CGST = "";

    getTotal();
    for (CartProductModel model in cartProductList) {
      double productPrice = (model.proDiscount != null && model.proDiscount != 0
              ? model.proDiscount
              : model.proPrice) ??
          0;
      productIds += "${productIds.isEmpty ? "" : "^"}${model.proId ?? ""}";
      productNames +=
          "${productNames.isEmpty ? "" : "^"}${model.proName ?? ""}";
      productQty += "${productQty.isEmpty ? "" : "^"}${model.proQty ?? "1"}";
      productTotal +=
          "${productTotal.isEmpty ? "" : "^"}${productPrice * (model.proQty ?? 1)}";

      SGST +=
          "${SGST.isEmpty ? "" : "^"}${model.proSGST != null ? model.proSGST! * (model.proQty ?? 1) : "0"}";
      CGST +=
          "${CGST.isEmpty ? "" : "^"}${model.proCGST != null ? model.proCGST! * (model.proQty ?? 1) : "0"}";
    }

    HttpRequestModel request = HttpRequestModel(
        url: endOrderSave,
        authMethod: '',
        body: '',
        headerType: '',
        params: json.encode({
          "OrderId": "0",
          "UserId": userId,
          "AddressId": addressId.toString(),
          "ProductId": productIds,
          "ProductName": productNames,
          "SubTotal": subTotal.value.toString(),
          "TotalAmount": total.value.toString(),
          "ProductTotal": productTotal.toString(),
          "SGST": SGST,
          "CGST": CGST,
          "Qty": productQty,
          "OrderDate": DateFormat("dd MMM yyyy").format(DateTime.now()),
          "ExpectedDeliveryDate": DateFormat("dd MMM yyyy")
              .format(DateTime.now().add(const Duration(days: 7))),
        }).toString(),
        method: 'POST');

    print(request.params);
    try {
      isOrderPlacementLoading.trigger(true);
      isOrderPlacementSuccessFull.trigger(false);
      // getOverlay();

      // Get.to(() => const OrderPlacedResult());
      // await Future.delayed(
      //   const Duration(seconds: 3),
      //   () {
      //     isOrderPlacementLoading.trigger(false);
      //     isOrderPlacementSuccessFull.trigger(true);
      //   },
      // );

      String response = await HttpService().init(request);
      if (response.isNotEmpty) {
        var responseJson = jsonDecode(response);
        if (responseJson["Status"] == "1") {
          showSnackBarWithText(Get.context, responseJson["Message"],
              color: colorGreen);
          isOrderPlacementLoading.trigger(false);
          isOrderPlacementSuccessFull.trigger(true);
          await getData(false);
        } else {
          showSnackBarWithText(Get.context, responseJson["Message"]);
          isOrderPlacementSuccessFull.trigger(false);
        }
      } else {
        showSnackBarWithText(Get.context, stringSomeThingWentWrong);
      }
    } catch (e) {
      log("ERROR: NS ${e.toString()}");
      showSnackBarWithText(Get.context, stringSomeThingWentWrong);
    } finally {
      removeOverlay();
      isOrderPlacementLoading.trigger(false);
      // isAddCartLoading.trigger(false);
    }
  }
}
