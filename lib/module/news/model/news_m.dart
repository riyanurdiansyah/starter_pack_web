// To parse this JSON data, do
//
//     final newsM = newsMFromJson(jsonString);

import 'dart:convert';

NewsM newsMFromJson(String str) => NewsM.fromJson(json.decode(str));

String newsMToJson(NewsM data) => json.encode(data.toJson());

class NewsM {
  final String id;
  final String content;
  final String title;
  final String image;
  final String date;
  final int page;
  final List<String> users;
  final bool isForAll;

  NewsM({
    required this.id,
    required this.content,
    required this.title,
    required this.image,
    required this.date,
    required this.page,
    required this.users,
    required this.isForAll,
  });

  NewsM copyWith({
    String? id,
    String? content,
    String? title,
    String? image,
    String? date,
    int? page,
    List<String>? users,
    bool? isForAll,
  }) =>
      NewsM(
        id: id ?? this.id,
        content: content ?? this.content,
        title: title ?? this.title,
        image: image ?? this.image,
        date: date ?? this.date,
        page: page ?? this.page,
        users: users ?? this.users,
        isForAll: isForAll ?? this.isForAll,
      );

  factory NewsM.fromJson(Map<String, dynamic> json) => NewsM(
        id: json["id"],
        content: json["content"],
        title: json["title"],
        image: json["image"],
        date: json["date"],
        isForAll: json["isForAll"] ?? false,
        page: 0,
        users: json["users"] == null
            ? []
            : List<String>.from(json["users"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "content": content,
        "title": title,
        "image": image,
        "date": date,
        "isForAll": isForAll,
        "users": List<String>.from(users.map((x) => x)),
      };
}
