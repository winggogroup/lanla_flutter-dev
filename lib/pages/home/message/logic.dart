import 'package:get/get.dart';
import 'package:lanla_flutter/services/content.dart';

import 'state.dart';

class MessageLogic extends GetxController {
  final MessageState state = MessageState();
  final xiaoxi = Get.find<ContentProvider>();
  empty() async {
    // if(id==2){
    //   state.concern=0;
    // }else if(id==1){
    //   state.likeComment=0;
    // }else if(id==3){
    //   state.likeCollect=0;
    // }
    var result = await xiaoxi.Newsquantity();
    if (result.statusCode == 200) {
      state.likeCollect = result.body['likeCollect'];
      state.concern = result.body['concern'];
      state.likeComment = result.body['likeComment'];
      state.systemnum = result.body['system'];
      update();
    }

  }
}
