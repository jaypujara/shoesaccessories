import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoes_acces/screens/users/cart/CartScreen.dart';

import '../../../utils/ColorConstants.dart';
import '../../../utils/Constants.dart';
import '../../../widgets/Widgets.dart';
import '../cart/CartController.dart';
import 'ShoesListController.dart';
import 'model/ProductResponseModel.dart';

class ShoesListPage extends StatefulWidget {
  const ShoesListPage({super.key});

  @override
  State<ShoesListPage> createState() => _ShoesListPageState();
}

class _ShoesListPageState extends State<ShoesListPage> {
  ShoesListController controller = Get.put(ShoesListController());
  CartController controllerCart = Get.find(tag: "CartController");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Text(Get.arguments["cat_name"].toString()),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildSearch(controller.textControllerSearch, (value) {
                      controller.search(value);
                    }),
                    Obx(
                      () => !controller.isLoading.value &&
                              controller.searchShoesList.isNotEmpty
                          ? ListView.builder(
                              itemCount: controller.searchShoesList.length,
                              shrinkWrap: true,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              physics: const NeverScrollableScrollPhysics(),
                              primary: true,
                              itemBuilder: (context, index) {
                                Product model =
                                    controller.searchShoesList[index];
                                return Container(
                                  height: 150,
                                  margin: const EdgeInsets.only(top: 10),
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
                                          color: colorWhite,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: InkWell(
                                            onTap: () {
                                              Get.dialog(
                                                Dialog(
                                                  clipBehavior: Clip
                                                      .antiAliasWithSaveLayer,
                                                  backgroundColor: colorWhite,
                                                  insetPadding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 20),
                                                  child: AspectRatio(
                                                    aspectRatio: 1 / 1,
                                                    child: CachedNetworkImage(
                                                      imageUrl:
                                                          model.imagePath ?? "",
                                                      imageBuilder: (context,
                                                          imageProvider) {
                                                        return Container(
                                                          color: Colors.white,
                                                          child: Image(
                                                              image:
                                                                  imageProvider),
                                                        );
                                                      },
                                                      progressIndicatorBuilder:
                                                          (context, url,
                                                                  downloadProgress) =>
                                                              Center(
                                                                  child:
                                                                      CircularProgressIndicator(
                                                        value: downloadProgress
                                                            .progress,
                                                        color: colorPrimary,
                                                        strokeWidth: 2,
                                                      )),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          const Icon(
                                                              Icons.error),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.all(8),
                                              child: Center(
                                                child: CachedNetworkImage(
                                                  imageUrl:
                                                      model.imagePath ?? "",
                                                  imageBuilder:
                                                      (context, imageProvider) {
                                                    return Container(
                                                      color: Colors.white,
                                                      child: Image(
                                                          image: imageProvider),
                                                    );
                                                  },
                                                  progressIndicatorBuilder: (context,
                                                          url,
                                                          downloadProgress) =>
                                                      Center(
                                                          child:
                                                              CircularProgressIndicator(
                                                    value: downloadProgress
                                                        .progress,
                                                    color: colorPrimary,
                                                    strokeWidth: 2,
                                                  )),
                                                  errorWidget: (context, url,
                                                          error) =>
                                                      const Icon(Icons.error),
                                                ),
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
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
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
                                                    : "${model.proWeight}",
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
                                                  if (model.proDiscount !=
                                                          null &&
                                                      model.proDiscount != 0)
                                                    Text(
                                                      "${model.proDiscount}₹",
                                                      textAlign: TextAlign.left,
                                                      style: const TextStyle(
                                                        color: colorGreen,
                                                        fontSize: 16,
                                                        height: 1,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  if (model.proDiscount !=
                                                          null &&
                                                      model.proDiscount != 0)
                                                    const SizedBox(width: 5),
                                                  Text(
                                                    "${model.proPrice}₹",
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                      color: model.proDiscount !=
                                                                  null &&
                                                              model.proDiscount !=
                                                                  0
                                                          ? Colors.red
                                                          : colorGreen,
                                                      fontSize: model.proDiscount !=
                                                                  null &&
                                                              model.proDiscount !=
                                                                  0
                                                          ? 12
                                                          : 16,
                                                      decoration:
                                                          model.proDiscount !=
                                                                      null &&
                                                                  model.proDiscount !=
                                                                      0
                                                              ? TextDecoration
                                                                  .lineThrough
                                                              : null,
                                                      height: 1,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      (model.model != null)
                                          ? Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                IconButton(
                                                  onPressed: () async {
                                                    log(((model.model!.proQty ??
                                                                1) +
                                                            1)
                                                        .toString());
                                                    await controllerCart.addToCart(
                                                        productId:
                                                            model.proId ?? "",
                                                        quantity: (model.model!
                                                                    .proQty ??
                                                                1) +
                                                            1,
                                                        cartId: (model.model!
                                                                    .cartId ??
                                                                0)
                                                            .toString());
                                                    controller
                                                        .mapWithCartList();
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
                                                    (model.model!.proQty ?? 1)
                                                        .toString(),
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                ),
                                                IconButton(
                                                  onPressed: () async {
                                                    if ((model.model!.proQty ??
                                                            1) >
                                                        1) {
                                                      await controllerCart.addToCart(
                                                          productId:
                                                              model.proId ?? "",
                                                          quantity: (model
                                                                      .model!
                                                                      .proQty ??
                                                                  1) -
                                                              1,
                                                          cartId: (model.model!
                                                                      .cartId ??
                                                                  0)
                                                              .toString());
                                                      controller
                                                          .mapWithCartList();
                                                    } else {
                                                      await buildConfirmationDialog(
                                                          icon: Icons
                                                              .delete_forever_rounded,
                                                          title:
                                                              "Delete From Cart",
                                                          msg:
                                                              "Are you sure you want to remove this product from the cart?",
                                                          onYesTap: () async {
                                                            await controllerCart
                                                                .deleteFromCart(
                                                                    (model.model!.cartId ??
                                                                            0)
                                                                        .toString())
                                                                .then((v) {
                                                              Future.delayed(
                                                                  const Duration(
                                                                      seconds:
                                                                          1),
                                                                  () {
                                                                controller
                                                                    .mapWithCartList();
                                                              });
                                                              model.model =
                                                                  null;
                                                              Get.back();
                                                            });
                                                          },
                                                          onClose: () {
                                                            log("ENCLOSE");
                                                            controller
                                                                .mapWithCartList();
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
                                          : IconButton(
                                              icon: const Icon(
                                                Icons.add_shopping_cart_rounded,
                                                color: colorPrimary,
                                              ),
                                              onPressed: () async {
                                                await controllerCart.addToCart(
                                                    productId:
                                                        model.proId ?? "");
                                                controller.mapWithCartList();
                                              },
                                            ),
                                    ],
                                  ),
                                );
                              },
                            )
                          : !controller.isLoading.value &&
                                  controller.searchShoesList.isEmpty
                              ? buildNoData(
                                  controller.inProgressOrDataNotAvailable.value)
                              : _buildLoading(),
                    ),
                  ],
                ),
              ),
            ),
            Obx(
              () => controllerCart.cartProductList.isNotEmpty
                  ? Container(
                      margin: const EdgeInsets.only(
                          bottom: 10, left: 10, right: 10),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 15),
                      decoration: BoxDecoration(
                        color: colorGreen,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: boxShadow,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${controllerCart.cartProductList.length} Items added",
                            style: const TextStyle(
                              color: colorWhite,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Get.to(() => CartPage());
                            },
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "View Cart",
                                  style: TextStyle(
                                    color: colorWhite,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(width: 3),
                                Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: colorWhite,
                                  size: 16,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(),
            )
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
}