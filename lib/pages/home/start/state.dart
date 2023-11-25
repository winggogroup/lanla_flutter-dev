import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lanla_flutter/models/ChannelList.dart';

class StartState {
  // 最顶部的tab控制器
  TabController? topTabController;
  final List<Tab> topTabs = <Tab>[
    Tab(text: '发现'.tr),
    Tab(text: '话题'.tr),
    Tab(text: '附近'.tr),
  ];
}
