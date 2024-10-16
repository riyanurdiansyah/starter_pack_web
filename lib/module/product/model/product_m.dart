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
  final List<InformasiProductM> informasi;

  ProductM({
    required this.id,
    required this.nama,
    required this.image,
    required this.imageBg,
    required this.price,
    required this.informasi,
  });

  ProductM copyWith({
    String? id,
    String? nama,
    String? image,
    String? imageBg,
    int? price,
    List<InformasiProductM>? informasi,
  }) =>
      ProductM(
        id: id ?? this.id,
        nama: nama ?? this.nama,
        image: image ?? this.image,
        imageBg: imageBg ?? this.imageBg,
        price: price ?? this.price,
        informasi: informasi ?? this.informasi,
      );

  factory ProductM.fromJson(Map<String, dynamic> json) => ProductM(
        id: json["id"],
        nama: json["nama"],
        image: json["image"],
        imageBg: json["image_bg"],
        price: json["price"],
        informasi: List<InformasiProductM>.from(
            json["informasi"].map((x) => InformasiProductM.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nama": nama,
        "image": image,
        "image_bg": imageBg,
        "price": price,
        "informasi": List<dynamic>.from(informasi.map((x) => x.toJson())),
      };
}

class InformasiProductM {
  final String gizi;
  final int price;

  InformasiProductM({
    required this.gizi,
    required this.price,
  });

  InformasiProductM copyWith({
    String? gizi,
    int? price,
  }) =>
      InformasiProductM(
        gizi: gizi ?? this.gizi,
        price: price ?? this.price,
      );

  factory InformasiProductM.fromJson(Map<String, dynamic> json) =>
      InformasiProductM(
        gizi: json["gizi"],
        price: json["price"],
      );

  Map<String, dynamic> toJson() => {
        "gizi": gizi,
        "price": price,
      };
}
