import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:starter_pack_web/module/challenge/model/challenge_m.dart';

class ChallengeController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // final PageController pageController = PageController(viewportFraction: 0.8);
  RxList<bool> isHoveredList = List.generate(4, (index) => false).obs;
  Rx<bool> isHovered = false.obs;

  Rx<int> currentIndex = 0.obs;

  RxList<ChallengeM> challenges = <ChallengeM>[].obs;

  Rx<double> widthDefault = 0.0.obs;

  @override
  void onInit() async {
    await getChallenges();
    super.onInit();
  }

  void nextImage() {
    currentIndex.value = (currentIndex.value + 1) % challenges.length;
  }

  void previousImage() {
    currentIndex.value =
        (currentIndex.value - 1 + challenges.length) % challenges.length;
  }

  Future getChallenges() async {
    final response = await firestore.collection("challenge").get();

    challenges.value = response.docs.map((e) {
      return ChallengeM.fromJson(e.data());
    }).toList();

    challenges.sort((a, b) => a.no.compareTo(b.no));
  }
}
