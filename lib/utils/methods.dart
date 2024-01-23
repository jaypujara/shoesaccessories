

import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
final OverlayEntry overlayEntry = OverlayEntry(
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
            backgroundColor: Colors.green,
            strokeWidth: 5.0,
          ),
        ),
      ),
    ),
  ),
);
OverlayState? overlayStates;

getOverlay(BuildContext context) {
  overlayStates = Overlay.of(context);

  if (overlayEntry != null && !_isLoading && overlayStates != null) {
    overlayStates!.insert(overlayEntry);
    _isLoading = true;
  }
}

removeOverlay() {
  log("_isLoading : $_isLoading && ${overlayEntry != null}");
  if (_isLoading && overlayEntry != null) {
    _isLoading = false;
    overlayEntry.remove();
  }
}