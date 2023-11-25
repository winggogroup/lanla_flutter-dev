// To parse this JSON data, do
//
//     final Message = MessageFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<Message> MessageFromJson(String str) => List<Message>.from(json.decode(str).map((x) => Message.fromJson(x)));

String MessageToJson(List<Message> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Message {
  Message({
    required this.id,
    required this.type,
    required this.userId,
    required this.text,
    required this.targetId,
    required this.targetUserId,
    required this.isRead,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.userAvatar,
    required this.userName,
    required this.thumbnail,
    required this.follows,
    required this.message,
    required this.commentContent,
    required this.title,
    required this.router,
    required this.targetOther,
    required this.contentType,
    required this.contentId,
    required this.contentUserId,
    required this.baseId,
    required this.commentChildContent,
    required this.commentId,



  });

  int id;
  int type;
  int userId;
  String text;
  int router;
  String title;
  int targetId;
  int targetUserId;
  int isRead;
  int status;
  String createdAt;
  String updatedAt;
  String userAvatar;
  String userName;
  String thumbnail;
  bool follows;
  String message;
  String commentContent;
  String targetOther;
  int contentType;
  int contentId;
  int contentUserId;
  int baseId;
  String commentChildContent;
  int commentId;


  factory Message.fromJson(Map<String, dynamic> json) => Message(
    id: json["id"],
    type: json["type"],
    userId: json["userId"],
    router: json["router"],
    title: json["title"],
    text: json["text"],
    targetId: json["targetId"],
    targetUserId: json["targetUserId"],
    isRead: json["isRead"],
    status: json["status"],
    createdAt: json["createdAt"],
    updatedAt: json["updatedAt"],
    userAvatar: json["userAvatar"],
    userName: json["userName"],
    thumbnail: json["thumbnail"],
    follows: json["follows"],
    message: json["message"],
    commentContent: json["commentContent"],
    targetOther: json["targetOther"],
    contentType: json["contentType"],
    contentId: json["contentId"],
    contentUserId: json["contentUserId"],
    baseId: json["baseId"],
    commentChildContent: json["commentChildContent"],
    commentId: json["commentId"],

  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type,
    "userId": userId,
    "text": text,
    "targetId": targetId,
    "targetUserId": targetUserId,
    "isRead": isRead,
    "status": status,
    "createdAt": createdAt,
    "message": message,
    "updatedAt": updatedAt,
    "userAvatar": userAvatar,
    "userName": userName,
    "thumbnail": thumbnail,
    "follows": follows,
    "commentContent":commentContent,
    "title": title,
    "router": router,
    "targetOther": targetOther,
    "contentType": contentType,
    "contentId": contentId,
    "contentUserId": contentUserId,
    "baseId": baseId,
    "commentChildContent": commentChildContent,
    "commentId": commentId,
  };
}