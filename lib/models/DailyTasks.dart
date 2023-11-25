// To parse this JSON data, do
//
//     final dailyTasks = dailyTasksFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

DailyTasks dailyTasksFromJson(String str) => DailyTasks.fromJson(json.decode(str));

String dailyTasksToJson(DailyTasks data) => json.encode(data.toJson());

class DailyTasks {
  List<Datum> newData;
  List<Datum> data;

  DailyTasks({
    required this.newData,
    required this.data,
  });

  factory DailyTasks.fromJson(Map<String, dynamic> json) => DailyTasks(
    newData: List<Datum>.from(json["newData"].map((x) => Datum.fromJson(x))),
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "newData": List<dynamic>.from(newData.map((x) => x.toJson())),
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  String summary;
  int rewardBeans;
  int beansCap;

  int num;
  String image;
  int jumpType;

  Datum({
    required this.summary,
    required this.rewardBeans,
    required this.beansCap,
    required this.num,
    required this.image,
    required this.jumpType,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    summary: json["summary"],
    rewardBeans: json["rewardBeans"],
    beansCap: json["beansCap"],
    num: json["num"],
    image: json["image"],
    jumpType: json["jumpType"],
  );

  Map<String, dynamic> toJson() => {
    "summary": summary,
    "rewardBeans": rewardBeans,
    "beansCap": beansCap,
    "num": num,
    "image": image,
    "jumpType": jumpType,
  };
}
