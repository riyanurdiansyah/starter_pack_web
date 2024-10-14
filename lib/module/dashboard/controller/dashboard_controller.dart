import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../model/sidebar_m.dart';

class DashboardController extends GetxController {
  final RxList<SidebarM> menus = <SidebarM>[].obs;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void onInit() async {
    super.onInit();
    await getMenus();
  }

  Future getMenus() async {
    final response = await firestore.collection("menu").get();
    menus.value = response.docs.map((e) {
      return SidebarM.fromJson(e.data());
    }).toList();

    // menus.sort((a, b) => a.title.compareTo(b.title));
  }
}
