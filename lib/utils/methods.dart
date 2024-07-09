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

// buildConfirmationDialog(
//     String title, String msg, IconData icon, void Function() onYesTap,
//     {bool isDelete = false, void Function()? onclose}) {
//   Get.dialog(
//     Dialog(
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Row(
//               children: [
//                 Material(
//                   color: colorPrimary,
//                   borderRadius: BorderRadius.circular(8),
//                   child: Padding(
//                     padding: const EdgeInsets.all(10),
//                     child: Icon(
//                       icon,
//                       color: colorWhite,
//                       size: 30,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 Text(
//                   title,
//                   style: const TextStyle(
//                     fontWeight: FontWeight.w500,
//                     color: colorPrimary,
//                     fontSize: 30,
//                   ),
//                 )
//               ],
//             ),
//             const SizedBox(height: 10),
//             Divider(color: colorPrimary.shade100),
//             const SizedBox(height: 20),
//             Text(
//               msg,
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontWeight: FontWeight.w500,
//                 color: colorPrimary.shade300,
//                 fontSize: 18,
//                 height: 1,
//               ),
//             ),
//             const SizedBox(height: 20),
//             Divider(color: colorPrimary.shade100),
//             const SizedBox(height: 10),
//             Row(
//               children: [
//                 Expanded(
//                   child: InkWell(
//                     onTap: onYesTap,
//                     child: Container(
//                       decoration: BoxDecoration(
//                         color: colorRed,
//                         borderRadius: BorderRadius.circular(25),
//                       ),
//                       alignment: Alignment.center,
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 20, vertical: 10),
//                       child: const Text(
//                         "Yes",
//                         style: TextStyle(
//                           color: colorWhite,
//                           fontWeight: FontWeight.w500,
//                           fontSize: 18,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 Expanded(
//                   child: InkWell(
//                     onTap: () {
//                       Get.back();
//                     },
//                     child: Container(
//                       decoration: BoxDecoration(
//                         color: colorGreen,
//                         borderRadius: BorderRadius.circular(25),
//                       ),
//                       alignment: Alignment.center,
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 20, vertical: 10),
//                       child: const Text(
//                         "No",
//                         style: TextStyle(
//                           color: colorWhite,
//                           fontWeight: FontWeight.w500,
//                           fontSize: 18,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     ),
//   ).then((value) {
//     if (onclose != null) onclose;
//   });
// }
