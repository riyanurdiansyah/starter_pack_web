import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:starter_pack_web/module/demography/controller/finance_controller.dart';
import 'package:starter_pack_web/utils/app_extension.dart';

import '../../../utils/app_color.dart';
import '../../../utils/app_decoration.dart';
import '../../../utils/app_sound.dart';
import '../../../utils/app_text.dart';

class FinancePage extends StatelessWidget {
  FinancePage({super.key});

  final _c = Get.find<FinanceController>();

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
                      onPressed: _c.savePrice,
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

              //batas
              Obx(
                () => Expanded(
                  child: Form(
                    key: _c.formKey,
                    child: ListView(
                      children: List.generate(_c.demographys.length, (index) {
                        final data = _c.demographys[index];
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
                                        20.pw,
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                      child: Column(
                                    children: [
                                      AppTextNormal.labelBold(
                                        "Price: \$${data.details[data.details.indexWhere((e) {
                                          return e.productId == prod.id;
                                        })].minPrice} - \$${data.details[data.details.indexWhere((e) {
                                          return e.productId == prod.id;
                                        })].maxPrice}",
                                        16,
                                        Colors.grey.shade600,
                                      ),
                                    ],
                                  )),
                                  Expanded(
                                    flex: 2,
                                    child: TextFormField(
                                      controller: _c.accessList[index]
                                          ["controller"][subindex],
                                      textInputAction: TextInputAction.next,
                                      decoration: textFieldAuthDecoration(
                                        fontSize: 14,
                                        hintText: "",
                                        radius: 4,
                                      ),
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r'[0-9.]')),
                                      ],
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      onChanged: (value) {},
                                      validator: (val) {
                                        if (val != null && val.isNotEmpty) {
                                          var dig = val.replaceAll(",", ".");
                                          double? number = double.tryParse(dig);
                                          if (number == null ||
                                              number <
                                                  (data
                                                      .details[data.details
                                                          .indexWhere((e) {
                                                    return e.productId ==
                                                        prod.id;
                                                  })]
                                                      .minPrice) ||
                                              number >
                                                  (data
                                                      .details[data.details
                                                          .indexWhere((e) {
                                                    return e.productId ==
                                                        prod.id;
                                                  })]
                                                      .maxPrice)) {
                                            return "Price must be between R\$ ${data.details[data.details.indexWhere((e) {
                                              return e.productId == prod.id;
                                            })].minPrice} - R\$ ${data.details[data.details.indexWhere((e) {
                                              return e.productId == prod.id;
                                            })].maxPrice}";
                                          }
                                        } else {
                                          return "Price cant be empty";
                                        }
                                        return null;
                                      },
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
              ),
            ],
          ),
        ],
      ),
    );
  }
}
