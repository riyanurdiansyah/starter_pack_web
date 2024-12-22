import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:starter_pack_web/middleware/app_route_name.dart';
import 'package:starter_pack_web/module/demography/controller/demography_controller.dart';
import 'package:starter_pack_web/utils/app_images.dart';
import 'package:starter_pack_web/utils/app_text.dart';

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
                    onEnter: (_) =>
                        _c.demographys[index] = _c.demographys[index].copyWith(
                      isHovered: true,
                    ),
                    onExit: (_) => setState(() =>
                        _c.demographys[index] = _c.demographys[index].copyWith(
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
                              bottom: 0,
                              right: 0,
                              left: 0,
                              child: AnimatedOpacity(
                                duration: const Duration(milliseconds: 300),
                                opacity:
                                    _c.demographys[index].isHovered ? 1.0 : 0.0,
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
                                        color:
                                            Colors.red, // Warna pinggiran merah
                                      ),
                                      Shadow(
                                        // Shadow kedua untuk outline lebih tebal
                                        offset: Offset(-1.5, -1.5),
                                        blurRadius: 2.0,
                                        color:
                                            Colors.red, // Warna pinggiran merah
                                      ),
                                    ],
                                  ),
                                  child: Text(_c.demographys[index].name),
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
            Obx(
              () => AnimatedPositioned(
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
                  color: Colors.black.withOpacity(0.4),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Data Demography",
                        style: TextStyle(color: Colors.white, fontSize: 24),
                      ),
                      const SizedBox(height: 20),
                      if (_c.selectedIndex.value != 99)
                        Text(
                          _c.demographys[_c.selectedIndex.value].data,
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 16),
                        ),
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
            ),
          ],
        ),
      ),
    );
  }
}
