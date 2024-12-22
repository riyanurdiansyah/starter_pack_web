import 'package:animated_item/animated_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:starter_pack_web/module/demography/controller/cart_controller.dart';
import 'package:starter_pack_web/module/user/model/group_m.dart';
import 'package:starter_pack_web/utils/app_extension.dart';
import 'package:starter_pack_web/utils/app_sound.dart';

import '../../../utils/app_color.dart';
import '../../../utils/app_dialog.dart';
import '../../../utils/app_images.dart';
import '../../../utils/app_text.dart';

class CartPage extends StatelessWidget {
  CartPage({super.key});

  final _c = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: size.height,
            child: Image.asset(
              bgProd,
              filterQuality: FilterQuality.high,
              fit: BoxFit.fill,
            ),
          ),
          Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
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
              Obx(() {
                if (_c.products.isEmpty) {
                  return Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    height: MediaQuery.sizeOf(context).height,
                    child: AppTextNormal.labelBold(
                      "Your team member has not created the product yet.",
                      26,
                      Colors.blueAccent,
                    ),
                  );
                }
                return const SizedBox();
              }),
              Stack(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(
                    () => Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          children: [
                            SizedBox(
                              height: size.height / 1.2,
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
                                      margin:
                                          const EdgeInsets.only(bottom: 20.0),
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        image: DecorationImage(
                                          scale: 0.2,
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
                              top: 320,
                              left: 505,
                              child: Image.asset(
                                bgProdName,
                              ),
                            ),
                            Positioned(
                              top: 490,
                              left: 665,
                              child: SizedBox(
                                width: 350,
                                child: FittedBox(
                                  child: AppTextNormal.labelBold(
                                    _c.products[_c.indexImg.value].nama,
                                    35,
                                    Colors.white,
                                    letterSpacing: 8,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 310,
                              left: 600,
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
                              top: 310,
                              right: 600,
                              child: IconButton(
                                onPressed: _c.nextPage,
                                icon: const Icon(
                                  CupertinoIcons.arrowtriangle_right_circle,
                                  color: Colors.grey,
                                  size: 50,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 640,
                              left: 700,
                              child: MouseRegion(
                                onEnter: (_) => AppSound.playHover(),
                                child: InkWell(
                                  onTap: () =>
                                      _c.decrementQuantity(_c.indexImg.value),
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: 25,
                                    height: 25,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(
                                        width: 1.5,
                                        color: Colors.white,
                                      ),
                                    ),
                                    child: AppTextNormal.labelBold(
                                      "-",
                                      18,
                                      Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Obx(() {
                              if (_c.quantityControllers.isEmpty) {
                                return const SizedBox();
                              }
                              return Positioned(
                                top: 630,
                                right: 780,
                                child: Container(
                                  alignment: Alignment.center,
                                  width: 125,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                      width: 2.2,
                                      color: Colors.white,
                                    ),
                                  ),
                                  child: TextField(
                                    controller: _c
                                        .quantityControllers[_c.indexImg.value],
                                    cursorHeight: 20,
                                    textAlign: TextAlign.center,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      int? newQty = int.tryParse(value);
                                      if (newQty != null) {
                                        _c.products[_c.indexImg.value] = _c
                                            .products[_c.indexImg.value]
                                            .copyWith(
                                          qty: newQty,
                                        );
                                      } else {
                                        _c.products[_c.indexImg.value] = _c
                                            .products[_c.indexImg.value]
                                            .copyWith(
                                          qty: 0,
                                        );
                                      }
                                    },
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              );
                            }),
                            Positioned(
                              top: 640,
                              right: 700,
                              child: MouseRegion(
                                onEnter: (_) => AppSound.playHover(),
                                child: InkWell(
                                  onTap: () =>
                                      _c.incrementQuantity(_c.indexImg.value),
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: 25,
                                    height: 25,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(
                                        width: 1.5,
                                        color: Colors.white,
                                      ),
                                    ),
                                    child: AppTextNormal.labelBold(
                                      "+",
                                      18,
                                      Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Obx(() {
                    if (_c.products
                        .where((x) => x.qty > 0)
                        .toList()
                        .isNotEmpty) {
                      return Row(
                        children: [
                          const Expanded(
                            flex: 5,
                            child: SizedBox(),
                          ),
                          Expanded(
                            flex: 2,
                            child: Obx(
                              () => Column(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 6),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                                padding:
                                                    const EdgeInsets.symmetric(
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
                                                          AppTextNormal
                                                              .labelBold(
                                                            "${data.nama}  -  ${data.tipe}",
                                                            16,
                                                            Colors
                                                                .grey.shade600,
                                                            letterSpacing: 1.8,
                                                          ),
                                                          8.ph,
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        8),
                                                            child: AppTextNormal
                                                                .labelW600(
                                                              "\$${convertNumber(data.harga)}  x  ${data.qty}",
                                                              16,
                                                              Colors.grey
                                                                  .shade600,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 2,
                                                      child: AppTextNormal
                                                          .labelBold(
                                                        "\$${convertNumber((data.harga * data.qty).toInt())}",
                                                        22,
                                                        colorPointRank,
                                                        textAlign:
                                                            TextAlign.end,
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
                                                  child:
                                                      AppTextNormal.labelBold(
                                                    "TOTAL",
                                                    16,
                                                    Colors.grey.shade600,
                                                    letterSpacing: 1.8,
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child:
                                                      AppTextNormal.labelBold(
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
                                                      child: AppTextNormal
                                                          .labelBold(
                                                        "Your balance is insufficient for this production.",
                                                        12,
                                                        Colors.red,
                                                        letterSpacing: 1.4,
                                                        maxLines: 3,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 2,
                                                      child: AppTextNormal
                                                          .labelBold(
                                                        "-\$${convertNumber(_c.products.fold(0, (total, product) => total + (product.qty * product.harga)) - _c.groupData.value.point)}",
                                                        22,
                                                        Colors.red,
                                                        textAlign:
                                                            TextAlign.end,
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
        ],
      ),
    );
  }
}
