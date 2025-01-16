import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starter_pack_web/module/rnd/model/config_simbis_m.dart';

import '../../../utils/app_constanta.dart';
import '../../dashboard/model/demography_m.dart';
import '../../demography/model/distribute_m.dart';
import '../../user/model/group_m.dart';
import '../../user/model/user_m.dart';

class RanksController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final Rx<bool> isLoading = false.obs;

  final Rx<bool> isHovered = false.obs;

  final RxList<ConfigSimbs> simbis = <ConfigSimbs>[].obs;

  final RxList<DistributeM> distributes = <DistributeM>[].obs;

  final RxList<AreaM> areas = <AreaM>[].obs;

  final RxList<DemographyM> demographys = <DemographyM>[].obs;

  Rx<UserM> userSession = userEmpty.obs;

  late SharedPreferences pref;

  RxList<GroupM> groups = <GroupM>[].obs;

  @override
  void onInit() async {
    onChangeLoading(true);
    await setup();
    await getGroups();
    await getDemographys();
    await getDistribute();
    await getSimbis();
    await onChangeLoading(false);
    super.onInit();
  }

  Future getGroups() async {
    QuerySnapshot<Map<String, dynamic>> response;
    if (userSession.value.roleId == 109) {
      response = await firestore.collection("group").get();
    } else {
      response = await firestore
          .collection("group")
          .where("alias", isNotEqualTo: "PANITIA")
          .get();
    }

    groups.value = response.docs.map((e) {
      return GroupM.fromJson(e.data());
    }).toList();
  }

  Future setup() async {
    pref = await SharedPreferences.getInstance();
    final user = pref.getString("user");
    if (user != null) {
      userSession.value = UserM.fromJson(json.decode(user));
    }
  }

  Future onChangeLoading(bool val) async {
    isLoading.value = val;
  }

  Future getDemographys() async {
    final response = await firestore.collection("demography").get();
    demographys.value = response.docs.map((e) {
      return DemographyM.fromJson(e.data());
    }).toList();
    demographys.sort((a, b) => a.name.compareTo(b.name));
  }

  Future getSimbis() async {
    final response = await firestore.collection("simbis").get();
    if (response.docs.isNotEmpty) {
      simbis.value =
          response.docs.map((doc) => ConfigSimbs.fromJson(doc.data())).toList();

      simbis.sort((a, b) => a.name.compareTo(b.name));
    }
  }

  Future getDistribute() async {
    final response = await firestore.collection("distribution_log").get();
    distributes.value = response.docs.map((e) {
      return DistributeM.fromJson(e.data());
    }).toList();
    areas.clear();
    for (var item in distributes) {
      for (var data in item.areas) {
        areas.add(data);
      }
    }
  }

  double calculateTotalProfit(DistributeM distributeM) {
    double totalProfit = 0;

    for (var area in distributeM.areas) {
      for (var product in area.products) {
        totalProfit += product.profit;
      }
    }

    return totalProfit;
  }

  List<DistributeM> sortDistributeListByProfit(
      List<DistributeM> distributeList) {
    distributeList.sort((a, b) {
      // Hitung total profit untuk masing-masing DistributeM
      double profitA = calculateTotalProfit(a);
      double profitB = calculateTotalProfit(b);

      // Urutkan dari yang paling rendah (ascending)
      return profitB.compareTo(profitA);
    });
    return distributeList;
  }
}
