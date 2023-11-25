import 'package:meta/meta.dart';
import 'dart:convert';

List<Topicpage> TopicpageFromJson(String str) => List<Topicpage>.from(json.decode(str).map((x) => Topicpage.fromJson(x)));

String TopicpageToJson(List<Topicpage> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Topicpage {
  Topicpage({
    required this.id,
    required this.title,
    required this.text,
    required this.visits,
    required this.getCollect,
    required this.imagePath,
    required this.hot,
    required this.status,
    required this.createdAt,
    required this.thumbnail,
    required this.updatedAt,
    required this.content,
  });

  int id;
  String title;
  String text;
  int visits;
  int getCollect;
  String imagePath;
  int hot;
  int status;
  DateTime createdAt;
  String thumbnail;
  DateTime updatedAt;
  List<Content> content;

  factory Topicpage.fromJson(Map<String, dynamic> json) => Topicpage(
    id: json["id"],
    title: json["title"],
    text: json["text"],
    visits: json["visits"],
    getCollect: json["getCollect"],
    imagePath: json["imagePath"],
    hot: json["hot"],
    status: json["status"],
    createdAt: DateTime.parse(json["createdAt"]),
    thumbnail: json["thumbnail"],
    updatedAt: DateTime.parse(json["updatedAt"]),
    content: List<Content>.from(json["content"].map((x) => Content.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "text": text,
    "visits": visits,
    "getCollect": getCollect,
    "imagePath": imagePath,
    "hot": hot,
    "status": status,
    "createdAt": createdAt.toIso8601String(),
    "thumbnail": thumbnail,
    "updatedAt": updatedAt.toIso8601String(),
    "content": List<dynamic>.from(content.map((x) => x.toJson())),
  };
}

class Content {
  Content({
    required this.id,
    required this.title,
    required this.text,
    required this.collects,
    required this.type,
    required this.videoPath,
    required this.imagesPath,
    required this.recordingPath,
    required this.recordingTime,
    required this.thumbnail,
    required this.likes,
    required this.status,
    required this.channel,
    required this.attaImageScale,
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.comments,
    required this.visits,
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
  int recordingTime;
  String thumbnail;
  int likes;
  int status;
  int channel;
  double attaImageScale;
  int userId;
  String userName;
  String userAvatar;
  int comments;
  String visits;
  DateTime createdAt;

  factory Content.fromJson(Map<String, dynamic> json) => Content(
    id: json["id"],
    title: json["title"],
    text: json["text"],
    collects: json["collects"],
    type: json["type"],
    videoPath: json["videoPath"],
    imagesPath: json["imagesPath"],
    recordingPath: json["recordingPath"],
    recordingTime: json["recordingTime"],
    thumbnail: json["thumbnail"],
    likes: json["likes"],
    status: json["status"],
    channel: json["channel"],
    attaImageScale: json["attaImageScale"]?.toDouble(),
    userId: json["userId"],
    userName: json["userName"],
    userAvatar: json["userAvatar"],
    comments: json["comments"],
    visits: json["visits"],
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
    "recordingTime": recordingTime,
    "thumbnail": thumbnail,
    "likes": likes,
    "status": status,
    "channel": channel,
    "attaImageScale": attaImageScale,
    "userId": userId,
    "userName": userName,
    "userAvatar": userAvatar,
    "comments": comments,
    "visits": visits,
    "createdAt": createdAt.toIso8601String(),
  };
}