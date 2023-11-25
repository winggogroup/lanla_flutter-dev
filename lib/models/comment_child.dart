// To parse this JSON data, do
//
//     final commentChild = commentChildFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<CommentChild> commentChildFromJson(String str) => List<CommentChild>.from(json.decode(str).map((x) => CommentChild.fromJson(x)));

String commentChildToJson(List<CommentChild> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CommentChild {
  CommentChild({
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
    required this.targetUserName,
    required this.targetUserId,
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
  String targetUserName;
  String targetUserId;
  bool selfLike;

  factory CommentChild.fromJson(Map<String, dynamic> json) => CommentChild(
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
    targetUserName: json["targetUserName"],
    targetUserId: json["targetUserId"],
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
    "targetUserName": targetUserName,
    "targetUserId": targetUserId,
    "selfLike": selfLike,
  };
}
