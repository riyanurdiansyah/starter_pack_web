import 'dart:convert';
import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starter_pack_web/middleware/app_route.dart';
import 'package:starter_pack_web/module/demography/model/produk_m.dart';
import 'package:starter_pack_web/module/user/model/group_m.dart';
import 'package:starter_pack_web/module/user/model/user_m.dart';
import 'package:starter_pack_web/utils/app_constanta.dart';
import 'package:starter_pack_web/utils/app_dialog.dart';
import 'package:starter_pack_web/utils/app_sound.dart';

class CartController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final Rx<String> name = "".obs;
  final RxList<ProdukM> products = <ProdukM>[].obs;
  final RxList<ProdukM> productsOwn = <ProdukM>[].obs;
  Rx<bool> isHovered = false.obs;

  final AudioPlayer audioPlayer = AudioPlayer();

  List<TextEditingController> quantityControllers = [];

  late SharedPreferences pref;

  Rx<UserM> userSession = userEmpty.obs;

  Rx<GroupM> groupData = groupEmpty.obs;

  @override
  void dispose() {
    for (var controller in quantityControllers) {
      controller.dispose();
    }
    super.dispose();
  }

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

  Future saveProduct() async {
    bool isUpdate = false;
    navigatorKey.currentContext!.pop();
    AppSound.playButton();
    CollectionReference collection = firestore
        .collection('group')
        .doc(groupData.value.id)
        .collection('production');

    var data = await collection.get();
    if (data.docs.isNotEmpty) {
      isUpdate = true;
    }
    firestore.runTransaction(
      (trx) async {
        for (var item in products) {
          var itemJson = item.toJson();
          itemJson["qty"] = FieldValue.increment(itemJson["qty"]);
          itemJson["updated_by"] = userSession.value.username;
          itemJson["updated_date"] = DateTime.now().toIso8601String();
          if (!isUpdate) {
            itemJson["created_by"] = userSession.value.username;
            itemJson["created_date"] = DateTime.now().toIso8601String();
          }
          collection.doc(item.id).set(itemJson, SetOptions(merge: true));
        }

        await FirebaseFirestore.instance
            .collection("group")
            .doc(userSession.value.groupId)
            .update({
          "point": groupData.value.point -
              products.fold(
                  0, (total, product) => total + (product.qty * product.harga)),
        });
      },
    ).then((_) {
      getProducts();
      AppDialog.dialogSnackbar("Data has been saved");
    }).catchError((e) {
      AppDialog.dialogSnackbar("Error while creating : $e");
    });
  }

  Future getProducts() async {
    final response = await firestore.collection("produk").get();
    products.value = response.docs.map((e) {
      return ProdukM.fromJson(e.data());
    }).toList();
    products.sort((a, b) => a.nama.compareTo(b.nama));
    quantityControllers = List.generate(products.length, (index) {
      return TextEditingController(text: products[index].qty.toString());
    });

    final responseStock = await firestore
        .collection("group")
        .doc(userSession.value.groupId)
        .collection("production")
        .get();
    productsOwn.value = responseStock.docs.map((e) {
      return ProdukM.fromJson(e.data());
    }).toList();
  }

  void incrementQuantity(int index) {
    AppSound.playHover();
    int currentQty = int.parse(quantityControllers[index].text);
    quantityControllers[index].text = (currentQty + 1).toString();
    products[index] = products[index].copyWith(qty: currentQty + 1);
    log(products[index].toJson().toString());
  }

  void decrementQuantity(int index) {
    AppSound.playHover();
    int currentQty = int.parse(quantityControllers[index].text);
    if (currentQty > 0) {
      quantityControllers[index].text = (currentQty - 1).toString();
      products[index] = products[index].copyWith(qty: currentQty - 1);
    }
  }

  Stream<GroupM> groupStream() {
    return FirebaseFirestore.instance
        .collection('group')
        .doc(userSession.value.groupId)
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists) {
        groupData.value =
            GroupM.fromJson(snapshot.data() as Map<String, dynamic>);
        return groupData.value;
      } else {
        throw Exception("Data not found");
      }
    });
  }
}
