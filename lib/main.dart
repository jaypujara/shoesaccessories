import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shoes_acces/screens/splash/SplashPage.dart';
import 'package:shoes_acces/screens/users/cart/CartController.dart';
import 'package:shoes_acces/utils/ColorConstants.dart';

void main() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shoe Accessory',
      defaultTransition: Transition.fadeIn,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: colorPrimary),
        useMaterial3: true,
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: colorPrimary,
        ),
      ),
      home: SplashPage(),
      onInit: () {
        Get.put(CartController(), tag: "CartController");
      },
      // home: const Demo(),
    );
  }
}
