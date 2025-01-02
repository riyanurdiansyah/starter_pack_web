import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:starter_pack_web/module/challenge/controller/challenge_quiz_controller.dart';
import 'package:starter_pack_web/utils/app_color.dart';
import 'package:starter_pack_web/utils/app_dialog.dart';
import 'package:starter_pack_web/utils/app_extension.dart';
import 'package:starter_pack_web/utils/app_text.dart';

import '../../../utils/app_images.dart';
import '../../../utils/app_validator.dart';

class ChallengeQuizPage extends StatelessWidget {
  ChallengeQuizPage({super.key});

  final _c = Get.find<ChallengeQuizController>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;
    final isMiniMobile = size.width < 400 && size.height < 800;
    return Scaffold(
      backgroundColor: colorPointRank,
      body: Obx(
        () {
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
          if (_c.isComingSoon.value) {
            int days = _c.remainingTime.value.inDays; // Hitung jumlah hari
            int hours =
                _c.remainingTime.value.inHours % 24; // Sisa jam setelah hari
            int minutes = _c.remainingTime.value.inMinutes % 60; // Sisa menit
            int seconds = _c.remainingTime.value.inSeconds % 60; // Sisa detik
            return Center(
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 18),
                color: Colors.amber,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppTextNormal.labelBold(
                      "COMING SOON",
                      50,
                      Colors.black,
                      letterSpacing: 18,
                    ),
                    14.ph,
                    AppTextNormal.labelW600(
                      "The challenge will start in...",
                      36,
                      Colors.black,
                      letterSpacing: 8,
                    ),
                    50.ph,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (!isMobile)
                          const Expanded(
                            flex: 4,
                            child: SizedBox(),
                          ),
                        Expanded(
                          child: Column(
                            children: [
                              Container(
                                alignment: Alignment.center,
                                width: 80,
                                height: 90,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  color: Colors.white,
                                  border: Border.all(
                                    width: 0.6,
                                    color: Colors.black54,
                                  ),
                                ),
                                child: AppTextNormal.labelBold(
                                  days.toString().padLeft(2, '0'),
                                  25,
                                  Colors.grey.shade600,
                                  letterSpacing: 4,
                                ),
                              ),
                              25.ph,
                              AppTextNormal.labelBold(
                                "Days",
                                14,
                                Colors.grey.shade800,
                                letterSpacing: 2,
                              ),
                            ],
                          ),
                        ),
                        16.pw,
                        Expanded(
                          child: Column(
                            children: [
                              Container(
                                alignment: Alignment.center,
                                width: 80,
                                height: 90,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  color: Colors.white,
                                  border: Border.all(
                                    width: 0.6,
                                    color: Colors.black54,
                                  ),
                                ),
                                child: AppTextNormal.labelBold(
                                  hours.toString().padLeft(2, '0'),
                                  25,
                                  Colors.grey.shade600,
                                  letterSpacing: 4,
                                ),
                              ),
                              25.ph,
                              AppTextNormal.labelBold(
                                "Hours",
                                14,
                                Colors.grey.shade800,
                                letterSpacing: 2,
                              ),
                            ],
                          ),
                        ),
                        16.pw,
                        Expanded(
                          child: Column(
                            children: [
                              Container(
                                alignment: Alignment.center,
                                width: 80,
                                height: 90,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  color: Colors.white,
                                  border: Border.all(
                                    width: 0.6,
                                    color: Colors.black54,
                                  ),
                                ),
                                child: AppTextNormal.labelBold(
                                  minutes.toString().padLeft(2, '0'),
                                  25,
                                  Colors.grey.shade600,
                                  letterSpacing: 4,
                                ),
                              ),
                              25.ph,
                              AppTextNormal.labelBold(
                                "Minutes",
                                14,
                                Colors.grey.shade800,
                                letterSpacing: 2,
                              ),
                            ],
                          ),
                        ),
                        16.pw,
                        Expanded(
                          child: Column(
                            children: [
                              Container(
                                alignment: Alignment.center,
                                width: 80,
                                height: 90,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  color: Colors.white,
                                  border: Border.all(
                                    width: 0.6,
                                    color: Colors.black54,
                                  ),
                                ),
                                child: AppTextNormal.labelBold(
                                  seconds.toString().padLeft(2, '0'),
                                  25,
                                  Colors.grey.shade600,
                                  letterSpacing: 4,
                                ),
                              ),
                              25.ph,
                              AppTextNormal.labelBold(
                                "Seconds",
                                14,
                                Colors.grey.shade800,
                                letterSpacing: 2,
                              ),
                            ],
                          ),
                        ),
                        if (!isMobile)
                          const Expanded(
                            flex: 4,
                            child: SizedBox(),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }

