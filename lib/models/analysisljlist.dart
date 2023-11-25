import 'package:meta/meta.dart';
import 'dart:convert';

List<List<analysislwList>> analysislwListFromJson(String str) => List<List<analysislwList>>.from(json.decode(str).map((x) => List<analysislwList>.from(x.map((x) => analysislwList.fromJson(x)))));

String analysislwListToJson(List<List<analysislwList>> data) => json.encode(List<dynamic>.from(data.map((x) => List<dynamic>.from(x.map((x) => x.toJson())))));

class analysislwList {
  analysislwList({
    required this.id,
    required this.type,
    required this.name,
    required this.imagePath,
    required this.price,
    required this.status,
    required this.sort,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  int type;
  String name;
  String imagePath;
  int price;
  int status;
  int sort;
  DateTime createdAt;
  DateTime updatedAt;

  factory analysislwList.fromJson(Map<String, dynamic> json) => analysislwList(
    id: json["id"],
    type: json["type"],
    name: json["name"],
    imagePath: json["imagePath"],
    price: json["price"],
    status: json["status"],
    sort: json["sort"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type,
    "name": name,
    "imagePath": imagePath,
    "price": price,
    "status": status,
    "sort": sort,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
  };
}

