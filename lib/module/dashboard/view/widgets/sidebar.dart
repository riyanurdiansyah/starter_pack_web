import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:starter_pack_web/module/dashboard/controller/dashboard_controller.dart';
import 'package:starter_pack_web/utils/app_extension.dart';

import '../../../../middleware/app_route.dart';
import '../../../../utils/app_color.dart';
import '../../../../utils/app_text.dart';
import '../../model/sidebar_m.dart';

class Siderbar extends StatelessWidget {
  Siderbar({
    super.key,
    required this.route,
  });

  final String route;

  final _dC = Get.find<DashboardController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Drawer(
        width: double.infinity,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        elevation: 0,
        child: Material(
          color: colorPrimaryDark,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextNormal.labelBold(
                  "Dash UI KIT",
                  25,
                  Colors.white,
                ),
                25.ph,
                Expanded(
                  child: SingleChildScrollView(
                    child: Obx(
                      () => Column(
                        children: List.generate(
                          _dC.menus.length,
                          (index) => _buildMenu(_dC.menus[index]),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: ListTile(
        tileColor: Colors.red,
        onTap: () {},
        leading: const Icon(
          Icons.logout_rounded,
          color: Colors.white,
        ),
        title: AppTextNormal.labelW600(
          "Keluar",
          16,
          Colors.white,
        ),
      ),
    );
  }

  Widget _buildSubMenu(List<SidebarM> submenus) {
    return Column(
      children: submenus.map(
        (submenu) {
          return ListTile(
            onTap: () {
              navigatorKey.currentContext?.goNamed(submenu.route);
            },
            title: AppTextNormal.labelNormal(
              submenu.title,
              16,
              Colors.white,
            ),
          );
        },
      ).toList(),
    );
  }

  Widget _buildMenu(SidebarM sidebar) {
    if (sidebar.submenus.isEmpty) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color:
              sidebar.route == route.split("/")[1] && sidebar.route.isNotEmpty
                  ? Colors.white
                  : null,
        ),
        child: ListTile(
          selectedColor: Colors.amber,
          focusColor: Colors.red,
          selectedTileColor: Colors.black,
          onTap: () {
            navigatorKey.currentContext?.goNamed(sidebar.route);
          },
          title: AppTextNormal.labelNormal(
            sidebar.title,
            16,
            sidebar.route == route.split("/")[1] && sidebar.route.isNotEmpty
                ? colorPrimaryDark
                : Colors.white,
          ),
        ),
      );
    }
    sidebar.submenus.sort((a, b) => a.title.compareTo(b.title));
    return ExpansionTile(
      childrenPadding: const EdgeInsets.only(left: 6),
      title: AppTextNormal.labelNormal(
        sidebar.title,
        16,
        sidebar.route == route.split("/")[1] && sidebar.route.isNotEmpty
            ? colorPrimaryDark
            : Colors.white,
      ),
      iconColor: Colors.white,
      collapsedIconColor: Colors.white,
      children: List.generate(sidebar.submenus.length, (index) {
        if (sidebar.submenus[index].submenus.isEmpty) {
          if (index + 1 == sidebar.submenus.length) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: _buildMenu(sidebar.submenus[index]),
            );
          }
          return _buildMenu(sidebar.submenus[index]);
        }
        return _buildSubMenu(sidebar.submenus[index].submenus);
      }),
    );
  }
}
