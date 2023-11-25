// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<Reportype> ReportypeFromJson(String str) => List<Reportype>.from(json.decode(str).map((x) => Reportype.fromJson(x)));

String ReportypeToJson(List<Reportype> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Reportype {
  Reportype({
    required this.id,
    required this.text,
  });

  int? id;
  String? text;

  factory Reportype.fromJson(Map<String, dynamic> json) => Reportype(
    id: json["id"],
    text: json["text"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "text": text,
  };
}