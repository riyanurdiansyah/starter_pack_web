import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:starter_pack_web/module/dashboard/model/demography_m.dart';

import '../../../utils/app_dialog.dart';
import '../../demography/model/produk_m.dart';

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
  final tcImage = TextEditingController();
  final tcCost = TextEditingController();
  final tcMinPrice = TextEditingController();
  final tcMaxPrice = TextEditingController();

  Map<int, List<TextEditingController>> tcProducts =
      <int, List<TextEditingController>>{};

  final tcInfant = TextEditingController();
  final tcPregnant = TextEditingController();
  final tcSeniors = TextEditingController();

  final tcInfantElevated = TextEditingController();
  final tcPregnantElevated = TextEditingController();
  final tcSeniorsElevated = TextEditingController();

  final RxList<ProdukM> products = <ProdukM>[].obs;

  FilePickerResult? filePickerResult;

  //Core Lifestyle
  //Elevated Class
  @override
  void onInit() async {
    await getProducts();
    await getDemographys();
    super.onInit();
  }

  Future getProducts() async {
    final response = await firestore.collection("produk").get();
    products.value = response.docs.map((e) {
      return ProdukM.fromJson(e.data());
    }).toList();
    products.sort((a, b) => a.nama.compareTo(b.nama));

    for (int i = 0; i < products.length; i++) {
      tcProducts[i] = [
        TextEditingController(text: products[i].id),
        TextEditingController(
            text: "${products[i].nama} - ${products[i].tipe}"),
        TextEditingController(text: "0"),
        TextEditingController(text: "0"),
      ];
    }
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
    tcImage.text = oldDemography.image;
    tcCost.text = oldDemography.cost.toString();
    // tcMinPrice.text = oldDemography.minPrice.toString();
    // tcMaxPrice.text = oldDemography.maxPrice.toString();
  }

  void updateDemography(DemographyM? oldDemography) async {
    try {
      List<DetailProductDemography> details = [];
      for (int i = 0; i < tcProducts.keys.toList().length; i++) {
        log("CEK DATA 2: ${tcProducts[i]![1].text}");
        details.add(DetailProductDemography(
            productId: tcProducts[i]![0].text,
            minPrice: double.tryParse(tcProducts[i]![2].text) ?? 0,
            maxPrice: double.tryParse(tcProducts[i]![3].text) ?? 0));
      }
      String downlodUrl = "";
      if (oldDemography != null) {
        if (oldDemography.image != tcImage.text) {
          final fileBytes = filePickerResult?.files.single.bytes;
          final fileName = filePickerResult?.files.single.name;
          final storageRef = FirebaseStorage.instance
              .ref()
              .child('assets/demography/$fileName');

          final uploadTask = storageRef.putData(fileBytes!);

          final snapshot = await uploadTask.whenComplete(() {});

          downlodUrl = await snapshot.ref.getDownloadURL();
        }
        oldDemography = oldDemography.copyWith(
          name: tcName.text,
          data: tcData.text,
          seniors: tcSeniors.text,
          infant: tcInfant.text,
          pregnant: tcPregnant.text,
          infantElevated: tcInfantElevated.text,
          pregnantElevated: tcPregnantElevated.text,
          seniorsElevated: tcSeniorsElevated.text,
          cost: double.tryParse(tcCost.text) ?? oldDemography.cost,
          // minPrice: double.tryParse(tcMinPrice.text) ?? oldDemography.minPrice,
          // maxPrice: double.tryParse(tcMaxPrice.text) ?? oldDemography.maxPrice,
          image: downlodUrl.isEmpty
              ? oldDemography.image
              : downlodUrl.split("&token")[0].trim(),
          details: details,
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
