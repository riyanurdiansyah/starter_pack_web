import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../../utils/app_constanta.dart';
import '../../../utils/app_dialog.dart';
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

  final Rx<bool> isDone = false.obs;

  RxList<Map<String, dynamic>> accessList = <Map<String, dynamic>>[].obs;

  @override
  void onInit() async {
    await setup();
    await getProducts();
    await getDemographys();
    await generateAccess();
    await getLogFinance();
    super.onInit();
  }

  Future setup() async {
    pref = await SharedPreferences.getInstance();
    final user = pref.getString("user");
    if (user != null) {
      userSession.value = UserM.fromJson(json.decode(user));
    }
  }

  Future getLogFinance() async {
    final logAssign = await firestore
        .collection("log")
        .where("type", isEqualTo: "selling_price")
        .where("groupId", isEqualTo: userSession.value.groupId)
        .get();
    if (logAssign.docs.isNotEmpty) {
      isDone.value = true;
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

  void savePrice() async {
    if (formKey.currentState!.validate()) {
      bool adaKosong = accessList.any((e) =>
          (e["controller"] as List<TextEditingController>)
              .any((x) => x.text.isEmpty));
      if (adaKosong) {
        AppDialog.dialogSnackbar("All price fields must be filled.");
      } else {
        final body = {
          "groupId": userSession.value.groupId,
          "areas": demographys.map((e) {
            final demographyJson = e.toJson();

            final controllers =
                (accessList.firstWhere((x) => x["id"] == e.id)["controller"]
                    as List<TextEditingController>);

            demographyJson["products"] = productsOwn.map((product) {
              final index = productsOwn.indexOf(product);

              final price = double.tryParse(controllers[index].text) ?? 0;

              return product.copyWith(priceDistribute: price).toJson();
            }).toList();

            return demographyJson;
          }).toList(),
        };

        // Periksa dokumen dengan groupId
        final querySnapshot = await firestore
            .collection("selling_price")
            .where("groupId", isEqualTo: userSession.value.groupId)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          // Dokumen ditemukan, lakukan update
          final docId = querySnapshot.docs.first.id;
          await firestore.collection("selling_price").doc(docId).update(body);
        } else {
          // Dokumen tidak ditemukan, buat dokumen baru
          final newId = const Uuid().v4();
          body["priceId"] = newId;
          await firestore.collection("selling_price").doc(newId).set(body);
        }

        // Log perubahan
        final id = const Uuid().v4();
        await firestore.collection("log").doc(id).set({
          "logId": id,
          "groupId": userSession.value.groupId,
          "type": "selling_price",
          "createdBy": userSession.value.username,
          "createdAt": DateTime.now().toIso8601String(),
        });

        await getLogFinance();
      }
    }
  }
}
