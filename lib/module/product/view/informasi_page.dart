import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:starter_pack_web/module/product/controller/product_controller.dart';

import '../../../utils/app_color.dart';
import '../../../utils/app_text.dart';

class InformasiPage extends StatelessWidget {
  InformasiPage({super.key});

  final _c = Get.find<ProductController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppTextNormal.labelBold(
            "Nilai Gizi",
            16,
            colorPrimaryDark,
          ),
          const SizedBox(
            height: 14,
          ),
          GridView.count(
            crossAxisSpacing: 5,
            mainAxisSpacing: 5,
            crossAxisCount: 2,
            childAspectRatio: 5,
            shrinkWrap: true,
            children: List.generate(
              _c.products[_c.currentPage.value].informasi.length,
              (index) {
                final data = _c.products[_c.currentPage.value].informasi[index];
                return Obx(
                  () => Card(
                    // Menggunakan Card untuk tampilan yang lebih baik
                    color: Colors.white,
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8.0), // Padding dalam ListTile
                      leading: Checkbox(
                        value: _c.informasiSelected.contains(data),
                        onChanged: (val) => _c.onSelectInformasi(data),
                      ),
                      title: AppTextNormal.labelBold(
                        "\$${data.price} - ${data.gizi}",
                        16,
                        Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
