import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shoes_acces/screens/users/dashboard/DashBoardPage.dart';
import 'package:shoes_acces/utils/ColorConstants.dart';
import 'package:shoes_acces/widgets/ThemedTextField.dart';

import '../../utils/Preferences.dart';
import '../../widgets/Widgets.dart';
import '../users/register/RegisterPage.dart';
import 'LoginController.dart';

class LoginPage extends GetView<LoginController> {
  LoginController controller = Get.put(LoginController());

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Obx(
              () =>
              Form(
                key: controller.keyForm,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 5),
                      Image.asset(
                        "assets/images/logo_new.png",
                        height: 150,
                        width: 130,
                      ),
                      const Text(
                        "Hello!",
                        style: TextStyle(
                          fontSize: 60,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          height: 1,
                        ),
                      ),
                      const Text(
                        "Sign in to your account",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          height: 1,
                        ),
                      ),
                      const SizedBox(height: 40),
                      ThemedTextField(
                        controller: controller.controllerEmail,
                        borderRadiusTextField: 25,
                        hintText: "Email Or Phone No",
                        preFix: const Icon(Icons.email_outlined),
                        validator: (p0) {
                          if (p0 == null || p0.isEmpty) {
                            return "Please enter email or phone number!";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      ThemedTextField(
                        controller: controller.controllerPassword,
                        borderRadiusTextField: 25,
                        hintText: "Password",
                        preFix: const Icon(Icons.password_rounded),
                        isPasswordTextField: true,
                        validator: (p0) {
                          if (p0 == null || p0.isEmpty) {
                            return "Please enter Password!";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 30),
                      InkWell(
                        onTap: controller.onLogin,
                        child: Container(
                          decoration: BoxDecoration(
                            color: colorPrimary,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          child: controller.isLoading.value
                              ? buildButtonProgressIndicator()
                              : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Sign In",
                                style: TextStyle(
                                  color: colorWhite,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                ),
                              ),
                              SizedBox(width: 10),
                              Icon(
                                Icons.arrow_circle_right_outlined,
                                color: colorWhite,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      InkWell(
                        onTap: () {
                          Get.bottomSheet(
                            BottomSheet(
                              onClosing: () {},
                              builder: (context) {
                                return Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const SizedBox(height: 30),
                                      const Text(
                                        "Forgot Password?",
                                        style: TextStyle(
                                          fontSize: 24,
                                          color: Colors.black,
                                          height: 1,
                                        ),
                                      ),
                                      const SizedBox(height: 30),
                                      ThemedTextField(
                                        controller:
                                        controller.controllerForgotNumber,
                                        borderRadiusTextField: 25,
                                        hintText: "Mobile Number / Email",
                                        preFix: const Icon(
                                            Icons.alternate_email_rounded),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Please enter your registered Mobile Number or Email!";
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 30),
                                      InkWell(
                                        onTap: controller.onForgotSend,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: colorPrimary,
                                            borderRadius: BorderRadius.circular(
                                                25),
                                          ),
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 10),
                                          child: const Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Submit",
                                                style: TextStyle(
                                                  color: colorWhite,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 18,
                                                ),
                                              ),
                                              SizedBox(width: 10),
                                              Icon(
                                                Icons
                                                    .arrow_circle_right_outlined,
                                                color: colorWhite,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                    ],
                                  ),
                                );
                              },
                            ),
                          );
                        },
                        child: const Text(
                          "Forgot Password?",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            height: 1,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      InkWell(
                        onTap: () {
                          Get.to(() => RegisterPage());
                        },
                        child: const Text(
                          "Don't have account? Create One",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            height: 1,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Divider(),
                      // const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // IconButton.filledTonal(
                          //   onPressed: () {
                          //     controller.signWithGoogle();
                          //   },
                          //   icon: SvgPicture.asset("assets/svgs/svg_google.svg"),
                          // ),
                          // const SizedBox(width: 10),
                          // IconButton.filledTonal(
                          //   onPressed: () {
                          //     controller.signWithFacebook();
                          //   },
                          //   icon: SvgPicture.asset("assets/svgs/svg_facebook.svg"),
                          // ),
                          // const SizedBox(width: 10),
                          // const Text("OR"),
                          // const SizedBox(width: 10),
                          FilledButton.tonal(
                            onPressed: () async {
                              await Preferences()
                                  .setPrefBool(Preferences.prefIsGuest, true);
                              Get.off(DashBoardPage());
                            },
                            child: const Text("Continue as Guest"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
        ),
      ),
    );
  }
}
