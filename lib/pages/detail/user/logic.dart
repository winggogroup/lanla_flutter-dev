import 'package:get/get.dart';
import 'package:lanla_flutter/services/user.dart';

import 'package:lanla_flutter/models/UserInfo.dart';
import 'state.dart';

class UserHomeLogic extends GetxController {
  final UserHomeState state = UserHomeState();
  final userProvider = Get.put<UserProvider>(UserProvider());
  UserInfoMode? userInfo;
  @override
  void onInit(){
    print('用户信息122');
    print(Get.arguments);
    _setData();
    super.onInit();
  }

  _setData() async {

    UserInfoMode? data = await userProvider.getUserInfo(Get.arguments as int);
    if(data == null){
      Get.back();
      return ;
    }
    userInfo = data;
    update();
  }
}
