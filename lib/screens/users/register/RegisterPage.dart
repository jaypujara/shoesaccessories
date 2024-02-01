import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Network/GlobalMethods.dart';
import '../../../utils/ColorConstants.dart';
import '../../../widgets/ThemedTextField.dart';
import 'RegisterController.dart';

class RegisterPage extends GetView<RegisterController> {
  RegisterController controller = Get.put(RegisterController());

  RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        shadowColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Obx(
          () {
            return Form(
              key: controller.keyForm.value,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/logo.png",
                      height: 130,
                      width: 130,
                    ),
                    const SizedBox(height: 30),
                    ThemedTextField(
                      controller: controller.controllerName,
                      borderRadiusTextField: 25,
                      hintText: "Full Name",
                      keyBoardType: TextInputType.name,
                      preFix: const Icon(Icons.person),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter you full name!";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    ThemedTextField(
                      controller: controller.controllerNumber,
                      borderRadiusTextField: 25,
                      hintText: "Mobile Number",
                      preFix: const Icon(Icons.phone_android_rounded),
                      keyBoardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter you number!";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: 40,
                      decoration: BoxDecoration(
                        border: Border.all(color: colorPrimary),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Stack(
                        children: [
                          Transform.translate(
                            offset: Offset(
                                controller.isGenderMale.value
                                    ? 0
                                    : (Get.width - 40) / 2,
                                0),
                            child: Container(
                              height: 50,
                              width: (Get.width - 40) / 2,
                              decoration: BoxDecoration(
                                color: colorPrimary,
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    controller.isGenderMale.trigger(true);
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.male_rounded,
                                          color: controller.isGenderMale.value
                                              ? colorWhite
                                              : colorPrimary,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          "Male",
                                          style: TextStyle(
                                            color: controller.isGenderMale.value
                                                ? colorWhite
                                                : colorPrimary,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    controller.isGenderMale.trigger(false);
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.female_rounded,
                                          color: controller.isGenderMale.value
                                              ? colorPrimary
                                              : colorWhite,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          "Female",
                                          style: TextStyle(
                                            color: controller.isGenderMale.value
                                                ? colorPrimary
                                                : colorWhite,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    ThemedTextField(
                      controller: controller.controllerEmail,
                      borderRadiusTextField: 25,
                      hintText: "Email",
                      preFix: const Icon(Icons.email_outlined),
                      keyBoardType: TextInputType.text,
                      validator: (p0) {
                        return validateEmail(p0);
                      },
                    ),
                    const SizedBox(height: 10),
                    ThemedTextField(
                      controller: controller.controllerPassword,
                      borderRadiusTextField: 25,
                      keyBoardType: TextInputType.visiblePassword,
                      hintText: "Password",
                      preFix: const Icon(Icons.password_rounded),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter password!";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    ThemedTextField(
                      controller: controller.controllerConfirmPassword,
                      borderRadiusTextField: 25,
                      hintText: "Confirm Password",
                      preFix: const Icon(Icons.password_rounded),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter confirm password!";
                        } else if (value !=
                            controller.controllerPassword.text) {
                          return "Password and Confirm Password has to be same!";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),
                    InkWell(
                      onTap: controller.onRegister,
                      child: Container(
                        decoration: BoxDecoration(
                          color: colorPrimary,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: controller.isLoading.value
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Sign Up",
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
                        Get.back();
                      },
                      child: const Text(
                        "Already Have an Account? Sign In",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          height: 1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
