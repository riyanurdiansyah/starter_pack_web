import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:starter_pack_web/middleware/app_route_name.dart';
import 'package:starter_pack_web/module/news/controller/news_controller.dart';
import 'package:starter_pack_web/utils/app_extension.dart';
import 'package:starter_pack_web/utils/app_text.dart';

class NewsPage extends StatelessWidget {
  NewsPage({super.key});

  final _c = Get.find<NewsController>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: Colors.black,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Obx(
              () {
                if (_c.news.isEmpty) {
                  return const SizedBox();
                }
                return SingleChildScrollView(
                  child: InkWell(
                    onTap: () => context
                        .goNamed(AppRouteName.newsDetail, pathParameters: {
                      "id": _c.news[0].id,
                    }),
                    hoverColor: Colors.grey.shade200,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CachedNetworkImage(
                            imageUrl: _c.news[0].image,
                            height: size.height / 1.25,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                          16.ph,
                          AppTextNormal.labelBold(
                            _c.news[0].title,
                            35,
                            Colors.white,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            letterSpacing: 2,
                            height: 1.25,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          12.pw,
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppTextNormal.labelBold(
                    "Recent News",
                    18.5,
                    Colors.white,
                    letterSpacing: 2,
                  ),
                  Container(
                    width: 135,
                    height: 2.4,
                    color: Colors.grey,
                  ),
                  16.ph,
                  Expanded(
                    child: Obx(
                      () => ListView(
                        children: List.generate(
                          _c.news.length,
                          (index) {
                            return InkWell(
                              onTap: () => context.goNamed(
                                  AppRouteName.newsDetail,
                                  pathParameters: {
                                    "id": _c.news[index].id,
                                  }),
                              hoverColor: Colors.black45,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CachedNetworkImage(
                                    imageUrl: _c.news[index].image,
                                    height: 125,
                                    width: 120,
                                    fit: BoxFit.fill,
                                  ),
                                  16.pw,
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        14.ph,
                                        AppTextNormal.labelBold(
                                          _c.news[index].title,
                                          16,
                                          Colors.white,
                                          maxLines: 3,
                                          letterSpacing: 1.6,
                                          height: 1.4,
                                        ),
                                        12.ph,
                                        AppTextNormal.labelW600(
                                          "published : ${DateFormat("dd MMM yyyy").format(DateTime.parse(_c.news[index].date))}",
                                          14,
                                          Colors.white,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
