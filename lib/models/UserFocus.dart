// To parse this JSON data, do
//
//     final userFocus = userFocusFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

UserFocus userFocusFromJson(String str) => UserFocus.fromJson(json.decode(str));

String userFocusToJson(UserFocus data) => json.encode(data.toJson());

class UserFocus {
  UserFocus({
    required this.likes,
    required this.collects,
    required this.follows,
  });

  List<int> likes;
  List<int> collects;
  List<int> follows;

  factory UserFocus.fromJson(Map<String, dynamic> json) => UserFocus(
    likes: List<int>.from(json["likes"].map((x) => x)),
    collects: List<int>.from(json["collects"].map((x) => x)),
    follows: List<int>.from(json["follows"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "likes": List<dynamic>.from(likes.map((x) => x)),
    "collects": List<dynamic>.from(collects.map((x) => x)),
    "follows": List<dynamic>.from(follows.map((x) => x)),
  };

  bool CheckLike(int id){

    return false;
  }
}
