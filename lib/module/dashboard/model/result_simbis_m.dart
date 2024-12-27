// To parse this JSON data, do
//
//     final resultSimbisM = resultSimbisMFromJson(jsonString);

import 'dart:convert';

ResultSimbisM resultSimbisMFromJson(String str) =>
    ResultSimbisM.fromJson(json.decode(str));

String resultSimbisMToJson(ResultSimbisM data) => json.encode(data.toJson());

// class ResultSimbisM {
//   final List<Result> result;

//   ResultSimbisM({
//     required this.result,
//   });

//   ResultSimbisM copyWith({
//     List<Result>? result,
//   }) =>
//       ResultSimbisM(
//         result: result ?? this.result,
//       );

//   factory ResultSimbisM.fromJson(Map<String, dynamic> json) => ResultSimbisM(
//         result:
//             List<Result>.from(json["result"].map((x) => Result.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "result": List<dynamic>.from(result.map((x) => x.toJson())),
//       };
// }

class ResultSimbisM {
  final String distributeId;
  final String groupId;
  final String groupName;
  final List<Summary> summary;
  final int page;

  ResultSimbisM({
    required this.distributeId,
    required this.groupId,
    required this.groupName,
    required this.summary,
    required this.page,
  });

  ResultSimbisM copyWith({
    String? distributeId,
    String? groupId,
    String? groupName,
    List<Summary>? summary,
    int? page,
  }) =>
      ResultSimbisM(
        distributeId: distributeId ?? this.distributeId,
        groupId: groupId ?? this.groupId,
        groupName: groupName ?? this.groupName,
        summary: summary ?? this.summary,
        page: page ?? this.page,
      );

  factory ResultSimbisM.fromJson(Map<String, dynamic> json) => ResultSimbisM(
        distributeId: json["distributeId"],
        groupId: json["groupId"],
        groupName: json["groupName"],
        summary:
            List<Summary>.from(json["summary"].map((x) => Summary.fromJson(x))),
        page: 0,
      );

  Map<String, dynamic> toJson() => {
        "distributeId": distributeId,
        "groupId": groupId,
        "groupName": groupName,
        "summary": List<dynamic>.from(summary.map((x) => x.toJson())),
      };
}

class Summary {
  final String areaId;
  final String areaName;
  final List<Product> products;

  Summary({
    required this.areaId,
    required this.areaName,
    required this.products,
  });

  Summary copyWith({
    String? areaId,
    String? areaName,
    List<Product>? products,
  }) =>
      Summary(
        areaId: areaId ?? this.areaId,
        areaName: areaName ?? this.areaName,
        products: products ?? this.products,
      );

  factory Summary.fromJson(Map<String, dynamic> json) => Summary(
        areaId: json["areaId"],
        areaName: json["areaName"],
        products: List<Product>.from(
            json["products"].map((x) => Product.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "areaId": areaId,
        "areaName": areaName,
        "products": List<dynamic>.from(products.map((x) => x.toJson())),
      };
}

class Product {
  final String productId;
  final String productName;
  final int sold;
  final int profit;

  Product({
    required this.productId,
    required this.productName,
    required this.sold,
    required this.profit,
  });

  Product copyWith({
    String? productId,
    String? productName,
    int? sold,
    int? profit,
  }) =>
      Product(
        productId: productId ?? this.productId,
        productName: productName ?? this.productName,
        sold: sold ?? this.sold,
        profit: profit ?? this.profit,
      );

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        productId: json["productId"],
        productName: json["productName"],
        sold: json["sold"],
        profit: json["profit"],
      );

  Map<String, dynamic> toJson() => {
        "productId": productId,
        "productName": productName,
        "sold": sold,
        "profit": profit,
      };
}
