import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:starter_pack_web/module/user/model/user_m.dart';
import 'package:starter_pack_web/utils/app_color.dart';
import 'package:starter_pack_web/utils/app_dialog.dart';
import 'package:starter_pack_web/utils/app_extension.dart';
import 'package:starter_pack_web/utils/app_images.dart';
import 'package:starter_pack_web/utils/app_text.dart';

import '../controller/assign_controller.dart';

class AssignPage extends StatelessWidget {
  AssignPage({super.key});

  final _c = Get.find<AssignController>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Obx(() {
      if (_c.isLoading.value) {
        return Container(
          color: Colors.black,
          width: double.infinity,
          height: size.height,
          child: Container(
            width: 250,
            height: 150,
            alignment: Alignment.center,
            child: Image.asset(
              loadingGif,
              fit: BoxFit.cover,
              filterQuality: FilterQuality.high,
              width: 250,
            ),
          ),
        );
      }
      return Scaffold(
        backgroundColor: Colors.grey.withOpacity(0.4),
        body: Stack(
          children: [
            SizedBox(
              width: double.infinity,
              height: size.height,
              child: Image.asset(
                bgRole,
                fit: BoxFit.fill,
              ),
            ),
            Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 125, vertical: 14),
                width: double.infinity,
                child: Obx(() {
                  if (_c.isDone.value) {
                    return Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 28.0),
                        child: AppTextNormal.labelBold(
                          "You have assigned a role to the user...",
                          18,
                          Colors.black,
                        ),
                      ),
                    );
                  }
                  return Container(
                    color: Colors.black.withOpacity(0.4),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          height: 60,
                          color: Colors.black,
                          child: Row(
                            children: [
                              AppTextNormal.labelBold(
                                'MY GOOD TEAM',
                                18,
                                Colors.white,
                              ),
                              const Spacer(),
                              // Obx(
                              //   () => AppTextNormal.labelW600(
                              //     "Number of teams: ${_c.users.where((e) => e.roleId != 108).toList().length} / ${_c.users.length}",
                              //     16,
                              //     Colors.white,
                              //   ),
                              // ),
                              // 16.pw,
                              ElevatedButton(
                                onPressed: () {
                                  AppDialog.dialogDelete(
                                    title: "Save Role",
                                    subtitle:
                                        "Are you sure you want to save the role?",
                                    confirmText: "Yes, save",
                                    callback: () {
                                      context.pop();
                                      _c.saveUser();
                                    },
                                  );
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
                        Expanded(
                          child: Obx(
                            () => ListView.builder(
                              padding: const EdgeInsets.all(10),
                              itemCount: _c.roles.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppTextNormal.labelBold(
                                      "ROLE : ${_c.roles[index].role}",
                                      18,
                                      Colors.white,
                                    ),

                                    const SizedBox(height: 10),
                                    GridView.builder(
                                      shrinkWrap:
                                          true, // Agar GridView dapat digunakan di dalam ListView
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3, // Jumlah kolom
                                        crossAxisSpacing:
                                            10, // Jarak antar kolom
                                        mainAxisSpacing:
                                            10, // Jarak antar baris
                                        childAspectRatio: 2,
                                      ),
                                      itemCount: _c.roles[index].max,
                                      itemBuilder: (context, subIndex) {
                                        return ClipPath(
                                          clipper: MyClipper2(),
                                          child: Container(
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 10),
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              color:
                                                  Colors.white.withOpacity(0.4),
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            height: 150,
                                            child: Row(
                                              children: [
                                                14.pw,
                                                _c.roles[index].image.isEmpty
                                                    ? Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10),
                                                        color: Colors
                                                            .grey.shade200,
                                                        child: Icon(
                                                          Icons.person_rounded,
                                                          size: 80,
                                                          color: Colors
                                                              .grey.shade600,
                                                        ),
                                                      )
                                                    : SizedBox(
                                                        width: 80,
                                                        height: 80,
                                                        child: DecoratedBox(
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10), // Opsional, membuat sudut melengkung
                                                          ),
                                                          child: Image.asset(
                                                            "assets/images/${_c.roles[index].image}",
                                                            fit: BoxFit.cover,
                                                            width: 125,
                                                            height: 125,
                                                          ),
                                                        ),
                                                      ),
                                                16.pw,
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    14.ph,
                                                    Stack(
                                                      children: [
                                                        FittedBox(
                                                          child: Container(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        10),
                                                            height: 40,
                                                            width: _c
                                                                        .roles[
                                                                            index]
                                                                        .role
                                                                        .length >
                                                                    15
                                                                ? _c
                                                                        .roles[
                                                                            index]
                                                                        .role
                                                                        .length *
                                                                    6
                                                                : _c.roles[index].role.length >
                                                                        8
                                                                    ? _c
                                                                            .roles[
                                                                                index]
                                                                            .role
                                                                            .length *
                                                                        8
                                                                    : _c.roles[index].role
                                                                            .length *
                                                                        18,
                                                            decoration:
                                                                BoxDecoration(
                                                              gradient:
                                                                  LinearGradient(
                                                                colors: [
                                                                  colorElectricViolet,
                                                                  colorElectricViolet
                                                                      .withOpacity(
                                                                          0.8),
                                                                  colorElectricViolet
                                                                      .withOpacity(
                                                                          0.6),
                                                                  colorElectricViolet
                                                                      .withOpacity(
                                                                          0.4),
                                                                  Colors.white
                                                                      .withOpacity(
                                                                          0.2)
                                                                ],
                                                                begin: Alignment
                                                                    .topLeft,
                                                                end: Alignment
                                                                    .bottomRight,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      10),
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          height: 40,
                                                          width: 150,
                                                          child: FittedBox(
                                                            child: AppTextNormal
                                                                .labelBold(
                                                              _c.roles[index]
                                                                  .role,
                                                              16,
                                                              Colors.white,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    10.ph,
                                                    Obx(
                                                      () => SizedBox(
                                                        width: 130,
                                                        child: DropdownSearch<
                                                            UserM>(
                                                          decoratorProps:
                                                              DropDownDecoratorProps(
                                                            decoration:
                                                                InputDecoration(
                                                              fillColor: Colors
                                                                  .white
                                                                  .withOpacity(
                                                                      0.4),
                                                              filled: true,
                                                              // hintText: "Masukkan role",
                                                              // hintStyle: GoogleFonts.poppins(
                                                              //   fontSize: 14,
                                                              //   wordSpacing: 4,
                                                              // ),
                                                              contentPadding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      vertical:
                                                                          0,
                                                                      horizontal:
                                                                          12),
                                                              border:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8),
                                                              ),
                                                              focusedBorder:
                                                                  OutlineInputBorder(
                                                                borderSide:
                                                                    const BorderSide(
                                                                        color:
                                                                            colorPrimaryDark),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8),
                                                              ),
                                                              enabledBorder:
                                                                  OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: Colors
                                                                        .grey
                                                                        .shade300),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8),
                                                              ),
                                                            ),
                                                          ),
                                                          popupProps:
                                                              PopupProps.menu(
                                                            disabledItemFn:
                                                                (itm) {
                                                              return _c
                                                                  .selectedUser
                                                                  .any((role) => role[
                                                                          'assignedUser']
                                                                      .contains(
                                                                          itm.username));
                                                            },
                                                            fit: FlexFit.loose,
                                                            showSearchBox: true,
                                                            searchFieldProps:
                                                                TextFieldProps(
                                                              decoration:
                                                                  InputDecoration(
                                                                contentPadding:
                                                                    const EdgeInsets
                                                                        .symmetric(
                                                                        vertical:
                                                                            0,
                                                                        horizontal:
                                                                            12),
                                                                border:
                                                                    OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8),
                                                                ),
                                                                focusedBorder:
                                                                    OutlineInputBorder(
                                                                  borderSide:
                                                                      const BorderSide(
                                                                          color:
                                                                              colorPrimaryDark),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8),
                                                                ),
                                                                enabledBorder:
                                                                    OutlineInputBorder(
                                                                  borderSide: BorderSide(
                                                                      color: Colors
                                                                          .grey
                                                                          .shade300),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          items: (_, __) =>
                                                              _c.getUsers(),
                                                          compareFn: (_, __) {
                                                            return false;
                                                          },
                                                          itemAsString:
                                                              (UserM u) =>
                                                                  u.nama,
                                                          selectedItem:
                                                              _c.selectedItems[
                                                                  index],
                                                          onChanged: (val) =>
                                                              _c.onSelectUser(
                                                                  subIndex,
                                                                  index,
                                                                  _c.roles[
                                                                      index],
                                                                  val),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    const Divider(), // Garis pemisah antar role
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                })),
          ],
        ),
      );
    });
  }
}

class MyClipper2 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double cutSizeShort = 20.0; // Ukuran potongan diagonal standar
    double cutSizeLong =
        45.0; // Ukuran potongan diagonal untuk kiri atas dan kiri bawah

    Path path = Path();

    // Mulai dari titik di sebelah kiri atas setelah potongan diagonal (lebih panjang)
    path.moveTo(size.width, 0);

    // Garis lurus ke kanan atas dengan potongan sudut kanan atas
    path.lineTo(size.width, 0);
    path.lineTo(size.width, cutSizeShort);

    // Garis lurus ke bawah kanan dengan potongan sudut kanan bawah
    path.lineTo(size.width, size.height - cutSizeLong);
    path.lineTo(size.width - cutSizeLong, size.height);

    // Garis lurus ke kiri bawah dengan potongan sudut kiri bawah (lebih panjang)
    path.lineTo(0, size.height);
    path.lineTo(0, size.height - cutSizeShort);

    // Garis lurus ke kiri atas dengan potongan sudut kiri atas (lebih panjang)
    path.lineTo(0, 0);
    path.lineTo(cutSizeLong, 0);

    path.close(); // Menutup path
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class MyClipper3 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double cutSizeShort = 20.0; // Ukuran potongan diagonal standar

    Path path = Path();

    // Mulai dari titik di sebelah kiri atas setelah potongan diagonal (lebih panjang)
    path.moveTo(size.width, 0);

    // Garis lurus ke kanan atas dengan potongan sudut kanan atas
    path.lineTo(size.width, 0);
    path.lineTo(size.width, cutSizeShort);

    // Garis lurus ke bawah kanan dengan potongan sudut kanan bawah
    path.lineTo(size.width, size.height - cutSizeShort);
    path.lineTo(size.width - cutSizeShort, size.height);

    // Garis lurus ke kiri bawah dengan potongan sudut kiri bawah (lebih panjang)
    path.lineTo(0, size.height);
    path.lineTo(0, size.height - cutSizeShort);

    // Garis lurus ke kiri atas dengan potongan sudut kiri atas (lebih panjang)
    path.lineTo(0, 0);
    path.lineTo(cutSizeShort, 0);

    path.close(); // Menutup path
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
