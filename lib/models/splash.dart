// To parse this JSON data, do
//
//     final splashModel = splashModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<SplashModel> splashModelFromJson(String str) => List<SplashModel>.from(json.decode(str).map((x) => SplashModel.fromJson(x)));

String splashModelToJson(List<SplashModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SplashModel {
  SplashModel({
    required this.imagePath,
    required this.targetId,
    required this.targetType,
    required this.targetOther,
  });

  String imagePath;
  String targetId;
  int targetType;
  String targetOther;

  factory SplashModel.fromJson(Map<String, dynamic> json) => SplashModel(
    imagePath: json["imagePath"],
    targetId: json["targetId"],
    targetType: json["targetType"],
    targetOther: json["targetOther"],
  );

  Map<String, dynamic> toJson() => {
    "imagePath": imagePath,
    "targetId": targetId,
    "targetType": targetType,
    "targetOther": targetOther,
  };
}
