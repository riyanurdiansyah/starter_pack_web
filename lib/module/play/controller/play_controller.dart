import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starter_pack_web/middleware/app_route.dart';
import 'package:starter_pack_web/middleware/app_route_name.dart';
import 'package:starter_pack_web/module/news/model/news_m.dart';
import 'package:starter_pack_web/module/user/model/user_m.dart';
import 'package:universal_html/html.dart' as html;

import '../../../utils/app_dialog.dart';
import '../../dashboard/controller/audio_controller.dart';
import '../../dashboard/model/sidebar_m.dart';

class PlayController extends GetxController {
  final AudioPlayer audioPlayer = AudioPlayer();
  final RxList<SidebarM> menus = <SidebarM>[].obs;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final Rx<bool> isLoading = true.obs;

  final Rx<bool> isPlayingMusic = true.obs;

  final Rx<bool> isShow = false.obs;

  final random = Random();

  final Rx<UserM> user = UserM(
    id: "",
    nama: "",
    username: "",
    password: "",
    point: 0,
    roleId: 0,
    role: "",
    kelompok: "",
    kelompokId: 0,
    page: 0,
    groupId: "",
    isUsePrivillege: false,
  ).obs;

  late SharedPreferences pref;

  Rx<bool> isPlaying = false.obs;

  Timer? _timer;

  @override
  void onInit() async {
    pref = await SharedPreferences.getInstance();
    await getUser();
    await getMenus();
    getNews();
    Future.delayed(const Duration(seconds: 1), () async {
      await changeLoading(false);
      // Future.delayed(const Duration(seconds: 1), () {
      //   AppDialog.dialogNews();
      // });
    });
    super.onInit();
  }

  void getNews() async {
    _timer = Timer.periodic(
      const Duration(seconds: 3),
      (timer) async {
        final response = await firestore.collection("news").get();
        List<NewsM> news =
            response.docs.map((e) => NewsM.fromJson(e.data())).toList();
        news = news
            .where((e) =>
                !e.users.contains(user.value.id) &&
                DateTime.now().isAfter(DateTime.parse(e.date)))
            .toList();
        if (news.isNotEmpty) {
          if (user.value.roleId == 100 || user.value.roleId == 109) {
            updateNews(news[0]);
            AppDialog.dialogNews(news[0]);
          }
        }
      },
    );
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

  void mute() async {
    if (Get.isRegistered<AudioController>()) {
      final audioC = Get.find<AudioController>();
      if (audioC.isPlaySound.value) {
        await audioC.audioPlayer.setVolume(0.0);
        audioC.isPlaySound.value = false;
        isPlayingMusic.value = false;
      } else {
        await audioC.audioPlayer.setVolume(1.0);
        audioC.isPlaySound.value = true;
        isPlayingMusic.value = true;
      }
    }
  }

  // Stream<bool> groupStream() {
  //   return FirebaseFirestore.instance
  //       .collection('news')
  //       .snapshots()
  //       .map((snapshot) {
  //     debugPrint("LISTEN");
  //     if (snapshot.docs.isNotEmpty) {
  //       List<NewsM> news =
  //           snapshot.docs.map((e) => NewsM.fromJson(e.data())).toList();
  //       news = news
  //           .where((e) =>
  //               !e.users.contains(user.value.id) &&
  //               DateTime.now().isAfter(DateTime.parse(e.date)))
  //           .toList();
  //       debugPrint("CEK NEWS : ${json.encode(news)}");
  //       if (news.isNotEmpty) {
  //         if (user.value.roleId == 100 || user.value.roleId == 109) {
  //           updateNews(news[0]);
  //           AppDialog.dialogNews(news[0]);
  //         }
  //       }
  //       return true;
  //     } else {
  //       return false;
  //     }
  //   });
  // }

  void updateNews(NewsM news) async {
    DocumentReference docRef =
        FirebaseFirestore.instance.collection('news').doc(news.id);

    await docRef.update({
      'users': FieldValue.arrayUnion([user.value.id])
    });
  }
}
