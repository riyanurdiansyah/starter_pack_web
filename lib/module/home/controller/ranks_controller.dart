import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starter_pack_web/module/demography/model/distribute_new_m.dart';
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

  final RxList<GroupM> groups = <GroupM>[].obs;

  final RxList<AreaNewM> newAreas = <AreaNewM>[].obs;

  @override
  void onInit() async {
    onChangeLoading(true);
    await getNewAreas();
    await setup();
    await getGroups();
    await getDemographys();
    await getDistribute();
    await getSimbis();
    await onChangeLoading(false);
    super.onInit();
  }

  Future getNewAreas() async {
    final response = await firestore.collection("distribution_log_new").get();
    newAreas.value = response.docs.map((e) {
      return AreaNewM.fromJson(e.data());
    }).toList();
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

  void sortAreasByProfit(List<DistributeM> distributeList) {
    for (var distribute in distributeList) {
      for (var area in distribute.areas) {
        // Mengurutkan produk dalam area berdasarkan profit secara descending
        area.products.sort((a, b) => b.profit.compareTo(a.profit));
      }
    }
  }

  List<DistributeM> sortDistributeListByProfit(
      List<DistributeM> distributeList) {
    // Pertama-tama, urutkan produk dalam setiap area terlebih dahulu
    sortAreasByProfit(distributeList);

    // Setelah produk dalam area diurutkan, urutkan list distributeM berdasarkan profit produk yang ada dalam area pertama
    distributeList.sort((a, b) {
      // Ambil profit terbesar dari setiap area (produk pertama)
      double profitA = a.areas.isNotEmpty ? a.areas[0].products[0].profit : 0;
      double profitB = b.areas.isNotEmpty ? b.areas[0].products[0].profit : 0;

      // Urutkan berdasarkan profit terbesar di area pertama
      return profitB.compareTo(profitA);
    });

    return distributeList; // Mengembalikan list yang sudah diurutkan
  }

  List<AreaNewM> getSortNewAreas(String cycleId, String areaId) {
    final tempList = newAreas
        .where((e) => e.cycleId == cycleId && e.areaId == areaId)
        .toList();

    // Menyortir tempList berdasarkan total profit atau sold dari seluruh produk
    tempList.sort((a, b) {
      // Menghitung total sold untuk setiap area
      var totalSoldA =
          a.products.fold(0.0, (sum, product) => sum + product.sold);
      var totalSoldB =
          b.products.fold(0.0, (sum, product) => sum + product.sold);
      return totalSoldB.compareTo(totalSoldA); // Urutkan secara descending
    });

    // Menyortir tempList berdasarkan total profit
    tempList.sort((a, b) {
      // Menghitung total profit untuk setiap area
      var totalProfitA =
          a.products.fold(0.0, (sum, product) => sum + product.profit);
      var totalProfitB =
          b.products.fold(0.0, (sum, product) => sum + product.profit);
      return totalProfitB.compareTo(totalProfitA); // Urutkan secara descending
    });

    return tempList;
  }
}
