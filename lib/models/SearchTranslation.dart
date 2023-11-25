// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<Hotlist> HotlistFromJson(String str) => List<Hotlist>.from(json.decode(str).map((x) => Hotlist.fromJson(x)));

String HotlistToJson(List<Hotlist> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Hotlist {
  Hotlist({
    required this.contentId,
    required this.text,
    required this.likes,
    required this.title,
    required this.type,
  });

  int contentId;
  String text;
  int likes;
  int type;
  String title;

  factory Hotlist.fromJson(Map<String, dynamic> json) => Hotlist(
    contentId: json["contentId"],
    text: json["text"],
    likes: json["likes"],
    title: json["title"],
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "contentId": contentId,
    "text": text,
    "likes": likes,
    "title": title,
    "type": type,
  };
}