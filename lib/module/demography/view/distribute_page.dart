import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:starter_pack_web/module/demography/controller/distribute_controller.dart';
import 'package:starter_pack_web/utils/app_extension.dart';
import 'package:starter_pack_web/utils/app_images.dart';

import '../../../utils/app_color.dart';
import '../../../utils/app_dialog.dart';
import '../../../utils/app_sound.dart';
import '../../../utils/app_text.dart';

class DistributePage extends StatelessWidget {
  DistributePage({super.key});

  final _c = Get.find<DistributeController>();

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
            color: Colors.black.withOpacity(0.6),
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
                        return Padding(
                          padding: const EdgeInsets.only(right: 45, top: 10),
                          child: ElevatedButton(
                            onPressed: () {
                              AppDialog.dialogDetailDistribute();
                              // AppDialog.dialogDelete(
                              //   title: "Update Selling Price",
                              //   subtitle:
                              //       "Are you sure you want to submit selling price? Once submitted the data can no longer be modified!",
                              //   confirmText: "Yes, update the price",
                              //   cancelText: "No, cancel",
                              //   callback: () => _c.saveDistribute(),
                              // );
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                padding: const EdgeInsets.all(20)),
                            child: AppTextNormal.labelBold(
                              "SUBMIT",
                              16,
                              Colors.black,
                            ),
                          ),
                        );
                      }),
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
                  if (_c.isLoading.value) {
                    return const SizedBox();
                  }
                  if (_c.sellings.isEmpty) {
                    return SizedBox(
                      width: double.infinity,
                      height: size.height / 1.6,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AppTextNormal.labelBold(
                            "Your team member in the Sales role has not yet\ndecided on the price for the product.",
                            20,
                            Colors.white,
                            maxLines: 3,
                            textAlign: TextAlign.center,
                            height: 1.4,
                            letterSpacing: 2.5,
                            shadows: [
                              const Shadow(
                                offset:
                                    Offset(-1.5, -1.5), // Bayangan ke kiri atas
                                color: Colors.black,
                                blurRadius: 1.0,
                              ),
                              const Shadow(
                                offset:
                                    Offset(1.5, -1.5), // Bayangan ke kanan atas
                                color: Colors.black,
                                blurRadius: 1.0,
                              ),
                              const Shadow(
                                offset:
                                    Offset(1.5, 1.5), // Bayangan ke kanan bawah
                                color: Colors.black,
                                blurRadius: 1.0,
                              ),
                              const Shadow(
                                offset:
                                    Offset(-1.5, 1.5), // Bayangan ke kiri bawah
                                color: Colors.black,
                                blurRadius: 1.0,
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }
                  return Expanded(
                    child: Form(
                      key: _c.formKey,
                      child: Column(
                        children: [
                          AppTextNormal.labelBold(
                            "DISTRIBUTION",
                            35,
                            Colors.white,
                            letterSpacing: 2,
                          ),
                          50.ph,
                          Expanded(
                            child: ListView(
                              shrinkWrap: true,
                              children: List.generate(
                                  _c.sellings[0].areas.length, (index) {
                                final data = _c.sellings[0].areas[index];

                                return ExpansionTile(
                                  tilePadding: EdgeInsets.zero,
                                  title: Stack(
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 24),
                                        margin: const EdgeInsets.only(
                                            right: 20, left: 50),
                                        height: 140,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: _c.listHoveredProduct[index]
                                                ? [
                                                    colorPointRank,
                                                    colorPointRank
                                                  ]
                                                : index.isOdd
                                                    ? [
                                                        colorPrimaryDark,
                                                        colorElectricViolet
                                                      ]
                                                    : [
                                                        colorElectricViolet,
                                                        colorPrimaryDark
                                                      ],
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                AppTextNormal.labelBold(
                                                  data.name,
                                                  35,
                                                  Colors.white,
                                                ),
                                                10.ph,
                                                AppTextNormal.labelBold(
                                                  "\$ ${data.cost}/item",
                                                  14,
                                                  Colors.white,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Positioned(
                                        right: index.isEven ? null : 0,
                                        left: index.isOdd ? null : 0,
                                        top: 0,
                                        bottom: 0,
                                        child: SizedBox(
                                          // color: Colors.white,
                                          width: 240,
                                          height: 350,
                                          child: AspectRatio(
                                            aspectRatio: 16 / 9,
                                            child: CachedNetworkImage(
                                              imageUrl: _c.imageDemos[index],
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  trailing: const SizedBox
                                      .shrink(), // Menghilangkan ikon ekspansi
                                  children: List.generate(
                                    data.products.length,
                                    (i) {
                                      final prod = data.products[i];
                                      return Stack(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 24),
                                            margin: const EdgeInsets.only(
                                                right: 60,
                                                top: 10,
                                                bottom: 10,
                                                left: 125),
                                            height: 140,
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade400,
                                              borderRadius:
                                                  const BorderRadius.only(
                                                topLeft: Radius.circular(12),
                                                bottomLeft: Radius.circular(12),
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                60.pw,
                                                Expanded(
                                                  child:
                                                      AppTextNormal.labelBold(
                                                    "${prod.nama} ${prod.tipe}",
                                                    20,
                                                    Colors.white,
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      AppTextNormal.labelW600(
                                                        "Min : 0",
                                                        12.5,
                                                        Colors.black,
                                                      ),
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          SizedBox(
                                                            width: 100,
                                                            height: 45,
                                                            child: TextField(
                                                              inputFormatters: [
                                                                FilteringTextInputFormatter
                                                                    .digitsOnly, // Hanya menerima angka
                                                              ],
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              controller:
                                                                  _c.listDistribute[
                                                                          index]
                                                                      [
                                                                      "controller"][i],
                                                              keyboardType:
                                                                  TextInputType
                                                                      .number,
                                                              decoration:
                                                                  const InputDecoration(
                                                                disabledBorder:
                                                                    OutlineInputBorder(
                                                                        borderSide:
                                                                            BorderSide(
                                                                  color:
                                                                      colorElectricViolet,
                                                                  width: 1.2,
                                                                )),
                                                                enabledBorder:
                                                                    OutlineInputBorder(
                                                                        borderSide:
                                                                            BorderSide(
                                                                  color:
                                                                      colorElectricViolet,
                                                                  width: 1.2,
                                                                )),
                                                                focusedErrorBorder:
                                                                    OutlineInputBorder(
                                                                        borderSide:
                                                                            BorderSide(
                                                                  color:
                                                                      colorElectricViolet,
                                                                  width: 1.2,
                                                                )),
                                                                focusedBorder:
                                                                    OutlineInputBorder(
                                                                        borderSide:
                                                                            BorderSide(
                                                                  color:
                                                                      colorElectricViolet,
                                                                  width: 1.2,
                                                                )),
                                                                border:
                                                                    OutlineInputBorder(
                                                                        borderSide:
                                                                            BorderSide(
                                                                  color:
                                                                      colorElectricViolet,
                                                                  width: 1.2,
                                                                )),
                                                              ),
                                                              onChanged: (String
                                                                  value) {
                                                                if (value
                                                                    .isEmpty) {
                                                                  _c.listDistribute[
                                                                          index]
                                                                      [
                                                                      "products"][i] = 0;
                                                                } else {
                                                                  final int
                                                                      typedValue =
                                                                      int.parse(
                                                                          value);
                                                                  if (typedValue <=
                                                                      prod.qty) {
                                                                    // Jika valid, perbarui nilai
                                                                    _c.listDistribute[index]["products"]
                                                                            [
                                                                            i] =
                                                                        typedValue;
                                                                  } else {
                                                                    // Jika melebihi batas, tetap gunakan nilai sebelumnya
                                                                    (_c.listDistribute[index]["controller"][i]
                                                                            as TextEditingController)
                                                                        .text = _c.listDistribute[
                                                                            index]
                                                                            [
                                                                            "products"]
                                                                            [i]
                                                                        .toString();
                                                                    (_c.listDistribute[index]["controller"][i]
                                                                                as TextEditingController)
                                                                            .selection =
                                                                        TextSelection
                                                                            .fromPosition(
                                                                      TextPosition(
                                                                          offset: (_c.listDistribute[index]["controller"][i] as TextEditingController)
                                                                              .text
                                                                              .length),
                                                                    );
                                                                  }
                                                                }
                                                                _c.listDistribute[
                                                                            index]
                                                                        ["cost"]
                                                                    [
                                                                    i] = double.parse((data
                                                                            .cost *
                                                                        int.parse(
                                                                            value))
                                                                    .toStringAsFixed(
                                                                        2));
                                                                _c.listDistribute[
                                                                        index]
                                                                    ["total"] = double.parse((int.parse((_c.listDistribute[index]["controller"][i]
                                                                                as TextEditingController)
                                                                            .text) *
                                                                        data
                                                                            .cost)
                                                                    .toStringAsFixed(
                                                                        2));
                                                                _c.listDistribute
                                                                    .refresh();
                                                              },
                                                            ),
                                                          ),
                                                          Slider(
                                                            activeColor:
                                                                colorElectricViolet,
                                                            value: _c.listDistribute[
                                                                    index]
                                                                ["products"][i],
                                                            max: prod.qty
                                                                .roundToDouble(),
                                                            min: 0,
                                                            onChanged:
                                                                (double value) {
                                                              _c.listDistribute[
                                                                          index]
                                                                      [
                                                                      "products"][i] =
                                                                  value.round();
                                                              (_c.listDistribute[index]["controller"]
                                                                              [
                                                                              i]
                                                                          as TextEditingController)
                                                                      .text =
                                                                  value
                                                                      .round()
                                                                      .toString();

                                                              _c.listDistribute[
                                                                          index]
                                                                      ["cost"][
                                                                  i] = double.parse((data
                                                                          .cost *
                                                                      value
                                                                          .round())
                                                                  .toStringAsFixed(
                                                                      2));

                                                              _c.listDistribute[
                                                                      index][
                                                                  "total"] = double.parse((int.parse((_c.listDistribute[index]["controller"][i]
                                                                              as TextEditingController)
                                                                          .text) *
                                                                      data.cost)
                                                                  .toStringAsFixed(
                                                                      2));
                                                              _c.listDistribute
                                                                  .refresh();
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                      AppTextNormal.labelW600(
                                                        "Min : ${prod.qty}",
                                                        12.5,
                                                        Colors.black,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                28.pw,
                                                Expanded(
                                                  child:
                                                      AppTextNormal.labelBold(
                                                    "Distribution Cost : R\$ ${_c.listDistribute[index]["cost"][i]}",
                                                    18,
                                                    colorPrimaryDark,
                                                    textAlign: TextAlign.end,
                                                  ),
                                                ),
                                                80.pw,
                                              ],
                                            ),
                                          ),
                                          Positioned(
                                            left: 50,
                                            top: 0,
                                            bottom: 0,
                                            child: Container(
                                              padding: const EdgeInsets.all(8),
                                              width: 125,
                                              height: 125,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.white,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black.withOpacity(
                                                        0.25), // Warna bayangan dengan transparansi
                                                    spreadRadius:
                                                        12, // Penyebaran bayangan
                                                    blurRadius:
                                                        8, // Kekaburan bayangan
                                                    offset: const Offset(2,
                                                        4), // Posisi bayangan (x, y)
                                                  ),
                                                ],
                                              ),
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(20),
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.grey.shade600,
                                                ),
                                                child: CachedNetworkImage(
                                                  imageUrl: prod.image,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                );

                                //BATAS
                                // return ExpansionTile(
                                //   title: Row(
                                //     children: [
                                //       AppTextNormal.labelBold(
                                //         "${data.name} ",
                                //         16,
                                //         Colors.white,
                                //       ),
                                //       AppTextNormal.labelBold(
                                //         "  -  Cost: ${data.cost}/item",
                                //         12,
                                //         Colors.grey.shade300,
                                //       ),
                                //     ],
                                //   ),
                                //   children: List.generate(
                                //       _c.sellings[0].areas[index].products.length,
                                //       (subindex) {
                                //     final prod = _c
                                //         .sellings[0].areas[index].products[subindex];
                                //     return Padding(
                                //       padding: const EdgeInsets.only(bottom: 16.0),
                                //       child: Row(
                                //         mainAxisAlignment: MainAxisAlignment.center,
                                //         children: [
                                //           Expanded(
                                //             child: Row(
                                //               children: [
                                //                 Expanded(
                                //                   flex: 2,
                                //                   child: Row(
                                //                     children: [
                                //                       CachedNetworkImage(
                                //                         imageUrl: prod.image,
                                //                         width: 100,
                                //                         height: 100,
                                //                       ),
                                //                       18.pw,
                                //                       AppTextNormal.labelBold(
                                //                         "${prod.nama} - ${prod.tipe}",
                                //                         16,
                                //                         Colors.white,
                                //                       ),
                                //                     ],
                                //                   ),
                                //                 ),
                                //                 Expanded(
                                //                   child: AppTextNormal.labelBold(
                                //                     "Stock : ${_c.productsOwn.firstWhereOrNull((x) => x.id == prod.id)?.qty ?? 0}",
                                //                     16,
                                //                     Colors.white,
                                //                   ),
                                //                 ),
                                //                 Expanded(
                                //                   child: AppTextNormal.labelBold(
                                //                     "Price : ${prod.priceDistribute}",
                                //                     16,
                                //                     Colors.white,
                                //                   ),
                                //                 ),
                                //                 20.pw,
                                //               ],
                                //             ),
                                //           ),
                                //           Expanded(
                                //             child: Row(
                                //               children: [
                                //                 16.pw,
                                //                 OutlinedButton(
                                //                   onPressed: () {
                                //                     _c.decrementQuantity(
                                //                         index, subindex);
                                //                   },
                                //                   style: OutlinedButton.styleFrom(
                                //                     shape: RoundedRectangleBorder(
                                //                       borderRadius:
                                //                           BorderRadius.circular(4),
                                //                     ),
                                //                   ),
                                //                   child: AppTextNormal.labelBold(
                                //                     "-",
                                //                     16,
                                //                     Colors.white,
                                //                   ),
                                //                 ),
                                //                 16.pw,
                                //                 Expanded(
                                //                   child: TextFormField(
                                //                     controller: _c.accessList[index]
                                //                         ["controller"][subindex],
                                //                     textInputAction:
                                //                         TextInputAction.next,
                                //                     decoration:
                                //                         textFieldAuthDecoration(
                                //                             fontSize: 14,
                                //                             hintText: "",
                                //                             radius: 4),
                                //                     inputFormatters: [
                                //                       FilteringTextInputFormatter
                                //                           .digitsOnly,
                                //                     ],
                                //                     // readOnly: true,
                                //                     autovalidateMode: AutovalidateMode
                                //                         .onUserInteraction,
                                //                     // onChanged: (value) {
                                //                     //   int? newQty = int.tryParse(value);
                                //                     //   if (newQty != null) {
                                //                     //     if (_c.productsOwn[subindex].qty <
                                //                     //         newQty) {
                                //                     //       final updatedText =
                                //                     //           value.substring(
                                //                     //               0, value.length - 1);
                                //                     //       (_c.accessList[index]
                                //                     //                       ["controller"]
                                //                     //                   [subindex]
                                //                     //               as TextEditingController)
                                //                     //           .text = updatedText;
                                //                     //       AppDialog.dialogSnackbar(
                                //                     //           "${_c.productsOwn[subindex].nama} is out of Stock");
                                //                     //     } else {
                                //                     //       _c.productsOwn[subindex] = _c
                                //                     //           .productsOwn[subindex]
                                //                     //           .copyWith(
                                //                     //         qty: _c.productsOwn[subindex]
                                //                     //                 .qty -
                                //                     //             newQty,
                                //                     //       );
                                //                     //     }
                                //                     //   } else {
                                //                     //     _c.productsOwn[subindex] = _c
                                //                     //         .productsOwn[subindex]
                                //                     //         .copyWith(
                                //                     //       qty: _c.productsOwn[subindex].qty,
                                //                     //     );
                                //                     //   }
                                //                     // },
                                //                   ),
                                //                 ),
                                //                 16.pw,
                                //                 OutlinedButton(
                                //                   onPressed: () {
                                //                     _c.incrementQuantity(
                                //                         index, subindex);
                                //                   },
                                //                   style: OutlinedButton.styleFrom(
                                //                     shape: RoundedRectangleBorder(
                                //                       borderRadius:
                                //                           BorderRadius.circular(4),
                                //                     ),
                                //                   ),
                                //                   child: AppTextNormal.labelBold(
                                //                     "+",
                                //                     16,
                                //                     Colors.white,
                                //                   ),
                                //                 ),
                                //                 16.pw,
                                //               ],
                                //             ),
                                //           ),
                                //         ],
                                //       ),
                                //     );
                                //   }),
                                // );
                              }),
                            ),
                          ),
                        ],
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
