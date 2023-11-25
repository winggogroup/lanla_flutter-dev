// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<Rechargelist> RechargelistFromJson(String str) => List<Rechargelist>.from(json.decode(str).map((x) => Rechargelist.fromJson(x)));

String RechargelistToJson(List<Rechargelist> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Rechargelist {
  Rechargelist({
    required this.id,
    required this.platform,
    required this.otherId,
    required this.money,
    required this.price,
    required this.rate,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  int platform;
  String otherId;
  String money;
  String price;
  String rate;
  DateTime createdAt;
  DateTime updatedAt;

  factory Rechargelist.fromJson(Map<String, dynamic> json) => Rechargelist(
    id: json["id"],
    platform: json["platform"],
    otherId: json["otherId"],
    money: json["money"],
    price: json["price"],
    rate: json["rate"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "platform": platform,
    "otherId": otherId,
    "money": money,
    "price": price,
    "rate": rate,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
  };
}