import 'package:get/get.dart';

import '../model/sidebar_m.dart';

class DashboardController extends GetxController {
  final RxList<SidebarM> menus = <SidebarM>[].obs;

  @override
  void onInit() async {
    super.onInit();
    await getMenus();
  }

  Future getMenus() async {
    menus.value = <SidebarM>[
      SidebarM(
        id: "",
        created: "",
        role: [],
        submenus: [],
        updated: "",
        title: 'Home',
        route: 'home',
      ),
      SidebarM(
        id: "",
        created: "",
        role: [],
        submenus: [
          SidebarM(
            id: "",
            created: "",
            role: [],
            submenus: [],
            updated: "",
            title: 'Profile',
            route: 'profile',
          ),
          SidebarM(
            id: "",
            created: "",
            role: [],
            submenus: [],
            updated: "",
            title: 'Settings',
            route: 'settings',
          ),
        ],
        updated: "",
        title: 'General',
        route: '',
      ),
    ];
  }
}
