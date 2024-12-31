import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:starter_pack_web/module/news/controller/news_detail_controller.dart';
import 'package:starter_pack_web/utils/app_constanta.dart';
import 'package:starter_pack_web/utils/app_extension.dart';

import '../../../utils/app_images.dart';

class NewsDetailPage extends StatefulWidget {
  const NewsDetailPage({super.key, required this.id});
  final String id;

  @override
  State<NewsDetailPage> createState() => _NewsDetailPageState();
}

class _NewsDetailPageState extends State<NewsDetailPage> {
  final _c = Get.find<NewsDetailController>();

  @override
  void initState() {
    _c.id.value = widget.id;
    _c.getNews();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: Obx(() {
        if (_c.isLoading.value) {
          return Container(
            color: Colors.black,
            width: double.infinity,
            height: size.height,
            child: Container(
              width: 250,
              height: 150,
              alignment: Alignment.center,
              child: Image.asset(
                loadingGif,
                fit: BoxFit.cover,
                filterQuality: FilterQuality.high,
                width: 250,
              ),
            ),
          );
        }
        if (_c.news.value == newsEmpty) {
          return Container(
            color: Colors.red,
          );
        }

        final random = Random();
        return SizedBox(
          width: size.width,
          height: size.height,
          child: Stack(
            children: [
              SizedBox(
                width: double.infinity,
                height: size.height,
                child: Image.asset(
                  newsImage,
                  fit: BoxFit.fill,
                  filterQuality: FilterQuality.high,
                ),
              ),
              SizedBox(
                height: size.height,
                width: size.width,
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                        children: [
                          225.ph,
                          Expanded(
                            child: SingleChildScrollView(
                              controller: _c.scrollController,
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 24),
                                    width: double.infinity,
                                    child: AnimatedTextKit(
                                      repeatForever: false,
                                      isRepeatingAnimation: false,
                                      onFinished: () {},
                                      animatedTexts: [
                                        TypewriterAnimatedText(
                                          _c.removeHtmlTags(_c.news.value
                                              .content), // Teks biasa tanpa tag HTML
                                          textStyle: const TextStyle(
                                            color: Colors.white,
                                            fontFamily: "Race",
                                            height: 2.4,
                                            fontSize: 16,
                                            wordSpacing: 1.4,
                                          ),
                                          speed:
                                              const Duration(milliseconds: 10),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          60.ph,
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          200.ph,
                          Expanded(
                            child: SizedBox(
                              width: double.infinity,
                              child: Image.asset(
                                imageBOD[random.nextInt(4)],
                                fit: BoxFit.fitHeight,
                                filterQuality: FilterQuality.high,
                                width: 200,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // child: SingleChildScrollView(
          //   child: Padding(
          //     padding:
          //         const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          //     child: Column(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: [
          //         SizedBox(
          //           width: double.infinity,
          //           height: 350,
          //           child: CachedNetworkImage(
          //             imageUrl: _c.news.value.image,
          //             fit: BoxFit.cover,
          //           ),
          //         ),
          //         14.ph,
          //         AppTextNormal.labelBold(
          //           _c.news.value.title,
          //           24,
          //           Colors.black,
          //           maxLines: 3,
          //           letterSpacing: 1.6,
          //           height: 1.4,
          //         ),
          //         16.ph,
          //         QuillEditor(
          //           focusNode: FocusNode(),
          //           scrollController: ScrollController(),
          //           controller: _c.controller,
          //           configurations: const QuillEditorConfigurations(
          //             showCursor: false,
          //             padding: EdgeInsets.all(16),
          //             embedBuilders: [],
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
        );
      }),
    );
  }
}
