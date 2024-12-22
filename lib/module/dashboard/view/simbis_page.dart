import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:starter_pack_web/module/dashboard/controller/simbis_controller.dart';
import 'package:starter_pack_web/utils/app_color.dart';

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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Obx(
                  () => Expanded(
                    child: ListView.builder(
                      itemCount: _c.resultSimbis.length,
                      itemBuilder: (context, groupIndex) {
                        final group = _c.resultSimbis[groupIndex];

                        return ExpansionTile(
                          title: Text(group.groupName),
                          children: group.summary.map((area) {
                            return ExpansionTile(
                              title: Text(area.areaName),
                              children: area.products.map((product) {
                                return ListTile(
                                  title: Text(product.productName),
                                  subtitle: Text(
                                    'Sold: ${product.sold} | Profit: ${product.profit}',
                                  ),
                                );
                              }).toList(),
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Obx(() {
            if (!_c.isLoading.value) {
              return const SizedBox();
            }
            return Center(
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: colorPrimaryDark,
                ),
                child: const CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            );
          })
        ],
      ),
      floatingActionButton: ElevatedButton(
        onPressed: _c.generateResult,
        style: ElevatedButton.styleFrom(
          backgroundColor: colorPrimaryDark,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        child: AppTextNormal.labelW600(
          "Generate",
          16,
          Colors.white,
        ),
      ),
    );
  }
}
