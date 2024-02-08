import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/ColorConstants.dart';
import '../../../utils/Constants.dart';
import '../../../widgets/Widgets.dart';
import 'OrderHistoryListController.dart';
import 'model/OrderHistoryListResponseModel.dart';

class OrderHistoryList extends GetView<OrderHistoryListController> {
  OrderHistoryListController controller = Get.put(OrderHistoryListController());

  OrderHistoryList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: const Text("Order History"),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildSearch(controller.textControllerSearch, (value) {
              controller.search(value);
            }),
            Expanded(
              child: Obx(
                () => !controller.isLoading.value &&
                        controller.searchOrderList.isNotEmpty
                    ? ListView.builder(
                        itemCount: controller.searchOrderList.length,
                        shrinkWrap: true,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        primary: true,
                        itemBuilder: (context, index) {
                          OrderModel model = controller.searchOrderList[index];
                          return Container(
                            margin: const EdgeInsets.only(top: 10),
                            decoration: BoxDecoration(
                              color: colorWhite,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: boxShadow,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 20,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Flexible(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Order Id : ${model.orderId}",
                                            textAlign: TextAlign.left,
                                            style: const TextStyle(
                                              color: colorBlack,
                                              fontSize: 20,
                                              height: 1,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            "${model.orderDate}",
                                            textAlign: TextAlign.left,
                                            style: const TextStyle(
                                              color: colorPrimary,
                                              fontSize: 12,
                                              height: 1,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Flexible(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          const Text(
                                            "Status",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              color: colorBlack,
                                              fontSize: 12,
                                              height: 1,
                                            ),
                                          ),
                                          const SizedBox(height: 3),
                                          Text(
                                            model.status ?? "Order Placed",
                                            textAlign: TextAlign.left,
                                            style: const TextStyle(
                                                color: colorGreen,
                                                fontSize: 16,
                                                height: 1,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Divider(color: colorPrimary.shade100),
                                const SizedBox(height: 5),
                                Container(
                                  height: 130,
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
                                        flex: 4,
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
                                                "${model.productName}",
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
                                              const SizedBox(height: 15),
                                              Row(
                                                children: [
                                                  // if (model.productTotal !=
                                                  //         null &&
                                                  //     model.productTotal != 0)
                                                  Text(
                                                    "${model.totalAmount}₹",
                                                    textAlign: TextAlign.left,
                                                    style: const TextStyle(
                                                      color: colorGreen,
                                                      fontSize: 16,
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
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Text(
                                            "QTY",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                          Text(
                                            (model.qty ?? 1).toString(),
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontSize: 18,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                /*Text(
                                  "${model.productName}",
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                    color: colorPrimary,
                                    fontSize: 16,
                                    height: 1,
                                  ),
                                ),
                                Text(
                                  model.qty == null ? "" : "Qty : ${model.qty}",
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                    color: colorGrayText,
                                    fontSize: 14,
                                    height: 1,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    if (model.totalAmount != null &&
                                        model.totalAmount != 0)
                                      Text(
                                        "${model.totalAmount}₹",
                                        textAlign: TextAlign.left,
                                        style: const TextStyle(
                                          color: colorGreen,
                                          fontSize: 16,
                                          height: 1,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    if (model.totalAmount != null &&
                                        model.totalAmount != 0)
                                      const SizedBox(width: 5),
                                    Text(
                                      "${model.subTotal}₹",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        color: model.totalAmount != null &&
                                                model.totalAmount != 0
                                            ? Colors.red
                                            : colorGreen,
                                        fontSize: model.totalAmount != null &&
                                                model.totalAmount != 0
                                            ? 12
                                            : 16,
                                        decoration: model.totalAmount != null &&
                                                model.totalAmount != 0
                                            ? TextDecoration.lineThrough
                                            : null,
                                        height: 1,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),*/
                                const SizedBox(height: 10),
                                Divider(color: colorPrimary.shade100),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Expected Delivery",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        color: colorGrayText,
                                        fontSize: 14,
                                        height: 1,
                                      ),
                                    ),
                                    const Text(
                                      " : ",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        color: colorGrayText,
                                        fontSize: 14,
                                        height: 1,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        "${model.expectedDeliveryDate}",
                                        textAlign: TextAlign.left,
                                        style: const TextStyle(
                                          color: colorGrayText,
                                          fontSize: 14,
                                          height: 1,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Address ",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        color: colorGrayText,
                                        fontSize: 14,
                                        height: 1,
                                      ),
                                    ),
                                    const Text(
                                      " : ",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        color: colorGrayText,
                                        fontSize: 14,
                                        height: 1,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        "${model.address}",
                                        textAlign: TextAlign.left,
                                        style: const TextStyle(
                                          color: colorGrayText,
                                          fontSize: 14,
                                          height: 1,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      )
                    : !controller.isLoading.value &&
                            controller.searchOrderList.isEmpty
                        ? buildNoData(
                            controller.inProgressOrDataNotAvailable.value)
                        : _buildLoading(),
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
        child: CircularProgressIndicator(
          color: colorPrimary,
          strokeWidth: 2,
        ),
      ),
    );
  }
}
