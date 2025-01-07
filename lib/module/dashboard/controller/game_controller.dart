import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starter_pack_web/module/challenge/model/quiz_session_m.dart';
import 'package:starter_pack_web/module/user/model/group_m.dart';
import 'package:starter_pack_web/utils/app_dialog.dart';
import 'package:uuid/uuid.dart';

import '../../../utils/app_constanta.dart';
import '../../user/model/user_m.dart';

class GameController extends GetxController {
  late SharedPreferences pref;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final RxList<QuizSessionM> quizess = <QuizSessionM>[].obs;
  final RxList<QuizSessionM> quizessSearch = <QuizSessionM>[].obs;
  final Rx<bool> isSearched = false.obs;

  final Rx<GroupM> group = groupEmpty.obs;

  Rx<int> currentPage = 1.obs;
  Rx<int> dataPerPage = 5.obs;

  final Rx<UserM> user = userEmpty.obs;

  TextEditingController tcPoint = TextEditingController();

  @override
  void onInit() async {
    pref = await SharedPreferences.getInstance();
    await getUser();
    await getSessionQuiz();
    super.onInit();
  }

  Future getUser() async {
    final userCache = pref.getString("user") ?? "";
    final userData = json.decode(userCache);
    user.value = UserM.fromJson(userData);
  }

  List<QuizSessionM> isUsingGame() {
    if (isSearched.value) {
      return quizessSearch;
    }
    return quizess;
  }

  int isTotalPage() {
    if (isSearched.value) {
      return (quizessSearch.length / dataPerPage.value).ceil() == 0
          ? 1
          : (quizessSearch.length / dataPerPage.value).ceil();
    }
    return (quizess.length / dataPerPage.value).ceil() == 0
        ? 1
        : (quizess.length / dataPerPage.value).ceil();
  }

  void onChangepage(int newValue) {
    currentPage.value = newValue;
  }

  void onSearched(String query) {
    double pageTemp = 0;
    List<QuizSessionM> quizTemp = [];
    if (query.isEmpty) {
      isSearched.value = false;
      quizTemp.clear();
      quizessSearch.clear();
    } else {
      isSearched.value = true;
      quizTemp = quizess
          .where((e) => e.userId.toLowerCase().contains(query.toLowerCase()))
          .toList();
      for (int i = 0; i < quizTemp.length; i++) {
        pageTemp = (i + 1) / dataPerPage.value;
        quizTemp[i] = quizTemp[i].copyWith(page: pageTemp.ceil());
      }
      quizessSearch.value = quizTemp;
    }
  }

  Future getSessionQuiz() async {
    final response = await firestore
        .collection("quiz_session")
        .where("isRated", isEqualTo: false)
        .where("isFinished", isEqualTo: true)
        .where("type", isEqualTo: "WELLNESS")
        .get();

    if (response.docs.isEmpty) {
      quizess.clear();
      return;
    }

    quizess.value =
        response.docs.map((doc) => QuizSessionM.fromJson(doc.data())).toList();
  }

  Future updateGame(QuizSessionM data) async {
    var id = const Uuid().v4();
    data = data.copyWith(
      isRated: true,
      isFinished: true,
      point: int.parse(tcPoint.text),
    );
    try {
      final body = {
        "id": id,
        "challenge_id": data.quizId,
        "user_id": user.value.id,
        "username": user.value.username,
        "point": int.parse(tcPoint.text),
        "createdAt": DateTime.now().toIso8601String(),
      };

      // var responseList = await firestore.collection('group').get();
      // if (responseList.docs.isNotEmpty) {
      //   var listGroup = responseList.docs.map((e) async {
      //     var dataGroup = GroupM.fromJson(e.data());
      //     dataGroup = dataGroup.copyWith(
      //       pointBefore: dataGroup.point,
      //       point: dataGroup.point,
      //     );
      //     await firestore
      //         .collection("group")
      //         .doc(group.value.id)
      //         .update(group.toJson());
      //     return dataGroup;
      //   }).toList();
      // }
      var response =
          await firestore.collection('group').doc(data.groupId).get();
      if (!response.exists) {
        AppDialog.dialogSnackbar("User group is not found");
        return;
      }
      group.value = GroupM.fromJson(response.data()!);

      group.value = group.value.copyWith(
        pointBefore: group.value.point,
        point: group.value.point + data.point,
      );
      await firestore
          .collection("group")
          .doc(group.value.id)
          .update(group.toJson());
      await firestore.collection("challenge_result").doc(id).set(body);
      await firestore
          .collection("quiz_session")
          .doc(data.sessionId)
          .update(data.toJson());
      getSessionQuiz();
      AppDialog.dialogSnackbar("Success to update challenge");
    } catch (e) {
      AppDialog.dialogSnackbar("Failed to update: $e");
    }
  }
}
