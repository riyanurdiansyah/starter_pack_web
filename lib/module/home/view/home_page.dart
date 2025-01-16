import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:starter_pack_web/module/home/controller/home_controller.dart';
import 'package:starter_pack_web/module/home/view/widget/challenge_board_page.dart';
import 'package:starter_pack_web/utils/app_dialog.dart';
import 'package:starter_pack_web/utils/app_extension.dart';
import 'package:starter_pack_web/utils/app_text.dart';

import '../../../utils/app_color.dart';
import '../../../utils/app_images.dart';
import 'widget/individu_page.dart';
import 'widget/team_page.dart';

class CustomClipRank extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0.0, 0.0);
    path.lineTo(0.0, size.height);
    path.lineTo(size.width / 1.025, size.height);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final _c = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = MediaQuery.sizeOf(context).width < 600;
    return Obx(() {
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
      return Scaffold(
        backgroundColor: Colors.black.withOpacity(0.8),
        body: Row(
          children: [
            if (!isMobile)
              Expanded(
                flex: 1,
                child: Container(
                  height: 250,
                ),
              ),
            if (!isMobile)
              Expanded(
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  onEnter: (_) {
                    // _c.isHovered.value = true;
                  },
                  onExit: (_) {
                    // _c.isHovered.value = false;
                  },
                  child: Obx(
                    () => SizedBox(
                      width: 50,
                      height: 50,
                      child: GestureDetector(
                        onTap: _c.indexTab.value == 0
                            ? null
                            : () {
                                _c.indexTab.value--;
                              },
                        child: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color:
                              _c.indexTab.value == 0 ? Colors.grey : Colors.red,
                          size: 35,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            Expanded(
              flex: 10,
              child: Container(
                margin: isMobile ? const EdgeInsets.only(top: 50) : null,
                alignment: Alignment.topCenter,
                width: size.width,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_c.boards[_c.indexTab.value] != "GROUP" &&
                            _c.boards[_c.indexTab.value] != "USER")
                          20.ph,
                        if (_c.boards[_c.indexTab.value] != "GROUP" &&
                            _c.boards[_c.indexTab.value] != "USER")
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AppTextNormal.labelBold(
                                "${_c.challenges[_c.challenges.indexWhere((e) => e.id == _c.boards[_c.indexTab.value])].name} Board",
                                26,
                                Colors.white,
                              ),
                              if (_c
                                      .challenges[_c.challenges.indexWhere(
                                          (e) =>
                                              e.id ==
                                              _c.boards[_c.indexTab.value])]
                                      .isSpecialChallenge &&
                                  _c.users.indexWhere((e) =>
                                          e.username ==
                                          _c.userSession.value.username) ==
                                      0 &&
                                  _c
                                          .challenges[_c.challenges.indexWhere(
                                              (e) =>
                                                  e.id ==
                                                  _c.boards[_c.indexTab.value])]
                                          .isUseSpecialChallenge ==
                                      false)
                                Padding(
                                  padding: const EdgeInsets.only(right: 50.0),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      AppDialog.dialogSpecialChallenge();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: colorPrimaryDark,
                                    ),
                                    child: AppTextNormal.labelBold(
                                      "Get Your privilege",
                                      16,
                                      Colors.white,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        20.ph,
                        Obx(
                          () => Container(
                            margin: isMobile
                                ? null
                                : const EdgeInsets.only(left: 50),
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            width: isMobile ? size.width : size.width / 1.6,
                            height: 40,
                            color: colorElectricViolet,
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 50,
                                  child: AppTextNormal.labelBold(
                                    "RANK",
                                    isMobile ? 10 : 14,
                                    Colors.white,
                                  ),
                                ),
                                if (!isMobile)
                                  SizedBox(
                                    width: 100,
                                    child: AppTextNormal.labelBold(
                                      "",
                                      14,
                                      Colors.white,
                                    ),
                                  ),
                                if (_c.indexTab.value == 0 && !isMobile)
                                  SizedBox(
                                    width: 80,
                                    child: AppTextNormal.labelBold(
                                      "",
                                      14,
                                      Colors.white,
                                    ),
                                  ),
                                Expanded(
                                  flex: 2,
                                  child: AppTextNormal.labelBold(
                                    _c.indexTab.value == 0 ? "TEAM" : "NAME",
                                    14,
                                    Colors.white,
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: AppTextNormal.labelBold(
                                    _c.boards[_c.indexTab.value] == "GROUP"
                                        ? "CURRENT BALANCE"
                                        : "TEAM",
                                    14,
                                    Colors.white,
                                  ),
                                ),
                                if (_c.boards[_c.indexTab.value] == "USER" &&
                                    !isMobile)
                                  Expanded(
                                    child: AppTextNormal.labelBold(
                                      "ROLE",
                                      14,
                                      Colors.white,
                                    ),
                                  ),
                                SizedBox(
                                  width: 70,
                                  child: AppTextNormal.labelBold(
                                    _c.boards[_c.indexTab.value] == "GROUP"
                                        ? "REVENUE"
                                        : "POINT",
                                    14,
                                    Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        20.ph,
                        Obx(
                          () {
                            if (_c.boards[_c.indexTab.value] == "GROUP") {
                              return TeamPage();
                            }

                            if (_c.boards[_c.indexTab.value] == "USER") {
                              return IndividuPage();
                            }
                            return ChallengeBoardPage(
                              indexNow: _c.indexTab.value,
                            );
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (!isMobile)
              Expanded(
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  onEnter: (_) {
                    // _c.isHovered.value = true;
                  },
                  onExit: (_) {
                    // _c.isHovered.value = false;
                  },
                  child: Obx(
                    () => SizedBox(
                      width: 50,
                      height: 50,
                      child: GestureDetector(
                        onTap: _c.indexTab.value == (_c.boards.length - 1)
                            ? null
                            : () {
                                _c.indexTab.value++;
                              },
                        child: Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: _c.indexTab.value == (_c.boards.length - 1)
                              ? Colors.grey
                              : Colors.red,
                          size: 35,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            if (!isMobile)
              Expanded(
                flex: 1,
                child: Container(
                  height: 250,
                ),
              ),
          ],
        ),
        bottomNavigationBar: !isMobile
            ? null
            : Row(
                children: [
                  Expanded(
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      onEnter: (_) {
                        // _c.isHovered.value = true;
                      },
                      onExit: (_) {
                        // _c.isHovered.value = false;
                      },
                      child: Obx(
                        () => SizedBox(
                          width: 50,
                          height: 50,
                          child: GestureDetector(
                            onTap: _c.indexTab.value == 0
                                ? null
                                : () {
                                    _c.indexTab.value--;
                                  },
                            child: Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: _c.indexTab.value == 0
                                  ? Colors.grey
                                  : Colors.red,
                              size: 35,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      onEnter: (_) {
                        // _c.isHovered.value = true;
                      },
                      onExit: (_) {
                        // _c.isHovered.value = false;
                      },
                      child: Obx(
                        () => SizedBox(
                          width: 50,
                          height: 50,
                          child: GestureDetector(
                            onTap: _c.indexTab.value == (_c.boards.length - 1)
                                ? null
                                : () {
                                    _c.indexTab.value++;
                                  },
                            child: Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: _c.indexTab.value == (_c.boards.length - 1)
                                  ? Colors.grey
                                  : Colors.red,
                              size: 35,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      );
    });
  }
}

class IconRank extends StatelessWidget {
  const IconRank({super.key, required this.oldRank, required this.thenRank});

  final int oldRank;
  final int thenRank;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if ((oldRank - thenRank) > 0)
          const Center(
            child: Icon(
              Icons.arrow_drop_up_rounded,
              color: Colors.green,
              size: 25,
            ),
          ),
        if ((oldRank - thenRank) < 0)
          const Center(
            child: Icon(
              Icons.arrow_drop_down_rounded,
              color: Colors.red,
              size: 25,
            ),
          ),
        Center(
          child: AppTextNormal.labelBold(
            (oldRank - thenRank) > 0
                ? "+${(oldRank - thenRank).toString()}"
                : (oldRank - thenRank) < 0
                    ? (oldRank - thenRank).toString()
                    : "",
            12,
            (oldRank - thenRank) > 0
                ? Colors.green
                : (oldRank - thenRank) < 0
                    ? Colors.red
                    : Colors.white,
          ),
        ),
      ],
    );
  }
}
