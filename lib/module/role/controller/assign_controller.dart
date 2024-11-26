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

  RxMap<int, RoleM> selectedItems = <int, RoleM>{}.obs;

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
    for (int i = 0; i < users.length; i++) {
      final roleU = roles.where((e) => e.roleId == users[i].roleId).toList();
      if (roleU.isNotEmpty) {
        selectedItems[i] = roleU[0];
        if (roleU[0].roleId != 109 &&
            roleU[0].roleId != 106 &&
            roleU[0].roleId != 108) {
          roleSelected.add(roleU[0].id);
        }
      }
    }
    return users;
  }

  Future<List<RoleM>> getRoles() async {
    List<RoleM> list = [];
    final response = await firestore.collection("role").get();

    final listTemp = response.docs.map((e) {
      return RoleM.fromJson(e.data());
    }).toList();
    list.sort((a, b) => a.role.compareTo(b.role));
    list = listTemp.where((e) => e.roleId != 109 && e.roleId != 106).toList();
    roles.value = list;
    return list;
  }

  void onSelectRole(int index, RoleM? value) {
    if (value != null) {
      roleSelected.add(value.id);
      selectedItems[index] = value;
      users[index] = users[index].copyWith(
        role: value.role,
        roleId: value.roleId,
      );
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
