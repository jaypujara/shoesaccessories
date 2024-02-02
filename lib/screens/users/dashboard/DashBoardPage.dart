import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoes_acces/screens/users/addressList/AddressListPage.dart';
import 'package:shoes_acces/screens/users/cart/CartController.dart';
import 'package:shoes_acces/screens/users/cart/CartScreen.dart';
import 'package:shoes_acces/screens/users/order_history/OrderHistoryList.dart';
import 'package:shoes_acces/screens/users/shoeList/ShoesListPage.dart';
import 'package:shoes_acces/utils/ColorConstants.dart';
import 'package:shoes_acces/utils/Constants.dart';
import 'package:shoes_acces/utils/Preferences.dart';
import 'package:shoes_acces/widgets/ThemedTextField.dart';
import 'package:shoes_acces/widgets/Widgets.dart';

import '../../splash/SplashPage.dart';
import 'DashBoardController.dart';
import 'model/CategoryResponseModel.dart';

class DashBoardPage extends GetView<DashBoardController> {
  DashBoardController controller = Get.put(DashBoardController());
  CartController cartController = Get.find(tag: "CartController");

  DashBoardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: controller.keyScaffold,
      drawer: _buildDrawer(),
      appBar: _buildAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // const SizedBox(height: 10),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 15.0),
              //   child: Text(
              //     "WellCome To",
              //     style: Theme.of(context).textTheme.headlineSmall,
              //   ),
              // ),
              // const SizedBox(height: 3),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 15.0),
              //   child: Text(
              //     "Shoes Accessories",
              //     style: Theme.of(context).textTheme.headlineLarge,
              //   ),
              // ),
              const SizedBox(height: 20),
              Obx(
                () => controller.imageList.isNotEmpty
                    ? _buildSlider()
                    : const SizedBox(),
              ),
              // if (controller.imageList.isNotEmpty)
              //   _buildSlider(),
              // buildSearch(context, controller.textControllerSearch, (value) {
              //   controller.search(value);
              // }),
              const SizedBox(height: 20),
              Obx(
                () => !controller.isLoading.value &&
                        controller.searchCategoryList.isNotEmpty
                    ? _buildList()
                    : !controller.isLoading.value &&
                            controller.searchCategoryList.isEmpty
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

  _buildLoading() {
    return SizedBox(
      height: 500,
      width: Get.width,
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Theme.of(Get.context!).scaffoldBackgroundColor,
      elevation: 0,
      titleSpacing: 0,
      clipBehavior: Clip.none,
      title: const Text("Shoes Accessories"),
      actions: [
        InkWell(
          onTap: () {
            Get.to(() => CartPage());
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              const Icon(
                Icons.shopping_cart_rounded,
                color: colorPrimary,
                size: 27,
              ),
              Positioned(
                right: 0,
                top: -4,
                child: Obx(
                  () => Container(
                    decoration: const BoxDecoration(
                      color: colorRed,
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(4),
                    child: Text(
                      cartController.cartProductList.length.toString(),
                      style: const TextStyle(
                        color: colorWhite,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
      ],
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
                        "${snapshot.data}",
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
                    if (isAdminLogin)
                      Column(
                        children: [
                          ListTile(
                            onTap: () {
                              if (controller.keyScaffold.currentState != null) {
                                controller.keyScaffold.currentState!
                                    .closeDrawer();
                              }
                              Get.to(() => AddressListPage());
                            },
                            leading: const Icon(Icons.category_rounded),
                            title: const Text("Categories"),
                          ),
                          Divider(
                            color: colorPrimary.shade100,
                            endIndent: 10,
                            indent: 50,
                          ),
                          ListTile(
                            onTap: () {
                              if (controller.keyScaffold.currentState != null) {
                                controller.keyScaffold.currentState!
                                    .closeDrawer();
                              }
                              Get.to(() => AddressListPage());
                            },
                            leading:
                                const Icon(Icons.accessibility_new_outlined),
                            title: const Text("Products"),
                          ),
                          Divider(
                            color: colorPrimary.shade100,
                            endIndent: 10,
                            indent: 50,
                          ),
                        ],
                      ),
                    if (!isAdminLogin)
                      Column(
                        children: [
                          ListTile(
                            onTap: () {
                              if (controller.keyScaffold.currentState != null) {
                                controller.keyScaffold.currentState!
                                    .closeDrawer();
                              }
                              Get.to(() => AddressListPage());
                            },
                            leading: const Icon(Icons.pin_drop_rounded),
                            title: const Text("Saved Addresses"),
                          ),
                          Divider(
                            color: colorPrimary.shade100,
                            endIndent: 10,
                            indent: 50,
                          ),
                          ListTile(
                            onTap: () {
                              Get.to(() => CartPage());
                            },
                            leading: Icon(Icons.shopping_cart),
                            title: Text("Cart"),
                          ),
                          Divider(
                            color: colorPrimary.shade100,
                            endIndent: 10,
                            indent: 50,
                          ),
                          ListTile(
                            onTap: () {
                              Get.to(() => OrderHistoryList());
                            },
                            leading: const Icon(Icons.delivery_dining_rounded),
                            title: const Text("Order History"),
                          ),
                          Divider(
                            color: colorPrimary.shade100,
                            endIndent: 10,
                            indent: 50,
                          ),
                          ListTile(
                            onTap: () {
                              _buildChangePassDialog();
                            },
                            leading: const Icon(Icons.password_rounded),
                            title: const Text("Change Password"),
                          ),
                          Divider(
                            color: colorPrimary.shade100,
                            endIndent: 10,
                            indent: 50,
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
            Divider(color: colorPrimary.shade100),
            ListTile(
              onTap: () {
                _buildLogOutOrDeleteAcc(
                    "Logout",
                    "Are you sure?\nYou want to logout from this account!",
                    Icons.logout_rounded);
              },
              leading: const Icon(Icons.logout_rounded),
              title: const Text("Logout"),
            ),
            if (!isAdminLogin)
              Divider(
                color: colorPrimary.shade100,
                endIndent: 10,
                indent: 50,
              ),
            if (!isAdminLogin)
              ListTile(
                onTap: () {
                  _buildLogOutOrDeleteAcc(
                    "Delete",
                    "Are you sure?\nYou want to delete account from this out servers!",
                    Icons.delete_forever_rounded,
                    isDelete: true,
                  );
                },
                leading: const Icon(Icons.delete_forever_rounded),
                title: const Text("Delete Account"),
              ),
            Divider(color: colorPrimary.shade100),
          ],
        ),
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
                  (e) => CachedNetworkImage(
                    imageUrl: e ?? "",
                    fit: BoxFit.cover,
                    imageBuilder: (context, imageProvider) {
                      return Container(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Image(image: imageProvider, fit: BoxFit.cover),
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
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 3 / 3.5,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      physics: const NeverScrollableScrollPhysics(),
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
              Get.to(ShoesListPage(), arguments: {
                "cat_id": model.catId.toString(),
                "cat_name": model.catName.toString()
              });
            },
            child: Column(
              // fit: StackFit.expand,
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
                    decoration: BoxDecoration(color: colorPrimary.shade400
                        // gradient: LinearGradient(
                        //     colors: [
                        //       Colors.transparent,
                        //       Color(0xAAb3baff),
                        //       Color(0xAAb3baff),
                        //     ],
                        //     begin: Alignment.centerRight,
                        //     end: Alignment.centerLeft),
                        ),
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
          ),
        );
      },
    );
  }

  _buildChangePassDialog() {
    if (controller.keyScaffold.currentState != null) {
      controller.keyScaffold.currentState!.closeDrawer();
    }
    Get.bottomSheet(
      isScrollControlled: true,
      BottomSheet(
        constraints: BoxConstraints.loose(Size(Get.width, Get.height * 0.75)),
        onClosing: () {},
        builder: (context) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: GetBuilder<DashBoardController>(
                builder: (controller) {
                  return Obx(
                    () => Form(
                      key: controller.keyForm,
                      child: Column(
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
                            controller: controller.textControllerOldPass,
                            borderRadiusTextField: 25,
                            hintText: "Old Password",
                            preFix: const Icon(Icons.pin_drop_rounded),
                            keyBoardType: TextInputType.streetAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter your Old Password!";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          ThemedTextField(
                            controller: controller.textControllerNewPass,
                            borderRadiusTextField: 25,
                            hintText: "New Password",
                            preFix: const Icon(Icons.pin_drop_rounded),
                            keyBoardType: TextInputType.streetAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter your New Password!";
                              } else if (value ==
                                  controller.textControllerOldPass.text) {
                                return "Old Password and New Password can not be same!";
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
                            onTap: controller.onChangePassword,
                            child: Container(
                              decoration: BoxDecoration(
                                color: colorPrimary,
                                borderRadius: BorderRadius.circular(25),
                              ),
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: controller.isChangePassLoading.value
                                  ? const Center(
                                      child: SizedBox(
                                        height: 27,
                                        width: 27,
                                        child: CircularProgressIndicator(
                                          color: colorWhite,
                                          strokeWidth: 2,
                                        ),
                                      ),
                                    )
                                  : const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Change Password",
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
    ).then((value) {
      controller.error.value = "";
      controller.textControllerOldPass.text = "";
      controller.textControllerNewPass.text = "";
    });
  }

  _buildLogOutOrDeleteAcc(String title, String msg, IconData icon,
      {bool isDelete = false}) {
    if (controller.keyScaffold.currentState != null) {
      controller.keyScaffold.currentState!.closeDrawer();
    }
    Get.dialog(
      Dialog(
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
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Icon(
                        icon,
                        color: colorWhite,
                        size: 30,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: colorPrimary,
                      fontSize: 30,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10),
              Divider(color: colorPrimary.shade100),
              const SizedBox(height: 20),
              Text(
                msg,
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
                        if (isDelete) {
                          await controller.deleteAccount();
                        } else {
                          await controller.logout();
                        }
                        Get.back();
                        Get.offAll(() => SplashPage());
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
    ).then((value) {
      controller.error.value = "";
      controller.textControllerOldPass.text = "";
      controller.textControllerNewPass.text = "";
    });
  }
}
