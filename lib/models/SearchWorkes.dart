// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<Welcome> welcomeFromJson(String str) => List<Welcome>.from(json.decode(str).map((x) => Welcome.fromJson(x)));

String welcomeToJson(List<Welcome> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Welcome {
  Welcome({
    required this.id,
    required this.title,
    required this.text,
    required this.collects,
    required this.type,
    required this.videoPath,
    required this.imagesPath,
    required this.recordingPath,
    required this.thumbnail,
    required this.likes,
    required this.status,
    required this.channel,
    required this.attaImageScale,
    required this.userId,
    required this.userName,
    required this.userAvatar,
  });

  int id;
  String title;
  String text;
  int collects;
  int type;
  String videoPath;
  List<dynamic> imagesPath;
  String recordingPath;
  String thumbnail;
  int likes;
  int status;
  int channel;
  double attaImageScale;
  int userId;
  String userName;
  String userAvatar;

  factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
    id: json["id"],
    title: json["title"],
    text: json["text"],
    collects: json["collects"],
    type: json["type"],
    videoPath: json["videoPath"],
    imagesPath: List<dynamic>.from(json["imagesPath"].map((x) => x)),
    recordingPath: json["recordingPath"],
    thumbnail: json["thumbnail"],
    likes: json["likes"],
    status: json["status"],
    channel: json["channel"],
    attaImageScale: json["attaImageScale"].toDouble(),
    userId: json["userId"],
    userName: json["userName"],
    userAvatar: json["userAvatar"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "text": text,
    "collects": collects,
    "type": type,
    "videoPath": videoPath,
    "imagesPath": List<dynamic>.from(imagesPath.map((x) => x)),
    "recordingPath": recordingPath,
    "thumbnail": thumbnail,
    "likes": likes,
    "status": status,
    "channel": channel,
    "attaImageScale": attaImageScale,
    "userId": userId,
    "userName": userName,
    "userAvatar": userAvatar,
  };
}