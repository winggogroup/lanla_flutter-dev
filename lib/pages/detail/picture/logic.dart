import 'package:get/get.dart';
import 'package:lanla_flutter/models/HomeItem.dart';

import 'package:lanla_flutter/services/content.dart';
import 'state.dart';

class PictureLogic extends GetxController {
  final PictureState state = PictureState();
  //实例化
  ContentProvider provider = Get.put(ContentProvider());
  HomeItem? dataSource = null;


  @override
  void onReady(){
    dataSource = Get.arguments['data'] as HomeItem;
    print('接收参数');
    print(dataSource?.userAvatar);
    update();
    super.onReady();
  }

  setData(HomeItem data){
    dataSource = data;
    print('设置默认值');
    print(dataSource?.imagesPath);
    Future.delayed(const Duration(milliseconds: 200)).then((e){
      update();
    });
  }
  //@override
  // Future<void> follow() async {
  //   var result = await provider.follow();
  //   print('请求接口');
  //   print(result.statusCode);
  //   print(result.bodyString);
  // }

@override
  void onClose() {
    print('结束图文');
    super.onClose();
  }
}
