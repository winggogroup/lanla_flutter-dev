// To parse this JSON data, do
//
//     final commentParent = commentParentFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

import 'comment_child.dart';

List<CommentParent> commentParentFromJson(String str) => List<CommentParent>.from(json.decode(str).map((x) => CommentParent.fromJson(x)));

String commentParentToJson(List<CommentParent> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CommentParent {
  CommentParent({
    required this.id,
    required this.userId,
    required this.contentId,
    required this.text,
    required this.parentUid,
    required this.baseId,
    required this.likes,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.userName,
    required this.userAvatar,
    required this.children,
    required this.childrenCount,
    required this.selfLike,
  });

  int id;
  int userId;
  int contentId;
  String text;
  int parentUid;
  int baseId;
  int likes;
  int status;
  DateTime createdAt;
  DateTime updatedAt;
  String userName;
  String userAvatar;
  List<CommentChild> children;
  int childrenCount;
  bool selfLike;

  factory CommentParent.fromJson(Map<String, dynamic> json) => CommentParent(
    id: json["id"],
    userId: json["userId"],
    contentId: json["contentId"],
    text: json["text"],
    parentUid: json["parentUid"],
    baseId: json["baseId"],
    likes: json["likes"],
    status: json["status"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    userName: json["userName"],
    userAvatar: json["userAvatar"],
    children: List<CommentChild>.from(json["children"].map((x) => CommentChild.fromJson(x))),
    childrenCount: json["childrenCount"],
    selfLike: json["selfLike"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "userId": userId,
    "contentId": contentId,
    "text": text,
    "parentUid": parentUid,
    "baseId": baseId,
    "likes": likes,
    "status": status,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "userName": userName,
    "userAvatar": userAvatar,
    "children": List<dynamic>.from(children.map((x) => x)),
    "childrenCount": childrenCount,
    "selfLike": selfLike,
  };
}