          if (DateTime.now().isAfter(DateTime.parse(_c.challenge.value.end))) {
            return Container(
              width: double.infinity,
              color: Colors.red,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppTextNormal.labelBold(
                    "The time to complete the challenge has run out",
                    20,
                    Colors.white,
                    textAlign: TextAlign.center,
                  ),
                  45.ph,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OutlinedButton(
                        onPressed: () => context.pop(),
                        style: ButtonStyle(
                          side: WidgetStateProperty.all(
                            BorderSide(
                              color: Colors.grey.shade200,
                            ), // Ganti warna dan lebar sesuai kebutuhan
                          ),
                          shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  16), // Custom border radius
                            ),
                          ),
                        ),
                        child: AppTextNormal.labelBold(
                          "Back",
                          14,
                          Colors.grey.shade200,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }
          if (!_c.isStarting.value && !_c.isHaveSession.value) {
            return SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppTextNormal.labelBold(
                    "Welcome to the ${_c.challenge.value.name}",
                    isMobile ? 18 : 25,
                    Colors.white,
                    letterSpacing: 8,
                    maxLines: 10,
                    height: 1.5,
                    textAlign: TextAlign.center,
                  ),
                  45.ph,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OutlinedButton(
                        onPressed: () => context.pop(),
                        style: ButtonStyle(
                          side: WidgetStateProperty.all(
                            BorderSide(
                              color: Colors.grey.shade200,
                            ), // Ganti warna dan lebar sesuai kebutuhan
                          ),
                          shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  16), // Custom border radius
                            ),
                          ),
                        ),
                        child: AppTextNormal.labelBold(
                          "Back",
                          14,
                          Colors.grey.shade200,
                        ),
                      ),
                      18.pw,
                      ElevatedButton(
                        onPressed: () async {
                          _c.startTimer();
                          await _c.saveSessionQuiz(false);
                          await _c.getSessionQuiz();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorGold,
                        ),
                        child: AppTextNormal.labelBold(
                          "START",
                          14,
                          Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }

          if (_c.isFinished.value &&
              (_c.challenge.value.type == "MULTIPLE CHOICE" ||
                  _c.challenge.value.type == "TRUE/FALSE")) {
            return Stack(
              children: [
                SizedBox(
                  width: size.width,
                  height: size.height,
                  child: Image.asset(
                    quizPlayImage,
                    fit: BoxFit.fill,
                  ),
                ),
                Align(
                  // top: 20,
                  // left: 20,
                  alignment: Alignment.topLeft,
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    onEnter: (_) {
                      // AppSound.playHover();
                      // _c.isHovered.value = true;
                    },
                    onExit: (_) {
                      // _c.isHovered.value = false;
                    },
                    child: InkWell(
                      onTap: () => context.pop(),
                      child: Container(
                        margin: EdgeInsets.only(
                            top: isMiniMobile
                                ? 25
                                : isMobile
                                    ? 80
                                    : 30,
                            left: 20),
                        alignment: Alignment.center,
                        height: 45,
                        width: 100,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 25.0),
                          child: AppTextNormal.labelBold(
                            "BACK",
                            26,
                            Colors.grey,
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
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  height: size.height,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: colorElectricViolet.withOpacity(0.6),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.8),
                          ),
                          child: Image.asset(
                            helmetImg,
                            width: 250,
                          ),
                        ),
                      ),
                      35.ph,
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(35),
                          color: colorElectricViolet.withOpacity(0.6),
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 22, horizontal: 30),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(35),
                            color: Colors.grey.withOpacity(0.8),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AppTextNormal.labelBold(
                                "Congratulation! You've Reach the Finished Line ${_c.point.value}",
                                20,
                                Colors.white,
                              ),
                              10.ph,
                              AppTextNormal.labelBold(
                                "You Scored",
                                14,
                                Colors.white,
                              ),
                              8.ph,
                              AppTextNormal.labelBold(
                                "${_c.point.value}",
                                20,
                                Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
          if (_c.isFinished.value &&
              (_c.challenge.value.type == "WELLNESS" ||
                  _c.challenge.value.type == "WELLNESS GROUP")) {
            return Center(
              child: AppTextNormal.labelBold(
                "Quiz is Finished",
                20,
                Colors.white,
              ),
            );
          }

          if (_c.challenge.value.type == "MULTIPLE CHOICE" ||
              _c.challenge.value.type == "TRUE/FALSE") {
            return Stack(
              children: [
                SizedBox(
                  width: size.width,
                  height: size.height,
                  child: Image.asset(
                    quizPlayImage,
                    fit: BoxFit.fill,
                  ),
                ),
                Align(
                  // top: 20,
                  // left: 20,
                  alignment: Alignment.topLeft,
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    onEnter: (_) {
                      // AppSound.playHover();
                      // _c.isHovered.value = true;
                    },
                    onExit: (_) {
                      // _c.isHovered.value = false;
                    },
                    child: InkWell(
                      onTap: () => context.pop(),
                      child: Container(
                        margin: EdgeInsets.only(
                            top: isMiniMobile
                                ? 25
                                : isMobile
                                    ? 80
                                    : 30,
                            left: 20),
                        alignment: Alignment.center,
                        height: 45,
                        width: 100,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 25.0),
                          child: AppTextNormal.labelBold(
                            "BACK",
                            26,
                            Colors.grey,
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
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      isMiniMobile
                          ? 18.ph
                          : isMobile
                              ? 75.ph
                              : 25.ph,
                      Container(
                        alignment: Alignment.center,
                        width: isMobile ? 55 : 70,
                        height: isMobile ? 55 : 70,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: AppTextNormal.labelNormal(
                          "${_c.indexNow.value + 1} / ${_c.multipleChoices.length}",
                          18,
                          Colors.black,
                        ),
                      ),
                      if (_c.isQuestFinished.value)
                        Container(
                          alignment: Alignment.bottomLeft,
                          width: isMobile || isMiniMobile
                              ? size.width
                              : size.width / 2.6,
                          height: size.height / 1.2,
                          child: Stack(
                            children: [
                              Positioned(
                                bottom: 0, // Letakkan di bagian bawah
                                left:
                                    0, // Opsional jika ingin gambar sejajar dengan sisi kiri
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  width: 250,
                                  height: 500,
                                  child: Image.asset(
                                    andyImg,
                                    width: 300,
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0, // Letakkan di bagian bawah
                                left:
                                    0, // Opsional jika ingin gambar sejajar dengan sisi kiri
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 18),
                                  alignment: Alignment.centerLeft,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  width: isMobile || isMiniMobile
                                      ? size.width
                                      : size.width / 2.6,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      AppTextNormal.labelBold(
                                        "Great job completing all the questions! Are you ready to submit your answers?",
                                        12,
                                        Colors.black,
                                        maxLines: 10,
                                        letterSpacing: 2.5,
                                        height: 1.8,
                                      ),
                                      10.ph,
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          const Spacer(),
                                          SizedBox(
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Colors.grey.shade400,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  )),
                                              onPressed: () {
                                                _c.isQuestFinished.value =
                                                    false;
                                                // context.pop();
                                              },
                                              child: AppTextNormal.labelBold(
                                                "CANCEL",
                                                14,
                                                Colors.white,
                                                letterSpacing: 1.6,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          SizedBox(
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    colorPrimaryDark,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                              ),
                                              onPressed: () async {
                                                _c.submitChallengeOK();
                                              },
                                              child: AppTextNormal.labelBold(
                                                "SUBMIT",
                                                14,
                                                Colors.white,
                                                letterSpacing: 1.6,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (!_c.isQuestFinished.value)
                        SizedBox(
                          width: size.width,
                          child: Column(
                            children: [
                              isMobile ? 50.ph : 35.ph,
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 18),
                                width: isMobile ? size.width : size.width / 1.6,
                                child: AppTextNormal.labelBold(
                                  _c.multipleChoices[_c.indexNow.value]
                                      .question,
                                  14,
                                  Colors.white,
                                  letterSpacing: 2.5,
                                  textAlign: TextAlign.center,
                                  height: 1.6,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              30.ph,
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                width: isMobile ? size.width : size.width / 2.2,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    AppTextNormal.labelBold(
                                      "Max Point : ${convertNumber(_c.challenge.value.maxPoint)}",
                                      12.5,
                                      Colors.white,
                                    ),
                                    AppTextNormal.labelBold(
                                      "Time : ${_c.formatTime()}",
                                      12.5,
                                      Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                              18.ph,
                              Container(
                                height: 4,
                                width: double.infinity,
                                color: Colors.white.withOpacity(0.4),
                              ),
                              isMobile ? 20.ph : 10.ph,
                              SizedBox(
                                width: double.infinity,
                                child: Row(
                                  children: [
                                    if (!isMobile)
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                          height: 150,
                                        ),
                                      ),
                                    if (!isMobile)
                                      Expanded(
                                        child: IconButton(
                                          iconSize: 18,
                                          icon: const Icon(
                                            Icons.arrow_back_ios,
                                            color: Colors.white,
                                          ),
                                          onPressed: _c.indexNow.value == 0
                                              ? null
                                              : () {
                                                  _c.indexNow.value--;
                                                },
                                        ),
                                      ),
                                    Expanded(
                                      flex: 4,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: List.generate(
                                            _c
                                                .multipleChoices[
                                                    _c.indexNow.value]
                                                .options
                                                .length, (index) {
                                          return MouseRegion(
                                            onEnter: (_) {
                                              _c.indexOptionHover.value = index;
                                            },
                                            onExit: (_) {
                                              _c.indexOptionHover.value = 99;
                                            },
                                            child: InkWell(
                                              onTap: _c
                                                          .listAnswer[
                                                              _c.indexNow.value]
                                                          .indexAnswer ==
                                                      index
                                                  ? null
                                                  : () {
                                                      _c.onSelectOption(index);
                                                    },
                                              child: Container(
                                                width: double.infinity,
                                                margin: EdgeInsets.all(
                                                    isMobile ? 8 : 8),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal:
                                                        isMobile ? 8 : 10,
                                                    vertical:
                                                        isMobile ? 10 : 10),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  color: _c
                                                              .listAnswer[_c
                                                                  .indexNow
                                                                  .value]
                                                              .indexAnswer ==
                                                          index
                                                      ? colorGold
                                                      : _c.indexOptionHover
                                                                  .value ==
                                                              index
                                                          ? Colors.grey.shade300
                                                          : Colors.white,
                                                ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Container(
                                                      alignment:
                                                          Alignment.center,
                                                      width: 30,
                                                      height: 30,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: colorPointRank
                                                            .withOpacity(0.4),
                                                      ),
                                                      child: AppTextNormal
                                                          .labelBold(
                                                        String.fromCharCode(
                                                            65 + index),
                                                        16,
                                                        Colors.black,
                                                      ),
                                                    ),
                                                    14.pw,
                                                    Expanded(
                                                      child: AppTextNormal
                                                          .labelBold(
                                                        _c
                                                            .multipleChoices[_c
                                                                .indexNow.value]
                                                            .options[index]
                                                            .answer,
                                                        16,
                                                        Colors.black,
                                                        maxLines: 3,
                                                        height: 1.25,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        }),
                                      ),
                                    ),
                                    if (!isMobile)
                                      Expanded(
                                        child: IconButton(
                                          iconSize: 18,
                                          icon: const Icon(
                                            Icons.arrow_forward_ios,
                                            color: Colors.white,
                                          ),
                                          onPressed: (_c.indexNow.value + 1) ==
                                                  _c.multipleChoices.length
                                              ? null
                                              : () {
                                                  _c.indexNow.value++;
                                                },
                                        ),
                                      ),
                                    if (!isMobile)
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                          height: 150,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              16.ph,
                              SizedBox(
                                width: isMobile
                                    ? double.infinity
                                    : size.width / 2.35,
                                child: Row(
                                  children: [
                                    14.pw,
                                    if (isMobile)
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          color: Colors.grey.shade100,
                                        ),
                                        child: IconButton(
                                          iconSize: 18,
                                          icon: const Icon(
                                            Icons.arrow_back_ios,
                                            color: Colors.black,
                                          ),
                                          onPressed: _c.indexNow.value == 0
                                              ? null
                                              : () {
                                                  _c.indexNow.value--;
                                                },
                                        ),
                                      ),
                                    10.pw,
                                    Expanded(
                                      child: Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: isMobile ? 0 : 14),
                                        height: 45,
                                        child: ElevatedButton(
                                          onPressed: _c.submitChallenge,
                                          style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            backgroundColor: colorPointRank,
                                          ),
                                          child: AppTextNormal.labelBold(
                                            "SUBMIT",
                                            16,
                                            Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    10.pw,
                                    if (isMobile)
                                      Container(
                                        margin: const EdgeInsets.only(right: 8),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          color: Colors.grey.shade100,
                                        ),
                                        child: IconButton(
                                          iconSize: 18,
                                          icon: const Icon(
                                            Icons.arrow_forward_ios,
                                            color: Colors.black,
                                          ),
                                          onPressed: (_c.indexNow.value + 1) ==
                                                  _c.multipleChoices.length
                                              ? null
                                              : () {
                                                  _c.indexNow.value++;
                                                },
                                        ),
                                      ),
                                    14.pw,
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                // if (!_c.isQuestFinished.value)
                //   Positioned(
                //     left: 0,
                //     right: 0,
                //     top: isMobile ? 75 : 50,
                //     child:
                //   ),
                // if (!_c.isQuestFinished.value)
                //   Positioned(
                //     left: 400,
                //     bottom: _c.challenge.value.type == "TRUE/FALSE" ? 350 : 300,
                //     child: IconButton(
                //       onPressed: _c.indexNow.value == 0
                //           ? null
                //           : () {
                //               _c.indexNow.value--;
                //             },
                //       icon: const Icon(
                //         Icons.arrow_back_ios_rounded,
                //         size: 40,
                //         color: Colors.white,
                //       ),
                //     ),
                //   ),
                // if (!_c.isQuestFinished.value)
                //   Positioned(
                //     right: 400,
                //     bottom: _c.challenge.value.type == "TRUE/FALSE" ? 350 : 300,
                //     child: IconButton(
                //       onPressed:
                //           (_c.indexNow.value + 1) == _c.multipleChoices.length
                //               ? null
                //               : () {
                //                   _c.indexNow.value++;
                //                 },
                //       icon: const Icon(
                //         Icons.arrow_forward_ios_rounded,
                //         size: 40,
                //         color: Colors.white,
                //       ),
                //     ),
                //   ),
              ],
            );
          }

          return Stack(
            children: [
              SizedBox(
                width: size.width,
                height: size.height,
                child: Image.asset(
                  quizPlayImage,
                  fit: BoxFit.fill,
                ),
              ),
              if (!_c.isQuestFinished.value)
                Positioned(
                  left: 0,
                  right: 0,
                  top: 50,
                  child: Container(
                    alignment: Alignment.center,
                    width: 55,
                    height: 55,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: AppTextNormal.labelNormal(
                      "${_c.indexNow.value + 1} / 1",
                      14,
                      Colors.black,
                    ),
                  ),
                ),
              if (!_c.isQuestFinished.value)
                SizedBox(
                  width: size.width,
                  child: Column(
                    children: [
                      125.ph,
                      SizedBox(
                        width: size.width / 2.2,
                        child: AppTextNormal.labelBold(
                          "",
                          25,
                          Colors.white,
                          letterSpacing: 2.5,
                          textAlign: TextAlign.center,
                          height: 1.6,
                          maxLines: 10,
                        ),
                      ),
                      SizedBox(
                        width: isMobile ? double.infinity : size.width / 2.4,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AppTextNormal.labelBold(
                              "Max Point : ${convertNumber(_c.challenge.value.maxPoint)}",
                              12.5,
                              Colors.white,
                            ),
                            AppTextNormal.labelBold(
                              "Time : ${_c.formatTime()}",
                              12.5,
                              Colors.white,
                            ),
                          ],
                        ),
                      ),
                      10.ph,
                      Container(
                        height: 4,
                        width: double.infinity,
                        color: Colors.white.withOpacity(0.4),
                      ),
                      14.ph,
                      Center(
                        child: Container(
                          height: 150,
                          width: size.width / 2.4,
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.2),
                            border: Border.all(
                              width: 1.5,
                              color: Colors.white.withOpacity(0.6),
                            ),
                          ),
                          child: Stack(
                            children: [
                              if (_c.fileName.value.isNotEmpty)
                                Container(
                                  height: 180,
                                  width: size.width / 2.4,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Image.memory(
                                    _c.filePickerResult!.files.first.bytes!,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              Builder(
                                builder: (context) {
                                  return DropzoneView(
                                    onCreated: (controller) =>
                                        _c.dropzoneController = controller,
                                    onDropFile: (file) async {
                                      if (file.type.contains("image")) {
                                        _c.fileName.value = file.name;
                                        final byteData = await _c
                                            .dropzoneController
                                            .getFileData(file);
                                        final files = [
                                          PlatformFile(
                                            name: file.name,
                                            size: byteData.lengthInBytes,
                                            bytes: byteData,
                                          ),
                                        ];

                                        _c.filePickerResult =
                                            FilePickerResult(files);
                                      } else {
                                        AppDialog.dialogSnackbar(
                                            "Only image files are allowed!");
                                      }
                                    },
                                    onError: (e) => debugPrint('Error: $e'),
                                  );
                                },
                              ),
                              Center(
                                child: InkWell(
                                  onTap: _c.pickImage,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          // Ikon dengan warna outline (lebih besar)
                                          Icon(
                                            Icons.cloud_upload,
                                            size:
                                                54, // Lebih besar untuk efek outline
                                            color:
                                                Colors.black, // Warna outline
                                          ),
                                          // Ikon utama
                                          Icon(
                                            Icons.cloud_upload,
                                            size: 50, // Ukuran asli
                                            color:
                                                Colors.grey, // Warna ikon utama
                                          ),
                                        ],
                                      ),
                                      14.ph,
                                      AppTextNormal.labelBold(
                                        "Drag & Drop or Click to Upload",
                                        14,
                                        Colors.white,
                                        letterSpacing: 2.5,
                                        shadows: const [
                                          Shadow(
                                            offset: Offset(-1.5,
                                                -1.5), // Bayangan ke kiri atas
                                            color: Colors.black,
                                            blurRadius: 1.0,
                                          ),
                                          Shadow(
                                            offset: Offset(1.5,
                                                -1.5), // Bayangan ke kanan atas
                                            color: Colors.black,
                                            blurRadius: 1.0,
                                          ),
                                          Shadow(
                                            offset: Offset(1.5,
                                                1.5), // Bayangan ke kanan bawah
                                            color: Colors.black,
                                            blurRadius: 1.0,
                                          ),
                                          Shadow(
                                            offset: Offset(-1.5,
                                                1.5), // Bayangan ke kiri bawah
                                            color: Colors.black,
                                            blurRadius: 1.0,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      18.ph,
                      SizedBox(
                        width: size.width / 2.4,
                        child: TextFormField(
                          controller: _c.tcRemark,
                          validator: (val) => AppValidator.requiredField(val!),
                          style: GoogleFonts.poppins(
                            height: 1.4,
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                            hintStyle: GoogleFonts.poppins(
                              fontSize: 14,
                              wordSpacing: 4,
                              color: Colors.white30,
                            ),
                            hintText: "Insert your remark",
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 0, horizontal: 8),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade500),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey.shade500),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      16.ph,
                      SizedBox(
                        width: size.width / 2.4,
                        height: 45,
                        child: ElevatedButton(
                          onPressed: _c.fileName.value.isEmpty
                              ? () {}
                              : _c.saveChallengeWellfit,
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            backgroundColor: _c.fileName.value.isEmpty
                                ? Colors.grey
                                : colorPointRank,
                          ),
                          child: AppTextNormal.labelBold(
                            "SUBMIT",
                            14,
                            Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
