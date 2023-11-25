import 'dart:convert';

List<HomeDetails> homeDetailsFromJson(String str) => List<HomeDetails>.from(json.decode(str).map((x) => HomeDetails.fromJson(x)));

String homeDetailsToJson(List<HomeDetails> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class HomeDetails {
  HomeDetails({
    required this.id,
    required this.title,
    required this.collects,
    required this.type,
    required this.videoPath,
    required this.thumbnail,
    required this.likes,
    required this.status,
    required this.recordingPath,
    required this.attaImageScale,
    required this.recordingTime,
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.createdAt,
    required this.comments,
    required this.imagesPath,
    required this.text,
    required this.channel,
    required this.topics,
    required this.placeName,
    required this.placeId,
    required this.visits,
    required this.goodsList,
  });

  int id;
  String title;
  int collects;
  int type;
  String videoPath;
  String thumbnail;
  String imagesPath;
  int likes;
  int status;
  String recordingPath;
  double attaImageScale;
  int recordingTime;
  int userId;
  int channel;
  int comments;
  String createdAt;
  String userName;
  String userAvatar;
  String text;
  String placeName;
  String placeId;
  String visits;
  List<dynamic> topics;
  List<GoodsList> goodsList;

  factory HomeDetails.fromJson(Map<String, dynamic> json) => HomeDetails(
    id: json["id"],
    title: json["title"],
    collects: json["collects"],
    type: json["type"],
    videoPath: json["videoPath"],
    imagesPath: json["imagesPath"],
    thumbnail: json["thumbnail"],
    likes: json["likes"],
    text: json["text"],
    status: json["status"],
    recordingPath:json["recordingPath"],
    comments: json["comments"],
    createdAt: json["createdAt"],
    recordingTime:json["recordingTime"],
    attaImageScale: json["attaImageScale"].toDouble(),
    userId: json["userId"],
    channel: json["channel"],
    userName: json["userName"],
    userAvatar: json["userAvatar"],
    topics: json["topics"],
    visits: json["visits"],
    placeName: json["placeName"]==null?'':json["placeName"],
    placeId: json["placeId"]==null?'':json["placeId"],
    goodsList: List<GoodsList>.from(json["goodsList"].map((x) => GoodsList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "collects": collects,
    "type": type,
    "videoPath": videoPath,
    "imagesPath": imagesPath,
    "thumbnail": thumbnail,
    "text": text,
    "likes": likes,
    "status": status,
    'recordingPath':recordingPath,
    "attaImageScale": attaImageScale,
    "recordingTime":recordingTime,
    "userId": userId,
    "comments": comments,
    "createdAt": createdAt,
    "visits": visits,
    "userName": userName,
    "userAvatar": userAvatar,
    "channel": channel,
    "topics":topics,
    "placeName":placeName==null?'':placeName,
    "placeId":placeId==null?'':placeId,
    "goodsList": List<dynamic>.from(goodsList.map((x) => x.toJson())),
  };
}

class GoodsList {
  GoodsList({
    required this.id,
    required this.title,
    required this.thumbnail,
    required this.score,
    required this.price,
    required this.priceOther,
  });

  int id;
  String title;
  String thumbnail;
  String score;
  String price;
  String priceOther;

  factory GoodsList.fromJson(Map<String, dynamic> json) => GoodsList(
    id: json["id"],
    title: json["title"],
    thumbnail: json["thumbnail"],
    score: json["score"],
    price: json["price"],
    priceOther: json["priceOther"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "thumbnail": thumbnail,
    "score": score,
    "price": price,
    "priceOther": priceOther,
  };
}
