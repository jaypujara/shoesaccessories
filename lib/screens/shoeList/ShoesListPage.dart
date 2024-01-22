import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoes_acces/screens/shoeList/ShoesListController.dart';
import 'package:shoes_acces/screens/shoeList/model/ProductResponseModel.dart';
import 'package:shoes_acces/utils/functions.dart';

import '../../utils/ColorConstants.dart';
import '../../utils/Constants.dart';

class ShoesListPage extends StatefulWidget {
  const ShoesListPage({super.key});

  @override
  State<ShoesListPage> createState() => _ShoesListPageState();
}

class _ShoesListPageState extends State<ShoesListPage> {
  ShoesListController controller = Get.put(ShoesListController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Text(Get.arguments["cat_name"].toString()),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(
                () => !controller.isLoading.value &&
                        controller.searchShoesList.isNotEmpty
                    ? ListView.builder(
                        itemCount: controller.searchShoesList.length,
                        shrinkWrap: true,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        physics: const NeverScrollableScrollPhysics(),
                        primary: true,
                        itemBuilder: (context, index) {
                          Product model = controller.searchShoesList[index];
                          return Container(
                            height: 100,
                            // clipBehavior: Clip.antiAliasWithSaveLayer,
                            // decoration: BoxDecoration(
                            //   color: colorWhite,
                            //   borderRadius: boxBorderRadius,
                            //   boxShadow: boxShadow,
                            // ),
                            margin: const EdgeInsets.only(top: 10),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color:
                                          Theme.of(context).primaryColorLight,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    padding: const EdgeInsets.all(5),
                                    child: Center(
                                      child:
                                          Image.network(model.imagePath ?? ""),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: colorWhite,
                                      borderRadius: BorderRadius(),
                                      boxShadow: boxShadow,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0,
                                        vertical: 8,
                                      ),
                                      child: Text(
                                        "${model.proName}",
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

// class ShoesListPage extends GetView<ShoesListController> {
//   ShoesListController controller = Get.put(ShoesListController());
//
//   ShoesListPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         titleSpacing: 0,
//         title: Text(Get.arguments["cat_name"].toString()),
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(height: 30),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 10.0),
//                 child: Text(
//                   "WellCome To",
//                   style: Theme.of(context).textTheme.headlineSmall,
//                 ),
//               ),
//               const SizedBox(height: 3),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 10.0),
//                 child: Text(
//                   "Shoes Accessories",
//                   style: Theme.of(context).textTheme.headlineLarge,
//                 ),
//               ),
//               const SizedBox(height: 40),
//               Obx(
//                 () => !controller.isLoading.value &&
//                         controller.searchShoesList.isNotEmpty
//                     ? GridView.builder(
//                         itemCount: controller.searchShoesList.length,
//                         shrinkWrap: true,
//                         gridDelegate:
//                             const SliverGridDelegateWithFixedCrossAxisCount(
//                           crossAxisCount: 2,
//                           crossAxisSpacing: 8,
//                           mainAxisSpacing: 8,
//                         ),
//                         padding: const EdgeInsets.symmetric(horizontal: 10),
//                         physics: const NeverScrollableScrollPhysics(),
//                         itemBuilder: (context, index) {
//                           Product model = controller.searchShoesList[index];
//                           return Container(
//                             height: 100,
//                             clipBehavior: Clip.antiAliasWithSaveLayer,
//                             decoration: BoxDecoration(
//                               color: colorWhite,
//                               borderRadius: boxBorderRadius,
//                               boxShadow: boxShadow,
//                             ),
//                             child: Stack(
//                               fit: StackFit.expand,
//                               children: [
//                                 Image.network(model.imagePath ?? ""),
//                                 Align(
//                                   alignment: Alignment.bottomLeft,
//                                   child: Container(
//                                     width: double.infinity,
//                                     decoration: const BoxDecoration(
//                                       gradient: LinearGradient(
//                                           colors: [
//                                             Colors.transparent,
//                                             Color(0x33888888),
//                                             Color(0x33888888),
//                                             Color(0x33888888),
//                                           ],
//                                           begin: Alignment.centerRight,
//                                           end: Alignment.centerLeft),
//                                     ),
//                                     child: Padding(
//                                       padding: const EdgeInsets.symmetric(
//                                         horizontal: 8.0,
//                                         vertical: 8,
//                                       ),
//                                       child: Text(
//                                         "${model.proName}",
//                                         textAlign: TextAlign.left,
//                                         style: TextStyle(
//                                           color: colorBlack,
//                                           fontSize: 24,
//                                           height: 1,
//                                           fontWeight: FontWeight.w500,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           );
//                         },
//                       )
//                     : !controller.isLoading.value &&
//                             controller.searchShoesList.isEmpty
//                         ? buildNoData(
//                             controller.inProgressOrDataNotAvailable.value)
//                         : _buildLoading(),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   _buildLoading() {
//     return SizedBox(
//       height: 500,
//       width: Get.width,
//       child: const Center(
//         child: CircularProgressIndicator(),
//       ),
//     );
//   }
// }
