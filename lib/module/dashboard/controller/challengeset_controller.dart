import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:starter_pack_web/module/challenge/model/challenge_m.dart';
import 'package:starter_pack_web/utils/app_dialog.dart';
import 'package:uuid/uuid.dart';

class ChallengesetController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  RxList<ChallengeM> challenges = <ChallengeM>[].obs;
  RxList<ChallengeM> challengesSearch = <ChallengeM>[].obs;

  final Rx<bool> isSearched = false.obs;

  FilePickerResult? filePickerResult;

  DateTime? selectedDate;

  DateTime? selectedEndDate;

  Rx<int> currentPage = 1.obs;
  Rx<int> dataPerPage = 8.obs;

  final formKey = GlobalKey<FormState>();

  final tcDate = TextEditingController();
  final tcEndDate = TextEditingController();
  final tcChallenge = TextEditingController();
  final tcTime = TextEditingController();
  final tcMaxQuestion = TextEditingController();
  final tcMaxPoint = TextEditingController();
  final tcType = TextEditingController();
  final tcImage = TextEditingController();

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

  void saveChallenge({ChallengeM? oldChallenge}) async {
    try {
      String downlodUrl = "";
      if (oldChallenge == null) {
        final fileBytes = filePickerResult?.files.single.bytes;
        final fileName = filePickerResult?.files.single.name;
        final storageRef =
            FirebaseStorage.instance.ref().child('assets/challenge/$fileName');

        final uploadTask = storageRef.putData(fileBytes!);

        final snapshot = await uploadTask.whenComplete(() {});

        downlodUrl = await snapshot.ref.getDownloadURL();
      }
      CollectionReference challengeCollection =
          firestore.collection('challenge');
      final id = const Uuid().v4();
      ChallengeM challenge = ChallengeM(
        id: oldChallenge != null ? oldChallenge.id : id,
        image: oldChallenge != null ? oldChallenge.image : downlodUrl,
        name: tcChallenge.text,
        no: 0,
        type: tcType.text,
        route: "challenge",
        start: selectedDate?.toIso8601String() ?? "",
        end: selectedEndDate?.toIso8601String() ?? "",
        page: 0,
        time: int.parse(tcTime.text),
        maxPoint: int.parse(tcMaxPoint.text),
        maxQuestion: int.parse(tcMaxQuestion.text),
      );
      if (oldChallenge != null) {
        challengeCollection.doc(oldChallenge.id).update(challenge.toJson());
        AppDialog.dialogSnackbar("Data has been updated");
      } else {
        challengeCollection.doc(id).set(challenge.toJson());
        AppDialog.dialogSnackbar("Data has been created");
      }
      clearAllData();
      getChallenges();
    } catch (e) {
      AppDialog.dialogSnackbar("Error while saving : $e");
    }
  }

  void clearAllData() {
    tcChallenge.clear();
    tcDate.clear();
    tcEndDate.clear();
    tcImage.clear();
    filePickerResult = null;
    selectedDate = null;
    selectedEndDate = null;
  }

  void deleteData(ChallengeM data) async {
    try {
      final firebaseStorageRef =
          FirebaseStorage.instance.refFromURL(data.image);

      await firebaseStorageRef.delete();

      final documentRef = firestore.collection('challenge').doc(data.id);

      await documentRef.delete();
      getChallenges();
      AppDialog.dialogSnackbar("Data has been deleted");
    } catch (e) {
      AppDialog.dialogSnackbar("Error while deleting : $e");
    }
  }

  void setChallengeToDialog(ChallengeM oldChallenge) {
    tcChallenge.text = oldChallenge.name;
    tcType.text = oldChallenge.type;
    tcDate.text =
        "${DateFormat("dd/MM/yyyy HH:mm").format(DateTime.parse(oldChallenge.start))} WIB";
    selectedDate = DateTime.parse(oldChallenge.start);
    if (oldChallenge.end.isNotEmpty) {
      selectedEndDate = DateTime.parse(oldChallenge.end);
      tcEndDate.text =
          "${DateFormat("dd/MM/yyyy HH:mm").format(DateTime.parse(oldChallenge.end))} WIB";
    }
  }
}
