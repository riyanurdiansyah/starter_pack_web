import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:starter_pack_web/module/login/controller/login_controller.dart';
import 'package:starter_pack_web/module/user/controller/user_controller.dart';
import 'package:starter_pack_web/module/user/model/user_m.dart';
import 'package:starter_pack_web/utils/app_color.dart';
import 'package:starter_pack_web/utils/app_extension.dart';

import '../middleware/app_route.dart';
import '../module/user/model/group_m.dart';
import '../module/user/model/role_m.dart';
import 'app_decoration.dart';
import 'app_text.dart';
import 'app_validator.dart';

class AppDialog {
  static dialogSignin() {
    final size = MediaQuery.sizeOf(navigatorKey.currentContext!);
    return showDialog(
      context: navigatorKey.currentContext!,
      barrierColor: Colors.grey.withOpacity(0.4),
      builder: (context) {
        return _AppDialogContent(size: size);
      },
    );
  }

  static dialogUser({
    UserM? oldUser,
  }) {
    final uC = Get.find<UserController>();
    final size = MediaQuery.of(navigatorKey.currentContext!).size;
    // if (oldUser != null) {
    //   uC.setProductsToVariable(oldUser);
    // }
    return showDialog(
      context: navigatorKey.currentContext!,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        title: AppTextNormal.labelBold(
          "Add User",
          16,
          Colors.black,
        ),
        content: SizedBox(
          width: size.width / 2.5,
          child: Form(
            key: uC.formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextNormal.labelW700(
                  "Nama",
                  14,
                  Colors.black,
                ),
                const SizedBox(
                  height: 12,
                ),
                TextFormField(
                  controller: uC.tcNama,
                  validator: (val) => AppValidator.requiredField(val!),
                  style: GoogleFonts.poppins(
                    height: 1.4,
                  ),
                  decoration: InputDecoration(
                    hintStyle: GoogleFonts.poppins(
                      fontSize: 14,
                      wordSpacing: 4,
                    ),
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade500),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                AppTextNormal.labelW700(
                  "Username",
                  14,
                  Colors.black,
                ),
                const SizedBox(
                  height: 12,
                ),
                TextFormField(
                  controller: uC.tcUsername,
                  validator: (val) => AppValidator.requiredField(val!),
                  style: GoogleFonts.poppins(
                    height: 1.4,
                  ),
                  decoration: InputDecoration(
                    hintStyle: GoogleFonts.poppins(
                      fontSize: 14,
                      wordSpacing: 4,
                    ),
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade500),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                AppTextNormal.labelW700(
                  "Role",
                  14,
                  Colors.black,
                ),
                const SizedBox(
                  height: 12,
                ),
                DropdownSearch<RoleM>(
                  popupProps: PopupProps.menu(
                    fit: FlexFit.loose,
                    showSearchBox: true,
                    searchFieldProps: TextFieldProps(
                      decoration: InputDecoration(
                        hintText: "Masukkan role",
                        hintStyle: GoogleFonts.poppins(
                          fontSize: 14,
                          wordSpacing: 4,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: colorPrimaryDark),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  items: (_, __) => uC.getRoles(),
                  compareFn: (_, __) {
                    return false;
                  },
                  // asyncItems: (String filter) =>
                  //     iC.customerRepository.getCustomers(),
                  itemAsString: (RoleM u) => u.role,
                  selectedItem: uC.selectedRole.value,
                  onChanged: uC.onSelectRole,
                ),
                const SizedBox(
                  height: 16,
                ),
                AppTextNormal.labelW700(
                  "Kelompok",
                  14,
                  Colors.black,
                ),
                const SizedBox(
                  height: 12,
                ),
                DropdownSearch<GroupM>(
                  popupProps: PopupProps.menu(
                    fit: FlexFit.loose,
                    showSearchBox: true,
                    searchFieldProps: TextFieldProps(
                      decoration: InputDecoration(
                        hintText: "Masukkan nama kelompok",
                        hintStyle: GoogleFonts.poppins(
                          fontSize: 14,
                          wordSpacing: 4,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: colorPrimaryDark),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  items: (_, __) => uC.getGroups(),
                  compareFn: (_, __) {
                    return false;
                  },
                  // asyncItems: (String filter) =>
                  //     iC.customerRepository.getCustomers(),
                  itemAsString: (GroupM u) => u.name,
                  selectedItem: uC.selectedGroup.value,
                  onChanged: uC.onSelectGroup,
                ),
                const SizedBox(
                  height: 35,
                ),
                SizedBox(
                  width: double.infinity,
                  child: Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 40,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey.shade400,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                )),
                            onPressed: () => context.pop(),
                            child: AppTextNormal.labelBold(
                              "BATAL",
                              14,
                              Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 18,
                      ),
                      Expanded(
                        child: SizedBox(
                          height: 40,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colorPrimaryDark,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            onPressed: () {
                              uC.addNewUser();
                            },
                            child: AppTextNormal.labelBold(
                              "SIMPAN",
                              14,
                              Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AppDialogContent extends StatefulWidget {
  final Size size;

  const _AppDialogContent({super.key, required this.size});

  @override
  __AppDialogContentState createState() => __AppDialogContentState();
}

class __AppDialogContentState extends State<_AppDialogContent>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  final _c = Get.find<LoginController>();

  @override
  void initState() {
    super.initState();

    // Inisialisasi AnimationController dengan TickerProvider
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    // Menambahkan animasi dengan efek zoom
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    // Memulai animasi saat dialog muncul
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.size;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: size.width / 6),
      child: ScaleTransition(
        scale: _animation,
        child: Container(
          width: size.width / 3,
          height: size.height / 1.5,
          // color: Colors.white.withOpacity(0.6),
          padding: const EdgeInsets.symmetric(vertical: 35, horizontal: 50),
          child: Form(
            key: _c.formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                125.ph,
                TextFormField(
                  controller: _c.tcUsername,
                  textInputAction: TextInputAction.next,
                  decoration: textFieldAuthDecoration(
                      fontSize: 14, hintText: "username", radius: 4),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (val) => AppValidator.requiredField(val!,
                      errorMsg: "Username tidak boleh kosong"),
                ),
                const SizedBox(
                  height: 25,
                ),
                TextFormField(
                  obscureText: true,
                  controller: _c.tcPassword,
                  textInputAction: TextInputAction.go,
                  onEditingComplete: () => _c.onLogin(),
                  decoration: textFieldAuthDecoration(
                      fontSize: 14, hintText: "Password", radius: 4),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (val) => AppValidator.requiredField(val!,
                      errorMsg: "Password tidak boleh kosong"),
                ),
                Obx(() {
                  if (_c.errorMessage.isEmpty) {
                    return const SizedBox();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: 18.0),
                    child: AppTextNormal.labelNormal(
                        _c.errorMessage.value, 14, Colors.red),
                  );
                }),
                const SizedBox(
                  height: 35,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      shape: WidgetStateProperty.all(
                          const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(6)))),
                      backgroundColor: WidgetStateProperty.all(colorPointRank),
                    ),
                    onPressed: () => _c.onLogin(),
                    child: AppTextNormal.labelBold(
                      "SIGN IN",
                      18,
                      Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
