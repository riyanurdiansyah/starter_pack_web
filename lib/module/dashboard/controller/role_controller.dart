import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:starter_pack_web/module/user/model/role_m.dart';

class RoleController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final RxList<RoleM> roles = <RoleM>[].obs;
  final RxList<RoleM> rolesSearch = <RoleM>[].obs;
  final Rx<bool> isSearched = false.obs;

  Rx<int> currentPage = 1.obs;
  Rx<int> dataPerPage = 5.obs;

  @override
  void onInit() async {
    await getRoles();
    super.onInit();
  }

  Future<List<RoleM>> getRoles() async {
    final response = await firestore.collection("user").get();
    roles.value = response.docs.map((e) {
      return RoleM.fromJson(e.data());
    }).toList();
    roles.sort((a, b) => a.role.compareTo(b.role));
    return roles;
  }

  List<RoleM> isUsingRoles() {
    if (isSearched.value) {
      return rolesSearch;
    }
    return roles;
  }

  void onSearched(String query) {
    double pageTemp = 0;
    List<RoleM> rolesTemp = [];
    if (query.isEmpty) {
      isSearched.value = false;
      rolesTemp.clear();
      rolesSearch.clear();
    } else {
      isSearched.value = true;
      rolesTemp = roles
          .where((e) => e.role.toLowerCase().contains(query.toLowerCase()))
          .toList();
      for (int i = 0; i < rolesTemp.length; i++) {
        pageTemp = (i + 1) / dataPerPage.value;
        rolesTemp[i] = rolesTemp[i].copyWith(page: pageTemp.ceil());
      }
      rolesSearch.value = rolesTemp;
      rolesSearch.sort((a, b) => a.role.compareTo(b.role));
    }
  }

  int isTotalPage() {
    if (isSearched.value) {
      return (rolesSearch.length / dataPerPage.value).ceil() == 0
          ? 1
          : (rolesSearch.length / dataPerPage.value).ceil();
    }
    return (roles.length / dataPerPage.value).ceil() == 0
        ? 1
        : (roles.length / dataPerPage.value).ceil();
  }

  void onChangepage(int newValue) {
    currentPage.value = newValue;
  }

  void deleteData(String documentId) async {
    try {
      final documentRef = FirebaseFirestore.instance
          .collection('collectionName')
          .doc(documentId);

      await documentRef.delete();
    } catch (e) {}
  }
}