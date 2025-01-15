// To parse this JSON data, do
//
//     final distributeM = distributeMFromJson(jsonString);

import 'dart:convert';

List<DistributeM> distributeMFromJson(String str) => List<DistributeM>.from(
    json.decode(str).map((x) => DistributeM.fromJson(x)));

String distributeMToJson(List<DistributeM> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DistributeM {
  final String distributeId;
  final String cycleId;
  final String groupId;
  final String groupName;
  final List<AreaM> areas;
  final int page;

  DistributeM({
    required this.distributeId,
    required this.cycleId,
    required this.groupId,
    required this.groupName,
    required this.areas,
    required this.page,
  });

  DistributeM copyWith({
    String? distributeId,
    String? cycleId,
    String? groupId,
    String? groupName,
    List<AreaM>? areas,
    int? page,
  }) =>
      DistributeM(
        distributeId: distributeId ?? this.distributeId,
        cycleId: cycleId ?? this.cycleId,
        groupId: groupId ?? this.groupId,
        groupName: groupName ?? this.groupName,
        areas: areas ?? this.areas,
        page: page ?? this.page,
      );

  factory DistributeM.fromJson(Map<String, dynamic> json) => DistributeM(
        distributeId: json["distributeId"],
        cycleId: json["cycleId"] ?? "",
        groupId: json["groupId"],
        groupName: json["groupName"] ?? "",
        areas: List<AreaM>.from(json["areas"].map((x) => AreaM.fromJson(x))),
        page: json["page"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "distributeId": distributeId,
        "cycleId": cycleId,
        "groupId": groupId,
        "groupName": groupName,
        "page": page,
        "areas": List<dynamic>.from(areas.map((x) => x.toJson())),
      };
}

class AreaM {
  final String areaId;
  final String areaName;
  final List<ProductDistributeM> products;

  AreaM({
    required this.areaId,
    required this.areaName,
    required this.products,
  });

  AreaM copyWith({
    String? areaId,
    String? areaName,
    List<ProductDistributeM>? products,
  }) =>
      AreaM(
        areaId: areaId ?? this.areaId,
        areaName: areaName ?? this.areaName,
        products: products ?? this.products,
      );

  factory AreaM.fromJson(Map<String, dynamic> json) => AreaM(
        areaId: json["areaId"],
        areaName: json["areaName"],
        products: List<ProductDistributeM>.from(
            json["products"].map((x) => ProductDistributeM.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "areaId": areaId,
        "areaName": areaName,
        "products": List<dynamic>.from(products.map((x) => x.toJson())),
      };
}

class ProductDistributeM {
  final String productId;
  final String productName;
  final double pricePerProduct;
  final int qty;
  final int sold;
  final double profit;

  ProductDistributeM({
    required this.productId,
    required this.productName,
    required this.pricePerProduct,
    required this.qty,
    required this.sold,
    required this.profit,
  });

  ProductDistributeM copyWith({
    String? productId,
    String? productName,
    double? pricePerProduct,
    int? qty,
    int? sold,
    double? profit,
  }) =>
      ProductDistributeM(
        productId: productId ?? this.productId,
        productName: productName ?? this.productName,
        pricePerProduct: pricePerProduct ?? this.pricePerProduct,
        qty: qty ?? this.qty,
        sold: sold ?? this.sold,
        profit: profit ?? this.profit,
      );

  factory ProductDistributeM.fromJson(Map<String, dynamic> json) =>
      ProductDistributeM(
        productId: json["productId"],
        productName: json["productName"],
        pricePerProduct: json["pricePerProduct"],
        qty: json["qty"],
        sold: json["sold"] ?? 0,
        profit: json["profit"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "productId": productId,
        "productName": productName,
        "pricePerProduct": pricePerProduct,
        "qty": qty,
        "sold": sold,
        "profit": profit,
      };
}
