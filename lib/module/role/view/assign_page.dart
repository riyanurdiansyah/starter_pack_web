import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:starter_pack_web/module/user/model/user_m.dart';
import 'package:starter_pack_web/utils/app_color.dart';
import 'package:starter_pack_web/utils/app_dialog.dart';
import 'package:starter_pack_web/utils/app_extension.dart';
import 'package:starter_pack_web/utils/app_text.dart';

import '../controller/assign_controller.dart';

class AssignPage extends StatelessWidget {
  AssignPage({super.key});

  final _c = Get.find<AssignController>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: colorElectricViolet.withOpacity(0.2),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 125, vertical: 14),
        width: double.infinity,
        color: colorElectricViolet.withOpacity(0.6),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              height: 60,
              color: colorPointRank,
              child: Row(
                children: [
                  AppTextNormal.labelBold(
                    'MY GOOD TEAM',
                    18,
                    Colors.white,
                  ),
                  const Spacer(),
                  Obx(
                    () => AppTextNormal.labelW600(
                      "Number of teams: ${_c.users.where((e) => e.roleId != 108).toList().length} / ${_c.users.length}",
                      16,
                      Colors.white,
                    ),
                  ),
                  16.pw,
                  ElevatedButton(
                    onPressed: () {
                      AppDialog.dialogDelete(
                        title: "Save Role",
                        subtitle: "Are you sure you want to save the role?",
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
                () => Container(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(10),
                    itemCount: _c.roles.length,
                    itemBuilder: (context, index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Role: ${_c.roles[index].role}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          GridView.builder(
                            shrinkWrap:
                                true, // Agar GridView dapat digunakan di dalam ListView
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3, // Jumlah kolom
                              crossAxisSpacing: 10, // Jarak antar kolom
                              mainAxisSpacing: 10, // Jarak antar baris
                              childAspectRatio: 3.2,
                            ),
                            itemCount: _c.roles[index].max,
                            itemBuilder: (context, subIndex) {
                              return ClipPath(
                                clipper: MyClipper2(),
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 10),
                                  color: Colors.white,
                                  width: double.infinity,
                                  height: 150,
                                  child: Row(
                                    children: [
                                      14.pw,
                                      ClipPath(
                                        clipper: MyClipper3(),
                                        child: _c.roles[index].image.isEmpty
                                            ? Container(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                color: Colors.grey.shade200,
                                                child: Icon(
                                                  Icons.person_rounded,
                                                  size: 80,
                                                  color: Colors.grey.shade600,
                                                ),
                                              )
                                            : Image.asset(
                                                "assets/images/${_c.roles[index].image}",
                                                width: 80,
                                                height: 80,
                                                fit: BoxFit.cover,
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
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10),
                                                height: 40,
                                                width: _c.roles[index].role
                                                            .length >
                                                        15
                                                    ? _c.roles[index].role
                                                            .length *
                                                        12
                                                    : _c.roles[index].role
                                                            .length *
                                                        20,
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      colorElectricViolet,
                                                      colorElectricViolet
                                                          .withOpacity(0.8),
                                                      colorElectricViolet
                                                          .withOpacity(0.6),
                                                      colorElectricViolet
                                                          .withOpacity(0.4),
                                                      Colors.white
                                                          .withOpacity(0.2)
                                                    ],
                                                    begin: Alignment.topLeft,
                                                    end: Alignment.bottomRight,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10),
                                                alignment: Alignment.center,
                                                height: 40,
                                                child: AppTextNormal.labelBold(
                                                  _c.roles[index].role,
                                                  16,
                                                  Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                          10.ph,
                                          Obx(
                                            () => SizedBox(
                                              width: 200,
                                              child: DropdownSearch<UserM>(
                                                popupProps: PopupProps.menu(
                                                  disabledItemFn: (itm) {
                                                    return _c.selectedUser.any(
                                                        (role) =>
                                                            role['assignedUser']
                                                                .contains(itm
                                                                    .username));
                                                  },
                                                  fit: FlexFit.loose,
                                                  showSearchBox: true,
                                                  searchFieldProps:
                                                      TextFieldProps(
                                                    decoration: InputDecoration(
                                                      // hintText: "Masukkan role",
                                                      // hintStyle: GoogleFonts.poppins(
                                                      //   fontSize: 14,
                                                      //   wordSpacing: 4,
                                                      // ),
                                                      contentPadding:
                                                          const EdgeInsets
                                                              .symmetric(
                                                              vertical: 0,
                                                              horizontal: 12),
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                                color:
                                                                    colorPrimaryDark),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Colors
                                                                .grey.shade300),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                items: (_, __) => _c.getUsers(),
                                                compareFn: (_, __) {
                                                  return false;
                                                },
                                                itemAsString: (UserM u) =>
                                                    u.nama,
                                                selectedItem:
                                                    _c.selectedItems[index],
                                                onChanged: (val) =>
                                                    _c.onSelectUser(
                                                        subIndex,
                                                        index,
                                                        _c.roles[index],
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
            ),

            // Expanded(
            //   child: Obx(
            //     () => GridView.builder(
            //       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            //         crossAxisCount: 3, // 2 item per baris
            //         crossAxisSpacing: 16.0, // Jarak horizontal antar item
            //         mainAxisSpacing: 16.0, // Jarak vertikal antar item
            //         childAspectRatio: 3, // Rasio lebar : tinggi item
            //       ),
            //       itemCount: _c.users.length,
            //       itemBuilder: (context, index) {
            //         return ClipPath(
            //           clipper: MyClipper2(),
            //           child: Container(
            //             margin: const EdgeInsets.symmetric(
            //                 horizontal: 16, vertical: 10),
            //             color: Colors.white,
            //             width: double.infinity,
            //             height: 150,
            //             child: Row(
            //               children: [
            //                 14.pw,
            //                 ClipPath(
            //                   clipper: MyClipper3(),
            //                   child: Container(
            //                     padding: const EdgeInsets.all(10),
            //                     color: Colors.grey.shade200,
            //                     child: Icon(
            //                       Icons.person_rounded,
            //                       size: 80,
            //                       color: Colors.grey.shade600,
            //                     ),
            //                   ),
            //                 ),
            //                 16.pw,
            //                 Column(
            //                   crossAxisAlignment: CrossAxisAlignment.start,
            //                   children: [
            //                     14.ph,
            //                     Stack(
            //                       children: [
            //                         Container(
            //                           padding: const EdgeInsets.symmetric(
            //                               horizontal: 10),
            //                           height: 40,
            //                           width: _c.users[index].nama.length < 15
            //                               ? _c.users[index].nama.length * 16
            //                               : _c.users[index].nama.length * 14,
            //                           decoration: BoxDecoration(
            //                             gradient: LinearGradient(
            //                               colors: [
            //                                 colorElectricViolet,
            //                                 colorElectricViolet
            //                                     .withOpacity(0.8),
            //                                 colorElectricViolet
            //                                     .withOpacity(0.6),
            //                                 colorElectricViolet
            //                                     .withOpacity(0.4),
            //                                 Colors.white.withOpacity(0.2)
            //                               ],
            //                               begin: Alignment.topLeft,
            //                               end: Alignment.bottomRight,
            //                             ),
            //                           ),
            //                         ),
            //                         Container(
            //                           padding: const EdgeInsets.symmetric(
            //                               horizontal: 10),
            //                           alignment: Alignment.center,
            //                           height: 40,
            //                           child: AppTextNormal.labelBold(
            //                             _c.users[index].nama,
            //                             16,
            //                             Colors.white,
            //                           ),
            //                         ),
            //                       ],
            //                     ),
            //                     10.ph,
            //                     Obx(
            //                       () => SizedBox(
            //                         width: 200,
            //                         child: DropdownSearch<RoleM>(
            //                           popupProps: PopupProps.menu(
            //                             disabledItemFn: (itm) {
            //                               if (itm.roleId == 100) {
            //                                 return _c.roleSelected
            //                                             .where(
            //                                                 (x) => x == itm.id)
            //                                             .toList()
            //                                             .length >=
            //                                         2 &&
            //                                     itm.role != "NONE";
            //                               }
            //                               return _c.roleSelected
            //                                           .where((x) => x == itm.id)
            //                                           .toList()
            //                                           .length >=
            //                                       3 &&
            //                                   itm.role != "NONE";
            //                             },
            //                             fit: FlexFit.loose,
            //                             showSearchBox: true,
            //                             searchFieldProps: TextFieldProps(
            //                               decoration: InputDecoration(
            //                                 // hintText: "Masukkan role",
            //                                 // hintStyle: GoogleFonts.poppins(
            //                                 //   fontSize: 14,
            //                                 //   wordSpacing: 4,
            //                                 // ),
            //                                 contentPadding:
            //                                     const EdgeInsets.symmetric(
            //                                         vertical: 0,
            //                                         horizontal: 12),
            //                                 border: OutlineInputBorder(
            //                                   borderRadius:
            //                                       BorderRadius.circular(8),
            //                                 ),
            //                                 focusedBorder: OutlineInputBorder(
            //                                   borderSide: const BorderSide(
            //                                       color: colorPrimaryDark),
            //                                   borderRadius:
            //                                       BorderRadius.circular(8),
            //                                 ),
            //                                 enabledBorder: OutlineInputBorder(
            //                                   borderSide: BorderSide(
            //                                       color: Colors.grey.shade300),
            //                                   borderRadius:
            //                                       BorderRadius.circular(8),
            //                                 ),
            //                               ),
            //                             ),
            //                           ),
            //                           items: (_, __) => _c.getRoles(),
            //                           compareFn: (_, __) {
            //                             return false;
            //                           },
            //                           itemAsString: (RoleM u) => u.role,
            //                           selectedItem: _c.selectedItems[index],
            //                           onChanged: (val) =>
            //                               _c.onSelectRole(index, val),
            //                         ),
            //                       ),
            //                     ),
            //                   ],
            //                 ),
            //               ],
            //             ),
            //           ),
            //         );
            //       },
            //     ),

            // SingleChildScrollView(
            //   child: Column(
            //     children: List.generate(
            //       _c.users.length,
            //       (index) {
            //         return ClipPath(
            //           clipper: MyClipper2(),
            //           child: Container(
            //             margin: const EdgeInsets.symmetric(
            //                 horizontal: 16, vertical: 10),
            //             color: Colors.white,
            //             width: double.infinity,
            //             height: 150,
            //             child: Row(
            //               children: [
            //                 14.pw,
            //                 ClipPath(
            //                   clipper: MyClipper3(),
            //                   child: Container(
            //                     width: 110,
            //                     height: 125,
            //                     color: Colors.grey.shade300,
            //                     child: Icon(
            //                       Icons.person_rounded,
            //                       size: 80,
            //                       color: Colors.grey.shade600,
            //                     ),
            //                   ),
            //                 ),
            //                 16.pw,
            //                 Column(
            //                   children: [
            //                     14.ph,
            //                     Stack(
            //                       children: [
            //                         Container(
            //                           padding: const EdgeInsets.symmetric(
            //                               horizontal: 10),
            //                           height: 40,
            //                           width: _c.users[index].nama.length <
            //                                   15
            //                               ? _c.users[index].nama.length * 16
            //                               : _c.users[index].nama.length *
            //                                   14,
            //                           decoration: BoxDecoration(
            //                             gradient: LinearGradient(
            //                               colors: [
            //                                 colorElectricViolet,
            //                                 colorElectricViolet
            //                                     .withOpacity(0.8),
            //                                 colorElectricViolet
            //                                     .withOpacity(0.6),
            //                                 colorElectricViolet
            //                                     .withOpacity(0.4),
            //                                 Colors.white.withOpacity(0.2)
            //                               ],
            //                               begin: Alignment.topLeft,
            //                               end: Alignment.bottomRight,
            //                             ),
            //                           ),
            //                         ),
            //                         Container(
            //                           padding: const EdgeInsets.symmetric(
            //                               horizontal: 10),
            //                           alignment: Alignment.center,
            //                           height: 40,
            //                           child: AppTextNormal.labelBold(
            //                             _c.users[index].nama,
            //                             16,
            //                             Colors.white,
            //                           ),
            //                         )
            //                       ],
            //                     )
            //                   ],
            //                 )
            //               ],
            //             ),
            //           ),
            //         );
            //       },
            //     ),
            //   ),
            // ),
            //   ),
            // ),
          ],
        ),
      ),
    );
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
