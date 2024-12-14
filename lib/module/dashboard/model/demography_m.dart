import 'dart:convert';

DemographyM demographyMFromJson(String str) =>
    DemographyM.fromJson(json.decode(str));

String demographyMToJson(DemographyM data) => json.encode(data.toJson());

class DemographyM {
  final String id;
  final String data;
  final String infant;
  final String seniors;
  final String pregnant;
  final String infantElevated;
  final String seniorsElevated;
  final String pregnantElevated;
  final double right;
  final double left;
  final double top;
  final double bottom;
  final String name;
  final int page;
  final bool isHovered;

  DemographyM({
    required this.id,
    required this.data,
    required this.infant,
    required this.seniors,
    required this.pregnant,
    required this.infantElevated,
    required this.seniorsElevated,
    required this.pregnantElevated,
    required this.right,
    required this.left,
    required this.top,
    required this.bottom,
    required this.name,
    required this.page,
    required this.isHovered,
  });

  DemographyM copyWith({
    String? id,
    String? data,
    String? infant,
    String? seniors,
    String? pregnant,
    String? infantElevated,
    String? seniorsElevated,
    String? pregnantElevated,
    double? right,
    double? left,
    double? top,
    double? bottom,
    String? name,
    int? page,
    bool? isHovered,
  }) =>
      DemographyM(
        id: id ?? this.id,
        data: data ?? this.data,
        infant: infant ?? this.infant,
        seniors: seniors ?? this.seniors,
        pregnant: pregnant ?? this.pregnant,
        infantElevated: infantElevated ?? this.infantElevated,
        seniorsElevated: seniorsElevated ?? this.seniorsElevated,
        pregnantElevated: pregnantElevated ?? this.pregnantElevated,
        right: right ?? this.right,
        left: left ?? this.left,
        top: top ?? this.top,
        bottom: bottom ?? this.bottom,
        name: name ?? this.name,
        page: page ?? this.page,
        isHovered: isHovered ?? this.isHovered,
      );

  factory DemographyM.fromJson(Map<String, dynamic> json) => DemographyM(
        id: json["id"],
        data: json["data"] ?? "",
        infant: json["infant_core_lifestyle"] ?? "",
        seniors: json["seniors_core_lifestyle"] ?? "",
        pregnant: json["pregnant_core_lifestyle"] ?? "",
        infantElevated: json["infant_elevated_class"] ?? "",
        seniorsElevated: json["seniors_elevated_class"] ?? "",
        pregnantElevated: json["pregnant_elevated_class"] ?? "",
        right: json["right"]?.toDouble() ?? 0,
        left: json["left"]?.toDouble() ?? 0,
        top: json["top"]?.toDouble() ?? 0,
        bottom: json["bottom"]?.toDouble() ?? 0,
        name: json["name"],
        page: 0,
        isHovered: false,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "data": data,
        "right": right,
        "left": left,
        "top": top,
        "bottom": bottom,
        "name": name,
        "infant_core_lifestyle": infant,
        "pregnant_core_lifestyle": pregnant,
        "seniors_core_lifestyle": seniors,
        "infant_elevated_class": infantElevated,
        "pregnant_elevated_class": pregnantElevated,
        "seniors_elevated_class": seniorsElevated,
      };
}
