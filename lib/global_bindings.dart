import 'package:get/get.dart';
import 'package:lanla_flutter/pages/home/friend/logic.dart';
import 'package:lanla_flutter/pages/home/logic.dart';
import 'package:lanla_flutter/pages/home/start/list_widget/list_logic.dart';
import 'package:lanla_flutter/pages/home/start/logic.dart';

import 'common/controller/PublishDataLogic.dart';
import 'pages/home/start/logic.dart';

class GlobalBindings extends Bindings {
  @override
  void dependencies() {
    //Get.put<VideoLogic>(VideoLogic(), permanent: true,);
    //Get.put<UserLogic>(UserLogic(), permanent: true);
    Get.put<HomeLogic>(HomeLogic(), permanent: true);
    Get.put<PublishDataLogic>(PublishDataLogic(), permanent: true);
    Get.put<FriendLogic>(FriendLogic(), permanent: true);
    //Get.put<IndexLogic>(IndexLogic(), permanent: true); // 储存app首页信息 - 即将废弃
    Get.put<StartLogic>(StartLogic(), permanent: true); // 储存app首页信息
    Get.put<StartListLogic>(StartListLogic(), permanent: true); // 储存app频道信息

  }
}
