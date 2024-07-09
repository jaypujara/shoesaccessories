import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoes_acces/screens/users/order_history/model/OrderHistoryListResponseModel_V2.dart';

import '../../../utils/ColorConstants.dart';
import '../../../utils/Constants.dart';
import '../../../widgets/Widgets.dart';
import '../../users/order_history/OrderHistoryDetail.dart';
import '../../users/order_history/model/OrderHistoryListResponseModel.dart';
import 'OrderHistoryListControllerAdmin.dart';

class OrderHistoryListAdmin extends GetView<OrderHistoryListControllerAdmin> {
  OrderHistoryListControllerAdmin controller = Get.put(
      OrderHistoryListControllerAdmin(),
      tag: "OrderHistoryListControllerAdmin");

  OrderHistoryListAdmin({super.key});

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
                          // Orders model = controller.searchOrderList[index];
                          return _buildOrderItem(
                              controller.searchOrderList[index]);
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

  _buildOrderItem(Orders model) {
    return InkWell(
      onTap: () async {
        await Get.to(() => OrderHistoryDetail(), arguments: {
          "isAdmin": true,
          "model": model,
        });
        controller.getData();
      },
      child: Container(
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                    crossAxisAlignment: CrossAxisAlignment.end,
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
                      DropdownButton<int>(
                        value: model.statusCode,
                        items: const [
                          DropdownMenuItem(
                            value: 0,
                            child: Text("Order Placed"),
                          ),
                          DropdownMenuItem(
                            value: 1,
                            child: Text("Accepted"),
                          ),
                          DropdownMenuItem(
                            value: 2,
                            child: Text("Dispatch"),
                          ),
                          DropdownMenuItem(
                            value: 3,
                            child: Text("Delivered"),
                          ),
                        ],
                        padding: EdgeInsets.zero,
                        onChanged: (int? value) {
                          if (value != null && model.statusCode != value) {
                            controller.updateOrderStatus(
                              orderId: model.orderId ?? 0,
                              state: value,
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Divider(color: colorPrimary.shade100),
            /*const SizedBox(height: 5),
            ListView.builder(
              itemCount: model.orderhistoryDetV2 != null
                  ? model.orderhistoryDetV2!.length
                  : 0,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                OrderhistoryDetV2 modelProduct = model.orderhistoryDetV2![index];
                return Container(
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
                          borderRadius: BorderRadius.circular(8),
                          child: InkWell(
                            onTap: () {
                              Get.dialog(
                                Dialog(
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  backgroundColor: colorWhite,
                                  insetPadding:
                                      const EdgeInsets.symmetric(horizontal: 20),
                                  child: AspectRatio(
                                    aspectRatio: 1 / 1,
                                    child: CachedNetworkImage(
                                      imageUrl: modelProduct.imagePath ?? "",
                                      imageBuilder: (context, imageProvider) {
                                        return Container(
                                          color: Colors.white,
                                          child: Image(image: imageProvider),
                                        );
                                      },
                                      progressIndicatorBuilder: (context, url,
                                              downloadProgress) =>
                                          Center(
                                              child: CircularProgressIndicator(
                                        value: downloadProgress.progress,
                                        color: colorPrimary,
                                        strokeWidth: 2,
                                      )),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    ),
                                  ),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Center(
                                child: CachedNetworkImage(
                                  imageUrl: modelProduct.imagePath ?? "",
                                  imageBuilder: (context, imageProvider) {
                                    return Container(
                                      color: Colors.white,
                                      child: Image(image: imageProvider),
                                    );
                                  },
                                  progressIndicatorBuilder:
                                      (context, url, downloadProgress) => Center(
                                          child: CircularProgressIndicator(
                                    value: downloadProgress.progress,
                                    color: colorPrimary,
                                    strokeWidth: 2,
                                  )),
                                  errorWidget: (context, url, error) =>
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(height: 10),
                              Text(
                                "${modelProduct.productName}",
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
                                "Code : ${modelProduct.productCode}",
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                  fontSize: 12,
                                  height: 1,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  // if (model.productTotal !=
                                  //         null &&
                                  //     model.productTotal != 0)
                                  Text(
                                    "${modelProduct.totalAmount}₹",
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(
                                      color: colorGreen,
                                      fontSize: 16,
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "QTY",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            (modelProduct.qty ?? 1).toString(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 10),*/
            // Divider(color: colorPrimary.shade100),
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
