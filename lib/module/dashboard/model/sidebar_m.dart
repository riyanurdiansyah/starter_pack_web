import 'dart:convert';

SidebarM sidebarMFromJson(String str) => SidebarM.fromJson(json.decode(str));

String sidebarMToJson(SidebarM data) => json.encode(data.toJson());

class SidebarM {
  final String route;
  final String id;
  final List<int> role;
  final String title;
  final String created;
  final String updated;
  final List<SidebarM> submenus;
  final int no;
  final bool isMobile;
  final String start;

  SidebarM({
    required this.route,
    required this.id,
    required this.role,
    required this.title,
    required this.created,
    required this.updated,
    required this.submenus,
    required this.no,
    required this.isMobile,
    required this.start,
  });

  SidebarM copyWith({
    String? route,
    String? id,
    List<int>? role,
    String? title,
    String? created,
    String? updated,
    List<SidebarM>? submenus,
    int? no,
    bool? isMobile,
    String? start,
  }) =>
      SidebarM(
        route: route ?? this.route,
        id: id ?? this.id,
        role: role ?? this.role,
        title: title ?? this.title,
        created: created ?? this.created,
        updated: updated ?? this.updated,
        submenus: submenus ?? this.submenus,
        no: no ?? this.no,
        isMobile: isMobile ?? this.isMobile,
        start: start ?? this.start,
      );

  factory SidebarM.fromJson(Map<String, dynamic> json) => SidebarM(
        route: json["route"] ?? "",
        id: json["id"] ?? "",
        role: json["role"] == null
            ? []
            : List<int>.from(json["role"].map((x) => x)),
        title: json["title"] ?? "",
        created: json["created"] ?? "",
        updated: json["updated"] ?? "",
        isMobile: json["isMobile"] ?? false,
        submenus: json["submenus"] == null
            ? []
            : List<SidebarM>.from(
                json["submenus"].map(
                  (x) => SidebarM.fromJson(x),
                ),
              ),
        no: json["no"] ?? 99,
        start: json["start"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "route": route,
        "id": id,
        "role": List<dynamic>.from(role.map((x) => x)),
        "title": title,
        "created": created,
        "updated": updated,
        "isMobile": isMobile,
        "submenus": List<SidebarM>.from(submenus.map((e) => e.toJson())),
        "start": start,
      };
}
