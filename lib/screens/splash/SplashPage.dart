import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoes_acces/screens/dashboard/DashBoardPage.dart';
import 'package:shoes_acces/screens/login/LoginPage.dart';
import 'package:shoes_acces/utils/ColorConstants.dart';

import '../../utils/Preferences.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool animate = false;

  @override
  void initState() {
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

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Future.delayed(
        const Duration(milliseconds: 200),
        () {
          setState(() {
            animate = true;
          });
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorPrimary,
      body: Center(
        child: AnimatedContainer(
          duration: const Duration(seconds: 2),
          curve: Curves.bounceOut,
          width: animate ? Get.width * .7 : 0,
          height: animate ? Get.width * .7 : 0,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(10),
          child: Image.asset("assets/images/logo.png"),
        ),
      ),
    );
  }
}
