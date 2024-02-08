import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoes_acces/screens/admin/add_products/AddProduct.dart';
import 'package:shoes_acces/screens/admin/categories/AddCategory.dart';
import 'package:shoes_acces/screens/admin/shoeList/ADShoesListPage.dart';
import 'package:shoes_acces/screens/users/dashboard/model/CategoryResponseModel.dart';
import 'package:shoes_acces/utils/ColorConstants.dart';
import 'package:shoes_acces/utils/Constants.dart';
import 'package:shoes_acces/widgets/Widgets.dart';

import '../../../utils/Preferences.dart';
import '../../splash/SplashPage.dart';
import '../advertisement/ManageAdvertisements.dart';
import 'DashBoardAdminController.dart';

class DashBoardAdmin extends GetView<DashBoardAdminController> {
  DashBoardAdminController controller =
      Get.put(DashBoardAdminController(), tag: "DashBoardAdminController");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: controller.keyScaffold,
      appBar: AppBar(
        title: const Text("Admin Shoe Accessory"),
        titleSpacing: 0,
      ),
      drawer: _buildDrawer(),
      body: Column(
        children: [
          Obx(
            () => controller.imageList.isNotEmpty
                ? _buildSlider()
                : const SizedBox(),
          ),
          Expanded(
            child: Obx(
              () => !controller.isLoading.value &&
                      controller.searchCategoryList.isNotEmpty
                  ? _buildList()
                  : !controller.isLoading.value &&
                          controller.searchCategoryList.isEmpty
                      ? buildNoData(
                          controller.inProgressOrDataNotAvailable.value)
                      : _buildLoading(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSlider() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AspectRatio(
          aspectRatio: 16 / 9,
          child: CarouselSlider(
            carouselController: CarouselController(),
            items: controller.imageList
                .map(
                  (e) => Stack(
                    fit: StackFit.expand,
                    children: [
                      CachedNetworkImage(
                        imageUrl: e ?? "",
                        fit: BoxFit.cover,
                        imageBuilder: (context, imageProvider) {
                          return Container(
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child:
                                Image(image: imageProvider, fit: BoxFit.cover),
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
                                msg:
                                    "Are you sure you want to delete this category?",
                                icon: Icons.delete_forever_rounded,
                                onYesTap: () {
                                  Get.back();
                                  controller.deleteImage(e);
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                )
                .toList(),
            options: CarouselOptions(
              // aspectRatio: 16 / 9,
              viewportFraction: .8,
              initialPage: 0,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 3),
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              autoPlayCurve: Curves.easeInOutSine,
              enlargeCenterPage: true,
              enlargeFactor: 0.2,
              onPageChanged: (index, reason) {
                controller.indexSlider.value = index;
              },
              scrollDirection: Axis.horizontal,
            ),
          ),
        ),
        const SizedBox(height: 10),
        DotsIndicator(
          dotsCount: controller.imageList.length,
          position: controller.indexSlider.value,
          mainAxisSize: MainAxisSize.min,
          decorator: const DotsDecorator(
            activeSize: Size(7, 7),
            activeColor: colorPrimary,
            size: Size(5, 5),
            spacing: EdgeInsets.symmetric(horizontal: 3),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildList() {
    return GridView.builder(
      itemCount: controller.searchCategoryList.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 3 / 3.5,
      ),
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      itemBuilder: (context, index) {
        CategoryModel model = controller.searchCategoryList[index];
        return Container(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          decoration: BoxDecoration(
            color: colorWhite,
            borderRadius: boxBorderRadius,
            boxShadow: boxShadow,
          ),
          child: InkWell(
            onTap: () {
              Get.to(const ADShoesListPage(), arguments: {
                "cat_id": model.catId.toString(),
                "cat_name": model.catName.toString()
              });
            },
            child: Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      child: CachedNetworkImage(
                        imageUrl: model.imagePath ?? "",
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
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(color: colorPrimary.shade400),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 8,
                          ),
                          child: Text(
                            (model.catName ?? "").toUpperCase(),
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                              color: colorWhite,
                              fontSize: 18,
                              height: 1,
                              // fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      iconSize: 16,
                      style: IconButton.styleFrom(
                        backgroundColor: colorRed,
                        padding: const EdgeInsets.all(0),
                        minimumSize: const Size(30, 30),
                        maximumSize: const Size(30, 30),
                      ),
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
                            controller.deleteCategory(model);
                          },
                        );
                      },
                    ),
                    IconButton(
                      iconSize: 16,
                      style: IconButton.styleFrom(
                        backgroundColor: colorPrimary,
                        padding: const EdgeInsets.all(0),
                        minimumSize: const Size(30, 30),
                        maximumSize: const Size(30, 30),
                      ),
                      color: colorPrimary,
                      icon: const Icon(
                        Icons.edit_rounded,
                        color: colorWhite,
                      ),
                      onPressed: () async {
                        var result = await Get.to(
                          () => AddCategory(),
                          arguments: model,
                        );
                        if (result != null && result == true) {
                          controller.getData();
                        }
                      },
                    ),
                  ],
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

  Widget _buildDrawer() {
    return SafeArea(
      child: Drawer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 150,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FutureBuilder(
                    future:
                        Preferences().getPrefString(Preferences.prefFullName),
                    builder:
                        (BuildContext context, AsyncSnapshot<String> snapshot) {
                      return Text(
                        "Hello, ${snapshot.data}",
                        style: const TextStyle(
                            fontSize: 26,
                            color: colorPrimary,
                            fontWeight: FontWeight.w500),
                      );
                    },
                  ),
                  FutureBuilder(
                    future: Preferences().getPrefString(Preferences.prefEmail),
                    builder:
                        (BuildContext context, AsyncSnapshot<String> snapshot) {
                      return Text(
                        "${snapshot.data},Admin",
                        style: const TextStyle(
                          fontSize: 16,
                          color: colorPrimary,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Divider(
                      color: colorPrimary.shade100,
                    ),
                    ListTile(
                      onTap: () async {
                        if (controller.keyScaffold.currentState != null) {
                          controller.keyScaffold.currentState!.closeDrawer();
                        }
                        bool? isAdded = await Get.to(() => AddCategory());
                        if (isAdded ?? false) {
                          controller.getData();
                        }
                      },
                      leading: const Icon(Icons.category_rounded),
                      title: const Text("Add Categories"),
                    ),
                    Divider(
                      color: colorPrimary.shade100,
                      endIndent: 10,
                      indent: 50,
                    ),
                    ListTile(
                      onTap: () {
                        if (controller.keyScaffold.currentState != null) {
                          controller.keyScaffold.currentState!.closeDrawer();
                        }
                        if (controller.categoryList.isNotEmpty) {
                          Get.to(() => AddProduct());
                        } else {
                          showSnackBarWithText(
                              Get.context, "Category List is Empty!");
                        }
                      },
                      leading: const Icon(Icons.accessibility_new_outlined),
                      title: const Text("Add Products"),
                    ),
                    Divider(
                      color: colorPrimary.shade100,
                      endIndent: 10,
                      indent: 50,
                    ),
                    ListTile(
                      onTap: () async {
                        if (controller.keyScaffold.currentState != null) {
                          controller.keyScaffold.currentState!.closeDrawer();
                        }
                        var result = await Get.to(
                          () => ManageAdvertisements(),
                        );
                        if (result != null && result == true) {
                          controller.getAdvertisement();
                        }
                      },
                      leading: const Icon(Icons.ad_units_rounded),
                      title: const Text("Advertisement"),
                    ),
                    Divider(
                      color: colorPrimary.shade100,
                    ),
                  ],
                ),
              ),
            ),
            Divider(color: colorPrimary.shade100),
            ListTile(
              onTap: () {
                // _buildLogOutOrDeleteAcc(
                //     "Logout",
                //     "Are you sure?\nYou want to logout from this account!",
                //     Icons.logout_rounded);
                buildConfirmationDialog(
                  title: "Logout",
                  msg: "Are you sure?\nYou want to logout from this account!",
                  icon: Icons.logout_rounded,
                  onYesTap: () async {
                    await controller.logout();

                  },
                );
              },
              leading: const Icon(Icons.logout_rounded),
              title: const Text("Logout"),
            ),
            // if (!isAdminLogin)
            //   Divider(
            //     color: colorPrimary.shade100,
            //     endIndent: 10,
            //     indent: 50,
            //   ),
            // if (!isAdminLogin)
            //   ListTile(
            //     onTap: () {
            //
            //       _buildLogOutOrDeleteAcc(
            //         "Delete",
            //         "Are you sure?\nYou want to delete account from this out servers!",
            //         Icons.delete_forever_rounded,
            //         isDelete: true,
            //       );
            //     },
            //     leading: const Icon(Icons.delete_forever_rounded),
            //     title: const Text("Delete Account"),
            //   ),
            Divider(color: colorPrimary.shade100),
          ],
        ),
      ),
    );
  }
}
