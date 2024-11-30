import 'package:flutter/material.dart';
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
          return SizedBox(
            width: size.width,
            child: Column(
              children: [
                25.ph,
                SizedBox(
                  width: size.width / 2.4,
                  child: Row(
                    children: [
                      TextButton.icon(
                        onPressed: _c.indexNow.value == 0
                            ? null
                            : () {
                                _c.indexNow.value--;
                              },
                        icon: Icon(
                          Icons.arrow_back_rounded,
                          size: 18,
                          color: _c.indexNow.value == 0
                              ? Colors.grey
                              : Colors.white,
                        ),
                        label: Padding(
                          padding: const EdgeInsets.only(top: 4, left: 10),
                          child: AppTextNormal.labelNormal(
                            "Back",
                            14,
                            _c.indexNow.value == 0 ? Colors.grey : Colors.white,
                          ),
                        ),
                      ),
                      const Spacer(),
                      AppTextNormal.labelBold(
                        "Question ${_c.indexNow.value + 1}/${_c.multipleChoices.length}",
                        16,
                        Colors.white,
                        letterSpacing: 2.5,
                      ),
                      const Spacer(),
                      TextButton.icon(
                        onPressed:
                            (_c.indexNow.value + 1) == _c.multipleChoices.length
                                ? null
                                : () {
                                    _c.indexNow.value++;
                                  },
                        label: Icon(
                          Icons.arrow_forward_rounded,
                          size: 18,
                          color: (_c.indexNow.value + 1) ==
                                  _c.multipleChoices.length
                              ? Colors.grey
                              : Colors.white,
                        ),
                        icon: Padding(
                          padding: const EdgeInsets.only(top: 4, left: 10),
                          child: AppTextNormal.labelNormal(
                            "Next",
                            14,
                            (_c.indexNow.value + 1) == _c.multipleChoices.length
                                ? Colors.grey
                                : Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                25.ph,
                SizedBox(
                  width: size.width / 2.4,
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
                Text(
                  "Max Point : ${_c.challenge.value.maxPoint}",
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                ),
                Text(
                  "Get Point : ${_c.point.value}",
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                ),
                50.ph,
                Container(
                  height: 4,
                  width: double.infinity,
                  color: colorGold,
                ),
                50.ph,
                SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                        _c.multipleChoices[_c.indexNow.value].options.length,
                        (index) {
                      return MouseRegion(
                        onEnter: (_) {
                          _c.indexOptionHover.value = index;
                        },
                        onExit: (_) {
                          _c.indexOptionHover.value = 99;
                        },
                        child: InkWell(
                          onTap: _c.listAnswer[_c.indexNow.value].indexAnswer ==
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
                                    color: colorPointRank.withOpacity(0.4),
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
          );
        },
      ),
    );
  }
}
