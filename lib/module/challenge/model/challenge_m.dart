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
  final String end;
  final int no;
  final String id;
  final String image;
  final String name;
  final int page;
  final String type;
  final int time;
  final int maxQuestion;
  final int maxPoint;
  final bool isRevenue;

  ChallengeM({
    required this.route,
    required this.start,
    required this.end,
    required this.no,
    required this.id,
    required this.image,
    required this.name,
    required this.page,
    required this.type,
    required this.time,
    required this.maxQuestion,
    required this.maxPoint,
    required this.isRevenue,
  });

  ChallengeM copyWith({
    String? route,
    String? start,
    String? end,
    int? no,
    String? id,
    String? image,
    String? name,
    int? page,
    String? type,
    int? time,
    int? maxQuestion,
    int? maxPoint,
    bool? isRevenue,
  }) =>
      ChallengeM(
        route: route ?? this.route,
        start: start ?? this.start,
        end: end ?? this.end,
        no: no ?? this.no,
        id: id ?? this.id,
        image: image ?? this.image,
        name: name ?? this.name,
        page: page ?? this.page,
        type: type ?? this.type,
        time: time ?? this.time,
        maxQuestion: maxQuestion ?? this.maxQuestion,
        maxPoint: maxPoint ?? this.maxPoint,
        isRevenue: isRevenue ?? this.isRevenue,
      );

  factory ChallengeM.fromJson(Map<String, dynamic> json) => ChallengeM(
        route: json["route"],
        start: json["start"],
        end: json["end"] ?? "",
        no: json["no"],
        id: json["id"],
        image: json["image"],
        name: json["name"],
        type: json["type"] ?? "",
        page: 0,
        time: json["time"] ?? 0,
        maxQuestion: json["maxQuestion"] ?? 0,
        maxPoint: json["maxPoint"] ?? 0,
        isRevenue: json["isRevenue"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "route": route,
        "start": start,
        "end": end,
        "no": no,
        "id": id,
        "image": image,
        "name": name,
        "type": type,
        "time": time,
        "maxQuestion": maxQuestion,
        "maxPoint": maxPoint,
        "isRevenue": isRevenue,
      };
}
