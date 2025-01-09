import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:starter_pack_web/module/demography/controller/finance_controller.dart';
import 'package:starter_pack_web/utils/app_extension.dart';
import 'package:starter_pack_web/utils/app_images.dart';

import '../../../utils/app_color.dart';
import '../../../utils/app_decoration.dart';
import '../../../utils/app_sound.dart';
import '../../../utils/app_text.dart';

class FinancePage extends StatelessWidget {
  FinancePage({super.key});

  final _c = Get.find<FinanceController>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.8),
      body: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: size.height,
            child: Image.asset(
              bgSales,
              fit: BoxFit.fill,
            ),
          ),
          Container(
            color: Colors.white.withOpacity(0.6),
            child: Column(
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
                      Obx(() {
                        if (_c.isDone.value) {
                          return const SizedBox();
                        }
                        return ElevatedButton(
                          onPressed: _c.savePrice,
                          child: AppTextNormal.labelBold(
                            "SAVE",
                            16,
                            Colors.black,
                          ),
                        );
                      })
                    ],
                  ),
                ),
                18.ph,

                //batas
                Obx(() {
                  if (_c.isDone.value) {
                    return Container(
                      margin: const EdgeInsets.only(right: 25),
                      width: double.infinity,
                      height: size.height / 1.2,
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 28.0),
                          child: AppTextNormal.labelBold(
                            "You have assigned price to the product...",
                            18,
                            Colors.black,
                          ),
                        ),
                      ),
                    );
                  }

                  return Expanded(
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
                            children: List.generate(_c.productsOwn.length,
                                (subindex) {
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
                                            width: 90,
                                            height: 90,
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
                                          "Standard Price: \$${data.details[data.details.indexWhere((e) {
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
                                            double? number =
                                                double.tryParse(dig);
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
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
