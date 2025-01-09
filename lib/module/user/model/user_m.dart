// To parse this JSON data, do
//
//     final userM = userMFromJson(jsonString);

import 'dart:convert';

UserM userMFromJson(String str) => UserM.fromJson(json.decode(str));

String userMToJson(UserM data) => json.encode(data.toJson());

class UserM {
  final String id;
  final String nama;
  final String username;
  final String password;
  final int roleId;
  final String role;
  final String kelompok;
  final int kelompokId;
  final int page;
  final String groupId;
  final double point;

  UserM({
    required this.id,
    required this.nama,
    required this.username,
    required this.password,
    required this.roleId,
    required this.role,
    required this.kelompok,
    required this.kelompokId,
    required this.page,
    required this.groupId,
    required this.point,
  });

  UserM copyWith({
    String? id,
    String? nama,
    String? username,
    String? password,
    int? roleId,
    String? role,
    String? kelompok,
    int? kelompokId,
    int? page,
    String? groupId,
    double? point,
  }) =>
      UserM(
        id: id ?? this.id,
        nama: nama ?? this.nama,
        username: username ?? this.username,
        password: password ?? this.password,
        roleId: roleId ?? this.roleId,
        role: role ?? this.role,
        kelompok: kelompok ?? this.kelompok,
        kelompokId: kelompokId ?? this.kelompokId,
        page: page ?? this.page,
        groupId: groupId ?? this.groupId,
        point: point ?? this.point,
      );

  factory UserM.fromJson(Map<String, dynamic> json) => UserM(
        id: json["id"],
        nama: json["nama"],
        username: json["username"],
        password: json["password"],
        roleId: json["role_id"],
        role: json["role"],
        kelompok: json["kelompok"],
        kelompokId: json["kelompok_id"] ?? 0,
        page: json["page"] ?? 0,
        groupId: json["group_id"] ?? "",
        point: json["point"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nama": nama,
        "username": username,
        "password": password,
        "role_id": roleId,
        "role": role,
        "kelompok": kelompok,
        "kelompok_id": kelompokId,
        "group_id": groupId,
      };
}
