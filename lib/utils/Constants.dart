import 'dart:io';

import 'package:flutter/material.dart';

bool trustSelfSigned = true;

HttpClient getHttpClient() {
  HttpClient httpClient = HttpClient()
    ..connectionTimeout = const Duration(seconds: 10)
    ..badCertificateCallback =
        ((X509Certificate cert, String host, int port) => trustSelfSigned);

  return httpClient;
}

List<BoxShadow> boxShadow = [
  BoxShadow(
    color: Colors.grey.shade400,
    blurRadius: 3,
    spreadRadius: 0,
    offset: const Offset(0, 1),
  ),
];


const double spaceVertical = 8;
const double spaceHorizontal = 10;
const double radius = 6;

BorderRadius boxBorderRadius = BorderRadius.circular(radius);
double elevation = 2;


class Constants {
  static bool isFromPaymentConfirmation = false;
}
