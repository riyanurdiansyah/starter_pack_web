import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../../dashboard/controller/audio_controller.dart';

class GettingController extends GetxController
    with GetSingleTickerProviderStateMixin {
  AnimationController? animationController;
  Animation<double>? animation;
  final AudioPlayer audioPlayer = AudioPlayer();
  final AudioPlayer audioPlayerGas = AudioPlayer();
  final Rx<bool> isStarted = false.obs;
  final Rx<double> speed = 0.0.obs;
  final Rx<bool> isLongPressing = false.obs;
  final Rx<bool> isDecrese = false.obs;
  final Rx<bool> isShow = false.obs;
  final Rx<bool> isDone = false.obs;
  late VideoPlayerController videoPlayerController;
  late ConfettiController confettiController;

  late Timer _timer;

  @override
  void onInit() {
    animationController =
        AnimationController(duration: const Duration(seconds: 3), vsync: this)
          ..repeat(reverse: true);
    animation = CurvedAnimation(
        parent: animationController!, curve: Curves.fastOutSlowIn);
    videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(
        "https://firebasestorage.googleapis.com/v0/b/mfg-rakor.appspot.com/o/assets%2FGraduates!.mp4?alt=media"));
    confettiController =
        ConfettiController(duration: const Duration(milliseconds: 3));
    startTimer();
    super.onInit();
  }

  void startTimer() async {
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        startDecreasingValue();
      },
    );
  }

  void engineStart() async {
    if (Get.isRegistered<AudioController>()) {
      final audioC = Get.find<AudioController>();
      audioC.audioPlayer.stop();
    }
    isStarted.value = true;
    await audioPlayer.play(AssetSource("music/engine.mp3"));
  }

  void onTick(Duration elapsed) {
    if (speed.value < 500) {
      speed.value = (elapsed.inMilliseconds / 10).clamp(0.0, 500.0);
    }
  }

  void startIncreasingValue() {
    if (isLongPressing.value && speed.value < 500) {
      Future.delayed(const Duration(milliseconds: 50), () {
        speed.value = (speed.value + 6).clamp(0.0, 500.0);
        startIncreasingValue();
      });
    }
    if (speed.value == 500) {
      audioPlayerGas.stop();
      videoPlayerController.initialize();
      videoPlayerController.play();
      isShow.value = true;
      videoPlayerController.addListener(() {
        if (videoPlayerController.value.position ==
                videoPlayerController.value.duration &&
            !isDone.value &&
            videoPlayerController.value.duration.inSeconds.toInt() != 0) {
          isDone.value = true;
          confettiController.play();
        }
      });
    }
  }

  void startDecreasingValue() {
    if (!isLongPressing.value && speed.value > 0) {
      Future.delayed(const Duration(milliseconds: 50), () {
        speed.value =
            (speed.value - 2).clamp(0.0, 500.0); // Turunkan nilai sampai 0
        startDecreasingValue(); // Rekursif untuk terus menurunkan nilai
      });
    }
  }

  void increaseValue() {
    if (speed.value < 500) {
      speed.value = (speed.value + 12)
          .clamp(0.0, 500.0); // Tambah sedikit-sedikit setiap tap
    }
  }

  void gas() async {
    await audioPlayerGas.play(AssetSource("music/gas.wav"));
    Future.delayed(const Duration(milliseconds: 350), () {
      audioPlayerGas.stop();
    });
  }

  void fullGas() async {
    await audioPlayerGas.play(AssetSource("music/car_engine.mp3"));
  }
}
