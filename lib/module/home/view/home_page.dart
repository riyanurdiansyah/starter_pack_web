import 'package:cached_network_image/cached_network_image.dart';
import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:starter_pack_web/module/home/controller/home_controller.dart';
import 'package:starter_pack_web/utils/app_extension.dart';
import 'package:starter_pack_web/utils/app_text.dart';

import '../../../utils/app_images.dart';

class CustomClipRank extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0.0, 0.0);
    path.lineTo(0.0, size.height);
    path.lineTo(size.width / 1.025, size.height);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final _c = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        alignment: Alignment.topCenter,
        width: size.width,
        color: Colors.grey.shade200.withOpacity(0.2),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                20.ph,
                Container(
                  margin: const EdgeInsets.only(left: 50),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  width: size.width / 1.6,
                  height: 40,
                  color: Colors.amber.shade200,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 50,
                        child: AppTextNormal.labelBold(
                          "RANK",
                          14,
                          Colors.black,
                        ),
                      ),
                      SizedBox(
                        width: 100,
                        child: AppTextNormal.labelBold(
                          "EVOLUTION",
                          14,
                          Colors.black,
                        ),
                      ),
                      SizedBox(
                        width: 80,
                        child: AppTextNormal.labelBold(
                          "",
                          14,
                          Colors.black,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: AppTextNormal.labelBold(
                          "TEAM",
                          14,
                          Colors.black,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: AppTextNormal.labelBold(
                          "RESULT",
                          14,
                          Colors.black,
                        ),
                      ),
                      SizedBox(
                        width: 70,
                        child: AppTextNormal.labelBold(
                          "MONEY",
                          14,
                          Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                20.ph,
                SizedBox(
                    width: size.width / 1.5,
                    child: Obx(() {
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
                                      silverMedal,
                                      width: 30,
                                    ),
                                  ),
                                if (index == 2)
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Image.asset(
                                      bronzeMedal,
                                      width: 30,
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
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.2),
                                        ),
                                        margin: const EdgeInsets.only(
                                            bottom: 10, left: 20),
                                        alignment: Alignment.center,
                                        height: 45,
                                        child: InkWell(
                                          onTap: () {},
                                          child: Row(
                                            children: [
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    left: 6),
                                                width: 50,
                                                child: AppTextNormal.labelBold(
                                                  "${index + 1}",
                                                  16,
                                                  Colors.white,
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
                                                    'Access-Control-Allow-Origin':
                                                        '*'
                                                  },
                                                  errorWidget:
                                                      (context, url, error) =>
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
                                                      14,
                                                      Colors.white,
                                                    ),
                                                    5.ph,
                                                    Row(
                                                      children: [
                                                        CountryFlag
                                                            .fromLanguageCode(
                                                          data.country
                                                              .toLowerCase(),
                                                          width: 15,
                                                          height: 12,
                                                        ),
                                                        8.pw,
                                                        AppTextNormal
                                                            .labelNormal(
                                                          data.name,
                                                          12,
                                                          Colors.white30,
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: AppTextNormal.labelBold(
                                                  "RESULT",
                                                  14,
                                                  Colors.black,
                                                ),
                                              ),
                                              Container(
                                                width: 80,
                                                margin: const EdgeInsets.all(6),
                                                alignment: Alignment.center,
                                                decoration: const BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(8)),
                                                  color: Colors.red,
                                                ),
                                                child: AppTextNormal.labelBold(
                                                  "\$ ${data.point}",
                                                  14,
                                                  Colors.white,
                                                ),
                                              ),
                                              36.pw,
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
                                  delay: (index * 300)
                                      .ms, // delay bertahap per index
                                );
                          },
                        ),
                      );
                    })),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class IconRank extends StatelessWidget {
  const IconRank({super.key, required this.oldRank, required this.thenRank});

  final int oldRank;
  final int thenRank;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if ((oldRank - thenRank) > 0)
          const Center(
            child: Icon(
              Icons.arrow_drop_up_rounded,
              color: Colors.green,
              size: 25,
            ),
          ),
        if ((oldRank - thenRank) < 0)
          const Center(
            child: Icon(
              Icons.arrow_drop_down_rounded,
              color: Colors.red,
              size: 25,
            ),
          ),
        Center(
          child: AppTextNormal.labelBold(
            (oldRank - thenRank) > 0
                ? "+${(oldRank - thenRank).toString()}"
                : (oldRank - thenRank) < 0
                    ? (oldRank - thenRank).toString()
                    : "",
            12,
            (oldRank - thenRank) > 0
                ? Colors.green
                : (oldRank - thenRank) < 0
                    ? Colors.red
                    : Colors.white,
          ),
        ),
      ],
    );
  }
}
