import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starter_pack_web/module/rnd/model/config_simbis_m.dart';
import 'package:starter_pack_web/utils/app_dialog.dart';
import 'package:uuid/uuid.dart';

import '../../../utils/app_constanta.dart';
import '../../../utils/app_sound.dart';
import '../../demography/model/produk_m.dart';
import '../../user/model/user_m.dart';

class RndController extends GetxController {
  final RxList<ConfigSimbs> configSimbis = <ConfigSimbs>[].obs;
  final RxList<ProdukM> products = <ProdukM>[].obs;
  final RxList<ProdukM> productsOwn = <ProdukM>[].obs;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  late SharedPreferences pref;

  Rx<UserM> userSession = userEmpty.obs;

  Rx<bool> isHovered = false.obs;

  Rx<bool> isLoading = false.obs;

  Rx<bool> isDone = false.obs;

  RxList<String> checkedProducts = <String>[].obs;

  Rx<int> indexImg = 0.obs;

  RxList<int> indexSelecteds = <int>[].obs;

  final verticalTranslateController = PageController(viewportFraction: 0.8);

  @override
  void onInit() async {
    changeLoading(true);
    verticalTranslateController.addListener(() {
      indexImg.value = verticalTranslateController.page?.round() ?? 0;
    });
    await setup();
    await getLogRND();
    await getProducts();
    await changeLoading(false);
    super.onInit();
  }

  Future getLogRND() async {
    final logAssign = await firestore
        .collection("log")
        .where("type", isEqualTo: "rnd")
        .where("groupId", isEqualTo: userSession.value.groupId)
        .get();
    if (logAssign.docs.isNotEmpty) {
      isDone.value = true;
    }
  }

  Future changeLoading(bool val) async {
    isLoading.value = val;
  }

  void nextPage() {
    if ((products.length - 1) > indexImg.value) {
      AppSound.playHover();
      indexImg.value++;
    } else {
      indexImg.value = 0;
    }
  }

  void previousPage() {
    if (indexImg.value > 0) {
      AppSound.playHover();
      indexImg.value--;
    } else {
      indexImg.value = products.length - 1;
    }
  }

  Future setup() async {
    pref = await SharedPreferences.getInstance();
    final user = pref.getString("user");
    if (user != null) {
      userSession.value = UserM.fromJson(json.decode(user));
    }

    final response = await firestore.collection("simbis").get();
    configSimbis.value = response.docs.map((e) {
      return ConfigSimbs.fromJson(e.data());
    }).toList();
  }

  Future getProducts() async {
    final response = await firestore.collection("produk").get();
    products.value = response.docs.map((e) {
      return ProdukM.fromJson(e.data());
    }).toList();
    products.sort((a, b) => a.nama.compareTo(b.nama));

    productsOwn.value = products.where((produk) {
      return produk.groups.contains(userSession.value.groupId);
    }).toList();
  }

  void onCheckProduct(String id) async {
    if (checkedProducts.contains(id)) {
      checkedProducts.remove(id);
    } else {
      if (checkedProducts.length == 3) {
        AppDialog.dialogSnackbar("The product must not exceed 3 !!");
      } else {
        checkedProducts.add(id);
      }
    }
  }

  Future saveProduct() async {
    var id = const Uuid().v4();
    try {
      await firestore.runTransaction((transaction) async {
        products.value = products.map((produk) {
          // Hapus groupId yang sesuai dengan userGroupId
          produk.groups.removeWhere((id) => id == userSession.value.groupId);
          return produk;
        }).toList();
        for (var item in products) {
          var itemJson = item.toJson();
          if (checkedProducts.contains(item.id)) {
            itemJson['groups'] =
                FieldValue.arrayUnion([userSession.value.groupId]);
          }

          // Referensi dokumen di Firestore
          DocumentReference docRef =
              firestore.collection("produk").doc(item.id);

          // Lakukan update dalam transaksi
          transaction.update(docRef, itemJson);
        }
        final filteredCase = configSimbis.firstWhereOrNull((item) {
          return DateTime.now().isAfter(DateTime.parse(item.start)) &&
              DateTime.now().isBefore(DateTime.parse(item.end));
        });

        await firestore.collection("log").doc(id).set({
          "logId": id,
          "groupId": userSession.value.groupId,
          "type": "rnd",
          "week": filteredCase?.name ?? "",
          "createdAt": DateTime.now().toIso8601String(),
        });
      });

      // Jika transaksi sukses
      getLogRND();
      AppDialog.dialogSnackbar("Data has been saved");
    } catch (e) {
      // Jika ada kesalahan, transaksi akan dibatalkan
      AppDialog.dialogSnackbar("Error while saving: $e");
    }
  }

  void onSelect() {
    onCheckProduct(products[indexImg.value].id);
    if (indexSelecteds.contains(indexImg.value)) {
      indexSelecteds.remove(indexImg.value);
    } else {
      if (indexSelecteds.length < 3) {
        indexSelecteds.add(indexImg.value);
      }
    }
  }

  void onRemove(int index) {
    onCheckProduct(products[index].id);
    if (indexSelecteds.contains(index)) {
      indexSelecteds.remove(index);
    } else {
      indexSelecteds.add(index);
    }
  }
}
