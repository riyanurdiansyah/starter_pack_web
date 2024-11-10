import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:starter_pack_web/module/challenge/model/challenge_m.dart';

class ChallengesetController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  RxList<ChallengeM> challenges = <ChallengeM>[].obs;
  RxList<ChallengeM> challengesSearch = <ChallengeM>[].obs;

  final Rx<bool> isSearched = false.obs;

  Rx<int> currentPage = 1.obs;
  Rx<int> dataPerPage = 8.obs;

  @override
  void onInit() async {
    await getChallenges();
    super.onInit();
  }

  Future<List<ChallengeM>> getChallenges() async {
    final response = await firestore.collection("challenge").get();
    challenges.value = response.docs.map((e) {
      return ChallengeM.fromJson(e.data());
    }).toList();
    challenges.sort((a, b) => a.name.compareTo(b.name));

    double pageTemp = 0;
    for (int i = 0; i < challenges.length; i++) {
      pageTemp = (i + 1) ~/ 8 < 1 ? 1 : (i + 1) / 8;
      challenges[i] = challenges[i].copyWith(page: pageTemp.ceil());
    }
    return challenges;
  }

  List<ChallengeM> isUsingChallenges() {
    if (isSearched.value) {
      return challengesSearch
          .where((e) => e.page == currentPage.value)
          .toList();
    }
    return challenges.where((e) => e.page == currentPage.value).toList();
  }

  void onSearched(String query) {
    double pageTemp = 0;
    List<ChallengeM> challengesTemp = [];
    if (query.isEmpty) {
      isSearched.value = false;
      challengesTemp.clear();
      challengesSearch.clear();
    } else {
      isSearched.value = true;
      challengesTemp = challenges
          .where((e) => e.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
      for (int i = 0; i < challengesTemp.length; i++) {
        pageTemp = (i + 1) / dataPerPage.value;
        challengesTemp[i] = challengesTemp[i].copyWith(page: pageTemp.ceil());
      }
      challengesSearch.value = challengesTemp;
      challengesSearch.sort((a, b) => a.name.compareTo(b.name));
    }
  }

  int isTotalPage() {
    if (isSearched.value) {
      return (challengesSearch.length / dataPerPage.value).ceil() == 0
          ? 1
          : (challengesSearch.length / dataPerPage.value).ceil();
    }
    return (challenges.length / dataPerPage.value).ceil() == 0
        ? 1
        : (challenges.length / dataPerPage.value).ceil();
  }

  void onChangepage(int newValue) {
    currentPage.value = newValue;
  }
}
