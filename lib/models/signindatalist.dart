// To parse this JSON data, do
//
//     final signindatalist = signindatalistFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

Signindatalist signindatalistFromJson(String str) => Signindatalist.fromJson(json.decode(str));

String signindatalistToJson(Signindatalist data) => json.encode(data.toJson());

class Signindatalist {
  int userIndex;
  bool userDailySignIn;
  List<Task> task;

  Signindatalist({
    required this.userIndex,
    required this.userDailySignIn,
    required this.task,
  });

  factory Signindatalist.fromJson(Map<String, dynamic> json) => Signindatalist(
    userIndex: json["userIndex"],
    userDailySignIn: json["userDailySignIn"],
    task: List<Task>.from(json["task"].map((x) => Task.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "userIndex": userIndex,
    "userDailySignIn": userDailySignIn,
    "task": List<dynamic>.from(task.map((x) => x.toJson())),
  };
}

class Task {
  int id;
  String title;
  String description;
  String imagePath;
  DateTime updatedAt;
  List<TaskReward> taskRewards;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.imagePath,
    required this.updatedAt,
    required this.taskRewards,
  });

  factory Task.fromJson(Map<String, dynamic> json) => Task(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    imagePath: json["imagePath"],
    updatedAt: DateTime.parse(json["updatedAt"]),
    taskRewards: List<TaskReward>.from(json["taskRewards"].map((x) => TaskReward.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "imagePath": imagePath,
    "updatedAt": updatedAt.toIso8601String(),
    "taskRewards": List<dynamic>.from(taskRewards.map((x) => x.toJson())),
  };
}

class TaskReward {
  String rewardAmount;
  int rewardType;
  int showType;

  TaskReward({
    required this.rewardAmount,
    required this.rewardType,
    required this.showType,
  });

  factory TaskReward.fromJson(Map<String, dynamic> json) => TaskReward(
    rewardAmount: json["rewardAmount"],
    rewardType: json["rewardType"],
    showType: json["showType"],
  );

  Map<String, dynamic> toJson() => {
    "rewardAmount": rewardAmount,
    "rewardType": rewardType,
    "showType": showType,
  };
}
