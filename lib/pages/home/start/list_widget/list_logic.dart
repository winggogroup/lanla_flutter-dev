import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lanla_flutter/common/controller/UserLogic.dart';
import 'package:lanla_flutter/models/ChannelList.dart';
import 'package:lanla_flutter/pages/detail/video/view.dart';
import 'package:lanla_flutter/services/content.dart';
import 'package:lanla_flutter/ulits/app_log.dart';

import 'list_state.dart';

/**
 * 专门用于控制频道列表
 */
class StartListLogic extends GetxController with GetSingleTickerProviderStateMixin{
  final StartListState state = StartListState();
  final contentProvider = Get.find<ContentProvider>();
  final userLogic = Get.find<UserLogic>(); // 是否正在请求接口
  @override
  void onReady() {
    // TODO: implement onReady
    // initChannelData();
    // toupdate();
    super.onReady();
  }
  initChannelData() {
    FirebaseAnalytics.instance.logEvent(
      name: "UserAppStatus",
      parameters: {
        "userId": userLogic.userId,
        "type":'OpenApp',
        "deviceId":userLogic.deviceId,
      },
    );
    contentProvider.GetChannel().then((List<ChannelList>? value) {

      var recommend;
      var recommendate;
      for(var i=0;i<value!.length;i++){
         if(value[i].id==0){
             recommend=i;
             recommendate=value[i];
         }
      }
      print(33556);
      if(recommend!=null){
        value.removeAt(recommend);
        value!.insert(0, ChannelList(id:0, name:'推荐'.tr,banner:recommendate.banner));
      }else{
        value!.insert(0, ChannelList(id:0, name:'推荐'.tr,banner:[]));
      }


      state.channelTabController = TabController(vsync: this, length: value!.length);
      state.channelDataSource = value!;

      // for(var i=0;i<state.channelDataSource.length;i++){
      //     state.channelDataSource[i].banner= [{
      //     "image_path": "https://dayuhaichuang-dev2.oss-me-east-1.aliyuncs.com/topic/topic-13.png",
      //     "target_id": "1"
      //     },
      //     // {
      //     // "image_path": "https://dayuhaichuang-dev2.oss-me-east-1.aliyuncs.com/topic/topic-13.png",
      //     // "target_id": "1"
      //     // }
      // ];
      // }
      update();
      AppLog('homeinitover');
    });
  }

  channellist() async {
    var res =await contentProvider.userChannellist();
    if(res.statusCode==200){
      print('什么数据');
      print(res.body['unselected_channel']);
      state.newchannel=res.body;
    }
  }
  ///更新
  toupdate(){
    print('更新不更新');
    // Get.defaultDialog();
  }
}