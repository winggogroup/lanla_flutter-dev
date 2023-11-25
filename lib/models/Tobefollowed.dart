// To parse this JSON data, do
//
//     final tobefollowed = tobefollowedFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<Tobefollowed> tobefollowedFromJson(String str) => List<Tobefollowed>.from(json.decode(str).map((x) => Tobefollowed.fromJson(x)));

String tobefollowedToJson(List<Tobefollowed> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Tobefollowed {
  int id;
  String headimg;
  String nickname;
  int bgz;

  Tobefollowed({
    required this.id,
    required this.headimg,
    required this.nickname,
    required this.bgz,
  });

  factory Tobefollowed.fromJson(Map<String, dynamic> json) => Tobefollowed(
    id: json["id"],
    headimg: json["headimg"],
    nickname: json["nickname"],
    bgz: json["bgz"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "headimg": headimg,
    "nickname": nickname,
    "bgz": bgz,
  };
}
