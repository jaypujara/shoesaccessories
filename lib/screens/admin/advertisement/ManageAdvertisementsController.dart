import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../../../Network/API.dart';
import '../../../Network/ApiUrls.dart';
import '../../../utils/ColorConstants.dart';
import '../../../utils/Strings.dart';
import '../../../utils/methods.dart';
import '../../../widgets/Widgets.dart';
import '../../users/dashboard/model/AdvertisementResponseModel.dart';

class ManageAdvertisementsController extends GetxController {
  RxList imageList = [].obs;
  RxBool isLoading = false.obs;
  RxString inProgressOrDataNotAvailable = "".obs;
  bool isUpdated = false;

  @override
  void onInit() {
    super.onInit();
    getAdvertisement();
  }

  getAdvertisement() async {
    HttpRequestModel request = HttpRequestModel(
        url: endAdvertisementList,
        authMethod: '',
        body: '',
        headerType: '',
        params: '',
        method: 'POST');

    try {
      isLoading.trigger(true);
      String response = await HttpService().init(request);
      if (response.isNotEmpty) {
        AdvertisementResponseModel responseModel =
            AdvertisementResponseModel.fromJson(jsonDecode(response));
        if (responseModel.status == "1" &&
            responseModel.imagePathList != null) {
          imageList.clear();
          imageList.value = responseModel.imagePathList!
              .map((e) => e.imagePath ?? "")
              .toList();
        } else {
          imageList.clear();
          inProgressOrDataNotAvailable.value = stringDataNotAvailable;
        }
      } else {
        imageList.clear();
        inProgressOrDataNotAvailable.value = stringDataNotAvailable;
      }
    } catch (e) {
      log("ERROR: NS ${e.toString()}");
      imageList.clear();
      inProgressOrDataNotAvailable.value = stringDataNotAvailable;
    } finally {
      isLoading.trigger(false);
    }
  }

  pickImageFromCamera() async {
    Get.back();
    final ImagePicker picker = ImagePicker();
    final XFile? img = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 10,
    );
    if (img != null) {
      print(img.path);
      uploadImage(img.path);
      // image = File(img.path);
    }
  }

  pickImageFromGallery() async {
    Get.back();
    final ImagePicker picker = ImagePicker();
    XFile? img = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 10,
    );
    if (img != null) {
      print(img.path);
      uploadImage(img.path);
      // image = File(img.path);
    }
  }

  uploadImage(String imagePath) async {
    try {
      getOverlay();
      var postUri = getUrl(endUploadAdvertisementFiles);
      var request = http.MultipartRequest("POST", postUri);
      request.files
          .add(await http.MultipartFile.fromPath('FileName', imagePath));
      await request.send().then((response) async {
        if (response.statusCode == 200) {
          print("SUCCESS");
          showSnackBarWithText(Get.context, "Image Uploaded Successfully.",
              color: colorGreen);
          getAdvertisement();
          isUpdated = true;
        } else {
          showSnackBarWithText(
              Get.context, response.reasonPhrase ?? "Image upload failed!");
        }
      });
    } catch (e) {
      print(e);
    } finally {
      removeOverlay();
    }
  }

  deleteImage(String imagePath) async {
    HttpRequestModel request = HttpRequestModel(
        url: endAdvertisementFilesDelete,
        authMethod: '',
        body: '',
        headerType: '',
        params: json.encode({
          "FileName": imagePath.split("/").last ?? "",
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
          await CachedNetworkImage.evictFromCache(imagePath ?? "");
          removeOverlay();
          isUpdated = true;
          getAdvertisement();
        } else {
          showSnackBarWithText(Get.context, responseJson["Message"]);
        }
      } else {
        showSnackBarWithText(Get.context, stringSomeThingWentWrong);
      }
    } catch (e) {
      log("ERROR: $endDeleteCart ${e.toString()}");
      showSnackBarWithText(Get.context, stringSomeThingWentWrong);
    } finally {
      removeOverlay();
    }
  }
}
