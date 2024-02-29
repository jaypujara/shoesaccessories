import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shoes_acces/screens/users/cart/CartController.dart';
import 'package:shoes_acces/screens/users/dashboard/DashBoardPage.dart';
import 'package:shoes_acces/utils/ColorConstants.dart';

import 'model/CartListResponseModel.dart';

class OrderPlacedResult extends StatefulWidget {
  const OrderPlacedResult({super.key});

  @override
  State<OrderPlacedResult> createState() => _OrderPlacedResultState();
}

class _OrderPlacedResultState extends State<OrderPlacedResult> {
  CartController cartController = Get.find(tag: "CartController");

  List<CartProductModel> dataList = [];

  @override
  void initState() {
    dataList.addAll(cartController.cartProductList);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Get.offAll(() => DashBoardPage());
        return Future(() => false);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text("Order Placement"),
          titleSpacing: 0,
        ),
        body: Center(
          child: Obx(() => AnimatedSwitcher(
                duration: const Duration(seconds: 1),
                child: cartController.isOrderPlacementLoading.value
                    ? const CircularProgressIndicator()
                    : cartController.isOrderPlacementSuccessFull.value
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Thank You",
                                style: TextStyle(
                                  color: colorPrimary,
                                  fontSize: 36,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const Text(
                                  "Your order has been placed successfully."),
                              Padding(
                                padding: const EdgeInsets.all(20),
                                child: SvgPicture.asset(
                                  "assets/svgs/order_success_vector.svg",
                                  height: Get.height / 2,
                                ),
                              ),
                              SizedBox(
                                width: Get.width - 40,
                                child: FilledButton.tonal(
                                  onPressed: () {
                                    Get.offAll(() => DashBoardPage());
                                  },
                                  child: const Text("HOME"),
                                ),
                              ),
                            ],
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Ohh! Sorry",
                                style: TextStyle(
                                  color: colorRed,
                                  fontSize: 36,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const Text("Some thing went wrong!"),
                              const Text("Order placement unsuccessful"),
                              const SizedBox(height: 50),
                              Container(
                                decoration: const BoxDecoration(
                                  color: colorRed,
                                  shape: BoxShape.circle,
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(20),
                                  child: Icon(
                                    Icons.close_rounded,
                                    color: colorWhite,
                                    size: 140,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 30),
                              SizedBox(
                                width: Get.width / 2,
                                child: FilledButtonTheme(
                                  data: FilledButtonThemeData(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.red.shade100),
                                    ),
                                  ),
                                  child: FilledButton.tonal(
                                    onPressed: () {
                                      Get.back();
                                    },
                                    child: const Text("Close"),
                                  ),
                                ),
                              ),
                            ],
                          ),
              )),
        ),
      ),
    );
  }
}
