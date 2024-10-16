import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:starter_pack_web/module/product/controller/product_controller.dart';
import 'package:starter_pack_web/utils/app_color.dart';
import 'package:starter_pack_web/utils/app_extension.dart';
import 'package:starter_pack_web/utils/app_images.dart';
import 'package:starter_pack_web/utils/app_text.dart';

import '../../play/view/play_page.dart';

class ProductPage extends StatelessWidget {
  ProductPage({super.key});

  final _c = Get.find<ProductController>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      // appBar: AppBar(
      //   backgroundColor: Colors.amber.shade200,
      //   leadingWidth: 115,
      //   leading: InkWell(
      //     onTap: () => context.pop(),
      //     child: ClipPath(
      //       clipper: TrapezoidClipper(),
      //       child: Container(
      //         alignment: Alignment.center,
      //         color: Colors.black26,
      //         height: 45,
      //         child: Padding(
      //           padding: const EdgeInsets.only(right: 25.0),
      //           child: Image.asset(
      //             backImage,
      //             width: 50,
      //           ),
      //         ),
      //       ),
      //     ),
      //   ),
      //   actions: [
      //     Container(
      //       margin: const EdgeInsets.symmetric(horizontal: 16),
      //       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      //       decoration: const BoxDecoration(
      //           color: Colors.black26,
      //           borderRadius: BorderRadius.all(Radius.circular(8))),
      //       child: Row(
      //         children: [
      //           Image.asset(
      //             dollarImage,
      //             width: 30,
      //           ),
      //           10.pw,
      //           AnimatedDefaultTextStyle(
      //             duration: const Duration(milliseconds: 300),
      //             style: GoogleFonts.nanumGothicCoding(
      //               fontSize: 26,
      //               color: Colors.white,
      //               fontWeight: FontWeight.w600,
      //             ),
      //             child: const Text("339.2"),
      //           ),
      //           16.pw,
      //         ],
      //       ),
      //     )
      //   ],
      // ),
      body: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: size.height,
            child: Image.asset(
              garageImage,
              fit: BoxFit.fill,
              filterQuality: FilterQuality.high,
            ),
          ),
          Column(
            children: [
              Row(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    width: 125,
                    child: InkWell(
                      onTap: () => context.pop(),
                      child: ClipPath(
                        clipper: TrapezoidClipper(),
                        child: Container(
                          padding: const EdgeInsets.only(right: 25.0),
                          alignment: Alignment.center,
                          color: colorPrimaryDark.withOpacity(0.7),
                          height: 45,
                          child: Image.asset(
                            backImage,
                            width: 40,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      flex: 7,
                      child: Obx(() {
                        if (_c.isLoading.value) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return Column(
                          children: <Widget>[
                            Expanded(
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        right: size.width / 2.5),
                                    child: InkWell(
                                      onTap: () => _c.carouselSliderController
                                          .previousPage(),
                                      child: const Icon(
                                        Icons.arrow_back_ios_rounded,
                                        size: 60,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  CarouselSlider(
                                    items: _c.products
                                        .map(
                                          (item) => CachedNetworkImage(
                                            imageUrl: item.image,
                                            width: double.infinity,
                                            fit: BoxFit.contain,
                                            // placeholder: (context, url) => const SizedBox(
                                            //     width: 20,
                                            //     height: 20,
                                            //     child: CircularProgressIndicator()),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(Icons.error),
                                          ),
                                        )
                                        .toList(),
                                    options: CarouselOptions(
                                        onPageChanged: (index, _) {
                                          _c.onChangeProduct(index);
                                        },
                                        enlargeCenterPage: true,
                                        height: size.height / 2),
                                    carouselController:
                                        _c.carouselSliderController,
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(left: size.width / 2.5),
                                    child: InkWell(
                                      onTap: () => _c.carouselSliderController
                                          .nextPage(),
                                      child: const Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        size: 60,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }),
                    ),

                    // Expanded(
                    //   flex: 4,
                    //   child: Obx(() {
                    //     if (_c.isLoading.value) {
                    //       return const SizedBox();
                    //     }
                    //     return Container(
                    //       width: size.width,
                    //       height: size.height,
                    //       color: Colors.white38.withOpacity(0.2),
                    //       child: DefaultTabController(
                    //         length: 2, // Jumlah tab
                    //         child: Column(
                    //           children: [
                    //             16.ph,
                    //             PreferredSize(
                    //               preferredSize: const Size.fromHeight(40),
                    //               child: ClipRRect(
                    //                 borderRadius: const BorderRadius.all(
                    //                     Radius.circular(10)),
                    //                 child: Container(
                    //                   height: 45,
                    //                   margin: const EdgeInsets.symmetric(
                    //                       horizontal: 20),
                    //                   decoration: BoxDecoration(
                    //                     borderRadius: const BorderRadius.only(
                    //                       topLeft: Radius.circular(14),
                    //                       bottomRight: Radius.circular(14),
                    //                     ),
                    //                     color: Colors.grey.shade200
                    //                         .withOpacity(0.2),
                    //                   ),
                    //                   child: const TabBar(
                    //                     indicatorSize: TabBarIndicatorSize.tab,
                    //                     dividerColor: Colors.transparent,
                    //                     indicator: BoxDecoration(
                    //                       color: colorGold,
                    //                       borderRadius: BorderRadius.only(
                    //                         topLeft: Radius.circular(14),
                    //                         bottomRight: Radius.circular(14),
                    //                       ),
                    //                     ),
                    //                     labelColor: Colors.white,
                    //                     unselectedLabelColor: Colors.black54,
                    //                     tabs: [
                    //                       TabItem(title: 'Brand'),
                    //                       TabItem(title: 'Informasi'),
                    //                     ],
                    //                   ),
                    //                 ),
                    //               ),
                    //             ),
                    //             Expanded(
                    //               child: Column(
                    //                 children: [
                    //                   Expanded(
                    //                     child: TabBarView(
                    //                       children: [
                    //                         BrandPage(),
                    //                         InformasiPage(),
                    //                       ],
                    //                     ),
                    //                   ),
                    //                   Padding(
                    //                     padding: const EdgeInsets.symmetric(
                    //                         horizontal: 16, vertical: 14),
                    //                     child: Column(
                    //                       children: [
                    //                         Obx(
                    //                           () {
                    //                             if (_c.price.value == 0) {
                    //                               return const SizedBox();
                    //                             }
                    //                             return Container(
                    //                               padding: const EdgeInsets
                    //                                   .symmetric(
                    //                                   horizontal: 16),
                    //                               margin: const EdgeInsets.only(
                    //                                   bottom: 14),
                    //                               width: double.infinity,
                    //                               height: 35,
                    //                               color: Colors.white,
                    //                               child: Row(
                    //                                 mainAxisAlignment:
                    //                                     MainAxisAlignment
                    //                                         .spaceBetween,
                    //                                 children: [
                    //                                   AppTextNormal.labelW600(
                    //                                     "TOTAL  :",
                    //                                     20,
                    //                                     colorPrimaryDark,
                    //                                   ),
                    //                                   AppTextNormal.labelBold(
                    //                                     "\$${_c.price.value}",
                    //                                     25,
                    //                                     Colors.red,
                    //                                   ),
                    //                                 ],
                    //                               ),
                    //                             );
                    //                           },
                    //                         ),
                    //                         Row(
                    //                           mainAxisAlignment:
                    //                               MainAxisAlignment.center,
                    //                           children: [
                    //                             Expanded(
                    //                               child: ElevatedButton(
                    //                                 style: ElevatedButton
                    //                                     .styleFrom(
                    //                                   backgroundColor:
                    //                                       Colors.grey.shade300,
                    //                                   shape:
                    //                                       const RoundedRectangleBorder(
                    //                                     borderRadius:
                    //                                         BorderRadius.all(
                    //                                             Radius.circular(
                    //                                                 6)),
                    //                                   ),
                    //                                 ),
                    //                                 onPressed: () {},
                    //                                 child: Padding(
                    //                                   padding: const EdgeInsets
                    //                                       .symmetric(
                    //                                       vertical: 10,
                    //                                       horizontal: 14),
                    //                                   child:
                    //                                       AnimatedDefaultTextStyle(
                    //                                     duration:
                    //                                         const Duration(
                    //                                             milliseconds:
                    //                                                 300),
                    //                                     style: GoogleFonts
                    //                                         .nanumGothicCoding(
                    //                                       fontSize: 20,
                    //                                       color: Colors.black,
                    //                                       fontWeight:
                    //                                           FontWeight.w600,
                    //                                     ),
                    //                                     child:
                    //                                         const Text("RESET"),
                    //                                   ),
                    //                                 ),
                    //                               ),
                    //                             ),
                    //                             16.pw,
                    //                             Expanded(
                    //                               child: ElevatedButton(
                    //                                 style: ElevatedButton
                    //                                     .styleFrom(
                    //                                   backgroundColor:
                    //                                       colorPrimaryDark,
                    //                                   shape:
                    //                                       const RoundedRectangleBorder(
                    //                                     borderRadius:
                    //                                         BorderRadius.all(
                    //                                             Radius.circular(
                    //                                                 6)),
                    //                                   ),
                    //                                 ),
                    //                                 onPressed: () {},
                    //                                 child: Padding(
                    //                                   padding: const EdgeInsets
                    //                                       .symmetric(
                    //                                       vertical: 10,
                    //                                       horizontal: 14),
                    //                                   child:
                    //                                       AnimatedDefaultTextStyle(
                    //                                     duration:
                    //                                         const Duration(
                    //                                             milliseconds:
                    //                                                 300),
                    //                                     style: GoogleFonts
                    //                                         .nanumGothicCoding(
                    //                                       fontSize: 20,
                    //                                       color: Colors.white,
                    //                                       fontWeight:
                    //                                           FontWeight.w600,
                    //                                     ),
                    //                                     child:
                    //                                         const Text("SAVE"),
                    //                                   ),
                    //                                 ),
                    //                               ),
                    //                             ),
                    //                           ],
                    //                         ),
                    //                       ],
                    //                     ),
                    //                   ),
                    //                 ],
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //     );
                    //   }),
                    // ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    // const Spacer(),
                    SizedBox(
                      width: 125,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                            backgroundColor: colorGold,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                              ),
                            )),
                        child: Row(
                          children: [
                            AppTextNormal.labelW600(
                              "SAVE",
                              20,
                              Colors.black,
                            ),
                            10.pw,
                            const Icon(
                              Icons.arrow_upward_rounded,
                              color: Colors.red,
                              size: 25,
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
