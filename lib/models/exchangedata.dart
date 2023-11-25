// To parse this JSON data, do
//
//     final exchangedata = exchangedataFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<Exchangedata> exchangedataFromJson(String str) => List<Exchangedata>.from(json.decode(str).map((x) => Exchangedata.fromJson(x)));

String exchangedataToJson(List<Exchangedata> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Exchangedata {
  String createdAt;
  int price;
  String title;
  String image;
  String pinCode;
  int type;
  int status;

  Exchangedata({
    required this.createdAt,
    required this.price,
    required this.title,
    required this.image,
    required this.pinCode,
    required this.type,
    required this.status,
  });

  factory Exchangedata.fromJson(Map<String, dynamic> json) => Exchangedata(
    createdAt: json["createdAt"],
    price: json["price"],
    title: json["title"],
    image: json["image"],
    pinCode: json["pinCode"],
    type: json["type"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "createdAt": createdAt,
    "price": price,
    "title": title,
    "image": image,
    "pinCode": pinCode,
    "type": type,
    "status": status,
  };
}
