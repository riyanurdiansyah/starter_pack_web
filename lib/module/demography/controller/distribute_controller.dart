import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starter_pack_web/module/demography/model/selling_price_m.dart';
import 'package:uuid/uuid.dart';

import '../../../utils/app_constanta.dart';
import '../../../utils/app_dialog.dart';
import '../../../utils/app_sound.dart';
import '../../dashboard/model/demography_m.dart';
import '../../user/model/group_m.dart';
import '../../user/model/user_m.dart';
import '../model/distribute_m.dart';
import '../model/produk_m.dart';

class DistributeController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final RxList<DemographyM> demographys = <DemographyM>[].obs;
  Rx<bool> isHovered = false.obs;

  Rx<bool> isLoading = false.obs;

  final RxList<ProdukM> products = <ProdukM>[].obs;
  final RxList<ProdukM> productsOwn = <ProdukM>[].obs;

  final RxList<bool> listHovered = <bool>[].obs;
  final formKey = GlobalKey<FormState>();

  late SharedPreferences pref;

  Rx<UserM> userSession = userEmpty.obs;

  Rx<int> indexSelected = 99.obs;

  RxList<int> totalDistributed = <int>[].obs;

  RxList<SellingPriceM> sellings = <SellingPriceM>[].obs;

  // RxList<TextEditingController> quantityControllers =
  //     <TextEditingController>[].obs;

  RxList<Map<String, dynamic>> accessList = <Map<String, dynamic>>[].obs;

  final RxList<bool> listHoveredProduct = <bool>[].obs;

  final imageDemos = [
    "https://firebasestorage.googleapis.com/v0/b/mfg-rakor.appspot.com/o/assets%2Fdemography%2F54.png?alt=media",
    "https://firebasestorage.googleapis.com/v0/b/mfg-rakor.appspot.com/o/assets%2Fdemography%2F55.png?alt=media",
    "https://firebasestorage.googleapis.com/v0/b/mfg-rakor.appspot.com/o/assets%2Fdemography%2F56.png?alt=media",
    "https://firebasestorage.googleapis.com/v0/b/mfg-rakor.appspot.com/o/assets%2Fdemography%2F555.png?alt=media"
  ];

  final Rx<bool> isDone = false.obs;

  final listDistribute = <Map<String, dynamic>>[].obs;

  final tcQty = TextEditingController();

  Rx<GroupM> groupData = groupEmpty.obs;

  RxList<DistributeM> oldDistributions = <DistributeM>[].obs;

  @override
  void onInit() async {
    onChangeLoading(true);
    await setup();
    await getProducts();
    await getDemographys();
    await getSellingPrice();
    await generateAccess();
    await getLogDistribution();
    await getDistribution();
    await onChangeLoading(false);
    super.onInit();
  }

  Future getDistribution() async {
    final snapshot = await firestore
        .collection("distribution")
        .where("groupId", isEqualTo: userSession.value.groupId)
        .get();

    if (snapshot.docs.isNotEmpty) {
      oldDistributions.value =
          snapshot.docs.map((e) => DistributeM.fromJson(e.data())).toList();
    }
  }

  Future getLogDistribution() async {
    final logAssign = await firestore
        .collection("log")
        .where("type", isEqualTo: "distribution")
        .where("groupId", isEqualTo: userSession.value.groupId)
        .get();
    if (logAssign.docs.isNotEmpty) {
      isDone.value = true;
    }
  }

  Future onChangeLoading(bool val) async {
    isLoading.value = val;
  }

  Future setup() async {
    pref = await SharedPreferences.getInstance();
    final user = pref.getString("user");
    if (user != null) {
      userSession.value = UserM.fromJson(json.decode(user));
    }
  }

  Future<List<SellingPriceM>> getSellingPrice() async {
    final response = await firestore
        .collection("selling_price")
        .where("groupId", isEqualTo: userSession.value.groupId)
        .get();
    sellings.value = response.docs.map((e) {
      return SellingPriceM.fromJson(e.data());
    }).toList();
    if (sellings.isNotEmpty) {
      listHoveredProduct.value =
          List.generate(sellings[0].areas.length, (i) => false);
      listDistribute.clear();
      listDistribute.value = List.generate(sellings[0].areas.length, (i) {
        return {
          "areaId": sellings[0].areas[i].id,
          "total": 0,
          "products": List.generate(
              sellings[0].areas[i].products.length, (subindex) => 0),
          "controller": List.generate(
            sellings[0].areas[i].products.length,
            (subindex) => TextEditingController(),
          ),
          "cost": List.generate(
              sellings[0].areas[i].products.length, (subindex) => 0.0),
        };
      });
    }
    return sellings;
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
    totalDistributed.value = List.generate(productsOwn.length, (i) => 0);
  }

  Future generateAccess() async {
    if (sellings.isNotEmpty) {
      accessList.value = List.generate(sellings[0].areas.length, (index) {
        final data = sellings[0].areas[index];
        return {
          "id": data.id,
          "name": data.name,
          "controller": List.generate(data.products.length, (subindex) {
            return TextEditingController(text: "0");
          }),
          "controller_price": List.generate(data.products.length, (subindex) {
            return TextEditingController(text: "0");
          }),
        };
      });
    }
  }

  void incrementQuantity(int index, int subindex) {
    AppSound.playHover();
    if (sellings[0].areas[index].products[subindex].priceDistribute == 0) {
      AppDialog.dialogSnackbar(
          "Please determine the distribution price for this product first!!");
    } else {
      var qTc =
          accessList[index]["controller"][subindex] as TextEditingController;
      int currentQty = int.parse(qTc.text);
      if (sellings[0].areas[index].products[subindex].qty > 0) {
        totalDistributed[subindex] = totalDistributed[subindex] + 1;
        qTc.text = (currentQty + 1).toString();
        sellings[0].areas[index].products[subindex] = sellings[0]
            .areas[index]
            .products[subindex]
            .copyWith(qty: sellings[0].areas[index].products[subindex].qty - 1);
      }
    }
  }

  void decrementQuantity(int index, int subindex) {
    AppSound.playHover();
    var qTc =
        accessList[index]["controller"][subindex] as TextEditingController;
    int currentQty = int.parse(qTc.text);
    if (currentQty > 0 && sellings[0].areas[index].products[subindex].qty > 0) {
      totalDistributed[subindex] = totalDistributed[subindex] - 1;
      qTc.text = (currentQty - 1).toString();
      productsOwn[subindex] =
          productsOwn[subindex].copyWith(qty: productsOwn[subindex].qty + 1);
    }
  }

  Future saveDistribute(double totalDistributionCost) async {
    // if (formKey.currentState!.validate()) {
    final id = const Uuid().v4();
    Map<String, AreaM> groupedAreas = {};

    for (int i = 0; i < demographys.length; i++) {
      for (int j = 0; j < productsOwn.length; j++) {
        final priceTc = sellings[0].areas[i].products[j].priceDistribute;
        // var qTc = accessList[i]["controller"][j] as TextEditingController;
        var qTc = listDistribute[i]["controller"][j] as TextEditingController;

        int currentQty = int.tryParse(qTc.text) ?? 0;

        productsOwn[j] = productsOwn[j].copyWith(
          qty: productsOwn[j].qty - currentQty,
        );

        // if (qtyTc.trim().isNotEmpty) {
        final areaId = demographys[i].id;
        final product = ProductDistributeM(
          productId: productsOwn[j].id,
          productName: "${productsOwn[j].nama} - ${productsOwn[j].tipe}",
          pricePerProduct: priceTc.toDouble(),
          qty: currentQty,
          sold: 0,
          profit: 0,
        );

        if (groupedAreas.containsKey(areaId)) {
          groupedAreas[areaId]!.products.add(product);
        } else {
          groupedAreas[areaId] = AreaM(
            areaId: areaId,
            areaName: demographys[i].name,
            products: [product],
          );
        }
        // }
      }
    }

    final groupedAreasList = groupedAreas.values.toList();

    DistributeM dataDistribute;

    final snapshot = await firestore
        .collection("distribution")
        .where("groupId", isEqualTo: userSession.value.groupId)
        .get();

    if (snapshot.docs.isNotEmpty) {
      dataDistribute = DistributeM.fromJson(snapshot.docs[0].data());

      for (var newArea in groupedAreasList) {
        final existingAreaIndex = dataDistribute.areas.indexWhere(
            (existingArea) => existingArea.areaId == newArea.areaId);

        if (existingAreaIndex != -1) {
          final existingArea = dataDistribute.areas[existingAreaIndex];

          for (var newProduct in newArea.products) {
            final existingProductIndex = existingArea.products.indexWhere(
                (existingProduct) =>
                    existingProduct.productId == newProduct.productId);

            if (existingProductIndex != -1) {
              final existingProduct =
                  existingArea.products[existingProductIndex];

              existingArea.products[existingProductIndex] =
                  existingProduct.copyWith(
                qty: existingProduct.qty + newProduct.qty,
                pricePerProduct: newProduct.pricePerProduct,
              );
            } else {
              existingArea.products.add(newProduct);
            }
          }
          dataDistribute.areas[existingAreaIndex] = existingArea;
        } else {
          dataDistribute.areas.add(newArea);
        }
      }
    } else {
      // Jika data belum ada di Firestore
      dataDistribute = DistributeM(
        distributeId: id,
        cycleId: "",
        groupId: userSession.value.groupId,
        groupName: userSession.value.kelompok,
        areas: groupedAreasList,
        page: 0,
      );
    }

    // Simpan data ke Firestore
    await firestore.runTransaction((trx) async {
      await firestore
          .collection("distribution")
          .doc(dataDistribute.distributeId)
          .set(dataDistribute.toJson());
      for (var item in productsOwn) {
        await FirebaseFirestore.instance
            .collection("group")
            .doc(userSession.value.groupId)
            .collection("production")
            .doc(item.id)
            .update(item.toJson());
      }

      await FirebaseFirestore.instance
          .collection("group")
          .doc(userSession.value.groupId)
          .update({
        "point": groupData.value.point - totalDistributionCost,
      });

      await firestore.collection("log").doc(id).set({
        "logId": id,
        "groupId": userSession.value.groupId,
        "type": "distribution",
        "createdBy": userSession.value.username,
        "createdAt": DateTime.now().toIso8601String(),
      });
    }).then((_) async {
      onChangeLoading(true);
      await getProducts();
      await getDemographys();
      await getSellingPrice();
      await getLogDistribution();
      await getDistribution();
      await onChangeLoading(false);
      AppDialog.dialogSnackbar("Data has been saved");
    }).catchError((e) {
      AppDialog.dialogSnackbar("Error while creating : $e");
    });
  }
  // }

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
