// To parse this JSON data, do
//
//     final spDetails = spDetailsFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

spDetails spDetailsFromJson(String str) => spDetails.fromJson(json.decode(str));

String spDetailsToJson(spDetails data) => json.encode(data.toJson());

class spDetails {
  spDetails({
    required this.id,
    required this.title,
    required this.thumbnail,
    required this.score,
    required this.price,
    required this.priceOther,
    required this.historyPrice,
    required this.commentList,
    required this.isCollect,
    required this.fiveStarNum,
    required this.fourStarNum,
    required this.threeStarNum,
    required this.twoStarNum,
    required this.oneStarNum,
    required this.commentNum,
    required this.images,
  });

  int id;
  String title;
  String thumbnail;
  String score;
  String price;
  String priceOther;
  String historyPrice;
  List<CommentList> commentList;
  bool isCollect;
  int fiveStarNum;
  int fourStarNum;
  int threeStarNum;
  int twoStarNum;
  int oneStarNum;
  int commentNum;
  String images;


  factory spDetails.fromJson(Map<String, dynamic> json) => spDetails(
    id: json["id"],
    title: json["title"],
    thumbnail: json["thumbnail"],
    score: json["score"],
    price: json["price"],
    images: json["images"],
    commentList: List<CommentList>.from(json["commentList"].map((x) => CommentList.fromJson(x))),
    isCollect: json["isCollect"],
    fiveStarNum: json["fiveStarNum"],
    fourStarNum: json["fourStarNum"],
    threeStarNum: json["threeStarNum"],
    twoStarNum: json["twoStarNum"],
    oneStarNum: json["oneStarNum"],
    commentNum: json["commentNum"],
    priceOther: json["priceOther"],
    historyPrice: json["historyPrice"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "thumbnail": thumbnail,
    "score": score,
    "price": price,
    "images": images,
    "commentList": List<dynamic>.from(commentList.map((x) => x.toJson())),
    "isCollect": isCollect,
    "fiveStarNum": fiveStarNum,
    "fourStarNum": fourStarNum,
    "threeStarNum": threeStarNum,
    "twoStarNum": twoStarNum,
    "oneStarNum": oneStarNum,
    "commentNum": commentNum,
    "priceOther": priceOther,
    "historyPrice": historyPrice,
  };
}

class CommentList {
  CommentList({
    required this.id,
    required this.text,
    required this.images,
    required this.username,
    required this.avatar,
    required this.userId,
    required this.type,
    required this.score,
    required this.createdAt
  });

  int id;
  String text;
  String images;
  String username;
  String avatar;
  int userId;
  int type;
  String createdAt;
  String score;
  factory CommentList.fromJson(Map<String, dynamic> json) => CommentList(
    id: json["id"],
    text: json["text"],
    images: json["images"],
    username: json["username"],
    avatar: json["avatar"],
    userId: json["userId"],
    type: json["type"],
    createdAt: json["createdAt"],
    score: json["score"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "text": text,
    "images": images,
    "username": username,
    "avatar": avatar,
    "userId": userId,
    "type": type,
    'score':score,
    'createdAt':createdAt
  };
}
