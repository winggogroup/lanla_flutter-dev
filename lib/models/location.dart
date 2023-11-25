// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<Location> LocationFromJson(String str) => List<Location>.from(json.decode(str).map((x) => Location.fromJson(x)));

String LocationToJson(List<Location> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Location {
  Location({
    required this.id,
    required this.placeId,
    required this.grade,
    required this.type,
    required this.createdAt,
    required this.name,
    required this.types,
    required this.thumbnail,
  });

  int id;
  String placeId;
  int grade;
  int type;
  String createdAt;
  String name;
  List<String> types;
  String thumbnail;

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    id: json["id"],
    placeId: json["placeId"],
    grade: json["grade"],
    type: json["type"],
    createdAt: json["createdAt"],
    name: json["name"],
    types: List<String>.from(json["types"].map((x) => x)),
    thumbnail: json["thumbnail"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "placeId": placeId,
    "grade": grade,
    "type": type,
    "createdAt": createdAt,
    "name": name,
    "types": List<dynamic>.from(types.map((x) => x)),
    "thumbnail": thumbnail,
  };
}