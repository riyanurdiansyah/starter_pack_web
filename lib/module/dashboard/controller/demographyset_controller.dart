import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:starter_pack_web/module/dashboard/model/demography_m.dart';

import '../../../utils/app_dialog.dart';

class DemographysetController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final RxList<DemographyM> demographys = <DemographyM>[].obs;
  final RxList<DemographyM> demographysSearch = <DemographyM>[].obs;
  final Rx<bool> isSearched = false.obs;

  Rx<int> currentPage = 1.obs;
  Rx<int> dataPerPage = 5.obs;

  final formKey = GlobalKey<FormState>();

  final tcName = TextEditingController();
  final tcData = TextEditingController();

  final tcInfant = TextEditingController();
  final tcPregnant = TextEditingController();
  final tcSeniors = TextEditingController();

  final tcInfantElevated = TextEditingController();
  final tcPregnantElevated = TextEditingController();
  final tcSeniorsElevated = TextEditingController();
  //Core Lifestyle
  //Elevated Class
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

  void setDemographyToDialog(DemographyM oldDemography) {
    tcName.text = oldDemography.name;
    tcData.text = oldDemography.data;
    tcInfant.text = oldDemography.infant;
    tcPregnant.text = oldDemography.pregnant;
    tcSeniors.text = oldDemography.seniors;
  }

  void updateDemography(DemographyM? oldDemography) async {
    try {
      if (oldDemography != null) {
        oldDemography = oldDemography.copyWith(
          name: tcName.text,
          data: tcData.text,
          seniors: tcSeniors.text,
          infant: tcInfant.text,
          pregnant: tcPregnant.text,
          infantElevated: tcInfantElevated.text,
          pregnantElevated: tcPregnantElevated.text,
          seniorsElevated: tcSeniorsElevated.text,
        );
        await firestore
            .collection("demography")
            .doc(oldDemography.id)
            .update(oldDemography.toJson());
      }
      getDemographys();
      AppDialog.dialogSnackbar("Data has been updated");
    } catch (e) {
      AppDialog.dialogSnackbar("Error while updating : $e");
    }
  }
}
