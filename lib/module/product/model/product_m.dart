// To parse this JSON data, do
//
//     final productM = productMFromJson(jsonString);

import 'dart:convert';

ProductM productMFromJson(String str) => ProductM.fromJson(json.decode(str));

String productMToJson(ProductM data) => json.encode(data.toJson());

class ProductM {
  final String id;
  final String nama;
  final String image;
  final String imageBg;
  final int price;

  ProductM({
    required this.id,
    required this.nama,
    required this.image,
    required this.imageBg,
    required this.price,
  });

  ProductM copyWith({
    String? id,
    String? nama,
    String? image,
    String? imageBg,
    int? price,
  }) =>
      ProductM(
        id: id ?? this.id,
        nama: nama ?? this.nama,
        image: image ?? this.image,
        imageBg: imageBg ?? this.imageBg,
        price: price ?? this.price,
      );

  factory ProductM.fromJson(Map<String, dynamic> json) => ProductM(
        id: json["id"],
        nama: json["nama"],
        image: json["image"],
        imageBg: json["image_bg"],
        price: json["price"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nama": nama,
        "image": image,
        "image_bg": imageBg,
        "price": price,
      };
}
