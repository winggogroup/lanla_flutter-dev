// To parse this JSON data, do
//
//     final UserandUser = UserandUserFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<UserandUser> UserandUserFromJson(String str) => List<UserandUser>.from(json.decode(str).map((x) => UserandUser.fromJson(x)));

String UserandUserToJson(List<UserandUser> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserandUser {
  UserandUser({
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.focusTime,
    required this.works,
    required this.fans,
    required this.slogan,

  });

  int userId;
  String userName;
  String userAvatar;
  String focusTime;
  String slogan;
  int works;
  int fans;

  factory UserandUser.fromJson(Map<String, dynamic> json) => UserandUser(
    userId: json["userId"],
    userName: json["userName"],
    userAvatar: json["userAvatar"],
    focusTime: json["focusTime"],
    works: json["works"],
    fans: json["fans"],
    slogan: json["slogan"],
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "userName": userName,
    "userAvatar": userAvatar,
    "focusTime": focusTime,
    "works": works,
    "fans": fans,
    "slogan": slogan,
  };
}