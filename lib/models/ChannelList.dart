// To parse this JSON data, do
//
//     final channelList = channelListFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<ChannelList> channelListFromJson(String str) => List<ChannelList>.from(json.decode(str).map((x) => ChannelList.fromJson(x)));

String channelListToJson(List<ChannelList> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ChannelList {
  ChannelList({
    required this.id,
    required this.name,
    required this.banner,
  });

  int id;
  String name;
  List<Banner> banner;

  factory ChannelList.fromJson(Map<String, dynamic> json) => ChannelList(
    id: json["id"],
    name: json["name"],
    banner: List<Banner>.from(json["banner"].map((x) => Banner.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "banner": List<dynamic>.from(banner.map((x) => x.toJson())),
  };
}
class Banner {
  Banner({
    required this.id,
    required this.imagePath,
    required this.targetId,
    required this.targetType,
    required this.targetOther,
  });
  int id;
  String imagePath;
  String targetId;
  int targetType;
  String targetOther;

  factory Banner.fromJson(Map<String, dynamic> json) => Banner(
    id: json["id"],
    imagePath: json["imagePath"],
    targetId: json["targetId"],
    targetType: json["targetType"],
    targetOther: json["targetOther"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "imagePath": imagePath,
    "targetId": targetId,
    "targetType": targetType,
    "targetOther": targetOther,
  };
}