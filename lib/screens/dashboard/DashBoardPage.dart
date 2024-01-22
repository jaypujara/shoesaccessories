import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoes_acces/screens/shoeList/ShoesListPage.dart';
import 'package:shoes_acces/utils/Constants.dart';

import '../../utils/ColorConstants.dart';
import '../../utils/functions.dart';
import 'DashBoardController.dart';
import 'model/CategoryResponseModel.dart';

class DashBoardPage extends GetView<DashBoardController> {
  DashBoardController controller = Get.put(DashBoardController());

  DashBoardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(),
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
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
              const SizedBox(height: 20),
              _buildSearch(context),
              const SizedBox(height: 20),
              Obx(
                () => !controller.isLoading.value &&
                        controller.searchCategoryList.isNotEmpty
                    ? GridView.builder(
                        itemCount: controller.searchCategoryList.length,
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
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
                                              // Color(0x33b3baff),
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
                                            fontSize: 24,
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
                      )
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

  Widget _buildSearch(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(
                    color: colorPrimary.shade100,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(
                    color: colorPrimary.shade100,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(
                    color: colorPrimary.shade100,
                  ),
                ),
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: IconButton(
                  onPressed: () {
                    controller.getData();
                  },
                  icon: Icon(Icons.close_rounded, color: colorPrimary.shade100),
                ),
                prefixIconColor: colorPrimary.shade100,
              ),
              onChanged: (value) {
                controller.search(value);
                // _homepageBloc.add(SearchEvent(value));
              },
            ),
          ),
        ],
      ),
    );
  }
}
