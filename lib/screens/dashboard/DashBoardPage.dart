import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoes_acces/screens/shoeList/ShoesListPage.dart';
import 'package:shoes_acces/utils/Constants.dart';
import 'package:shoes_acces/utils/Preferences.dart';

import '../../utils/ColorConstants.dart';
import '../../widgets/Widgets.dart';
import 'DashBoardController.dart';
import 'model/CategoryResponseModel.dart';

class DashBoardPage extends GetView<DashBoardController> {
  DashBoardController controller = Get.put(DashBoardController());

  DashBoardPage({super.key});

  Widget _buildTile() {
    return ListTile(
      leading: Icon(Icons.delivery_dining_rounded),
      title: Text("Order History"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SafeArea(
        child: Drawer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 200,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FutureBuilder(
                      future:
                          Preferences().getPrefString(Preferences.prefFullName),
                      builder: (BuildContext context,
                          AsyncSnapshot<String> snapshot) {
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
                      future:
                          Preferences().getPrefString(Preferences.prefEmail),
                      builder: (BuildContext context,
                          AsyncSnapshot<String> snapshot) {
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
                child: Column(
                  children: [
                    Divider(
                      color: colorPrimary.shade100,
                    ),
                    const ListTile(
                      leading: Icon(Icons.pin_drop_rounded),
                      title: Text("Saved Addresses"),
                    ),
                    Divider(
                      color: colorPrimary.shade100,
                      endIndent: 10,
                      indent: 50,
                    ),
                    const ListTile(
                      leading: Icon(Icons.delivery_dining_rounded),
                      title: Text("Order History"),
                    ),
                    Divider(
                      color: colorPrimary.shade100,
                      endIndent: 10,
                      indent: 50,
                    ),
                    const ListTile(
                      leading: Icon(Icons.password_rounded),
                      title: Text("Change Password"),
                    ),
                    Divider(
                      color: colorPrimary.shade100,
                      endIndent: 10,
                      indent: 50,
                    ),
                  ],
                ),
              ),
              Divider(color: colorPrimary.shade100),
              const ListTile(
                leading: Icon(Icons.logout_rounded),
                title: Text("Logout"),
              ),
              Divider(color: colorPrimary.shade100),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Text(
                "WellCome To",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            const SizedBox(height: 3),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Text(
                "Shoes Accessories",
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    if (controller.imageList.isNotEmpty) _buildSlider(),
                    buildSearch(context, controller.textControllerSearch,
                        (value) {
                      controller.search(value);
                    }),
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
            )
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
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildSlider() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CarouselSlider(
          carouselController: CarouselController(),
          items: controller.imageList
              .map(
                (e) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Container(
                    height: 240,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black26,
                            offset: Offset(0, 0),
                            blurRadius: 5,
                            spreadRadius: 1),
                      ],
                    ),
                    child: Image.asset(e, fit: BoxFit.cover),
                  ),
                ),
              )
              .toList(),
          options: CarouselOptions(
            height: 150,
            aspectRatio: 16 / 9,
            viewportFraction: .6,
            initialPage: 0,
            enableInfiniteScroll: true,
            reverse: false,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 3),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            autoPlayCurve: Curves.easeInOutSine,
            enlargeCenterPage: true,
            enlargeFactor: 0.3,
            onPageChanged: (index, reason) {
              controller.indexSlider.value = index;
            },
            scrollDirection: Axis.horizontal,
          ),
        ),
        const SizedBox(height: 10),
        DotsIndicator(
          dotsCount: controller.imageList.length,
          position: controller.indexSlider.value,
          mainAxisSize: MainAxisSize.min,
          decorator: const DotsDecorator(
            activeSize: Size(7, 7),
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
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        Category model = controller.searchCategoryList[index];
        return Container(
          height: 100,
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
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(model.imagePath ?? ""),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            Color(0x55b3baff),
                          ],
                          begin: Alignment.centerRight,
                          end: Alignment.centerLeft),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 8,
                      ),
                      child: Text(
                        "${model.catName}",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: colorBlack,
                          fontSize: 20,
                          height: 1,
                          fontWeight: FontWeight.w500,
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
}
