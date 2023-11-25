import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import 'package:lanla_flutter/common/controller/UserLogic.dart';
import 'package:lanla_flutter/models/HomeDetails.dart';
import 'package:lanla_flutter/models/HomeItem.dart';
import 'package:lanla_flutter/models/followlist.dart';
import 'package:lanla_flutter/services/content.dart';
import 'state.dart';

class FriendLogic extends GetxController {
  final FriendState state = FriendState();
  ContentProvider provider =  Get.put(ContentProvider());
  final userController = Get.find<UserLogic>();
  //ScrollController scrollController = ScrollController(); //listview 的控制器
  @override
  void onReady() async {
    // TODO: implement onReady
    super.onReady();

    //监听划到最底部就进行if内的操作
    // scrollController.addListener(() {
    //   if (scrollController.position.pixels >
    //       scrollController.position.maxScrollExtent - 20) {
    //
    //   }
    // });

    // Map<String, dynamic> responseData =  jsonDecode(result?.bodyString.toString() ?? '');
  }
  // void initState() {
  //   super.initState();
  //   print('33333');
  // }
  Future<void> FocusInterfaces() async {
    var result = await  provider.followlist('1');
    state.followlist =homeDetailsFromJson(result?.bodyString ?? "");
    update();
  }
  //下拉

  //喜欢
  Future<void> likeoperation(id,index) async {
      bool status =userController.setLike(state.followlist[index].id);
      status? state.followlist[index].likes++: state.followlist[index].likes--;

      update();

   //}
  }
  //收藏
  Future<void> Collectionoperation(id,index) async {
      bool status =userController.setCollect(state.followlist[index].id);
      status? state.followlist[index].collects++: state.followlist[index].collects--;
      update();
   }

   ///更改
  renew(){
    state.Initialselection=2;
    update();
  }
}
