import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:starter_pack_web/module/demography/controller/distribute_controller.dart';
import 'package:starter_pack_web/utils/app_extension.dart';
import 'package:starter_pack_web/utils/app_images.dart';

import '../../../utils/app_color.dart';
import '../../../utils/app_decoration.dart';
import '../../../utils/app_sound.dart';
import '../../../utils/app_text.dart';

class DistributePage extends StatelessWidget {
  DistributePage({super.key});

  final _c = Get.find<DistributeController>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.8),
      body: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: size.height,
            child: Image.asset(
              bgDistribution,
              fit: BoxFit.fill,
            ),
          ),
          Column(
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
                    ElevatedButton(
                      onPressed: () {
                        _c.saveDistribute();
                      },
                      child: AppTextNormal.labelBold(
                        "SAVE",
                        16,
                        Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              18.ph,

              //batas
              Obx(() {
                if (_c.sellings.isEmpty) {
                  return SizedBox(
                    width: double.infinity,
                    height: size.height / 1.6,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppTextNormal.labelBold(
                          "Your team member in the Sales role has not yet\ndecided on the price for the product.",
                          20,
                          Colors.white,
                          maxLines: 3,
                          textAlign: TextAlign.center,
                          height: 1.4,
                          letterSpacing: 2.5,
                          shadows: [
                            const Shadow(
                              offset:
                                  Offset(-1.5, -1.5), // Bayangan ke kiri atas
                              color: Colors.black,
                              blurRadius: 1.0,
                            ),
                            const Shadow(
                              offset:
                                  Offset(1.5, -1.5), // Bayangan ke kanan atas
                              color: Colors.black,
                              blurRadius: 1.0,
                            ),
                            const Shadow(
                              offset:
                                  Offset(1.5, 1.5), // Bayangan ke kanan bawah
                              color: Colors.black,
                              blurRadius: 1.0,
                            ),
                            const Shadow(
                              offset:
                                  Offset(-1.5, 1.5), // Bayangan ke kiri bawah
                              color: Colors.black,
                              blurRadius: 1.0,
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }
                return Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Form(
                          key: _c.formKey,
                          child: ListView(
                            children: List.generate(_c.sellings[0].areas.length,
                                (index) {
                              final data = _c.sellings[0].areas[index];
                              return ExpansionTile(
                                title: Row(
                                  children: [
                                    AppTextNormal.labelBold(
                                      "${data.name} ",
                                      16,
                                      Colors.black,
                                    ),
                                    AppTextNormal.labelBold(
                                      "  -  Cost: ${data.cost}/item",
                                      12,
                                      Colors.grey.shade600,
                                    ),
                                  ],
                                ),
                                children: List.generate(
                                    _c.sellings[0].areas[index].products.length,
                                    (subindex) {
                                  final prod = _c.sellings[0].areas[index]
                                      .products[subindex];
                                  return Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 16.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Row(
                                            children: [
                                              CachedNetworkImage(
                                                imageUrl: prod.image,
                                                width: 60,
                                                height: 60,
                                              ),
                                              18.pw,
                                              AppTextNormal.labelBold(
                                                "${prod.nama} - ${prod.tipe}",
                                                16,
                                                Colors.black,
                                              ),
                                              const Spacer(),
                                              AppTextNormal.labelBold(
                                                "Stock : ${_c.productsOwn.firstWhereOrNull((x) => x.id == prod.id)?.qty ?? 0}",
                                                16,
                                                Colors.grey.shade600,
                                              ),
                                              const Spacer(),
                                              AppTextNormal.labelBold(
                                                "Price : ${prod.priceDistribute}",
                                                16,
                                                Colors.grey.shade600,
                                              ),
                                              20.pw,
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Row(
                                            children: [
                                              16.pw,
                                              OutlinedButton(
                                                onPressed: () {
                                                  _c.decrementQuantity(
                                                      index, subindex);
                                                },
                                                style: OutlinedButton.styleFrom(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                  ),
                                                ),
                                                child: AppTextNormal.labelBold(
                                                  "-",
                                                  16,
                                                  Colors.grey.shade600,
                                                ),
                                              ),
                                              16.pw,
                                              Expanded(
                                                child: TextFormField(
                                                  controller: _c
                                                          .accessList[index]
                                                      ["controller"][subindex],
                                                  textInputAction:
                                                      TextInputAction.next,
                                                  decoration:
                                                      textFieldAuthDecoration(
                                                          fontSize: 14,
                                                          hintText: "",
                                                          radius: 4),
                                                  inputFormatters: [
                                                    FilteringTextInputFormatter
                                                        .digitsOnly,
                                                  ],
                                                  // readOnly: true,
                                                  autovalidateMode:
                                                      AutovalidateMode
                                                          .onUserInteraction,
                                                  onChanged: (value) {
                                                    int? newQty =
                                                        int.tryParse(value);
                                                    if (newQty != null) {
                                                      _c
                                                              .areas[_c.areas
                                                                  .indexWhere((e) =>
                                                                      e.areaId ==
                                                                      data.id)]
                                                              .products[0] =
                                                          _c
                                                              .areas[_c.areas
                                                                  .indexWhere((e) =>
                                                                      e.areaId ==
                                                                      data.id)]
                                                              .products[0]
                                                              .copyWith(
                                                                  qtyToWH: 20);
                                                    }
                                                  },
                                                ),
                                              ),
                                              16.pw,
                                              OutlinedButton(
                                                onPressed: () {
                                                  _c.incrementQuantity(
                                                      index, subindex);
                                                },
                                                style: OutlinedButton.styleFrom(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                  ),
                                                ),
                                                child: AppTextNormal.labelBold(
                                                  "+",
                                                  16,
                                                  Colors.grey.shade600,
                                                ),
                                              ),
                                              16.pw,
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                              );
                            }),
                          ),
                        ),
                      ),
                      Expanded(
                        child:
                            // Obx(
                            //   () =>
                            Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 100),
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
                                  Obx(
                                    () => Row(
                                      children:
                                          List.generate(_c.areas.length, (i) {
                                        final area = _c.areas[i];
                                        return Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 6),
                                              child: OutlinedButton(
                                                onPressed: () {
                                                  _c.indexArea.value = i;
                                                },
                                                style: OutlinedButton.styleFrom(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                  ),
                                                  backgroundColor:
                                                      i == _c.indexArea.value
                                                          ? colorPrimaryDark
                                                              .withOpacity(0.75)
                                                          : null,
                                                ),
                                                child: AppTextNormal.labelW600(
                                                  area.areaName,
                                                  14,
                                                  i == _c.indexArea.value
                                                      ? Colors.white
                                                      : Colors.black,
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      }),
                                    ),
                                  ),
                                  25.ph,
                                  Obx(
                                    () => Column(
                                      children: List.generate(
                                          _c.areas[_c.indexArea.value].products
                                              .length, (subindex) {
                                        // final product = _c
                                        //     .areas[_c.indexArea.value]
                                        //     .products[subindex];
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 18.0),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                flex: 2,
                                                child: AppTextNormal.labelBold(
                                                  _c
                                                      .areas[_c.indexArea.value]
                                                      .products[subindex]
                                                      .productName,
                                                  12.5,
                                                  Colors.black,
                                                ),
                                              ),
                                              Expanded(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    AppTextNormal.labelW600(
                                                      "To WH",
                                                      10.5,
                                                      Colors.grey.shade600,
                                                    ),
                                                    12.ph,
                                                    Obx(
                                                      () => AppTextNormal
                                                          .labelBold(
                                                        "+${_c.areas[_c.indexArea.value].products[subindex].qtyToWH.toString()}",
                                                        11.5,
                                                        Colors.green,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const Icon(
                                                Icons.arrow_forward,
                                                color: Colors.green,
                                                size: 14.5,
                                              ),
                                              Expanded(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    AppTextNormal.labelW600(
                                                      "In WH",
                                                      10.5,
                                                      Colors.grey.shade600,
                                                    ),
                                                    12.ph,
                                                    AppTextNormal.labelBold(
                                                      _c
                                                          .areas[_c
                                                              .indexArea.value]
                                                          .products[subindex]
                                                          .qty
                                                          .toString(),
                                                      11.5,
                                                      Colors.black,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }),
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      14.ph,
                                      Container(
                                        height: 2.5,
                                        width: double.infinity,
                                        color: Colors.grey.shade300,
                                      ),
                                      16.ph,
                                      // Obx(
                                      //   () => MouseRegion(
                                      //     onEnter: (_) => AppSound.playHover(),
                                      //     child: SizedBox(
                                      //       width: double.infinity,
                                      //       height: 45,
                                      //       child: ElevatedButton(
                                      //         onPressed: () {},
                                      //         style: ElevatedButton.styleFrom(
                                      //           backgroundColor: colorPointRank,
                                      //           shape: RoundedRectangleBorder(
                                      //             borderRadius:
                                      //                 BorderRadius.circular(8),
                                      //           ),
                                      //         ),
                                      //         child: AppTextNormal.labelBold(
                                      //           "SAVE",
                                      //           22,
                                      //           Colors.white,
                                      //           letterSpacing: 1.8,
                                      //         ),
                                      //       ),
                                      //     ),
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      // ),
                      16.pw,
                    ],
                  ),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }
}
