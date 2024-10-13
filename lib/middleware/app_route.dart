// app_pages.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:starter_pack_web/middleware/app_route_name.dart';
import 'package:starter_pack_web/module/dashboard/view/dashboard_page.dart';
import 'package:starter_pack_web/module/profile/controller/profile_controller.dart';

import '../module/dashboard/controller/dashboard_controller.dart';
import '../module/home/controller/home_controller.dart';
import '../module/home/view/home_page.dart';
import '../module/profile/view/profile_page.dart';

final navigatorKey = GlobalKey<NavigatorState>();
final shellNavigatorKey = GlobalKey<NavigatorState>();

CustomTransitionPage buildPageWithDefaultTransition<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) =>
        FadeTransition(opacity: animation, child: child),
  );
}

GoRouter router = GoRouter(
  errorBuilder: (context, state) => Container(),
  navigatorKey: navigatorKey,
  initialLocation: "/home",
  debugLogDiagnostics: true,
  routes: [
    ShellRoute(
      navigatorKey: shellNavigatorKey,
      pageBuilder: ((context, state, child) {
        Get.put(DashboardController());
        return buildPageWithDefaultTransition(
          context: context,
          state: state,
          child: DashboardPage(
            widget: child,
            route: state.matchedLocation,
          ),
        );
      }),
      routes: [
        GoRoute(
          path: "/",
          name: AppRouteName.app,
          onExit: (_, __) {
            Get.delete<DashboardController>();
            return true;
          },
          pageBuilder: (context, state) {
            return const NoTransitionPage(
              child: SizedBox(),
            );
          },
          routes: [
            GoRoute(
              path: AppRouteName.home,
              name: AppRouteName.home,
              onExit: (_, __) {
                Get.delete<HomeController>();
                return true;
              },
              pageBuilder: (context, state) {
                Get.put(HomeController());
                return const NoTransitionPage(child: HomePage());
              },
            ),
            GoRoute(
              path: AppRouteName.profile,
              name: AppRouteName.profile,
              onExit: (_, __) {
                Get.delete<ProfileController>();
                return true;
              },
              pageBuilder: (context, state) {
                Get.put(ProfileController());
                return NoTransitionPage(child: ProfilePage());
              },
            ),
          ],
        ),
      ],
    ),
    // GoRoute(
    //   path: '/signin',
    //   name: AppRouteName.signin,
    //   builder: (context, state) {
    //     return WebSigninPage();
    //   },
    // ),
    // GoRoute(
    //   path: '/invoice/:id',
    //   name: AppRouteName.invoicesDetail,
    //   onExit: (context) {
    //     Get.delete<InvoiceDetailController>();
    //     return true;
    //   },
    //   pageBuilder: (context, state) {
    //     String id = state.pathParameters["id"] ?? "";
    //     Get.put(InvoiceDetailController()).invoiceId.value = id;
    //     return NoTransitionPage(child: WebInvoiceDetailPage());
    //   },
    // ),
  ],
);
