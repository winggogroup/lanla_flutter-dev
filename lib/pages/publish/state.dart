import 'dart:io';

import 'package:geolocator/geolocator.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';


enum PublishType {
  picture,
  video
}
class PublishState {
  var id;
  List listItem = [];
  List<AssetEntity> dataList = [];  // 图片列表
  List<File> dataListFile = []; // 用于展示在页面上
  PublishType type = PublishType.video;

  String? videoPath; // 视频地址
  String? thumbnailPath; // 缩略图
  bool selectThumbnail = false; // 缩略图

  String ossToken = '';
  Position? position;

  // 表单内容
  Map<String,dynamic> formData = {};
  String goodIds = '';
  ///播放
  bool Startplaying=false;

  ///暂停
  bool AudioPause=false;
  // 选择的话题
  List<Map<String, String>> selectTopic = [];
  //位置信息
  Map<dynamic, dynamic> positioninformation={};
  ///长图文图片视频数据
  var Longgraphicvideodata=[];
}
