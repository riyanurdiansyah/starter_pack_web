import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:starter_pack_web/module/demography/controller/cart_controller.dart';
import 'package:starter_pack_web/module/user/model/group_m.dart';
import 'package:starter_pack_web/utils/app_dialog.dart';
import 'package:starter_pack_web/utils/app_extension.dart';
import 'package:starter_pack_web/utils/app_sound.dart';

import '../../../utils/app_color.dart';
import '../../../utils/app_text.dart';

class CartPage extends StatelessWidget {
  CartPage({super.key});

  final _c = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
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
                      "Production",
                      style: TextStyle(
                        fontFamily: "Race",
                        fontSize: 35,
                        color: colorElectricViolet,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 4,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Obx(() {
                    if (_c.userSession.value.id == "") {
                      return const SizedBox();
                    }

                    return StreamBuilder<GroupM>(
                      // Memanggil stream dari controller yang sudah dikonversi ke model
                      stream: _c.groupStream(),
                      builder: (context, AsyncSnapshot<GroupM> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        if (snapshot.hasError) {
                          return Center(
                              child: Text("Error: ${snapshot.error}"));
                        }

                        if (!snapshot.hasData) {
                          return const Center(child: Text("Data not found"));
                        }

                        // Mendapatkan data dari model UserModel
                        return Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: colorElectricViolet,
                          ),
                          child: Text(
                            "\$ ${convertNumber(_c.groupData.value.point)}",
                            style: const TextStyle(
                              fontFamily: "Race",
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      },
                    );
                  }),
                ],
              ),
            ),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(
                    () => Expanded(
                      flex: 5,
                      child: SingleChildScrollView(
                        child: Column(
                          children: List.generate(_c.products.length, (index) {
                            // final data = _c.products[index];
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Container(
                                    height: 135,
                                    width: 110,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(
                                        width: 0.2,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                    child: CachedNetworkImage(
                                      imageUrl: _c.products[index].image,
                                      placeholder: (_, __) => Container(
                                        color: Colors.grey.shade400,
                                      ),
                                    ),
                                  ),
                                  16.pw,
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        AppTextNormal.labelW600(
                                          _c.products[index].tipe,
                                          18,
                                          Colors.black,
                                        ),
                                        8.ph,
                                        AppTextNormal.labelBold(
                                          _c.products[index].nama,
                                          24,
                                          colorPointRank,
                                          letterSpacing: 2,
                                        ),
                                        16.ph,
                                      ],
                                    ),
                                  ),
                                  12.pw,
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        AppTextNormal.labelW600(
                                          "Cost",
                                          18,
                                          Colors.black,
                                        ),
                                        8.ph,
                                        AppTextNormal.labelBold(
                                          "\$${convertNumber(_c.products[index].harga)}",
                                          24,
                                          colorPointRank,
                                          letterSpacing: 2,
                                        ),
                                        16.ph,
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        AppTextNormal.labelW600(
                                          "Stock",
                                          18,
                                          Colors.black,
                                        ),
                                        8.ph,
                                        AppTextNormal.labelBold(
                                          "${_c.productsOwn.firstWhereOrNull((x) => x.id == _c.products[index].id)?.qty ?? 0} Pcs",
                                          24,
                                          colorPointRank,
                                          letterSpacing: 2,
                                        ),
                                        16.ph,
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Row(
                                      children: [
                                        MouseRegion(
                                          onEnter: (_) => AppSound.playHover(),
                                          child: InkWell(
                                            onTap: () =>
                                                _c.decrementQuantity(index),
                                            child: Container(
                                              alignment: Alignment.center,
                                              width: 25,
                                              height: 25,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                border: Border.all(
                                                  width: 0.2,
                                                  color: Colors.grey.shade600,
                                                ),
                                              ),
                                              child: AppTextNormal.labelBold(
                                                "-",
                                                18,
                                                Colors.grey.shade600,
                                              ),
                                            ),
                                          ),
                                        ),
                                        14.pw,
                                        Container(
                                          alignment: Alignment.center,
                                          width: 100,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            border: Border.all(
                                              width: 0.2,
                                              color: Colors.grey.shade600,
                                            ),
                                          ),
                                          child: TextField(
                                            controller:
                                                _c.quantityControllers[index],
                                            cursorHeight: 20,
                                            textAlign: TextAlign.center,
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly
                                            ],
                                            keyboardType: TextInputType.number,
                                            onChanged: (value) {
                                              int? newQty = int.tryParse(value);
                                              if (newQty != null) {
                                                _c.products[index] =
                                                    _c.products[index].copyWith(
                                                  qty: newQty,
                                                );
                                              } else {
                                                _c.products[index] =
                                                    _c.products[index].copyWith(
                                                  qty: 0,
                                                );
                                              }
                                            },
                                            decoration: const InputDecoration(
                                              border: InputBorder.none,
                                            ),
                                          ),
                                        ),
                                        14.pw,
                                        MouseRegion(
                                          onEnter: (_) => AppSound.playHover(),
                                          child: InkWell(
                                            onTap: () =>
                                                _c.incrementQuantity(index),
                                            child: Container(
                                              alignment: Alignment.center,
                                              width: 25,
                                              height: 25,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                border: Border.all(
                                                  width: 0.2,
                                                  color: Colors.grey.shade600,
                                                ),
                                              ),
                                              child: AppTextNormal.labelBold(
                                                "+",
                                                18,
                                                Colors.grey.shade600,
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
                  ),
                  Obx(() {
                    if (_c.products
                        .where((x) => x.qty > 0)
                        .toList()
                        .isNotEmpty) {
                      return Expanded(
                        flex: 3,
                        child: Obx(
                          () => Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(18.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  color: Colors.grey.shade100,
                                  border: Border.all(
                                    width: 0.25,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppTextNormal.labelBold(
                                      "Summary",
                                      22,
                                      Colors.black,
                                      letterSpacing: 1.5,
                                    ),
                                    14.ph,
                                    Column(
                                      children: List.generate(
                                        _c.products
                                            .where((x) => x.qty > 0)
                                            .toList()
                                            .length,
                                        (index) {
                                          final data = _c.products
                                              .where((x) => x.qty > 0)
                                              .toList()[index];
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 14),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  flex: 4,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      AppTextNormal.labelBold(
                                                        "${data.nama}  -  ${data.tipe}",
                                                        16,
                                                        Colors.grey.shade600,
                                                        letterSpacing: 1.8,
                                                      ),
                                                      8.ph,
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 8),
                                                        child: AppTextNormal
                                                            .labelW600(
                                                          "\$${convertNumber(data.harga)}  x  ${data.qty}",
                                                          16,
                                                          Colors.grey.shade600,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child:
                                                      AppTextNormal.labelBold(
                                                    "\$${convertNumber((data.harga * data.qty).toInt())}",
                                                    22,
                                                    colorPointRank,
                                                    textAlign: TextAlign.end,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        14.ph,
                                        Container(
                                          height: 2.5,
                                          width: double.infinity,
                                          color: Colors.grey.shade300,
                                        ),
                                        14.ph,
                                        Row(
                                          children: [
                                            Expanded(
                                              flex: 4,
                                              child: AppTextNormal.labelBold(
                                                "TOTAL",
                                                16,
                                                Colors.grey.shade600,
                                                letterSpacing: 1.8,
                                              ),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: AppTextNormal.labelBold(
                                                "\$${convertNumber(_c.products.fold(0, (total, product) => total + (product.qty * product.harga)))}",
                                                22,
                                                colorPointRank,
                                                textAlign: TextAlign.end,
                                              ),
                                            ),
                                          ],
                                        ),
                                        14.ph,
                                        Obx(() {
                                          if (_c.groupData.value.point <
                                              _c.products.fold(
                                                  0,
                                                  (total, product) =>
                                                      total +
                                                      (product.qty *
                                                          product.harga))) {
                                            return Row(
                                              children: [
                                                Expanded(
                                                  flex: 4,
                                                  child:
                                                      AppTextNormal.labelBold(
                                                    "Your balance is insufficient for this production.",
                                                    12,
                                                    Colors.red,
                                                    letterSpacing: 1.4,
                                                    maxLines: 3,
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child:
                                                      AppTextNormal.labelBold(
                                                    "-\$${convertNumber(_c.products.fold(0, (total, product) => total + (product.qty * product.harga)) - _c.groupData.value.point)}",
                                                    22,
                                                    Colors.red,
                                                    textAlign: TextAlign.end,
                                                  ),
                                                ),
                                              ],
                                            );
                                          }
                                          return const SizedBox();
                                        })
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              25.ph,
                              Obx(
                                () => MouseRegion(
                                  onEnter: (_) => AppSound.playHover(),
                                  child: SizedBox(
                                    width: double.infinity,
                                    height: 45,
                                    child: ElevatedButton(
                                      onPressed: _c.groupData.value.point <
                                              _c.products.fold(
                                                  0,
                                                  (total, product) =>
                                                      total +
                                                      (product.qty *
                                                          product.harga))
                                          ? null
                                          : () => AppDialog.dialogDelete(
                                                title: "Create Product",
                                                subtitle:
                                                    "Are you sure you want to create a new product?",
                                                confirmText: "Yes, create",
                                                cancelText: "No, cancel",
                                                callback: () =>
                                                    _c.saveProduct(),
                                              ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: colorPointRank,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                      child: AppTextNormal.labelBold(
                                        "PRODUCTION",
                                        22,
                                        Colors.white,
                                        letterSpacing: 1.8,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    return const SizedBox();
                  })
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
