// To parse this JSON data, do
//
//     final Binding = BindingFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<Binding> BindingFromJson(String str) => List<Binding>.from(json.decode(str).map((x) => Binding.fromJson(x)));

String BindingToJson(List<Binding> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Binding {
  Binding({
    required this.name,
    required this.type,
    required this.areaCode,
  });

  String name;
  int type;
  String areaCode;

  factory Binding.fromJson(Map<String, dynamic> json) => Binding(
    name: json["name"],
    type: json["type"],
    areaCode: json["areaCode"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "type": type,
    "areaCode": areaCode,
  };
}