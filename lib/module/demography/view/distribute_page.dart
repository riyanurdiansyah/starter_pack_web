import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:starter_pack_web/module/demography/controller/distribute_controller.dart';
import 'package:starter_pack_web/utils/app_extension.dart';

import '../../../utils/app_color.dart';
import '../../../utils/app_decoration.dart';
import '../../../utils/app_sound.dart';
import '../../../utils/app_text.dart';

class DistributePage extends StatelessWidget {
  DistributePage({super.key});

  final _c = Get.find<DistributeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
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
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () {
                        _c.saveDistribute();
                      },
                      child: AppTextNormal.labelBold(
                        "SAVE",
                        16,
                        Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              Obx(
                () => Expanded(
                  child: ListView(
                    children: List.generate(_c.demographys.length, (index) {
                      final data = _c.demographys[index];
                      return ExpansionTile(
                        title: AppTextNormal.labelBold(
                          data.name,
                          16,
                          Colors.black,
                        ),
                        children:
                            List.generate(_c.productsOwn.length, (subindex) {
                          final prod = _c.productsOwn[subindex];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      CachedNetworkImage(
                                        imageUrl: prod.image,
                                        width: 60,
                                        height: 60,
                                      ),
                                      18.pw,
                                      AppTextNormal.labelBold(
                                        "${prod.nama} - ${prod.tipe}",
                                        16,
                                        Colors.black,
                                      ),
                                      const Spacer(),
                                      AppTextNormal.labelBold(
                                        "Stok : ${prod.qty}",
                                        16,
                                        Colors.grey.shade600,
                                      ),
                                      20.pw,
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            AppTextNormal.labelBold(
                                              "Price R\$ ${data.details.firstWhereOrNull((e) => e.productId == prod.id)?.minPrice ?? 0} - ${data.details.firstWhereOrNull((e) => e.productId == prod.id)?.maxPrice ?? 0}",
                                              12.5,
                                              Colors.black,
                                              letterSpacing: 1.25,
                                            ),
                                            16.ph,
                                            TextFormField(
                                              controller: _c.accessList[index]
                                                      ["controller_price"]
                                                  [subindex],
                                              textInputAction:
                                                  TextInputAction.next,
                                              keyboardType:
                                                  TextInputType.number,
                                              decoration:
                                                  textFieldAuthDecoration(
                                                      fontSize: 14,
                                                      hintText: "",
                                                      radius: 4),
                                              onChanged: (value) {
                                                // Replace ',' with '.' and remove multiple ',' or '.'
                                                String updatedValue =
                                                    value.replaceAll(',', '.');
                                                if (RegExp(r'\..*\.')
                                                    .hasMatch(updatedValue)) {
                                                  updatedValue =
                                                      updatedValue.replaceFirst(
                                                          RegExp(
                                                              r'\.(?![^.]*$)'),
                                                          '');
                                                }
                                                if (updatedValue != value) {
                                                  _c.accessList[index][
                                                              "controller_price"]
                                                          [subindex] =
                                                      TextEditingValue(
                                                    text: updatedValue,
                                                    selection:
                                                        TextSelection.collapsed(
                                                            offset: updatedValue
                                                                .length),
                                                  );
                                                }
                                              },
                                              validator: (val) {
                                                if (val != null &&
                                                    val.isNotEmpty) {
                                                  var dig =
                                                      val.replaceAll(",", ".");
                                                  double? number =
                                                      double.tryParse(dig);
                                                  if (number == null ||
                                                      number <
                                                          (data.details
                                                                  .firstWhereOrNull((e) =>
                                                                      e.productId ==
                                                                      prod.id)
                                                                  ?.minPrice ??
                                                              0) ||
                                                      number >
                                                          (data.details
                                                                  .firstWhereOrNull((e) =>
                                                                      e.productId ==
                                                                      prod.id)
                                                                  ?.maxPrice ??
                                                              0)) {
                                                    return "Price must be between R\$ ${data.details.firstWhereOrNull((e) => e.productId == prod.id)?.minPrice ?? 0} - R\$ ${data.details.firstWhereOrNull((e) => e.productId == prod.id)?.maxPrice ?? 0}";
                                                  }
                                                }
                                                return null;
                                              },
                                              autovalidateMode: AutovalidateMode
                                                  .onUserInteraction,
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Expanded(
                                        child: SizedBox(),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      AppTextNormal.labelW600(
                                        "",
                                        12.5,
                                        Colors.black,
                                      ),
                                      16.ph,
                                      Row(
                                        children: [
                                          16.pw,
                                          OutlinedButton(
                                            onPressed: () {
                                              _c.decrementQuantity(
                                                  index, subindex);
                                            },
                                            style: OutlinedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                            ),
                                            child: AppTextNormal.labelBold(
                                              "-",
                                              16,
                                              Colors.grey.shade600,
                                            ),
                                          ),
                                          16.pw,
                                          Expanded(
                                            child: TextFormField(
                                              controller: _c.accessList[index]
                                                  ["controller"][subindex],
                                              textInputAction:
                                                  TextInputAction.next,
                                              decoration:
                                                  textFieldAuthDecoration(
                                                      fontSize: 14,
                                                      hintText: "",
                                                      radius: 4),
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .digitsOnly,
                                              ],
                                              readOnly: true,
                                              autovalidateMode: AutovalidateMode
                                                  .onUserInteraction,
                                              // onChanged: (value) {
                                              //   int? newQty = int.tryParse(value);
                                              //   if (newQty != null) {
                                              //     if (_c.productsOwn[subindex].qty <
                                              //         newQty) {
                                              //       final updatedText =
                                              //           value.substring(
                                              //               0, value.length - 1);
                                              //       (_c.accessList[index]
                                              //                       ["controller"]
                                              //                   [subindex]
                                              //               as TextEditingController)
                                              //           .text = updatedText;
                                              //       AppDialog.dialogSnackbar(
                                              //           "${_c.productsOwn[subindex].nama} is out of Stock");
                                              //     } else {
                                              //       _c.productsOwn[subindex] = _c
                                              //           .productsOwn[subindex]
                                              //           .copyWith(
                                              //         qty: _c.productsOwn[subindex]
                                              //                 .qty -
                                              //             newQty,
                                              //       );
                                              //     }
                                              //   } else {
                                              //     _c.productsOwn[subindex] = _c
                                              //         .productsOwn[subindex]
                                              //         .copyWith(
                                              //       qty: _c.productsOwn[subindex].qty,
                                              //     );
                                              //   }
                                              // },
                                            ),
                                          ),
                                          16.pw,
                                          OutlinedButton(
                                            onPressed: () {
                                              _c.incrementQuantity(
                                                  index, subindex);
                                            },
                                            style: OutlinedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                            ),
                                            child: AppTextNormal.labelBold(
                                              "+",
                                              16,
                                              Colors.grey.shade600,
                                            ),
                                          ),
                                          16.pw,
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      );
                    }),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
