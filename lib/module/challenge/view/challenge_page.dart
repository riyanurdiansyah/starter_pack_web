import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:starter_pack_web/module/challenge/controller/challenge_controller.dart';
import 'package:starter_pack_web/utils/app_color.dart';
import 'package:starter_pack_web/utils/app_text.dart';

class ChallengePage extends StatelessWidget {
  ChallengePage({super.key});

  final _c = Get.find<ChallengeController>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // SizedBox(
          //   width: double.infinity,
          //   height: size.height,
          //   child: ColorFiltered(
          //     colorFilter: const ColorFilter.mode(
          //       Colors.black,
          //       BlendMode.saturation,
          //     ),
          //     child: Image.asset(
          //       bgUImage,
          //       fit: BoxFit.cover,
          //       filterQuality: FilterQuality.high,
          //     ),
          //   ),
          // ),
          Column(
            children: [
              Row(
                children: [
                  Obx(
                    () => Padding(
                      padding: const EdgeInsets.only(top: 18.0, left: 35),
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        onEnter: (_) {
                          _c.isHovered.value = true;
                        },
                        onExit: (_) {
                          _c.isHovered.value = false;
                        },
                        child: InkWell(
                          onTap: () => context.pop(),
                          child: Container(
                            alignment: Alignment.center,
                            color: Colors.black26,
                            height: 45,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 25.0),
                              child: AppTextNormal.labelBold(
                                "HOME",
                                26,
                                _c.isHovered.value
                                    ? colorElectricViolet
                                    : Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Obx(() {
                return Container(
                  height: size.height / 1.1,
                  alignment: Alignment.center,
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: Row(
                          children: List.generate(
                            _c.challenges.length,
                            (index) {
                              int displayIndex =
                                  (_c.currentIndex.value + index) %
                                      _c.challenges.length;
                              return Expanded(
                                child: ClipPath(
                                  clipper: MyClipper(),
                                  child: MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    onEnter: (_) {
                                      _c.isHoveredList[displayIndex] = true;
                                    },
                                    onExit: (_) {
                                      _c.isHoveredList[displayIndex] = false;
                                    },
                                    child: Stack(
                                      children: [
                                        ColorFiltered(
                                          colorFilter: ColorFilter.mode(
                                            _c.isHoveredList[displayIndex]
                                                ? Colors.transparent
                                                : Colors.grey,
                                            BlendMode.saturation,
                                          ),
                                          child: AnimatedContainer(
                                            duration: const Duration(
                                                milliseconds: 500),
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            height:
                                                _c.isHoveredList[displayIndex]
                                                    ? size.height / 1.4
                                                    : size.height / 1.5,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.white),
                                            ),
                                            child: CachedNetworkImage(
                                              imageUrl: _c
                                                  .challenges[displayIndex]
                                                  .image,
                                              placeholder: (context, url) =>
                                                  Shimmer.fromColors(
                                                baseColor: Colors.red,
                                                highlightColor: Colors.yellow,
                                                child: const SizedBox(
                                                  width: 200.0,
                                                  height: 100.0,
                                                ),
                                              ),
                                              filterQuality: FilterQuality.high,
                                              fit: BoxFit.fill,
                                              fadeOutDuration: const Duration(
                                                  milliseconds: 1000),
                                              fadeInDuration: const Duration(
                                                  milliseconds: 1000),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 0,
                                          child: Container(
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 20),
                                            child: Text(
                                              _c.challenges[displayIndex].name,
                                              style: TextStyle(
                                                fontFamily: "Race",
                                                fontSize: 26,
                                                color: _c.isHoveredList[
                                                        displayIndex]
                                                    ? colorElectricViolet
                                                    : Colors.white,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 4,
                                                shadows: !_c.isHoveredList[
                                                        displayIndex]
                                                    ? null
                                                    : [
                                                        const Shadow(
                                                          offset:
                                                              Offset(2.0, 2.0),
                                                          blurRadius: 1.0,
                                                          color: Colors.white,
                                                        ),
                                                      ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      // Tombol Previous
                      Positioned(
                        left: -20,
                        top: size.height / 3.5,
                        child: IconButton(
                          icon: Icon(
                            Icons.arrow_back_ios_rounded,
                            size: 60,
                            color: Colors.grey.shade600,
                          ),
                          onPressed: _c.previousImage,
                        ),
                      ),
                      // Tombol Next
                      Positioned(
                        right: 0,
                        top: size.height / 3.5,
                        child: IconButton(
                          icon: Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 60,
                            color: Colors.grey.shade600,
                          ),
                          onPressed: _c.nextImage,
                        ),
                      ),
                    ],
                  ),
                );
              })
            ],
          ),
        ],
      ),
    );
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double cutSizeShort = 20.0; // Ukuran potongan diagonal standar
    double cutSizeLong =
        45.0; // Ukuran potongan diagonal untuk kiri atas dan kiri bawah

    Path path = Path();

    // Mulai dari titik di sebelah kiri atas setelah potongan diagonal (lebih panjang)
    path.moveTo(cutSizeLong, 0);

    // Garis lurus ke kanan atas dengan potongan sudut kanan atas
    path.lineTo(size.width - cutSizeShort, 0);
    path.lineTo(size.width, cutSizeShort);

    // Garis lurus ke bawah kanan dengan potongan sudut kanan bawah
    path.lineTo(size.width, size.height - cutSizeLong);
    path.lineTo(size.width - cutSizeLong, size.height);

    // Garis lurus ke kiri bawah dengan potongan sudut kiri bawah (lebih panjang)
    path.lineTo(cutSizeShort, size.height);
    path.lineTo(0, size.height - cutSizeShort);

    // Garis lurus ke kiri atas dengan potongan sudut kiri atas (lebih panjang)
    path.lineTo(0, cutSizeLong);
    path.lineTo(cutSizeLong, 0);

    path.close(); // Menutup path
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
