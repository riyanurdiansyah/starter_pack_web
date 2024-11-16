import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:starter_pack_web/module/demography/controller/demography_controller.dart';
import 'package:starter_pack_web/utils/app_images.dart';

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
                      onTap: _c.toggleWidget3,
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
            // Positioned(
            //   right: size.width / 2.9,
            //   top: 240,
            //   child: MouseRegion(
            //     cursor: SystemMouseCursors.click,
            //     onEnter: (_) => setState(() => _c.isHovered.value = true),
            //     onExit: (_) => setState(() => _c.isHovered.value = false),
            //     child: InkWell(
            //       onTap: _c.toggleWidget2,
            //       child: Container(
            //         color: Colors.transparent,
            //         alignment: Alignment.center,
            //         width: 125,
            //         height: 125,
            //         child: Stack(
            //           alignment: Alignment.center,
            //           children: [
            //             Stack(
            //               children: [
            //                 Center(
            //                   child: ScaleTransition(
            //                     scale: _c.animation,
            //                     child: const Icon(
            //                       Icons.location_on,
            //                       color: Colors.white,
            //                       size: 70,
            //                     ),
            //                   ),
            //                 ),
            //                 Center(
            //                   child: ScaleTransition(
            //                     scale: _c.animation,
            //                     child: const Icon(
            //                       Icons.location_on,
            //                       color: Colors.red,
            //                       size: 60,
            //                     ),
            //                   ),
            //                 ),
            //               ],
            //             ),
            //             Positioned(
            //               top: 0,
            //               bottom: 0,
            //               right: 0,
            //               left: 0,
            //               child: AnimatedOpacity(
            //                 duration: const Duration(milliseconds: 300),
            //                 opacity: _c.isHovered.value ? 1.0 : 0.0,
            //                 child: const AnimatedDefaultTextStyle(
            //                   duration: Duration(milliseconds: 300),
            //                   textAlign: TextAlign.center,
            //                   style: TextStyle(
            //                     fontFamily: 'Race',
            //                     fontSize: 16,
            //                     height: 2.5,
            //                     letterSpacing: 5,
            //                     color: Colors.white, // Warna utama teks
            //                     fontStyle: FontStyle.italic,
            //                     shadows: [
            //                       Shadow(
            //                         // Shadow pertama untuk outline
            //                         offset: Offset(1.5, 1.5),
            //                         blurRadius: 2.0,
            //                         color: Colors.red, // Warna pinggiran merah
            //                       ),
            //                       Shadow(
            //                         // Shadow kedua untuk outline lebih tebal
            //                         offset: Offset(-1.5, -1.5),
            //                         blurRadius: 2.0,
            //                         color: Colors.red, // Warna pinggiran merah
            //                       ),
            //                     ],
            //                   ),
            //                   child: Text("AREA 2"),
            //                 ),
            //               ),
            //             ),
            //           ],
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            // Positioned(
            //   right: size.width / 1.4,
            //   top: 210,
            //   child: InkWell(
            //     onTap: _c.toggleWidget,
            //     child: MouseRegion(
            //       cursor: SystemMouseCursors.click,
            //       onEnter: (_) => setState(() => _c.isHovered2.value = true),
            //       onExit: (_) => setState(() => _c.isHovered2.value = false),
            //       child: Container(
            //         color: Colors.transparent,
            //         alignment: Alignment.center,
            //         width: 125,
            //         height: 125,
            //         child: Stack(
            //           alignment: Alignment.center,
            //           children: [
            //             Stack(
            //               children: [
            //                 Center(
            //                   child: ScaleTransition(
            //                     scale: _c.animation,
            //                     child: const Icon(
            //                       Icons.location_on_sharp,
            //                       color: Colors.white,
            //                       size: 70,
            //                     ),
            //                   ),
            //                 ),
            //                 Center(
            //                   child: ScaleTransition(
            //                     scale: _c.animation,
            //                     child: const Icon(
            //                       Icons.location_on,
            //                       color: Colors.red,
            //                       size: 60,
            //                     ),
            //                   ),
            //                 ),
            //               ],
            //             ),
            //             Positioned(
            //               top: 0,
            //               bottom: 0,
            //               right: 0,
            //               left: 0,
            //               child: AnimatedOpacity(
            //                 duration: const Duration(milliseconds: 300),
            //                 opacity: _c.isHovered2.value ? 1.0 : 0.0,
            //                 child: const AnimatedDefaultTextStyle(
            //                   duration: Duration(milliseconds: 300),
            //                   textAlign: TextAlign.center,
            //                   style: TextStyle(
            //                     fontFamily: 'Race',
            //                     fontSize: 16,
            //                     height: 2.5,
            //                     letterSpacing: 5,
            //                     color: Colors.white, // Warna utama teks
            //                     fontStyle: FontStyle.italic,
            //                     shadows: [
            //                       Shadow(
            //                         // Shadow pertama untuk outline
            //                         offset: Offset(1.5, 1.5),
            //                         blurRadius: 2.0,
            //                         color: Colors.red, // Warna pinggiran merah
            //                       ),
            //                       Shadow(
            //                         // Shadow kedua untuk outline lebih tebal
            //                         offset: Offset(-1.5, -1.5),
            //                         blurRadius: 2.0,
            //                         color: Colors.red, // Warna pinggiran merah
            //                       ),
            //                     ],
            //                   ),
            //                   child: Text("AREA 1"),
            //                 ),
            //               ),
            //             ),
            //           ],
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            AnimatedPositioned(
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
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Informasi Lokasi",
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Detail lokasi dan informasi lainnya ditampilkan di sini.",
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _c.toggleWidget();

                        // context.goNamed(AppRouteName.pro,
                        //     queryParameters: {"name": "area-1"});
                      },
                      child: const Text("Tutup"),
                    ),
                  ],
                ),
              ),
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              top: 0,
              bottom: 0,
              right: _c.isWidgetVisible2.value
                  ? 0
                  : -size.width * 0.5, // Off-screen when hidden
              width: size.width * 0.35,
              child: Container(
                height: 200,
                width: double.infinity,
                color: Colors.black.withOpacity(0.4),
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Informasi Lokasi",
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Detail lokasi dan informasi lainnya ditampilkan di sini.",
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _c.toggleWidget2();

                        // context.goNamed(AppRouteName.cart, extra: {
                        //   "name": "Area 2",
                        // });
                      },
                      child: const Text("Tutup"),
                    ),
                  ],
                ),
              ),
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              top: 0,
              bottom: 0,
              right: _c.isWidgetVisible3.value
                  ? 0
                  : -size.width * 0.5, // Off-screen when hidden
              width: size.width * 0.35,
              child: Container(
                height: 200,
                width: double.infinity,
                color: Colors.black.withOpacity(0.4),
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Informasi Lokasi",
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Detail lokasi dan informasi lainnya ditampilkan di sini.",
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _c.toggleWidget3();

                        // context.goNamed(AppRouteName.cart, extra: {
                        //   "name": "Area 3",
                        // });
                      },
                      child: const Text("Tutup"),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
