import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';
import 'package:starter_pack_web/module/news/controller/news_detail_controller.dart';
import 'package:starter_pack_web/utils/app_constanta.dart';
import 'package:starter_pack_web/utils/app_extension.dart';

import '../../../utils/app_images.dart';
import '../../../utils/app_text.dart';

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
        return Center(
          child: Container(
            width: size.width / 1.8,
            height: size.height,
            color: Colors.white,
            child: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 350,
                      child: CachedNetworkImage(
                        imageUrl: _c.news.value.image,
                        fit: BoxFit.cover,
                      ),
                    ),
                    14.ph,
                    AppTextNormal.labelBold(
                      _c.news.value.title,
                      24,
                      Colors.black,
                      maxLines: 3,
                      letterSpacing: 1.6,
                      height: 1.4,
                    ),
                    16.ph,
                    QuillEditor(
                      focusNode: FocusNode(),
                      scrollController: ScrollController(),
                      controller: _c.controller,
                      configurations: const QuillEditorConfigurations(
                        showCursor: false,
                        padding: EdgeInsets.all(16),
                        embedBuilders: [],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
