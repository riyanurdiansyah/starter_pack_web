import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:starter_pack_web/module/challenge/model/quiz_session_m.dart';
import 'package:starter_pack_web/module/dashboard/controller/game_controller.dart';
import 'package:starter_pack_web/utils/app_data_table.dart';

import '../../../utils/app_color.dart';
import '../../../utils/app_dialog.dart';
import '../../../utils/app_text.dart';

class GamePage extends StatelessWidget {
  GamePage({super.key});

  final _c = Get.find<GameController>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Obx(() {
              if (_c.isLoading.value) {
                return const SizedBox();
              }
              return Container(
                color: Colors.white,
                child: AppDataTable<QuizSessionM>(
                  headers: const [
                    "Image",
                    "Username",
                    "Group",
                    "Remark",
                    "Uploaded At"
                  ],
                  datas: _c.isUsingGame(),
                  currentPage: _c.currentPage.value,
                  totalPage: _c.isTotalPage(),
                  onPageChanged: _c.onChangepage,
                  onSearched: _c.onSearched,
                  buildRow: (data) => Column(
                    children: [
                      Container(
                        color: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 16),
                        child: Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  AppDialog.dialogMarkChallenge(data);
                                },
                                child: CachedNetworkImage(
                                  imageUrl: data.image,
                                  width: 80,
                                  height: 80,
                                ),
                              ),
                            ),
                            Expanded(
                              child: AppTextNormal.labelW500(
                                data.username,
                                16,
                                colorPrimaryDark,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              child: AppTextNormal.labelW500(
                                _c.groups
                                    .where((e) => e.id == data.groupId)
                                    .first
                                    .alias,
                                16,
                                colorPrimaryDark,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              child: AppTextNormal.labelW500(
                                data.remark,
                                16,
                                colorPrimaryDark,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              child: AppTextNormal.labelW500(
                                DateFormat("dd MMM yyyy HH:mm:ss")
                                    .format(DateTime.parse(data.createdAt)),
                                16,
                                colorPrimaryDark,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(
                              width: 100,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 26,
                                    height: 26,
                                    padding: const EdgeInsets.all(2.5),
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        AppDialog.dialogMarkChallenge(data);
                                      },
                                      child: const Icon(
                                        Icons.check,
                                        size: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  // 8.pw,
                                  // Container(
                                  //   width: 26,
                                  //   height: 26,
                                  //   padding: const EdgeInsets.all(2.5),
                                  //   decoration: BoxDecoration(
                                  //     color: Colors.red,
                                  //     borderRadius: BorderRadius.circular(4),
                                  //   ),
                                  //   child: InkWell(
                                  //     onTap: () {},
                                  //     child: const Icon(
                                  //       Icons.close,
                                  //       size: 16,
                                  //       color: Colors.white,
                                  //     ),
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 0.6,
                        width: double.infinity,
                        color: Colors.grey.shade400,
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.small(
        onPressed: () => AppDialog.dialogAddNews(),
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
