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

  ProdukM({
    required this.nama,
    required this.tipe,
    required this.id,
    required this.harga,
    required this.image,
    required this.qty,
  });

  ProdukM copyWith({
    String? nama,
    String? tipe,
    String? id,
    int? harga,
    String? image,
    int? qty,
  }) =>
      ProdukM(
        nama: nama ?? this.nama,
        tipe: tipe ?? this.tipe,
        id: id ?? this.id,
        harga: harga ?? this.harga,
        image: image ?? this.image,
        qty: qty ?? this.qty,
      );

  factory ProdukM.fromJson(Map<String, dynamic> json) => ProdukM(
        nama: json["nama"],
        tipe: json["tipe"],
        id: json["id"],
        harga: json["harga"],
        image: json["image"],
        qty: 0,
      );

  Map<String, dynamic> toJson() => {
        "nama": nama,
        "tipe": tipe,
        "id": id,
        "harga": harga,
        "image": image,
        "qty": qty,
      };
}
