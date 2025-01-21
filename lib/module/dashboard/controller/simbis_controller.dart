import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starter_pack_web/module/dashboard/model/result_simbis_m.dart';
import 'package:starter_pack_web/module/demography/model/simulation_m.dart';
import 'package:starter_pack_web/module/rnd/model/config_simbis_m.dart';
import 'package:uuid/uuid.dart';

import '../../../utils/app_constanta.dart';
import '../../../utils/app_dialog.dart';
import '../../demography/model/distribute_m.dart';
import '../../user/model/user_m.dart';
import '../model/demography_m.dart';

class SimbisController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final RxList<DemographyM> demographys = <DemographyM>[].obs;
  final RxList<DistributeM> distributes = <DistributeM>[].obs;
  final RxList<DistributeM> distributesSearch = <DistributeM>[].obs;
  final RxList<ResultSimbisM> resultSimbis = <ResultSimbisM>[].obs;
  final Rx<String> result = "...".obs;
  final Rx<bool> isLoading = false.obs;
  final Rx<String> apiKey = "".obs;

  late SharedPreferences pref;

  Rx<UserM> userSession = userEmpty.obs;

  // final RxList<ResultSimbisM> resultSimbisSearch = <ResultSimbisM>[].obs;

  // final RxList<DistributeM> resultDistribute = <DistributeM>[].obs;
  // final RxList<DistributeM> distributesSearch = <DistributeM>[].obs;
  final Rx<bool> isSearched = false.obs;

  Rx<int> currentPage = 1.obs;
  Rx<int> dataPerPage = 2.obs;

  List<String> groupNames = ["Group"];
  @override
  void onInit() async {
    await setup();
    await getConfig();
    await getDemographys();
    await getDistribute();
    super.onInit();
  }

  Future setup() async {
    pref = await SharedPreferences.getInstance();
    final user = pref.getString("user");
    if (user != null) {
      userSession.value = UserM.fromJson(json.decode(user));
    }
  }

  Future<List<DemographyM>> getDemographys() async {
    final response = await firestore.collection("demography").get();
    demographys.value = response.docs.map((e) {
      return DemographyM.fromJson(e.data());
    }).toList();
    return demographys;
  }

  Future getConfig() async {
    final response =
        await firestore.collection("config").doc("wEhYq9rOXtSQpURMLUwF").get();
    if (response.exists) {
      apiKey.value = response.data()!["apiKey"];
    }
  }

  Future<List<DistributeM>> getDistribute() async {
    final response = await firestore.collection("distribution").get();
    distributes.value = response.docs.map((e) {
      return DistributeM.fromJson(e.data());
    }).toList();
    var list = distributes
        .expand((distribute) => distribute.areas)
        .map((area) => area.areaName)
        .toSet()
        .toList();
    for (var item in list) {
      groupNames.add(item);
    }
    return distributes;
  }

  Future generateResult() async {
    isLoading.value = true;
    ConfigSimbs? configSimbs;
    final response = await firestore
        .collection("simbis")
        .where("isActive", isEqualTo: true)
        .get();
    if (response.docs.isNotEmpty) {
      configSimbs = ConfigSimbs.fromJson(response.docs[0].data());
    }
    String demoData = "Simpan Dataset Demography ini : ";
    List<SimulationM> simulations = [];

// Pastikan demographys berisi data
    for (var item in demographys) {
      if (item.specialCase.isNotEmpty) {
        demoData =
            "$demoData ${json.encode(item.name)}: ${json.encode(item.data)}. Special Case : Special Case: freeze demand=0, dimarket Susu Bayi Affordable & Susu Bayi Premium.";
      } else {
        demoData =
            "$demoData ${json.encode(item.name)}: ${json.encode(item.data)}";
      }
    }

    for (var item in distributes) {
      simulations.add(
        SimulationM(
          cycleId: configSimbs?.id ?? const Uuid().v4(),
          distributeId: item.distributeId,
          groupId: item.groupId,
          groupName: item.groupName,
          productSell: item.areas.map((e) {
            return SimulationAreaM(
              areaId: e.areaId,
              areaName: e.areaName,
              products: e.products.map((x) {
                return SimulationProductM(
                  productId: x.productId,
                  productName: x.productName,
                  pricePerProduct: x.pricePerProduct,
                  qty: x.qty - x.sold,
                );
              }).toList(),
            );
          }).toList(),
        ),
      );
    }
    simulations = simulations.where((simulation) {
      return simulation.productSell.any((area) {
        return area.products.any((product) => product.qty > 0);
      });
    }).toList();
    log("CEK BODY : $demoData");
    log("CEK BODY 2 : ${jsonEncode(simulations)}");
    try {
      final data = {
        "model": "gpt-4o",
        "response_format": {"type": "json_object"},
        "temperature": 0.5,
        "max_tokens": 16383,
        "messages": [
          {
            "role": "system",
            "content": demoData,
          },
          {
            "role": "user",
            "content": jsonEncode(simulations),
          },
          {
            "role": "user",
            "content": '''
                      Perhitungan Penjualan per Area
                      1. Jika pasar affordable, maka simulasi menunjukkan produk dengan harga lebih rendah akan habis terlebih dahulu.
                      2. Jika pasar premium, sensitivitas harga rendah, sehingga penjualan didominasi oleh produk berkualitas tinggi tanpa pengaruh besar pada harga.               
                      Asumsinya, setiap pembeli hanya membeli satu item dalam setiap transaksi, tanpa membeli beberapa item sekaligus. Misalnya, seorang ibu hamil tidak akan membeli susu ibu hamil lagi jika persediaan susu yang dimilikinya belum habis.                     
                      Simulasikan penjualan masing-masing kelompok selama 4 hari, berdasarkan kondisi demografi masing-masing area yang tersedia mempertimbangkan 
                      Pembelian dapat dilakukan selama 30hari, dengan nilai daya beli setara 4 hari. Buat grafik penjualan yang kompetitif berdasarkan dengan tipe produk dan harga produk.     
                      dengan format json berikut.
                      conclusions: [
                        {
                          "areaId" : "...",
                          "areaName" : "...",
                          "cycleId" : "...",
                          "conclusion" : "...",
                        }
                      ]
                      result:
                      [
                          {
                              "distributeId" : "...",
                              "cycleId" : "...",
                              "groupId" : "...",
                              "groupName" : "...",
                              "summary" : [
                                  {
                                      "areaId" : "...",
                                      "areaName" : "...",
                                      "products" : [
                                          {
                                              "productId" : "...",
                                              "productName" : "...",
                                              "sold" : 0,
                                              "revenue" : 0
                                          }
                                      ]
                                  }
                              ]
                          }
                      ]
                  ''',
          }
        ]
      };

      // Dio dio = Dio();
      // final response = await dio.post(
      //   "https://api.openai.com/v1/chat/completions",
      //   data: data,
      //   options: Options(headers: {
      //     "Authorization": "Bearer ${apiKey.value}",
      //   }),
      // );

      // // final dataJSON = json
      // //     .decode();
      // final dataJSON = jsonDecode(
      //         response.data["choices"][0]["message"]["content"])["result"]
      //     as List<dynamic>;
      // final dataJSONConclu = jsonDecode(
      //         response.data["choices"][0]["message"]["content"])["conclusions"]
      //     as List<dynamic>;
      // resultSimbis.value = dataJSON.map((e) {
      //   return ResultSimbisM.fromJson(e);
      // }).toList();

      // await updateData(distributes.map((e) => e.toJson()).toList(),
      //     resultSimbis.map((e) => e.toJson()).toList());

      // for (var item in dataJSONConclu) {
      //   item["id"] = const Uuid().v4();
      //   await firestore.collection("conclusions").doc(item["id"]).set(item);
      // }

      // for (var item in convertDistributeMToMap(distributes)) {
      //   await firestore
      //       .collection("distribution_log_new")
      //       .doc(item["id"])
      //       .set(item);
      // }

      // for (var i = 0; i < distributes.length; i++) {
      //   for (var j = 0; j < distributes[i].areas.length; j++) {
      //     for (var k = 0; k < distributes[i].areas[j].products.length; k++) {
      //       distributes[i].areas[j].products[k] =
      //           distributes[i].areas[j].products[k].copyWith(
      //                 qty: distributes[i].areas[j].products[k].qty -
      //                     distributes[i].areas[j].products[k].sold,
      //               );
      //     }
      //   }
      //   await firestore
      //       .collection("distribution")
      //       .doc(distributes[i].distributeId)
      //       .update(distributes[i].toJson());
      // }

      // await getDistribute();

      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      log(e.toString());
      AppDialog.dialogSnackbar("Failed generate simbis : $e");
    }
  }

  List<Map<String, dynamic>> convertDistributeMToMap(
      List<DistributeM> distributeList) {
    return distributeList.expand((distribute) {
      return distribute.areas.map((area) {
        return {
          "id": const Uuid().v4(),
          "cycleId": distribute.cycleId,
          "areaId": area.areaId,
          "areaName": area.areaName,
          "groupId": distribute.groupId,
          "groupName": distribute.groupName,
          "products": area.products.map((product) {
            return {
              "productId": product.productId,
              "productName": product.productName,
              "revenue": product.profit,
              "qty": product.qty,
              "sold": product.sold,
            };
          }).toList(),
        };
      }).toList();
    }).toList();
  }

  List<DistributeM> isUsingSimbis() {
    return distributes;
  }

  int isTotalPage() {
    if (isSearched.value) {
      return (distributesSearch.length / dataPerPage.value).ceil() == 0
          ? 1
          : (distributesSearch.length / dataPerPage.value).ceil();
    }
    return (distributes.length / dataPerPage.value).ceil() == 0
        ? 1
        : (distributes.length / dataPerPage.value).ceil();
  }

  void onChangepage(int newValue) {
    currentPage.value = newValue;
  }

  void onSearched(String query) {
    double pageTemp = 0;
    List<DistributeM> simbisTemp = [];
    if (query.isEmpty) {
      isSearched.value = false;
      simbisTemp.clear();
      distributesSearch.clear();
    } else {
      isSearched.value = true;
      simbisTemp = distributes
          .where((e) => e.groupName.toLowerCase().contains(query.toLowerCase()))
          .toList();
      for (int i = 0; i < simbisTemp.length; i++) {
        pageTemp = (i + 1) / dataPerPage.value;
        simbisTemp[i] = simbisTemp[i].copyWith(page: pageTemp.ceil());
      }
      distributesSearch.value = simbisTemp;
    }
  }

  Future updateData(List<Map<String, dynamic>> baseData,
      List<Map<String, dynamic>> generatedData) async {
    for (var base in baseData) {
      String distributeId = base['distributeId'];
      var matchingGenerated = generatedData.firstWhere(
        (gen) => gen['distributeId'] == distributeId,
      );

      base["cycleId"] = matchingGenerated["cycleId"];

      for (var baseArea in base['areas']) {
        String areaId = baseArea['areaId'];
        var matchingArea = matchingGenerated['summary'].firstWhere(
          (area) => area['areaId'] == areaId,
        );

        if (matchingArea != null) {
          for (var baseProduct in baseArea['products']) {
            String productId = baseProduct['productId'];
            var matchingProduct = matchingArea['products'].firstWhere(
              (product) => product['productId'] == productId,
            );

            if (matchingProduct != null) {
              // Add sold and profit to base product
              baseProduct['sold'] = matchingProduct['sold'];
              baseProduct['profit'] = matchingProduct['profit'];
            }
          }
        }
      }
    }
    distributes.value = baseData.map((e) => DistributeM.fromJson(e)).toList();
  }
}
