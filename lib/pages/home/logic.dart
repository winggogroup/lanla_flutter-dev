import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import 'state.dart';

class HomeLogic extends GetxController {
  final HomeState state = HomeState();
  final PageController controller = PageController(initialPage: 0);


  // 设置当前页
  setNowPage(index) {
    state.nowPage.value = index;
    controller.jumpToPage(index);
  }
}
