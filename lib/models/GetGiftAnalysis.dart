// To parse this JSON data, do
//
//     final getGiftAnalysis = getGiftAnalysisFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<GetGiftAnalysis> getGiftAnalysisFromJson(String str) => List<GetGiftAnalysis>.from(json.decode(str).map((x) => GetGiftAnalysis.fromJson(x)));

String getGiftAnalysisToJson(List<GetGiftAnalysis> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetGiftAnalysis {
  int giftCount;
  int userId;
  String nickname;
  String headimg;
  String imagePath;
  int sex;
  int level;

  GetGiftAnalysis({
    required this.giftCount,
    required this.userId,
    required this.nickname,
    required this.headimg,
    required this.imagePath,
    required this.sex,
    required this.level,
  });

  factory GetGiftAnalysis.fromJson(Map<String, dynamic> json) => GetGiftAnalysis(
    giftCount: json["giftCount"],
    userId: json["user_id"],
    nickname: json["nickname"],
    headimg: json["headimg"],
    imagePath: json["image_path"],
    sex: json["sex"],
    level: json["level"],
  );

  Map<String, dynamic> toJson() => {
    "giftCount": giftCount,
    "user_id": userId,
    "nickname": nickname,
    "headimg": headimg,
    "image_path": imagePath,
    "sex": sex,
    "level": level,
  };
}
