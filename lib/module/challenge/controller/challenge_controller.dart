import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:starter_pack_web/middleware/app_route.dart';
import 'package:starter_pack_web/module/challenge/model/challenge_m.dart';

import '../../../middleware/app_route_name.dart';

class ChallengeController extends GetxController
    with GetSingleTickerProviderStateMixin {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  late AnimationController animationController;
  late Animation<double> scaleAnimation;

  // final PageController pageController = PageController(viewportFraction: 0.8);
  RxList<bool> isHoveredList = <bool>[].obs;
  Rx<bool> isHovered = false.obs;

  Rx<int> currentIndex = 0.obs;

  RxList<ChallengeM> challenges = <ChallengeM>[].obs;

  Rx<double> widthDefault = 0.0.obs;

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }

  @override
  void onInit() async {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    scaleAnimation = Tween<double>(begin: 0, end: 10)
        .chain(
          CurveTween(curve: Curves.elasticIn),
        )
        .animate(animationController);
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
    isHoveredList.value = List.generate(challenges.length, (index) => false);
  }

  void handleTap(int index) {
    final bool isDisabled =
        DateTime.parse(challenges[index].start).isAfter(DateTime.now());
    if (isDisabled) {
      animationController.forward(from: 0);
      HapticFeedback.heavyImpact();
      return;
    }
    // Navigate to quiz page
    navigatorKey.currentContext!.goNamed(
      AppRouteName.quiz,
      pathParameters: {"id": challenges[index].id},
    );
  }

  List<ChallengeM> get visibleChallenges {
    return List.generate(
      4,
      (i) => challenges[(currentIndex.value + i) % challenges.length],
    );
  }
}
