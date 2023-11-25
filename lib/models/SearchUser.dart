// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<SearchUser> SearchUserFromJson(String str) => List<SearchUser>.from(json.decode(str).map((x) => SearchUser.fromJson(x)));

String SearchUserToJson(List<SearchUser> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SearchUser {
  SearchUser({
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.slogan,
    required this.works,
    required this.fans,
  });

  int userId;
  String userName;
  String userAvatar;
  String slogan;
  int works;
  int fans;

  factory SearchUser.fromJson(Map<String, dynamic> json) => SearchUser(
    userId: json["userId"],
    userName: json["userName"],
    userAvatar: json["userAvatar"],
    slogan: json["slogan"],
    works: json["works"],
    fans: json["fans"],
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "userName": userName,
    "userAvatar": userAvatar,
    "slogan": slogan,
    "works": works,
    "fans": fans,
  };
}