// To parse this JSON data, do
//
//     final topItemModel = topItemModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<TopItemModel> topItemModelFromJson(String str) => List<TopItemModel>.from(json.decode(str).map((x) => TopItemModel.fromJson(x)));

String topItemModelToJson(List<TopItemModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TopItemModel {
  TopItemModel({
    required this.id,
    required this.title,
    required this.attaImageScale,
    required this.banner,
    required this.url,
  });

  int id;
  String title;
  double attaImageScale;
  String banner;
  String url;

  factory TopItemModel.fromJson(Map<String, dynamic> json) => TopItemModel(
    id: json["id"],
    title: json["title"],
    attaImageScale: json["atta_image_scale"].toDouble(),
    banner: json["banner"],
    url: json["url"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "atta_image_scale": attaImageScale,
    "banner": banner,
    "url": url,
  };
}
