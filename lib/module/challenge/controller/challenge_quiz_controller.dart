import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:starter_pack_web/module/challenge/model/answer_m.dart';

import '../../../utils/app_constanta.dart';
import '../../dashboard/model/multiple_choice_m.dart';
import '../model/challenge_m.dart';

class ChallengeQuizController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final Rx<ChallengeM> challenge = challengeEmpty.obs;

  final RxList<MultipleChoiceM> multipleChoices = <MultipleChoiceM>[].obs;

  Rx<String> id = "".obs;

  Rx<int> point = 0.obs;

  Rx<int> indexNow = 0.obs;

  Rx<int> indexOptionHover = 99.obs;

  Rx<bool> isLoading = true.obs;

  final RxList<AnswerM> listAnswer = <AnswerM>[].obs;

  @override
  void onInit() async {
    Future.delayed(const Duration(seconds: 1), () async {
      await getChallenge();

      Future.delayed(const Duration(seconds: 2), () async {
        await changeLoading(false);
      });
    });
    super.onInit();
  }

  Future changeLoading(bool val) async {
    isLoading.value = val;
  }

  Future getChallenge() async {
    final response =
        await firestore.collection("challenge").doc(id.value).get();
    if (response.exists) {
      challenge.value = ChallengeM.fromJson(response.data()!);
      final responseDetails = await firestore
          .collection("questions")
          .where("challenge_id", isEqualTo: id.value)
          .get();
      if (responseDetails.docs.isNotEmpty) {
        multipleChoices.value = responseDetails.docs
            .map((doc) => MultipleChoiceM.fromJson(doc.data()))
            .toList();

        if (multipleChoices.length > 10) {
          listAnswer.value = List.generate(
              10, (index) => AnswerM(indexAnswer: 99, isCorrect: false));
        } else {
          listAnswer.value = List.generate(multipleChoices.length,
              (index) => AnswerM(indexAnswer: 99, isCorrect: false));
          log("$listAnswer");
        }
      }
    }
  }

  void onSelectOption(int index) {
    if (multipleChoices[indexNow.value].options[index].correct) {
      point.value += challenge.value.maxPoint ~/ challenge.value.maxQuestion;
    } else {
      if (point.value > 0 && listAnswer[indexNow.value].isCorrect) {
        point.value -= challenge.value.maxPoint ~/ challenge.value.maxQuestion;
      }
    }
    listAnswer[indexNow.value] = AnswerM(
        indexAnswer: index,
        isCorrect: multipleChoices[indexNow.value].options[index].correct);
    if ((indexNow.value + 1) != multipleChoices.length) {
      indexNow.value++;
    }
  }
}
