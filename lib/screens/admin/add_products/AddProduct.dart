import 'dart:ffi';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoes_acces/screens/admin/add_products/AddProductController.dart';
import 'package:shoes_acces/utils/Constants.dart';
import 'package:shoes_acces/widgets/Widgets.dart';

import '../../../utils/ColorConstants.dart';
import '../../../widgets/ThemedTextField.dart';
import '../../users/dashboard/model/CategoryResponseModel.dart';
import '../dashboard/DashBoardAdminController.dart';

class AddProduct extends GetView<AddProductController> {
  AddProductController controller = Get.put(AddProductController());
  DashBoardAdminController controllerDashboard =
      Get.find(tag: "DashBoardAdminController");

  AddProduct({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: const Text("Add Product"),
      ),
      body: GetBuilder<AddProductController>(
        builder: (controller) => Form(
          key: controller.keyForm.value,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (controller.isForUpdate)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            height: 200,
                            width: Get.width - 10,
                            child: controller.image != null
                                ? InkWell(
                                    onTap: () {
                                      _buildPikeImageChooseDialog();
                                    },
                                    child: AspectRatio(
                                      aspectRatio: 3 / 3.5,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: colorPrimary.shade300,
                                            width: 1,
                                          ),
                                          borderRadius: boxBorderRadius,
                                        ),
                                        child: controller.image != null
                                            ? Image.file(controller.image!)
                                            : const Center(
                                                child: Text(
                                                  "Add Image",
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                      ),
                                    ),
                                  )
                                : Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: colorPrimary.shade300,
                                        width: 1,
                                      ),
                                      borderRadius: boxBorderRadius,
                                    ),
                                    margin: const EdgeInsets.all(2),
                                    padding: const EdgeInsets.all(2),
                                    child: CachedNetworkImage(
                                      imageUrl: controller.imageUpdateList[
                                          controller.indexSelectedImage.value],
                                      imageBuilder: (context, imageProvider) {
                                        return Container(
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
                                    )),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            height: 100,
                            child: Row(
                              children: [
                                Expanded(
                                  child: ListView.builder(
                                    itemCount:
                                        controller.imageUpdateList.length,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onTap: () {
                                          controller.indexSelectedImage
                                              .trigger(index);
                                        },
                                        child: AspectRatio(
                                          aspectRatio: 3 / 3.5,
                                          child: Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5),
                                              clipBehavior:
                                                  Clip.antiAliasWithSaveLayer,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: colorPrimary.shade300,
                                                  width: 1,
                                                ),
                                                borderRadius: boxBorderRadius,
                                              ),
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    controller.imageUpdateList[
                                                        controller
                                                            .indexSelectedImage
                                                            .value],
                                                imageBuilder:
                                                    (context, imageProvider) {
                                                  return Container(
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
                                                  value:
                                                      downloadProgress.progress,
                                                  color: colorPrimary,
                                                  strokeWidth: 2,
                                                )),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const Icon(Icons.error),
                                              )),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: 100,
                                  child: InkWell(
                                    onTap: () {
                                      _buildPikeImageChooseDialog();
                                    },
                                    child: AspectRatio(
                                      aspectRatio: 3 / 3.5,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: colorPrimary.shade300,
                                            width: 1,
                                          ),
                                          borderRadius: boxBorderRadius,
                                        ),
                                        child: Center(
                                          child: Text(
                                            controller.image != null
                                                ? "Change Image"
                                                : "Add Image",
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    if (!controller.isForUpdate)
                      SizedBox(
                        height: 200,
                        child: InkWell(
                          onTap: () {
                            _buildPikeImageChooseDialog();
                          },
                          child: AspectRatio(
                            aspectRatio: 3 / 3.5,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: colorPrimary.shade300,
                                  width: 1,
                                ),
                                borderRadius: boxBorderRadius,
                              ),
                              child: controller.image != null
                                  ? Image.file(controller.image!)
                                  : const Center(
                                      child: Text("Selecte Image"),
                                    ),
                            ),
                          ),
                        ),
                      ),
                    // SizedBox(
                    //   height: 200,
                    //   child: InkWell(
                    //     onTap: () {
                    //       _buildPikeImageChooseDialog();
                    //     },
                    //     child: AspectRatio(
                    //       aspectRatio: 3 / 3.5,
                    //       child: Container(
                    //         decoration: BoxDecoration(
                    //           border: Border.all(
                    //             color: colorPrimary.shade300,
                    //             width: 1,
                    //           ),
                    //           borderRadius: boxBorderRadius,
                    //         ),
                    //         child: controller.image != null
                    //             ? Image.file(controller.image!)
                    //             : const Center(
                    //                 child: Text("Add Image"),
                    //               ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
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
                      controller: controller.controllerProductCode,
                      borderRadiusTextField: 25,
                      hintText: "Product Code",
                      keyBoardType: TextInputType.name,
                      preFix: const Icon(Icons.code),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter you full name!";
                        } else if (value.length > 10) {
                          return "Code length has to be less then 10 characters";
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: colorPrimary.shade100,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        children: [
                          Icon(
                            Icons.category_rounded,
                            size: 20,
                            color: colorPrimary.shade100,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: DropdownButton<CategoryModel>(
                              value: controller.selectedCategory,
                              isExpanded: true,
                              underline: Container(),
                              hint: Text(
                                "Select Category*",
                                style: TextStyle(color: colorPrimary.shade200),
                              ),
                              iconEnabledColor: colorPrimary.shade200,
                              items: controller.controllerDashboard.categoryList
                                  .map(
                                    (e) => DropdownMenuItem<CategoryModel>(
                                      value: e,
                                      child: Text(e.catName ?? ""),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) {
                                controller.selectedCategory = value;
                                controller.update();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    ThemedTextField(
                      controller: controller.controllerPrice,
                      borderRadiusTextField: 25,
                      hintText: "Price ₹",
                      keyBoardType: const TextInputType.numberWithOptions(
                          signed: false, decimal: true),
                      preFix: Text(
                        "₹",
                        style: TextStyle(color: colorPrimary.shade200),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter you full name!";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    ThemedTextField(
                      controller: controller.controllerPriceDiscount,
                      borderRadiusTextField: 25,
                      hintText: "Discounted Price in ₹",
                      keyBoardType: const TextInputType.numberWithOptions(
                          signed: false, decimal: true),
                      preFix: Text(
                        "₹",
                        style: TextStyle(color: colorPrimary.shade200),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter you full name!";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    ThemedTextField(
                      controller: controller.controllerSGST,
                      borderRadiusTextField: 25,
                      hintText: "SGST in ₹",
                      keyBoardType: const TextInputType.numberWithOptions(
                          signed: false, decimal: true),
                      preFix: Text(
                        "TAX",
                        style: TextStyle(color: colorPrimary.shade200),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter you full name!";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    ThemedTextField(
                      controller: controller.controllerCGST,
                      borderRadiusTextField: 25,
                      hintText: "CGST in ₹",
                      keyBoardType: const TextInputType.numberWithOptions(
                          signed: false, decimal: true),
                      preFix: Text(
                        "TAX",
                        style: TextStyle(color: colorPrimary.shade200),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter you full name!";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    ThemedTextField(
                      controller: controller.controllerCourierCharges,
                      borderRadiusTextField: 25,
                      hintText: "Courier Charges in ₹",
                      keyBoardType: const TextInputType.numberWithOptions(
                          signed: false, decimal: true),
                      preFix: Text(
                        "CC",
                        style: TextStyle(color: colorPrimary.shade200),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter you full name!";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    ThemedTextField(
                      controller: controller.controllerWeight,
                      borderRadiusTextField: 25,
                      hintText: "Weight in grm",
                      keyBoardType: const TextInputType.numberWithOptions(
                          signed: false, decimal: true),
                      preFix: Text(
                        "KGs",
                        style: TextStyle(color: colorPrimary.shade200),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter you full name!";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    InkWell(
                      onTap: controller.onSave,
                      child: Container(
                        decoration: BoxDecoration(
                          color: colorPrimary,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: controller.isLoading.value
                            ? buildButtonProgressIndicator()
                            : const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Save",
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
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _buildPikeImageChooseDialog() {
    Get.bottomSheet(
      BottomSheet(
        onClosing: () {},
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 30),
                const Text(
                  "Pick Image From",
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.black,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 10),
                Divider(
                  color: colorPrimary.shade100,
                  height: 1,
                ),
                ListTile(
                  title: const Text(
                    'Camera',
                  ),
                  leading: const Icon(
                    Icons.camera_alt_rounded,
                    color: colorPrimary,
                  ),
                  onTap: () async {
                    controller.pickImageFromCamera();
                  },
                ),
                ListTile(
                  title: const Text(
                    'Gallery',
                  ),
                  leading: const Icon(
                    Icons.photo_rounded,
                    color: colorPrimary,
                  ),
                  onTap: () async {
                    controller.pickImageFromGallery();
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
