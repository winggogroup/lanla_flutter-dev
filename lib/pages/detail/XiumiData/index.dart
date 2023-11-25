import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lanla_flutter/models/HomeDetails.dart';
import 'package:lanla_flutter/pages/detail/XiumiData/xiumi_view.dart';
import 'package:lanla_flutter/pages/detail/user/inner_view.dart';
import 'package:lanla_flutter/services/content.dart';
import 'package:lanla_flutter/ulits/toast.dart';

class xiumidataPage extends StatefulWidget {
  @override
  xiumidataState createState() => xiumidataState();
}

class xiumidataState extends State<xiumidataPage> {
  int? Id;
  bool? isEnd;
  int nowUserId = 0;
  var dataSource;
  var newdataSource;
  PageController _controller = PageController();

  @override
  void initState() {
    Id = Get.arguments['data'];
    isEnd = Get.arguments['isEnd'];
    // nowUserId = dataSource?.userId ?? 0;
    _controller.addListener(_pageListener);
    setState(() {
      dataSource = Get.arguments['Detailed'];
      nowUserId = Get.arguments['Detailed']?.userId ?? 0;
    });
    _initData();
    super.initState();
  }

  _pageListener() {
    if (_controller.page == 1) {

    }
  }

  _initData() async {
    //请求当前数据
    HomeDetails? defalutData = await _fetchDefalutData(Id!);
    if (defalutData == null) {
      ToastInfo('内容已经被删除'.tr);
      Get.back();
      return;
    }
    setState(() {
      newdataSource = defalutData;
      nowUserId = defalutData?.userId ?? 0;
    });
  }
  Future<HomeDetails?> _fetchDefalutData(int contentId) async {
    return await Get.put<ContentProvider>(ContentProvider()).Detail(contentId);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          if (_controller.page == 1) {
            _controller.jumpToPage(0);
            return false;
          }
          return true;
        },
        child: NotificationListener(
          onNotification: (ScrollNotification notification) {
            switch (notification.runtimeType) {
              case OverscrollNotification:
                Get.back();
                break;
            }
            return false;
          },
          child: PageView(
            controller: _controller,
            physics: const ClampingScrollPhysics(),
            children: [
              // 图文详情
              if(newdataSource!=null)xiumidetailsPage(newdataSource!, isEnd!),
              // // 用户界面
              if(newdataSource!=null)UserInnerView(nowUserId)
            ],
          ),
        ));
  }

  @override
  void dispose() {
    print('退出图文详情页');
    super.dispose();
  }
}
