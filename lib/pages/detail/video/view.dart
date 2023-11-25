import 'package:event_bus/event_bus.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lanla_flutter/common/controller/UserLogic.dart';
import 'package:lanla_flutter/common/widgets/topic_format.dart';
import 'package:lanla_flutter/models/HomeDetails.dart';
import 'package:lanla_flutter/models/HomeItem.dart';
import 'package:lanla_flutter/pages/detail/user/inner_view.dart';
import 'package:lanla_flutter/pages/detail/video/play_view.dart';
import 'package:lanla_flutter/pages/detail/video/video_list_view.dart';
import 'package:lanla_flutter/services/content.dart';
import 'package:lanla_flutter/ulits/app_log.dart';
import 'package:lanla_flutter/ulits/event.dart';
import 'package:lanla_flutter/ulits/toast.dart';

EventBus? stopVideoEvent;

class VideoPage extends StatefulWidget {
  const VideoPage({super.key});

  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  var Id;
  bool? isEnd;
  int nowUserId = 0;
  var dataSource;
  var dataSourceold;
  final PageController _controller = PageController();
  final bool _isOverscroll = false;
  final userLogic = Get.find<UserLogic>();
  @override
  void initState() {
    Id = Get.arguments['data'];
    isEnd = Get.arguments['isEnd'];
    if(Get.arguments['Detailed']!=null){
      setState(() {
        dataSourceold = Get.arguments['Detailed'] ;
        nowUserId = Get.arguments['Detailed']?.userId ?? 0;
      });
    }
    _initData();
    //nowUserId = dataSource?.userId ?? 0;
    _controller.addListener(_pageListener);
    stopVideoEvent = EventBus();

    super.initState();
  }
  _initData() async {
    //请求当前数据
    HomeDetails? defalutData = await _fetchDefalutData(Id!);
    await FirebaseAnalytics.instance.logEvent(
      name: "video_view",
      parameters: {
        "id": Id,
      },
    );
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
  _pageListener() {
    if (_controller.page == 1) {
      stopVideoEvent?.fire(VideoStop());
      AppLog('toUserPage', event: 'video', targetid: nowUserId);
    }
  }

  // 滑动页的回调
  listPageSetUserId(int userId) {
    nowUserId = userId;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return dataSource!=null ? VideoListView(dataSource, isEnd!, listPageSetUserId) :
    Scaffold(
        backgroundColor: Colors.black,
        appBar: PreferredSize(
            preferredSize: Size.zero,
            child: AppBar(
              backgroundColor: Colors.black,
              elevation: 0,
            )),
        body:SafeArea(child: Container(alignment: Alignment.center ,child: Stack(children: [
          Positioned(
              left: 0,
              right: 0,
              top: 0,
              bottom: 70,
              child: Container(
                // child: Image.network(
                //   dataSourceold.thumbnail,
                //   fit: dataSourceold.attaImageScale > 1
                //       ? BoxFit.cover
                //       : BoxFit.fitWidth,
                // ),
                color: Colors.black,
              )
          ),
          Positioned(
            top: 20,
            right: 0,
            child: GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Container(
                height: 50,
                width: 50,
                child: const Center(
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white70,
                    size: 22,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: SizedBox(
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              height: 400,
              //color: Colors.red,
              child: Column(
                crossAxisAlignment:CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [

                  if(dataSource!=null)_userInfoBar(),
                  const SizedBox(height: 10,),
                  _bottomBar(),
                ],
              ),
            ),
          ),
        ],),),)

    );
      WillPopScope(
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
              // 视频滑动界面
              if(dataSource!=null)VideoListView(dataSource, isEnd!, listPageSetUserId),
              // 用户界面
              //if(dataSource!=null)UserInnerView(nowUserId)
            ],
          ),
        ));
  }

  @override
  void dispose() {
    stopVideoEvent!.destroy();
    super.dispose();
  }



