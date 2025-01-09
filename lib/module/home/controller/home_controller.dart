import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starter_pack_web/module/user/model/group_m.dart';

import '../../../utils/app_constanta.dart';
import '../../challenge/model/challenge_m.dart';
import '../../challenge/model/quiz_session_m.dart';
import '../../demography/model/distribute_m.dart';
import '../../user/model/user_m.dart';

class HomeController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Rx<int> indexFilter = 0.obs;
  Rx<int> indexTab = 0.obs;

  RxList<GroupM> groups = <GroupM>[].obs;
  RxList<GroupM> oldGroups = <GroupM>[].obs;
  RxList<GroupM> thenGroups = <GroupM>[].obs;

  Rx<UserM> userSession = userEmpty.obs;

  late SharedPreferences pref;

  final RxList<UserM> users = <UserM>[].obs;
  final RxList<UserM> usersSearch = <UserM>[].obs;
  final RxList<QuizSessionM> quizess = <QuizSessionM>[].obs;

  Rx<int> currentPage = 1.obs;
  Rx<int> dataPerPage = 12.obs;

  RxList<int> currentPageChallenges = <int>[0, 0].obs;
  RxList<int> dataPerPageChallenges = <int>[12, 12].obs;
  Rx<bool> isSearched = false.obs;
  Rx<bool> isLoading = false.obs;

  final RxList<DistributeM> distributes = <DistributeM>[].obs;

  RxList<ChallengeM> challenges = <ChallengeM>[].obs;

  RxList<List<UserM>> challengeUsers = <List<UserM>>[
    [userEmpty],
    [userEmpty],
  ].obs;

  RxList<String> boards = <String>[].obs;

  @override
  void onInit() async {
    changeLoading(true);
    await setup();
    await getDistribute();
    await getGroups();
    await getSessionQuiz();
    await getUsers();
    await getChallenges();

//     final response = await firestore.collection("quiz_session").get();

// // Buat list dari QuizSessionM
//     final listQuizSessions =
//         response.docs.map((doc) => QuizSessionM.fromJson(doc.data())).toList();

// // Ambil daftar unik groupId
//     final uniqueGroupIds = listQuizSessions.map((quiz) => quiz.groupId).toSet();

// // Hitung total poin untuk setiap groupId
//     final groupPoints = uniqueGroupIds.map((groupId) {
//       final totalPoints = listQuizSessions
//           .where((quiz) => quiz.groupId == groupId)
//           .fold(0, (sum, quiz) => sum + quiz.point);

//       return {
//         'groupId': groupId,
//         'totalPoints': totalPoints,
//       };
//     }).toList();

// // Perbarui nilai point di dalam groups
//     for (var i = 0; i < groups.length; i++) {
//       final groupPoint = groupPoints.firstWhere(
//         (e) => e['groupId'] == groups[i].id,
//         orElse: () => {'groupId': groups[i].id, 'totalPoints': 0},
//       );

//       groups[i] = groups[i].copyWith(
//         point:
//             100000 + (int.tryParse("${groupPoint['totalPoints'] ?? 0}") ?? 0),
//       );
//     }

    await changeLoading(false);
    super.onInit();
  }

  Future getChallenges() async {
    final response = await firestore.collection("challenge").get();

    challenges.value = response.docs.map((e) {
      return ChallengeM.fromJson(e.data());
    }).toList();

    challenges.sort(
        (a, b) => DateTime.parse(a.start).compareTo(DateTime.parse(b.start)));

    for (var item in challenges) {
      List<UserM> userData = [];
      double pageTemp = 0;
      boards.add(item.id);
      for (var data in users) {
        var resultQuiz = quizess.firstWhereOrNull(
            (e) => e.quizId == item.id && e.username == data.username);
        if (resultQuiz != null) {
          data = data.copyWith(
            point: resultQuiz.point,
          );
        } else {
          data = data.copyWith(
            point: 0,
          );
        }
        userData.add(data);
      }

      userData.sort((a, b) => a.nama.compareTo(b.nama));
      userData.sort((a, b) => b.point.compareTo(a.point));
      for (int i = 0; i < userData.length; i++) {
        pageTemp =
            (i + 1) ~/ dataPerPage.value < 1 ? 1 : (i + 1) / dataPerPage.value;
        userData[i] = userData[i].copyWith(
          page: pageTemp.ceil(),
        );
      }
      userData = userData.where((e) => e.kelompok != "PANITIA").toList();
      challengeUsers.add(userData);
      dataPerPageChallenges.add(12);
      currentPageChallenges.add(1);
    }
  }

  Future<List<DistributeM>> getDistribute() async {
    final response = await firestore.collection("distribution").get();
    distributes.value = response.docs.map((e) {
      return DistributeM.fromJson(e.data());
    }).toList();
    return distributes;
  }

  Future changeLoading(bool val) async {
    isLoading.value = val;
  }

  Future setup() async {
    pref = await SharedPreferences.getInstance();
    final user = pref.getString("user");
    if (user != null) {
      userSession.value = UserM.fromJson(json.decode(user));
    }
  }

  Future getGroups() async {
    final response = await firestore
        .collection("group")
        .where("alias", isNotEqualTo: "PANITIA")
        .get();

    groups.value = response.docs.map((e) {
      var data = GroupM.fromJson(e.data()).copyWith(
        profit: calculateTotalProfit(e.id).toInt(),
      );
      return data;
    }).toList();

    oldGroups.value = List.from(groups);
    thenGroups.value = List.from(groups);

    groups.sort((a, b) => b.profit.compareTo(a.profit));
    groups.sort((a, b) => b.point.compareTo(a.point));
    oldGroups.sort((a, b) => b.pointBefore.compareTo(a.pointBefore));
    thenGroups.sort((a, b) => b.point.compareTo(a.point));

    bool allPointsZero = groups.every((group) => group.point == 0);

    for (int i = 0; i < groups.length; i++) {
      if (allPointsZero) {
        groups[i] = groups[i].copyWith(
          rank: 0,
          rankOld: 0,
        );
      } else {
        groups[i] = groups[i].copyWith(
          rank: thenGroups.indexWhere((x) => x.id == groups[i].id) + 1,
          rankOld: oldGroups.indexWhere((x) => x.id == groups[i].id) + 1,
        );
      }
    }

    boards.add("GROUP");
  }

  // Future insertDummy() async {
  //   for (var groupData in groupList) {
  //     await insertDataToFirestore(groupData);
  //   }
  // }

  void onChangeFilter(int i) {
    indexFilter.value = i;
  }

  Future<void> insertDataToFirestore(GroupM data) async {
    await firestore.collection('group').doc(data.id).set(data.toJson());
  }

  int getEvolution(GroupM data) {
    final oldRank = oldGroups.indexOf(data) + 1;
    final thenRank = thenGroups.indexOf(data) + 1;

    return thenRank - oldRank;
  }

  Future getSessionQuiz() async {
    final response = await firestore.collection("quiz_session").get();
    quizess.value = response.docs.map((e) {
      return QuizSessionM.fromJson(e.data());
    }).toList();
  }

  Future getUsers() async {
    final response = await firestore.collection("user").get();
    users.value = response.docs.map((e) {
      return UserM.fromJson(e.data());
    }).toList();
    users.value =
        users.where((e) => e.kelompokId < 20 && e.roleId != 109).toList();

    double pageTemp = 0;
    for (int i = 0; i < users.length; i++) {
      users[i] = users[i].copyWith(
        point: quizess
            .where((e) => e.username == users[i].username)
            .fold<int>(0, (total, element) => total + element.point),
      );
    }

    users.sort((a, b) => a.nama.compareTo(b.nama));
    users.sort((a, b) => b.point.compareTo(a.point));
    for (int i = 0; i < users.length; i++) {
      pageTemp =
          (i + 1) ~/ dataPerPage.value < 1 ? 1 : (i + 1) / dataPerPage.value;
      users[i] = users[i].copyWith(
        page: pageTemp.ceil(),
      );
    }
    boards.add("USER");
  }

  // Future getUsersChallenge() async {
  //   double pageTemp = 0;
  //   for (int i = 0; i < challengeUsers.length; i++) {
  //     for(int j = 0; j < users.length; j++) {
  //       if(challengeUsers[i].)
  //     }
  //     users[i] = users[i].copyWith(
  //       point: quizess
  //           .where((e) => e.username == users[i].username)
  //           .fold<int>(0, (total, element) => total + element.point),
  //     );
  //   }

  //   users.sort((a, b) => a.nama.compareTo(b.nama));
  //   users.sort((a, b) => b.point.compareTo(a.point));
  //   for (int i = 0; i < users.length; i++) {
  //     pageTemp =
  //         (i + 1) ~/ dataPerPage.value < 1 ? 1 : (i + 1) / dataPerPage.value;
  //     users[i] = users[i].copyWith(
  //       page: pageTemp.ceil(),
  //     );
  //   }
  // }

  List<UserM> isUsingUsers() {
    if (isSearched.value) {
      return usersSearch.where((e) => e.page == currentPage.value).toList();
    }

    return users.where((e) => e.page == currentPage.value).toList();
  }

  List<UserM> isUsingUsersChallenge(List<UserM> usersData) {
    return usersData.where((e) => e.page == currentPage.value).toList();
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

  void onSearched(String query) {
    double pageTemp = 0;
    List<UserM> usersTemp = [];
    users.sort((a, b) => b.point.compareTo(a.point));
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
                e.groupId.toLowerCase().contains(query.toLowerCase()) ||
                e.username.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
      for (int i = 0; i < usersTemp.length; i++) {
        pageTemp = (i + 1) / dataPerPage.value;
        usersTemp[i] = usersTemp[i].copyWith(page: pageTemp.ceil());
      }
      usersSearch.value = usersTemp;
      groups.sort((a, b) => b.point.compareTo(a.point));
    }
  }

  void onChangepage(int newValue) {
    currentPageChallenges[indexTab.value] = newValue;
  }

  void onChangepageIndividu(int newValue) {
    currentPage.value = newValue;
  }

  double calculateTotalProfit(String targetGroupId) {
    return distributes
        .where((distribute) =>
            distribute.groupId == targetGroupId) // Filter berdasarkan groupId
        .expand((distribute) => distribute.areas) // Dapatkan semua AreaM
        .expand((area) => area.products) // Dapatkan semua ProductDistributeM
        .map((product) => product.profit) // Ambil nilai profit
        .fold(0.0, (total, profit) => total + profit); // Jumlahkan semua profit
  }
}
