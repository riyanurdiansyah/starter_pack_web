import 'dart:convert';

ProdukM produkMFromJson(String str) => ProdukM.fromJson(json.decode(str));

String produkMToJson(ProdukM data) => json.encode(data.toJson());

class ProdukM {
  final String nama;
  final String tipe;
  final String id;
  final int harga;
  final String image;
  final int qty;
  final int qtyDistributed;
  final List<String> groups;
  final double priceDistribute;
  final int page;
  final double minPrice;
  final double maxPrice;
  final double charge;
  final double discount;

  ProdukM({
    required this.nama,
    required this.tipe,
    required this.id,
    required this.harga,
    required this.image,
    required this.qty,
    required this.qtyDistributed,
    required this.groups,
    required this.priceDistribute,
    required this.page,
    required this.minPrice,
    required this.maxPrice,
    required this.charge,
    required this.discount,
  });

  ProdukM copyWith({
    String? nama,
    String? tipe,
    String? id,
    int? harga,
    String? image,
    int? qty,
    int? qtyDistributed,
    List<String>? groups,
    double? priceDistribute,
    int? page,
    double? minPrice,
    double? maxPrice,
    double? charge,
    double? discount,
  }) =>
      ProdukM(
        nama: nama ?? this.nama,
        tipe: tipe ?? this.tipe,
        id: id ?? this.id,
        harga: harga ?? this.harga,
        image: image ?? this.image,
        qty: qty ?? this.qty,
        qtyDistributed: qtyDistributed ?? this.qtyDistributed,
        groups: groups ?? this.groups,
        priceDistribute: priceDistribute ?? this.priceDistribute,
        page: page ?? this.page,
        minPrice: minPrice ?? this.minPrice,
        maxPrice: maxPrice ?? this.maxPrice,
        charge: charge ?? this.charge,
        discount: discount ?? this.discount,
      );

  factory ProdukM.fromJson(Map<String, dynamic> json) => ProdukM(
        nama: json["nama"],
        tipe: json["tipe"],
        id: json["id"],
        harga: json["harga"],
        image: json["image"],
        qty: json["qty"] ?? 0,
        qtyDistributed: 0,
        page: 0,
        charge: 0,
        discount: 0,
        priceDistribute: json["priceDistribute"] ?? 0,
        minPrice: json["minPrice"] ?? 0,
        maxPrice: json["maxPrice"] ?? 0,
        groups: json["groups"] == null
            ? []
            : List<String>.from(json["groups"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "nama": nama,
        "tipe": tipe,
        "id": id,
        "harga": harga,
        "image": image,
        "qty": qty,
        "minPrice": minPrice,
        "maxPrice": maxPrice,
        "priceDistribute": priceDistribute,
        "groups": List<String>.from(groups.map((x) => x)),
      };

  Map<String, dynamic> toJsonPRICE() => {
        "nama": nama,
        "tipe": tipe,
        "id": id,
        "harga": harga,
        // "image": image,
        // "qty": qty,
        "priceDistribute": priceDistribute,
        // "groups": List<String>.from(groups.map((x) => x)),
      };
}
