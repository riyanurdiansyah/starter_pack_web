import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starter_pack_web/middleware/app_route.dart';
import 'package:starter_pack_web/middleware/app_route_name.dart';
import 'package:starter_pack_web/module/user/model/user_m.dart';
import 'package:universal_html/html.dart' as html;

import '../../dashboard/model/sidebar_m.dart';

class PlayController extends GetxController {
  final AudioPlayer audioPlayer = AudioPlayer();
  final RxList<SidebarM> menus = <SidebarM>[].obs;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final Rx<bool> isLoading = true.obs;

  final Rx<bool> isShow = false.obs;

  final Rx<UserM> user = UserM(
    id: "",
    nama: "",
    username: "",
    password: "",
    roleId: 0,
    role: "",
    kelompok: "",
    kelompokId: 0,
    page: 0,
    groupId: "",
  ).obs;

  late SharedPreferences pref;

  Rx<bool> isPlaying = false.obs;

  @override
  void onInit() async {
    pref = await SharedPreferences.getInstance();
    await getUser();
    await getMenus();
    Future.delayed(const Duration(seconds: 1), () async {
      await changeLoading(false);
      // Future.delayed(const Duration(seconds: 1), () {
      //   AppDialog.dialogNews();
      // });
    });
    super.onInit();
  }

  Future changeLoading(bool isValue) async {
    isLoading.value = isValue;
  }

  Future getUser() async {
    final userCache = pref.getString("user") ?? "";
    final userData = json.decode(userCache);
    user.value = UserM.fromJson(userData);
  }

  Future getMenus() async {
    final response = await firestore.collection("menus").get();
    menus.value = response.docs.map((e) {
      return SidebarM.fromJson(e.data());
    }).toList();
    menus.value = menus
        .where((e) => e.role.isEmpty || e.role.contains(user.value.roleId))
        .toList();
    menus.sort((a, b) => a.no.compareTo(b.no));
  }

  void logout() {
    html.document.cookie = "WebRakorMFG=; path=/; max-age=0;";
    pref.clear();
    navigatorKey.currentContext!.goNamed(AppRouteName.signin);
  }

  void playTyping(bool isPlay) async {
    if (!isPlay) {
      await audioPlayer.play(AssetSource("music/typing.mp3"));
    } else {
      await audioPlayer.stop();
    }
  }
}
