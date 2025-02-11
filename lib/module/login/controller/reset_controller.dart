import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starter_pack_web/utils/app_constanta.dart';

import '../../../middleware/app_route.dart';
import '../../../middleware/app_route_name.dart';
import '../../dashboard/controller/audio_controller.dart';
import '../../user/model/user_m.dart';

class ResetController extends GetxController {
  final Rx<UserM> user = userEmpty.obs;

  late SharedPreferences pref;

  Rx<bool> isPlaying = false.obs;

  Rx<bool> isLoading = false.obs;

  final tcPassword = TextEditingController();

  final audioC = Get.find<AudioController>();

  @override
  void onInit() async {
    pref = await SharedPreferences.getInstance();
    await getUser();
    super.onInit();
  }

  Future getUser() async {
    final userCache = pref.getString("user") ?? "";
    final userData = json.decode(userCache);
    user.value = UserM.fromJson(userData);
  }

  String hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  void updatePassword() async {
    DocumentReference docRef =
        FirebaseFirestore.instance.collection('user').doc(user.value.id);

    user.value = user.value.copyWith(password: hashPassword(tcPassword.text));
    await docRef.update(user.toJson());
    // audioC.playMusic();
    navigatorKey.currentContext!.goNamed(AppRouteName.play);
  }
}
