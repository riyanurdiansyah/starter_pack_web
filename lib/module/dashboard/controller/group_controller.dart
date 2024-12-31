import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:starter_pack_web/module/user/model/group_m.dart';
import 'package:starter_pack_web/utils/app_dialog.dart';
import 'package:uuid/uuid.dart';

class GroupController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final RxList<GroupM> groups = <GroupM>[].obs;
  final RxList<GroupM> groupsSearch = <GroupM>[].obs;
  final Rx<bool> isSearched = false.obs;

  Rx<int> currentPage = 1.obs;
  Rx<int> dataPerPage = 8.obs;

  final tcAlias = TextEditingController();
  final tcCountry = TextEditingController();
  final tcGroupId = TextEditingController();
  final tcImage = TextEditingController();
  final tcName = TextEditingController();
  final tcGroupName = TextEditingController();
  final tcGroupCountry = TextEditingController();

  int newGroupId = 0;

  final formKey = GlobalKey<FormState>();
  FilePickerResult? filePickerResult;
  @override
  void onInit() async {
    await getGroups();
    super.onInit();
  }

  Future<List<GroupM>> getGroups() async {
    final response = await firestore.collection("group").get();
    groups.value = response.docs.map((e) {
      return GroupM.fromJson(e.data());
    }).toList();
    groups.sort((a, b) => a.groupId.compareTo(b.groupId));

    double pageTemp = 0;
    for (int i = 0; i < groups.length; i++) {
      pageTemp = (i + 1) ~/ 8 < 1 ? 1 : (i + 1) / 8;
      groups[i] = groups[i].copyWith(page: pageTemp.ceil());
    }

    int highestGroupId =
        groups.map((item) => item.groupId).reduce((a, b) => a > b ? a : b);

    newGroupId = highestGroupId + 1;
    tcGroupName.text = "Kelompok $newGroupId";
    return groups;
  }

  List<GroupM> isUsingGroups() {
    if (isSearched.value) {
      return groupsSearch.where((e) => e.page == currentPage.value).toList();
    }
    return groups.where((e) => e.page == currentPage.value).toList();
  }

  void onSearched(String query) {
    double pageTemp = 0;
    List<GroupM> groupsTemp = [];
    if (query.isEmpty) {
      isSearched.value = false;
      groupsTemp.clear();
      groupsSearch.clear();
    } else {
      isSearched.value = true;
      groupsTemp = groups
          .where((e) => e.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
      for (int i = 0; i < groupsTemp.length; i++) {
        pageTemp = (i + 1) / dataPerPage.value;
        groupsTemp[i] = groupsTemp[i].copyWith(page: pageTemp.ceil());
      }
      groupsSearch.value = groupsTemp;
      groupsSearch.sort((a, b) => a.name.compareTo(b.name));
    }
  }

  int isTotalPage() {
    if (isSearched.value) {
      return (groupsSearch.length / dataPerPage.value).ceil() == 0
          ? 1
          : (groupsSearch.length / dataPerPage.value).ceil();
    }
    return (groups.length / dataPerPage.value).ceil() == 0
        ? 1
        : (groups.length / dataPerPage.value).ceil();
  }

  void onChangepage(int newValue) {
    currentPage.value = newValue;
  }

  Future resetAll() async {
    try {
      for (var item in groups) {
        item = item.copyWith(point: 0, pointBefore: 0);

        firestore.collection("group").doc(item.id).update(item.toJson());
      }
      AppDialog.dialogSnackbar("Data has been reset");
    } catch (e) {
      AppDialog.dialogSnackbar("Error while resetting : $e");
    }
  }

  Future createGroup() async {
    final id = const Uuid().v4();
    try {
      firestore.runTransaction(
        (trx) async {
          final fileBytes = filePickerResult?.files.single.bytes;
          final fileName = filePickerResult?.files.single.name;
          final storageRef =
              FirebaseStorage.instance.ref().child('assets/avatar/$fileName');

          final uploadTask = storageRef.putData(fileBytes!);

          final snapshot = await uploadTask.whenComplete(() {});

          final downloadUrl = await snapshot.ref.getDownloadURL();
          final data = GroupM(
              alias: tcGroupName.text,
              country: "",
              groupId: newGroupId,
              id: id,
              image: downloadUrl.split("&token")[0],
              name: tcGroupName.text,
              point: 0,
              pointBefore: 0,
              updatedDate: DateTime.now().toIso8601String(),
              page: 0);
          await firestore.collection("group").doc(id).set(data.toJson());
        },
      ).then((_) {
        getGroups();
        AppDialog.dialogSnackbar("Data has been saved");
      }).catchError((e) {
        AppDialog.dialogSnackbar("Error while creating : $e");
      });
    } catch (e) {
      AppDialog.dialogSnackbar("Error while creating : $e");
    }
  }

  Future updateGroup(GroupM oldGroup) async {
    String downloadUrl = "";
    try {
      firestore.runTransaction(
        (trx) async {
          if (filePickerResult != null) {
            final fileBytes = filePickerResult?.files.single.bytes;
            final fileName = filePickerResult?.files.single.name;
            final storageRef =
                FirebaseStorage.instance.ref().child('assets/avatar/$fileName');

            final uploadTask = storageRef.putData(fileBytes!);

            final snapshot = await uploadTask.whenComplete(() {});

            final decodedPath =
                Uri.decodeFull(oldGroup.image.split('/o/')[1].split('?')[0]);

            final fileRef = FirebaseStorage.instance.ref(decodedPath);

            await fileRef.delete();
            downloadUrl = await snapshot.ref.getDownloadURL();
          }
          final data = GroupM(
            alias: tcAlias.text,
            country: oldGroup.country,
            groupId: oldGroup.groupId,
            id: oldGroup.id,
            image: downloadUrl.isNotEmpty
                ? downloadUrl.split("&token")[0]
                : oldGroup.image,
            name: tcGroupName.text,
            point: oldGroup.point,
            pointBefore: oldGroup.pointBefore,
            updatedDate: DateTime.now().toIso8601String(),
            page: 0,
          );
          await firestore
              .collection("group")
              .doc(oldGroup.id)
              .update(data.toJson());
        },
      ).then((_) {
        getGroups();
        AppDialog.dialogSnackbar("Data has been updated");
      }).catchError((e) {
        AppDialog.dialogSnackbar("Error while updating : $e");
      });
    } catch (e) {
      AppDialog.dialogSnackbar("Error while updating : $e");
    }
  }

  void setGroupDialog(GroupM oldGroup) {
    tcAlias.text = oldGroup.alias;
    tcCountry.text = oldGroup.country;
    tcGroupId.text = oldGroup.groupId.toString();
    tcImage.text = oldGroup.image;
    tcName.text = oldGroup.name;
    tcGroupName.text = oldGroup.name;
    tcGroupCountry.text = oldGroup.country;
  }

  void deleteGroup(GroupM oldGroup) async {
    try {
      final decodedPath =
          Uri.decodeFull(oldGroup.image.split('/o/')[1].split('?')[0]);

      final fileRef = FirebaseStorage.instance.ref(decodedPath);

      await fileRef.delete();
      await firestore.collection("group").doc(oldGroup.id).delete();
      getGroups();
      AppDialog.dialogSnackbar("Data has been deleted");
    } catch (e) {
      AppDialog.dialogSnackbar("Error while deleting : $e");
    }
  }
}
