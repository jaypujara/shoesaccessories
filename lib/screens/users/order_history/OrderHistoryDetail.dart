import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoes_acces/screens/users/order_history/OrderHistoryDetailController.dart';

import '../../../utils/ColorConstants.dart';
import '../../../utils/Constants.dart';
import '../dashboard/DashBoardController.dart';
import 'model/OrderHistoryListResponseModel_V2.dart';

class OrderHistoryDetail extends GetView<OrderHistoryDetailController> {
  final controller = Get.put(OrderHistoryDetailController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: controller,
        builder: (context) {
          return controller.model != null
              ? Scaffold(
                  appBar: AppBar(
                    title: Text("Order Detail :${controller.model!.orderId}"),
                    titleSpacing: 0,
                  ),
                  body: Container(
                    margin: const EdgeInsets.only(top: 10),
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
                                  const Text(
                                    "Order date",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      color: colorBlack,
                                      fontSize: 20,
                                      height: 1,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    "${controller.model!.orderDate}",
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
                                  !controller.isAdmin
                                      ? Text(
                                          controller.model!.status ??
                                              "Order Placed",
                                          textAlign: TextAlign.left,
                                          style: const TextStyle(
                                              color: colorGreen,
                                              fontSize: 16,
                                              height: 1,
                                              fontWeight: FontWeight.w500),
                                        )
                                      : DropdownButton<int>(
                                          value: controller.model!.statusCode,
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
                                            if (value != null &&
                                                controller.model!.statusCode !=
                                                    value) {
                                              controller.updateOrderStatus(
                                                orderId:
                                                    controller.model!.orderId ??
                                                        0,
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
                        const SizedBox(height: 10),
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
                                "${controller.model!.expectedDeliveryDate}",
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
                                "${controller.model!.address}",
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
                        const SizedBox(height: 5),
                        Divider(color: colorPrimary.shade100),
                        const SizedBox(height: 5),
                        ListView.builder(
                          itemCount: controller.model!.orderhistoryDetV2 != null
                              ? controller.model!.orderhistoryDetV2!.length
                              : 0,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            OrderhistoryDetV2 modelProduct =
                                controller.model!.orderhistoryDetV2![index];
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
                                              clipBehavior:
                                                  Clip.antiAliasWithSaveLayer,
                                              backgroundColor: colorWhite,
                                              insetPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20),
                                              child: AspectRatio(
                                                aspectRatio: 1 / 1,
                                                child: CachedNetworkImage(
                                                  imageUrl:
                                                      modelProduct.imagePath ??
                                                          "",
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
                                          );
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: Center(
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  modelProduct.imagePath ?? "",
                                              imageBuilder:
                                                  (context, imageProvider) {
                                                return Container(
                                                  color: Colors.white,
                                                  child: Image(
                                                      image: imageProvider),
                                                );
                                              },
                                              progressIndicatorBuilder: (context,
                                                      url, downloadProgress) =>
                                                  Center(
                                                      child:
                                                          CircularProgressIndicator(
                                                value:
                                                    downloadProgress.progress,
                                                color: colorPrimary,
                                                strokeWidth: 2,
                                              )),
                                              errorWidget:
                                                  (context, url, error) =>
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
                      ],
                    ),
                  ),
                )
              : Scaffold(
                  appBar: AppBar(
                    title: const Text("Order Detail"),
                    titleSpacing: 0,
                  ),
                  body: const Center(
                    child: Text("No Data"),
                  ),
                );
        });
  }

  _buildGetStatusText(int status) {
    switch (status) {
      case 1:
        return const Text("Accepted");
      case 2:
        return const Text("Dispatch");

      case 3:
        return const Text("Delivered");

      default:
        return const Text("Order Placed");
    }
  }
}
