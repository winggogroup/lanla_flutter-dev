// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<commoditylistanalysis> commoditylistanalysisFromJson(String str) => List<commoditylistanalysis>.from(json.decode(str).map((x) => commoditylistanalysis.fromJson(x)));

String commoditylistanalysisToJson(List<commoditylistanalysis> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class commoditylistanalysis {
  commoditylistanalysis({
    required this.id,
    required this.title,
    required this.thumbnail,
    required this.score,
    required this.priceOther,
    required this.sort,
    required this.images,
    required this.historyPrice
  });

  int id;
  String title;
  String thumbnail;
  String score;
  String priceOther;
  int sort;
  String images;
  String historyPrice;
  factory commoditylistanalysis.fromJson(Map<String, dynamic> json) => commoditylistanalysis(
    id: json["id"],
    title: json["title"],
    thumbnail: json["thumbnail"],
    score: json["score"],
    priceOther: json["priceOther"],
    sort: json["sort"],
    images: json["images"],
    historyPrice: json["historyPrice"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "thumbnail": thumbnail,
    "score": score,
    "priceOther": priceOther,
    "sort": sort,
    "images": images,
    "historyPrice": historyPrice,
  };
}
