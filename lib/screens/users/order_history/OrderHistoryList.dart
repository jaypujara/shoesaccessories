import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/ColorConstants.dart';
import '../../../utils/Constants.dart';
import '../../../widgets/Widgets.dart';
import 'OrderHistoryDetail.dart';
import 'OrderHistoryListController.dart';
import 'package:shoes_acces/screens/users/order_history/model/OrderHistoryListResponseModel_V2.dart';

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
                          Orders model = controller.searchOrderList[index];
                          return InkWell(
                            onTap: () {
                              Get.to(() => OrderHistoryDetail(), arguments: {
                                "isAdmin": false,
                                "model": model,
                              });
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
                                  const SizedBox(height: 10),
                                  Divider(color: colorPrimary.shade100),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
