import 'package:get/get.dart';
import 'package:lanla_flutter/models/HomeItem.dart';
import 'package:lanla_flutter/models/VideoItemModel.dart';


class VideoState {
  int nowViewPage = 0;  // 用于监听滑动完成，控制播放
  int totalPage = 3;
  List<HomeItem> dataSource = [];
  bool isEnd = false;


}
