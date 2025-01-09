import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:starter_pack_web/module/demography/model/produk_m.dart';
import 'package:starter_pack_web/module/product/controller/product_controller.dart';
import 'package:starter_pack_web/utils/app_data_table.dart';
import 'package:starter_pack_web/utils/app_dialog.dart';
import 'package:starter_pack_web/utils/app_extension.dart';

import '../../../utils/app_color.dart';
import '../../../utils/app_text.dart';

class ProductPage extends StatelessWidget {
  ProductPage({super.key});

  final _c = Get.find<ProductController>();

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
                child: AppDataTable<ProdukM>(
                  headers: const [
                    "Image",
                    "Name",
                    "Type",
                    "Cost",
                  ],
                  datas: _c.isUsingProduct(),
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
                                data.nama,
                                16,
                                colorPrimaryDark,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              child: AppTextNormal.labelW500(
                                data.tipe,
                                16,
                                colorPrimaryDark,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              child: AppTextNormal.labelW500(
                                "\$${convertNumber(data.harga)}",
                                16,
                                colorPrimaryDark,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            50.pw,
                            SizedBox(
                              width: 25,
                              height: 25,
                              child: InkWell(
                                onTap: () => AppDialog.dialogProduk(data),
                                child: const Icon(
                                  Icons.mode_edit_rounded,
                                  color: colorPointRank,
                                  size: 20,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 30,
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
        onPressed: () {},
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
