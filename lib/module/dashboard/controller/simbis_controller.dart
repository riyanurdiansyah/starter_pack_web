import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starter_pack_web/module/dashboard/model/result_simbis_m.dart';
import 'package:starter_pack_web/module/demography/model/simulation_m.dart';
import 'package:starter_pack_web/utils/app_dialog.dart';

import '../../../utils/app_constanta.dart';
import '../../demography/model/distribute_m.dart';
import '../../user/model/user_m.dart';
import '../model/demography_m.dart';

class SimbisController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final RxList<DemographyM> demographys = <DemographyM>[].obs;
  final RxList<DistributeM> distributes = <DistributeM>[].obs;
  final RxList<ResultSimbisM> resultSimbis = <ResultSimbisM>[].obs;
  final Rx<String> result = "...".obs;
  final Rx<bool> isLoading = false.obs;

  late SharedPreferences pref;

  Rx<UserM> userSession = userEmpty.obs;

  final RxList<ResultSimbisM> resultSimbisSearch = <ResultSimbisM>[].obs;
  final Rx<bool> isSearched = false.obs;

  Rx<int> currentPage = 1.obs;
  Rx<int> dataPerPage = 5.obs;

  @override
  void onInit() async {
    await setup();
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
    demographys.sort((a, b) => a.name.compareTo(b.name));
    return demographys;
  }

  Future<List<DistributeM>> getDistribute() async {
    final response = await firestore.collection("distribution").get();
    distributes.value = response.docs.map((e) {
      return DistributeM.fromJson(e.data());
    }).toList();
    return distributes;
  }

  Future generateResult() async {
    isLoading.value = true;
    String demoData = "Simpan Dataset Demography ini :";
    // List<Map<String, dynamic>> datas = [];
    List<SimulationM> simulations = [];
    for (var item in demographys) {
      demoData = "$demoData \n${item.name}: ${item.data}";
    }

    for (var item in distributes) {
      simulations.add(
        SimulationM(
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
                  qty: x.qty,
                );
              }).toList(),
            );
          }).toList(),
        ),
      );
    }
    try {
      final data = {
        "model": "gpt-4o-mini",
        "response_format": {"type": "json_object"},
        "temperature": 0.5,
        "max_tokens": 5000,
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
                      dengan data di atas buatkan simulasi penjualan dengan berdasarkan dataset demography yg sudah ada. berikan angka random sesuai dengan dataset demography dan tidak perlu semua qty product terjual habis. dengan format json berikut 
                      result:
                      [
                          {
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
                                              "profit" : 0
                                          }
                                      ]
                                  }
                              ]
                          }
                      ]

                      BALAS HANYA JSON SAJA!.
                  ''',
          }
        ]
      };
      Dio dio = Dio();
      var aiKey = dotenv.env['API_KEY'];
      final response = await dio.post(
        "https://api.openai.com/v1/chat/completions",
        data: data,
        options: Options(headers: {
          "Authorization": "Bearer $aiKey",
        }),
      );
      // final dataJSON = json
      //     .decode();
      final dataJSON = jsonDecode(
              response.data["choices"][0]["message"]["content"])["result"]
          as List<dynamic>;
      resultSimbis.value = dataJSON.map((e) {
        return ResultSimbisM.fromJson(e);
      }).toList();
      resultSimbis.sort((a, b) => a.groupName.compareTo(b.groupName));
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      log("CEK RES ERROR: $e");
      AppDialog.dialogSnackbar("Failed generate simbis : $e");
    }
  }

  List<ResultSimbisM> isUsingSimbis() {
    if (isSearched.value) {
      return resultSimbisSearch;
    }
    return resultSimbis;
  }

  int isTotalPage() {
    if (isSearched.value) {
      return (resultSimbisSearch.length / dataPerPage.value).ceil() == 0
          ? 1
          : (resultSimbisSearch.length / dataPerPage.value).ceil();
    }
    return (resultSimbis.length / dataPerPage.value).ceil() == 0
        ? 1
        : (resultSimbis.length / dataPerPage.value).ceil();
  }

  void onChangepage(int newValue) {
    currentPage.value = newValue;
  }

  void onSearched(String query) {
    double pageTemp = 0;
    List<ResultSimbisM> simbisTemp = [];
    if (query.isEmpty) {
      isSearched.value = false;
      simbisTemp.clear();
      resultSimbisSearch.clear();
    } else {
      isSearched.value = true;
      simbisTemp = resultSimbis
          .where((e) => e.groupName.toLowerCase().contains(query.toLowerCase()))
          .toList();
      for (int i = 0; i < simbisTemp.length; i++) {
        pageTemp = (i + 1) / dataPerPage.value;
        simbisTemp[i] = simbisTemp[i].copyWith(page: pageTemp.ceil());
      }
      resultSimbisSearch.value = simbisTemp;
    }
  }
}