  Widget _bottomBar() {
    return Container(
      height: 70,
      color: Colors.black,
      padding: const EdgeInsets.fromLTRB(20, 0, 15, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 1,
            child: GestureDetector(
              child:
              Container(
                padding: const EdgeInsets.fromLTRB(25, 3, 5, 3),
                child:
                Container(
                  height: 44,
                  padding: const EdgeInsets.fromLTRB(15, 3, 15, 3),
                  decoration: const BoxDecoration(
                    // color: HexColor('#efefef'),
                    color: Color(0x4cffffff),
                    //设置四周圆角 角度
                    borderRadius: BorderRadius.all(Radius.circular(40)),
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset('assets/svg/bi_drak.svg',width: 18,height: 18,),
                      const SizedBox(width: 8,),
                      Text(
                        '${'说点什么'.tr}...',

                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            // color: Color(0xff999999)),
                            color: Colors.white.withAlpha(50)),

                      )
                    ],
                  ),
                ),

              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 0),
            // padding: EdgeInsets.only(left: 10),
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  child:Container(color: Colors.transparent,margin:const EdgeInsets.only(left: 20),child:Column(
                    mainAxisAlignment:MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        child:  SvgPicture.asset(
                          "assets/svg/noshoucang.svg",
                        ),
                      ),
                      const SizedBox(height: 5,),//pym_
                      const Text(
                        '0',
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.white),
                      ),
                    ],
                  ) ,) ,
                ),
                Row(
                  children: [
                    GestureDetector(
                      child: Container(color: Colors.transparent,margin:const EdgeInsets.only(left: 20),child:Column(
                        mainAxisAlignment:MainAxisAlignment.center,
                        children: [
                           Container(
                            width: 24,
                            height: 24,
                            child: SvgPicture.asset(
                              "assets/svg/live.svg",
                            ),
                          ),
                          const SizedBox(height: 5,),//pym_
                          const Text(
                            '0',
                            //userLogic.getLike(widget.dataSource.id),
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.white),
                          ),
                        ],
                      ),),
                    )
                  ],
                ),
                ///消息
                GestureDetector(

                  child: Container(color: Colors.transparent,margin:const EdgeInsets.only(left: 20),child:Column(
                    mainAxisAlignment:MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 22,
                        height: 22,
                        child: SvgPicture.asset(
                          'assets/svg/pinglun_new.svg',
                        ),
                      ),
                      const SizedBox(height: 5,),//pym_
                      const Text(
                        '0',
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.white),
                      ),

                    ],
                  ) ,),
                ),
                ///礼物
                GestureDetector(

                  child:Container(
                    color: Colors.transparent,
                    margin: const EdgeInsets.only(left: 0),//pym_
                    child:Column(
                      mainAxisAlignment:MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/liwuicon.png',
                          width: 24,
                          height: 24,
                        ),
                        const SizedBox(height: 0,),
                        Text(
                          '礼物'.tr,
                          style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xff999999)),
                        ),
                      ],
                    ),),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _userInfoBar() {
    return GetBuilder<UserLogic>(builder: (logic) {
      return Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // 头像
                GestureDetector(
                  child: Row(
                    children: [
                      Stack(clipBehavior: Clip.none, alignment:Alignment.center ,children: [
                        Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            border: Border.all(width: 1,color: userLogic.getFollow(dataSourceold.userId)?Colors.transparent:Colors.white),
                            color: Colors.black12,
                            image: DecorationImage(
                                image: NetworkImage(dataSourceold.userAvatar ??
                                    'https://dyhc-dev.oss-cn-beijing.aliyuncs.com/topic/topic-9.png'),
                                fit: BoxFit.cover),
                          ),
                          //child: Image.network(data.userAvatar,fit:BoxFit.cover),
                        ),
                        if(!userLogic.getFollow(dataSourceold.userId))Positioned(bottom: -6,left: 40/2-9,child: GestureDetector(
                          child: Image.asset('assets/images/shiguanzhu.png',width: 18,height: 18,),))
                      ]),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Text(
                          dataSourceold.userName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              height: 15,
            ),
            Container(
              alignment: Alignment.bottomRight,
              margin: const EdgeInsets.only(bottom: 5),
              child: Text(
                dataSourceold.title,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            dataSourceold.text == ''
                ? Container()
                : Container(
              alignment: Alignment.topRight,
              margin: const EdgeInsets.only(bottom: 20),
              child: Text(
                dataSourceold.text ?? '',
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                maxLines: 4,
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
            // TopicFormat(dataSourceold!.topics,isVideo:true)
          ],
        ),
      );
    });
  }
}