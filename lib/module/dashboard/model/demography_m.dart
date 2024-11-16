import 'dart:convert';

DemographyM demographyMFromJson(String str) =>
    DemographyM.fromJson(json.decode(str));

String demographyMToJson(DemographyM data) => json.encode(data.toJson());

class DemographyM {
  final String id;
  final String data;
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
        data: json["data"],
        right: json["right"]?.toDouble(),
        left: json["left"]?.toDouble(),
        top: json["top"]?.toDouble(),
        bottom: json["bottom"]?.toDouble(),
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
      };
}
