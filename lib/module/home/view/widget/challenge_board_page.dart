import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:starter_pack_web/utils/app_extension.dart';

import '../../../../utils/app_color.dart';
import '../../../../utils/app_images.dart';
import '../../../../utils/app_pagination.dart';
import '../../../../utils/app_text.dart';
import '../../controller/home_controller.dart';
import '../home_page.dart';

class ChallengeBoardPage extends StatelessWidget {
  ChallengeBoardPage({super.key, required this.indexNow});

  final int indexNow;

  final _c = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = MediaQuery.sizeOf(context).width < 600;
    return SizedBox(
      width: isMobile ? size.width : size.width / 1.5,
      child: Obx(
        () {
          return Column(
            children: [
              Column(
                children: List.generate(
                    _c.challengeUsers[_c.indexTab.value]
                        .where((e) =>
                            e.page ==
                            _c.currentPageChallenges[_c.indexTab.value])
                        .toList()
                        .length, (index) {
                  final data = _c.challengeUsers[_c.indexTab.value]
                      .where((e) =>
                          e.page == _c.currentPageChallenges[_c.indexTab.value])
                      .toList()[index];
                  return Row(
                    children: [
                      if (index == 0 &&
                          _c.currentPageChallenges[_c.indexTab.value] == 1 &&
                          !isMobile)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Image.asset(
                            goldMedal,
                            width: 30,
                          ),
                        ),
                      if (index == 1 &&
                          _c.currentPageChallenges[_c.indexTab.value] == 1 &&
                          !isMobile)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Image.asset(
                            bronzeMedal,
                            width: 30,
                          ),
                        ),
                      if (index == 2 &&
                          _c.currentPageChallenges[_c.indexTab.value] == 1 &&
                          !isMobile)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Image.asset(
                            bronzeMedal,
                            width: 30,
                            color: Colors.brown,
                          ),
                        ),
                      if (index > 2 &&
                          _c.currentPageChallenges[_c.indexTab.value] == 1 &&
                          !isMobile)
                        const SizedBox(
                          width: 30,
                        ),
                      if (_c.currentPageChallenges[_c.indexTab.value] > 1 &&
                          !isMobile)
                        const SizedBox(
                          width: 30,
                        ),
                      Expanded(
                        child: ClipPath(
                            clipper: CustomClipRank(),
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                color: _c.userSession.value.username ==
                                        data.username
                                    ? colorGold
                                    : colorCardRank,
                              ),
                              margin: EdgeInsets.only(
                                  bottom: 10, left: isMobile ? 0 : 20),
                              alignment: Alignment.center,
                              height: 45,
                              child: InkWell(
                                onTap: () {},
                                child: Row(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(left: 6),
                                      width: 50,
                                      child: AppTextNormal.labelBold(
                                        "${((_c.currentPageChallenges[_c.indexTab.value] - 1) * _c.dataPerPageChallenges[_c.indexTab.value]) + index + 1}", // Nomor urut
                                        16,
                                        Colors.black,
                                      ),
                                    ),
                                    if (!isMobile)
                                      const SizedBox(
                                        width: 80,
                                      ),
                                    if (!isMobile) 10.pw,
                                    Expanded(
                                      flex: 2,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          AppTextNormal.labelBold(
                                            data.nama,
                                            14,
                                            Colors.black,
                                            letterSpacing: 3.5,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: AppTextNormal.labelBold(
                                        _c.groups
                                                .firstWhereOrNull(
                                                    (e) => e.id == data.groupId)
                                                ?.alias ??
                                            "-",
                                        14,
                                        Colors.black,
                                      ),
                                    ),
                                    Container(
                                      width: 70,
                                      padding: const EdgeInsets.all(6),
                                      margin: const EdgeInsets.all(6),
                                      alignment: Alignment.center,
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8)),
                                        color: colorPointRank,
                                      ),
                                      child: FittedBox(
                                        child: AppTextNormal.labelBold(
                                          // "R\$ ${_c.quizess.indexWhere((e) => e.quizId == _c.boards[_c.indexTab.value] && e.username == data.username) < 0 ? 0 : _c.quizess[_c.quizess.indexWhere((e) => e.quizId == _c.boards[_c.indexTab.value] && e.username == data.username)].point}",
                                          "${data.point}",
                                          14,
                                          Colors.white,
                                        ),
                                      ),
                                    ),
                                    25.pw,
                                  ],
                                ),
                              ),
                            )),
                      )
                    ],
                  )
                      .animate() // Mulai menambahkan animasi
                      .fadeIn(
                        // Fade-in animasi
                        duration: 500.ms, // durasi 500ms
                        delay: (index * 300).ms, // delay bertahap per index
                      );
                }),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40.0),
                child: AppPaginationBoard(
                  currentPage: _c.currentPageChallenges[_c.indexTab.value],
                  totalPage: (_c.challengeUsers[_c.indexTab.value].length /
                                  _c.dataPerPageChallenges[_c.indexTab.value])
                              .ceil() ==
                          0
                      ? 1
                      : (_c.challengeUsers[_c.indexTab.value].length /
                              _c.dataPerPageChallenges[_c.indexTab.value])
                          .ceil(),
                  onPageChanged: _c.onChangepage,
                  onSearched: _c.onSearched,
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
