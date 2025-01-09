import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starter_pack_web/module/user/model/user_m.dart';
import 'package:starter_pack_web/utils/app_constanta.dart';
import 'package:uuid/uuid.dart';

import '../../../utils/app_dialog.dart';
import '../../user/model/role_m.dart';

class AssignController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final RxList<UserM> users = <UserM>[].obs;
  final RxList<UserM> usersUp = <UserM>[].obs;
  final Rx<UserM> user = userEmpty.obs;

  final RxList<RoleM> roles = <RoleM>[].obs;
  final RxList<String> userSelected = <String>[].obs;

  final RxList<String> roleSelected = <String>[].obs;

  late SharedPreferences pref;

  RxMap<int, UserM> selectedItems = <int, UserM>{}.obs;

  final RxList<Map<String, dynamic>> selectedUser =
      <Map<String, dynamic>>[].obs;

  final Rx<bool> isDone = false.obs;
  final Rx<bool> isHovered = false.obs;

  final Rx<bool> isLoading = false.obs;

  @override
  void onInit() async {
    changeLoading(true);
    roleSelected.clear();
    pref = await SharedPreferences.getInstance();
    await getUser();
    await getUsers();
    await getRoles();
    await getLogAssign();
    await changeLoading(false);

    super.onInit();
  }

  Future changeLoading(bool val) async {
    isLoading.value = val;
  }

  Future getLogAssign() async {
    final logAssign = await firestore
        .collection("log")
        .where("type", isEqualTo: "assign")
        .where("groupId", isEqualTo: user.value.groupId)
        .get();
    if (logAssign.docs.isNotEmpty) {
      isDone.value = true;
    }
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
        "assignedUser": List.generate(users.length, (_) => ""),
      },
    );
    return list;
  }

  void onSelectUser(int index, int roleIndex, RoleM? value, UserM? user) {
    if (value != null && user != null) {
      final userIndex = users.indexWhere((e) => e.username == user.username);
      if (userIndex != -1) {
        var data = users[userIndex].copyWith(
          roleId: value.roleId,
          role: value.role,
        );

        usersUp.add(data);

        selectedUser[roleIndex]['assignedUser'][userIndex] = user.username;

        if (!userSelected.contains(user.username)) {
          userSelected.add(user.username);
        }
      }
    }
  }

  Future validateUser() async {
    var valid = true;
    for (var item in usersUp) {
      if (!userSelected.contains(item.username)) {
        valid = false;
        AppDialog.dialogSnackbar(
          "Warning\nAll users must have an assigned role before proceeding.",
        );
        break;
      }
    }
    return valid;
  }

  void saveUser() async {
    var id = const Uuid().v4();
    try {
      var isValid = await validateUser();
      if (!isValid) {
        return;
      }
      firestore.runTransaction(
        (trx) async {
          for (var item in usersUp) {
            await firestore
                .collection("user")
                .doc(item.id)
                .update(item.toJson());
          }
          await firestore.collection("log").doc(id).set({
            "logId": id,
            "groupId": user.value.groupId,
            "type": "assign",
            "createdBy": user.value.username,
            "createdAt": DateTime.now().toIso8601String(),
          });
        },
      ).then((_) {
        getUsers();
        getLogAssign();
        AppDialog.dialogSnackbar("Data has been saved");
      }).catchError((e) {
        AppDialog.dialogSnackbar("Error while saving : $e");
      });
    } catch (e) {
      AppDialog.dialogSnackbar("Error while creating : $e");
    }
  }
}
