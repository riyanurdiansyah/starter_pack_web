// To parse this JSON data, do
//
//     final groupM = groupMFromJson(jsonString);

import 'dart:convert';

List<GroupM> groupMFromJson(String str) =>
    List<GroupM>.from(json.decode(str).map((x) => GroupM.fromJson(x)));

String groupMToJson(List<GroupM> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GroupM {
  final String alias;
  final String country;
  final int groupId;
  final String id;
  final String image;
  final String name;
  final double point;
  final double pointBefore;
  final String updatedDate;
  final int? rank;
  final int? rankOld;
  final int page;
  final int profit;

  GroupM({
    required this.alias,
    required this.country,
    required this.groupId,
    required this.id,
    required this.image,
    required this.name,
    required this.point,
    required this.pointBefore,
    required this.updatedDate,
    this.rank,
    this.rankOld,
    required this.page,
    required this.profit,
  });

  GroupM copyWith({
    String? alias,
    String? country,
    int? groupId,
    String? id,
    String? image,
    String? name,
    double? point,
    double? pointBefore,
    String? updatedDate,
    int? rank,
    int? rankOld,
    int? page,
    int? profit,
  }) =>
      GroupM(
        alias: alias ?? this.alias,
        country: country ?? this.country,
        groupId: groupId ?? this.groupId,
        id: id ?? this.id,
        image: image ?? this.image,
        name: name ?? this.name,
        point: point ?? this.point,
        pointBefore: pointBefore ?? this.pointBefore,
        updatedDate: updatedDate ?? this.updatedDate,
        rank: rank ?? this.rank,
        rankOld: rankOld ?? this.rankOld,
        page: page ?? this.page,
        profit: profit ?? this.profit,
      );

  factory GroupM.fromJson(Map<String, dynamic> json) => GroupM(
        alias: json["alias"],
        country: json["country"],
        groupId: json["group_id"],
        id: json["id"],
        image: json["image"],
        name: json["name"],
        point: json["point"],
        pointBefore: json["point_before"],
        updatedDate: json["updated_date"],
        rank: 0,
        rankOld: 0,
        page: 0,
        profit: 0,
      );

  Map<String, dynamic> toJson() => {
        "alias": alias,
        "country": country,
        "group_id": groupId,
        "id": id,
        "image": image,
        "name": name,
        "point": point,
        "point_before": pointBefore,
        "updated_date": updatedDate,
      };
}
