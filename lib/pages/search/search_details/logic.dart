import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:lanla_flutter/ulits/app_log.dart';

import '../../../models/SearchUser.dart';
import '../../../services/search.dart';
import 'state.dart';

class SearchDetailsLogic extends GetxController {
  final SearchDetailsState state = SearchDetailsState();
  //实例化
  SearchProvider provider =  Get.put(SearchProvider());
  ScrollController scrollController = ScrollController();
  ///搜索作品接口
  // Future<void> SearchContent(keywords) async {
  //   // state.keywords=keywords;
  //   // update();
  //   // var result = await provider.Searchcontent(keywords,'1',state.page.toString());
  //   // print('请求接口');
  //   // print(result.statusCode);
  //   // print(result.bodyString);
  //   // print('445566');
  //   update();
  // }
  ///搜索用户接口
  Future<void> SearchUsers(keywords) async {
    state.oneData=true;
    state.page=1;
    state.keywords=keywords;
    print('是啥啊');
    print(keywords);
    var result = await provider.Searchcontent(keywords,'2',state.page.toString());
    print('请求接口yong');
    print(result.statusCode);
    print(result.bodyString);
    print(result.bodyString);
    state.UserContent =SearchUserFromJson(result?.bodyString ?? "");
    state.oneData=false;
    update();
    AppLog('search',data: keywords);
  }
  Future<void> Follow() async {
    var result = await provider.Follow('1');
    print('请求接口yong');
    print(result.statusCode);
    print(result.bodyString);
    print(result.bodyString);

  }
}
