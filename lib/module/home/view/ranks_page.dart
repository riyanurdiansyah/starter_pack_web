import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:starter_pack_web/module/home/controller/ranks_controller.dart';
import 'package:starter_pack_web/utils/app_extension.dart';

import '../../../utils/app_color.dart';
import '../../../utils/app_images.dart';
import '../../../utils/app_sound.dart';
import '../../../utils/app_text.dart';

class RanksPage extends StatelessWidget {
  RanksPage({super.key});

  final _c = Get.find<RanksController>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isMobile = MediaQuery.sizeOf(context).width < 600;
    return Scaffold(
      body: Obx(() {
        if (_c.isLoading.value) {
          return Container(
            color: Colors.black,
            width: double.infinity,
            height: size.height,
            child: Container(
              width: 250,
              height: 150,
              alignment: Alignment.center,
              child: Image.asset(
                loadingGif,
                fit: BoxFit.cover,
                filterQuality: FilterQuality.high,
                width: 250,
              ),
            ),
          );
        }
        return Stack(
          children: [
            SizedBox(
              width: double.infinity,
              height: size.height,
              child: Image.asset(
                bgSales,
                fit: BoxFit.fill,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                        margin: const EdgeInsets.symmetric(
                            horizontal: 26, vertical: 20),
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
                16.ph,
                Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: AppTextNormal.labelBold(
                    "Simulation Recap",
                    24,
                    Colors.white,
                  ),
                ),
                50.ph,
                Expanded(
                  child: ListView.builder(
                    itemCount: _c.simbis
                        .length, // Menampilkan ConfigSimbs terlebih dahulu
                    itemBuilder: (context, configIndex) {
                      final config = _c.simbis[configIndex];

                      return ExpansionTile(
                        trailing: const SizedBox.shrink(),
                        title: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          onEnter: (_) {
                            // _c.listHoveredProduct[i] = true;
                          },
                          onExit: (_) {
                            // _c.listHoveredProduct[i] = false;
                          },
                          child: Stack(
                            children: [
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 24),
                                margin: EdgeInsets.only(
                                    right: configIndex.isEven ? 30 : 60,
                                    left: configIndex.isOdd ? 30 : 60,
                                    top: 10,
                                    bottom: 10),
                                height: 140,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: configIndex.isOdd
                                        ? [
                                            colorElectricViolet,
                                            colorPrimaryDark,
                                          ]
                                        : [
                                            colorPrimaryDark,
                                            colorElectricViolet,
                                          ],
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    AppTextNormal.labelBold(
                                      config.name,
                                      24,
                                      Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                right: configIndex.isEven ? null : 20,
                                left: configIndex.isOdd ? null : 20,
                                top: 0,
                                bottom: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  width: 200,
                                  height: 200,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(
                                            0.25), // Warna bayangan dengan transparansi
                                        spreadRadius: 12, // Penyebaran bayangan
                                        blurRadius: 8, // Kekaburan bayangan
                                        offset: const Offset(
                                            2, 4), // Posisi bayangan (x, y)
                                      ),
                                    ],
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: colorPrimaryDark,
                                    ),
                                    // child: CachedNetworkImage(
                                    //   imageUrl: prod.image,
                                    //   fit: BoxFit.fill,
                                    // ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        children: List.generate(
                          _c.demographys.length,
                          (i) {
                            final area = _c.demographys[i];
                            final d = _c.distributes
                                .where((e) => e.cycleId == config.id)
                                .toList();
                            return ExpansionTile(
                                trailing: const SizedBox.shrink(),
                                title: Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 25),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 25),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade600,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      configIndex.isOdd ? 0.pw : 60.pw,
                                      Expanded(
                                        child: Center(
                                          child: AppTextNormal.labelBold(
                                            area.name,
                                            20,
                                            Colors.white,
                                          ),
                                        ),
                                      ),
                                      configIndex.isEven ? 60.pw : 0.pw,
                                    ],
                                  ),
                                ),
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(
                                        bottom: 10,
                                        left: isMobile ? 0 : 40,
                                        right: 80),
                                    height: 60,
                                    width: double.infinity,
                                    color: Colors.grey.shade400,
                                    child: Row(
                                      children: [
                                        14.pw,
                                        Expanded(
                                          flex: 1,
                                          child: AppTextNormal.labelBold(
                                            "GROUP",
                                            14,
                                            colorPrimaryDark,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 4,
                                          child: Center(
                                            child: AppTextNormal.labelBold(
                                              "PRODUCT SOLD",
                                              14,
                                              colorPrimaryDark,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              AppTextNormal.labelBold(
                                                "REVENUE",
                                                14,
                                                colorPrimaryDark,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    children: List.generate(
                                        _c.sortDistributeListByProfit(d).length,
                                        (k) {
                                      final areas = _c
                                          .sortDistributeListByProfit(d)[k]
                                          .areas
                                          .where((x) => x.areaId == area.id)
                                          .toList();
                                      final products = areas[areas.indexWhere(
                                              (u) => u.areaId == area.id)]
                                          .products;
                                      return SizedBox(
                                        width: double.infinity,
                                        height: 60,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          decoration: const BoxDecoration(
                                            color: colorCardRank,
                                          ),
                                          margin: EdgeInsets.only(
                                              bottom: 10,
                                              left: isMobile ? 0 : 40,
                                              right: 80),
                                          alignment: Alignment.center,
                                          height: 45,
                                          child: InkWell(
                                            onTap: () {},
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                    flex: 1,
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        AppTextNormal.labelBold(
                                                          "${k + 1}. ",
                                                          16.5,
                                                          Colors.black,
                                                        ),
                                                        Container(
                                                          margin:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 6),
                                                          child: AppTextNormal
                                                              .labelBold(
                                                            _c.groups
                                                                    .firstWhereOrNull((e) =>
                                                                        e.id ==
                                                                        _c
                                                                            .sortDistributeListByProfit(d)[k]
                                                                            .groupId)
                                                                    ?.alias ??
                                                                "-",
                                                            16,
                                                            Colors.black,
                                                          ),
                                                        ),
                                                      ],
                                                    )),
                                                Expanded(
                                                  flex: 4,
                                                  child: Center(
                                                    child:
                                                        AppTextNormal.labelBold(
                                                      "${products.fold(0, (sum, item) => sum + item.qty)} pcs",
                                                      12.5,
                                                      Colors.black,
                                                      letterSpacing: 3.5,
                                                      maxLines: 5,
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Container(
                                                    width: 70,
                                                    padding:
                                                        const EdgeInsets.all(6),
                                                    margin:
                                                        const EdgeInsets.all(6),
                                                    alignment: Alignment.center,
                                                    decoration:
                                                        const BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  8)),
                                                      color: colorPointRank,
                                                    ),
                                                    child: FittedBox(
                                                      child: AppTextNormal
                                                          .labelBold(
                                                        "R\$ ${products.fold(0.0, (sum, item) => sum + item.profit)}",
                                                        14,
                                                        Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                                  )
                                ]);
                          },
                        ),
                      );
                    },
                  ),
                ),
                50.ph,
                // SizedBox(
                //   height: size.height / 1.4,
                //   child: Column(
                //     children: List.generate(
                //       _c.simbis.length,
                //       (i) {
                //         final prod = _c.simbis[i];
                //         final config = _c.simbis[i];
                //         return ExpansionTile(
                //           tilePadding: EdgeInsets.zero,
                //           title: MouseRegion(
                //             cursor: SystemMouseCursors.click,
                //             onEnter: (_) {
                //               // _c.listHoveredProduct[i] = true;
                //             },
                //             onExit: (_) {
                //               // _c.listHoveredProduct[i] = false;
                //             },
                //             child: Stack(
                //               children: [
                //                 Container(
                //                   padding: const EdgeInsets.symmetric(
                //                       horizontal: 24),
                //                   margin: const EdgeInsets.symmetric(
                //                       horizontal: 60, vertical: 10),
                //                   height: 140,
                //                   decoration: BoxDecoration(
                //                     gradient: LinearGradient(
                //                       colors: i.isOdd
                //                           ? [
                //                               colorElectricViolet,
                //                               colorPrimaryDark,
                //                             ]
                //                           : [
                //                               colorPrimaryDark,
                //                               colorElectricViolet,
                //                             ],
                //                     ),
                //                   ),
                //                   child: Row(
                //                     mainAxisAlignment: MainAxisAlignment.center,
                //                     children: [
                //                       AppTextNormal.labelBold(
                //                         prod.name,
                //                         24,
                //                         Colors.white,
                //                       ),
                //                     ],
                //                   ),
                //                 ),
                //                 Positioned(
                //                   right: i.isEven ? null : 20,
                //                   left: i.isOdd ? null : 20,
                //                   top: 0,
                //                   bottom: 0,
                //                   child: Container(
                //                     padding: const EdgeInsets.all(8),
                //                     width: 200,
                //                     height: 200,
                //                     decoration: BoxDecoration(
                //                       borderRadius: BorderRadius.circular(10),
                //                       color: Colors.white,
                //                       boxShadow: [
                //                         BoxShadow(
                //                           color: Colors.black.withOpacity(
                //                               0.25), // Warna bayangan dengan transparansi
                //                           spreadRadius:
                //                               12, // Penyebaran bayangan
                //                           blurRadius: 8, // Kekaburan bayangan
                //                           offset: const Offset(
                //                               2, 4), // Posisi bayangan (x, y)
                //                         ),
                //                       ],
                //                     ),
                //                     child: Container(
                //                       padding: const EdgeInsets.all(6),
                //                       decoration: BoxDecoration(
                //                         borderRadius: BorderRadius.circular(10),
                //                         color: colorPrimaryDark,
                //                       ),
                //                       // child: CachedNetworkImage(
                //                       //   imageUrl: prod.image,
                //                       //   fit: BoxFit.fill,
                //                       // ),
                //                     ),
                //                   ),
                //                 ),
                //               ],
                //             ),
                //           ),
                //           trailing: const SizedBox.shrink(),
                //           children: List.generate(_c.demographys.length, (j) {
                //             final area = _c.demographys[j];
                //             final d = _c.distributes
                //                 .where((e) => e.cycleId == config.id)
                //                 .toList();
                //             return Column(
                //               children: List.generate(d.length, (k) {
                //                 return ExpansionTile(title: d[k].areas)
                //               }),
                //             );
                //           }),
                //         );
                //       },
                //     ),
                //   ),
                // ),
              ],
            )
          ],
        );
      }),
    );
  }
}
