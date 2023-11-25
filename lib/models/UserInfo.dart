// To parse this JSON data, do
//
//     final userInfoMode = userInfoModeFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

UserInfoMode userInfoModeFromJson(String str) => UserInfoMode.fromJson(json.decode(str));

String userInfoModeToJson(UserInfoMode data) => json.encode(data.toJson());

class UserInfoMode {
  UserInfoMode({
    required this.userId,
    required this.userName,
    required this.slogan,
    required this.avatar,
    required this.sex,
    required this.concern,
    required this.fans,
    required this.birthday,
    required this.getLike,
    required this.works,
    required this.getCollect,
    required this.isMyFans,
    required this.isDisLike,
    required this.topics,
    required this.collect,
    required this.addressCollect,
    required this.authImage,
    required this.goodsCollectNum,
    required this.level,
    required this.labelHighQualityAuthor,
    required this.labelFamousUser,
  });

  int userId;
  String userName;
  String slogan;
  String avatar;
  int sex;
  int concern;
  int fans;
  int works;
  dynamic birthday;
  int getLike;
  int getCollect;
  bool isMyFans;
  bool isDisLike;
  int topics;
  int collect;
  int addressCollect;
  int goodsCollectNum;
  String authImage;
  int level;
  Label labelHighQualityAuthor;
  Label labelFamousUser;

  factory UserInfoMode.fromJson(Map<String, dynamic> json) => UserInfoMode(
    userId: json["userId"],
    userName: json["userName"],
    slogan: json["slogan"],
    avatar: json["avatar"],
    sex: json["sex"],
    concern: json["concern"],
    fans: json["fans"],
    birthday: json["birthday"],
    getLike: json["getLike"],
    getCollect: json["getCollect"],
    isMyFans: json["isMyFans"],
    isDisLike: json["isDisLike"],
    works: json["works"],
    topics: json["topics"],
    collect: json["collect"],
    addressCollect: json["addressCollect"],
    authImage: json["authImage"],
    goodsCollectNum:json["goodsCollectNum"],
    level:json["level"],
    labelHighQualityAuthor: Label.fromJson(json["label_high_quality_author"]),
    labelFamousUser: Label.fromJson(json["label_famous_user"]),
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "userName": userName,
    "slogan": slogan,
    "avatar": avatar,
    "sex": sex,
    "concern": concern,
    "fans": fans,
    "birthday": birthday,
    "getLike": getLike,
    "getCollect": getCollect,
    "isMyFans": isMyFans,
    "isDisLike":isDisLike,
    "works": works,
    "topics": topics,
    "collect": collect,
    "addressCollect": addressCollect,
    "authImage": authImage,
    "goodsCollectNum":goodsCollectNum,
    "level":level,
    "label_high_quality_author": labelHighQualityAuthor.toJson(),
    "label_famous_user": labelFamousUser.toJson(),
  };
}
class Label {
  String icon;
  String desc;

  Label({
    required this.icon,
    required this.desc,
  });

  factory Label.fromJson(Map<String, dynamic> json) => Label(
    icon: json["icon"],
    desc: json["desc"],
  );

  Map<String, dynamic> toJson() => {
    "icon": icon,
    "desc": desc,
  };
}