// To parse this JSON data, do
//
//     final groupM = groupMFromJson(jsonString);

import 'dart:convert';

GroupM groupMFromJson(String str) => GroupM.fromJson(json.decode(str));

String groupMToJson(GroupM data) => json.encode(data.toJson());

class GroupM {
  final String id;
  final String nama;
  final int groupId;

  GroupM({
    required this.id,
    required this.nama,
    required this.groupId,
  });

  GroupM copyWith({
    String? id,
    String? nama,
    int? groupId,
  }) =>
      GroupM(
        id: id ?? this.id,
        nama: nama ?? this.nama,
        groupId: groupId ?? this.groupId,
      );

  factory GroupM.fromJson(Map<String, dynamic> json) => GroupM(
        id: json["id"],
        nama: json["nama"],
        groupId: json["group_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nama": nama,
        "group_id": groupId,
      };
}
