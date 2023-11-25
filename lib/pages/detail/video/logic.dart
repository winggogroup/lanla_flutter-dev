import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lanla_flutter/models/HomeItem.dart';
import 'package:lanla_flutter/models/VideoItemModel.dart';

import '../../../services/video.dart';
import 'state.dart';

class VideoLogic extends GetxController with GetSingleTickerProviderStateMixin{
  final VideoState state = VideoState();
  PageController pageController = PageController(); // 上下滑动控制器
  VideoProvider provider = Get.put<VideoProvider>(VideoProvider());
  @override
  void onReady() {
    print('初始化controller');
    // 请求接口
    super.onReady();
  }

  // 初始化数据
  setInitData(){
    print('初始化video');
    state.dataSource.add(Get.arguments['data']);
    state.isEnd = Get.arguments['isEnd'];
    if(!state.isEnd){
      _getList();
      _getList();
    }
  }

  // 抓取下一页数据
  _getList() async {
    // var result = await provider.GetVideoList();
    // print(result.bodyString);
    // List<HomeItem> data = homeItemFromJson(result.bodyString??"");
    // state.dataSource.addAll(data);
    // update();
  }

  setNowViewPage(index){
    state.nowViewPage = index;
    update();
  }

  clear(){
    print('清理video');
    state.dataSource = [];
    state.totalPage = 0;
    state.nowViewPage = 0;
  }

  @override
  void onClose(){
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    super.onClose();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    print('释放了');
    super.dispose();
  }
}
