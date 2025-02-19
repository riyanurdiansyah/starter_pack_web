import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  late DropzoneViewController dropzoneController2;

  final Rx<ChallengeM> challenge = challengeEmpty.obs;

  final RxList<MultipleChoiceM> multipleChoices = <MultipleChoiceM>[].obs;

  Rx<String> id = "".obs;

  Rx<bool> isComingSoon = false.obs;

  Rx<double> point = 0.0.obs;

  Rx<int> indexNow = 0.obs;

  Rx<int> indexOptionHover = 99.obs;

  Rx<bool> isLoading = true.obs;

  Rx<bool> isStarting = false.obs;

  Rx<bool> isSubmitting = false.obs;

  final Rx<bool> isQuestFinished = false.obs;

  Rx<bool> isHaveSession = false.obs;

  Rx<double> timeQuiz = 0.0.obs;

  Rx<double> timeToStart = 0.0.obs;

  Rx<double> uploadProgress = 0.0.obs;

  Rx<int> timeElapsed = 0.obs;

  Rx<int> timeElapsedCountdown = 0.obs;

  Rx<int> maxPoint = 0.obs;

  Timer? _timer;

  late Timer _timerCountdown;

  late SharedPreferences pref;

  final RxList<AnswerM> listAnswer = <AnswerM>[].obs;

  final Rx<UserM> user = userEmpty.obs;

  final Rx<bool> isFinished = false.obs;

  FilePickerResult? filePickerResult;
  FilePickerResult? filePickerResult2;

  final tcImage = TextEditingController();
  final tcImage2 = TextEditingController();
  final tcRemark = TextEditingController();

  Rx<Uint8List?> imageBytes = null.obs;
  Rx<Uint8List?> imageBytes2 = null.obs;
  Rx<String> fileName = "".obs;
  Rx<String> fileName2 = "".obs;

  Rx<Duration> remainingTime = Duration.zero.obs;

  Rx<bool> isLastQuestion = false.obs;

  Rx<DateTime> dateNow = DateTime.now().obs;

  // RxList<LeaderboardM> leaderboards;

  final Rx<GroupM> group = groupEmpty.obs;
  final RxList<int> listCorrect = <int>[].obs;
  // final RxList<int> listIncorrect = <int>[].obs;
  @override
  void onInit() async {
    await getDateServer();
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
      multipleChoices.shuffle();
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
    // timeQuiz.value = session.time * 60;
    timeElapsed.value = 0;
    listAnswer.value = session.answers;
    isFinished.value = session.isFinished;
    point.value = session.point;
    startTimer();
  }

  void startTimer() {
    log("MASUK");
    if (isStarting.value) return;
    isStarting.value = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (dateNow.value.isAfter(DateTime.parse(challenge.value.end))) {
        _timer?.cancel();
      } else if (timeQuiz.value > 0) {
        DateTime startDate = DateTime.parse(challenge.value.start);
        DateTime endDate = DateTime.parse(challenge.value.end);
        // DateTime now = dateNow.value;

        Duration difference = endDate.difference(startDate);
        Duration differenceNow = endDate.difference(dateNow.value);

// Mendapatkan perbedaan dalam jam
        int hoursDifference = difference.inHours;
        int hoursDifferenceNow = differenceNow.inHours;

        // Duration difference = endDate.difference(now);
        // double hoursDifference = difference.inMinutes / 60;
        if (hoursDifferenceNow < hoursDifference) {
          hoursDifferenceNow = hoursDifferenceNow + 1;
        }
        maxPoint.value = ((challenge.value.maxPoint / 2) +
                ((challenge.value.maxPoint / 2) *
                    (hoursDifferenceNow / hoursDifference)))
            .floor();
        if ((challenge.value.maxPoint / 2) > maxPoint.value) {
          maxPoint.value = (challenge.value.maxPoint / 2).floor();
        }

        timeQuiz.value--;
        timeElapsed.value++;
        if (timeElapsed.value % 10 == 0) {
          if (isFinished.value == false) {
            if (!challenge.value.type.toLowerCase().contains("wellness")) {
              // saveSessionQuiz(false);
            }
          }
        }
      } else {
        if (isFinished.value == false) {
          // saveSessionQuiz(true);
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

    try {
      // Buat data QuizSessionM
      var data = QuizSessionM(
        updatedAt: dateNow.value.toIso8601String(),
        userId: user.value.id,
        multipleChoices: multipleChoices,
        quizId: challenge.value.id,
        sessionId: uuid,
        groupId: user.value.groupId,
        answers: listAnswer,
        time: isFinished ? 0 : timeQuiz.value / 60,
        point: point.value.roundToDouble(),
        isFinished: isFinished,
        isRated: false,
        type: challenge.value.type,
        username: user.value.username,
        page: 0,
        image: "",
        remark: tcRemark.text,
        isUsePrivillege: false,
        isRevenue: challenge.value.isRevenue,
        createdAt: dateNow.value.toIso8601String(),
      );
      await firestore.runTransaction((transaction) async {
        // Check and update quiz session
        final sessionQuery = await firestore
            .collection("quiz_session")
            .where('userId', isEqualTo: user.value.id)
            .where('quizId', isEqualTo: challenge.value.id)
            .get();

        if (isFinished) {
          final sessions =
              QuizSessionM.fromJson(sessionQuery.docs.first.data());
          if (!sessions.isFinished) {
            final groupDoc =
                firestore.collection('group').doc(user.value.groupId);

            final responseGroup = await transaction.get(groupDoc);
            if (!responseGroup.exists) {
              throw Exception("User group is not found");
            }

            final groupData = GroupM.fromJson(responseGroup.data()!);

            // Increment group points by the quiz point
            if (!challenge.value.isSpecialChallenge) {
              if (challenge.value.isRevenue) {
                transaction.update(groupDoc, {
                  'point_before': groupData.point,
                  'revenue': FieldValue.increment(point.value
                      .roundToDouble()), // Increment point by the value
                });
              } else {
                transaction.update(groupDoc, {
                  'point_before': groupData.point,
                  'point': FieldValue.increment(point.value
                      .roundToDouble()), // Increment point by the value
                });
              }
            }
          }
        }

        if (sessionQuery.docs.isEmpty) {
          final newSessionDoc =
              firestore.collection("quiz_session").doc(data.sessionId);
          transaction.set(newSessionDoc, data.toJson());
        } else {
          final existingSession = sessionQuery.docs.first;
          data = data.copyWith(
            sessionId: existingSession.id,
            multipleChoices: multipleChoices,
            answers: listAnswer,
            time: timeQuiz.value / 60,
          );
          // Update group points if the quiz is finished

          transaction.update(existingSession.reference, data.toJson());
        }
      });

      // Snackbar success
      // AppDialog.dialogSnackbar("Quiz submit successfully.");
    } catch (e) {
      // Handle errors and display a failure message
      // AppDialog.dialogSnackbar(
      //     "Failed to submit quiz session: ${e.toString()}");
    }
  }

  Future changeLoading(bool val) async {
    isLoading.value = val;
  }

  void startCountdown() {
    DateTime targetTime = DateTime.parse("2024-11-22T16:04:00.000");
    DateTime now = dateNow.value;
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
      if (dateNow.value.isBefore(DateTime.parse(challenge.value.start))) {
        remainingTime.value =
            DateTime.parse(challenge.value.start).difference(dateNow.value);
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
              .difference(dateNow.value)
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
              (maxPoint / challenge.value.maxQuestion).ceilToDouble();
        } else {
          point.value += (maxPoint / multipleChoices.length).ceilToDouble();
        }
      }
      listCorrect.add(indexNow.value);
    } else {
      if (listCorrect.contains(indexNow.value)) {
        if (multipleChoices.length >= challenge.value.maxQuestion) {
          point.value -=
              (maxPoint / challenge.value.maxQuestion).ceilToDouble();
        } else {
          point.value -= (maxPoint / multipleChoices.length).ceilToDouble();
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

  void pickImage2() async {
    final result = await pickFile();
    filePickerResult2 = result;

    if (result != null) {
      fileName2.value = result.files.single.name;
    } else {
      tcImage2.clear();
    }
  }

  void onDrop(dynamic event) async {
    final bytes = await dropzoneController.getFileData(event);
    final name = await dropzoneController.getFilename(event);
    imageBytes.value = bytes;
    fileName.value = name;
  }

  void onDrop2(dynamic event) async {
    final bytes = await dropzoneController2.getFileData(event);
    final name = await dropzoneController2.getFilename(event);
    imageBytes2.value = bytes;
    fileName2.value = name;
  }

  Future<Map<String, dynamic>> uploadsFile() async {
    var data = <String, dynamic>{};
    // Inisialisasi variabel file pertama
    final fileBytes1 = filePickerResult!.files.single.bytes!;
    final fileName1 = filePickerResult!.files.single.name;
    final storageRef1 = FirebaseStorage.instance
        .ref()
        .child('assets/challenges/${challenge.value.name}/$fileName1');

    // Inisialisasi variabel file kedua

    // Metadata untuk kedua file
    final metadata1 = SettableMetadata(
      contentType: 'image/${fileName1.split('.').last}',
    );

    // Membuat task upload untuk kedua file
    final uploadTask1 = await storageRef1.putData(fileBytes1, metadata1);

    data["url"] = await storageRef1.getDownloadURL();

    if (challenge.value.type == "MULTIPLE WELLNESS") {
      final fileBytes2 = filePickerResult2!.files.single.bytes!;
      final fileName2 = filePickerResult2!.files.single.name;
      final metadata2 = SettableMetadata(
        contentType: 'image/${fileName2.split('.').last}',
      );
      final storageRef2 = FirebaseStorage.instance
          .ref()
          .child('assets/challenges/${challenge.value.name}/$fileName2');

      final uploadTask2 = await storageRef2.putData(fileBytes2, metadata2);
      data["url2"] = await storageRef2.getDownloadURL();
    }

    // Mendengarkan progress upload kedua file
    // String downloadUrl1 = "";
    // String downloadUrl2 = "";

    // await Future.wait([
    //   await uploadTask1.snapshotEvents.listen((TaskSnapshot snapshot) async {
    //     final progress =
    //         (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
    //     uploadProgress.value = progress / 2; // Karena ada 2 file
    //     if (snapshot.state == TaskState.success) {
    //       data["url"] = await snapshot.ref.getDownloadURL();
    //     }
    //   }).asFuture(),
    //   await uploadTask2.snapshotEvents.listen((TaskSnapshot snapshot) async {
    //     final progress =
    //         (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
    //     uploadProgress.value = 50 + (progress / 2); // Progres file kedua
    //     if (snapshot.state == TaskState.success) {
    //       data["url2"] = await snapshot.ref.getDownloadURL();
    //     }
    //   }).asFuture(),
    // ]);
    return data;
  }

  void saveChallengeWellfit() async {
    changeLoading(true);
    // Menampilkan dialog loading
    // showDialog(
    //   context: navigatorKey.currentContext!,
    //   barrierDismissible: false,
    //   builder: (context) => AlertDialog(
    //     backgroundColor: Colors.white,
    //     shape: RoundedRectangleBorder(
    //       borderRadius: BorderRadius.circular(4),
    //     ),
    //     content: Padding(
    //       padding: const EdgeInsets.all(16),
    //       child: Column(
    //         mainAxisSize: MainAxisSize.min,
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: [
    //           const CircularProgressIndicator(
    //             color: colorPrimaryDark,
    //           ),
    //           const SizedBox(height: 18),
    //           Obx(
    //             () => AppTextNormal.labelW700(
    //               "Uploading on progress ${uploadProgress.value.toInt()}%",
    //               14,
    //               Colors.grey.shade600,
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );

    try {
      // Validasi file pertama
      if (filePickerResult == null ||
          filePickerResult?.files.single.bytes == null) {
        AppDialog.dialogSnackbar("First file is not valid");
        return;
      }

      // Validasi file kedua
      if (challenge.value.type == "MULTIPLE WELLNESS") {
        if (filePickerResult2 == null ||
            filePickerResult2?.files.single.bytes == null) {
          AppDialog.dialogSnackbar("Second file is not valid");
          return;
        }
      }
      final res = await uploadsFile();
      // Validasi URL download
      if (res["url"].isEmpty) {
        await changeLoading(false);
        AppDialog.dialogSnackbar("Failed to upload one or more files");
        return;
      }

      if (challenge.value.type == "MULTIPLE WELLNESS" && res["url2"].isEmpty) {
        await changeLoading(false);
        AppDialog.dialogSnackbar("Failed to upload one or more files");
        return;
      }

      // Membuat data untuk Firestore
      var data = QuizSessionM(
        userId: user.value.id,
        multipleChoices: multipleChoices,
        groupId: user.value.groupId,
        quizId: challenge.value.id,
        sessionId: id.value,
        answers: listAnswer,
        time: 0,
        point: point.value,
        isUsePrivillege: false,
        page: 0,
        username: user.value.username,
        isFinished: true,
        isRated: false,
        type: challenge.value.type,
        image: challenge.value.type == "WELLNESS"
            ? res["url"]
            : "${res["url"]}||${res["url2"]}", // Simpan URL file pertama
        isRevenue: false,
        remark: tcRemark.text,
        updatedAt: dateNow.value.toIso8601String(),
        createdAt: dateNow.value.toIso8601String(),
      );

      // Menambahkan URL file kedua (opsional)

      // Menyimpan data ke Firestore
      await firestore
          .collection("quiz_session")
          .doc(data.sessionId)
          .update(data.toJson());
      await getSessionQuiz();
      await changeLoading(false);
      AppDialog.dialogSnackbar("Success");
    } catch (e) {
      await changeLoading(false);
      AppDialog.dialogSnackbar("Error while saving: $e");
    }
  }

  void submitChallengeOK() async {
    if (isSubmitting.value) return;
    onChangeSubmitting(true);
    _timer?.cancel();
    timeQuiz.value = 0;
    await saveSessionQuiz(true);
    await getSessionQuiz();
    await onChangeSubmitting(false);
  }

  Future onChangeSubmitting(bool val) async {
    isSubmitting.value = val;
  }

  Future getDateServer() async {
    try {
      final HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('getServerTime');
      final result = await callable.call();
      dateNow.value = DateTime.parse(result.data["time"]);
      startGlobalTime();
    } catch (e) {
      log("CEK ERROR : $e");
    }
  }

  void startGlobalTime() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      // Increment the time by 1 second each time
      dateNow.value = dateNow.value.add(const Duration(seconds: 1));
    });
  }
}
