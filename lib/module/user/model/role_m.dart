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

  RoleM({
    required this.id,
    required this.role,
    required this.roleId,
  });

  RoleM copyWith({
    String? id,
    String? role,
    int? roleId,
  }) =>
      RoleM(
        id: id ?? this.id,
        role: role ?? this.role,
        roleId: roleId ?? this.roleId,
      );

  factory RoleM.fromJson(Map<String, dynamic> json) => RoleM(
        id: json["id"],
        role: json["role"],
        roleId: json["role_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "role": role,
        "role_id": roleId,
      };
}
