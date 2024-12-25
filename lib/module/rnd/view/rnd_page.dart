import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:starter_pack_web/module/rnd/controller/rnd_controller.dart';
import 'package:starter_pack_web/utils/app_extension.dart';
import 'package:starter_pack_web/utils/app_images.dart';

import '../../../utils/app_color.dart';
import '../../../utils/app_dialog.dart';
import '../../../utils/app_sound.dart';
import '../../../utils/app_text.dart';
import '../../demography/view/curved_text.dart';

class RndPage extends StatelessWidget {
  RndPage({super.key});

  final _c = Get.find<RndController>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: size.height,
            child: Image.asset(
              bgProd,
              filterQuality: FilterQuality.high,
              fit: BoxFit.fill,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Obx(
                        () => MouseRegion(
                          cursor: SystemMouseCursors.click,
                          onEnter: (_) {
                            AppSound.playHover();
                            _c.isHovered.value = true;
                          },
                          onExit: (_) {
                            _c.isHovered.value = false;
                          },
                          child: InkWell(
                            onTap: () => context.pop(),
                            child: Container(
                              alignment: Alignment.center,
                              height: 45,
                              width: 100,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 25.0),
                                child: AppTextNormal.labelBold(
                                  "BACK",
                                  26,
                                  _c.isHovered.value
                                      ? colorElectricViolet
                                      : Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                20.ph,
                Expanded(
                  child: Obx(() {
                    if (!_c.isDone.value) {
                      return Center(
                        child: AppTextNormal.labelBold(
                          "You have already created the product.",
                          26,
                          Colors.blueAccent,
                        ),
                      );
                    }

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 80),
                              child: MouseRegion(
                                onEnter: (_) => AppSound.playHover(),
                                child: IconButton(
                                  onPressed: _c.previousPage,
                                  icon: const Icon(
                                    CupertinoIcons.arrowtriangle_left_circle,
                                    color: Colors.grey,
                                    size: 50,
                                  ),
                                ),
                              ),
                            ),
                            Obx(
                              () => SizedBox(
                                width: size.width / 3,
                                height: size.height / 1.9,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    AnimatedContainer(
                                      width: size.width / 3,
                                      height: size.height / 2.5,
                                      duration: const Duration(seconds: 3),
                                      child: CachedNetworkImage(
                                        imageUrl: _c
                                            .products[_c.indexImg.value].image,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      child: Container(
                                        margin: const EdgeInsets.only(top: 150),
                                        width: size.width / 3,
                                        height: size.height / 4,
                                        child: Stack(
                                          children: [
                                            SizedBox(
                                              width: double.infinity,
                                              child: Image.asset(
                                                bgProdName,
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                            Container(
                                              padding: const EdgeInsets.only(
                                                  top: 14),
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 100),
                                              alignment: Alignment.center,
                                              width: double.infinity - 80,
                                              child: CurvedText(
                                                curvature: -0.0015,
                                                text:
                                                    "${_c.products[_c.indexImg.value].nama} - ${_c.products[_c.indexImg.value].tipe}",
                                                textStyle: const TextStyle(
                                                  fontFamily: 'Bigail',
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 25,
                                                  color: Colors.white,
                                                  shadows: [
                                                    Shadow(
                                                      offset: Offset(-1.5,
                                                          -1.5), // Bayangan ke kiri atas
                                                      color: Colors.black,
                                                      blurRadius: 1.0,
                                                    ),
                                                    Shadow(
                                                      offset: Offset(1.5,
                                                          -1.5), // Bayangan ke kanan atas
                                                      color: Colors.black,
                                                      blurRadius: 1.0,
                                                    ),
                                                    Shadow(
                                                      offset: Offset(1.5,
                                                          1.5), // Bayangan ke kanan bawah
                                                      color: Colors.black,
                                                      blurRadius: 1.0,
                                                    ),
                                                    Shadow(
                                                      offset: Offset(-1.5,
                                                          1.5), // Bayangan ke kiri bawah
                                                      color: Colors.black,
                                                      blurRadius: 1.0,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                                padding: const EdgeInsets.only(bottom: 80),
                                child: MouseRegion(
                                  onEnter: (_) => AppSound.playHover(),
                                  child: IconButton(
                                    onPressed: _c.nextPage,
                                    icon: const Icon(
                                      CupertinoIcons.arrowtriangle_right_circle,
                                      color: Colors.grey,
                                      size: 50,
                                    ),
                                  ),
                                )),
                          ],
                        ),
                        MouseRegion(
                          onEnter: (_) => AppSound.playHover(),
                          child: OutlinedButton(
                            onPressed: _c.onSelect,
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              backgroundColor:
                                  _c.indexSelecteds.contains(_c.indexImg.value)
                                      ? Colors.amber
                                      : Colors.white,
                            ),
                            child: AppTextNormal.labelBold(
                              "SELECT",
                              16,
                              Colors.black,
                            ),
                          ),
                        ),
                      ],
                    );

                    // return Column(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     Stack(
                    //       children: [
                    //         SizedBox(
                    //           height: 500,
                    //           child: PageView.builder(
                    //             controller: _c.verticalTranslateController,
                    //             itemCount: _c.products.length,
                    //             itemBuilder: (context, index) {
                    //               return AnimatedPage(
                    //                 controller: _c.verticalTranslateController,
                    //                 index: index,
                    //                 effect: const TranslateEffect(
                    //                   animationAxis: Axis.vertical,
                    //                   startOffset: 20,
                    //                 ),
                    //                 child: Container(
                    //                   margin: const EdgeInsets.all(5.0),
                    //                   width: 60,
                    //                   decoration: BoxDecoration(
                    //                     borderRadius: BorderRadius.circular(10),
                    //                     image: DecorationImage(
                    //                       image: NetworkImage(
                    //                         _c.products[index].image,
                    //                       ),
                    //                     ),
                    //                   ),
                    //                 ),
                    //               );
                    //             }, // Can be null
                    //           ),
                    //         ),
                    //         Positioned(
                    //           top: 200,
                    //           left: 490,
                    //           child: Image.asset(
                    //             bgProdName,
                    //           ),
                    //         ),
                    //         if (_c.products.isNotEmpty)
                    //           Positioned(
                    //             top: 370,
                    //             left: 650,
                    //             child: SizedBox(
                    //               width: 350,
                    //               height: 50,
                    //               child: FittedBox(
                    //                 child: AppTextNormal.labelBold(
                    //                   _c.products[_c.indexImg.value].nama,
                    //                   18,
                    //                   Colors.white,
                    //                   letterSpacing: 8,
                    //                 ),
                    //               ),
                    //             ),
                    //           ),
                    //         Positioned(
                    //           top: 200,
                    //           left: 550,
                    //           child: IconButton(
                    //             onPressed: _c.previousPage,
                    //             icon: const Icon(
                    //               CupertinoIcons.arrowtriangle_left_circle,
                    //               color: Colors.grey,
                    //               size: 50,
                    //             ),
                    //           ),
                    //         ),
                    //         Positioned(
                    //           top: 200,
                    //           right: 550,
                    //           child: IconButton(
                    //             onPressed: _c.nextPage,
                    //             icon: const Icon(
                    //               CupertinoIcons.arrowtriangle_right_circle,
                    //               color: Colors.grey,
                    //               size: 50,
                    //             ),
                    //           ),
                    //         ),
                    //         Positioned(
                    //           top: 470,
                    //           right: 775,
                    //           child: OutlinedButton(
                    //             onPressed: _c.onSelect,
                    //             style: OutlinedButton.styleFrom(
                    //               shape: RoundedRectangleBorder(
                    //                 borderRadius: BorderRadius.circular(4),
                    //               ),
                    //               backgroundColor: _c.indexSelecteds
                    //                       .contains(_c.indexImg.value)
                    //                   ? Colors.amber
                    //                   : Colors.white,
                    //             ),
                    //             child: AppTextNormal.labelBold(
                    //               "SELECT",
                    //               16,
                    //               Colors.black,
                    //             ),
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ],
                    // );
                  }),
                ),
              ],
            ),
          ),
          Obx(() {
            if (_c.indexSelecteds.isEmpty) {
              return const SizedBox();
            }

            return Positioned(
              right: 25,
              top: 25,
              child: Container(
                width: 450,
                margin: const EdgeInsets.symmetric(horizontal: 6),
                padding: const EdgeInsets.all(18.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: Colors.grey.shade100,
                  border: Border.all(
                    width: 0.25,
                    color: Colors.grey.shade500,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppTextNormal.labelBold(
                      "Summary",
                      22,
                      Colors.black,
                      letterSpacing: 1.5,
                    ),
                    14.ph,
                    Column(
                      children: List.generate(
                        _c.indexSelecteds.length,
                        (index) {
                          final data = _c.products[_c.indexSelecteds[index]];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 4,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      AppTextNormal.labelBold(
                                        "R\$${data.harga}/pcs",
                                        16,
                                        colorPrimaryDark,
                                        letterSpacing: 1.8,
                                      ),
                                      10.ph,
                                      AppTextNormal.labelBold(
                                        "${data.nama}  -  ${data.tipe}",
                                        16,
                                        Colors.grey.shade600,
                                        letterSpacing: 1.8,
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    _c.onRemove(_c.indexSelecteds[index]);
                                  },
                                  icon: const Icon(
                                    Icons.close,
                                    color: Colors.red,
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Obx(() {
                        if (_c.isDone.value) {
                          return const SizedBox();
                        }
                        return MouseRegion(
                          onEnter: (_) => AppSound.playHover(),
                          child: SizedBox(
                            width: double.infinity,
                            height: 45,
                            child: ElevatedButton(
                              onPressed: _c.checkedProducts.length > 3 ||
                                      _c.checkedProducts.isEmpty
                                  ? null
                                  : () {
                                      AppDialog.dialogDelete(
                                        title: "Save Product",
                                        subtitle:
                                            "Are you sure you want to save this product?\nThe data cannot be changed later.",
                                        callback: () {
                                          context.pop();
                                          _c.saveProduct();
                                        },
                                        confirmText: "Yes, save",
                                      );
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: AppTextNormal.labelBold(
                                "SAVE",
                                22,
                                Colors.white,
                                letterSpacing: 1.8,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
