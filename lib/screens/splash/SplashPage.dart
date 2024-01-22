import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../dashboard/DashBoardPage.dart';

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
      () {
        Get.offAll(() => DashBoardPage());
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
