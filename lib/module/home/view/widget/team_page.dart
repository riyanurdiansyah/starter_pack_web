import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:starter_pack_web/utils/app_extension.dart';

import '../../../../utils/app_color.dart';
import '../../../../utils/app_images.dart';
import '../../../../utils/app_text.dart';
import '../../controller/home_controller.dart';
import '../home_page.dart';

class TeamPage extends StatelessWidget {
  TeamPage({super.key});

  final _c = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width / 1.5,
      child: Obx(
        () {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _c.groups.length,
              (index) {
                final data = _c.groups[index];
                return Row(
                  children: [
                    if (index == 0)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Image.asset(
                          goldMedal,
                          width: 30,
                        ),
                      ),
                    if (index == 1)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Image.asset(
                          bronzeMedal,
                          width: 30,
                        ),
                      ),
                    if (index == 2)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Image.asset(
                          bronzeMedal,
                          width: 30,
                          color: Colors.brown,
                        ),
                      ),
                    if (index > 2)
                      const SizedBox(
                        width: 30,
                      ),
                    Expanded(
                      child: ClipPath(
                          clipper: CustomClipRank(),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: _c.userSession.value.groupId ==
                                      _c.groups[index].id
                                  ? colorGold
                                  : colorCardRank,
                            ),
                            margin: const EdgeInsets.only(bottom: 10, left: 20),
                            alignment: Alignment.center,
                            height: 45,
                            child: InkWell(
                              onTap: () {},
                              child: Row(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(left: 6),
                                    width: 50,
                                    child: AppTextNormal.labelBold(
                                      "${index + 1}",
                                      16,
                                      Colors.black,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 100,
                                    child: IconRank(
                                      oldRank: data.rankOld ?? 99,
                                      thenRank: data.rank ?? 99,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 80,
                                    child: CachedNetworkImage(
                                      imageUrl: data.image,
                                      width: 25,
                                      fit: BoxFit.cover,
                                      httpHeaders: const {
                                        'Access-Control-Allow-Origin': '*'
                                      },
                                      errorWidget: (context, url, error) =>
                                          const SizedBox(),
                                    ),
                                  ),
                                  10.pw,
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        AppTextNormal.labelBold(
                                          data.alias.toUpperCase(),
                                          12.5,
                                          Colors.black,
                                          letterSpacing: 3.5,
                                        ),
                                        // 5.ph,
                                        // Row(
                                        //   children: [
                                        //     CountryFlag
                                        //         .fromLanguageCode(
                                        //       data.country
                                        //           .toLowerCase(),
                                        //       width: 15,
                                        //       height: 12,
                                        //     ),
                                        //     8.pw,
                                        //     AppTextNormal
                                        //         .labelNormal(
                                        //       data.name,
                                        //       12,
                                        //       Colors.black,
                                        //     ),
                                        //   ],
                                        // ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: AppTextNormal.labelBold(
                                      "R\$ ${formatToThousandK(data.point)}",
                                      14,
                                      Colors.black,
                                    ),
                                  ),
                                  Container(
                                    width: 70,
                                    padding: const EdgeInsets.all(6),
                                    margin: const EdgeInsets.all(6),
                                    alignment: Alignment.center,
                                    decoration: const BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8)),
                                      color: colorPointRank,
                                    ),
                                    child: FittedBox(
                                      child: AppTextNormal.labelBold(
                                        "R\$ ${data.profit}",
                                        14,
                                        Colors.white,
                                      ),
                                    ),
                                  ),
                                  25.pw,
                                ],
                              ),
                            ),
                          )),
                    )
                  ],
                )
                    .animate() // Mulai menambahkan animasi
                    .fadeIn(
                      // Fade-in animasi
                      duration: 500.ms, // durasi 500ms
                      delay: (index * 300).ms, // delay bertahap per index
                    );
              },
            ),
          );
        },
      ),
    );
  }
}
