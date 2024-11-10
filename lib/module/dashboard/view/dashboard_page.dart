import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/dashboard_controller.dart';
import 'widgets/sidebar.dart';

class DashboardPage extends StatelessWidget {
  DashboardPage({
    super.key,
    required this.widget,
    required this.route,
  });

  final Widget widget;
  final String route;

  final _dC = Get.find<DashboardController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: Siderbar(
        route: route,
      ),
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: Siderbar(
              route: route,
            ),
          ),
          Expanded(
            flex: 10,
            child: widget,
          ),
        ],
      ),
    );
  }
}
