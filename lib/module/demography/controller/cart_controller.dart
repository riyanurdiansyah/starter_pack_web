import 'dart:convert';

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
import 'package:uuid/uuid.dart';

class CartController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final Rx<String> name = "".obs;
  final RxList<ProdukM> products = <ProdukM>[].obs;
  final RxList<ProdukM> productsOwn = <ProdukM>[].obs;
  Rx<bool> isHovered = false.obs;
  Rx<bool> isDone = false.obs;
  Rx<bool> isLoading = false.obs;

  final AudioPlayer audioPlayer = AudioPlayer();

  RxList<TextEditingController> quantityControllers =
      <TextEditingController>[].obs;

  late SharedPreferences pref;

  Rx<UserM> userSession = userEmpty.obs;

  Rx<GroupM> groupData = groupEmpty.obs;

  Rx<int> indexImg = 0.obs;

  RxList<int> indexSelecteds = <int>[].obs;

  final verticalTranslateController = PageController(viewportFraction: 0.8);

  @override
  void dispose() {
    verticalTranslateController.dispose();
    for (var controller in quantityControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  void onInit() async {
    changeLoading(true);
    verticalTranslateController.addListener(() {
      indexImg.value = verticalTranslateController.page?.round() ?? 0;
    });
    await setup();
    await getLogProduction();
    await getProducts();
    await changeLoading(false);
    super.onInit();
  }

  Future getLogProduction() async {
    final logAssign = await firestore
        .collection("log")
        .where("type", isEqualTo: "production")
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
  }

  Future saveProduct() async {
    var id = const Uuid().v4();
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
                  0,
                  (total, product) =>
                      (total + (product.qty * product.harga)) -
                      product.discount +
                      product.charge)
        });

        await firestore.collection("log").doc(id).set({
          "logId": id,
          "groupId": userSession.value.groupId,
          "type": "production",
          "createdBy": userSession.value.username,
          "createdAt": DateTime.now().toIso8601String(),
        });
      },
    ).then((_) {
      getProducts();
      getLogProduction();
      AppDialog.dialogSnackbar("Data has been saved");
    }).catchError((e) {
      AppDialog.dialogSnackbar("Error while creating : $e");
    });
  }

  Future getProducts() async {
    final response = await firestore
        .collection("produk")
        .where("groups", arrayContains: userSession.value.groupId)
        .get();
    products.value = response.docs.map((e) {
      return ProdukM.fromJson(e.data());
    }).toList();
    products.sort((a, b) => a.nama.compareTo(b.nama));
    quantityControllers.value = List.generate(products.length, (index) {
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
