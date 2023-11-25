import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lanla_flutter/models/HomeDetails.dart';
import 'package:lanla_flutter/models/HomeItem.dart';
import 'package:lanla_flutter/pages/detail/picture/picture_view.dart';
import 'package:lanla_flutter/pages/detail/user/inner_view.dart';
import 'package:lanla_flutter/pages/detail/video/video_list_view.dart';
import 'package:lanla_flutter/services/content.dart';
import 'package:lanla_flutter/ulits/app_log.dart';
import 'package:lanla_flutter/ulits/event.dart';
import 'package:lanla_flutter/ulits/toast.dart';

class PicturePage extends StatefulWidget {
  const PicturePage({super.key});

  @override
  _PicturePageState createState() => _PicturePageState();
}

class _PicturePageState extends State<PicturePage> {
  int? Id;
  bool? isEnd;
  int nowUserId = 0;
  var dataSource;
  PageController _controller = PageController();

  @override
  void initState() {
    Id = Get.arguments['data'];
    isEnd = Get.arguments['isEnd'];
    // nowUserId = dataSource?.userId ?? 0;
    _controller.addListener(_pageListener);
    if(Get.arguments['Detailed']!=null){
      setState(() {
        dataSource = Get.arguments['Detailed'];
        nowUserId = Get.arguments['Detailed']?.userId ?? 0;
      });
    }else{
      _initData();
    }

    super.initState();
  }

  _pageListener() {
    if (_controller.page == 1) {
      AppLog('toUserPage', event: 'pic', targetid: nowUserId);
    }
  }

  _initData() async {
    print('hussssssdddddddd}');
    //请求当前数据
    HomeDetails? defalutData = await _fetchDefalutData(Id!);
    if (defalutData == null) {
      ToastInfo('内容已经被删除'.tr);
      Get.back();
      return;
    }
    setState(() {
      dataSource = defalutData;
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
              if(dataSource!=null)PictureInnerPage(dataSource!, isEnd!),
              // // 用户界面
              if(dataSource!=null)UserInnerView(nowUserId)
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
