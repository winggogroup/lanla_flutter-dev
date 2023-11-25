// To parse this JSON data, do
//
//     final followlist = followlistFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<followlist> followlistFromJson(String str) => List<followlist>.from(json.decode(str).map((x) => followlist.fromJson(x)));

String followlistToJson(List<followlist> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class followlist {
  followlist({
    required this.id,
    required this.title,
    required this.collects,
    required this.type,
    required this.videoPath,
    required this.thumbnail,
    required this.likes,
    required this.status,
    required this.attaImageScale,
    required this.userId,
    required this.comments,
    required this.createdAt,
    required this.userName,
    required this.userAvatar,
    required this.isCollect,
    required this.isLike,
    required this.isFocus,
    required this.channel,
    required this.text,
    required this.imagesPath,

  });

  int id;
  String title;
  int collects;
  int type;
  String videoPath;
  String thumbnail;
  int likes;
  int status;
  int channel;
  double attaImageScale;
  int userId;
  int comments;
  String createdAt;
  String text;
  String userName;
  String userAvatar;
  bool isCollect;
  bool isLike;
  bool isFocus;
  List<String> imagesPath;

  factory followlist.fromJson(Map<String, dynamic> json) => followlist(
    id: json["id"],
    title: json["title"],
    collects: json["collects"],
    type: json["type"],
    videoPath: json["videoPath"],
    thumbnail: json["thumbnail"],
    likes: json["likes"],
    status: json["status"],
    attaImageScale: json["attaImageScale"].toDouble(),
    channel: json["channel"],
    userId: json["userId"],
    text: json["text"],
    comments: json["comments"],
    createdAt: json["createdAt"],
    userName: json["userName"],
    userAvatar: json["userAvatar"],
    isCollect: json["isCollect"],
    isLike: json["isLike"] == "true" ? true : false,
    isFocus: json["isFocus"],
    imagesPath:List<String>.from(json["imagesPath"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "collects": collects,
    "type": type,
    "videoPath": videoPath,
    "thumbnail": thumbnail,
    "likes": likes,
    "status": status,
    "attaImageScale": attaImageScale,
    "channel": channel,
    "userId": userId,
    "text": text,
    "comments": comments,
    "createdAt": createdAt,
    "userName": userName,
    "userAvatar": userAvatar,
    "isCollect": isCollect,
    "isLike": isLike,
    "isFocus": isFocus,
    "imagesPath": List<dynamic>.from(imagesPath.map((x) => x)),
  };
}
