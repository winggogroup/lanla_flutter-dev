import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'package:lanla_flutter/ulits/hex_color.dart';
import 'package:lanla_flutter/pages/home/start/detail_view/view.dart';

class UserContentTabView extends StatefulWidget {
  int userId = 0;

  UserContentTabView({super.key, required this.userId});

  @override
  _UserContentTabViewState createState() => _UserContentTabViewState();
}

class _UserContentTabViewState extends State<UserContentTabView> {
  final List<Tab> myTabs = <Tab>[
    Tab(text: '发布'.tr),
    Tab(text: '赞过'.tr),
    Tab(text: '收藏'.tr)
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(width: 1, color: Color(0xffF1F1F1)))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TabBar(
                  tabs: myTabs,
                  labelColor: Colors.black,
                  labelPadding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                  isScrollable: true,
                  indicatorColor: HexColor('#ff2442'),
                  indicatorWeight: 1.5,
                  indicatorSize: TabBarIndicatorSize.label,
                )
              ],
            ),
          ),
          Expanded(
              child: TabBarView(children: [
            StartDetailPage(
              type: ApiType.myPublish,
              parameter: widget.userId.toString(),
                lasting:false
            ),
            StartDetailPage(
              type: ApiType.myLike,
              parameter: widget.userId.toString(),
                lasting:false
            ),
            StartDetailPage(
              type: ApiType.myCollect,
              parameter: widget.userId.toString(), lasting:false
            ),
          ]))
        ],
      ),
    );
  }
}
