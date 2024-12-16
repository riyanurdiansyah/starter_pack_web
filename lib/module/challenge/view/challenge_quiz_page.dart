import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:get/get.dart';
import 'package:starter_pack_web/module/challenge/controller/challenge_quiz_controller.dart';
import 'package:starter_pack_web/utils/app_color.dart';
import 'package:starter_pack_web/utils/app_extension.dart';
import 'package:starter_pack_web/utils/app_text.dart';

import '../../../utils/app_images.dart';

class ChallengeQuizPage extends StatelessWidget {
  ChallengeQuizPage({super.key});

  final _c = Get.find<ChallengeQuizController>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
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
          if (!_c.isStarting.value && !_c.isHaveSession.value) {
            return SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppTextNormal.labelBold(
                    "Welcome to the ${_c.challenge.value.name}",
                    25,
                    Colors.white,
                    letterSpacing: 8,
                  ),
                  25.ph,
                  ElevatedButton(
                    onPressed: _c.startTimer,
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
            );
          }

          if (_c.isFinished.value &&
              _c.challenge.value.type == "MULTIPLE CHOICE") {
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
                AppTextNormal.labelBold(
                  "Quiz is Finished : ${_c.point.value}",
                  20,
                  Colors.white,
                ),
              ],
            );
          }
          if (_c.challenge.value.type == "MULTIPLE CHOICE") {
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
                        "${_c.indexNow.value + 1} / ${_c.multipleChoices.length}",
                        18,
                        Colors.black,
                      ),
                    ),
                  ),
                if (!_c.isQuestFinished.value)
                  Positioned(
                    left: 400,
                    bottom: 300,
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
                    bottom: 300,
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
                        // SizedBox(
                        //   width: size.width / 2.4,
                        //   child: Row(
                        //     children: [
                        //       TextButton.icon(
                        //         onPressed: _c.indexNow.value == 0
                        //             ? null
                        //             : () {
                        //                 _c.indexNow.value--;
                        //               },
                        //         icon: Icon(
                        //           Icons.arrow_back_rounded,
                        //           size: 18,
                        //           color: _c.indexNow.value == 0
                        //               ? Colors.grey
                        //               : Colors.white,
                        //         ),
                        //         label: Padding(
                        //           padding: const EdgeInsets.only(top: 4, left: 10),
                        //           child: AppTextNormal.labelNormal(
                        //             "Back",
                        //             14,
                        //             _c.indexNow.value == 0
                        //                 ? Colors.grey
                        //                 : Colors.white,
                        //           ),
                        //         ),
                        //       ),
                        //       const Spacer(),
                        //       AppTextNormal.labelBold(
                        //         "Question ${_c.indexNow.value + 1}/${_c.multipleChoices.length}",
                        //         16,
                        //         Colors.white,
                        //         letterSpacing: 2.5,
                        //       ),
                        //       const Spacer(),
                        //       TextButton.icon(
                        //         onPressed: (_c.indexNow.value + 1) ==
                        //                 _c.multipleChoices.length
                        //             ? null
                        //             : () {
                        //                 _c.indexNow.value++;
                        //               },
                        //         label: Icon(
                        //           Icons.arrow_forward_rounded,
                        //           size: 18,
                        //           color: (_c.indexNow.value + 1) ==
                        //                   _c.multipleChoices.length
                        //               ? Colors.grey
                        //               : Colors.white,
                        //         ),
                        //         icon: Padding(
                        //           padding: const EdgeInsets.only(top: 4, left: 10),
                        //           child: AppTextNormal.labelNormal(
                        //             "Next",
                        //             14,
                        //             (_c.indexNow.value + 1) ==
                        //                     _c.multipleChoices.length
                        //                 ? Colors.grey
                        //                 : Colors.white,
                        //           ),
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        SizedBox(
                          width: size.width / 2.2,
                          height: 150,
                          child: AppTextNormal.labelBold(
                            _c.multipleChoices[_c.indexNow.value].question,
                            25,
                            Colors.white,
                            letterSpacing: 2.5,
                            textAlign: TextAlign.center,
                            height: 1.6,
                            maxLines: 10,
                          ),
                        ),
                        18.ph,
                        SizedBox(
                          width: size.width / 2.4,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AppTextNormal.labelBold(
                                "Max Point : ${convertNumber(_c.point.value)}",
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                                _c.multipleChoices[_c.indexNow.value].options
                                    .length, (index) {
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
                                    width: size.width / 2.4,
                                    margin: const EdgeInsets.all(12),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 18, vertical: 18),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      color: _c.listAnswer[_c.indexNow.value]
                                                  .indexAnswer ==
                                              index
                                          ? colorGold
                                          : _c.indexOptionHover.value == index
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
                                            color:
                                                colorPointRank.withOpacity(0.4),
                                          ),
                                          child: AppTextNormal.labelBold(
                                            String.fromCharCode(65 + index),
                                            16,
                                            Colors.black,
                                          ),
                                        ),
                                        14.pw,
                                        AppTextNormal.labelBold(
                                          _c.multipleChoices[_c.indexNow.value]
                                              .options[index].answer,
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
              Center(
                child: Container(
                  height: 200,
                  width: size.width / 2.6,
                  color: Colors.grey.withOpacity(0.4),
                  child: Builder(
                    builder: (context) {
                      return DropzoneView(
                        onCreated: (controller) =>
                            _c.dropzoneController = controller,
                        onDropFile: (file) async {
                          _c.fileName.value = file.name;
                        },
                        onError: (e) => debugPrint('Error: $e'),
                      );
                    },
                  ),
                ),
              ),
              Positioned.fill(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      160.ph,
                      const Icon(Icons.cloud_upload,
                          size: 50, color: Colors.grey),
                      const Text("Drag & Drop or Click to Upload"),
                      80.ph,
                      ElevatedButton.icon(
                        onPressed: _c.pickImage,
                        icon: const Icon(Icons.file_upload),
                        label: Text("Pick Image ${_c.fileName.value}"),
                      ),
                      const SizedBox(height: 20),
                      Obx(() {
                        if (_c.imageBytes.value != null) {
                          return Column(
                            children: [
                              160.ph,
                              Text("Uploaded File: ${_c.fileName}"),
                              const SizedBox(height: 10),
                              Image.memory(
                                _c.imageBytes.value!,
                                height: 200,
                                fit: BoxFit.cover,
                              ),
                            ],
                          );
                        }
                        return const SizedBox();
                      })
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
