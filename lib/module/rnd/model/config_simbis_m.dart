// To parse this JSON data, do
//
//     final configSimbs = configSimbsFromJson(jsonString);

import 'dart:convert';

List<ConfigSimbs> configSimbsFromJson(String str) => List<ConfigSimbs>.from(
    json.decode(str).map((x) => ConfigSimbs.fromJson(x)));

String configSimbsToJson(List<ConfigSimbs> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ConfigSimbs {
  final String end;
  final String start;
  final String id;
  final String name;

  ConfigSimbs({
    required this.end,
    required this.start,
    required this.id,
    required this.name,
  });

  ConfigSimbs copyWith({
    String? end,
    String? start,
    String? id,
    String? name,
  }) =>
      ConfigSimbs(
        end: end ?? this.end,
        start: start ?? this.start,
        id: id ?? this.id,
        name: name ?? this.name,
      );

  factory ConfigSimbs.fromJson(Map<String, dynamic> json) => ConfigSimbs(
        end: json["end"],
        start: json["start"],
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "end": end,
        "start": start,
        "id": id,
        "name": name,
      };
}
