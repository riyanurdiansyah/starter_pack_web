import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starter_pack_web/module/user/model/user_m.dart';
import 'package:starter_pack_web/utils/app_constanta.dart';

import '../../../utils/app_dialog.dart';
import '../../user/model/role_m.dart';

class AssignController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final RxList<UserM> users = <UserM>[].obs;
  final Rx<UserM> user = userEmpty.obs;

  final RxList<RoleM> roles = <RoleM>[].obs;

  final RxList<String> roleSelected = <String>[].obs;

  late SharedPreferences pref;

  RxMap<int, UserM> selectedItems = <int, UserM>{}.obs;

  final RxList<Map<String, dynamic>> selectedUser =
      <Map<String, dynamic>>[].obs;

  @override
  void onInit() async {
    roleSelected.clear();
    pref = await SharedPreferences.getInstance();
    await getRoles();
    await getUser();
    await getUsers();
    super.onInit();
  }

  Future getUser() async {
    final userCache = pref.getString("user") ?? "";
    final userData = json.decode(userCache);
    user.value = UserM.fromJson(userData);
  }

  Future<List<UserM>> getUsers() async {
    final response = await firestore.collection("user").get();
    users.value = response.docs.map((e) {
      return UserM.fromJson(e.data());
    }).toList();
    users.sort((a, b) => a.nama.compareTo(b.nama));
    users.value = users
        .where((e) =>
            e.groupId == user.value.groupId &&
            e.username != user.value.username &&
            e.roleId != 109)
        .toList();
    // for (int i = 0; i < users.length; i++) {
    //   final roleU = roles.where((e) => e.roleId == users[i].roleId).toList();
    //   if (roleU.isNotEmpty) {
    //     selectedItems[i] = roleU[0];
    //     if (roleU[0].roleId != 109 &&
    //         roleU[0].roleId != 106 &&
    //         roleU[0].roleId != 108) {
    //       roleSelected.add(roleU[0].id);
    //     }
    //   }
    // }
    return users;
  }

  Future<List<RoleM>> getRoles() async {
    List<RoleM> list = [];
    final response = await firestore.collection("role").get();

    final listTemp = response.docs.map((e) {
      return RoleM.fromJson(e.data());
    }).toList();
    list.sort((a, b) => a.role.compareTo(b.role));
    list = listTemp
        .where((e) => e.roleId != 109 && e.roleId != 108 && e.roleId != 106)
        .toList();
    roles.value = list;
    roles.sort((a, b) => a.role.compareTo(b.role));

    selectedUser.value = List.generate(
      roles.length,
      (i) => {
        "role": roles[i].role,
        "max": roles[i].max,
        "assignedUser": List.generate(roles[i].max, (_) => ""),
      },
    );
    return list;
  }

  void onSelectUser(int index, int roleIndex, RoleM? value, UserM? user) {
    if (value != null && user != null) {
      // Cari indeks elemen
      final userIndex = users.indexWhere((e) => e == user);

      // Pastikan indeks valid
      if (userIndex != -1) {
        users[userIndex] = users[userIndex].copyWith(
          roleId: value.roleId,
          role: value.role,
        );

        selectedUser[roleIndex]['assignedUser'][userIndex] = user.username;
      }
    }
  }

  void saveUser() {
    try {
      firestore.runTransaction(
        (trx) async {
          for (var item in users) {
            await firestore
                .collection("user")
                .doc(item.id)
                .update(item.toJson());
          }
        },
      ).then((_) {
        getUsers();
        AppDialog.dialogSnackbar("Data has been saved");
      }).catchError((e) {
        AppDialog.dialogSnackbar("Error while saving : $e");
      });
    } catch (e) {
      AppDialog.dialogSnackbar("Error while creating : $e");
    }
  }
}
