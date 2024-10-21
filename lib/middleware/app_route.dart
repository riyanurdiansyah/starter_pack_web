// app_pages.dart
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starter_pack_web/middleware/app_route_name.dart';
import 'package:starter_pack_web/module/challenge/controller/challenge_controller.dart';
import 'package:starter_pack_web/module/challenge/view/challenge_page.dart';
import 'package:starter_pack_web/module/dashboard/view/dashboard_page.dart';
import 'package:starter_pack_web/module/login/controller/login_controller.dart';
import 'package:starter_pack_web/module/login/view/login_page.dart';
import 'package:starter_pack_web/module/play/controller/play_controller.dart';
import 'package:starter_pack_web/module/play/view/play_page.dart';
import 'package:starter_pack_web/module/product/controller/product_controller.dart';
import 'package:starter_pack_web/module/product/view/product_page.dart';
import 'package:starter_pack_web/module/profile/controller/profile_controller.dart';
import 'package:starter_pack_web/module/user/controller/user_controller.dart';
import 'package:starter_pack_web/module/user/model/user_m.dart';
import 'package:starter_pack_web/module/user/view/user_page.dart';
import 'package:universal_html/html.dart' as html;

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

String? getSessionFromCookie() {
  String cookies = html.document.cookie ?? "";
  List<String> cookiesList = cookies.split("; ");

  for (String cookie in cookiesList) {
    if (cookie.startsWith("WebRakorMFG=")) {
      return cookie.substring("WebRakorMFG=".length);
    }
  }
  return null;
}

GoRouter router = GoRouter(
  errorBuilder: (context, state) => Container(),
  navigatorKey: navigatorKey,
  initialLocation: "/play",
  debugLogDiagnostics: true,
  redirect: (context, state) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final user = pref.getString("user");
    if (user == null) {
      return "/signin";
    }

    String? sessionId = getSessionFromCookie();

    if (sessionId == null &&
        state.uri.toString() != "/${AppRouteName.signin}") {
      return "/${AppRouteName.signin}";
    }

    final userObj = UserM.fromJson(json.decode(user));

    if (sessionId != userObj.id) {
      return "/${AppRouteName.signin}";
    }

    log(state.uri.toString());

    if (state.uri.toString() == "/${AppRouteName.signin}") {
      return "/${AppRouteName.play}";
    }

    return null;
  },
  routes: [
    GoRoute(
      path: "/${AppRouteName.signin}",
      name: AppRouteName.signin,
      onExit: (_, __) {
        Get.delete<LoginController>();
        return true;
      },
      pageBuilder: (context, state) {
        Get.put(LoginController());
        return NoTransitionPage(child: LoginPage());
      },
    ),
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
              return NoTransitionPage(child: ProductPage());
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
              return NoTransitionPage(child: ChallengePage());
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
  ],
);
