import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:starter_pack_web/module/news/model/news_m.dart';

class NewsController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final RxList<NewsM> news = <NewsM>[].obs;

  @override
  void onInit() async {
    await getNews();
    super.onInit();
  }

  Future getNews() async {
    final response = await firestore.collection("news").get();
    news.value = response.docs.map((e) {
      return NewsM.fromJson(e.data());
    }).toList();
    news.sort(
        (a, b) => DateTime.parse(b.date).compareTo(DateTime.parse(a.date)));
  }
}
