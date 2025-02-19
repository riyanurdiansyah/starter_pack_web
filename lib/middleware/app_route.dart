// app_pages.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starter_pack_web/middleware/app_route_name.dart';
import 'package:starter_pack_web/module/challenge/controller/challenge_controller.dart';
import 'package:starter_pack_web/module/challenge/controller/challenge_quiz_controller.dart';
import 'package:starter_pack_web/module/challenge/view/challenge_quiz_page.dart';
import 'package:starter_pack_web/module/dashboard/controller/audio_controller.dart';
import 'package:starter_pack_web/module/dashboard/controller/challengeset_controller.dart';
import 'package:starter_pack_web/module/dashboard/controller/challengeset_detail_controller.dart';
import 'package:starter_pack_web/module/dashboard/controller/demographyset_controller.dart';
import 'package:starter_pack_web/module/dashboard/controller/game_controller.dart';
import 'package:starter_pack_web/module/dashboard/controller/group_controller.dart';
import 'package:starter_pack_web/module/dashboard/controller/newset_controller.dart';
import 'package:starter_pack_web/module/dashboard/controller/simbis_controller.dart';
import 'package:starter_pack_web/module/dashboard/view/challengeset_detail_page.dart';
import 'package:starter_pack_web/module/dashboard/view/challengeset_page.dart';
import 'package:starter_pack_web/module/dashboard/view/dashboard_page.dart';
import 'package:starter_pack_web/module/dashboard/view/demographyset_page.dart';
import 'package:starter_pack_web/module/dashboard/view/game_page.dart';
import 'package:starter_pack_web/module/dashboard/view/group_page.dart';
import 'package:starter_pack_web/module/dashboard/view/newset_page.dart';
import 'package:starter_pack_web/module/dashboard/view/role_page.dart';
import 'package:starter_pack_web/module/dashboard/view/simbis_page.dart';
import 'package:starter_pack_web/module/demography/controller/cart_controller.dart';
import 'package:starter_pack_web/module/demography/controller/demography_controller.dart';
import 'package:starter_pack_web/module/demography/controller/distribute_controller.dart';
import 'package:starter_pack_web/module/demography/controller/finance_controller.dart';
import 'package:starter_pack_web/module/demography/view/cart_page.dart';
import 'package:starter_pack_web/module/demography/view/demography_page.dart';
import 'package:starter_pack_web/module/demography/view/finance_page.dart';
import 'package:starter_pack_web/module/getting/controller/getting_controller.dart';
import 'package:starter_pack_web/module/getting/view/getting_page.dart';
import 'package:starter_pack_web/module/home/controller/ranks_controller.dart';
import 'package:starter_pack_web/module/home/view/ranks_page.dart';
import 'package:starter_pack_web/module/login/controller/login_controller.dart';
import 'package:starter_pack_web/module/login/controller/reset_controller.dart';
import 'package:starter_pack_web/module/login/view/login_page.dart';
import 'package:starter_pack_web/module/login/view/reset_pass_page.dart';
import 'package:starter_pack_web/module/news/controller/news_controller.dart';
import 'package:starter_pack_web/module/news/controller/news_detail_controller.dart';
import 'package:starter_pack_web/module/news/view/news_page.dart';
import 'package:starter_pack_web/module/play/controller/play_controller.dart';
import 'package:starter_pack_web/module/play/view/play_page.dart';
import 'package:starter_pack_web/module/product/controller/product_controller.dart';
import 'package:starter_pack_web/module/product/view/product_page.dart';
import 'package:starter_pack_web/module/profile/controller/profile_controller.dart';
import 'package:starter_pack_web/module/rnd/controller/rnd_controller.dart';
import 'package:starter_pack_web/module/rnd/view/rnd_page.dart';
import 'package:starter_pack_web/module/role/controller/assign_controller.dart';
import 'package:starter_pack_web/module/role/view/assign_page.dart';
import 'package:starter_pack_web/module/user/controller/user_controller.dart';
import 'package:starter_pack_web/module/user/view/user_page.dart';
import 'package:universal_html/html.dart' as html;

