import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:starter_pack_web/middleware/app_route_name.dart';
import 'package:starter_pack_web/module/challenge/model/challenge_m.dart';
import 'package:starter_pack_web/module/dashboard/controller/challengeset_controller.dart';
import 'package:starter_pack_web/utils/app_data_table.dart';

import '../../../utils/app_color.dart';
import '../../../utils/app_dialog.dart';
import '../../../utils/app_text.dart';

class ChallengesetPage extends StatelessWidget {
  ChallengesetPage({super.key});

  final _c = Get.find<ChallengesetController>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Obx(
              () => Container(
                color: Colors.white,
                child: AppDataTable<ChallengeM>(
                  headers: const [
                    "Image",
                    "Challenge",
                    "Type",
                    "Time",
                    "Max Question",
                    "Max Point",
                    "Start",
                    "End"
                  ],
                  datas: _c.isUsingChallenges(),
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
                              child: SizedBox(
                                width: 80,
                                height: 80,
                                child: CachedNetworkImage(
                                  imageUrl: data.image,
                                ),
                              ),
                            ),
                            Expanded(
                              child: AppTextNormal.labelW500(
                                data.name,
                                16,
                                colorPrimaryDark,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              child: AppTextNormal.labelW500(
                                data.type,
                                16,
                                colorPrimaryDark,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              child: AppTextNormal.labelW500(
                                data.time.toString(),
                                16,
                                colorPrimaryDark,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              child: AppTextNormal.labelW500(
                                data.maxQuestion.toString(),
                                16,
                                colorPrimaryDark,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              child: AppTextNormal.labelW500(
                                data.maxPoint.toString(),
                                16,
                                colorPrimaryDark,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              child: AppTextNormal.labelW500(
                                "${DateFormat("dd/MM/yyyy HH:mm").format(DateTime.parse(data.start))} WIB",
                                16,
                                colorPrimaryDark,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              child: AppTextNormal.labelW500(
                                data.end.isEmpty
                                    ? "-"
                                    : "${DateFormat("dd/MM/yyyy HH:mm").format(DateTime.parse(data.end))} WIB",
                                16,
                                colorPrimaryDark,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(
                              width: 25,
                              height: 25,
                              child: InkWell(
                                onTap: () => AppDialog.dialogChallenge(
                                    oldChallenge: data),
                                child: const Icon(
                                  Icons.mode_edit_rounded,
                                  color: colorPointRank,
                                  size: 20,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Container(
                              width: 2,
                              height: 30,
                              color: Colors.grey.shade200,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            SizedBox(
                              width: 25,
                              height: 25,
                              child: InkWell(
                                onTap: () =>
                                    AppDialog.dialogDelete(callback: () {
                                  context.pop();
                                  _c.deleteData(data);
                                }),
                                child: const Icon(
                                  Icons.delete_rounded,
                                  color: Colors.red,
                                  size: 20,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Container(
                              width: 2,
                              height: 30,
                              color: Colors.grey.shade200,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            SizedBox(
                              width: 25,
                              height: 25,
                              child: InkWell(
                                onTap: () => context.goNamed(
                                    AppRouteName.update,
                                    pathParameters: {
                                      "id": data.id,
                                    }),
                                child: const Icon(
                                  Icons.double_arrow_rounded,
                                  color: colorPrimaryDark,
                                  size: 20,
                                ),
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
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.small(
        onPressed: () => AppDialog.dialogChallenge(),
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
