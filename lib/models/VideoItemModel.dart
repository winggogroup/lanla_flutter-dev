// To parse this JSON data, do
//
//     final videoItem = videoItemFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<VideoItem> videoItemFromJson(String str) => List<VideoItem>.from(json.decode(str).map((x) => VideoItem.fromJson(x)));

String videoItemToJson(List<VideoItem> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class VideoItem {
  VideoItem({
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
    required this.comments,
    required this.createdAt,
  });

  int id;
  String title;
  String text;
  int collects;
  int type;
  String videoPath;
  String imagesPath;
  String recordingPath;
  String thumbnail;
  int likes;
  int status;
  int channel;
  double attaImageScale;
  int userId;
  String userName;
  String userAvatar;
  int comments;
  DateTime createdAt;

  factory VideoItem.fromJson(Map<String, dynamic> json) => VideoItem(
    id: json["id"],
    title: json["title"],
    text: json["text"],
    collects: json["collects"],
    type: json["type"],
    videoPath: json["videoPath"],
    imagesPath: json["imagesPath"],
    recordingPath: json["recordingPath"],
    thumbnail: json["thumbnail"],
    likes: json["likes"],
    status: json["status"],
    channel: json["channel"],
    attaImageScale: json["attaImageScale"].toDouble(),
    userId: json["userId"],
    userName: json["userName"],
    userAvatar: json["userAvatar"],
    comments: json["comments"],
    createdAt: DateTime.parse(json["createdAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "text": text,
    "collects": collects,
    "type": type,
    "videoPath": videoPath,
    "imagesPath": imagesPath,
    "recordingPath": recordingPath,
    "thumbnail": thumbnail,
    "likes": likes,
    "status": status,
    "channel": channel,
    "attaImageScale": attaImageScale,
    "userId": userId,
    "userName": userName,
    "userAvatar": userAvatar,
    "comments": comments,
    "createdAt": createdAt.toIso8601String(),
  };
}
