import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoes_acces/screens/admin/categories/AddCategoryController.dart';
import 'package:shoes_acces/utils/Constants.dart';
import 'package:shoes_acces/widgets/Widgets.dart';

import '../../../utils/ColorConstants.dart';
import '../../../widgets/ThemedTextField.dart';

class AddCategory extends GetView<AddCategoryController> {
  AddCategoryController controller = Get.put(AddCategoryController());

  AddCategory({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: const Text("Add Category"),
      ),
      body: GetBuilder<AddCategoryController>(
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
