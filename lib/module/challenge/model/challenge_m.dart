// To parse this JSON data, do
//
//     final challengeM = challengeMFromJson(jsonString);

import 'dart:convert';

List<ChallengeM> challengeMFromJson(String str) =>
    List<ChallengeM>.from(json.decode(str).map((x) => ChallengeM.fromJson(x)));

String challengeMToJson(List<ChallengeM> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ChallengeM {
  final String route;
  final String start;
  final int no;
  final String id;
  final String image;
  final String name;
  final int page;

  ChallengeM({
    required this.route,
    required this.start,
    required this.no,
    required this.id,
    required this.image,
    required this.name,
    required this.page,
  });

  ChallengeM copyWith({
    String? route,
    String? start,
    int? no,
    String? id,
    String? image,
    String? name,
    int? page,
  }) =>
      ChallengeM(
        route: route ?? this.route,
        start: start ?? this.start,
        no: no ?? this.no,
        id: id ?? this.id,
        image: image ?? this.image,
        name: name ?? this.name,
        page: page ?? this.page,
      );

  factory ChallengeM.fromJson(Map<String, dynamic> json) => ChallengeM(
        route: json["route"],
        start: json["start"],
        no: json["no"],
        id: json["id"],
        image: json["image"],
        name: json["name"],
        page: 0,
      );

  Map<String, dynamic> toJson() => {
        "route": route,
        "start": start,
        "no": no,
        "id": id,
        "image": image,
        "name": name,
      };
}
