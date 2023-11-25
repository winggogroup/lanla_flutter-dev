import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'state.dart';

class MeLogic extends GetxController with GetSingleTickerProviderStateMixin {
  final MeState state = MeState();

  TabController? tabController;

  @override
  void onReady() {
    tabController = TabController(length: 2, vsync: this);

    super.onReady();
    print('进入我的');
  }
}
