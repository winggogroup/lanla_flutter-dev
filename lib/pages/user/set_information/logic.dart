import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:lanla_flutter/common/controller/UserLogic.dart';
import 'package:lanla_flutter/common/toast/view.dart';
import 'package:lanla_flutter/pages/home/view.dart';
import 'package:lanla_flutter/pages/user/Invitationpage/index.dart';
import 'package:lanla_flutter/pages/user/reference/index.dart';
import 'package:lanla_flutter/services/user_home.dart';

import '../../../services/content.dart';
import '../chooseTopic/view.dart';
import 'state.dart';

class SetInformationLogic extends GetxController {
  final SetInformationState state = SetInformationState();
  //引入修改个人信息的文件
  final userLogic =  Get.find<UserLogic>();
  bool antishake=true;
  UserHomeProvider InvitationCodeprovider =  Get.put(UserHomeProvider());
  //实例化
  ContentProvider provider =  Get.put(ContentProvider());
  void Completioninformation(context) async{
    var result = await provider.wansinformation(state.sex,state.birthday.value);
    print('请求接口');
    print(result.statusCode);
    print(result.bodyString);
    Map<String, dynamic> responseData =  jsonDecode(result?.bodyString.toString() ??'');
    print(responseData);
    // Get.to(ChooseTopicPage());
    if(result.statusCode==200){
      if(userLogic.Invitationcodes!=''){
        Fillinvitationcode(userLogic.Invitationcodes,context);
      }
      // Get.offAll(InvitationPage());
      Get.offAll(ReferencePage());
      //Get.to(ChooseTopicPage());
    }
  }
  //
  ///填写邀请码
  Fillinvitationcode(code,context) async {
    if(antishake){
      antishake=false;
      var result = await InvitationCodeprovider.getinviteCode(code);
      if(result ==200){
        Toast.toast(context,
            msg: "填写成功".tr, position: ToastPostion.bottom);
      }

      Timer.periodic(const Duration(milliseconds: 1000),(timer){
        antishake=true;
        timer.cancel();//取消定时器
      }
      );
      //
    }
  }
}
