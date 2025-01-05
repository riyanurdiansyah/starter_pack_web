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
      backgroundColor: Colors.white.withOpacity(0.8),
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
              18.ph,
              // Obx(
              //   () => Row(
              //     children: List.generate(_c.demographys.length, (index) {
              //       return Expanded(
              //         child: Padding(
              //           padding: const EdgeInsets.symmetric(horizontal: 12),
              //           child: MouseRegion(
              //             cursor: SystemMouseCursors.click,
              //             onEnter: (_) {
              //               _c.listHovered[index] = true;
              //             },
              //             onExit: (_) {
              //               _c.listHovered[index] = false;
              //             },
              //             child: Obx(
              //               () => InkWell(
              //                 onTap: () {
              //                   _c.indexSelected.value = index;
              //                 },
              //                 child: Container(
              //                   height: 225,
              //                   decoration: BoxDecoration(
              //                     borderRadius: BorderRadius.circular(10),
              //                     color: Colors.grey.shade200,
              //                   ),
              //                   child: Stack(
              //                     children: [
              //                       ClipRRect(
              //                         borderRadius: BorderRadius.circular(10),
              //                         child: Stack(
              //                           fit: StackFit.expand,
              //                           children: [
              //                             AnimatedScale(
              //                               scale: _c.listHovered[index] ||
              //                                       _c.indexSelected.value ==
              //                                           index
              //                                   ? 1.05
              //                                   : 1.0, // Zoom pada gambar
              //                               duration: const Duration(
              //                                   milliseconds: 300),
              //                               child: ColorFiltered(
              //                                 colorFilter: ColorFilter.mode(
              //                                   _c.listHovered[index] ||
              //                                           _c.indexSelected
              //                                                   .value ==
              //                                               index
              //                                       ? Colors.transparent
              //                                       : Colors.grey,
              //                                   BlendMode
              //                                       .saturation, // Grayscale efek
              //                                 ),
              //                                 child: Image.asset(
              //                                   bg3Image,
              //                                   fit: BoxFit.cover,
              //                                 ),
              //                               ),
              //                             ),
              //                           ],
              //                         ),
              //                       ),
              //                       Align(
              //                         alignment: Alignment.bottomRight,
              //                         child: Container(
              //                           padding: const EdgeInsets.symmetric(
              //                               horizontal: 10, vertical: 14),
              //                           width:
              //                               _c.demographys[index].name.length <
              //                                       5
              //                                   ? _c.demographys[index].name
              //                                           .length *
              //                                       25
              //                                   : _c.demographys[index].name
              //                                           .length *
              //                                       15,
              //                           decoration: BoxDecoration(
              //                             color: !_c.listHovered[index] ||
              //                                     _c.indexSelected.value ==
              //                                         index
              //                                 ? Colors.grey.shade600
              //                                 : null,
              //                             borderRadius: const BorderRadius.only(
              //                               bottomRight: Radius.circular(10),
              //                               topLeft: Radius.circular(4),
              //                             ),
              //                             gradient: !_c.listHovered[index] &&
              //                                     _c.indexSelected.value !=
              //                                         index
              //                                 ? null
              //                                 : LinearGradient(
              //                                     colors: [
              //                                       colorElectricViolet,
              //                                       colorElectricViolet
              //                                           .withOpacity(0.8),
              //                                       colorElectricViolet
              //                                           .withOpacity(0.6),
              //                                       colorElectricViolet
              //                                           .withOpacity(0.4),
              //                                       Colors.white
              //                                           .withOpacity(0.2)
              //                                     ],
              //                                     begin: Alignment.topLeft,
              //                                     end: Alignment.bottomRight,
              //                                   ),
              //                           ),
              //                           child: AppTextNormal.labelBold(
              //                             _c.demographys[index].name,
              //                             16,
              //                             _c.listHovered[index] ||
              //                                     _c.indexSelected.value ==
              //                                         index
              //                                 ? Colors.white
              //                                 : Colors.black,
              //                             letterSpacing: 2,
              //                           ),
              //                         ),
              //                       ),
              //                     ],
              //                   ),
              //                 ),
              //               ),
              //             ),
              //           ),
              //         ),
              //       );
              //     }),
              //   ),
              // ),
              // Obx(() {
              //   if (_c.indexSelected.value == 99) {
              //     return const SizedBox();
              //   }
              //   return Expanded(
              //     child: Form(
              //       key: _c.formKey,
              //       child: Container(
              //         margin: const EdgeInsets.symmetric(
              //             horizontal: 16, vertical: 14),
              //         // color: Colors.grey.shade400,
              //         padding: const EdgeInsets.symmetric(horizontal: 12),
              //         child: Column(
              //           mainAxisAlignment: MainAxisAlignment.center,
              //           children: List.generate(
              //             _c.productsOwn.length,
              //             (index) {
              //               final data = _c.productsOwn[index];
              //               return Padding(
              //                 padding: const EdgeInsets.symmetric(vertical: 12),
              //                 child: Row(
              //                   children: [
              //                     Expanded(
              //                       child: Row(
              //                         children: [
              //                           Expanded(
              //                             child: CachedNetworkImage(
              //                               imageUrl: data.image,
              //                             ),
              //                           ),
              //                           Expanded(
              //                             flex: 2,
              //                             child: Column(
              //                               crossAxisAlignment:
              //                                   CrossAxisAlignment.start,
              //                               children: [
              //                                 AppTextNormal.labelBold(
              //                                   "${data.nama} - ${data.tipe}",
              //                                   18,
              //                                   Colors.black,
              //                                 ),
              //                               ],
              //                             ),
              //                           ),
              //                         ],
              //                       ),
              //                     ),
              //                     Expanded(
              //                       child: Column(
              //                         crossAxisAlignment:
              //                             CrossAxisAlignment.start,
              //                         children: [
              //                           AppTextNormal.labelBold(
              //                             "Price R\$ ${_c.demographys[_c.indexSelected.value].details.firstWhereOrNull((e) => e.productId == data.id)?.minPrice ?? 0} - ${_c.demographys[_c.indexSelected.value].details.firstWhereOrNull((e) => e.productId == data.id)?.maxPrice ?? 0}",
              //                             12.5,
              //                             Colors.black,
              //                             letterSpacing: 1.25,
              //                           ),
              //                           16.ph,
              //                           TextFormField(
              //                             controller: _c.accessList[
              //                                     _c.indexSelected.value]
              //                                 ["controller_price"][index],
              //                             textInputAction: TextInputAction.next,
              //                             keyboardType: TextInputType.number,
              //                             decoration: textFieldAuthDecoration(
              //                                 fontSize: 14,
              //                                 hintText: "",
              //                                 radius: 4),
              //                             onChanged: (value) {
              //                               // Replace ',' with '.' and remove multiple ',' or '.'
              //                               String updatedValue =
              //                                   value.replaceAll(',', '.');
              //                               if (RegExp(r'\..*\.')
              //                                   .hasMatch(updatedValue)) {
              //                                 updatedValue =
              //                                     updatedValue.replaceFirst(
              //                                         RegExp(r'\.(?![^.]*$)'),
              //                                         '');
              //                               }
              //                               if (updatedValue != value) {
              //                                 _c.accessList[_c
              //                                             .indexSelected.value]
              //                                         ["controller_price"]
              //                                     [index] = TextEditingValue(
              //                                   text: updatedValue,
              //                                   selection:
              //                                       TextSelection.collapsed(
              //                                           offset: updatedValue
              //                                               .length),
              //                                 );
              //                               }
              //                             },
              //                             validator: (val) {
              //                               if (val != null && val.isNotEmpty) {
              //                                 var dig =
              //                                     val.replaceAll(",", ".");
              //                                 double? number =
              //                                     double.tryParse(dig);
              //                                 if (number == null ||
              //                                     number <
              //                                         (_c
              //                                                 .demographys[_c
              //                                                     .indexSelected
              //                                                     .value]
              //                                                 .details
              //                                                 .firstWhereOrNull(
              //                                                     (e) =>
              //                                                         e.productId ==
              //                                                         data.id)
              //                                                 ?.minPrice ??
              //                                             0) ||
              //                                     number >
              //                                         (_c
              //                                                 .demographys[_c
              //                                                     .indexSelected
              //                                                     .value]
              //                                                 .details
              //                                                 .firstWhereOrNull(
              //                                                     (e) =>
              //                                                         e.productId ==
              //                                                         data.id)
              //                                                 ?.maxPrice ??
              //                                             0)) {
              //                                   return "Price must be between R\$ ${_c.demographys[_c.indexSelected.value].details.firstWhereOrNull((e) => e.productId == data.id)?.minPrice ?? 0} - R\$ ${_c.demographys[_c.indexSelected.value].details.firstWhereOrNull((e) => e.productId == data.id)?.maxPrice ?? 0}";
              //                                 }
              //                               }
              //                               return null;
              //                             },
              //                             autovalidateMode: AutovalidateMode
              //                                 .onUserInteraction,
              //                           ),
              //                         ],
              //                       ),
              //                     ),
              //                     Expanded(
              //                       child: Container(
              //                         margin: const EdgeInsets.only(
              //                           bottom: 16,
              //                         ),
              //                         height: 60,
              //                         color: Colors.amber,
              //                       ),
              //                     ),
              //                   ],
              //                 ),
              //               );
              //             },
              //           ),
              //         ),
              //       ),
              //     ),
              //   );
              // }),

              //batas
              Obx(() {
                if (_c.sellings.isEmpty) {
                  return const SizedBox();
                }
                return Expanded(
                  child: Form(
                    key: _c.formKey,
                    child: ListView(
                      children:
                          List.generate(_c.sellings[0].areas.length, (index) {
                        final data = _c.sellings[0].areas[index];
                        return ExpansionTile(
                          title: Row(
                            children: [
                              AppTextNormal.labelBold(
                                "${data.name} ",
                                16,
                                Colors.black,
                              ),
                              AppTextNormal.labelBold(
                                "  -  Cost: ${data.cost}/item",
                                12,
                                Colors.grey.shade600,
                              ),
                            ],
                          ),
                          children: List.generate(
                              _c.sellings[0].areas[index].products.length,
                              (subindex) {
                            final prod =
                                _c.sellings[0].areas[index].products[subindex];
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
                                          "Stock : ${_c.productsOwn.firstWhereOrNull((x) => x.id == prod.id)?.qty ?? 0}",
                                          16,
                                          Colors.grey.shade600,
                                        ),
                                        const Spacer(),
                                        AppTextNormal.labelBold(
                                          "Price : ${prod.priceDistribute}",
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
                                            decoration: textFieldAuthDecoration(
                                                fontSize: 14,
                                                hintText: "",
                                                radius: 4),
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly,
                                            ],
                                            // readOnly: true,
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
                                  ),
                                ],
                              ),
                            );
                          }),
                        );
                      }),
                    ),
                  ),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }
}
