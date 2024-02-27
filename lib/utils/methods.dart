import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

// import 'package:image_cropper/image_cropper.dart';
import 'package:image_editor_plus/image_editor_plus.dart';
import 'package:image_editor_plus/utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shoes_acces/utils/ColorConstants.dart';

import '../Network/ApiUrls.dart';

Uri getUrl(String apiName, {var params}) {
  var uri = Uri.https(baseUrl, nestedUrl + apiName, params);
  return uri;
}

bool isValidateEmail(String value) {
  if (value.isEmpty) {
    return false; //'Enter your Email Address';
  }
//r'^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$
  String pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = RegExp(pattern);

  return regex.hasMatch(value); //'Enter Valid Email Address';
}

String? validateEmail(String value) {
  if (value.isEmpty) {
    return 'Please enter email address';
  }
  if (!isValidateEmail(value)) {
    return 'Enter Valid Email Address';
  } else {
    return null;
  }
}

bool _isLoading = false;
OverlayEntry? overlayEntry;
OverlayState? overlayStates;

intiOverLay() {
  _isLoading = false;
  overlayEntry = OverlayEntry(
    builder: (context) => Container(
      color: Colors.black.withOpacity(0.5),
      child: Center(
        child: Container(
          height: 45.0,
          width: 45.0,
          decoration:
              const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
          child: Container(
            margin: const EdgeInsets.all(5.0),
            child: const CircularProgressIndicator(
              color: colorPrimary,
              strokeWidth: 2,
            ),
          ),
        ),
      ),
    ),
  );
}

getOverlay(/*BuildContext context*/) {
  // overlayStates = Overlay.of(context);
  // if (overlayEntry != null && !_isLoading && overlayStates != null) {
  //   overlayStates!.insert(overlayEntry!);
  //   _isLoading = true;
  // }
  if (!_isLoading) {
    _isLoading = true;
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: const CircularProgressIndicator(
              color: colorPrimary,
              strokeWidth: 2,
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }
}

removeOverlay() {
  log("_isLoading : $_isLoading && ${overlayEntry != null}");
  if (_isLoading) {
    // Get.back(closeOverlays: true);
    Navigator.pop(Get.overlayContext!, true);
    _isLoading = false;
  }
  // if (_isLoading && overlayEntry != null) {
  //   _isLoading = false;
  //   overlayEntry!.remove();
  // }
}

Future<File?> sendForCrop(String path) async {
  // CroppedFile? croppedFile = await ImageCropper().cropImage(
  //   sourcePath: path,
  //   aspectRatio: CropAspectRatio(ratioX: x, ratioY: y),
  //   uiSettings: [
  //     AndroidUiSettings(
  //       toolbarTitle: 'Cropper',
  //       toolbarColor: colorPrimary,
  //       toolbarWidgetColor: Colors.white,
  //       initAspectRatio: CropAspectRatioPreset.original,
  //       lockAspectRatio: true,
  //     ),
  //     IOSUiSettings(
  //       title: 'Cropper',
  //       aspectRatioLockEnabled: true,
  //     ),
  //   ],
  // );
  print(path);
  final editedImage = await Navigator.push(
    Get.context!,
    MaterialPageRoute(
      builder: (context) => ImageEditor(
        image: File(path), // <-- Uint8List of image
      ),
    ),
  );
  final convertedImage = await ImageUtils.convert(
    editedImage,
    format: 'jpeg',
    quality: 100,
  );

  Directory cacheDirectory = await getApplicationCacheDirectory();
  print(cacheDirectory.path);
  File image = await File('${cacheDirectory.path}/temp.jpg')
      .writeAsBytes(convertedImage);
  print(image.path);
  if (image != null) {
    print("IMAGE : " + image.path);
    return File(image.path);
  } else {
    return null;
  }
}
