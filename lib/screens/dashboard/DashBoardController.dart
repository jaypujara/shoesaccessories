import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:shoes_acces/screens/dashboard/model/CategoryResponseModel.dart';

import '../../Network/API.dart';
import '../../Network/ApiUrls.dart';
import '../../utils/Strings.dart';
import '../../utils/methods.dart';

class DashBoardController extends GetxController {
  RxList<Category> searchCategoryList = <Category>[].obs;
  List<Category> categoryList = [];
  RxString inProgressOrDataNotAvailable = "".obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getData();
  }

  getData() async {
    HttpRequestModel request = HttpRequestModel(
        url: endCategoryList,
        authMethod: '',
        body: '',
        headerType: '',
        params: '',
        method: 'POST');

    try {
      isLoading.trigger(true);
      String response = await HttpService().init(request);
      if (response.isNotEmpty) {
        CategoryResponseModel responseModel =
            CategoryResponseModel.fromJson(jsonDecode(response));
        if (responseModel.status == "1" && responseModel.list != null) {
          // prepareList(nearestStops.data!);
          // nearestApiCallTimer = Timer(Duration(seconds:), () { })
          categoryList.clear();
          searchCategoryList.clear();
          if (responseModel.list != null) {
            categoryList.addAll(responseModel.list!);
            searchCategoryList.addAll(categoryList);
          } else {
            inProgressOrDataNotAvailable.value = stringDataNotAvailable;
          }
          isLoading.trigger(false);
        } else {
          inProgressOrDataNotAvailable.value = stringDataNotAvailable;
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
