import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoes_acces/screens/cart/model/CartListResponseModel.dart';

import '../../utils/ColorConstants.dart';
import '../../utils/Constants.dart';
import '../../widgets/Widgets.dart';
import 'CartController.dart';

class CartPage extends GetView<CartController> {
  CartController controller = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: const Text("Cart"),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildSearch(context, controller.textControllerSearch, (value) {
              controller.search(value);
            }),
            const SizedBox(height: 10),
            Expanded(
              child: Container(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: colorPrimary.shade200,
                  ),
                ),
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Obx(
                  () => !controller.isLoading.value &&
                          controller.searchedCartProductList.isNotEmpty
                      ? ListView.builder(
                          itemCount: controller.searchedCartProductList.length,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          primary: true,
                          itemBuilder: (context, index) {
                            CartProductModel model =
                                controller.searchedCartProductList[index];
                            return Container(
                              height: 150,
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              decoration: BoxDecoration(
                                color: colorWhite,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: boxShadow,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 8,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Material(
                                      elevation: 2,
                                      color: colorPrimary.shade50,
                                      borderRadius: BorderRadius.circular(8),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Center(
                                          child: Image.network(
                                              model.imagePath ?? ""),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 8,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const SizedBox(height: 10),
                                          Text(
                                            "${model.proName}",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              color: colorBlack,
                                              fontSize: 20,
                                              height: 1,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Text(
                                            model.proWeight!.isEmpty
                                                ? ""
                                                : "${model.proWeight} g",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              color: colorGrayText,
                                              fontSize: 14,
                                              height: 1,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(height: 15),
                                          Row(
                                            children: [
                                              if (model.proDiscount != null &&
                                                  model.proDiscount != 0)
                                                Text(
                                                  "${model.proDiscount}₹",
                                                  textAlign: TextAlign.left,
                                                  style: const TextStyle(
                                                    color: colorGreen,
                                                    fontSize: 16,
                                                    height: 1,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              if (model.proDiscount != null &&
                                                  model.proDiscount != 0)
                                                const SizedBox(width: 5),
                                              Text(
                                                "${model.proPrice}₹",
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  color: model.proDiscount !=
                                                              null &&
                                                          model.proDiscount != 0
                                                      ? Colors.red
                                                      : colorGreen,
                                                  fontSize: model.proDiscount !=
                                                              null &&
                                                          model.proDiscount != 0
                                                      ? 12
                                                      : 16,
                                                  decoration: model
                                                                  .proDiscount !=
                                                              null &&
                                                          model.proDiscount != 0
                                                      ? TextDecoration
                                                          .lineThrough
                                                      : null,
                                                  height: 1,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        onPressed: () {},
                                        icon: const Icon(
                                          Icons.add,
                                          color: colorGreen,
                                          size: 20,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: Text(
                                          model.proQty != null
                                              ? model.proQty.toString()
                                              : "1",
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {

                                        },
                                        icon: const Icon(
                                          Icons.remove_rounded,
                                          color: colorRed,
                                          size: 20,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            );
                          },
                        )
                      : !controller.isLoading.value &&
                              controller.searchedCartProductList.isEmpty
                          ? buildNoData(
                              controller.inProgressOrDataNotAvailable.value)
                          : _buildLoading(),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Total:",
                            style: TextStyle(
                              color: colorPrimary,
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                          ),
                          Obx(
                            () => Text(
                              "${controller.total}₹",
                              style: const TextStyle(
                                color: colorBlack,
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: InkWell(
                      // onTap: controller.onLogin,
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
                                    "Place Order",
                                    style: TextStyle(
                                      color: colorWhite,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
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
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildLoading() {
    return SizedBox(
      height: 500,
      width: Get.width,
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
