import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:starter_pack_web/module/demography/controller/finance_controller.dart';
import 'package:starter_pack_web/utils/app_extension.dart';
import 'package:starter_pack_web/utils/app_images.dart';

import '../../../utils/app_color.dart';
import '../../../utils/app_sound.dart';
import '../../../utils/app_text.dart';

class FinancePage extends StatelessWidget {
  FinancePage({super.key});

  final _c = Get.find<FinanceController>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: size.height,
            child: Image.asset(
              bgSales,
              fit: BoxFit.fill,
            ),
          ),
          Container(
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
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
                      const Spacer(),
                      Obx(() {
                        if (_c.isDone.value) {
                          return const SizedBox();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(right: 45, top: 20),
                          child: ElevatedButton(
                            onPressed: _c.savePrice,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            child: AppTextNormal.labelBold(
                              "SAVE",
                              16,
                              Colors.black,
                            ),
                          ),
                        );
                      })
                    ],
                  ),
                ),
                18.ph,

                //batas
                Obx(() {
                  // if (_c.isDone.value) {
                  //   return Container(
                  //     margin: const EdgeInsets.only(right: 25),
                  //     width: double.infinity,
                  //     height: size.height / 1.2,
                  //     child: Align(
                  //       alignment: Alignment.bottomRight,
                  //       child: Padding(
                  //         padding: const EdgeInsets.only(bottom: 28.0),
                  //         child: AppTextNormal.labelBold(
                  //           "You have assigned price to the product...",
                  //           18,
                  //           Colors.black,
                  //         ),
                  //       ),
                  //     ),
                  //   );
                  // }

                  return Column(
                    children: [
                      AppTextNormal.labelBold(
                        "SELLING PRICE",
                        35,
                        Colors.white,
                        letterSpacing: 2,
                      ),
                      SingleChildScrollView(
                        child: SizedBox(
                          height: size.height / 1.4,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              _c.productsOwn.length,
                              (i) {
                                final prod = _c.productsOwn[i];
                                return MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  onEnter: (_) {
                                    _c.listHoveredProduct[i] = true;
                                  },
                                  onExit: (_) {
                                    _c.listHoveredProduct[i] = false;
                                  },
                                  child: Stack(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 24),
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 60, vertical: 10),
                                        height: 140,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: _c.listHoveredProduct[i]
                                                ? [
                                                    colorPointRank,
                                                    colorPointRank
                                                  ]
                                                : i.isOdd
                                                    ? [
                                                        colorPointRank,
                                                        colorPrimaryDark,
                                                      ]
                                                    : [
                                                        colorPrimaryDark,
                                                        colorPointRank,
                                                      ],
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: i.isOdd
                                              ? MainAxisAlignment.start
                                              : MainAxisAlignment.end,
                                          children: [
                                            if (i.isEven) 175.pw,
                                            i.isOdd
                                                ? Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 80.0),
                                                    child:
                                                        AppTextNormal.labelBold(
                                                      "${prod.nama} ${prod.tipe}",
                                                      28,
                                                      Colors.white,
                                                    ),
                                                  )
                                                : Row(
                                                    children: [
                                                      if (!_c.isDone.value)
                                                        AppTextNormal.labelBold(
                                                          "\$ ${prod.minPrice}",
                                                          14,
                                                          Colors.white,
                                                        ),
                                                      if (!_c.isDone.value)
                                                        14.pw,
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          AppTextNormal
                                                              .labelBold(
                                                            "\$ ${_c.priceSliders[i].toStringAsFixed(1)}",
                                                            18,
                                                            Colors.white,
                                                          ),
                                                          if (!_c.isDone.value)
                                                            Slider(
                                                              activeColor:
                                                                  colorGold,
                                                              value:
                                                                  _c.priceSliders[
                                                                      i],
                                                              max:
                                                                  prod.maxPrice,
                                                              min:
                                                                  prod.minPrice,
                                                              label: _c
                                                                  .priceSliders[
                                                                      i]
                                                                  .toString(),
                                                              onChanged: (double
                                                                  value) {
                                                                _c.priceSliders[
                                                                    i] = value;
                                                              },
                                                            ),
                                                        ],
                                                      ),
                                                      if (!_c.isDone.value)
                                                        14.pw,
                                                      if (!_c.isDone.value)
                                                        AppTextNormal.labelBold(
                                                          "\$ ${prod.maxPrice}",
                                                          14,
                                                          Colors.white,
                                                        ),
                                                    ],
                                                  ),
                                            const Spacer(),
                                            i.isOdd
                                                ? Row(
                                                    children: [
                                                      if (!_c.isDone.value)
                                                        AppTextNormal.labelBold(
                                                          "\$ ${prod.minPrice}",
                                                          14,
                                                          Colors.white,
                                                        ),
                                                      if (!_c.isDone.value)
                                                        14.pw,
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          AppTextNormal
                                                              .labelBold(
                                                            "\$ ${_c.priceSliders[i].toStringAsFixed(1)}",
                                                            18,
                                                            Colors.white,
                                                          ),
                                                          if (!_c.isDone.value)
                                                            Slider(
                                                              activeColor:
                                                                  colorGold,
                                                              value:
                                                                  _c.priceSliders[
                                                                      i],
                                                              max:
                                                                  prod.maxPrice,
                                                              min:
                                                                  prod.minPrice,
                                                              label: _c
                                                                  .priceSliders[
                                                                      i]
                                                                  .toString(),
                                                              onChanged: (double
                                                                  value) {
                                                                _c.priceSliders[
                                                                    i] = value;
                                                              },
                                                            ),
                                                        ],
                                                      ),
                                                      if (!_c.isDone.value)
                                                        14.pw,
                                                      if (!_c.isDone.value)
                                                        AppTextNormal.labelBold(
                                                          "\$ ${prod.maxPrice}",
                                                          14,
                                                          Colors.white,
                                                        ),
                                                    ],
                                                  )
                                                : Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 80.0),
                                                    child:
                                                        AppTextNormal.labelBold(
                                                      "${prod.nama} ${prod.tipe}",
                                                      28,
                                                      Colors.white,
                                                    ),
                                                  ),
                                            if (i.isOdd) 175.pw,
                                          ],
                                        ),
                                      ),
                                      Positioned(
                                        right: i.isEven ? null : 20,
                                        left: i.isOdd ? null : 20,
                                        top: 0,
                                        bottom: 0,
                                        child: Container(
                                          padding: const EdgeInsets.all(1.6),
                                          color: Colors.white,
                                          width: 200,
                                          height: 200,
                                          child: Container(
                                            padding: const EdgeInsets.all(6),
                                            color: colorPrimaryDark,
                                            child: CachedNetworkImage(
                                              imageUrl: prod.image,
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  );

                  //BATAS
                  // return Expanded(
                  //   child: Form(
                  //     key: _c.formKey,
                  //     child: ListView(
                  //       children: List.generate(_c.demographys.length, (index) {
                  //         final data = _c.demographys[index];
                  //         return ExpansionTile(
                  //           title: Row(
                  //             children: [
                  //               AppTextNormal.labelBold(
                  //                 "${data.name} ",
                  //                 16,
                  //                 Colors.black,
                  //               ),
                  //               AppTextNormal.labelBold(
                  //                 "  -  Cost: ${data.cost}/item",
                  //                 12,
                  //                 Colors.grey.shade600,
                  //               ),
                  //             ],
                  //           ),
                  //           children: List.generate(_c.productsOwn.length,
                  //               (subindex) {
                  //             final prod = _c.productsOwn[subindex];
                  //             return Padding(
                  //               padding: const EdgeInsets.only(bottom: 16.0),
                  //               child: Row(
                  //                 mainAxisAlignment: MainAxisAlignment.center,
                  //                 children: [
                  //                   Expanded(
                  //                     child: Row(
                  //                       children: [
                  //                         CachedNetworkImage(
                  //                           imageUrl: prod.image,
                  //                           width: 90,
                  //                           height: 90,
                  //                         ),
                  //                         18.pw,
                  //                         AppTextNormal.labelBold(
                  //                           "${prod.nama} - ${prod.tipe}",
                  //                           16,
                  //                           Colors.black,
                  //                         ),
                  //                         20.pw,
                  //                       ],
                  //                     ),
                  //                   ),
                  //                   Expanded(
                  //                       child: Column(
                  //                     children: [
                  //                       AppTextNormal.labelBold(
                  //                         "Standard Price: \$${data.details[data.details.indexWhere((e) {
                  //                           return e.productId == prod.id;
                  //                         })].minPrice} - \$${data.details[data.details.indexWhere((e) {
                  //                           return e.productId == prod.id;
                  //                         })].maxPrice}",
                  //                         16,
                  //                         Colors.grey.shade600,
                  //                       ),
                  //                     ],
                  //                   )),
                  //                   Expanded(
                  //                     flex: 2,
                  //                     child: TextFormField(
                  //                       controller: _c.accessList[index]
                  //                           ["controller"][subindex],
                  //                       textInputAction: TextInputAction.next,
                  //                       decoration: textFieldAuthDecoration(
                  //                         fontSize: 14,
                  //                         hintText: "",
                  //                         radius: 4,
                  //                       ),
                  //                       inputFormatters: [
                  //                         FilteringTextInputFormatter.allow(
                  //                             RegExp(r'[0-9.]')),
                  //                       ],
                  //                       autovalidateMode:
                  //                           AutovalidateMode.onUserInteraction,
                  //                       onChanged: (value) {},
                  //                       validator: (val) {
                  //                         if (val != null && val.isNotEmpty) {
                  //                           var dig = val.replaceAll(",", ".");
                  //                           double? number =
                  //                               double.tryParse(dig);
                  //                           if (number == null ||
                  //                               number <
                  //                                   (data
                  //                                       .details[data.details
                  //                                           .indexWhere((e) {
                  //                                     return e.productId ==
                  //                                         prod.id;
                  //                                   })]
                  //                                       .minPrice) ||
                  //                               number >
                  //                                   (data
                  //                                       .details[data.details
                  //                                           .indexWhere((e) {
                  //                                     return e.productId ==
                  //                                         prod.id;
                  //                                   })]
                  //                                       .maxPrice)) {
                  //                             return "Price must be between R\$ ${data.details[data.details.indexWhere((e) {
                  //                               return e.productId == prod.id;
                  //                             })].minPrice} - R\$ ${data.details[data.details.indexWhere((e) {
                  //                               return e.productId == prod.id;
                  //                             })].maxPrice}";
                  //                           }
                  //                         } else {
                  //                           return "Price cant be empty";
                  //                         }
                  //                         return null;
                  //                       },
                  //                     ),
                  //                   ),
                  //                 ],
                  //               ),
                  //             );
                  //           }),
                  //         );
                  //       }),
                  //     ),
                  //   ),
                  // );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
