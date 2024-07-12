import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoes_acces/screens/admin/add_products/AddProduct.dart';

import '../../../utils/ColorConstants.dart';
import '../../../utils/Constants.dart';
import '../../../widgets/Widgets.dart';
import '../../users/shoeList/model/ProductResponseModel.dart';
import 'ADShoesListController.dart';

class ADShoesListPage extends StatefulWidget {
  const ADShoesListPage({super.key});

  @override
  State<ADShoesListPage> createState() => _ADShoesListPageState();
}

class _ADShoesListPageState extends State<ADShoesListPage> {
  ADShoesListController controller = Get.put(ADShoesListController());

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
                                  margin: const EdgeInsets.only(top: 10),
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  decoration: BoxDecoration(
                                    color: colorWhite,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: boxShadow,
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        height: 150,
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 10,
                                                  vertical: 8,
                                                ),
                                                child: Row(
                                                  children: [
                                                    AspectRatio(
                                                      aspectRatio: 3 / 3.5,
                                                      child: Material(
                                                        elevation: 2,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        clipBehavior: Clip
                                                            .antiAliasWithSaveLayer,
                                                        child: InkWell(
                                                          onTap: () {
                                                            _buildImageDialog(
                                                                model.imagePath !=
                                                                        null
                                                                    ? model
                                                                        .imagePath!
                                                                        .split(
                                                                            ",")
                                                                        .first
                                                                    : "");
                                                          },
                                                          child: Center(
                                                            child:
                                                                CachedNetworkImage(
                                                              imageUrl: model
                                                                          .imagePath !=
                                                                      null
                                                                  ? model
                                                                      .imagePath!
                                                                      .split(
                                                                          ",")
                                                                      .first
                                                                  : "",
                                                              imageBuilder:
                                                                  (context,
                                                                      imageProvider) {
                                                                return Container(
                                                                  color: Colors
                                                                      .white,
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
                                                                  color:
                                                                      colorPrimary,
                                                                  strokeWidth:
                                                                      2,
                                                                ),
                                                              ),
                                                              errorWidget: (context,
                                                                      url,
                                                                      error) =>
                                                                  const Icon(Icons
                                                                      .error),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 3,
                                                      child: Container(
                                                        width: double.infinity,
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                          horizontal: 10,
                                                          vertical: 8,
                                                        ),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            const SizedBox(
                                                                height: 10),
                                                            Text(
                                                              "${model.proName}",
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              maxLines: 2,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style:
                                                                  const TextStyle(
                                                                color:
                                                                    colorBlack,
                                                                fontSize: 20,
                                                                height: 1,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                            ),
                                                            Text(
                                                              "Code : ${model.proCode}",
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              style:
                                                                  const TextStyle(
                                                                color:
                                                                    colorGrayText,
                                                                fontSize: 14,
                                                                height: 1,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                            ),
                                                            Text(
                                                              model.proWeight!
                                                                      .isEmpty
                                                                  ? ""
                                                                  : "${model.proWeight}",
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              style:
                                                                  const TextStyle(
                                                                color:
                                                                    colorGrayText,
                                                                fontSize: 14,
                                                                height: 1,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                height: 15),
                                                            Row(
                                                              children: [
                                                                if (model.proDiscount !=
                                                                        null &&
                                                                    model.proDiscount !=
                                                                        0)
                                                                  Text(
                                                                    "${model.proDiscount}₹",
                                                                    textAlign:
                                                                        TextAlign
                                                                            .left,
                                                                    style:
                                                                        const TextStyle(
                                                                      color:
                                                                          colorGreen,
                                                                      fontSize:
                                                                          16,
                                                                      height: 1,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                    ),
                                                                  ),
                                                                if (model.proDiscount !=
                                                                        null &&
                                                                    model.proDiscount !=
                                                                        0)
                                                                  const SizedBox(
                                                                      width: 5),
                                                                Text(
                                                                  "${model.proPrice}₹",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                  style:
                                                                      TextStyle(
                                                                    color: model.proDiscount !=
                                                                                null &&
                                                                            model.proDiscount !=
                                                                                0
                                                                        ? Colors
                                                                            .red
                                                                        : colorGreen,
                                                                    fontSize: model.proDiscount !=
                                                                                null &&
                                                                            model.proDiscount !=
                                                                                0
                                                                        ? 12
                                                                        : 16,
                                                                    decoration: model.proDiscount !=
                                                                                null &&
                                                                            model.proDiscount !=
                                                                                0
                                                                        ? TextDecoration
                                                                            .lineThrough
                                                                        : null,
                                                                    height: 1,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Column(
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    color: colorYellow,
                                                    child: IconButton(
                                                      icon: const Icon(
                                                        Icons.edit_rounded,
                                                        color: colorWhite,
                                                      ),
                                                      onPressed: () async {
                                                        var result =
                                                            await Get.to(
                                                          () => AddProduct(),
                                                          arguments: {
                                                            "model": model,
                                                            "catId": int.parse(
                                                                controller
                                                                    .catId),
                                                          },
                                                        );
                                                        if (result != null &&
                                                            result == true) {
                                                          controller.getData();
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    color: colorRed,
                                                    child: IconButton(
                                                      icon: const Icon(
                                                        Icons
                                                            .delete_forever_rounded,
                                                        color: colorWhite,
                                                      ),
                                                      onPressed: () async {
                                                        buildConfirmationDialog(
                                                          title:
                                                              "Delete Confirmation!",
                                                          msg:
                                                              "Are you sure you want to delete this Product?",
                                                          icon: Icons
                                                              .delete_forever_rounded,
                                                          onYesTap: () {
                                                            Get.back();
                                                            controller
                                                                .changeStatusOfProduct(
                                                              categoryId:
                                                                  model.proId ??
                                                                      "",
                                                              isActive: false,
                                                            );
                                                          },
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Divider(
                                        color: colorWhite,
                                        height: 1,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: InkWell(
                                              onTap: () {
                                                controller
                                                    .changeStatusOfProduct(
                                                  categoryId: model.proId ?? "",
                                                  isActive: true,
                                                );
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: model.isProductActive
                                                      ? colorGreen
                                                      : null,
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  vertical: 10,
                                                ),
                                                child: Text(
                                                  "Enabled",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: model.isProductActive
                                                        ? colorWhite
                                                        : colorGrayText,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: InkWell(
                                              onTap: () {
                                                controller
                                                    .changeStatusOfProduct(
                                                  categoryId: model.proId ?? "",
                                                  isActive: false,
                                                );
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: model.isProductActive
                                                      ? null
                                                      : colorRed,
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  vertical: 10,
                                                ),
                                                child: Text(
                                                  "Disabled",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: model.isProductActive
                                                        ? colorGrayText
                                                        : colorWhite,
                                                  ),
                                                ),
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
                                  controller.searchShoesList.isEmpty
                              ? buildNoData(
                                  controller.inProgressOrDataNotAvailable.value)
                              : _buildLoading(),
                    ),
                  ],
                ),
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

  void _buildImageDialog(String path) {
    Get.dialog(
      Dialog(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        backgroundColor: colorWhite,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        child: AspectRatio(
          aspectRatio: 3 / 3.5,
          child: CachedNetworkImage(
            imageUrl: path,
            imageBuilder: (context, imageProvider) {
              return Container(
                color: Colors.white,
                child: Image(image: imageProvider),
              );
            },
            progressIndicatorBuilder: (context, url, downloadProgress) =>
                Center(
                    child: CircularProgressIndicator(
              value: downloadProgress.progress,
              color: colorPrimary,
              strokeWidth: 2,
            )),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
      ),
    );
  }
}
