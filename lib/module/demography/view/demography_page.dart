import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:starter_pack_web/utils/app_images.dart';

class DemographyPage extends StatefulWidget {
  const DemographyPage({super.key});

  @override
  State<DemographyPage> createState() => _DemographyPageState();
}

class _DemographyPageState extends State<DemographyPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isHovered = false;
  bool _isHovered2 = false;
  bool _isHovered3 = false;
  bool _isWidgetVisible = false;
  bool _isWidgetVisible2 = false;
  bool _isWidgetVisible3 = false;

  void _toggleWidget() {
    setState(() {
      _isWidgetVisible = !_isWidgetVisible;
    });
  }

  void _toggleWidget2() {
    setState(() {
      _isWidgetVisible2 = !_isWidgetVisible2;
      log(_isWidgetVisible2.toString());
    });
  }

  void _toggleWidget3() {
    setState(() {
      _isWidgetVisible3 = !_isWidgetVisible3;
      log(_isWidgetVisible3.toString());
    });
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: size.width,
            height: size.height,
            child: Image.asset(
              bgDemography,
              fit: BoxFit.fill,
            ),
          ),
          Positioned(
            left: size.width / 2.4,
            bottom: 250,
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              onEnter: (_) => setState(() => _isHovered3 = true),
              onExit: (_) => setState(() => _isHovered3 = false),
              child: InkWell(
                onTap: _toggleWidget3,
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
                              scale: _animation,
                              child: const Icon(
                                Icons.location_on,
                                color: Colors.white,
                                size: 70,
                              ),
                            ),
                          ),
                          Center(
                            child: ScaleTransition(
                              scale: _animation,
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
                          opacity: _isHovered3 ? 1.0 : 0.0,
                          child: const AnimatedDefaultTextStyle(
                            duration: Duration(milliseconds: 300),
                            textAlign: TextAlign.center,
                            style: TextStyle(
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
                                  color: Colors.red, // Warna pinggiran merah
                                ),
                                Shadow(
                                  // Shadow kedua untuk outline lebih tebal
                                  offset: Offset(-1.5, -1.5),
                                  blurRadius: 2.0,
                                  color: Colors.red, // Warna pinggiran merah
                                ),
                              ],
                            ),
                            child: Text("AREA 3"),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: size.width / 2.9,
            top: 240,
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              onEnter: (_) => setState(() => _isHovered = true),
              onExit: (_) => setState(() => _isHovered = false),
              child: InkWell(
                onTap: _toggleWidget2,
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
                              scale: _animation,
                              child: const Icon(
                                Icons.location_on,
                                color: Colors.white,
                                size: 70,
                              ),
                            ),
                          ),
                          Center(
                            child: ScaleTransition(
                              scale: _animation,
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
                          opacity: _isHovered ? 1.0 : 0.0,
                          child: const AnimatedDefaultTextStyle(
                            duration: Duration(milliseconds: 300),
                            textAlign: TextAlign.center,
                            style: TextStyle(
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
                                  color: Colors.red, // Warna pinggiran merah
                                ),
                                Shadow(
                                  // Shadow kedua untuk outline lebih tebal
                                  offset: Offset(-1.5, -1.5),
                                  blurRadius: 2.0,
                                  color: Colors.red, // Warna pinggiran merah
                                ),
                              ],
                            ),
                            child: Text("AREA 2"),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: size.width / 1.4,
            top: 210,
            child: InkWell(
              onTap: _toggleWidget,
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                onEnter: (_) => setState(() => _isHovered2 = true),
                onExit: (_) => setState(() => _isHovered2 = false),
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
                              scale: _animation,
                              child: const Icon(
                                Icons.location_on_sharp,
                                color: Colors.white,
                                size: 70,
                              ),
                            ),
                          ),
                          Center(
                            child: ScaleTransition(
                              scale: _animation,
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
                          opacity: _isHovered2 ? 1.0 : 0.0,
                          child: const AnimatedDefaultTextStyle(
                            duration: Duration(milliseconds: 300),
                            textAlign: TextAlign.center,
                            style: TextStyle(
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
                                  color: Colors.red, // Warna pinggiran merah
                                ),
                                Shadow(
                                  // Shadow kedua untuk outline lebih tebal
                                  offset: Offset(-1.5, -1.5),
                                  blurRadius: 2.0,
                                  color: Colors.red, // Warna pinggiran merah
                                ),
                              ],
                            ),
                            child: Text("AREA 1"),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            top: 0,
            bottom: 0,
            right: _isWidgetVisible
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
                      _toggleWidget();

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
            right: _isWidgetVisible2
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
                      _toggleWidget2();

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
            right: _isWidgetVisible3
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
                      _toggleWidget3();

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
    );
  }
}
