import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:starter_pack_web/module/demography/model/produk_m.dart';

class CartController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final Rx<String> name = "".obs;
  final RxList<ProdukM> products = <ProdukM>[].obs;
  Rx<bool> isHovered = false.obs;

  List<TextEditingController> quantityControllers = [];

  @override
  void dispose() {
    for (var controller in quantityControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  void onInit() async {
    await getProducts();
    super.onInit();
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
  }

  void incrementQuantity(int index) {
    int currentQty = int.parse(quantityControllers[index].text);
    quantityControllers[index].text = (currentQty + 1).toString();
    products[index] = products[index].copyWith(qty: currentQty + 1);
    log(products[index].toJson().toString());
  }

  void decrementQuantity(int index) {
    int currentQty = int.parse(quantityControllers[index].text);
    if (currentQty > 0) {
      quantityControllers[index].text = (currentQty - 1).toString();
      products[index] = products[index].copyWith(qty: currentQty - 1);
    }
  }
}
