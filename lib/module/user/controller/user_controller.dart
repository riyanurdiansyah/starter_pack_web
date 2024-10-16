import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:starter_pack_web/middleware/app_route.dart';
import 'package:starter_pack_web/module/user/model/group_m.dart';
import 'package:starter_pack_web/module/user/model/user_m.dart';
import 'package:starter_pack_web/utils/app_constanta.dart';
import 'package:uuid/uuid.dart';

import '../model/role_m.dart';

class UserController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  RxList<UserM> users = <UserM>[].obs;
  RxList<UserM> usersSearch = <UserM>[].obs;

  Rx<RoleM> selectedRole = roleEmpty.obs;
  Rx<GroupM> selectedGroup = groupEmpty.obs;

  Rx<int> currentPage = 1.obs;
  Rx<int> dataPerPage = 5.obs;

  Rx<bool> isSearched = false.obs;

  final formKey = GlobalKey<FormState>();

  final tcNama = TextEditingController();

  final tcUsername = TextEditingController();

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
          .where((e) => e.nama.toLowerCase().contains(query.toLowerCase()))
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
      return usersSearch;
    }
    return users;
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

  Future<void> addNewUser() async {
    try {
      CollectionReference userCollection = firestore.collection('user');

      UserM newUser = UserM(
        id: const Uuid().v4(),
        nama: tcNama.text,
        username: tcUsername.text,
        roleId: selectedRole.value.roleId,
        role: selectedRole.value.role,
        kelompok: selectedGroup.value.name,
        kelompokId: selectedGroup.value.groupId,
        page: 0,
      );

      userCollection.add(newUser.toJson());
      navigatorKey.currentContext!.pop();
      getUsers();
      clearAllField();
    } catch (e) {
      log('Error adding user: $e');
    }
  }

  void clearAllField() {
    tcNama.clear();
    tcUsername.clear();
    selectedGroup.value = groupEmpty;
    selectedRole.value = roleEmpty;
  }
}
