import 'dart:convert';

import 'package:get/get.dart';
import 'package:lanla_flutter/pages/home/start/list_widget/list_logic.dart';

import '../../../models/Topiclist.dart';
import '../../../services/content.dart';
import '../../home/view.dart';
import 'state.dart';

class ChooseTopicLogic extends GetxController {
  var monitor=true;
  final ChooseTopicState state = ChooseTopicState();
  //实例化
  ContentProvider provider =  Get.put(ContentProvider());

  StartListLogic gengxlb =  Get.put(StartListLogic());
  void onReady() async {
    var result = await provider.Topiclist();
    print('请求接口');
    print(result.statusCode);
    print(result.bodyString);
    // Map<String, dynamic> responseData =  jsonDecode(result.bodyString!);
    //
    var st =(conversationFromJson(result?.bodyString ?? ""));
    if(result.statusCode==200){
      state.topiclist.value=st;
    }
  }
  void complete() async{
    if (monitor == false) {
      // 防止重复请求
      return;
    }
    monitor = false;
    var result = await provider.determineht(state.xztopiclist.join(','));
    print('请求接口');
    print(result.statusCode);
    print(result.bodyString);
    Map<String, dynamic> responseData =  jsonDecode(result.bodyString!);
    print(responseData);
    if(result.statusCode==200){
      await gengxlb.initChannelData();
      Get.offAll(HomePage());
    }
    Future.delayed(Duration(milliseconds: 2000), () {
      monitor = true;
    });
  }
}
