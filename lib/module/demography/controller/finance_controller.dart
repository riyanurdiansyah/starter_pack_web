import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/app_constanta.dart';
import '../../dashboard/model/demography_m.dart';
import '../../user/model/user_m.dart';
import '../model/produk_m.dart';

class FinanceController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final RxList<DemographyM> demographys = <DemographyM>[].obs;
  Rx<bool> isHovered = false.obs;
  final RxList<ProdukM> products = <ProdukM>[].obs;
  final RxList<ProdukM> productsOwn = <ProdukM>[].obs;

  final RxList<bool> listHovered = <bool>[].obs;
  final formKey = GlobalKey<FormState>();

  late SharedPreferences pref;

  Rx<int> indexSelected = 99.obs;

  Rx<UserM> userSession = userEmpty.obs;

  RxList<Map<String, dynamic>> accessList = <Map<String, dynamic>>[].obs;

  @override
  void onInit() async {
    await setup();
    await getProducts();
    await getDemographys();
    await generateAccess();
    super.onInit();
  }

  Future setup() async {
    pref = await SharedPreferences.getInstance();
    final user = pref.getString("user");
    if (user != null) {
      userSession.value = UserM.fromJson(json.decode(user));
    }
  }

  Future generateAccess() async {
    accessList.value = List.generate(demographys.length, (index) {
      final data = demographys[index];
      return {
        "id": data.id,
        "name": data.name,
        "controller": List.generate(productsOwn.length, (subindex) {
          return TextEditingController(text: "");
        }),
        "controller_price": List.generate(productsOwn.length, (subindex) {
          return TextEditingController(text: "");
        }),
      };
    });
  }

  Future<List<DemographyM>> getDemographys() async {
    final response = await firestore.collection("demography").get();
    demographys.value = response.docs.map((e) {
      return DemographyM.fromJson(e.data());
    }).toList();
    demographys.sort((a, b) => a.name.compareTo(b.name));
    listHovered.value = List.generate(demographys.length, (i) => false);
    return demographys;
  }

  Future getProducts() async {
    final response = await firestore.collection("produk").get();
    products.value = response.docs.map((e) {
      return ProdukM.fromJson(e.data());
    }).toList();
    products.value = products
        .where((e) => e.groups.contains(userSession.value.groupId))
        .toList();
    products.sort((a, b) => a.nama.compareTo(b.nama));
    final responseStock = await firestore
        .collection("group")
        .doc(userSession.value.groupId)
        .collection("production")
        .get();
    productsOwn.value = responseStock.docs.map((e) {
      return ProdukM.fromJson(e.data());
    }).toList();
  }

  void savePrice() {
    log("MASUK");
    if (!formKey.currentState!.validate()) {}
  }
}
