import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoes_acces/screens/addressList/model/AddressListResponseModel.dart';

import '../../utils/ColorConstants.dart';
import '../../utils/Constants.dart';
import '../../widgets/ThemedTextField.dart';
import '../../widgets/Widgets.dart';
import 'AddressListController.dart';

class AddressListPage extends GetView<AddressListController> {
  AddressListController controller = Get.put(AddressListController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: const Text("Saved Address List"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            onPressed: () {
              _addOrEditAddress();
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add_rounded),
        onPressed: () {
          _addOrEditAddress();
        },
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildSearch(context, controller.textControllerSearch, (value) {
                controller.search(value);
              }),
              Obx(
                () => !controller.isLoading.value &&
                        controller.searchAddressList.isNotEmpty
                    ? ListView.builder(
                        itemCount: controller.searchAddressList.length,
                        shrinkWrap: true,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        physics: const NeverScrollableScrollPhysics(),
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
                            ),
                            margin: const EdgeInsets.only(top: 10),
                            child: Column(
                              children: [
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 15,
                                    vertical: 10,
                                  ),
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
                                Row(
                                  children: [
                                    Expanded(
                                      child: InkWell(
                                        onTap: () {
                                          print(model.id);
                                          _addOrEditAddress(
                                              isEdit: true, model: model);
                                        },
                                        child: Container(
                                          color: colorYellow,
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.all(10),
                                          child: const Text(
                                            "Edit",
                                            style: TextStyle(
                                              color: colorWhite,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: InkWell(
                                        onTap: () {},
                                        child: Container(
                                          color: colorRed,
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.all(10),
                                          child: const Text(
                                            "Delete",
                                            style: TextStyle(
                                              color: colorWhite,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
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
                            controller.searchAddressList.isEmpty
                        ? buildNoData(
                            controller.inProgressOrDataNotAvailable.value)
                        : _buildLoading(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _addOrEditAddress({bool isEdit = false, AddressModel? model}) {
    Get.bottomSheet(
      isScrollControlled: true,
      BottomSheet(
        constraints: BoxConstraints.loose(Size(Get.width, Get.height * 0.75)),
        onClosing: () {},
        builder: (context) {
          if (isEdit && model != null) {
            controller.textControllerAdd1.text = model.add1 ?? "";
            controller.textControllerAdd2.text = model.add2 ?? "";
            controller.textControllerAdd3.text = model.add3 ?? "";
            controller.textControllerArea.text = model.area ?? "";
            controller.textControllerCity.text = model.city ?? "";
            controller.textControllerPinCode.text = model.pinCode ?? "";
          }
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: GetBuilder<AddressListController>(
                builder: (controller) {
                  return Form(
                    key: controller.keyForm,
                    child: Obx(
                      () => Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 30),
                          const Text(
                            "Add Address",
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.black,
                              height: 1,
                            ),
                          ),
                          const Text(
                            "NOTE : * is mandatory fields",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.red,
                              height: 1,
                            ),
                          ),
                          const SizedBox(height: 30),
                          ThemedTextField(
                            controller: controller.textControllerAdd1,
                            borderRadiusTextField: 25,
                            hintText: "Address1 *",
                            preFix: const Icon(Icons.pin_drop_rounded),
                            keyBoardType: TextInputType.streetAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter your Street Address!";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          ThemedTextField(
                            controller: controller.textControllerAdd2,
                            borderRadiusTextField: 25,
                            hintText: "Address2 *",
                            preFix: const Icon(Icons.pin_drop_rounded),
                            keyBoardType: TextInputType.streetAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter near by address!";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          ThemedTextField(
                            controller: controller.textControllerAdd3,
                            borderRadiusTextField: 25,
                            hintText: "Address3",
                            preFix: const Icon(Icons.pin_drop_rounded),
                            keyBoardType: TextInputType.streetAddress,
                          ),
                          const SizedBox(height: 10),
                          ThemedTextField(
                            controller: controller.textControllerArea,
                            borderRadiusTextField: 25,
                            hintText: "Area *",
                            preFix: const Icon(Icons.pin_drop_rounded),
                            keyBoardType: TextInputType.streetAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter your Area Name!";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          ThemedTextField(
                            controller: controller.textControllerCity,
                            borderRadiusTextField: 25,
                            hintText: "City *",
                            preFix: const Icon(Icons.pin_drop_rounded),
                            keyBoardType: TextInputType.streetAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter your City Name!";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          ThemedTextField(
                            controller: controller.textControllerPinCode,
                            borderRadiusTextField: 25,
                            hintText: "Pin Code *",
                            preFix: const Icon(Icons.pin_drop_rounded),
                            keyBoardType: TextInputType.phone,
                            isAcceptNumbersOnly: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter your Pin Code!";
                              } else if (value.length != 6) {
                                return "Please enter valid length Pin Code!";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 30),
                          InkWell(
                            onTap: () {
                              controller.onAddressSubmit(
                                  id: isEdit && model != null
                                      ? (model.id ?? "").toString()
                                      : "0");
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: colorPrimary,
                                borderRadius: BorderRadius.circular(25),
                              ),
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: controller.isSubmitLoading.value
                                  ? const SizedBox(
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        color: colorWhite,
                                        strokeWidth: 1,
                                      ),
                                    )
                                  : const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Submit",
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
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
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
