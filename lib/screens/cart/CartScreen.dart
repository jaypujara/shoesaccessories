import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoes_acces/screens/cart/model/CartListResponseModel.dart';

import '../../utils/ColorConstants.dart';
import '../../utils/Constants.dart';
import '../../widgets/Widgets.dart';
import '../addressList/model/AddressListResponseModel.dart';
import 'CartController.dart';

class CartPage extends GetView<CartController> {
  CartController controller = Get.find(tag: "CartController");

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
            buildSearch(controller.textControllerSearch, (value) {
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
                                vertical: 10,
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
                                          child: CachedNetworkImage(
                                            imageUrl: model.imagePath ?? "",
                                            imageBuilder:
                                                (context, imageProvider) {
                                              return Container(
                                                color: Colors.white,
                                                child:
                                                    Image(image: imageProvider),
                                              );
                                            },
                                            progressIndicatorBuilder: (context,
                                                    url, downloadProgress) =>
                                                Center(
                                              child: CircularProgressIndicator(
                                                value:
                                                    downloadProgress.progress,
                                                color: colorPrimary,
                                                strokeWidth: 2,
                                              ),
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(Icons.error),
                                          ),
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
                                            style: const TextStyle(
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
                                            style: const TextStyle(
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
                                        onPressed: () async {
                                          print((model.proQty ?? 1) + 1);
                                          await controller.addToCart(
                                              productId: model.proId ?? "",
                                              quantity: (model.proQty ?? 1) + 1,
                                              cartId: (model.cartId ?? 0)
                                                  .toString());
                                        },
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
                                          (model.proQty ?? 1).toString(),
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () async {
                                          if ((model.proQty ?? 1) > 1) {
                                            await controller.addToCart(
                                                productId: model.proId ?? "",
                                                quantity:
                                                    (model.proQty ?? 1) - 1,
                                                cartId: (model.cartId ?? 0)
                                                    .toString());
                                          } else {
                                            buildConfirmationDialog(
                                                icon: Icons
                                                    .delete_forever_rounded,
                                                title: "Delete From Cart",
                                                msg:
                                                    "Are you sure you want to remove this product from the cart?",
                                                onYesTap: () {
                                                  Get.back();
                                                  controller.deleteFromCart(
                                                      (model.cartId ?? 0)
                                                          .toString());
                                                });
                                          }
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
                      child: Obx(
                        () => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (controller.subTotal != controller.total)
                              Text(
                                "${controller.subTotal}₹",
                                style: const TextStyle(
                                  color: colorRed,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            Text(
                              "${controller.total}₹",
                              style: const TextStyle(
                                color: colorGreen,
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: InkWell(
                      onTap: () {
                        _buildAddressListDialog();
                      },
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
                                child: CircularProgressIndicator(
                                  color: colorPrimary,
                                  strokeWidth: 2,
                                ),
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
            const SizedBox(height: 8),
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
        child: CircularProgressIndicator(
          color: colorPrimary,
          strokeWidth: 2,
        ),
      ),
    );
  }

  _buildAddressListDialog() {
    controller.getAddressData();
    Get.bottomSheet(
        // isScrollControlled: true,
        BottomSheet(
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return GetX<CartController>(
              tag: "CartController",
              builder: (controller) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      child: Text(
                        "Select Address",
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.black,
                          height: 1,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    buildSearch(controller.textControllerAddressSearch,
                        (value) {
                      controller.search(value);
                    }),
                    Expanded(
                      child: !controller.isAddressLoading.value &&
                              controller.searchAddressList.isNotEmpty
                          ? ListView.builder(
                              itemCount: controller.searchAddressList.length,
                              shrinkWrap: true,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              primary: true,
                              itemBuilder: (context, index) {
                                AddressModel model =
                                    controller.searchAddressList[index];
                                return Container(
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  decoration: BoxDecoration(
                                    color: colorWhite,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: boxShadow,
                                    border:
                                        controller.selectedAddressIndex.value ==
                                                index
                                            ? Border.all(
                                                color: colorPrimary.shade300,
                                                width: 2,
                                              )
                                            : null,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 15,
                                    vertical: 10,
                                  ),
                                  margin: const EdgeInsets.only(top: 10),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(10),
                                    onTap: () {
                                      controller.selectedAddressIndex.value =
                                          index;
                                      print(controller
                                          .selectedAddressIndex.value);
                                      setState(() {});
                                      controller.placeOrder(
                                          addressId: model.id ?? 0);
                                      Get.back();
                                    },
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const SizedBox(height: 10),
                                        Text(
                                          "${model.createdBy}",
                                          textAlign: TextAlign.left,
                                          style: const TextStyle(
                                            color: colorBlack,
                                            fontSize: 20,
                                            height: 1,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Divider(color: colorPrimary.shade100),
                                        const SizedBox(height: 5),
                                        Text(
                                          model.add1 ?? "",
                                          textAlign: TextAlign.left,
                                          style: const TextStyle(
                                            color: colorGrayText,
                                            fontSize: 14,
                                            height: 1,
                                          ),
                                        ),
                                        Text(
                                          model.add2 ?? "",
                                          textAlign: TextAlign.left,
                                          style: const TextStyle(
                                            color: colorGrayText,
                                            fontSize: 14,
                                            height: 1,
                                          ),
                                        ),
                                        Text(
                                          model.add3 ?? "",
                                          textAlign: TextAlign.left,
                                          style: const TextStyle(
                                            color: colorGrayText,
                                            fontSize: 14,
                                            height: 1,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          "City : ${model.city ?? ""}",
                                          textAlign: TextAlign.left,
                                          style: const TextStyle(
                                            color: colorBlack,
                                            fontSize: 16,
                                            height: 1,
                                          ),
                                        ),
                                        Text(
                                          "Area : ${model.area ?? ""}",
                                          textAlign: TextAlign.left,
                                          style: const TextStyle(
                                            color: colorBlack,
                                            fontSize: 16,
                                            height: 1,
                                          ),
                                        ),
                                        Text(
                                          "Pin : ${model.pinCode}",
                                          textAlign: TextAlign.left,
                                          style: const TextStyle(
                                            color: colorBlack,
                                            fontSize: 16,
                                            height: 1,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            )
                          : !controller.isAddressLoading.value &&
                                  controller.searchAddressList.isEmpty
                              ? buildNoData(
                                  controller.inProgressOrDataNotAvailable.value)
                              : _buildLoading(),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
      onClosing: () {},
    ));
  }
}