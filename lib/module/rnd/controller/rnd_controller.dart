import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starter_pack_web/utils/app_dialog.dart';

import '../../../utils/app_constanta.dart';
import '../../demography/model/produk_m.dart';
import '../../user/model/user_m.dart';

class RndController extends GetxController {
  final RxList<ProdukM> products = <ProdukM>[].obs;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  late SharedPreferences pref;

  Rx<UserM> userSession = userEmpty.obs;

  Rx<bool> isHovered = false.obs;

  Rx<bool> isDone = false.obs;

  RxList<String> checkedProducts = <String>[].obs;

  @override
  void onInit() async {
    await setup();
    await getProducts();
    super.onInit();
  }

  Future setup() async {
    pref = await SharedPreferences.getInstance();
    final user = pref.getString("user");
    if (user != null) {
      userSession.value = UserM.fromJson(json.decode(user));
    }
  }

  Future getProducts() async {
    final response = await firestore.collection("produk").get();
    products.value = response.docs.map((e) {
      return ProdukM.fromJson(e.data());
    }).toList();
    products.sort((a, b) => a.nama.compareTo(b.nama));
    if (products
        .where((e) => e.groups.contains(userSession.value.groupId))
        .toList()
        .isNotEmpty) {
      isDone.value = true;
    }
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
    try {
      await firestore.runTransaction((transaction) async {
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
      });

      // Jika transaksi sukses
      getProducts();
      AppDialog.dialogSnackbar("Data has been saved");
    } catch (e) {
      // Jika ada kesalahan, transaksi akan dibatalkan
      AppDialog.dialogSnackbar("Error while saving: $e");
    }
  }
}
