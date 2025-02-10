import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:starter_pack_web/module/dashboard/controller/simbis_controller.dart';
import 'package:starter_pack_web/module/demography/model/distribute_m.dart';
import 'package:starter_pack_web/utils/app_data_table.dart';
import 'package:starter_pack_web/utils/app_extension.dart';

import '../../../utils/app_color.dart';
import '../../../utils/app_dialog.dart';
import '../../../utils/app_text.dart';

class SimbisPage extends StatelessWidget {
  SimbisPage({super.key});

  final _c = Get.find<SimbisController>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Obx(
                    () => Container(
                      color: Colors.white,
                      child: AppDataTableSimbis<DistributeM>(
                        headers: _c.groupNames,
                        datas: _c.isUsingSimbis(),
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
                                  SizedBox(
                                    width: 80,
                                    child: FittedBox(
                                      child: AppTextNormal.labelW500(
                                        data.groupName,
                                        16,
                                        colorPrimaryDark,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  50.pw,
                                  Expanded(
                                    flex: data.areas.length,
                                    child: Row(
                                      children:
                                          List.generate(data.areas.length, (i) {
                                        final areaData = data.areas[i];
                                        return Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              AppTextNormal.labelBold(
                                                  "QTY", 10, Colors.black),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: List.generate(
                                                    areaData.products.length,
                                                    (j) {
                                                  final productData =
                                                      areaData.products[j];
                                                  return Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(vertical: 8),
                                                    child:
                                                        AppTextNormal.labelW500(
                                                      "${productData.productName} : ${productData.qty} : ${productData.pricePerProduct}",
                                                      11,
                                                      colorPrimaryDark,
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  );
                                                }),
                                              ),
                                              12.ph,
                                              AppTextNormal.labelBold(
                                                  "SOLD", 10, Colors.black),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: List.generate(
                                                    areaData.products.length,
                                                    (j) {
                                                  final productData =
                                                      areaData.products[j];
                                                  return Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(vertical: 8),
                                                    child:
                                                        AppTextNormal.labelW500(
                                                      "${productData.productName} : ${productData.sold}",
                                                      11,
                                                      colorPrimaryDark,
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  );
                                                }),
                                              ),
                                              12.ph,
                                              AppTextNormal.labelBold(
                                                  "PROFIT", 10, Colors.black),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: List.generate(
                                                    areaData.products.length,
                                                    (j) {
                                                  final productData =
                                                      areaData.products[j];
                                                  return Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(vertical: 8),
                                                    child:
                                                        AppTextNormal.labelW500(
                                                      "${productData.productName} : ${productData.profit}",
                                                      11,
                                                      colorPrimaryDark,
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  );
                                                }),
                                              ),
                                            ],
                                          ),
                                        );
                                      }),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 100,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 26,
                                          height: 26,
                                          padding: const EdgeInsets.all(2.5),
                                          decoration: BoxDecoration(
                                            color: Colors.green,
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          child: InkWell(
                                            onTap: () {},
                                            child: const Icon(
                                              Icons.edit_rounded,
                                              size: 16,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        8.pw,
                                        Container(
                                          width: 26,
                                          height: 26,
                                          padding: const EdgeInsets.all(2.5),
                                          decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          child: InkWell(
                                            onTap: () => AppDialog.dialogDelete(
                                                callback: () {}),
                                            child: const Icon(
                                              Icons.delete_rounded,
                                              size: 16,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
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
                    ),
                  ),
                ],
              ),
            ),
          ),
          Obx(() {
            if (!_c.isLoading.value) {
              return const SizedBox();
            }
            return Container(
              width: double.infinity,
              height: size.height,
              color: Colors.transparent,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: colorPrimaryDark,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        const CircularProgressIndicator(
                          color: Colors.white,
                        ),
                        20.ph,
                        AppTextNormal.labelBold(
                          "Running Simulation Business...",
                          14,
                          Colors.white,
                          letterSpacing: 1.6,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          })
        ],
      ),
      floatingActionButton: FloatingActionButton.small(
        onPressed: _c.generateResult,
        backgroundColor: Colors.blue,
        child: const Icon(
          Icons.get_app_rounded,
          color: Colors.white,
        ),
      ),
    );
  }
}
