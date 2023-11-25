// To parse this JSON data, do
//
//     final userGiftDetail = userGiftDetailFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<UserGiftDetail> userGiftDetailFromJson(String str) => List<UserGiftDetail>.from(json.decode(str).map((x) => UserGiftDetail.fromJson(x)));

String userGiftDetailToJson(List<UserGiftDetail> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserGiftDetail {
  String giftCount;
  String imagePath;
  String createdAt;
  String nickname;
  String headimg;


  UserGiftDetail({
    required this.giftCount,
    required this.imagePath,
    required this.createdAt,
    required this.nickname,
    required this.headimg,
  });

  factory UserGiftDetail.fromJson(Map<String, dynamic> json) => UserGiftDetail(
    giftCount: json["giftCount"],
    imagePath: json["imagePath"],
    createdAt: json["createdAt"],
    nickname: json["nickname"],
    headimg: json["headimg"],
  );

  Map<String, dynamic> toJson() => {
    "giftCount": giftCount,
    "imagePath": imagePath,
    "createdAt": createdAt,
    "nickname": nickname,
    "headimg": headimg,
  };
}
