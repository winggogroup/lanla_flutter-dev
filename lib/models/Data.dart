import 'dart:convert';
class Data {
  late int uid;
  Data({
    required this.uid,});

   Data.fromJson(dynamic json) {
    uid = json['uid'];
  }


  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['uid'] = uid;
    return map;
  }

}