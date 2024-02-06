import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/ColorConstants.dart';
import '../../../widgets/Widgets.dart';
import 'ManageAdvertisementsController.dart';

class ManageAdvertisements extends GetView<ManageAdvertisementsController> {
  ManageAdvertisementsController controller =
      Get.put(ManageAdvertisementsController());

  ManageAdvertisements({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: const Text("Manage Advertisements"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.back(result: controller.isUpdated);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add_rounded),
            onPressed: () {
              _buildPikeImageChooseDialog();
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _buildPikeImageChooseDialog();
        },
        child: const Icon(
          Icons.add,
          color: colorWhite,
        ),
      ),
      body: Obx(
        () => !controller.isLoading.value && controller.imageList.isNotEmpty
            ? _buildList()
            : !controller.isLoading.value && controller.imageList.isEmpty
                ? buildNoData(controller.inProgressOrDataNotAvailable.value)
                : _buildLoading(),
      ),
    );
  }

  Widget _buildList() {
    return ListView.builder(
      itemCount: controller.imageList.length,
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(vertical: 10),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(10),
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CachedNetworkImage(
                  imageUrl: controller.imageList[index] ?? "",
                  fit: BoxFit.cover,
                  imageBuilder: (context, imageProvider) {
                    return Container(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Image(image: imageProvider, fit: BoxFit.cover),
                    );
                  },
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      Center(
                    child: CircularProgressIndicator(
                      value: downloadProgress.progress,
                      color: colorPrimary,
                      strokeWidth: 2,
                    ),
                  ),
                  errorWidget: (context, url, error) =>
                      const Icon(Icons.image_rounded, size: 40),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                      iconSize: 16,
                      style: IconButton.styleFrom(
                        backgroundColor: colorRed,
                        padding: const EdgeInsets.all(0),
                        minimumSize: const Size(30, 30),
                        maximumSize: const Size(30, 30),
                      ),
                      color: colorRed,
                      icon: const Icon(
                        Icons.delete_forever_rounded,
                        color: colorWhite,
                      ),
                      onPressed: () {
                        buildConfirmationDialog(
                          title: "Delete",
                          msg: "Are you sure you want to delete this category?",
                          icon: Icons.delete_forever_rounded,
                          onYesTap: () {
                            Get.back();
                            controller
                                .deleteImage(controller.imageList[index] ?? "");
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
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
