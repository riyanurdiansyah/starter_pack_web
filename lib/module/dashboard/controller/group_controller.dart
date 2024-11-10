import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:starter_pack_web/module/user/model/group_m.dart';

class GroupController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final RxList<GroupM> groups = <GroupM>[].obs;
  final RxList<GroupM> groupsSearch = <GroupM>[].obs;
  final Rx<bool> isSearched = false.obs;

  Rx<int> currentPage = 1.obs;
  Rx<int> dataPerPage = 8.obs;

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
}
