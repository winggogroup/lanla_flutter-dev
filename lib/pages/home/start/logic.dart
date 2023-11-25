import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lanla_flutter/pages/home/start/state.dart';

class StartLogic extends GetxController with GetSingleTickerProviderStateMixin {
  final StartState state = StartState();
  @override
  void onReady() {
    // TODO: implement onReady
    state.topTabController = TabController(vsync: this, length: 3);
    super.onReady();
    update();
  }

}
