import 'package:cached_network_image/cached_network_image.dart';
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
    return Scaffold(
      body: Padding(
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
                  Container(
                    alignment: Alignment.center,
                    height: 45,
                    child: const Text(
                      "Research & Development",
                      style: TextStyle(
                        fontFamily: "Race",
                        fontSize: 35,
                        color: colorElectricViolet,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 4,
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
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // 2 item per baris
                    crossAxisSpacing: 16.0, // Jarak horizontal antar item
                    mainAxisSpacing: 16.0, // Jarak vertikal antar item
                    childAspectRatio: 5, // Rasio lebar : tinggi item
                  ),
                  itemCount: _c.products.length,
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 14),
                            height: 135,
                            width: 110,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                width: 0.2,
                                color: Colors.grey.shade200,
                              ),
                            ),
                            child: CachedNetworkImage(
                              imageUrl: _c.products[index].image,
                              placeholder: (_, __) => Container(
                                color: Colors.grey.shade400,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppTextNormal.labelBold(
                                  "${_c.products[index].nama}  -  ${_c.products[index].tipe}",
                                  22,
                                  Colors.white,
                                  letterSpacing: 1.6,
                                ),
                                10.ph,
                                AppTextNormal.labelBold(
                                  "Cost  -  \$${convertNumber(_c.products[index].harga)}",
                                  16,
                                  Colors.white,
                                  letterSpacing: 1.6,
                                ),
                              ],
                            ),
                          ),
                          16.pw,
                          Obx(
                            () => MouseRegion(
                              onEnter: (_) => AppSound.playHover(),
                              child: Transform.scale(
                                scale:
                                    1.4, // Ubah angka ini untuk menyesuaikan ukuran (1.0 = ukuran asli)
                                child: Checkbox(
                                  value: _c.checkedProducts
                                      .contains(_c.products[index].id),
                                  onChanged: (_) =>
                                      _c.onCheckProduct(_c.products[index].id),
                                  activeColor: Colors.white,
                                  checkColor: Colors.red,
                                  fillColor: WidgetStatePropertyAll(
                                      Colors.grey.shade200),
                                  side: const BorderSide(
                                      width: 1.6, color: Colors.white),
                                  materialTapTargetSize: MaterialTapTargetSize
                                      .shrinkWrap, // Hilangkan padding ekstra
                                ),
                              ),
                            ),
                          ),
                          25.pw,
                        ],
                      ),
                    );
                  },
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
    );
  }
}
