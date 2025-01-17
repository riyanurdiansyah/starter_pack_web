import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:starter_pack_web/middleware/app_route_name.dart';
import 'package:starter_pack_web/module/dashboard/controller/dashboard_controller.dart';
import 'package:starter_pack_web/utils/app_extension.dart';

import '../../../../middleware/app_route.dart';
import '../../../../utils/app_color.dart';
import '../../../../utils/app_images.dart';
import '../../../../utils/app_text.dart';
import '../../model/sidebar_m.dart';

class Siderbar extends StatelessWidget {
  Siderbar({
    super.key,
    required this.route,
  });

  final String route;
  final _dC = Get.find<DashboardController>();

  // Variabel untuk menyimpan index dari ExpansionTile yang terbuka
  final ValueNotifier<int?> _openExpansionTileIndex = ValueNotifier<int?>(null);

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
                          (index) => _buildMenu(_dC.menus[index], index),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 60,
                  height: 60,
                  child: Image.asset(bgSales),
                )
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: ListTile(
        tileColor: Colors.red,
        onTap: () => context.goNamed(AppRouteName.play),
        leading: const Icon(
          Icons.logout_rounded,
          color: Colors.white,
        ),
        title: AppTextNormal.labelW600(
          "Back",
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

  Widget _buildMenu(SidebarM sidebar, int index) {
    if (sidebar.submenus.isEmpty) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: null,
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
            Colors.white,
          ),
        ),
      );
    }

    sidebar.submenus.sort((a, b) => a.title.compareTo(b.title));
    return ValueListenableBuilder<int?>(
      valueListenable: _openExpansionTileIndex,
      builder: (context, openIndex, child) {
        return ExpansionTile(
          childrenPadding: const EdgeInsets.only(left: 6),
          title: AppTextNormal.labelNormal(
            sidebar.title,
            16,
            Colors.white,
          ),
          iconColor: Colors.white,
          collapsedIconColor: Colors.white,
          initiallyExpanded: openIndex == index,
          onExpansionChanged: (isExpanded) {
            if (isExpanded) {
              _openExpansionTileIndex.value = index; // Update index yang dibuka
            } else if (openIndex == index) {
              _openExpansionTileIndex.value = null; // Jika ditutup, set ke null
            }
          },
          children: List.generate(sidebar.submenus.length, (subIndex) {
            if (sidebar.submenus[subIndex].submenus.isEmpty) {
              return _buildMenu(sidebar.submenus[subIndex], subIndex);
            }
            return _buildSubMenu(sidebar.submenus[subIndex].submenus);
          }),
        );
      },
    );
  }
}
