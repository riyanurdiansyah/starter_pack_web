import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starter_pack_web/middleware/app_route.dart';
import 'package:starter_pack_web/module/challenge/model/answer_m.dart';
import 'package:starter_pack_web/module/challenge/model/quiz_session_m.dart';
import 'package:starter_pack_web/utils/app_images.dart';
import 'package:starter_pack_web/utils/app_text.dart';
import 'package:uuid/uuid.dart';

import '../../../utils/app_color.dart';
import '../../../utils/app_constanta.dart';
import '../../../utils/app_extension.dart';
import '../../dashboard/model/multiple_choice_m.dart';
import '../../user/model/user_m.dart';
import '../model/challenge_m.dart';

class ChallengeQuizController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  late DropzoneViewController dropzoneController;

  final Rx<ChallengeM> challenge = challengeEmpty.obs;

  final RxList<MultipleChoiceM> multipleChoices = <MultipleChoiceM>[].obs;

  Rx<String> id = "".obs;

  Rx<int> point = 0.obs;

  Rx<int> indexNow = 0.obs;

  Rx<int> indexOptionHover = 99.obs;

  Rx<bool> isLoading = true.obs;

  Rx<bool> isStarting = false.obs;

  final Rx<bool> isQuestFinished = false.obs;

  Rx<bool> isHaveSession = false.obs;

  Rx<double> timeQuiz = 0.0.obs;

  Rx<int> timeElapsed = 0.obs;

  late Timer _timer;

  late SharedPreferences pref;

  final RxList<AnswerM> listAnswer = <AnswerM>[].obs;

  final Rx<UserM> user = userEmpty.obs;

  final Rx<bool> isFinished = false.obs;

  FilePickerResult? filePickerResult;

  final tcImage = TextEditingController();

  Rx<Uint8List?> imageBytes = null.obs;
  Rx<String> fileName = "".obs;

  @override
  void onInit() async {
    pref = await SharedPreferences.getInstance();
    await getUser();
    Future.delayed(const Duration(seconds: 1), () async {
      await getChallenge();
      await getSessionQuiz();

      Future.delayed(const Duration(seconds: 2), () async {
        await changeLoading(false);
      });
    });
    super.onInit();
  }

  Future getUser() async {
    final userCache = pref.getString("user") ?? "";
    final userData = json.decode(userCache);
    user.value = UserM.fromJson(userData);
  }

  String formatTime() {
    int minutes = timeQuiz.value ~/ 60;
    int remainingSeconds = (timeQuiz.value % 60).toInt();
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  Future getSessionQuiz() async {
    final response = await firestore
        .collection("quiz_session")
        .where("userId", isEqualTo: user.value.id)
        .where("quizId", isEqualTo: challenge.value.id)
        .get();

    if (response.docs.isEmpty) {
      return;
    }

    final sessions =
        response.docs.map((doc) => QuizSessionM.fromJson(doc.data())).toList();

    final sessionData = sessions
        .where(
            (e) => e.userId == user.value.id && e.quizId == challenge.value.id)
        .toList();

    if (sessionData.isEmpty) {
      return;
    }

    final session = sessionData.first;
    isHaveSession.value = true;
    id.value = session.sessionId;
    timeQuiz.value = session.time * 60;
    timeElapsed.value = 0;
    listAnswer.value = session.answers;
    isFinished.value = session.isFinished;
    if (!session.isFinished) {
      startTimer();
    }
  }

  void startTimer() {
    isStarting.value = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeQuiz.value > 0) {
        timeQuiz.value--;
        timeElapsed.value++;
        if (timeElapsed.value % 10 == 0) {
          // saveSessionQuiz(false);
        }
      } else {
        saveSessionQuiz(true);
        _timer.cancel();
      }
    });
  }

  Future saveSessionQuiz(bool isFinished) async {
    final uuid = const Uuid().v4();
    var data = QuizSessionM(
      userId: user.value.id,
      multipleChoices: multipleChoices,
      quizId: challenge.value.id,
      sessionId: uuid,
      answers: listAnswer,
      time: isFinished ? 0 : timeQuiz.value / 60,
      point: point.value,
      isFinished: isFinished,
    );

    final response = await firestore.collection("quiz_session").get();
    if (response.docs.isEmpty) {
      await firestore
          .collection("quiz_session")
          .doc(data.sessionId)
          .set(data.toJson());
    } else {
      final sessions = response.docs
          .map((doc) => QuizSessionM.fromJson(doc.data()))
          .toList();
      final sessionData = sessions
          .where((e) =>
              e.userId == user.value.id && e.quizId == challenge.value.id)
          .toList();
      if (sessionData.isEmpty) {
        await firestore
            .collection("quiz_session")
            .doc(data.sessionId)
            .set(data.toJson());
      } else {
        data = data.copyWith(
          sessionId: sessionData.first.sessionId,
          multipleChoices: multipleChoices,
          answers: listAnswer,
          time: timeQuiz.value / 60,
        );
        await firestore
            .collection("quiz_session")
            .doc(data.sessionId)
            .update(data.toJson());
      }
    }
  }

  Future changeLoading(bool val) async {
    isLoading.value = val;
  }

  Future getChallenge() async {
    final response =
        await firestore.collection("challenge").doc(id.value).get();
    if (response.exists) {
      challenge.value = ChallengeM.fromJson(response.data()!);
      timeQuiz.value = challenge.value.time * 60;
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

    if ((indexNow.value + 1) == multipleChoices.length) {
      isQuestFinished.value = true;
      showBottomSheet(navigatorKey.currentContext!);
    }
    listAnswer[indexNow.value] = AnswerM(
        indexAnswer: index,
        isCorrect: multipleChoices[indexNow.value].options[index].correct);
    if ((indexNow.value + 1) != multipleChoices.length) {
      indexNow.value++;
    }
  }

  void showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          maxChildSize: 0.9,
          minChildSize: 0.4,
          builder: (_, scrollController) {
            return Stack(
              children: [
                // Gambar di belakang
                Positioned.fill(
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 150),
                    alignment: Alignment.centerLeft,
                    width: 800,
                    height: 500,
                    child: Image.asset(
                      andyImg,
                      width: 300,
                    ),
                  ),
                ),
                // Konten di atas
                Padding(
                  padding: const EdgeInsets.only(top: 300),
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(12),
                    height: 150,
                    margin: const EdgeInsets.only(top: 50),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        AppTextNormal.labelBold(
                          "Great job completing all the questions! Are you ready to submit your answers?",
                          18,
                          Colors.black,
                          maxLines: 10,
                          letterSpacing: 2.5,
                          height: 1.8,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Spacer(),
                            SizedBox(
                              height: 40,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey.shade400,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    )),
                                onPressed: () {
                                  isQuestFinished.value = false;
                                  context.pop();
                                },
                                child: AppTextNormal.labelBold(
                                  "CANCEL",
                                  14,
                                  Colors.white,
                                  letterSpacing: 1.6,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            SizedBox(
                              height: 40,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: colorPrimaryDark,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                onPressed: () async {
                                  timeQuiz.value = 0;
                                  saveSessionQuiz(true);
                                  getSessionQuiz();
                                  context.pop();
                                },
                                child: AppTextNormal.labelBold(
                                  "SUBMIT",
                                  14,
                                  Colors.white,
                                  letterSpacing: 1.6,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    // child: ListView.builder(
                    //   controller: scrollController,
                    //   itemCount: 20,
                    //   itemBuilder: (_, index) => ListTile(
                    //     title: Text('Item ${index + 1}'),
                    //   ),
                    // ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void pickImage() async {
    final result = await pickFile();

    filePickerResult = result;

    if (result != null) {
      tcImage.text = result.files.single.name;
    } else {
      tcImage.clear();
    }
  }

  void onDrop(dynamic event) async {
    final bytes = await dropzoneController.getFileData(event);
    final name = await dropzoneController.getFilename(event);
    imageBytes.value = bytes;
    fileName.value = name;
  }
}
