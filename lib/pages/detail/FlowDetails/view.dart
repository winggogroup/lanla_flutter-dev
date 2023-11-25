import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lanla_flutter/common/widgets/round_underline_tabindicator.dart';
import 'package:lanla_flutter/models/FlowDetails.dart';
import 'package:lanla_flutter/pages/detail/FlowDetails/ListDetails.dart';
import 'package:lanla_flutter/pages/home/start/detail_view/loading_widget.dart';
import 'package:lanla_flutter/services/GiftDetails.dart';
import 'package:lanla_flutter/ulits/hex_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:lanla_flutter/models/FlowDetails.dart';
import 'package:lanla_flutter/services/GiftDetails.dart';
import 'package:lanla_flutter/ulits/hex_color.dart';

class FlowDetailsPage extends StatefulWidget {
  @override
  createState() => _FlowDetailsState();
}

class _FlowDetailsState extends State<FlowDetailsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<Tab> myTabs = <Tab>[
    Tab(text: 'La币'.tr,),
    Tab(text: '贝壳'.tr),
  ];
  int pagetype=0;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, initialIndex: Get.arguments, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(color:Color(0xffF5F5F5)),
        child: DefaultTabController(
          length: 2,
          initialIndex:pagetype,
          child: Column(
            children: [
              Container(alignment: Alignment.center,width: double.infinity,color: Colors.white,child: TabBar(
                controller: _tabController, // 设置TabController
                  tabs: myTabs,
                  labelColor: Colors.black,
                  unselectedLabelColor:HexColor('#999999'),
                  // labelPadding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                  indicatorPadding:const EdgeInsets.only(bottom: 10,top: 6),
                  // isScrollable: true,
                  indicatorColor: HexColor('#000000'),
                  indicatorWeight: 3,
                  indicator: CustomUnderlineTabIndicator(
                      borderSide: BorderSide(
                        width: 4,
                        color: HexColor('#000000'),
                      )
                  ),
                  // indicator:,
                  indicatorSize: TabBarIndicatorSize.label,
                ),),
              const Divider(height: 1.0, color: Color(0xffF1F1F1),),
              Expanded(
                  child: TabBarView(controller: _tabController,children: [
                    ListDetailsPage(type: ApiType.myLike, pagetype: 1),
                    ListDetailsPage(type: ApiType.myLike, pagetype: 3),
                  ])
              )
            ],
          ),
        ),
      ),
      appBar: AppBar(
        elevation: 0, //消除阴影
        title: Text('明细'.tr,style: const TextStyle(fontSize: 17,fontWeight: FontWeight.w600),),
        backgroundColor: Colors.white,//设置背景颜色为白色
        leading: IconButton(
            color: Colors.black,
            icon: const Icon(Icons.arrow_back_ios),
            tooltip: "Search",
            onPressed: () {
              //print('menu Pressed');
              Get.back();
            }),
      ),
    );
  }

  deactivate() {
    super.dispose();

  }



}
//定义弹窗

