// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<positionlist> positionlistFromJson(String str) => List<positionlist>.from(json.decode(str).map((x) => positionlist.fromJson(x)));

String positionlistToJson(List<positionlist> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class positionlist {
  positionlist({
    required this.name,
    required this.placeId,
    required this.vicinity,
  });

  String name;
  String placeId;
  String vicinity;

  factory positionlist.fromJson(Map<String, dynamic> json) => positionlist(
    name: json["name"],
    placeId: json["placeId"],
    vicinity: json["vicinity"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "placeId": placeId,
    "vicinity": vicinity,
  };
}