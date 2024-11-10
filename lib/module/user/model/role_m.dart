// To parse this JSON data, do
//
//     final roleM = roleMFromJson(jsonString);

import 'dart:convert';

RoleM roleMFromJson(String str) => RoleM.fromJson(json.decode(str));

String roleMToJson(RoleM data) => json.encode(data.toJson());

class RoleM {
  final String id;
  final String role;
  final int roleId;
  final int page;

  RoleM({
    required this.id,
    required this.role,
    required this.roleId,
    required this.page,
  });

  RoleM copyWith({
    String? id,
    String? role,
    int? roleId,
    int? page,
  }) =>
      RoleM(
        id: id ?? this.id,
        role: role ?? this.role,
        roleId: roleId ?? this.roleId,
        page: page ?? this.page,
      );

  factory RoleM.fromJson(Map<String, dynamic> json) => RoleM(
        id: json["id"],
        role: json["role"],
        roleId: json["role_id"],
        page: 0,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "role": role,
        "role_id": roleId,
      };
}
