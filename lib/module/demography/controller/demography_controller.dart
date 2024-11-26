import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../dashboard/model/demography_m.dart';

class DemographyController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final RxList<DemographyM> demographys = <DemographyM>[].obs;

  late AnimationController animationController;
  late Animation<double> animation;

  final Rx<bool> isHovered = false.obs;
  final Rx<bool> isHovered2 = false.obs;
  final Rx<bool> isHovered3 = false.obs;
  final Rx<bool> isWidgetVisible = false.obs;

  final Rx<int> selectedIndex = 99.obs;
  // final Rx<bool> isWidgetVisible2 = false.obs;
  // final Rx<bool> isWidgetVisible3 = false.obs;
  @override
  void onInit() async {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    animation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeInOut),
    );
    await getDemographys();
    super.onInit();
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }

  void toggleWidget(int index) {
    isWidgetVisible.value = !isWidgetVisible.value;
    Future.delayed(const Duration(milliseconds: 250), () {
      if (index != 99 &&
          !isWidgetVisible.value &&
          selectedIndex.value != index) {
        selectedIndex.value = index;
        isWidgetVisible.value = !isWidgetVisible.value;
      }
      selectedIndex.value = index;
    });
  }

  // void toggleWidget2() {
  //   isWidgetVisible2.value = !isWidgetVisible2.value;
  // }

  // void toggleWidget3() {
  //   isWidgetVisible3.value = !isWidgetVisible3.value;
  // }

  Future<List<DemographyM>> getDemographys() async {
    final response = await firestore.collection("demography").get();
    demographys.value = response.docs.map((e) {
      return DemographyM.fromJson(e.data());
    }).toList();
    demographys.sort((a, b) => a.name.compareTo(b.name));
    log("CEK DATA : ${demographys.map((e) => e.toJson())}");
    return demographys;
  }
}