import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:get/get.dart';
import 'package:starter_pack_web/module/news/model/news_m.dart';
import 'package:starter_pack_web/utils/app_constanta.dart';

class NewsDetailController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  Rx<String> id = "".obs;

  Rx<bool> isLoading = true.obs;

  Rx<bool> isHovered = true.obs;

  Rx<NewsM> news = newsEmpty.obs;

  quill.QuillController controller = () {
    return quill.QuillController.basic(
      configurations: const quill.QuillControllerConfigurations(),
    );
  }();

  @override
  void onInit() async {
    await getNews();
    Future.delayed(const Duration(seconds: 2), () async {
      await changeLoading(false);
    });
    super.onInit();
  }

  Future changeLoading(bool val) async {
    isLoading.value = val;
  }

  Future getNews() async {
    final response = await firestore
        .collection("news")
        .where("id", isEqualTo: id.value)
        .get();
    if (response.docs.isNotEmpty) {
      news.value = NewsM.fromJson(response.docs.first.data());
      controller.document =
          quill.Document.fromJson(json.decode(news.value.content));
    }
  }
}
