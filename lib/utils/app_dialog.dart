import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:starter_pack_web/module/challenge/model/challenge_m.dart';
import 'package:starter_pack_web/module/dashboard/controller/challengeset_controller.dart';
import 'package:starter_pack_web/module/dashboard/controller/demographyset_controller.dart';
import 'package:starter_pack_web/module/dashboard/controller/group_controller.dart';
import 'package:starter_pack_web/module/dashboard/controller/role_controller.dart';
import 'package:starter_pack_web/module/dashboard/model/demography_m.dart';
import 'package:starter_pack_web/module/login/controller/login_controller.dart';
import 'package:starter_pack_web/module/user/controller/user_controller.dart';
import 'package:starter_pack_web/module/user/model/user_m.dart';
import 'package:starter_pack_web/utils/app_color.dart';
import 'package:starter_pack_web/utils/app_extension.dart';
import 'package:starter_pack_web/utils/app_images.dart';

import '../middleware/app_route.dart';
import '../module/user/model/group_m.dart';
import '../module/user/model/role_m.dart';
import 'app_constanta.dart';
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

  static dialogNews() {
    final size = MediaQuery.sizeOf(navigatorKey.currentContext!);

    showDialog(
      context: navigatorKey.currentContext!,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16), // Rounded corners
          ),
          child: Container(
            color: Colors.white,
            width: size.width / 1.6,
            height: size.height / 1.51,
            child: Stack(
              children: [
                Image.asset(
                  newsImage,
                  fit: BoxFit.fill,
                  filterQuality: FilterQuality.high,
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: IconButton(
                    onPressed: () => context.pop(),
                    icon: const Icon(
                      Icons.close_rounded,
                      color: Colors.white,
                    ),
                  ),
                ),
                Positioned(
                    top: 200,
                    left: 50,
                    bottom: 0,
                    child: SizedBox(
                      width: size.width / 2.5,
                      height: 40,
                      child: AnimatedTextKit(
                        repeatForever: false,
                        totalRepeatCount: 0,
                        isRepeatingAnimation: false,
                        animatedTexts: [
                          TypewriterAnimatedText(
                            loremIpsum,
                            textStyle: const TextStyle(
                              fontFamily: 'Bigail',
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.white,
                              letterSpacing: 1.4,
                              height: 2,
                            ),
                          ),
                        ],
                      ),
                    )),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Image.asset(
                    driverImage,
                    filterQuality: FilterQuality.high,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
    // return showDialog(
    //   context: navigatorKey.currentContext!,
    //   barrierColor: Colors.grey.withOpacity(0.4),
    //   builder: (context) {
    //     return AlertDialog(
    //       backgroundColor: Colors.transparent,
    //       content:
    //     );
    //   },
    // );
  }

  static dialogChallenge({
    ChallengeM? oldChallenge,
  }) {
    final c = Get.find<ChallengesetController>();
    final size = MediaQuery.sizeOf(navigatorKey.currentContext!);
    if (oldChallenge != null) {
      c.setChallengeToDialog(oldChallenge);
    }
    return showDialog(
      barrierDismissible: false,
      context: navigatorKey.currentContext!,
      barrierColor: Colors.grey.withOpacity(0.4),
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          title: AppTextNormal.labelBold(
            oldChallenge != null ? "Update Challenge" : "Add Challenge",
            16,
            Colors.black,
          ),
          content: SizedBox(
            width: size.width / 2.5,
            child: Form(
              key: c.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
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
                    controller: c.tcChallenge,
                    validator: (val) => AppValidator.requiredField(val!),
                    style: TextStyle(
                      fontFamily: 'Bigail',
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 12),
                      disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  16.ph,
                  AppTextNormal.labelW700(
                    "Start Date",
                    14,
                    Colors.black,
                  ),
                  12.ph,
                  TextFormField(
                    controller: c.tcDate,
                    validator: (val) => AppValidator.requiredField(val!),
                    style: TextStyle(
                      fontFamily: 'Bigail',
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                    onTap: () async {},
                    readOnly: true,
                    decoration: InputDecoration(
                      suffixIcon: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () async {
                            final date = await globalDate();
                            c.selectedDate = date;
                            if (date != null) {
                              c.tcDate.text =
                                  "${DateFormat("dd/MM/yyyy HH:mm").format(date)} WIB";
                            } else {
                              c.tcDate.clear();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            backgroundColor: Colors.grey.shade500,
                          ),
                          child: AppTextNormal.labelBold(
                            "Choose Date",
                            14,
                            Colors.white,
                          ),
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 12),
                      disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  16.ph,
                  AppTextNormal.labelW700(
                    "End Date",
                    14,
                    Colors.black,
                  ),
                  12.ph,
                  TextFormField(
                    controller: c.tcEndDate,
                    validator: (val) => AppValidator.requiredField(val!),
                    style: TextStyle(
                      fontFamily: 'Bigail',
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                    onTap: () async {},
                    readOnly: true,
                    decoration: InputDecoration(
                      suffixIcon: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () async {
                            final date = await globalDate();
                            c.selectedEndDate = date;
                            if (date != null) {
                              c.tcEndDate.text =
                                  "${DateFormat("dd/MM/yyyy HH:mm").format(date)} WIB";
                            } else {
                              c.tcEndDate.clear();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            backgroundColor: Colors.grey.shade500,
                          ),
                          child: AppTextNormal.labelBold(
                            "Choose Date",
                            14,
                            Colors.white,
                          ),
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 12),
                      disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  16.ph,
                  AppTextNormal.labelW700(
                    "Type",
                    14,
                    Colors.black,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  DropdownSearch<String>(
                    popupProps: PopupProps.menu(
                      fit: FlexFit.loose,
                      showSearchBox: true,
                      searchFieldProps: TextFieldProps(
                        controller: c.tcType,
                        decoration: InputDecoration(
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
                            borderSide:
                                const BorderSide(color: colorPrimaryDark),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    items: (_, __) => ["OPTION", "TRUE/FALSE", "UPLOAD"],
                    compareFn: (_, __) {
                      return false;
                    },
                    itemAsString: (u) => u,
                    selectedItem: c.tcType.text,
                    onChanged: (data) => c.tcType.text = data ?? "",
                  ),
                  16.ph,
                  AppTextNormal.labelW700(
                    "Image",
                    14,
                    Colors.black,
                  ),
                  12.ph,
                  TextFormField(
                    controller: c.tcImage,
                    validator: (val) => AppValidator.requiredField(val!),
                    style: TextStyle(
                      fontFamily: 'Bigail',
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                    onTap: () async {},
                    readOnly: true,
                    decoration: InputDecoration(
                      suffixIcon: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () async {
                            final result = await pickFile();

                            c.filePickerResult = result;

                            if (result != null) {
                              c.tcImage.text = result.files.single.name;
                            } else {
                              c.tcImage.clear();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            backgroundColor: Colors.grey.shade500,
                          ),
                          child: AppTextNormal.labelBold(
                            "Choose File",
                            14,
                            Colors.white,
                          ),
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 12),
                      disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  18.ph,
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
                              onPressed: () {
                                c.clearAllData();
                                context.pop();
                              },
                              child: AppTextNormal.labelBold(
                                "CANCEL",
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
                                context.pop();
                                c.saveChallenge(oldChallenge: oldChallenge);
                              },
                              child: AppTextNormal.labelBold(
                                "SAVE",
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
        );
      },
    );
  }

  static dialogGroup({
    GroupM? oldGroup,
  }) {
    final c = Get.find<GroupController>();
    final size = MediaQuery.sizeOf(navigatorKey.currentContext!);
    if (oldGroup != null) {
      c.setGroupDialog(oldGroup);
    }
    return showDialog(
      barrierDismissible: false,
      context: navigatorKey.currentContext!,
      barrierColor: Colors.grey.withOpacity(0.4),
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          title: AppTextNormal.labelBold(
            oldGroup != null ? "Update Group" : "Add Group",
            16,
            Colors.black,
          ),
          content: SizedBox(
            width: size.width / 2.5,
            child: Form(
              key: c.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppTextNormal.labelW700(
                    "Group Number",
                    14,
                    Colors.black,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  TextFormField(
                    controller: c.tcGroupName,
                    validator: (val) => AppValidator.requiredField(val!),
                    style: TextStyle(
                      fontFamily: 'Bigail',
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                    readOnly: true,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 12),
                      disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  16.ph,
                  AppTextNormal.labelW700(
                    "Group Name",
                    14,
                    Colors.black,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  TextFormField(
                    controller: c.tcAlias,
                    validator: (val) => AppValidator.requiredField(val!),
                    style: TextStyle(
                      fontFamily: 'Bigail',
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 12),
                      disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  16.ph,
                  // AppTextNormal.labelW700(
                  //   "Group Country",
                  //   14,
                  //   Colors.black,
                  // ),
                  // const SizedBox(
                  //   height: 12,
                  // ),
                  // TextFormField(
                  //   controller: c.tcGroupCountry,
                  //   validator: (val) => AppValidator.requiredField(val!),
                  //   style: TextStyle(
                  //     fontFamily: 'Bigail',
                  //     fontWeight: FontWeight.bold,
                  //     fontSize: 14,
                  //     color: Colors.grey.shade600,
                  //   ),
                  //   decoration: InputDecoration(
                  //     contentPadding: const EdgeInsets.symmetric(
                  //         vertical: 0, horizontal: 12),
                  //     disabledBorder: OutlineInputBorder(
                  //       borderSide: BorderSide(color: Colors.grey.shade300),
                  //       borderRadius: BorderRadius.circular(8),
                  //     ),
                  //     border: OutlineInputBorder(
                  //       borderSide: BorderSide(color: Colors.grey.shade300),
                  //       borderRadius: BorderRadius.circular(8),
                  //     ),
                  //     enabledBorder: OutlineInputBorder(
                  //       borderSide: BorderSide(color: Colors.grey.shade300),
                  //       borderRadius: BorderRadius.circular(8),
                  //     ),
                  //   ),
                  // ),
                  // 16.ph,
                  AppTextNormal.labelW700(
                    "Group Image",
                    14,
                    Colors.black,
                  ),
                  12.ph,
                  TextFormField(
                    controller: c.tcImage,
                    validator: (val) => AppValidator.requiredField(val!),
                    style: TextStyle(
                      fontFamily: 'Bigail',
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                    onTap: () async {},
                    readOnly: true,
                    decoration: InputDecoration(
                      suffixIcon: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () async {
                            final result = await pickFile();

                            c.filePickerResult = result;

                            if (result != null) {
                              c.tcImage.text = result.files.single.name;
                            } else {
                              c.tcImage.clear();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            backgroundColor: Colors.grey.shade500,
                          ),
                          child: AppTextNormal.labelBold(
                            "Choose File",
                            14,
                            Colors.white,
                          ),
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 12),
                      disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  18.ph,
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
                                "CANCEL",
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
                                AppDialog.dialogDelete(
                                  title: "Create Group",
                                  subtitle: "Are you sure you want to create?",
                                  confirmText: "Yes, create",
                                  callback: () {
                                    context.pop();
                                    context.pop();
                                    if (oldGroup != null) {
                                      c.updateGroup(oldGroup);
                                    } else {
                                      c.createGroup();
                                    }
                                  },
                                );
                              },
                              child: AppTextNormal.labelBold(
                                "SAVE",
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
        );
      },
    );
  }

  static dialogUser({
    UserM? oldUser,
  }) {
    final uC = Get.find<UserController>();
    final size = MediaQuery.of(navigatorKey.currentContext!).size;
    if (oldUser != null) {
      uC.setUserToDialog(oldUser);
    }
    return showDialog(
      context: navigatorKey.currentContext!,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        title: AppTextNormal.labelBold(
          oldUser != null ? "Update User" : "Add User",
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
                  readOnly: oldUser != null,
                  controller: uC.tcUsername,
                  validator: (val) => AppValidator.requiredField(val!),
                  style: GoogleFonts.poppins(
                    height: 1.4,
                  ),
                  decoration: InputDecoration(
                    filled: oldUser != null,
                    fillColor: oldUser != null ? Colors.grey.shade200 : null,
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
                              "CANCEL",
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
                              uC.addNewUser(oldUser);
                            },
                            child: AppTextNormal.labelBold(
                              "SAVE",
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

  static dialogRole({
    RoleM? oldRole,
  }) {
    final uC = Get.find<RoleController>();
    final size = MediaQuery.of(navigatorKey.currentContext!).size;
    if (oldRole != null) {
      uC.tcRole.text = oldRole.role;
    }
    return showDialog(
      context: navigatorKey.currentContext!,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        title: AppTextNormal.labelBold(
          oldRole != null ? "Update Role" : "Add Role",
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
                  "Role",
                  14,
                  Colors.black,
                ),
                const SizedBox(
                  height: 12,
                ),
                TextFormField(
                  controller: uC.tcRole,
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
                            onPressed: () {
                              uC.tcRole.clear();
                              context.pop();
                            },
                            child: AppTextNormal.labelBold(
                              "CANCEL",
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
                              context.pop();
                              uC.saveRole(oldRole: oldRole);
                            },
                            child: AppTextNormal.labelBold(
                              "SAVE",
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

  static dialogDemography({
    DemographyM? oldDemography,
  }) {
    final c = Get.find<DemographysetController>();
    final size = MediaQuery.of(navigatorKey.currentContext!).size;
    if (oldDemography != null) {
      c.setDemographyToDialog(oldDemography);
    }
    return showDialog(
      context: navigatorKey.currentContext!,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        title: AppTextNormal.labelBold(
          oldDemography != null ? "Update Demography" : "Add Demography",
          16,
          Colors.black,
        ),
        content: SizedBox(
          width: size.width / 2.5,
          child: Form(
            key: c.formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppTextNormal.labelW700(
                    "Name",
                    14,
                    Colors.black,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  TextFormField(
                    controller: c.tcName,
                    validator: (val) => AppValidator.requiredField(val!),
                    style: GoogleFonts.poppins(
                      height: 1.4,
                    ),
                    decoration: InputDecoration(
                      hintStyle: GoogleFonts.poppins(
                        fontSize: 14,
                        wordSpacing: 4,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 12),
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
                    "Infant",
                    14,
                    Colors.black,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  TextFormField(
                    controller: c.tcInfant,
                    validator: (val) => AppValidator.requiredField(val!),
                    style: GoogleFonts.poppins(
                      height: 1.4,
                    ),
                    minLines: 4,
                    maxLines: 50,
                    decoration: InputDecoration(
                      hintStyle: GoogleFonts.poppins(
                        fontSize: 14,
                        wordSpacing: 4,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 12),
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
                    "Pregnant",
                    14,
                    Colors.black,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  TextFormField(
                    controller: c.tcPregnant,
                    validator: (val) => AppValidator.requiredField(val!),
                    style: GoogleFonts.poppins(
                      height: 1.4,
                    ),
                    minLines: 4,
                    maxLines: 50,
                    decoration: InputDecoration(
                      hintStyle: GoogleFonts.poppins(
                        fontSize: 14,
                        wordSpacing: 4,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 12),
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
                    "Seniors",
                    14,
                    Colors.black,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  TextFormField(
                    controller: c.tcSeniors,
                    validator: (val) => AppValidator.requiredField(val!),
                    style: GoogleFonts.poppins(
                      height: 1.4,
                    ),
                    minLines: 4,
                    maxLines: 50,
                    decoration: InputDecoration(
                      hintStyle: GoogleFonts.poppins(
                        fontSize: 14,
                        wordSpacing: 4,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 12),
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
                                "CANCEL",
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
                                context.pop();
                                c.updateDemography(oldDemography);
                              },
                              child: AppTextNormal.labelBold(
                                "SAVE",
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
      ),
    );
  }

  static dialogDelete({
    VoidCallback? callback,
    String? title,
    String? subtitle,
    String? cancelText,
    String? confirmText,
  }) {
    final size = MediaQuery.of(navigatorKey.currentContext!).size;
    return showDialog(
      context: navigatorKey.currentContext!,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        title: AppTextNormal.labelBold(
          title ?? "Delete Item",
          16,
          Colors.black,
        ),
        content: SizedBox(
          width: size.width / 2.5,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTextNormal.labelW700(
                subtitle ?? "Are you sure you want to delete this item?",
                14,
                Colors.grey.shade600,
              ),
              26.ph,
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () => navigatorKey.currentContext!.pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade500,
                    ),
                    child: AppTextNormal.labelW700(
                      cancelText ?? "No, Cancel",
                      14,
                      Colors.white,
                    ),
                  ),
                  8.pw,
                  ElevatedButton(
                    onPressed: callback,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorPrimaryDark,
                    ),
                    child: AppTextNormal.labelW700(
                      confirmText ?? "Yes, Delete",
                      14,
                      Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  static dialogSnackbar(
    String message,
  ) {
    final size = MediaQuery.of(navigatorKey.currentContext!).size;
    return ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.black87,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
            bottom: 60, left: size.width / 4, right: size.width / 4),
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
