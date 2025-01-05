// To parse this JSON data, do
//
//     final sellingPriceM = sellingPriceMFromJson(jsonString);

import 'dart:convert';

SellingPriceM sellingPriceMFromJson(String str) =>
    SellingPriceM.fromJson(json.decode(str));

String sellingPriceMToJson(SellingPriceM data) => json.encode(data.toJson());

class SellingPriceM {
  final String priceId;
  final String groupId;
  final List<Area> areas;

  SellingPriceM({
    required this.priceId,
    required this.groupId,
    required this.areas,
  });

  SellingPriceM copyWith({
    String? priceId,
    String? groupId,
    List<Area>? areas,
  }) =>
      SellingPriceM(
        priceId: priceId ?? this.priceId,
        groupId: groupId ?? this.groupId,
        areas: areas ?? this.areas,
      );

  factory SellingPriceM.fromJson(Map<String, dynamic> json) => SellingPriceM(
        priceId: json["priceId"],
        groupId: json["groupId"],
        areas: List<Area>.from(json["areas"].map((x) => Area.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "priceId": priceId,
        "groupId": groupId,
        "areas": List<dynamic>.from(areas.map((x) => x.toJson())),
      };
}

class Area {
  final String id;
  final String data;
  final String specialCase;
  final double right;
  final double left;
  final int top;
  final int bottom;
  final String name;
  final String image;
  final String infantCoreLifestyle;
  final String pregnantCoreLifestyle;
  final String seniorsCoreLifestyle;
  final String infantElevatedClass;
  final String pregnantElevatedClass;
  final String seniorsElevatedClass;
  final double cost;
  final List<Detail> details;
  final List<Product> products;

  Area({
    required this.id,
    required this.data,
    required this.specialCase,
    required this.right,
    required this.left,
    required this.top,
    required this.bottom,
    required this.name,
    required this.image,
    required this.infantCoreLifestyle,
    required this.pregnantCoreLifestyle,
    required this.seniorsCoreLifestyle,
    required this.infantElevatedClass,
    required this.pregnantElevatedClass,
    required this.seniorsElevatedClass,
    required this.cost,
    required this.details,
    required this.products,
  });

  Area copyWith({
    String? id,
    String? data,
    String? specialCase,
    double? right,
    double? left,
    int? top,
    int? bottom,
    String? name,
    String? image,
    String? infantCoreLifestyle,
    String? pregnantCoreLifestyle,
    String? seniorsCoreLifestyle,
    String? infantElevatedClass,
    String? pregnantElevatedClass,
    String? seniorsElevatedClass,
    double? cost,
    List<Detail>? details,
    List<Product>? products,
  }) =>
      Area(
        id: id ?? this.id,
        data: data ?? this.data,
        specialCase: specialCase ?? this.specialCase,
        right: right ?? this.right,
        left: left ?? this.left,
        top: top ?? this.top,
        bottom: bottom ?? this.bottom,
        name: name ?? this.name,
        image: image ?? this.image,
        infantCoreLifestyle: infantCoreLifestyle ?? this.infantCoreLifestyle,
        pregnantCoreLifestyle:
            pregnantCoreLifestyle ?? this.pregnantCoreLifestyle,
        seniorsCoreLifestyle: seniorsCoreLifestyle ?? this.seniorsCoreLifestyle,
        infantElevatedClass: infantElevatedClass ?? this.infantElevatedClass,
        pregnantElevatedClass:
            pregnantElevatedClass ?? this.pregnantElevatedClass,
        seniorsElevatedClass: seniorsElevatedClass ?? this.seniorsElevatedClass,
        cost: cost ?? this.cost,
        details: details ?? this.details,
        products: products ?? this.products,
      );

  factory Area.fromJson(Map<String, dynamic> json) => Area(
        id: json["id"],
        data: json["data"],
        specialCase: json["specialCase"],
        right: json["right"]?.toDouble(),
        left: json["left"]?.toDouble(),
        top: json["top"],
        bottom: json["bottom"],
        name: json["name"],
        image: json["image"],
        infantCoreLifestyle: json["infant_core_lifestyle"],
        pregnantCoreLifestyle: json["pregnant_core_lifestyle"],
        seniorsCoreLifestyle: json["seniors_core_lifestyle"],
        infantElevatedClass: json["infant_elevated_class"],
        pregnantElevatedClass: json["pregnant_elevated_class"],
        seniorsElevatedClass: json["seniors_elevated_class"],
        cost: json["cost"]?.toDouble(),
        details: [],
        products: List<Product>.from(
            json["products"].map((x) => Product.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "data": data,
        "specialCase": specialCase,
        "right": right,
        "left": left,
        "top": top,
        "bottom": bottom,
        "name": name,
        "image": image,
        "infant_core_lifestyle": infantCoreLifestyle,
        "pregnant_core_lifestyle": pregnantCoreLifestyle,
        "seniors_core_lifestyle": seniorsCoreLifestyle,
        "infant_elevated_class": infantElevatedClass,
        "pregnant_elevated_class": pregnantElevatedClass,
        "seniors_elevated_class": seniorsElevatedClass,
        "cost": cost,
        "details": List<dynamic>.from(details.map((x) => x.toJson())),
        "products": List<dynamic>.from(products.map((x) => x.toJson())),
      };
}

class Detail {
  final String productId;
  final int minPrice;
  final int maxPrice;

  Detail({
    required this.productId,
    required this.minPrice,
    required this.maxPrice,
  });

  Detail copyWith({
    String? productId,
    int? minPrice,
    int? maxPrice,
  }) =>
      Detail(
        productId: productId ?? this.productId,
        minPrice: minPrice ?? this.minPrice,
        maxPrice: maxPrice ?? this.maxPrice,
      );

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
        productId: json["productId"],
        minPrice: json["minPrice"],
        maxPrice: json["maxPrice"],
      );

  Map<String, dynamic> toJson() => {
        "productId": productId,
        "minPrice": minPrice,
        "maxPrice": maxPrice,
      };
}

class Product {
  final String nama;
  final String tipe;
  final String id;
  final int harga;
  final String image;
  final int qty;
  final int priceDistribute;
  final List<String> groups;

  Product({
    required this.nama,
    required this.tipe,
    required this.id,
    required this.harga,
    required this.image,
    required this.qty,
    required this.priceDistribute,
    required this.groups,
  });

  Product copyWith({
    String? nama,
    String? tipe,
    String? id,
    int? harga,
    String? image,
    int? qty,
    int? priceDistribute,
    List<String>? groups,
  }) =>
      Product(
        nama: nama ?? this.nama,
        tipe: tipe ?? this.tipe,
        id: id ?? this.id,
        harga: harga ?? this.harga,
        image: image ?? this.image,
        qty: qty ?? this.qty,
        priceDistribute: priceDistribute ?? this.priceDistribute,
        groups: groups ?? this.groups,
      );

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        nama: json["nama"],
        tipe: json["tipe"],
        id: json["id"],
        harga: json["harga"],
        image: json["image"],
        qty: json["qty"],
        priceDistribute: json["priceDistribute"],
        groups: List<String>.from(json["groups"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "nama": nama,
        "tipe": tipe,
        "id": id,
        "harga": harga,
        "image": image,
        "qty": qty,
        "priceDistribute": priceDistribute,
        "groups": List<dynamic>.from(groups.map((x) => x)),
      };
}
