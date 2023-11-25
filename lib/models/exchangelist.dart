// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

exchangelist exchangelistFromJson(String str) => exchangelist.fromJson(json.decode(str));

String exchangelistToJson(exchangelist data) => json.encode(data.toJson());

class exchangelist {
  exchangelist({
    required this.data,
  });

  List<Datum> data;

  factory exchangelist.fromJson(Map<String, dynamic> json) => exchangelist(
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  Datum({
    required this.id,
    required this.image,
    required this.price,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.stock,
    required this.total,
    required this.title,
  });

  int id;
  String image;
  String price;
  int status;
  DateTime createdAt;
  DateTime updatedAt;
  int stock;
  int total;
  String title;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    image: json["image"],
    price: json["price"],
    status: json["status"],
    stock: json["stock"],
    total: json["total"],
    title: json["title"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "image": image,
    "price": price,
    "status": status,
    "stock": stock,
    "total": total,
    "title": title,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}