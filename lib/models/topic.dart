//[
//     {
//         "id": 1,
//         "title": "1asd",
//         "playersNum": "12",
//         "getCollect": "13",
//         "hot": 0
//     }
//     ]
import 'dart:convert';

List<TopicModel> topicModelFromJson(String str) => List<TopicModel>.from(json.decode(str).map((x) => TopicModel.fromJson(x)));

String topicModelToJson(List<TopicModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TopicModel {
  TopicModel({
    required this.id,
    required this.title,
    required this.text,
    required this.playersNum,
    required this.visits,
    required this.thumbnail,
    required this.getCollect,
    required this.imagePath,
    required this.hot,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.isCollect

  });

  int id;
  String title;
  String text;
  String playersNum;
  String visits;
  String thumbnail;
  String getCollect;
  String imagePath;
  int hot;
  int status;
  String createdAt;
  String updatedAt;
  bool isCollect;

  factory TopicModel.fromJson(Map<String, dynamic> json) => TopicModel(
    id: json["id"],
    title: json["title"],
    playersNum: json["playersNum"].toString(),
    visits: json["visits"].toString(),
    getCollect: json["getCollect"].toString(),
    text: json["text"],
    thumbnail: json["thumbnail"],
    hot: json["hot"],
    imagePath: json["imagePath"],
    status: json["status"],
    createdAt: json["createdAt"],
    updatedAt: json["updatedAt"],
    isCollect: json["isCollect"] ?? true,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "text": text,
    "playersNum": playersNum,
    "visits": visits,
    "getCollect": getCollect,
    "thumbnail": thumbnail,
    "hot": hot,
    "imagePath": imagePath,
    "status": status,
    "createdAt": createdAt,
    "updatedAt": updatedAt,
    "isCollect": isCollect ?? true,
  };
}
