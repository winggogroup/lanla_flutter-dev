// To parse this JSON data, do
//
//     final isemailbinding = isemailbindingFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

Isemailbinding isemailbindingFromJson(String str) => Isemailbinding.fromJson(json.decode(str));

String isemailbindingToJson(Isemailbinding data) => json.encode(data.toJson());

class Isemailbinding {
  bool allowBindEmail;
  HaveEmailUserInfo haveEmailUserInfo;

  Isemailbinding({
    required this.allowBindEmail,
    required this.haveEmailUserInfo,
  });

  factory Isemailbinding.fromJson(Map<String, dynamic> json) => Isemailbinding(
    allowBindEmail: json["allow_bind_email"],
    haveEmailUserInfo: HaveEmailUserInfo.fromJson(json["have_email_user_info"]),
  );

  Map<String, dynamic> toJson() => {
    "allow_bind_email": allowBindEmail,
    "have_email_user_info": haveEmailUserInfo.toJson(),
  };
}

class HaveEmailUserInfo {
  int id;
  String nickname;
  String headimg;
  List<LoginMethodList> loginMethodList;

  HaveEmailUserInfo({
    required this.id,
    required this.nickname,
    required this.headimg,
    required this.loginMethodList,
  });

  factory HaveEmailUserInfo.fromJson(Map<String, dynamic> json) => HaveEmailUserInfo(
    id: json["id"],
    nickname: json["nickname"],
    headimg: json["headimg"],
    loginMethodList: List<LoginMethodList>.from(json["login_method_list"].map((x) => LoginMethodList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "nickname": nickname,
    "headimg": headimg,
    "login_method_list": List<dynamic>.from(loginMethodList.map((x) => x.toJson())),
  };
}

class LoginMethodList {
  String name;
  int type;
  String otherId;
  String areaCode;

  LoginMethodList({
    required this.name,
    required this.type,
    required this.otherId,
    required this.areaCode,
  });

  factory LoginMethodList.fromJson(Map<String, dynamic> json) => LoginMethodList(
    name: json["name"],
    type: json["type"],
    otherId: json["other_id"],
    areaCode: json["area_code"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "type": type,
    "other_id": otherId,
    "area_code": areaCode,
  };
}
