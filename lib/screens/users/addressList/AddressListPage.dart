import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoes_acces/screens/users/addressList/model/AddressListResponseModel.dart';
import 'package:shoes_acces/utils/ColorConstants.dart';
import 'package:shoes_acces/utils/Constants.dart';
import 'package:shoes_acces/widgets/ThemedTextField.dart';
import 'package:shoes_acces/widgets/Widgets.dart';

import 'AddressListController.dart';

class AddressListPage extends GetView<AddressListController> {
  AddressListController controller = Get.put(AddressListController());

  AddressListPage({super.key, bool isWithAddAddressDialog = false}) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (isWithAddAddressDialog) {
        _addOrEditAddress();
      }
    });
  }

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
              buildSearch(controller.textControllerSearch, (value) {
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
                                        onTap: () {
                                          _buildDeleteConfirmation(
                                              (model.id ?? -1).toString());
                                        },
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

  _buildDeleteConfirmation(String addressId) {
    Get.dialog(
      Dialog(
        backgroundColor: colorWhite,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Material(
                    color: colorPrimary,
                    borderRadius: BorderRadius.circular(8),
                    child: const Padding(
                      padding: EdgeInsets.all(10),
                      child: Icon(
                        Icons.delete_forever_rounded,
                        color: colorWhite,
                        size: 30,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    "Delete Address",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: colorPrimary,
                      fontSize: 28,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10),
              Divider(color: colorPrimary.shade100),
              const SizedBox(height: 20),
              Text(
                "Are you sure yo want to delete this address?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: colorPrimary.shade300,
                  fontSize: 18,
                  height: 1,
                ),
              ),
              const SizedBox(height: 20),
              Divider(color: colorPrimary.shade100),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        await controller.onAddressDelete(id: addressId);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: colorRed,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: const Text(
                          "Yes",
                          style: TextStyle(
                            color: colorWhite,
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: colorGreen,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: const Text(
                          "No",
                          style: TextStyle(
                            color: colorWhite,
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _addOrEditAddress({bool isEdit = false, AddressModel? model}) {
    controller.error.value = "";
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
                          const SizedBox(height: 15),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              controller.error.value,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.red,
                                height: 1,
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
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
                                  ? buildButtonProgressIndicator()
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
        child: CircularProgressIndicator(
          color: colorPrimary,
          strokeWidth: 2,
        ),
      ),
    );
  }
}
