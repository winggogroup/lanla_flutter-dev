// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

LocationDetails LocationDetailsFromJson(String str) => LocationDetails.fromJson(json.decode(str));

String LocationDetailsToJson(LocationDetails data) => json.encode(data.toJson());

class LocationDetails {
  LocationDetails({
    required this.placeId,
    required this.name,
    required this.text,
    required this.weekdayText,
    required this.types,
    required this.phone,
    required this.vicinity,
    required this.visits,
    required this.createdAt,
    required this.lng,
    required this.lat,
    required this.distant,
    required this.imagePath,
    required this.grade,
    required this.type,
    required this.addressGradeId,
  });

  String placeId;
  String name;
  String text;
  List<String> weekdayText;
  List<String> types;
  String phone;
  String vicinity;
  String visits;
  DateTime createdAt;
  double lng;
  double lat;
  String distant;
  String imagePath;
  int grade;
  int type;
  int addressGradeId;

  factory LocationDetails.fromJson(Map<String, dynamic> json) => LocationDetails(
    placeId: json["placeId"],
    name: json["name"],
    text: json["text"],
    weekdayText: List<String>.from(json["weekdayText"].map((x) => x)),
    types: List<String>.from(json["types"].map((x) => x)),
    phone: json["phone"],
    vicinity: json["vicinity"],
    visits: json["visits"],
    createdAt: DateTime.parse(json["createdAt"]),
    lng: json["lng"].toDouble(),
    lat: json["lat"].toDouble(),
    distant: json["distant"],
    imagePath: json["imagePath"],
    grade: json["grade"],
    type: json["type"],
    addressGradeId: json["addressGradeId"],

  );

  Map<String, dynamic> toJson() => {
    "placeId": placeId,
    "name": name,
    "text": text,
    "weekdayText": List<dynamic>.from(weekdayText.map((x) => x)),
    "types": List<dynamic>.from(types.map((x) => x)),
    "phone": phone,
    "vicinity": vicinity,
    "visits": visits,
    "createdAt": createdAt.toIso8601String(),
    "lng": lng,
    "lat": lat,
    "distant": distant,
    "imagePath": imagePath,
    "grade":grade,
    "type":type,
    "addressGradeId":addressGradeId
  };
}
