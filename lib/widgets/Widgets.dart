import 'package:flutter/material.dart';

import '../utils/ColorConstants.dart';

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
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: colorBlack,
          fontWeight: FontWeight.w500,
          fontSize: 20,
        ),
      ),
    ),
  );
}

Widget buildSearch(BuildContext context, TextEditingController controller,
    void Function(String)? onChanged) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10),
    child: TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: "Search here....",
        hintStyle: TextStyle(
          color: colorPrimary.shade200,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide(
            color: colorPrimary.shade200,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide(
            color: colorPrimary.shade200,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide(
            color: colorPrimary.shade200,
          ),
        ),
        prefixIcon: const Icon(Icons.search_rounded),
        suffixIcon: IconButton(
          onPressed: () {
            controller.clear();
          },
          icon: Icon(Icons.close_rounded, color: colorPrimary.shade200),
        ),
        prefixIconColor: colorPrimary.shade200,
      ),
      onChanged: onChanged,
    ),
  );
}
