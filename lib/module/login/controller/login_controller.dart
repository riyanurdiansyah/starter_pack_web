import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starter_pack_web/middleware/app_route.dart';
import 'package:starter_pack_web/middleware/app_route_name.dart';
import 'package:starter_pack_web/module/user/model/user_m.dart';
import 'package:universal_html/html.dart' as html;

class LoginController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  late SharedPreferences pref;

  Rx<bool> isLoading = false.obs;

  TextEditingController tcUsername = TextEditingController();
  TextEditingController tcPassword = TextEditingController();

  final formKey = GlobalKey<FormState>();

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

    return inputHash == storedHash;
  }

  Future onLogin() async {
    if (formKey.currentState!.validate()) {
      isLoading.value = true;
      final response = await firestore
          .collection("user")
          .where("username", isEqualTo: tcUsername.text)
          .get();
      Future.delayed(
        const Duration(seconds: 2),
        () {
          if (response.docs.isEmpty) {
            errorMessage.value = "Username not found";
            isLoading.value = false;
          } else {
            final user = UserM.fromJson(response.docs.first.data());
            if (compareHash(tcPassword.text, user.password)) {
              pref.setString("user", json.encode(user.toJson()));
              saveSessionToCookie(user.id);
              isLoading.value = false;
              navigatorKey.currentContext!.goNamed(AppRouteName.play);
            } else {
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
