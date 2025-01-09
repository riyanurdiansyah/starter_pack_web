import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:starter_pack_web/module/user/model/group_m.dart';
import 'package:starter_pack_web/module/user/model/user_m.dart';
import 'package:starter_pack_web/utils/app_constanta.dart';
import 'package:starter_pack_web/utils/app_dialog.dart';
import 'package:uuid/uuid.dart';

import '../../../middleware/app_route.dart';
import '../model/role_m.dart';

class UserController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  RxList<UserM> users = <UserM>[].obs;
  RxList<UserM> usersSearch = <UserM>[].obs;

  Rx<RoleM> selectedRole = roleEmpty.obs;
  Rx<GroupM> selectedGroup = groupEmpty.obs;

  Rx<int> currentPage = 1.obs;
  Rx<int> dataPerPage = 8.obs;

  Rx<bool> isSearched = false.obs;

  final formKey = GlobalKey<FormState>();

  final tcNama = TextEditingController();

  final tcUsername = TextEditingController();

  final tcPassword = TextEditingController();

  final tcKelompok = TextEditingController();

  final tcRole = TextEditingController();

  @override
  void onInit() {
    getUsers();
    super.onInit();
  }

  Future<List<UserM>> getUsers() async {
    final response = await firestore.collection("user").get();
    users.value = response.docs.map((e) {
      return UserM.fromJson(e.data());
    }).toList();
    users.sort((a, b) => a.kelompok.compareTo(b.kelompok));

    double pageTemp = 0;
    for (int i = 0; i < users.length; i++) {
      pageTemp = (i + 1) ~/ 8 < 1 ? 1 : (i + 1) / 8;
      users[i] = users[i].copyWith(page: pageTemp.ceil());
    }
    return users;
  }

  Future<List<RoleM>> getRoles() async {
    final response = await firestore.collection("role").get();

    final list = response.docs.map((e) {
      return RoleM.fromJson(e.data());
    }).toList();
    list.sort((a, b) => a.role.compareTo(b.role));

    return list;
  }

  Future<List<GroupM>> getGroups() async {
    final response = await firestore.collection("group").get();
    final list = response.docs.map((e) {
      return GroupM.fromJson(e.data());
    }).toList();
    list.sort((a, b) => a.name.compareTo(b.name));
    return list;
  }

  void onChangepage(int newValue) {
    currentPage.value = newValue;
  }

  void onSearched(String query) {
    double pageTemp = 0;
    List<UserM> usersTemp = [];
    if (query.isEmpty) {
      isSearched.value = false;
      usersTemp.clear();
      usersSearch.clear();
    } else {
      isSearched.value = true;
      usersTemp = users
          .where(
            (e) =>
                e.nama.toLowerCase().contains(query.toLowerCase()) ||
                e.kelompok.toLowerCase().contains(query.toLowerCase()) ||
                e.username.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
      for (int i = 0; i < usersTemp.length; i++) {
        pageTemp = (i + 1) / dataPerPage.value;
        usersTemp[i] = usersTemp[i].copyWith(page: pageTemp.ceil());
      }
      usersSearch.value = usersTemp;
      usersSearch.sort((a, b) => a.nama.compareTo(b.nama));
    }
  }

  List<UserM> isUsingUsers() {
    if (isSearched.value) {
      return usersSearch.where((e) => e.page == currentPage.value).toList();
    }
    return users.where((e) => e.page == currentPage.value).toList();
  }

  int isTotalPage() {
    if (isSearched.value) {
      return (usersSearch.length / dataPerPage.value).ceil() == 0
          ? 1
          : (usersSearch.length / dataPerPage.value).ceil();
    }
    return (users.length / dataPerPage.value).ceil() == 0
        ? 1
        : (users.length / dataPerPage.value).ceil();
  }

  void onSelectGroup(GroupM? value) {
    if (value != null) {
      selectedGroup.value = value;
    }
  }

  void onSelectRole(RoleM? value) {
    if (value != null) {
      selectedRole.value = value;
    }
  }

  String hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<void> addNewUser(
    UserM? user,
  ) async {
    navigatorKey.currentContext!.pop();
    try {
      if (user != null) {
        final documentRef = firestore.collection('user').doc(user.id);

        user = user.copyWith(
          nama: tcNama.text,
          username: tcUsername.text,
          roleId: selectedRole.value.roleId,
          role: selectedRole.value.role,
          kelompok: selectedGroup.value.name,
          kelompokId: selectedGroup.value.groupId,
          groupId: selectedGroup.value.id.isEmpty
              ? user.groupId
              : selectedGroup.value.id,
          page: 0,
          password: tcPassword.text.isEmpty
              ? user.password
              : hashPassword(tcPassword.text),
        );
        await documentRef.update(user.toJson());
      } else {
        CollectionReference userCollection = firestore.collection('user');
        final id = const Uuid().v4();
        UserM newUser = UserM(
          id: id,
          nama: tcNama.text,
          username: tcUsername.text,
          roleId: selectedRole.value.roleId,
          role: selectedRole.value.role,
          kelompok: selectedGroup.value.name,
          kelompokId: selectedGroup.value.groupId,
          page: 0,
          point: 0,
          password: hashPassword(tcUsername.text),
          groupId: selectedGroup.value.id,
        );

        await userCollection.doc(id).set(newUser.toJson());
      }
      // log("${user?.toJson()}");
      getUsers();
      AppDialog.dialogSnackbar("Data has been saved");

      clearAllField();
    } catch (e) {
      AppDialog.dialogSnackbar("Error while adding : $e");
    }
  }

  void clearAllField() {
    tcNama.clear();
    tcUsername.clear();
    selectedGroup.value = groupEmpty;
    selectedRole.value = roleEmpty;
  }

  void setUserToDialog(UserM oldUser) {
    tcNama.text = oldUser.nama;
    tcUsername.text = oldUser.username;
    selectedGroup.value = GroupM(
      alias: "",
      country: "",
      profit: 0,
      groupId: oldUser.kelompokId,
      id: "",
      image: "",
      name: oldUser.kelompok,
      point: 0,
      page: 0,
      pointBefore: 0,
      updatedDate: DateTime.now().toIso8601String(),
    );

    selectedGroup.value = GroupM(
      alias: "",
      country: "",
      groupId: oldUser.kelompokId,
      id: "",
      image: "",
      name: oldUser.kelompok,
      point: 0,
      page: 0,
      pointBefore: 0,
      profit: 0,
      updatedDate: "",
      rank: 0,
      rankOld: 0,
    );
    selectedRole.value = RoleM(
      id: "",
      role: oldUser.role,
      roleId: oldUser.roleId,
      page: 0,
      max: 1,
      image: "",
    );
  }

  void deleteData(String documentId) async {
    try {
      final documentRef = firestore.collection('user').doc(documentId);

      await documentRef.delete();
      getUsers();
      AppDialog.dialogSnackbar("Data has been deleted");
    } catch (e) {
      AppDialog.dialogSnackbar("Error while deleting : $e");
    }
  }
}
