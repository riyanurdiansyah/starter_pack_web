import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:starter_pack_web/module/home/controller/home_controller.dart';
import 'package:starter_pack_web/utils/app_color.dart';
import 'package:starter_pack_web/utils/app_extension.dart';
import 'package:starter_pack_web/utils/app_text.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final _c = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: colorPrimary,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 25),
        child: Column(
          children: [
            Row(
              children: [
                Image.asset(
                  "images/crown.png",
                  width: 40,
                ),
                const SizedBox(
                  width: 16,
                ),
                AppTextNormal.labelBold(
                  "Leader Board",
                  24,
                  Colors.black,
                )
              ],
            ),
            8.ph,
            Container(
              width: double.infinity,
              height: 0.2,
              color: colorPrimaryDark,
            ),
            25.ph,
            Row(
              children: List.generate(
                3,
                (index) => Obx(
                  () => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: InkWell(
                      onTap: () => _c.onChangeFilter(index),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: _c.indexFilter.value == index
                              ? colorPrimaryDark
                              : Colors.white,
                          border: Border.all(
                            color: Colors.black,
                            width: 0.8,
                          ),
                        ),
                        child: AppTextNormal.labelW600(
                          "Filter $index",
                          14,
                          _c.indexFilter.value == index
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            16.ph,
            Expanded(
              child: Obx(
                () => IndexedStack(
                  index: _c.indexFilter.value,
                  children: [
                    ListView(
                      children: List.generate(
                        11,
                        (index) => Container(
                          height: 125,
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          color: index == 0
                              ? colorGold
                              : index == 1
                                  ? Colors.red
                                  : index == 2
                                      ? Colors.blue
                                      : Colors.grey.withOpacity(0.5),
                          child: Row(
                            children: [
                              Container(
                                alignment: Alignment.center,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                margin: const EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 4),
                                height: 150,
                                color: Colors.grey.withOpacity(0.3),
                                child: AppTextNormal.labelW600(
                                  "${index + 1}",
                                  14,
                                  Colors.black,
                                ),
                              ),
                              16.pw,
                              Expanded(
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          AppTextNormal.labelBold(
                                            "Kelompok ${index + 1}",
                                            20,
                                            Colors.black,
                                          ),
                                          8.ph,
                                          AppTextNormal.labelW600(
                                            "Autonomus Mobile",
                                            16,
                                            Colors.black,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 5,
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 2,
                                            height: 80,
                                            color: Colors.black26,
                                          ),
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                AppTextNormal.labelW400(
                                                  "Money",
                                                  12,
                                                  Colors.black,
                                                ),
                                                8.ph,
                                                AppTextNormal.labelBold(
                                                  "Rs. 1200",
                                                  18,
                                                  Colors.black,
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            width: 2,
                                            height: 80,
                                            color: Colors.black26,
                                          ),
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                AppTextNormal.labelW400(
                                                  "Product",
                                                  12,
                                                  Colors.black,
                                                ),
                                                8.ph,
                                                AppTextNormal.labelBold(
                                                  "200",
                                                  18,
                                                  Colors.black,
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            width: 2,
                                            height: 80,
                                            color: Colors.black26,
                                          ),
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                AppTextNormal.labelW400(
                                                  "Sold",
                                                  12,
                                                  Colors.black,
                                                ),
                                                8.ph,
                                                AppTextNormal.labelBold(
                                                  "80",
                                                  18,
                                                  Colors.black,
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            width: 2,
                                            height: 80,
                                            color: Colors.black26,
                                          ),
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                AppTextNormal.labelW400(
                                                  "Money",
                                                  12,
                                                  Colors.black,
                                                ),
                                                8.ph,
                                                AppTextNormal.labelBold(
                                                  "Rs. 1200",
                                                  18,
                                                  Colors.black,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
