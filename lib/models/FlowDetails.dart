// To parse this JSON data, do
//

import 'package:meta/meta.dart';
import 'dart:convert';

List<FlowDetails> FlowDetailsFromJson(String str) => List<FlowDetails>.from(json.decode(str).map((x) => FlowDetails.fromJson(x)));

String FlowDetailsToJson(List<FlowDetails> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FlowDetails {
  FlowDetails({
    required this.id,
    required this.userId,
    required this.source,
    required this.moneyType,
    required this.price,
    required this.type,
    required this.targetId,
    required this.targetUserId,
    required this.createdAt,
    required this.updatedAt,
    required this.title,
  });

  int id;
  int userId;
  int source;
  int moneyType;
  String price;
  String title;
  int type;
  int targetId;
  int targetUserId;
  String createdAt;
  String updatedAt;

  factory FlowDetails.fromJson(Map<String, dynamic> json) => FlowDetails(
    id: json["id"],
    userId: json["userId"],
    source: json["source"],
    moneyType: json["moneyType"],
    price: json["price"],
    type: json["type"],
    targetId: json["targetId"],
    targetUserId: json["targetUserId"],
    title: json["title"],
    createdAt: json["createdAt"],
    updatedAt: json["updatedAt"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "userId": userId,
    "source": source,
    "moneyType": moneyType,
    "price": price,
    "type": type,
    "targetId": targetId,
    "targetUserId": targetUserId,
    "createdAt": createdAt,
    "updatedAt": updatedAt,
    "title": title,

  };
}