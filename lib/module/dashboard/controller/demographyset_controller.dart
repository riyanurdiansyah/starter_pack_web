import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:starter_pack_web/module/dashboard/model/demography_m.dart';

class DemographysetController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final RxList<DemographyM> demographys = <DemographyM>[].obs;
  final RxList<DemographyM> demographysSearch = <DemographyM>[].obs;
  final Rx<bool> isSearched = false.obs;

  Rx<int> currentPage = 1.obs;
  Rx<int> dataPerPage = 5.obs;

  @override
  void onInit() async {
    await getDemographys();
    super.onInit();
  }

  Future<List<DemographyM>> getDemographys() async {
    final response = await firestore.collection("demography").get();
    demographys.value = response.docs.map((e) {
      return DemographyM.fromJson(e.data());
    }).toList();
    demographys.sort((a, b) => a.name.compareTo(b.name));

    double pageTemp = 0;
    for (int i = 0; i < demographys.length; i++) {
      pageTemp = (i + 1) ~/ 8 < 1 ? 1 : (i + 1) / 8;
      demographys[i] = demographys[i].copyWith(page: pageTemp.ceil());
    }

    return demographys;
  }

  List<DemographyM> isUsingDemographys() {
    if (isSearched.value) {
      return demographysSearch;
    }
    return demographys;
  }

  void onSearched(String query) {
    double pageTemp = 0;
    List<DemographyM> demographysTemp = [];
    if (query.isEmpty) {
      isSearched.value = false;
      demographysTemp.clear();
      demographysSearch.clear();
    } else {
      isSearched.value = true;
      demographysTemp = demographys
          .where((e) => e.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
      for (int i = 0; i < demographysTemp.length; i++) {
        pageTemp = (i + 1) / dataPerPage.value;
        demographysTemp[i] = demographysTemp[i].copyWith(page: pageTemp.ceil());
      }
      demographysSearch.value = demographysTemp;
      demographysSearch.sort((a, b) => a.name.compareTo(b.name));
    }
  }

  int isTotalPage() {
    if (isSearched.value) {
      return (demographysSearch.length / dataPerPage.value).ceil() == 0
          ? 1
          : (demographysSearch.length / dataPerPage.value).ceil();
    }
    return (demographys.length / dataPerPage.value).ceil() == 0
        ? 1
        : (demographys.length / dataPerPage.value).ceil();
  }

  void onChangepage(int newValue) {
    currentPage.value = newValue;
  }
}
