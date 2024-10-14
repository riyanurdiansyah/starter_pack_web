// app_pages.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:starter_pack_web/middleware/app_route_name.dart';
import 'package:starter_pack_web/module/challenge/controller/challenge_controller.dart';
import 'package:starter_pack_web/module/challenge/view/challenge_page.dart';
import 'package:starter_pack_web/module/dashboard/view/dashboard_page.dart';
import 'package:starter_pack_web/module/play/controller/play_controller.dart';
import 'package:starter_pack_web/module/play/view/play_page.dart';
import 'package:starter_pack_web/module/product/controller/product_controller.dart';
import 'package:starter_pack_web/module/product/view/product_page.dart';
import 'package:starter_pack_web/module/profile/controller/profile_controller.dart';
import 'package:starter_pack_web/module/user/controller/user_controller.dart';
import 'package:starter_pack_web/module/user/view/user_page.dart';

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
  initialLocation: "/play",
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
        path: "/${AppRouteName.play}",
        name: AppRouteName.play,
        onExit: (_, __) {
          Get.delete<PlayController>();
          return true;
        },
        pageBuilder: (context, state) {
          Get.put(PlayController());
          return NoTransitionPage(child: PlayPage());
        },
        routes: [
          GoRoute(
            path: AppRouteName.product,
            name: AppRouteName.product,
            onExit: (_, __) {
              Get.delete<ProductController>();
              return true;
            },
            pageBuilder: (context, state) {
              Get.put(ProductController());
              return const NoTransitionPage(child: ProductPage());
            },
          ),
          GoRoute(
            path: AppRouteName.challenge,
            name: AppRouteName.challenge,
            onExit: (_, __) {
              Get.delete<ChallengeController>();
              return true;
            },
            pageBuilder: (context, state) {
              Get.put(ChallengeController());
              return const NoTransitionPage(child: ChallengePage());
            },
          ),
        ]),
    GoRoute(
      path: "/${AppRouteName.board}",
      name: AppRouteName.board,
      onExit: (_, __) {
        Get.delete<HomeController>();
        return true;
      },
      pageBuilder: (context, state) {
        Get.put(HomeController());
        return NoTransitionPage(child: HomePage());
      },
    ),
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
          path: "/${AppRouteName.setting}",
          name: "/${AppRouteName.setting}",
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
                return NoTransitionPage(child: HomePage());
              },
            ),
            GoRoute(
              path: AppRouteName.user,
              name: AppRouteName.user,
              onExit: (_, __) {
                Get.delete<UserController>();
                return true;
              },
              pageBuilder: (context, state) {
                Get.put(UserController());
                return NoTransitionPage(child: UserPage());
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
