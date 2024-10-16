import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:starter_pack_web/module/user/model/group_m.dart';
import 'package:starter_pack_web/utils/app_constanta.dart';

class HomeController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Rx<int> indexFilter = 0.obs;

  RxList<GroupM> groups = <GroupM>[].obs;
  RxList<GroupM> oldGroups = <GroupM>[].obs;
  RxList<GroupM> thenGroups = <GroupM>[].obs;

  @override
  void onInit() async {
    // insertDummy();
    await getGroups();
    super.onInit();
  }

  Future getGroups() async {
    final response = await firestore.collection("group").get();
    // final response2 = await firestore.collection("group").get();

    groups.value = response.docs.map((e) {
      return GroupM.fromJson(e.data());
    }).toList();

    oldGroups.value = List.from(groups);
    thenGroups.value = List.from(groups);

    oldGroups.sort((a, b) => b.pointBefore.compareTo(a.pointBefore));
    thenGroups.sort((a, b) => b.point.compareTo(a.point));

    for (int i = 0; i < groups.length; i++) {
      groups[i] = groups[i].copyWith(
        rank: thenGroups.indexWhere((x) => x.id == groups[i].id) + 1,
        rankOld: oldGroups.indexWhere((x) => x.id == groups[i].id) + 1,
      );
    }

    groups.sort((a, b) => b.point.compareTo(a.point));
  }

  Future insertDummy() async {
    for (var groupData in groupList) {
      await insertDataToFirestore(groupData);
    }
  }

  void onChangeFilter(int i) {
    indexFilter.value = i;
  }

  Future<void> insertDataToFirestore(GroupM data) async {
    await firestore.collection('group').doc(data.id).set(data.toJson());
  }

  int getEvolution(GroupM data) {
    final oldRank = oldGroups.indexOf(data) + 1;
    final thenRank = thenGroups.indexOf(data) + 1;

    // log("CEK RANK ${data.name} : $oldRank");
    // log("CEK RANK 2 ${data.name}  : $thenRank");

    return thenRank - oldRank;
  }
}
