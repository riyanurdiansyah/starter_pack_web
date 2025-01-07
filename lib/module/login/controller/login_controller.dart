import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starter_pack_web/middleware/app_route.dart';
import 'package:starter_pack_web/middleware/app_route_name.dart';
import 'package:starter_pack_web/module/dashboard/controller/audio_controller.dart';
import 'package:starter_pack_web/module/user/model/user_m.dart';
import 'package:universal_html/html.dart' as html;

import '../../../utils/app_dialog.dart';

class LoginController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  late SharedPreferences pref;

  Rx<bool> isLoading = false.obs;

  TextEditingController tcUsername = TextEditingController();
  TextEditingController tcPassword = TextEditingController();

  final formKey = GlobalKey<FormState>();

  final audioC = Get.find<AudioController>();

  Rx<String> errorMessage = "".obs;

  @override
  void onInit() async {
    pref = await SharedPreferences.getInstance();
    super.onInit();
  }

  String hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  bool compareHash(String inputPassword, String storedHash) {
    String inputHash = hashPassword(inputPassword);
    log(inputHash);
    return inputHash == storedHash;
  }

  Future onLogin() async {
    if (formKey.currentState!.validate()) {
      navigatorKey.currentContext!.pop();
      isLoading.value = true;
      final response = await firestore
          .collection("user")
          .where("username", isEqualTo: tcUsername.text)
          .get();
      Future.delayed(
        const Duration(seconds: 2),
        () {
          if (response.docs.isEmpty) {
            AppDialog.dialogSignin();
            errorMessage.value = "Username not found";
            isLoading.value = false;
          } else {
            final user = UserM.fromJson(response.docs.first.data());
            if (compareHash(tcPassword.text, user.password)) {
              pref.setString("user", json.encode(user.toJson()));
              saveSessionToCookie(user.id);
              isLoading.value = false;
              if (tcPassword.text == tcUsername.text) {
                navigatorKey.currentContext!.goNamed(AppRouteName.reset);
              } else {
                audioC.playMusic();
                navigatorKey.currentContext!.goNamed(AppRouteName.play);
              }
            } else {
              AppDialog.dialogSignin();
              errorMessage.value = "Incorrect password";
              isLoading.value = false;
            }
          }
        },
      );
    }
  }

  void saveSessionToCookie(String sessionId) {
    html.document.cookie = "WebRakorMFG=$sessionId; path=/; max-age=3600;";
  }

  void deleteSessionCookie() {
    html.document.cookie = "WebRakorMFG=; path=/; max-age=0;";
  }
}
