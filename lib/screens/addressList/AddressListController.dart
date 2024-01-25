import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoes_acces/screens/addressList/model/AddressListResponseModel.dart';
import 'package:shoes_acces/utils/ColorConstants.dart';
import 'package:shoes_acces/utils/Preferences.dart';
import 'package:shoes_acces/widgets/Widgets.dart';

import '../../Network/API.dart';
import '../../Network/ApiUrls.dart';
import '../../utils/Strings.dart';

class AddressListController extends GetxController {
  final GlobalKey<FormState> keyForm = GlobalKey<FormState>();
  RxList<AddressModel> searchAddressList = <AddressModel>[].obs;
  List<AddressModel> addressList = [];
  RxString inProgressOrDataNotAvailable = "".obs;
  RxBool isLoading = false.obs;
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

  onAddressSubmit() async {
    if (keyForm.currentState != null && keyForm.currentState!.validate()) {
      print("Address Save");
      String userId = await Preferences().getPrefString(Preferences.prefCustId);
      String userName =
          await Preferences().getPrefString(Preferences.prefFullName);

      HttpRequestModel request = HttpRequestModel(
          url: endAddressSave,
          authMethod: '',
          body: '',
          headerType: '',
          params: json.encode({
            "Id": "0",
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
        isLoading.trigger(true);
        String response = await HttpService().init(request);
        if (response.isNotEmpty) {
          var responseModel = jsonDecode(response);
          if (responseModel["Status"] == "1") {
            showSnackBarWithText(Get.context, responseModel["Message"],
                color: colorGreen);
            Get.back();
            getData();
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
        isLoading.trigger(false);
      }
    }
  }
}
