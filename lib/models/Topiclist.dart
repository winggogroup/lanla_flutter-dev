import 'package:meta/meta.dart';
import 'dart:convert';

List<conversation> conversationFromJson(String str) => List<conversation>.from(json.decode(str).map((x) => conversation.fromJson(x)));

String conversationToJson(List<conversation> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class conversation {
  conversation({
    required this.id,
    required this.name,
    required this.picture,
    required this.checked,
  });

  int id;
  String name;
  String picture;
  String checked;

  factory conversation.fromJson(Map<String, dynamic> json) => conversation(
    id: json["id"],
    name: json["name"],
    picture: json["picture"],
    checked: json["checked"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "picture": picture,
    "checked": checked,
  };
}