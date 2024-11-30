import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:starter_pack_web/module/challenge/model/challenge_m.dart';
import 'package:starter_pack_web/module/dashboard/model/multiple_choice_m.dart';
import 'package:starter_pack_web/utils/app_constanta.dart';
import 'package:uuid/uuid.dart';

import '../../../utils/app_dialog.dart';

class ChallengesetDetailController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final Rx<int> indexSelected = 999.obs;

  final Rx<String> id = "".obs;

  final Rx<ChallengeM> challenge = challengeEmpty.obs;

  final RxList<MultipleChoiceM> multipleChoices = <MultipleChoiceM>[].obs;

  final formKey = GlobalKey<FormState>();

  final tcQuestion = TextEditingController();

  List<TextEditingController> tcOptions = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];

  final RxList<Option> options = <Option>[].obs;
  @override
  void onInit() async {
    Future.delayed(const Duration(seconds: 1), () async {
      await getChallenge();
    });
    super.onInit();
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
      }
    }
  }

  void saveMultipleChoice(MultipleChoiceM? oldMultipleChoice) {
    MultipleChoiceM newMultipleChoice;
    try {
      if (oldMultipleChoice != null) {
        newMultipleChoice = oldMultipleChoice.copyWith(
          question: tcQuestion.text,
          options: options,
        );
        firestore
            .collection("questions")
            .doc(newMultipleChoice.id)
            .update(newMultipleChoice.toJson());
      } else {
        newMultipleChoice = MultipleChoiceM(
          question: tcQuestion.text,
          options: options,
          challengeId: id.value,
          id: const Uuid().v4(),
          type: "multiple_choice",
        );
        firestore
            .collection("questions")
            .doc(newMultipleChoice.id)
            .set(newMultipleChoice.toJson());
      }
      getChallenge();
      AppDialog.dialogSnackbar("Data has been saved");
    } catch (e) {
      AppDialog.dialogSnackbar("Error while saving : $e");
    }
  }

  void deleteMultipleChoice(MultipleChoiceM multipleChoic) {
    try {
      firestore.collection("questions").doc(multipleChoic.id).delete();
      indexSelected.value = 999;
      getChallenge();
      AppDialog.dialogSnackbar("Data has been deleted");
    } catch (e) {
      AppDialog.dialogSnackbar("Error while deleting : $e");
    }
  }
}
