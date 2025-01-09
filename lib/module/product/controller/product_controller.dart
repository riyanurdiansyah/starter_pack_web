import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:starter_pack_web/module/demography/model/produk_m.dart';
import 'package:starter_pack_web/utils/app_dialog.dart';

class ProductController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final RxList<ProdukM> products = <ProdukM>[].obs;
  final RxList<ProdukM> productsSearch = <ProdukM>[].obs;

  final Rx<bool> isSearched = false.obs;

  FilePickerResult? filePickerResult;

  Rx<int> currentPage = 1.obs;
  Rx<int> dataPerPage = 8.obs;

  final tcPrice = TextEditingController();

  @override
  void onInit() async {
    await getProducts();
    super.onInit();
  }

  Future<List<ProdukM>> getProducts() async {
    final response = await firestore.collection("produk").get();
    products.value = response.docs.map((e) {
      return ProdukM.fromJson(e.data());
    }).toList();
    products.sort((a, b) => a.nama.compareTo(b.nama));

    double pageTemp = 0;
    for (int i = 0; i < products.length; i++) {
      pageTemp = (i + 1) ~/ 8 < 1 ? 1 : (i + 1) / 8;
      products[i] = products[i].copyWith(page: pageTemp.ceil());
    }
    return products;
  }

  List<ProdukM> isUsingProduct() {
    if (isSearched.value) {
      return productsSearch.where((e) => e.page == currentPage.value).toList();
    }
    return products.where((e) => e.page == currentPage.value).toList();
  }

  int isTotalPage() {
    if (isSearched.value) {
      return (productsSearch.length / dataPerPage.value).ceil() == 0
          ? 1
          : (productsSearch.length / dataPerPage.value).ceil();
    }
    return (products.length / dataPerPage.value).ceil() == 0
        ? 1
        : (products.length / dataPerPage.value).ceil();
  }

  void onChangepage(int newValue) {
    currentPage.value = newValue;
  }

  void onSearched(String query) {
    double pageTemp = 0;
    List<ProdukM> productsTemp = [];
    if (query.isEmpty) {
      isSearched.value = false;
      productsTemp.clear();
      productsSearch.clear();
    } else {
      isSearched.value = true;
      productsTemp = products
          .where((e) => e.nama.toLowerCase().contains(query.toLowerCase()))
          .toList();
      for (int i = 0; i < productsTemp.length; i++) {
        pageTemp = (i + 1) / dataPerPage.value;
        productsTemp[i] = productsTemp[i].copyWith(page: pageTemp.ceil());
      }
      productsSearch.value = productsTemp;
      productsSearch.sort((a, b) => a.nama.compareTo(b.nama));
    }
  }

  void setValueProduk(ProdukM oldProduk) {
    tcPrice.text = oldProduk.harga.toString();
  }

  void updateProduk(ProdukM oldProduk) {
    final String newPrice = tcPrice.text.trim();
    final int newPriceDouble = int.parse(newPrice);
    final ProdukM newProduk = oldProduk.copyWith(harga: newPriceDouble);
    firestore
        .collection('produk')
        .doc(oldProduk.id)
        .update(newProduk.toJson())
        .then((value) {
      AppDialog.dialogSnackbar("Update Successfully");
      getProducts();
    });
  }
}
