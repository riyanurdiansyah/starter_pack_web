import 'package:animated_item/animated_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:starter_pack_web/module/rnd/controller/rnd_controller.dart';
import 'package:starter_pack_web/utils/app_dialog.dart';
import 'package:starter_pack_web/utils/app_extension.dart';

import '../../../utils/app_color.dart';
import '../../../utils/app_sound.dart';
import '../../../utils/app_text.dart';

class RndPage extends StatelessWidget {
  RndPage({super.key});

  final _c = Get.find<RndController>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Obx(
                        () => MouseRegion(
                          cursor: SystemMouseCursors.click,
                          onEnter: (_) {
                            AppSound.playHover();
                            _c.isHovered.value = true;
                          },
                          onExit: (_) {
                            _c.isHovered.value = false;
                          },
                          child: InkWell(
                            onTap: () => context.pop(),
                            child: Container(
                              alignment: Alignment.center,
                              color: Colors.white,
                              height: 45,
                              width: 100,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 25.0),
                                child: AppTextNormal.labelBold(
                                  "BACK",
                                  26,
                                  _c.isHovered.value
                                      ? colorElectricViolet
                                      : Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                20.ph,
                Expanded(
                  child: Obx(() {
                    if (_c.isDone.value) {
                      return Center(
                        child: AppTextNormal.labelBold(
                          "You have already created the product.",
                          26,
                          Colors.blueAccent,
                        ),
                      );
                    }

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          children: [
                            SizedBox(
                              height: 500,
                              child: PageView.builder(
                                controller: _c.verticalTranslateController,
                                itemCount: _c.products.length,
                                itemBuilder: (context, index) {
                                  return AnimatedPage(
                                    controller: _c.verticalTranslateController,
                                    index: index,
                                    effect: const TranslateEffect(
                                      animationAxis: Axis.vertical,
                                      startOffset: 20,
                                    ),
                                    child: Container(
                                      margin: const EdgeInsets.all(5.0),
                                      width: 60,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        image: DecorationImage(
                                          image: NetworkImage(
                                            _c.products[index].image,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }, // Can be null
                              ),
                            ),
                            Positioned(
                              top: 250,
                              left: 550,
                              child: IconButton(
                                onPressed: _c.previousPage,
                                icon: const Icon(
                                  CupertinoIcons.arrowtriangle_left_circle,
                                  color: Colors.grey,
                                  size: 50,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 250,
                              right: 550,
                              child: IconButton(
                                onPressed: _c.nextPage,
                                icon: const Icon(
                                  CupertinoIcons.arrowtriangle_right_circle,
                                  color: Colors.grey,
                                  size: 50,
                                ),
                              ),
                            ),
                          ],
                        ),
                        OutlinedButton(
                          onPressed: _c.onSelect,
                          style: OutlinedButton.styleFrom(
                            backgroundColor:
                                _c.indexSelecteds.contains(_c.indexImg.value)
                                    ? Colors.amber
                                    : null,
                          ),
                          child: AppTextNormal.labelBold(
                            "SELECT",
                            16,
                            Colors.black,
                          ),
                        ),
                      ],
                    );
                  }),
                ),
                Obx(() {
                  if (_c.isDone.value) {
                    return const SizedBox();
                  }
                  return MouseRegion(
                    onEnter: (_) => AppSound.playHover(),
                    child: SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: ElevatedButton(
                        onPressed: _c.checkedProducts.length > 3 ||
                                _c.checkedProducts.isEmpty
                            ? null
                            : () {
                                AppDialog.dialogDelete(
                                  title: "Save Product",
                                  subtitle:
                                      "Are you sure you want to save this product?\nThe data cannot be changed later.",
                                  callback: () {
                                    context.pop();
                                    _c.saveProduct();
                                  },
                                  confirmText: "Yes, save",
                                );
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: AppTextNormal.labelBold(
                          "SAVE",
                          22,
                          Colors.white,
                          letterSpacing: 1.8,
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
          Obx(() {
            if (_c.indexSelecteds.isEmpty) {
              return const SizedBox();
            }

            return Positioned(
              right: 25,
              top: 25,
              child: Container(
                width: 250,
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: Colors.red.shade200,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Column(
                  children: [
                    Column(
                      children: List.generate(
                        _c.indexSelecteds.length,
                        (index) {
                          return Text(
                            "${_c.products[_c.indexSelecteds[index]].nama} ${_c.products[_c.indexSelecteds[index]].tipe}",
                          );
                        },
                      ),
                    ),
                    14.ph,
                    ElevatedButton(
                      onPressed: _c.saveProduct,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: AppTextNormal.labelBold(
                        "SAVE",
                        14,
                        Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            );
          })
        ],
      ),
    );
  }
}
