import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoes_acces/screens/dashboard/DashBoardPage.dart';
import 'package:shoes_acces/screens/login/LoginPage.dart';

import '../../utils/Preferences.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(
      const Duration(seconds: 3),
      () async {
        String email = await Preferences().getPrefString(Preferences.prefEmail);
        print("EMAIL : $email");
        if (email.isEmpty) {
          Get.offAll(() => LoginPage());
        } else {
          Get.offAll(() => DashBoardPage());
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("SPLASH"),
      ),
    );
  }
}
