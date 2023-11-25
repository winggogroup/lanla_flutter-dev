import 'dart:convert';

import 'Data.dart';
List<Newolduser> NewolduserFromJson(String str) => List<Newolduser>.from(json.decode(str).map((x) => Newolduser.fromJson(x)));

String NewolduserToJson(List<Newolduser> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
class Newolduser {
  Newolduser({

    required this.info,
    required this.data,});

  Newolduser.fromJson(dynamic json) {
    // status = json['status'];
    info = json['info'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  String? info;
  Data? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    // map['status'] = status;
    map['info'] = info;
    final data = this.data;
    if (data != null) {
      map['data'] = data.toJson();
    }
    return map;
  }

}