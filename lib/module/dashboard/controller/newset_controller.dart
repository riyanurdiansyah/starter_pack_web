import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:starter_pack_web/module/news/model/news_m.dart';
import 'package:uuid/uuid.dart';

import '../../../utils/app_dialog.dart';

class NewsetController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final RxList<NewsM> news = <NewsM>[].obs;
  final RxList<NewsM> newsSearch = <NewsM>[].obs;
  final Rx<bool> isSearched = false.obs;

  final tcTitle = TextEditingController();
  final tcData = TextEditingController();
  final tcImage = TextEditingController();

  final tcDate = TextEditingController();

  DateTime? selectedDate;

  FilePickerResult? filePickerResult;

  // quill.QuillController controller = () {
  //   return quill.QuillController.basic(
  //     configurations: const quill.QuillControllerConfigurations(),
  //   );
  // }();

  final ScrollController editorScrollController = ScrollController();

  final FocusNode editorFocusNode = FocusNode();

  Rx<int> currentPage = 1.obs;
  Rx<int> dataPerPage = 5.obs;

  @override
  void onInit() async {
    await getNews();
    super.onInit();
  }

  Future getNews() async {
    final response = await firestore.collection("news").get();
    news.value = response.docs.map((e) {
      return NewsM.fromJson(e.data());
    }).toList();
    news.sort(
        (a, b) => DateTime.parse(b.date).compareTo(DateTime.parse(a.date)));
  }

  List<NewsM> isUsingNews() {
    if (isSearched.value) {
      return newsSearch;
    }
    return news;
  }

  void onSearched(String query) {
    double pageTemp = 0;
    List<NewsM> newsTemp = [];
    if (query.isEmpty) {
      isSearched.value = false;
      newsTemp.clear();
      newsSearch.clear();
    } else {
      isSearched.value = true;
      newsTemp = news
          .where((e) => e.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
      for (int i = 0; i < newsTemp.length; i++) {
        pageTemp = (i + 1) / dataPerPage.value;
        newsTemp[i] = newsTemp[i].copyWith(page: pageTemp.ceil());
      }
      newsSearch.value = newsTemp;
      newsSearch.sort(
          (a, b) => DateTime.parse(b.date).compareTo(DateTime.parse(a.date)));
    }
  }

  int isTotalPage() {
    if (isSearched.value) {
      return (newsSearch.length / dataPerPage.value).ceil() == 0
          ? 1
          : (newsSearch.length / dataPerPage.value).ceil();
    }
    return (news.length / dataPerPage.value).ceil() == 0
        ? 1
        : (news.length / dataPerPage.value).ceil();
  }

  void onChangepage(int newValue) {
    currentPage.value = newValue;
  }

  void saveNews({NewsM? oldNews}) async {
    try {
      String downlodUrl = "";
      if (oldNews == null) {
        final fileBytes = filePickerResult?.files.single.bytes;
        final fileName = filePickerResult?.files.single.name;
        final storageRef =
            FirebaseStorage.instance.ref().child('assets/news/$fileName');

        final uploadTask = storageRef.putData(fileBytes!);

        final snapshot = await uploadTask.whenComplete(() {});

        downlodUrl = await snapshot.ref.getDownloadURL();
      }
      final id = const Uuid().v4();
      NewsM newsm = NewsM(
        isForAll: false,
        id: oldNews == null ? id : oldNews.id,
        title: tcTitle.text,
        content: tcData.text,
        date:
            selectedDate?.toIso8601String() ?? DateTime.now().toIso8601String(),
        image: oldNews != null ? oldNews.image : downlodUrl,
        page: 0,
        users: oldNews != null ? oldNews.users : [],
      );

      if (oldNews != null) {
        firestore.collection("news").doc(oldNews.id).update(newsm.toJson());
        AppDialog.dialogSnackbar("Data has been updated");
      } else {
        firestore.collection("news").doc(id).set(newsm.toJson());
        AppDialog.dialogSnackbar("Data has been created");
      }
      clearAllData();
      getNews();
    } catch (e) {
      AppDialog.dialogSnackbar("Error while saving : $e");
    }
  }

  void clearAllData() {
    tcTitle.clear();
    tcImage.clear();
    tcData.clear();
    // controller.document = quill.Document();
    filePickerResult = null;
  }

  void deleteData(NewsM data) async {
    try {
      // final firebaseStorageRef =
      //     FirebaseStorage.instance.refFromURL(data.image);

      // await firebaseStorageRef.delete();

      final documentRef = firestore.collection('news').doc(data.id);

      await documentRef.delete();
      getNews();
      AppDialog.dialogSnackbar("Data has been deleted");
    } catch (e) {
      AppDialog.dialogSnackbar("Error while deleting : $e");
    }
  }

  void setDataToDialog(NewsM oldNews) {
    tcTitle.text = oldNews.title;
    tcImage.text = oldNews.image;
    tcData.text = oldNews.content;
    if (oldNews.date.isNotEmpty) {
      selectedDate = DateTime.parse(oldNews.date);
      tcDate.text =
          "${DateFormat("dd/MM/yyyy HH:mm").format(selectedDate!)} WIB";
    }

    // controller.document = quill.Document.fromJson(json.decode(oldNews.content));
  }
}
