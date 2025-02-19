import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:starter_pack_web/module/getting/controller/getting_controller.dart';
import 'package:starter_pack_web/utils/app_images.dart';
import 'package:starter_pack_web/utils/app_text.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:video_player/video_player.dart';

class GettingPage extends StatelessWidget {
  GettingPage({super.key});

  final _c = Get.find<GettingController>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isMobile = MediaQuery.sizeOf(context).width < 600;
    return Scaffold(
      body: Obx(() {
        if (_c.isDone.value) {
          return SizedBox(
            width: double.infinity,
            height: size.height,
            child: Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: size.height,
                  child: Image.asset(
                    graduateImg,
                    fit: BoxFit.fill,
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: size.height,
                  alignment: Alignment.center,
                  child: Stack(
                    children: [
                      Center(
                        child: FadeTransition(
                          opacity: _c.animation!,
                          child: AppTextNormal.labelBold(
                            "COMMITMENT 2025\nTARGET 8.9 T\nGROWTH 7.8%",
                            isMobile ? 24 : 55,
                            Colors.white,
                            maxLines: 3,
                            textAlign: TextAlign.center,
                            height: 1.25,
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
                        ),
                      ),
                      Center(
                        child: ConfettiWidget(
                          maxBlastForce: 100,
                          minBlastForce: 1,
                          particleDrag: 0.0000000000000000001,
                          confettiController: _c.confettiController,
                          blastDirectionality: BlastDirectionality.explosive,
                          shouldLoop: false,
                          numberOfParticles: 300,
                          minimumSize: const Size(10, 10),
                          maximumSize: const Size(10, 10),
                          gravity: 1,
                          colors: const [
                            Colors.red,
                            Colors.blue,
                            Colors.green,
                            Colors.yellow,
                            Colors.orange,
                            Colors.pink,
                            Colors.purple,
                            Colors.brown,
                            Colors.teal,
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        }
        if (_c.isShow.value) {
          return Container(
            color: Colors.black,
            width: double.infinity,
            height: size.height,
            child: AspectRatio(
              aspectRatio: 100,
              child: VideoPlayer(
                _c.videoPlayerController,
              ),
            ),
          );
        }
        if (_c.isStarted.value) {
          return SizedBox(
            width: double.infinity,
            height: size.height,
            child: Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: size.height,
                  child: Image.asset(
                    isMobile ? gettingImg : gettingLandImg,
                    fit: BoxFit.fill,
                  ),
                ),
                Positioned(
                  bottom: 125,
                  left: 0,
                  right: 0,
                  child: Column(
                    children: [
                      Obx(
                        () => SfRadialGauge(
                          axes: [
                            RadialAxis(
                              maximum: 450,
                              minimum: 0,
                              interval: 50,
                              labelsPosition: ElementsPosition.outside,
                              ranges: [
                                GaugeRange(
                                  startValue: 0,
                                  endValue: 150,
                                  color: Colors.blue,
                                ),
                                GaugeRange(
                                  startValue: 150,
                                  endValue: 350,
                                  color: Colors.red.shade300,
                                ),
                                GaugeRange(
                                  startValue: 350,
                                  endValue: 500,
                                  color: Colors.red.shade800,
                                ),
                              ],
                              pointers: [
                                NeedlePointer(
                                  value: _c.speed.value,
                                  needleEndWidth: 10,
                                  enableAnimation: true,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Obx(
                  () => Positioned(
                    bottom: 60,
                    left: 0,
                    right: 0,
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onLongPressStart: _c.isLongPressing.value
                            ? null
                            : (e) {
                                _c.fullGas();
                                _c.isLongPressing.value = true;
                                _c.startIncreasingValue();
                              },
                        onLongPressEnd: (e) {
                          // Future.delayed(const Duration(milliseconds: 350), () {
                          //   _c.audioPlayerGas.stop();
                          // });
                          // _c.isLongPressing.value = false;
                          // _c.startDecreasingValue();
                        },
                        onTap: () {
                          // _c.increaseValue();
                          // _c.gas();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(16),
                          margin: const EdgeInsets.symmetric(
                            horizontal: 35,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                              color: _c.isLongPressing.value
                                  ? Colors.grey
                                  : Colors.red.shade400,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                width: 2,
                                color: _c.isLongPressing.value
                                    ? Colors.grey
                                    : Colors.red,
                              )),
                          child: AppTextNormal.labelBold(
                            "Getting\nCommitment",
                            25,
                            Colors.white,
                            maxLines: 2,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    // child: MouseRegion(
                    //   cursor: SystemMouseCursors.click,
                    //   child: GestureDetector(
                    //     onLongPressStart: (e) {
                    //       _c.fullGas();
                    //       _c.isLongPressing.value = true;
                    //       _c.startIncreasingValue();
                    //     },
                    //     onLongPressEnd: (e) {
                    //       // Future.delayed(const Duration(milliseconds: 350), () {
                    //       //   _c.audioPlayerGas.stop();
                    //       // });
                    //       // _c.isLongPressing.value = false;
                    //       // _c.startDecreasingValue();
                    //     },
                    //     onTap: () {
                    //       // _c.increaseValue();
                    //       // _c.gas();
                    //     },
                    //     child: Container(
                    //       decoration: const BoxDecoration(
                    //           shape: BoxShape.circle, color: Colors.red),
                    //       child: Container(
                    //         margin: const EdgeInsets.all(14),
                    //         decoration: BoxDecoration(
                    //           border: Border.all(
                    //             width: 2.5,
                    //             color: Colors.white,
                    //           ),
                    //           shape: BoxShape.circle,
                    //           color: Colors.red,
                    //         ),
                    //         child:
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ),
                ),
              ],
            ),
          );
        }
        return SizedBox(
          width: double.infinity,
          height: size.height,
          child: InkWell(
            onTap: () {
              _c.engineStart();
            },
            child: Image.asset(
              engineImg,
            ),
          ),
        );
      }),
    );
  }
}
