import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:starter_pack_web/module/dashboard/controller/challengeset_detail_controller.dart';
import 'package:starter_pack_web/utils/app_color.dart';
import 'package:starter_pack_web/utils/app_extension.dart';
import 'package:starter_pack_web/utils/app_text.dart';

import '../../../utils/app_dialog.dart';

class ChallengesetDetailPage extends StatelessWidget {
  ChallengesetDetailPage({super.key});

  final _c = Get.find<ChallengesetDetailController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  16.ph,
                  AppTextNormal.labelBold(
                    "Questions",
                    14,
                    Colors.black,
                  ),
                  12.ph,
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        width: 0.25,
                        color: Colors.grey,
                      ),
                    ),
                    child: Obx(
                      () => Wrap(
                        spacing: 10,
                        crossAxisAlignment: WrapCrossAlignment.start,
                        runSpacing: 10,
                        children:
                            List.generate(_c.multipleChoices.length, (index) {
                          return InkWell(
                            onTap: () {
                              _c.indexSelected.value = index;
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 6, horizontal: 10),
                              decoration: BoxDecoration(
                                color: _c.indexSelected.value == index
                                    ? colorPointRank
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  width: 0.25,
                                  color: Colors.grey,
                                ),
                              ),
                              child: AppTextNormal.labelBold(
                                "${index + 1}",
                                12,
                                _c.indexSelected.value == index
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Obx(
              () {
                if (_c.indexSelected.value == 999) {
                  return const SizedBox();
                }

                return Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      width: 0.25,
                      color: Colors.grey,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          TextButton.icon(
                            onPressed: _c.indexSelected.value == 0
                                ? null
                                : () {
                                    _c.indexSelected.value--;
                                  },
                            icon: const Icon(
                              Icons.arrow_back_rounded,
                              size: 18,
                            ),
                            label: Padding(
                              padding: const EdgeInsets.only(top: 4, left: 10),
                              child: AppTextNormal.labelNormal(
                                "Back",
                                14,
                                _c.indexSelected.value == 0
                                    ? Colors.grey
                                    : Colors.black,
                              ),
                            ),
                          ),
                          const Spacer(),
                          AppTextNormal.labelBold(
                            "Question : ${_c.indexSelected.value + 1}",
                            16,
                            colorElectricViolet,
                          ),
                          const Spacer(),
                          TextButton.icon(
                            onPressed: (_c.indexSelected.value + 1) ==
                                    _c.multipleChoices.length
                                ? null
                                : () {
                                    _c.indexSelected.value++;
                                  },
                            label: const Icon(
                              Icons.arrow_forward_rounded,
                              size: 18,
                            ),
                            icon: Padding(
                              padding: const EdgeInsets.only(top: 4, left: 10),
                              child: AppTextNormal.labelNormal(
                                "Next",
                                14,
                                (_c.indexSelected.value + 1) ==
                                        _c.multipleChoices.length
                                    ? Colors.grey
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                      26.ph,
                      Obx(() {
                        if (_c.indexSelected.value == 99) {
                          return const SizedBox();
                        }
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 22),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppTextNormal.labelBold(
                                _c.multipleChoices[_c.indexSelected.value]
                                    .question,
                                16,
                                Colors.black,
                                letterSpacing: 1.4,
                              ),
                              18.ph,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: List.generate(
                                  _c.multipleChoices[_c.indexSelected.value]
                                      .options.length,
                                  (index) {
                                    // Mengubah index ke huruf A, B, C, dst.
                                    String optionLabel =
                                        String.fromCharCode(65 + index);
                                    return AppTextNormal.labelBold(
                                      "$optionLabel. ${_c.multipleChoices[_c.indexSelected.value].options[index].answer}",
                                      _c.multipleChoices[_c.indexSelected.value]
                                              .options[index].correct
                                          ? 22
                                          : 14,
                                      _c.multipleChoices[_c.indexSelected.value]
                                              .options[index].correct
                                          ? Colors.green
                                          : Colors.grey.shade600,
                                      height: 1.8,
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () => AppDialog.dialogDelete(
                              callback: () {
                                context.pop();
                                _c.deleteMultipleChoice(
                                    _c.multipleChoices[_c.indexSelected.value]);
                              },
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            child: AppTextNormal.labelBold(
                              "DELETE",
                              14,
                              Colors.white,
                              letterSpacing: 2.5,
                            ),
                          ),
                          10.pw,
                          ElevatedButton(
                            onPressed: () => AppDialog.dialogMultipleQuestion(
                                oldMultipleChoice:
                                    _c.multipleChoices[_c.indexSelected.value]),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueGrey,
                            ),
                            child: AppTextNormal.labelBold(
                              "EDIT",
                              14,
                              Colors.white,
                              letterSpacing: 2.5,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.small(
        onPressed: () => AppDialog.dialogMultipleQuestion(),
        backgroundColor: Colors.blue,
        child: AppTextNormal.labelW600(
          "+",
          30,
          Colors.white,
        ),
      ),
    );
  }
}
