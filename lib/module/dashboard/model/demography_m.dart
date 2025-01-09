import 'dart:convert';

DemographyM demographyMFromJson(String str) =>
    DemographyM.fromJson(json.decode(str));

String demographyMToJson(DemographyM data) => json.encode(data.toJson());

class DemographyM {
  final String id;
  final String data;
  final String specialCase;
  final String infant;
  final String seniors;
  final String pregnant;
  final String infantElevated;
  final String seniorsElevated;
  final String pregnantElevated;
  final String image;
  final double right;
  final double left;
  final double top;
  final double bottom;
  final String name;
  final int page;
  final bool isHovered;
  final double cost;
  final List<DetailProductDemography> details;

  DemographyM({
    required this.id,
    required this.data,
    required this.specialCase,
    required this.infant,
    required this.seniors,
    required this.pregnant,
    required this.infantElevated,
    required this.seniorsElevated,
    required this.pregnantElevated,
    required this.image,
    required this.right,
    required this.left,
    required this.top,
    required this.bottom,
    required this.name,
    required this.page,
    required this.isHovered,
    required this.cost,
    required this.details,
  });

  DemographyM copyWith({
    String? id,
    String? data,
    String? specialCase,
    String? infant,
    String? seniors,
    String? pregnant,
    String? infantElevated,
    String? seniorsElevated,
    String? pregnantElevated,
    String? image,
    double? right,
    double? left,
    double? top,
    double? bottom,
    String? name,
    int? page,
    bool? isHovered,
    double? cost,
    List<DetailProductDemography>? details,
  }) =>
      DemographyM(
        id: id ?? this.id,
        data: data ?? this.data,
        specialCase: specialCase ?? this.specialCase,
        infant: infant ?? this.infant,
        seniors: seniors ?? this.seniors,
        pregnant: pregnant ?? this.pregnant,
        infantElevated: infantElevated ?? this.infantElevated,
        seniorsElevated: seniorsElevated ?? this.seniorsElevated,
        pregnantElevated: pregnantElevated ?? this.pregnantElevated,
        image: image ?? this.image,
        right: right ?? this.right,
        left: left ?? this.left,
        top: top ?? this.top,
        bottom: bottom ?? this.bottom,
        name: name ?? this.name,
        page: page ?? this.page,
        isHovered: isHovered ?? this.isHovered,
        cost: cost ?? this.cost,
        details: details ?? this.details,
      );

  factory DemographyM.fromJson(Map<String, dynamic> json) => DemographyM(
        id: json["id"],
        data: json["data"] ?? "",
        specialCase: json["specialCase"] ?? "",
        infant: json["infant_core_lifestyle"] ?? "",
        seniors: json["seniors_core_lifestyle"] ?? "",
        pregnant: json["pregnant_core_lifestyle"] ?? "",
        infantElevated: json["infant_elevated_class"] ?? "",
        seniorsElevated: json["seniors_elevated_class"] ?? "",
        pregnantElevated: json["pregnant_elevated_class"] ?? "",
        image: json["image"] ?? "",
        right: json["right"]?.toDouble() ?? 0,
        left: json["left"]?.toDouble() ?? 0,
        top: json["top"]?.toDouble() ?? 0,
        bottom: json["bottom"]?.toDouble() ?? 0,
        name: json["name"],
        page: 0,
        isHovered: false,
        cost: json["cost"]?.toDouble() ?? 0,
        details: json["details"] == null
            ? []
            : List<DetailProductDemography>.from(json["details"]
                .map((x) => DetailProductDemography.fromJson(x))),
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
        "infant_core_lifestyle": infant,
        "pregnant_core_lifestyle": pregnant,
        "seniors_core_lifestyle": seniors,
        "infant_elevated_class": infantElevated,
        "pregnant_elevated_class": pregnantElevated,
        "seniors_elevated_class": seniorsElevated,
        "cost": cost,
        "details": List<dynamic>.from(details.map((x) => x.toJson())),
      };

  Map<String, dynamic> toJsonPRICE() => {
        "id": id,
        // "details": List<dynamic>.from(details.map((x) => x.toJson())),
      };
}

class DetailProductDemography {
  final String productId;
  final double minPrice;
  final double maxPrice;

  DetailProductDemography({
    required this.productId,
    required this.minPrice,
    required this.maxPrice,
  });

  factory DetailProductDemography.fromJson(Map<String, dynamic> json) =>
      DetailProductDemography(
        productId: json["productId"] ?? "",
        minPrice: json["minPrice"]?.toDouble() ?? 0,
        maxPrice: json["maxPrice"]?.toDouble() ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "productId": productId,
        "minPrice": minPrice,
        "maxPrice": maxPrice,
      };
}
