import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoes_acces/screens/splash/SplashController.dart';
import 'package:shoes_acces/utils/ColorConstants.dart';

class SplashPage extends GetView<SplashController> {
  SplashController controller = Get.put(SplashController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorPrimary,
      body: Center(
        child: Obx(
          () => AnimatedContainer(
            duration: const Duration(seconds: 2),
            curve: Curves.bounceOut,
            width: controller.animate.value ? Get.width * .7 : 0,
            height: controller.animate.value ? Get.width * .7 : 0,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.all(10),
            child: Image.asset("assets/images/logo.png"),
          ),
        ),
      ),
    );
  }
}

/*
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
        log("EMAIL : $email");
        if (email.isEmpty) {
          Get.offAll(() => LoginPage());
        } else {
          String password =
              await Preferences().getPrefString(Preferences.prefPassword);
          signIn(email, password);
          // Get.offAll(() => isAdminLogin ? DashBoardAdmin() : DashBoardPage());
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

  signIn(String email, String password) async {
    HttpRequestModel request = HttpRequestModel(
        url: endLogin,
        authMethod: '',
        body: '',
        headerType: '',
        params:
            json.encode({"Loginuser": email, "Password": password}).toString(),
        method: 'POST');

    try {
      // getOverlay(Get.context!);
      isLoading.trigger(true);
      String response = await HttpService().init(request);
      if (response.isNotEmpty) {
        var jsonResponse = json.decode(response);
        if (jsonResponse["Status"] == "1") {
          showSnackBarWithText(Get.context, jsonResponse["Message"],
              color: colorGreen);
          await Preferences().setPrefString(
              Preferences.prefCustId, jsonResponse["Data"]["Cus_Id"]);
          await Preferences().setPrefString(
              Preferences.prefFullName, jsonResponse["Data"]["Cus_FullName"]);
          await Preferences().setPrefString(Preferences.prefEmail, email);
          await Preferences().setPrefString(Preferences.prefPassword, password);
          Get.offAll(() => DashBoardPage());
        } else {
          showSnackBarWithText(Get.context, jsonResponse["Message"]);
        }
      } else {
        showSnackBarWithText(Get.context, stringSomeThingWentWrong);
      }
    } catch (e) {
      log("ERROR: NS ${e.toString()}");
      showSnackBarWithText(Get.context, stringSomeThingWentWrong);
    } finally {
      isLoading.trigger(false);
    }
  }
}
*/
