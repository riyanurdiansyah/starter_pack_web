import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
import '../../../utils/app_dialog.dart';
import '../../../utils/app_extension.dart';
import '../../dashboard/model/multiple_choice_m.dart';
import '../../user/model/group_m.dart';
import '../../user/model/user_m.dart';
import '../model/challenge_m.dart';

class ChallengeQuizController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  late DropzoneViewController dropzoneController;

  final Rx<ChallengeM> challenge = challengeEmpty.obs;

  final RxList<MultipleChoiceM> multipleChoices = <MultipleChoiceM>[].obs;

  Rx<String> id = "".obs;

  Rx<bool> isComingSoon = false.obs;

  Rx<int> point = 0.obs;

  Rx<int> indexNow = 0.obs;

  Rx<int> indexOptionHover = 99.obs;

  Rx<bool> isLoading = true.obs;

  Rx<bool> isStarting = false.obs;

  final Rx<bool> isQuestFinished = false.obs;

  Rx<bool> isHaveSession = false.obs;

  Rx<double> timeQuiz = 0.0.obs;

  Rx<double> timeToStart = 0.0.obs;

  Rx<double> uploadProgress = 0.0.obs;

  Rx<int> timeElapsed = 0.obs;

  Rx<int> timeElapsedCountdown = 0.obs;

  Timer? _timer;

  late Timer _timerCountdown;

  late SharedPreferences pref;

  final RxList<AnswerM> listAnswer = <AnswerM>[].obs;

  final Rx<UserM> user = userEmpty.obs;

  final Rx<bool> isFinished = false.obs;

  FilePickerResult? filePickerResult;

  final tcImage = TextEditingController();
  final tcRemark = TextEditingController();

  Rx<Uint8List?> imageBytes = null.obs;
  Rx<String> fileName = "".obs;

  Rx<Duration> remainingTime = Duration.zero.obs;

  Rx<bool> isLastQuestion = false.obs;

  final Rx<GroupM> group = groupEmpty.obs;
  final RxList<int> listCorrect = <int>[].obs;
  // final RxList<int> listIncorrect = <int>[].obs;
  @override
  void onInit() async {
    pref = await SharedPreferences.getInstance();
    await refreshAll();
    super.onInit();
  }

  @override
  void onClose() {
    if (_timer != null) {
      _timer?.cancel();
    }
    super.onClose();
  }

  Future refreshAll() async {
    await getUser();
    Future.delayed(const Duration(seconds: 1), () async {
      await getChallenge();
      await getSessionQuiz();

      Future.delayed(const Duration(seconds: 2), () async {
        await changeLoading(false);
      });
    });
  }

  Future getUser() async {
    final userCache = pref.getString("user") ?? "";
    final userData = json.decode(userCache);
    user.value = UserM.fromJson(userData);
  }

  String formatTime() {
    int hours = timeQuiz.value ~/ 3600; // Menghitung jumlah jam
    int minutes =
        (timeQuiz.value % 3600) ~/ 60; // Menghitung sisa menit setelah jam
    int remainingSeconds = (timeQuiz.value % 60).toInt();
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  Widget formatTimeCountdown() {
    int minutes = timeToStart.value ~/ 60;
    int remainingSeconds = (timeToStart.value % 60).toInt();
    return Text(
        '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}');
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
    for (var i = 0; i < sessionData.first.answers.length; i++) {
      if (sessionData.first.answers[i].isCorrect) {
        listCorrect.add(i);
      }
    }
    final session = sessionData.first;
    isHaveSession.value = true;
    id.value = session.sessionId;
    timeQuiz.value = session.time * 60;
    timeElapsed.value = 0;
    listAnswer.value = session.answers;
    isFinished.value = session.isFinished;
    point.value = session.point;
    startTimer();
  }

  void startTimer() {
    isStarting.value = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (DateTime.now().isAfter(DateTime.parse(challenge.value.end))) {
        if (isFinished.value == false) {
          saveSessionQuiz(true);
        }
        _timer?.cancel();
      } else if (timeQuiz.value > 0) {
        timeQuiz.value--;
        timeElapsed.value++;
        if (timeElapsed.value % 10 == 0) {
          if (isFinished.value == false) {
            saveSessionQuiz(false);
          }
        }
      } else {
        if (isFinished.value == false) {
          saveSessionQuiz(true);
        }
        _timer?.cancel();
      }
    });
  }

  void startTimerCountdown() {
    _timerCountdown = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeToStart.value > 0) {
        timeToStart.value--;
        timeElapsedCountdown.value++;
      } else {
        _timerCountdown.cancel();
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
      groupId: user.value.groupId,
      answers: listAnswer,
      time: isFinished ? 0 : timeQuiz.value / 60,
      point: point.value,
      isFinished: isFinished,
      isRated: true,
      type: challenge.value.type,
      username: user.value.username,
      page: 0,
      image: "",
      createdAt: DateTime.now().toIso8601String(),
    );

    if (isFinished) {
      var responseGroup =
          await firestore.collection('group').doc(user.value.groupId).get();
      if (!responseGroup.exists) {
        AppDialog.dialogSnackbar("User group is not found");
        return;
      }
      group.value = GroupM.fromJson(responseGroup.data()!);

      group.value = group.value.copyWith(
        pointBefore: group.value.point,
        point: group.value.point + point.value,
      );
      await firestore
          .collection("group")
          .doc(group.value.id)
          .update(group.toJson());
    }

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

  void startCountdown() {
    DateTime targetTime = DateTime.parse("2024-11-22T16:04:00.000");
    DateTime now = DateTime.now();
  }

  // Widget formatDuration() {

  //   // return Text("${hours.toString().padLeft(2, '0')}:"
  //   //     "${minutes.toString().padLeft(2, '0')}:"
  //   //     "${seconds.toString().padLeft(2, '0')}");
  // }

  Future getChallenge() async {
    final response =
        await firestore.collection("challenge").doc(id.value).get();
    if (response.exists) {
      challenge.value = ChallengeM.fromJson(response.data()!);
      if (DateTime.now().isBefore(DateTime.parse(challenge.value.start))) {
        remainingTime.value =
            DateTime.parse(challenge.value.start).difference(DateTime.now());
        if (remainingTime.value.isNegative) {
          remainingTime.value = Duration.zero;
          isComingSoon.value = false;
        } else {
          _timerCountdown = Timer.periodic(const Duration(seconds: 1), (timer) {
            if (remainingTime.value.inSeconds <= 0) {
              isComingSoon.value = false;
              timer.cancel();
              // refreshAll();
            } else {
              isComingSoon.value = true;
              remainingTime.value =
                  remainingTime.value - const Duration(seconds: 1);
            }
          });
        }
      }
      timeQuiz.value = DateTime.parse(challenge.value.end)
              .difference(DateTime.parse(challenge.value.start))
              .inMinutes *
          60;
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
      // listIncorrect.remove(index);
      if (!listCorrect.contains(indexNow.value)) {
        if (multipleChoices.length >= challenge.value.maxQuestion) {
          point.value +=
              challenge.value.maxPoint ~/ challenge.value.maxQuestion;
        } else {
          point.value += challenge.value.maxPoint ~/ multipleChoices.length;
        }
      }
      listCorrect.add(indexNow.value);
    } else {
      if (listCorrect.contains(indexNow.value)) {
        if (multipleChoices.length >= challenge.value.maxQuestion) {
          point.value -=
              challenge.value.maxPoint ~/ challenge.value.maxQuestion;
        } else {
          point.value -= challenge.value.maxPoint ~/ multipleChoices.length;
        }
        listCorrect.remove(indexNow.value);
      }
    }

    if ((indexNow.value + 1) == multipleChoices.length) {
      isQuestFinished.value = true;
      // showBottomSheet(navigatorKey.currentContext!);
    }
    listAnswer[indexNow.value] = AnswerM(
        indexAnswer: index,
        isCorrect: multipleChoices[indexNow.value].options[index].correct);
    // if ((indexNow.value + 1) != multipleChoices.length) {
    //   indexNow.value++;
    // }
  }

  void submitChallenge() {
    isQuestFinished.value = true;
    // showBottomSheet(navigatorKey.currentContext!);
  }

  void showBottomSheet(BuildContext context) {
    final isMiniMobile = MediaQuery.sizeOf(context).width < 400;
    final isMobile = MediaQuery.sizeOf(context).width < 600;
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
                  padding: EdgeInsets.only(
                      top: isMiniMobile
                          ? 330
                          : isMobile
                              ? 250
                              : 180,
                      bottom: 50),
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    margin: EdgeInsets.symmetric(
                        horizontal: isMiniMobile || isMobile ? 0 : 80),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        AppTextNormal.labelBold(
                          "Great job completing all the questions! Are you ready to submit your answers?",
                          12,
                          Colors.black,
                          maxLines: 10,
                          letterSpacing: 2.5,
                          height: 1.8,
                        ),
                        10.ph,
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Spacer(),
                            SizedBox(
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
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: colorPrimaryDark,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                onPressed: () async {
                                  _timer?.cancel();
                                  timeQuiz.value = 0;
                                  context.pop();
                                  await saveSessionQuiz(true);
                                  await getSessionQuiz();
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
      fileName.value = result.files.single.name;
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

  void saveChallengeWellfit() async {
    try {
      showDialog(
        context: navigatorKey.currentContext!,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          content: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(
                  color: colorPrimaryDark,
                ),
                18.ph,
                Obx(
                  () => AppTextNormal.labelW700(
                    "Uploading on progress ${uploadProgress.value.toInt()}",
                    14,
                    Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
      String downloadUrl = "";
      final fileBytes = filePickerResult?.files.single.bytes;
      final fileName = filePickerResult?.files.single.name;
      final storageRef =
          FirebaseStorage.instance.ref().child('assets/challenge/$fileName');

      // Membuat task upload
      final uploadTask = storageRef.putData(fileBytes!);

      // Menggunakan snapshotEvents untuk memantau progress
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) async {
        final progress =
            (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
        uploadProgress.value = progress;
        if (progress.toInt() == 100 && isFinished.value == false) {
          navigatorKey.currentContext!.pop();
          _timer?.cancel();
          isFinished.value = true;
          downloadUrl = await snapshot.ref.getDownloadURL();

          var data = QuizSessionM(
            userId: user.value.id,
            multipleChoices: multipleChoices,
            groupId: user.value.groupId,
            quizId: challenge.value.id,
            sessionId: id.value,
            answers: listAnswer,
            time: 0,
            point: point.value,
            page: 0,
            username: user.value.username,
            isFinished: true,
            isRated: false,
            type: challenge.value.type,
            image: downloadUrl,
            createdAt: DateTime.now().toIso8601String(),
          );
          await firestore
              .collection("quiz_session")
              .doc(data.sessionId)
              .update(data.toJson());
          // // Memeriksa apakah data session ada di Firestore
          // final response = await firestore.collection("quiz_session").get();
          // if (response.docs.isEmpty) {
          //   await firestore
          //       .collection("quiz_session")
          //       .doc(data.sessionId)
          //       .set(data.toJson());
          //   await getSessionQuiz();
          // } else {
          //   final sessions = response.docs
          //       .map((doc) => QuizSessionM.fromJson(doc.data()))
          //       .toList();
          //   final sessionData = sessions
          //       .where((e) =>
          //           e.userId == user.value.id && e.quizId == challenge.value.id)
          //       .toList();
          //   if (sessionData.isEmpty) {
          //     await firestore
          //         .collection("quiz_session")
          //         .doc(data.sessionId)
          //         .set(data.toJson());
          //     await getSessionQuiz();
          //   } else {
          //     data = data.copyWith(
          //       sessionId: sessionData.first.sessionId,
          //       multipleChoices: multipleChoices,
          //       answers: listAnswer,
          //       time: 0,
          //       image: downloadUrl,
          //       isFinished: true,
          //       isRated: false,
          //     );
          //     await firestore
          //         .collection("quiz_session")
          //         .doc(data.sessionId)
          //         .update(data.toJson());
          //     await getSessionQuiz();
          //   }
          // }

          AppDialog.dialogSnackbar("Success");
        }
      });

      // Mendapatkan URL download
    } catch (e) {
      navigatorKey.currentContext!.pop();
      AppDialog.dialogSnackbar("Error while saving : $e");
    }
  }

  void submitChallengeOK() async {
    _timer?.cancel();
    timeQuiz.value = 0;
    // navigatorKey.currentContext!.pop();
    await saveSessionQuiz(true);
    await getSessionQuiz();
  }
}
