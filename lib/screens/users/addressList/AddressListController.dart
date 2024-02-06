import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoes_acces/Network/API.dart';
import 'package:shoes_acces/Network/ApiUrls.dart';
import 'package:shoes_acces/screens/users/addressList/model/AddressListResponseModel.dart';
import 'package:shoes_acces/utils/ColorConstants.dart';
import 'package:shoes_acces/utils/Preferences.dart';
import 'package:shoes_acces/utils/Strings.dart';
import 'package:shoes_acces/widgets/Widgets.dart';

class AddressListController extends GetxController {
  final GlobalKey<FormState> keyForm = GlobalKey<FormState>();
  RxList<AddressModel> searchAddressList = <AddressModel>[].obs;
  List<AddressModel> addressList = [];
  RxString inProgressOrDataNotAvailable = "".obs;
  RxBool isLoading = false.obs;
  RxBool isSubmitLoading = false.obs;
  RxString error = "".obs;
  final TextEditingController textControllerSearch = TextEditingController();

  // add Address Dialog Variable
  final TextEditingController textControllerAdd1 = TextEditingController();
  final TextEditingController textControllerAdd2 = TextEditingController();
  final TextEditingController textControllerAdd3 = TextEditingController();
  final TextEditingController textControllerArea = TextEditingController();
  final TextEditingController textControllerCity = TextEditingController();
  final TextEditingController textControllerPinCode = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    getData();
  }

  void search(String value) {
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

  getData() async {
    String userId = await Preferences().getPrefString(Preferences.prefCustId);

    HttpRequestModel request = HttpRequestModel(
        url: endAddressList,
        authMethod: '',
        body: '',
        headerType: '',
        params: {"UserId": userId}.toString(),
        method: 'POST');

    try {
      isLoading.trigger(true);
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

  onAddressSubmit({String id = "0"}) async {
    if (keyForm.currentState != null && keyForm.currentState!.validate()) {
      log("Address Save");
      log("Address Save  ${await Preferences().getPrefString(Preferences.prefFullName)} ${await Preferences().getPrefString(Preferences.prefCustId)}");
      String userId = await Preferences().getPrefString(Preferences.prefCustId);
      log("Address Save  ${await Preferences().getPrefString(Preferences.prefFullName)}");
      String userName =
          await Preferences().getPrefString(Preferences.prefFullName);
      log("Address Save $userName ${await Preferences().getPrefString(Preferences.prefFullName)}");
      error.value = "";
      HttpRequestModel request = HttpRequestModel(
          url: endAddressSave,
          authMethod: '',
          body: '',
          headerType: '',
          params: json.encode({
            "Id": id,
            "Cus_Id": userId,
            "Add1": textControllerAdd1.text,
            "Add2": textControllerAdd2.text,
            "Add3": textControllerAdd3.text,
            "Area": textControllerArea.text,
            "City": textControllerCity.text,
            "PinCode": textControllerPinCode.text,
            "CreatedBy": userName,
          }).toString(),
          method: 'POST');

      try {
        isSubmitLoading.trigger(true);
        String response = await HttpService().init(request);
        if (response.isNotEmpty) {
          var responseModel = jsonDecode(response);
          if (responseModel["Status"] == "1") {
            error.value = "";
            showSnackBarWithText(Get.context, responseModel["Message"],
                color: colorGreen);
            Get.back();
            await getData();
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
        // showSnackBarWithText(Get.context, stringSomeThingWentWrong);
      } finally {
        isSubmitLoading.trigger(false);
      }
    }
  }

  onAddressDelete({String id = "-1"}) async {
    HttpRequestModel request = HttpRequestModel(
        url: endCustomerAddressDelete,
        authMethod: '',
        body: '',
        headerType: '',
        params: json.encode({
          "Id": id,
        }).toString(),
        method: 'POST');

    try {
      isSubmitLoading.trigger(true);
      String response = await HttpService().init(request);
      if (response.isNotEmpty) {
        var responseModel = jsonDecode(response);
        if (responseModel["Status"] == "1") {
          showSnackBarWithText(Get.context, responseModel["Message"],
              color: colorGreen);
          Get.back();
          await getData();
        } else {
          showSnackBarWithText(Get.context, responseModel["Message"]);
        }
      } else {
        showSnackBarWithText(Get.context, stringSomeThingWentWrong);
      }
    } catch (e) {
      log("ERROR: NS ${e.toString()}");
      showSnackBarWithText(Get.context, stringSomeThingWentWrong);
    } finally {
      isSubmitLoading.trigger(false);
    }
  }
}
