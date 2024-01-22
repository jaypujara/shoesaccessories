import 'package:flutter/material.dart';

import 'ColorConstants.dart';

showSnackBarWithText(BuildContext? context, String strText,
    {Color color = Colors.redAccent,
    int duration = 2,
    void Function()? onPressOfOk}) {
  final snackBar = SnackBar(
    backgroundColor: color,
    content: Text(
      strText,
      style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w400,
          fontFamily: 'Poppins'),
    ),
    action: SnackBarAction(
      label: 'OK',
      textColor: Colors.white,
      onPressed: onPressOfOk ?? () {},
    ),
    duration: Duration(seconds: duration),
  );
  if (context != null) {
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

Widget buildNoData(String data) {
  return SizedBox(
    height: 300,
    child: Center(
      child: Text(
        data,
        style: TextStyle(
          color: colorBlack,
          fontWeight: FontWeight.w500,
          fontSize: 20,
        ),
      ),
    ),
  );
}
