import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoes_acces/screens/shoeList/ShoesListController.dart';
import 'package:shoes_acces/screens/shoeList/model/ProductResponseModel.dart';

import '../../utils/ColorConstants.dart';
import '../../utils/Constants.dart';
import '../../widgets/Widgets.dart';
import '../cart/CartController.dart';

class ShoesListPage extends StatefulWidget {
  const ShoesListPage({super.key});

  @override
  State<ShoesListPage> createState() => _ShoesListPageState();
}

class _ShoesListPageState extends State<ShoesListPage> {
  ShoesListController controller = Get.put(ShoesListController());
  CartController controllerCart = Get.find(tag: "CartController");

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
              buildSearch(context, controller.textControllerSearch, (value) {
                controller.search(value);
              }),
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
                            height: 150,
                            margin: const EdgeInsets.only(top: 10),
                            decoration: BoxDecoration(
                              color: colorWhite,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: boxShadow,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 8,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  // child:   FutureBuilder<PaletteGenerator>(
                                  //     future: _updatePaletteGenerator(), // async work
                                  //     builder: (BuildContext context, AsyncSnapshot<PaletteGenerator> snapshot) {
                                  //       switch (snapshot.connectionState) {
                                  //         case ConnectionState.waiting: return const Center(child:CircularProgressIndicator());
                                  //         default:
                                  //           if (snapshot.hasError)
                                  //             return new Text('Error: ${snapshot.error}');
                                  //           else {
                                  //             // Color color=new Color(snapshot.data.dominantColor.color);
                                  //             Color color =snapshot.data!.dominantColor!.color;
                                  //             return new Text('color: ${color.toString()}');
                                  //           }}}),
                                  child: Material(
                                    elevation: 2,
                                    color: colorPrimary.shade50,
                                    borderRadius: BorderRadius.circular(8),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Center(
                                        child: Image.network(
                                            model.imagePath ?? ""),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 8,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const SizedBox(height: 10),
                                        Text(
                                          "${model.proName}",
                                          textAlign: TextAlign.left,
                                          style: const TextStyle(
                                            color: colorBlack,
                                            fontSize: 20,
                                            height: 1,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          model.proWeight!.isEmpty
                                              ? ""
                                              : "${model.proWeight} g",
                                          textAlign: TextAlign.left,
                                          style: const TextStyle(
                                            color: colorGrayText,
                                            fontSize: 14,
                                            height: 1,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(height: 15),
                                        Row(
                                          children: [
                                            if (model.proDiscount != null &&
                                                model.proDiscount != 0)
                                              Text(
                                                "${model.proDiscount}₹",
                                                textAlign: TextAlign.left,
                                                style: const TextStyle(
                                                  color: colorGreen,
                                                  fontSize: 16,
                                                  height: 1,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            if (model.proDiscount != null &&
                                                model.proDiscount != 0)
                                              const SizedBox(width: 5),
                                            Text(
                                              "${model.proPrice}₹",
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                color: model.proDiscount !=
                                                            null &&
                                                        model.proDiscount != 0
                                                    ? Colors.red
                                                    : colorGreen,
                                                fontSize: model.proDiscount !=
                                                            null &&
                                                        model.proDiscount != 0
                                                    ? 12
                                                    : 16,
                                                decoration: model.proDiscount !=
                                                            null &&
                                                        model.proDiscount != 0
                                                    ? TextDecoration.lineThrough
                                                    : null,
                                                height: 1,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Obx(
                                  () => controllerCart.isAddCartLoading.value
                                      ? const SizedBox(
                                          height: 50,
                                          width: 50,
                                          child: Center(
                                            child: SizedBox(
                                              height: 24,
                                              width: 24,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 1,
                                                color: colorPrimary,
                                              ),
                                            ),
                                          ),
                                        )
                                      : !controllerCart
                                              .checkIfIdExist(model.proId ?? "")
                                          ? IconButton(
                                              icon: const Icon(
                                                Icons.add_shopping_cart_rounded,
                                                color: colorPrimary,
                                              ),
                                              onPressed: () {
                                                controllerCart.addToCart(
                                                    model.proId ?? "");
                                              },
                                            )
                                          : Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                IconButton(
                                                  onPressed: () {},
                                                  icon: const Icon(
                                                    Icons.add,
                                                    color: colorGreen,
                                                    size: 20,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 24,
                                                  height: 24,
                                                  child: Text(
                                                    "1",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                ),
                                                IconButton(
                                                  onPressed: () {},
                                                  icon: const Icon(
                                                    Icons.remove_rounded,
                                                    color: colorRed,
                                                    size: 20,
                                                  ),
                                                ),
                                              ],
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
// Widget _buildSearch(BuildContext context) {
//   return Padding(
//     padding: const EdgeInsets.symmetric(horizontal: 10),
//     child: Row(
//       children: [
//         Expanded(
//           child: TextField(
//             decoration: InputDecoration(
//               contentPadding:
//                   EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//               border: OutlineInputBorder(
//                 borderSide: BorderSide(
//                   color: colorPrimary.shade100,
//                 ),
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderSide: BorderSide(
//                   color: colorPrimary.shade100,
//                 ),
//               ),
//               enabledBorder: OutlineInputBorder(
//                 borderSide: BorderSide(
//                   color: colorPrimary.shade100,
//                 ),
//               ),
//               prefixIcon: Icon(Icons.search_rounded),
//               prefixIconColor: colorPrimary.shade100,
//             ),
//             onChanged: (value) {
//               controller.search(value);
//               // _homepageBloc.add(SearchEvent(value));
//             },
//           ),
//         ),
//         IconButton(
//           onPressed: () {
//             controller.getData();
//           },
//           icon: const Icon(Icons.close_rounded),
//         ),
//       ],
//     ),
//   );
// }

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
