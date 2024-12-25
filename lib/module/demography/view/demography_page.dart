import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:starter_pack_web/middleware/app_route_name.dart';
import 'package:starter_pack_web/module/demography/controller/demography_controller.dart';
import 'package:starter_pack_web/utils/app_extension.dart';
import 'package:starter_pack_web/utils/app_images.dart';
import 'package:starter_pack_web/utils/app_text.dart';

import '../../../utils/app_dialog.dart';

class DemographyPage extends StatefulWidget {
  const DemographyPage({super.key});

  @override
  State<DemographyPage> createState() => _DemographyPageState();
}

class _DemographyPageState extends State<DemographyPage>
    with SingleTickerProviderStateMixin {
  final _c = Get.find<DemographyController>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Obx(() {
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
      return Scaffold(
        body: Obx(
          () => Stack(
            children: [
              SizedBox(
                width: size.width,
                height: size.height,
                child: Image.asset(
                  bgDemography,
                  fit: BoxFit.fill,
                ),
              ),
              Stack(
                children: List.generate(_c.demographys.length, (index) {
                  return Positioned(
                    left: _c.demographys[index].left == 0
                        ? null
                        : size.width / _c.demographys[index].left,
                    right: _c.demographys[index].right == 0
                        ? null
                        : size.width / _c.demographys[index].right,
                    bottom: _c.demographys[index].bottom == 0
                        ? null
                        : _c.demographys[index].bottom,
                    top: _c.demographys[index].top == 0
                        ? null
                        : _c.demographys[index].top,
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      onEnter: (_) => _c.demographys[index] =
                          _c.demographys[index].copyWith(
                        isHovered: true,
                      ),
                      onExit: (_) => setState(() => _c.demographys[index] =
                              _c.demographys[index].copyWith(
                            isHovered: false,
                          )),
                      child: InkWell(
                        onTap: () => _c.toggleWidget(index),
                        child: Container(
                          color: Colors.transparent,
                          alignment: Alignment.center,
                          width: 125,
                          height: 125,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Stack(
                                children: [
                                  Center(
                                    child: ScaleTransition(
                                      scale: _c.animation,
                                      child: const Icon(
                                        Icons.location_on,
                                        color: Colors.white,
                                        size: 70,
                                      ),
                                    ),
                                  ),
                                  Center(
                                    child: ScaleTransition(
                                      scale: _c.animation,
                                      child: const Icon(
                                        Icons.location_on,
                                        color: Colors.red,
                                        size: 60,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Positioned(
                                top: 0,
                                bottom: 90,
                                right: 0,
                                left: 0,
                                child: AnimatedOpacity(
                                  duration: const Duration(milliseconds: 300),
                                  opacity: _c.demographys[index].isHovered
                                      ? 1.0
                                      : 0.0,
                                  child: AnimatedDefaultTextStyle(
                                    duration: const Duration(milliseconds: 300),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontFamily: 'Race',
                                      fontSize: 16,
                                      height: 2.5,
                                      letterSpacing: 5,
                                      color: Colors.white, // Warna utama teks
                                      fontStyle: FontStyle.italic,
                                      shadows: [
                                        Shadow(
                                          // Shadow pertama untuk outline
                                          offset: Offset(1.5, 1.5),
                                          blurRadius: 2.0,
                                          color: Colors
                                              .red, // Warna pinggiran merah
                                        ),
                                        Shadow(
                                          // Shadow kedua untuk outline lebih tebal
                                          offset: Offset(-1.5, -1.5),
                                          blurRadius: 2.0,
                                          color: Colors
                                              .red, // Warna pinggiran merah
                                        ),
                                      ],
                                    ),
                                    child: FittedBox(
                                        child:
                                            Text(_c.demographys[index].name)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
              Positioned(
                left: 150,
                bottom: 50,
                child: ElevatedButton(
                  onPressed: () {
                    context.goNamed(AppRouteName.distribute);
                  },
                  child: AppTextNormal.labelBold(
                    "DISTRIBUTE",
                    16,
                    Colors.red,
                  ),
                ),
              ),
              Obx(() {
                return AnimatedPositioned(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  top: 0,
                  bottom: 0,
                  right: _c.isWidgetVisible.value
                      ? 0
                      : -size.width * 0.5, // Off-screen when hidden
                  width: size.width * 0.35,
                  child: Container(
                    height: 200,
                    width: double.infinity,
                    color: Colors.black.withOpacity(0.8),
                    padding: const EdgeInsets.all(20),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppTextNormal.labelBold(
                            "Data Demography",
                            26,
                            Colors.white,
                          ),
                          if (_c.selectedIndex.value != 99 &&
                              _c.demographys[_c.selectedIndex.value].image
                                  .isNotEmpty)
                            20.ph,
                          if (_c.selectedIndex.value != 99 &&
                              _c.demographys[_c.selectedIndex.value].image
                                  .isNotEmpty)
                            InkWell(
                              onTap: () => AppDialog.dialogImagePreview(
                                  _c.demographys[_c.selectedIndex.value].image),
                              child: SizedBox(
                                height: 200,
                                width: double.infinity,
                                child: CachedNetworkImage(
                                  imageUrl: _c
                                      .demographys[_c.selectedIndex.value]
                                      .image,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          20.ph,
                          if (_c.selectedIndex.value != 99)
                            AppTextNormal.labelW600(
                              _c.demographys[_c.selectedIndex.value].data,
                              18,
                              Colors.white,
                              maxLines: 100,
                              height: 1.6,
                              letterSpacing: 1.2,
                              textAlign: TextAlign.justify,
                            ),
                          20.ph,
                          ElevatedButton(
                            onPressed: () {
                              _c.toggleWidget(99);
                            },
                            child: const Text("Tutup"),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      );
    });
  }
}
