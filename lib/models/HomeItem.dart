import 'dart:convert';

import 'HomeDetails.dart';

List<HomeItem> homeItemFromJson(String str) => List<HomeItem>.from(json.decode(str).map((x) => HomeItem.fromJson(x)));

String homeItemToJson(List<HomeItem> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class HomeItem {
  HomeItem({
    required this.activity,
    required this.contentArea,
    required this.ad,
    required this.id,
    required this.title,
    required this.text,
    required this.collects,
    required this.type,
    required this.videoPath,
    required this.imagesPath,
    required this.recordingPath,
    required this.recordingTime,
    required this.thumbnail,
    required this.likes,
    required this.status,
    required this.channel,
    required this.attaImageScale,
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.createdAt,
    required this.visits,
    required this.isFireTag,
    //required this.topics,
    // required this.targetId,
    // required this.targetType,
    // required this.imagePath,
    // required this.showType,
    // required this.showSite,
  });
  List<Activity> activity;
  List<dynamic>? ad;
  List<ContentArea> contentArea;
  int id;
  String title;
  String? text;
  int? collects;
  int? type;
  String? videoPath;
  String? imagesPath;
  String? recordingPath;
  int? recordingTime;
  String thumbnail;
  int likes;
  int? status;
  int channel;
  double attaImageScale;
  int? userId;
  String userName;
  String userAvatar;
  String? createdAt;
  String? visits;
  int? isFireTag;
  //List<dynamic> topics;
  // String targetId;
  // int? targetType;
  // String imagePath;
  // int? showType;
  // int? showSite;

  factory HomeItem.fromJson(Map<String, dynamic> json) => HomeItem(
    activity: json["activity"] == null ? [] : List<Activity>.from(json["activity"].map((x) => Activity.fromJson(x))),
    contentArea:json["contentArea"] == null ? [] : List<ContentArea>.from(json["contentArea"].map((x) => ContentArea.fromJson(x))),
    ad: json["ad"] == null ? null : [],
    id: json["id"] ?? 0,
    title: json["title"] ?? '',
    text: json["text"],
    collects: json["collects"],
    type: json["type"],
    videoPath: json["videoPath"],
    imagesPath: json["imagesPath"],
    recordingPath: json["recordingPath"],
    recordingTime: json["recordingTime"],
    thumbnail: json["thumbnail"] ?? '',
    likes: json["likes"] ?? 0,
    status: json["status"],
    channel: json["channel"] ?? 0,
    attaImageScale: json["attaImageScale"] == null ? 1.0 : json["attaImageScale"].toDouble(),
    userId: json["userId"],
    userName: json["userName"] ?? '',
    userAvatar: json["userAvatar"] ?? '',
    createdAt: json["createdAt"],
    visits:json["visits"],
    isFireTag:json["isFireTag"],
    //topics: json["topics"] == null ? null : List<dynamic>.from(json["topics"].map((x) => x)),
    // targetId: json["targetId"] == null ? '' : json["targetId"],
    // targetType: json["targetType"] == null ? null : json["targetType"],
    // imagePath: json["imagePath"] == null ? '' : json["imagePath"],
    // showType: json["showType"] == null ? null : json["showType"],
    // showSite: json["showSite"] == null ? null : json["showSite"],
  );

  Map<String, dynamic> toJson() => {
    "activity": activity == null ? null : List<dynamic>.from(activity.map((x) => x.toJson())),

    "contentArea": contentArea == null ? null : List<dynamic>.from(contentArea.map((x) => x.toJson())),
    "ad": activity,
    "id": id,
    "title": title,
    "text": text,
    "collects": collects,
    "type": type,
    "videoPath": videoPath,
    "imagesPath": imagesPath,
    "recordingPath": recordingPath,
    "recordingTime": recordingTime,
    "thumbnail": thumbnail,
    "likes": likes,
    "status": status,
    "channel": channel,
    "attaImageScale": attaImageScale,
    "userId": userId,
    "userName": userName,
    "userAvatar": userAvatar,
    "createdAt": createdAt,
    "visits":visits,
    "isFireTag":isFireTag,
    //"topics": topics == null ? null : List<dynamic>.from(topics.map((x) => x)),
    // "targetId": targetId == null ? null : targetId,
    // "targetType": targetType == null ? null : targetType,
    // "imagePath": imagePath == null ? null : imagePath,
    // "showType": showType == null ? null : showType,
    // "showSite": showSite == null ? null : showSite,
  };
  HomeDetails toHomeDetail() => HomeDetails(
    id: id,
    title:title,
    collects: collects!,
    type: type!,
    videoPath:videoPath!,
      thumbnail:thumbnail,
      likes:likes,
      status:1,
      recordingPath:"",
      attaImageScale:attaImageScale,
      recordingTime:0,
      userId:userId!,
      userName:userName,
      userAvatar:userAvatar,
      createdAt:"",
      comments:0,
      imagesPath:"",
      text:text!,
      channel:channel,
      topics:[],
      placeName:'',
      placeId:'',
      visits:visits!,
      goodsList:[],
  );
}

class Activity {
  Activity({
   required this.id,
   required this.targetId,
    required this.targetOther,
   required this.targetType,
   required this.imagePath,
   required this.showType,
   required this.showSite,
    required this.startTime,
    required this.endTime,
  });

  int id;
  String targetId;
  String targetOther;
  int targetType;
  String imagePath;
  int showType;
  int showSite;
  String? startTime;
  String? endTime;

  factory Activity.fromJson(Map<String, dynamic> json) => Activity(
    id: json["id"],
    targetId: json["targetId"],
    targetOther: json["targetOther"],
    targetType: json["targetType"],
    imagePath: json["imagePath"],
    showType: json["showType"],
    showSite: json["showSite"],
    startTime:json["startTime"],
    endTime:json["endTime"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "targetId": targetId,
    "targetOther": targetOther,
    "targetType": targetType,
    "imagePath": imagePath,
    "showType": showType,
    "showSite": showSite,
    "startTime":startTime,
    "endTime":endTime,
  };
}

class ContentArea {
  ContentArea({
    required this.id,
    required this.cover,
    required this.title,
  });

  int id;
  String cover;
  String title;

  factory ContentArea.fromJson(Map<String, dynamic> json) => ContentArea(
    id: json["id"],
    cover: json["cover"],
    title: json["title"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "cover": cover,
    "title": title,
  };
}