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
          if (DateTime.now()
              .isBefore(DateTime.parse(_c.challenge.value.start))) {
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
                          color: Colors.white.withOpacity(0.8),
                        ),
                        child: Image.asset(
                          helmetImg,
                          width: 150,
                        ),
                      ),
                      35.ph,
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(35),
                          color: Colors.white.withOpacity(0.8),
                        ),
                        child: AppTextNormal.labelBold(
                          "Congratulations : ${_c.point.value}",
                          20,
                          Colors.grey.shade600,
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
                if (!_c.isQuestFinished.value)
                  Positioned(
                    left: 0,
                    right: 0,
                    top: isMobile ? 75 : 50,
                    child: Container(
                      alignment: Alignment.center,
                      width: isMobile ? 75 : 90,
                      height: isMobile ? 75 : 90,
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
                  ),
                if (!_c.isQuestFinished.value)
                  Positioned(
                    left: 400,
                    bottom: _c.challenge.value.type == "TRUE/FALSE" ? 350 : 300,
                    child: IconButton(
                      onPressed: _c.indexNow.value == 0
                          ? null
                          : () {
                              _c.indexNow.value--;
                            },
                      icon: const Icon(
                        Icons.arrow_back_ios_rounded,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                  ),
                if (!_c.isQuestFinished.value)
                  Positioned(
                    right: 400,
                    bottom: _c.challenge.value.type == "TRUE/FALSE" ? 350 : 300,
                    child: IconButton(
                      onPressed:
                          (_c.indexNow.value + 1) == _c.multipleChoices.length
                              ? null
                              : () {
                                  _c.indexNow.value++;
                                },
                      icon: const Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                  ),
                if (!_c.isQuestFinished.value)
                  SizedBox(
                    width: size.width,
                    child: Column(
                      children: [
                        185.ph,
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          width: isMobile ? size.width : size.width / 2.2,
                          height: 150,
                          child: AppTextNormal.labelBold(
                            _c.multipleChoices[_c.indexNow.value].question,
                            isMobile ? 18 : 25,
                            Colors.white,
                            letterSpacing: 2.5,
                            textAlign: TextAlign.center,
                            height: 1.6,
                            maxLines: 10,
                          ),
                        ),
                        18.ph,
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          width: isMobile ? size.width : size.width / 2.2,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AppTextNormal.labelBold(
                                "Max Point : ${convertNumber(_c.challenge.value.maxPoint)}",
                                16,
                                Colors.white,
                              ),
                              AppTextNormal.labelBold(
                                "Time : ${_c.formatTime()}",
                                16,
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
                        20.ph,
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
                                  child: Container(
                                    height: 150,
                                  ),
                                ),
                              Expanded(
                                flex: 4,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(
                                      _c.multipleChoices[_c.indexNow.value]
                                          .options.length, (index) {
                                    return MouseRegion(
                                      onEnter: (_) {
                                        _c.indexOptionHover.value = index;
                                      },
                                      onExit: (_) {
                                        _c.indexOptionHover.value = 99;
                                      },
                                      child: InkWell(
                                        onTap: _c.listAnswer[_c.indexNow.value]
                                                    .indexAnswer ==
                                                index
                                            ? null
                                            : () {
                                                _c.onSelectOption(index);
                                              },
                                        child: Container(
                                          width: double.infinity,
                                          margin:
                                              EdgeInsets.all(isMobile ? 8 : 12),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: isMobile ? 8 : 18,
                                              vertical: isMobile ? 10 : 18),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            color:
                                                _c.listAnswer[_c.indexNow.value]
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
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                alignment: Alignment.center,
                                                width: 30,
                                                height: 30,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: colorPointRank
                                                      .withOpacity(0.4),
                                                ),
                                                child: AppTextNormal.labelBold(
                                                  String.fromCharCode(
                                                      65 + index),
                                                  16,
                                                  Colors.black,
                                                ),
                                              ),
                                              14.pw,
                                              AppTextNormal.labelBold(
                                                _c
                                                    .multipleChoices[
                                                        _c.indexNow.value]
                                                    .options[index]
                                                    .answer,
                                                16,
                                                Colors.black,
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
                                  child: Container(
                                    height: 150,
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
                          width: isMobile ? double.infinity : size.width / 2.4,
                          child: Row(
                            children: [
                              14.pw,
                              if (isMobile)
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
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
                                        borderRadius: BorderRadius.circular(4),
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
                                    borderRadius: BorderRadius.circular(6),
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
                    width: 90,
                    height: 90,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: AppTextNormal.labelNormal(
                      "${_c.indexNow.value + 1} / 1",
                      18,
                      Colors.black,
                    ),
                  ),
                ),
              if (!_c.isQuestFinished.value)
                Container(
                  color: Colors.red,
                  width: size.width,
                  child: Column(
                    children: [
                      225.ph,
                      SizedBox(
                        width: size.width / 2.2,
                        height: 150,
                        child: AppTextNormal.labelBold(
                          "....",
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
                              16,
                              Colors.white,
                            ),
                            AppTextNormal.labelBold(
                              "Time : ${_c.formatTime()}",
                              16,
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
                      20.ph,
                      Center(
                        child: Container(
                          height: 225,
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
                                  height: 225,
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
                                vertical: 0, horizontal: 12),
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
                        height: 50,
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
                            16,
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