import '../module/dashboard/controller/dashboard_controller.dart';
import '../module/dashboard/controller/role_controller.dart';
import '../module/demography/view/distribute_page.dart';
import '../module/home/controller/home_controller.dart';
import '../module/home/view/home_page.dart';
import '../module/news/view/news_detail_page.dart';
import '../module/profile/view/profile_page.dart';
import '../module/user/model/user_m.dart';

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
    Get.put(AudioController());
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
      path: "/${AppRouteName.reset}",
      name: AppRouteName.reset,
      onExit: (_, __) {
        Get.delete<ResetController>();
        return true;
      },
      pageBuilder: (context, state) {
        Get.put(ResetController());
        return NoTransitionPage(child: ResetPassPage());
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
              path: AppRouteName.setting,
              name: AppRouteName.setting,
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
                  path: AppRouteName.role,
                  name: AppRouteName.role,
                  onExit: (_, __) {
                    Get.delete<RoleController>();
                    return true;
                  },
                  pageBuilder: (context, state) {
                    Get.put(RoleController());
                    return NoTransitionPage(child: RolePage());
                  },
                ),
                GoRoute(
                  path: AppRouteName.group,
                  name: AppRouteName.group,
                  onExit: (_, __) {
                    Get.delete<GroupController>();
                    return true;
                  },
                  pageBuilder: (context, state) {
                    Get.put(GroupController());
                    return NoTransitionPage(child: GroupPage());
                  },
                ),
                GoRoute(
                  path: AppRouteName.demography,
                  name: AppRouteName.demographset,
                  onExit: (_, __) {
                    Get.delete<DemographysetController>();
                    return true;
                  },
                  pageBuilder: (context, state) {
                    Get.put(DemographysetController());
                    return NoTransitionPage(child: DemographysetPage());
                  },
                ),
                GoRoute(
                  path: AppRouteName.newset,
                  name: AppRouteName.newset,
                  onExit: (_, __) {
                    Get.delete<NewsetController>();
                    return true;
                  },
                  pageBuilder: (context, state) {
                    Get.put(NewsetController());
                    return NoTransitionPage(child: NewsetPage());
                  },
                ),
                GoRoute(
                  path: AppRouteName.wellness,
                  name: AppRouteName.wellness,
                  onExit: (_, __) {
                    Get.delete<GameController>();
                    return true;
                  },
                  pageBuilder: (context, state) {
                    Get.put(GameController());
                    return NoTransitionPage(child: GamePage());
                  },
                ),
                GoRoute(
                  path: AppRouteName.simbis,
                  name: AppRouteName.simbis,
                  onExit: (_, __) {
                    Get.delete<SimbisController>();
                    return true;
                  },
                  pageBuilder: (context, state) {
                    Get.put(SimbisController());
                    return NoTransitionPage(child: SimbisPage());
                  },
                ),
                GoRoute(
                    path: AppRouteName.challengeset,
                    name: AppRouteName.challengeset,
                    onExit: (_, __) {
                      Get.delete<ChallengesetController>();
                      return true;
                    },
                    pageBuilder: (context, state) {
                      Get.put(ChallengesetController());
                      return NoTransitionPage(child: ChallengesetPage());
                    },
                    routes: [
                      GoRoute(
                        path: ":id",
                        name: AppRouteName.update,
                        onExit: (_, __) {
                          Get.delete<ChallengesetDetailController>();
                          return true;
                        },
                        pageBuilder: (context, state) {
                          final id = state.pathParameters["id"] ?? "";
                          Get.put(ChallengesetDetailController()).id.value = id;
                          return NoTransitionPage(
                              child: ChallengesetDetailPage());
                        },
                      ),
                    ]),
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
        GoRoute(
          path: AppRouteName.board,
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
        GoRoute(
          path: AppRouteName.getting,
          name: AppRouteName.getting,
          onExit: (_, __) {
            Get.delete<GettingController>();
            return true;
          },
          pageBuilder: (context, state) {
            Get.put(GettingController());
            return NoTransitionPage(child: GettingPage());
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
            return NoTransitionPage(child: GettingPage());
          },
          routes: [
            GoRoute(
              path: "${AppRouteName.quiz}/:id",
              name: AppRouteName.quiz,
              onExit: (_, __) {
                Get.delete<ChallengeQuizController>();
                return true;
              },
              pageBuilder: (context, state) {
                final id = state.pathParameters['id'];

                Get.put(ChallengeQuizController()).id.value = id ?? "";
                return NoTransitionPage(child: ChallengeQuizPage());
              },
            ),
          ],
        ),
        GoRoute(
          path: AppRouteName.assign,
          name: AppRouteName.assign,
          onExit: (_, __) {
            Get.delete<AssignController>();
            return true;
          },
          pageBuilder: (context, state) {
            Get.put(AssignController());
            return NoTransitionPage(child: AssignPage());
          },
        ),
        GoRoute(
          path: AppRouteName.rnd,
          name: AppRouteName.rnd,
          onExit: (_, __) {
            Get.delete<RndController>();
            return true;
          },
          pageBuilder: (context, state) {
            Get.put(RndController());
            return NoTransitionPage(child: RndPage());
          },
        ),
        GoRoute(
          path: AppRouteName.ranks,
          name: AppRouteName.ranks,
          onExit: (_, __) {
            Get.delete<RanksController>();
            return true;
          },
          pageBuilder: (context, state) {
            Get.put(RanksController());
            return NoTransitionPage(child: RanksPage());
          },
        ),
        GoRoute(
            path: AppRouteName.news,
            name: AppRouteName.news,
            onExit: (_, __) {
              Get.delete<NewsController>();
              return true;
            },
            pageBuilder: (context, state) {
              Get.put(NewsController());
              return NoTransitionPage(child: NewsPage());
            },
            routes: [
              GoRoute(
                path: ':id', // Child route untuk detail berita
                name: AppRouteName.newsDetail,
                onExit: (_, __) {
                  Get.delete<NewsDetailController>();
                  return true;
                },
                pageBuilder: (context, state) {
                  final id = state.pathParameters['id'];
                  Get.put(NewsDetailController()).id.value = id ?? "";
                  return NoTransitionPage(
                      child: NewsDetailPage(
                          id: id ?? "")); // Halaman detail berita
                },
              ),
            ]),
        GoRoute(
          path: AppRouteName.production,
          name: AppRouteName.production,
          onExit: (_, __) {
            Get.delete<CartController>();
            return true;
          },
          pageBuilder: (context, state) {
            Get.put(CartController());
            return NoTransitionPage(child: CartPage());
          },
        ),
        GoRoute(
          path: AppRouteName.finance,
          name: AppRouteName.finance,
          onExit: (_, __) {
            Get.delete<FinanceController>();
            return true;
          },
          pageBuilder: (context, state) {
            Get.put(FinanceController());
            return NoTransitionPage(child: FinancePage());
          },
          routes: const [],
        ),
        GoRoute(
          path: AppRouteName.demography,
          name: AppRouteName.demography,
          onExit: (_, __) {
            Get.delete<DemographyController>();
            return true;
          },
          pageBuilder: (context, state) {
            Get.put(DemographyController());
            return const NoTransitionPage(child: DemographyPage());
          },
          routes: [
            GoRoute(
              path: AppRouteName.distribute,
              name: AppRouteName.distribute,
              onExit: (_, __) {
                Get.delete<DistributeController>();
                return true;
              },
              pageBuilder: (context, state) {
                Get.put(DistributeController());
                return NoTransitionPage(child: DistributePage());
              },
              routes: const [],
            ),
          ],
        ),
      ],
    ),
  ],
);
