import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lanla_flutter/common/controller/PublishDataLogic.dart';
import 'package:lanla_flutter/common/controller/UserLogic.dart';
import 'package:lanla_flutter/pages/detail/Amountdetails/view.dart';
import 'package:lanla_flutter/pages/home/logic.dart';
import 'package:lanla_flutter/pages/home/me/RedemptionHistory/index.dart';
import 'package:lanla_flutter/pages/home/me/TaskCenter/index.dart';
import 'package:lanla_flutter/pages/home/me/authentication/index.dart';
import 'package:lanla_flutter/pages/home/me/tab_view.dart';
import 'package:lanla_flutter/pages/home/start/detail_view/logic.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../common/toast/view.dart';
import 'Appsetup/Aboutus.dart';
import 'Appsetup/AccountSecurity.dart';
import 'logic.dart';
import 'myfans/view.dart';
import 'myfollow/view.dart';

class MePage extends StatefulWidget {
  @override
  // late int userId;
  //
  // UserInnerView(this.userId, {super.key});

  MeState createState() => MeState();

}

class MeState extends  State<MePage> with AutomaticKeepAliveClientMixin{
  @override
  bool get wantKeepAlive => true; // 是否开启缓存
  final logic = Get.put(MeLogic());
  final userLogic = Get.find<UserLogic>();
  final publishDataLogic = Get.find<PublishDataLogic>();
  final state = Get.find<MeLogic>().state;
  final _scaffoldkey = GlobalKey<ScaffoldState>();
  final WebSocketes = Get.find<StartDetailLogic>();


  Widget header = DrawerHeader(
    padding: EdgeInsets.zero, /* padding置为0 */
    child: Stack(children: <Widget>[
       Align(/* 先放置对齐 */
        alignment: FractionalOffset.bottomLeft,
        child: Container(
          height: 70.0,
          margin: const EdgeInsets.only(left: 20.0, bottom: 20.0),
          child: Row(
            mainAxisSize: MainAxisSize.min, /* 宽度只用包住子组件即可 */
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
               const CircleAvatar(
                backgroundImage: AssetImage('assets/images/default_head_image.png'),
                // radius: 35.0,
               ),
              Container(
                margin: const EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // 水平方向左对齐
                  mainAxisAlignment: MainAxisAlignment.center, // 竖直方向居中
                  children: const <Widget>[
                    Text("Tom", style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w400,
                        color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],),
        ),
      ),
    ]),
  );


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      drawer: Drawer(
        elevation:0,
        backgroundColor: Colors.white,
        width: MediaQuery.of(context).size.width * 0.7,
        child: Container(
          color: Colors.white,
          margin: const EdgeInsets.only(top: 0),
          child: ListView(
            padding: const EdgeInsets.only(bottom: 40),
            children: [
              // SizedBox(
              //   height: 134.0,
              //   child: Container(
              //     height: 70,
              //     width: 70,
              //     margin: const EdgeInsets.only(right: 20,top: 70),
              //     child: Row(
              //       mainAxisSize: MainAxisSize.min, /* 宽度只用包住子组件即可 */
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       mainAxisAlignment: MainAxisAlignment.start,
              //       children: <Widget>[
              //         const CircleAvatar(
              //           backgroundImage: AssetImage('assets/images/default_head_image.png'),
              //           radius: 23.0,
              //         ),
              //         Container(
              //           height: 60,
              //           margin: const EdgeInsets.only(left: 10.0,top: 14,right: 5),
              //           width: 180,
              //           child: Text(userLogic.userName.toString() ?? '-', style:const TextStyle(
              //               fontSize: 16.0,
              //               fontWeight: FontWeight.w700,
              //               color: Color(0xff2b2b2b),
              //             // overflow: TextOverflow.ellipsis,
              //           ),
              //         ),)
              //       ],),
              //   ),
              // ),
              // const Divider(height: 1.0,color:  Color(0xFFF1F1F1),indent: 20,endIndent: 20,),
              const SizedBox(height: 50,),
              ///个人资料
              GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    Get.toNamed('/verify/userUpdateInfo');
                  },
                  child: ListTile(
                    leading: SvgPicture.asset(
                      "assets/svg/xiugaiziliao.svg",
                      width: 20,
                      height: 20,
                    ),
                    contentPadding: const EdgeInsets.only(right: 20),
                    title: Transform(
                      transform: Matrix4.translationValues(19, 0.0, 0.0),
                      child: Text('个人资料'.tr,
                          style: const TextStyle(fontSize: 15, color: Color(0xff2b2b2b), fontWeight: FontWeight.w400)),
                    )
                    // Text('个人资料'.tr,style: const TextStyle(fontSize: 15,fontWeight: FontWeight.w400,color: Color(0xff2b2b2b)),),
                  )),
              ///设置
              GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    Get.toNamed('/verify/Appsetup');
                  },
                  child: ListTile(
                    leading: SvgPicture.asset(
                      "assets/svg/shezhi.svg",
                      width: 20,
                      height: 20,
                    ),
                    contentPadding: const EdgeInsets.only(right: 20),
                    title: Transform(
                      transform: Matrix4.translationValues(19, 0.0, 0.0),
                      child: Text('设置'.tr,
                          style: const TextStyle(fontSize: 15, color: Color(0xff2b2b2b), fontWeight: FontWeight.w400)),
                    ),

                    // Text('设置'.tr,style: const TextStyle(fontSize: 15,fontWeight: FontWeight.w400,color: Color(0xff2b2b2b)),),
                  )),
              ///达人认证
              GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    Get.to(authentication());
                  },
                  child: ListTile(
                    leading: SvgPicture.asset(
                      "assets/svg/darenrzsvg.svg",
                      width: 20,
                      height: 20,
                    ),
                    contentPadding: const EdgeInsets.only(right: 20),
                    title: Transform(
                      transform: Matrix4.translationValues(19, 0.0, 0.0),
                      child: Text('达人认证'.tr,
                          style: const TextStyle(fontSize: 15, color: Color(0xff2b2b2b), fontWeight: FontWeight.w400)),
                    ),

                    // Text('设置'.tr,style: const TextStyle(fontSize: 15,fontWeight: FontWeight.w400,color: Color(0xff2b2b2b)),),
                  )),

              const Divider(height: 1.0,color:  Color(0xFFEEEEEE),indent: 20,endIndent: 20,),
              ///礼物墙
              GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    Get.toNamed('/verify/GiftWall');
                  },
                  child: ListTile(
                    leading: Image.asset(
                      "assets/images/liwuqiang.png",
                      width: 20,
                      height: 20,
                    ),
                    contentPadding: const EdgeInsets.only(right: 20),
                    title: Transform(
                      transform: Matrix4.translationValues(19, 0.0, 0.0),
                      child: Text('礼物墙'.tr,
                          style: const TextStyle(fontSize: 15, color: Color(0xff2b2b2b), fontWeight: FontWeight.w400)),
                    ),

                    // Text('设置'.tr,style: const TextStyle(fontSize: 15,fontWeight: FontWeight.w400,color: Color(0xff2b2b2b)),),
                  )),
              ///草稿箱
              // GestureDetector(
              //     onTap: () async {
              //       // Navigator.pop(context);
              //       // var sp = await SharedPreferences.getInstance();
              //       // print('长度${jsonDecode(sp.getString("holduptank")!)['${userLogic.userId}'].length}');
              //       // return;
              //       // Get.toNamed('/verify/publish',
              //       //     arguments: {"holduptank": jsonDecode(sp.getString("holduptank")!)['${userLogic.userId}'][4]});
              //       Get.toNamed('/verify/drafts');
              //       //ToastInfo('敬请期待'.tr);
              //     },
              //     child: ListTile(
              //       leading: SvgPicture.asset(
              //         "assets/svg/caogao.svg",
              //         width: 20,
              //         height: 20,
              //       ),
              //       contentPadding: const EdgeInsets.only(right: 20),
              //       title: Transform(
              //         transform: Matrix4.translationValues(19, 0.0, 0.0),
              //         child: Text('草稿箱'.tr,
              //             style: TextStyle(fontSize: 15, color: Color(0xff2b2b2b), fontWeight: FontWeight.w400)),
              //       )
              //       // Text('草稿箱'.tr,style: const TextStyle(fontSize: 15,fontWeight: FontWeight.w400,color: Color(0xff2b2b2b)),),
              //     )),
              ///钱包
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    Get.to(AmountPage(),arguments: 1);
                  },
                  child: ListTile(
                    leading:
                    Image.asset(
                      "assets/images/qianbao.png",
                      width: 18,
                      height: 20,
                    ),//pym_
                    contentPadding: const EdgeInsets.only(right: 20),
                    title: Transform(
                      transform: Matrix4.translationValues(19, 0.0, 0.0),
                      child: Text('钱包'.tr,
                          style: const TextStyle(fontSize: 15, color: Color(0xff2b2b2b), fontWeight: FontWeight.w400)),
                    )
                    // Text('钱包'.tr,style: const TextStyle(fontSize: 15,fontWeight: FontWeight.w400,color: Color(0xff2b2b2b)),),
                  )),

              GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    Get.to(exchangelistPage());
                  },
                  child: ListTile(
                      leading:
                      SvgPicture.asset(
                        "assets/svg/jiangpinduihuan.svg",
                        width: 20,
                        height: 20,
                      ),//pym_
                      contentPadding: const EdgeInsets.only(right: 20),
                      title: Transform(
                        transform: Matrix4.translationValues(19, 0.0, 0.0),
                        child: Text('奖品兑换'.tr,
                            style: const TextStyle(fontSize: 15, color: Color(0xff2b2b2b), fontWeight: FontWeight.w400)),
                      )
                    // Text('钱包'.tr,style: const TextStyle(fontSize: 15,fontWeight: FontWeight.w400,color: Color(0xff2b2b2b)),),
                  )),
              ///邀请码
              ///任务
              GestureDetector(
                  onTap: () {
                    userLogic.Personallevel();
                    // Navigator.pop(context);
                    Navigator.pop(context);
                    Get.to(TaskCenterPage());
                  },
                  child: ListTile(
                    leading: SvgPicture.asset(
                      "assets/svg/renwu.svg",
                      width: 20,
                      height: 20,
                    ),
                    contentPadding: const EdgeInsets.only(right: 20),
                    title: Transform(
                      transform: Matrix4.translationValues(19, 0.0, 0.0),
                      child: Text('任务'.tr,
                          style: const TextStyle(fontSize: 15, color: Color(0xff2b2b2b), fontWeight: FontWeight.w400)),
                    )
                    // Text('任务'.tr,style: const TextStyle(fontSize: 15,fontWeight: FontWeight.w400,color: Color(0xff2b2b2b)),),
                  )),
              ///隐私设置
              // GestureDetector(
              //     onTap: () {
              //       Navigator.pop(context);
              //     },
              //     child: ListTile(
              //       leading: SvgPicture.asset(
              //         "assets/svg/yinsi.svg",
              //         width: 20,
              //         height: 20,
              //       ),
              //       contentPadding: const EdgeInsets.only(right: 20),
              //       title: Transform(
              //         transform: Matrix4.translationValues(19, 0.0, 0.0),
              //         child: Text('隐私设置'.tr,
              //             style: TextStyle(fontSize: 15, color: Color(0xff2b2b2b), fontWeight: FontWeight.w400)),
              //       )
              //       // Text('隐私设置'.tr,style: const TextStyle(fontSize: 15,fontWeight: FontWeight.w400,color: Color(0xff2b2b2b)),),
              //     )),
              ///填写邀请码
              GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    Get.toNamed('/verify/InvitationCode');
                  },
                  child: ListTile(
                    leading: SvgPicture.asset(
                      "assets/svg/yaoqing.svg",
                      width: 20,
                      height: 20,
                    ),
                    contentPadding: const EdgeInsets.only(right: 20),
                    title: Transform(
                      transform: Matrix4.translationValues(19, 0.0, 0.0),
                      child: Text('填写邀请码'.tr,
                          style: const TextStyle(fontSize: 15, color: Color(0xff2b2b2b), fontWeight: FontWeight.w400)),
                    )
                  )),
              const Divider(height: 1.0,color:  Color(0xFFF1F1F1),indent: 20,endIndent: 20,),
              ///关于我们
              GestureDetector(
                  onTap: () {
                    // Navigator.pop(context);
                    Get.to(AccountSecurityWidget());
                  },
                  child: ListTile(
                    leading: SvgPicture.asset(
                      "assets/svg/aboutus.svg",
                      width: 20,
                      height: 20,
                    ),
                    contentPadding: const EdgeInsets.only(right: 20),
                    title: Transform(
                      transform: Matrix4.translationValues(19, 0.0, 0.0),
                      child: Text('关于我们'.tr,
                          style: const TextStyle(fontSize: 15, color: Color(0xff2b2b2b), fontWeight: FontWeight.w400)),
                    )
                    // Text('关于我们'.tr,style: const TextStyle(fontSize: 15,fontWeight: FontWeight.w400,color: Color(0xff2b2b2b)),),
                  )),
              ///鼓励一下
              GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    if (Platform.isAndroid) {
                      _launchUniversalLinkIos(Uri.parse("market://details?id=lanla.app"));
                    } else if (Platform.isIOS) {
                      _launchUniversalLinkIos(Uri.parse("itms-apps://apps.apple.com/tr/app/times-tables-lets-learn/id6443484359?l=tr"));
                    }
                  },
                  child: ListTile(
                    leading: SvgPicture.asset(
                      "assets/svg/guli.svg",
                      width: 20,
                      height: 20,
                    ),
                    contentPadding: const EdgeInsets.only(right: 20),
                    title: Transform(
                      transform: Matrix4.translationValues(19, 0.0, 0.0),
                      child: Text('鼓励一下'.tr,
                          style: const TextStyle(fontSize: 15, color: Color(0xff2b2b2b), fontWeight: FontWeight.w400)),
                    )
                    // Text('鼓励一下'.tr,style: const TextStyle(fontSize: 15,fontWeight: FontWeight.w400,color: Color(0xff2b2b2b)),),
                  )),
              ///意见反馈
              GestureDetector(
                  onTap: () {
                    // Navigator.pop(context);
                    Get.to(AboutusWidget());
                  },
                  child: ListTile(
                    leading: SvgPicture.asset(
                      "assets/svg/fankui.svg",
                      width: 20,
                      height: 20,
                    ),
                    contentPadding: const EdgeInsets.only(right: 20),
                    title: Transform(
                      transform: Matrix4.translationValues(19, 0.0, 0.0),
                      child: Text('意见反馈'.tr,
                          style: const TextStyle(fontSize: 15, color: Color(0xff2b2b2b), fontWeight: FontWeight.w400)),
                    )
                    // Text('意见反馈'.tr,style: const TextStyle(fontSize: 15,fontWeight: FontWeight.w400,color: Color(0xff2b2b2b)),),
                  )),
              ///清理缓存
              GestureDetector(
                  onTap: () {
                    // Navigator.pop(context);
                    Toast.toast(context,msg: "清除成功".tr,position: ToastPostion.center);
                  },
                  child: ListTile(
                    leading: SvgPicture.asset(
                      "assets/svg/clear.svg",
                      width: 20,
                      height: 20,
                    ),
                    contentPadding: const EdgeInsets.only(right: 20),
                    title: Transform(
                      transform: Matrix4.translationValues(19, 0.0, 0.0),
                      child: Text('清理缓存'.tr,
                          style: const TextStyle(fontSize: 15, color: Color(0xff2b2b2b), fontWeight: FontWeight.w400)),
                    )
                    // Text('清理缓存'.tr,style: const TextStyle(fontSize: 15,fontWeight: FontWeight.w400,color: Color(0xff2b2b2b)),),
                  )),
              const Divider(height: 1.0,color:  Color(0xFFF1F1F1),indent: 20,endIndent: 20,),
              /*
              ///填写邀请码
              GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    Get.toNamed('/verify/InvitationCode');
                  },
                  child: ListTile(
                    leading: SvgPicture.asset(
                      "assets/svg/yaoqing.svg",
                      width: 20,
                      height: 20,
                    ),
                    title: Text('填写邀请码'.tr),
                  )),
              ///评价一下
              GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    if (Platform.isAndroid) {
                      _launchUniversalLinkIos(Uri.parse("market://details?id=lanla.app"));
                    } else if (Platform.isIOS) {
                      _launchUniversalLinkIos(Uri.parse("itms-apps://apps.apple.com/tr/app/times-tables-lets-learn/id6443484359?l=tr"));
                    }
                  },
                  child: ListTile(
                    leading: SvgPicture.asset(
                      "assets/svg/pingjia.svg",
                      width: 20,
                      height: 20,
                    ),
                    title: Text('评价一下'.tr),
                  )),
              */
              ///退出登录
              GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    userLogic.logout();
                    WebSocketes.channel.sink.close();
                    //userLogic.Chatdisconnected=false;
                    Get.find<HomeLogic>().setNowPage(0);
                  },
                  child: ListTile(
                    leading: SvgPicture.asset(
                      "assets/svg/tuichu.svg",
                      width: 20,
                      height: 20,
                    ),
                      contentPadding: const EdgeInsets.only(right: 20),
                      title: Transform(
                        transform: Matrix4.translationValues(19, 0.0, 0.0),
                        child: Text('退出登录'.tr,
                            style: const TextStyle(fontSize: 15, color: Color(0xff2b2b2b), fontWeight: FontWeight.w400)),
                      )
                    // contentPadding: const EdgeInsets.only(right: 20),
                    // title: Text('退出登录'.tr,style: const TextStyle(fontSize: 15,fontWeight: FontWeight.w400,color: Color(0xff2b2b2b)),),
                  )),
            ],
          ),
        ),
      ),
      // extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/mytopBg.png"), // 设置背景图片路径
              fit: BoxFit.cover, // 填充方式
            ),
          ),
        ),
        leading:
        // GestureDetector(
        //     onTap: () {
        //       AppLog('share',event: 'me',targetid: userLogic.userId);
        //       Get.put<ContentProvider>(ContentProvider()).ForWard(userLogic.userId,3);
        //       Share.share('https://api.lanla.app/share?u=' +
        //           userLogic.userId.toString());
        //     },
        //     child: Container(
        //       margin: const EdgeInsets.all(17),
        //       child: Image.asset(
        //         'assets/images/fenxiang.png',
        //       ),
        //     ),
        //   ),
        GestureDetector(
          onTap: () {
            _scaffoldkey.currentState?.openDrawer();
          },
          child: Container(
            margin: const EdgeInsets.all(15),
            child: Image.asset('assets/images/drawer.png',
              fit: BoxFit.cover,width: 18,height: 14,),
          ),
        ),
        actions: [
          GestureDetector(
              onTap: () {
                //Get.to(SearchPage());
                if(userLogic.token!=''){
                  if(!userLogic.Chatdisconnected){
                    WebSocketes.WebSocketconnection();
                  }
                  Get.toNamed('/public/message');
                }else{
                  Get.toNamed('/public/loginmethod');
                }
              },
              child: GetBuilder<UserLogic>(builder: (logic) {
                return Container(
                  margin: const EdgeInsets.fromLTRB(16,0,0,6),
                  child: Stack(clipBehavior: Clip.none, children: [
                    if(userLogic.Chatrelated['${userLogic.userId}']!=null)
                      if(userLogic.NumberMessages+userLogic.Chatrelated['${userLogic.userId}']['Unreadmessagezs']>0)Positioned(
                        top: -18 / 2,
                        right: -22 / 2,
                        child: Container(
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(50)),
                              color: Colors.red
                          ),
                          width: 16,
                          height: 16,
                          child: Text(userLogic.NumberMessages+userLogic.Chatrelated['${userLogic.userId}']['Unreadmessagezs']>99?'99':'${userLogic.NumberMessages+userLogic.Chatrelated['${userLogic.userId}']['Unreadmessagezs']}',
                            style: const TextStyle(color: Colors.white,
                                fontSize: 8,
                                height: 1.0),),
                        ),
                      ),
                    if(userLogic.Chatrelated['${userLogic.userId}']==null)
                      if(userLogic.NumberMessages>0)Positioned(
                        top: -18 / 2,
                        right: -22 / 2,
                        child: Container(
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(50)),
                              color: Colors.red
                          ),
                          width: 16,
                          height: 16,
                          child: Text(userLogic.NumberMessages.toString(),
                            style: const TextStyle(color: Colors.white,
                                fontSize: 8,
                                height: 1.0),),
                        ),
                      ),
                    SvgPicture.asset(
                      'assets/icons/lingdang.svg', width: 22, height: 22,),
                  ]),

                  //
                );
              })

          ),
        ],
      ),

      body: NestedScrollView(
          headerSliverBuilder: (contex, _) {
            return [
              //sliver
              SliverToBoxAdapter(
                child:
                Container(
                  height: 220,
                  width: double.maxFinite,
                  decoration: const BoxDecoration(color: Color(0xffffffff),),
                  child: Column(
                    children: [
                      // Divider(height: .1,color: Color(0x19000000),),
                      _userInfoWidget(context)
                    ],
                  ),
                ),
              ),
            ];
          },
          body: Stack(
            children: [
              // 背景图
              Container(
                  child: _contentWidget(),
                  decoration: const BoxDecoration(
                    color:  Color(0xffffffff),
                    // border: Border.all(color: Color(0xffF1F1F1),width: 1),
                    //设置四周圆角 角度
                    // borderRadius: BorderRadius.only(
                    //   topLeft: Radius.circular(10),
                    //   topRight: Radius.circular(10),
                    // ),
                    // )
                  )),
            ],
          )),

    );
  }
  Future<void> _launchUniversalLinkIos(Uri url) async {
    //启动APP 功能。可以带参数，如果启动原生的app 失败
    final bool nativeAppLaunchSucceeded = await launchUrl(
      url,
      //mode: LaunchMode.externalNonBrowserApplication,
    );
    //启动失败的话就使用应用内的webview 打开
    if (!nativeAppLaunchSucceeded) {
      await launchUrl(
        url,
        //mode: LaunchMode.inAppWebView,
      );
    }
  }

  // 用户信息组件
  _userInfoWidget(context) {
    return GetBuilder<UserLogic>(builder: (userLogic) {
      return Container(
        padding: const EdgeInsets.only(
            left: 20, right: 20,top: 25),
        child: Column(
          crossAxisAlignment:CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GestureDetector(child:Container(
                  width: 75,
                  height: 75,
                  //超出部分，可裁剪
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: userLogic.userAvatar,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Image.asset('assets/images/zhanweitufont.png',fit: BoxFit.cover,),
                  )
                ) ,onTap: (){

                },),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 10,right: 15),
                    height: 80,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment:MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                            children: [
                              Text(
                                userLogic.userInfo?.userName.toString() ?? '-',
                                style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600),
                              ),
                            ]),
                        Row(
                            children: [
                              ///认证
                              if(userLogic.userInfo!=null&&userLogic.userInfo!.labelHighQualityAuthor.icon!='')Container(padding: const EdgeInsets.fromLTRB(10, 2, 10, 2),decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(26)),color: Color.fromRGBO(245, 255, 210, 1)),child: Row(children: [
                                Image.network(userLogic.userInfo!.labelHighQualityAuthor.icon,width: 13,height: 13,),
                                const SizedBox(width: 5,),
                                Text(userLogic.userInfo!.labelHighQualityAuthor.desc,style: const TextStyle(fontSize: 10,fontWeight: FontWeight.w700,height: 1,color:Color.fromRGBO(52, 199, 0, 1)),)
                              ],),),
                              if(userLogic.userInfo!=null&&userLogic.userInfo!.labelFamousUser.icon!='')Container(padding: const EdgeInsets.fromLTRB(10, 2, 10, 2),decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(26)),color: Color.fromRGBO(255, 251, 210, 1)),child: Row(children: [
                                Image.network(userLogic.userInfo!.labelFamousUser.icon,width: 13,height: 13,),
                                const SizedBox(width: 5,),
                                Text(userLogic.userInfo!.labelFamousUser.desc,style: const TextStyle(fontSize: 10,fontWeight: FontWeight.w700,height: 1,color: Color.fromRGBO(255, 139, 48, 1)),)
                              ],),),
                              if(userLogic.userInfo!=null&&(userLogic.userInfo!.labelHighQualityAuthor.icon!='' || userLogic.userInfo!.labelHighQualityAuthor.icon!=''))const SizedBox(width: 10,),
                              ///等级
                              if(userLogic.userInfo?.level == 1)Container(alignment: Alignment.center,width: 40,height: 18,decoration:const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)),color: Color(0xfff5f5f5)),child: Row(mainAxisAlignment:MainAxisAlignment.center,
                                children: const [
                                  // Image.asset('assets/images/lv1.png',width: 12,height: 12,),SizedBox(width: 4,),
                                  Text('1',style: TextStyle(fontSize: 10,fontWeight: FontWeight.w700,fontFamily: 'Baloo Bhai 2',color: Color(0xffd9d9d9)),),Text('Lv',style: TextStyle(fontSize: 10,fontWeight: FontWeight.w700,fontFamily: 'Baloo Bhai 2',color: Color(0xffd9d9d9)),)],

                              ),),
                              if(userLogic.userInfo?.level == 2)Container(alignment: Alignment.center,width: 40,height: 18,decoration:const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)),color: Color(0xfff5f5f5)),child: Row(mainAxisAlignment:MainAxisAlignment.center,
                                children: const [
                                  // Image.asset('assets/images/lv2.png',width: 12,height: 12,),SizedBox(width: 4,),
                                  Text('2',style: TextStyle(fontSize: 10,fontWeight: FontWeight.w700,fontFamily: 'Baloo Bhai 2',color: Color(0xffd9d9d9)),),Text('Lv',style: TextStyle(fontSize: 10,fontWeight: FontWeight.w700,fontFamily: 'Baloo Bhai 2',color: Color(0xffd9d9d9)),)],

                              ),),
                              if(userLogic.userInfo?.level == 3)Container(alignment: Alignment.center,width: 40,height: 18,decoration:const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)),color: Color(0xfff5f5f5)),child: Row(mainAxisAlignment:MainAxisAlignment.center,
                                children: const [
                                  // Image.asset('assets/images/lv3.png',width: 12,height: 12,),SizedBox(width: 4,),
                                  Text('3',style: TextStyle(fontSize: 10,fontWeight: FontWeight.w700,fontFamily: 'Baloo Bhai 2',color: Color(0xffd9d9d9)),),Text('Lv',style: TextStyle(fontSize: 10,fontWeight: FontWeight.w700,fontFamily: 'Baloo Bhai 2',color: Color(0xffd9d9d9)),)],

                              ),),
                              if(userLogic.userInfo?.level == 4)Container(alignment: Alignment.center,width: 40,height: 18,decoration:const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)),color: Color(0xfff5f5f5)),child: Row(mainAxisAlignment:MainAxisAlignment.center,
                                children: const [
                                  // Image.asset('assets/images/lv4.png',width: 12,height: 12,),SizedBox(width: 4,),
                                  Text('4',style: TextStyle(fontSize: 10,fontWeight: FontWeight.w700,fontFamily: 'Baloo Bhai 2',color: Color(0xffd9d9d9)),),Text('Lv',style: TextStyle(fontSize: 10,fontWeight: FontWeight.w700,fontFamily: 'Baloo Bhai 2',color: Color(0xffd9d9d9)),)],
                              ),),
                              if(userLogic.userInfo?.level == 5)Container(alignment: Alignment.center,width: 40,height: 18,decoration:const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)),color: Color(0xfff5f5f5)),child: Row(mainAxisAlignment:MainAxisAlignment.center,
                                children: const [
                                  // Image.asset('assets/images/lv5.png',width: 12,height: 12,),SizedBox(width: 4,),
                                  Text('5',style: TextStyle(fontSize: 10,fontWeight: FontWeight.w700,fontFamily: 'Baloo Bhai 2',color: Color(0xffd9d9d9)),),Text('Lv',style: TextStyle(fontSize: 10,fontWeight: FontWeight.w700,fontFamily: 'Baloo Bhai 2',color: Color(0xffd9d9d9)),)],

                              ),),
                              ///性别
                              // userLogic.userInfo?.sex != 0
                              //     ? Container(
                              //   margin: EdgeInsets.only(right: 5),
                              //   alignment: Alignment.center,
                              //   decoration: BoxDecoration(color: Color(0xffF5F5F5),borderRadius: BorderRadius.all(Radius.circular(26))),
                              //   width: 27,height: 18,
                              //   child: userLogic.userInfo?.sex == 1
                              //       ? Image.asset('assets/images/nanIcon.png',width: 12.0,
                              //       height: 12.0) : Image.asset('assets/images/nvIcon.png',width: 12.0,
                              //       height: 12.0),)
                              //     : Container()

                            ]),



                        Text(
                          maxLines: 2,
                          userLogic.userInfo?.slogan.toString() == '' ? '快来填写你的个人简介吧'.tr:userLogic.userInfo?.slogan.toString() ?? '',
                          style: const TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontSize: 13,
                            color: Color(0xff666666),
                            height:1.4,
                          ),

                        ),
                        /*
                        Row(
                          children: [
                            GestureDetector(child: Container(
                              padding:EdgeInsets.fromLTRB(13, 5, 13, 5),
                              decoration: BoxDecoration(
                                border: Border.all(width: 0.3,color: Color(0xff000000)),
                                borderRadius: BorderRadius.circular(28),
                              ),
                              child: Image.asset('assets/images/xiugai.png',width: 17.0,
                                  height: 17.0),
                            ),onTap: (){
                              // Navigator.pop(context);
                              Get.toNamed('/verify/userUpdateInfo');
                            },) ,
                            GestureDetector(child:Container(
                              margin: EdgeInsets.only(right: 15),
                              decoration: BoxDecoration(
                                border: Border.all(width: 0.3,color: Color(0xff000000)),
                                borderRadius: BorderRadius.circular(28),
                              ),
                              padding:EdgeInsets.fromLTRB(13, 5, 13, 5),
                              child:Image.asset('assets/images/set.png',width: 17.0,
                                  height: 17.0),
                            ) ,onTap:(){
                              // Navigator.pop(context);
                              //Get.toNamed('/verify/InvitationCode');
                              Get.toNamed('/verify/Appsetup');
                            },),

                          ],
                        )

                         */
                        // Text(
                        //   maxLines: 2,
                        //   userLogic.userInfo?.slogan.toString() ?? '-',
                        //   style: TextStyle(
                        //       overflow: TextOverflow.ellipsis,
                        //       fontSize: 10,
                        //       color: Colors.white,
                        //       fontWeight: FontWeight.w600),
                        // ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 25,),
            // 下面展示位
            Container(
              decoration: BoxDecoration(
                  color:const Color(0xffffffff),
                  // border: Border.all(color: Color.fromRGBO(0, 0, 0, 0.05),width: 1),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: const [
                    BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.05),
                        //color:Colors.black,
                        offset: Offset(0.0, 0.0), //阴影xy轴偏移量
                        blurRadius: 1, //阴影模糊程度
                        spreadRadius: 1 //阴影扩散程度
                    )
                  ]
              ),
              padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(child: Container(width: 80,child: Column(
                    children: [
                      Text(userLogic.userInfo?.concern.toString() ?? '0',style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        //fontFamily: 'PingFang SC',
                      ),),
                      const SizedBox(height: 5,),
                      Text('关注'.tr,style: const TextStyle(
                        fontSize: 12,
                        color: Color(0XFF999999),
                        //fontFamily: 'PingFang SC',
                      ),)
                    ],
                  ),color: Colors.white,),onTap: (){
                    Get.to(MyfollowPage(),
                        //transition: Transition.leftToRight,
                        arguments:userLogic.userId);
                  },),

                  const SizedBox(
                    width: 1,
                    height: 20,
                    child: DecoratedBox(
                      decoration: BoxDecoration(color: Color(0x16000000)),
                    ),
                  ),
                  GestureDetector(child: Container(width: 80,color: Colors.white,child: Column(
                    children: [
                      Text(userLogic.userInfo?.fans.toString() ?? '0',style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        //fontFamily: 'PingFang SC',
                      ),),
                      const SizedBox(height: 5,),
                      Text('粉丝'.tr,style: const TextStyle(
                        fontSize: 12,
                        color: Color(0XFF999999),
                        //fontFamily: 'PingFang SC',
                      ),)
                    ],
                  ),)
                  ,onTap: (){
                    Get.to(MyfansPage(),
                        //transition: Transition.leftToRight,
                        arguments:userLogic.userId);
                  },),
                  const SizedBox(
                    width: 1,
                    height: 20,
                    child: DecoratedBox(
                      decoration: BoxDecoration(color: Color(0x16000000)),
                    ),
                  ),
                  GestureDetector(child: Container(width: 110,color: Colors.white,child:Column(
                    children: [
                      Text(((userLogic.userInfo?.getLike ?? 0) + (userLogic.userInfo?.getCollect ?? 0)).toString() ?? '0',style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        //fontFamily: 'PingFang SC',
                      ),),
                      const SizedBox(height: 5,),
                      Text('获赞和收藏'.tr,style: const TextStyle(
                        fontSize: 12,
                        color: Color(0XFF999999),
                        //fontFamily: 'PingFang SC',
                      ),)
                    ],
                  ) ,)
                    ,onTap: (){
                      _showMyDialog(context);
                    },),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  _infoTag(name, number) {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      child: Column(
        children: [
          Text(
            number.toString(),
            style: const TextStyle(
                color: Colors.white, fontSize: 13, fontWeight: FontWeight.w900),
          ),
          Text(
            name,
            style: const TextStyle(color: Colors.white, fontSize: 13),
          ),
        ],
      ),
    );
  }

  _contentWidget() {
    return Column(
      children: [
        GetBuilder<PublishDataLogic>(builder: (logic) {
          return logic.isBeingPublished ? _uploading(logic) : Container();
        }),
        _tabBar(),
      ],
    );
  }

  /**
   * 上传中组件
   */
  _uploading(PublishDataLogic logic) {
    return Container(
      height: 80,
      child: Column(
        children: [
          Container(
            height: 75,
            alignment: Alignment.center,
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Stack(children: [
                  Container(
                    width: 55,
                    height: 55,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          File(logic.thumbnailPath),
                          fit: BoxFit.cover,
                        )),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black12),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  Container(
                    width: 55,
                    height: 55,
                    decoration: BoxDecoration(
                      color: Colors.black12.withOpacity(0.4),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  // Positioned(
                  //   top: 16,
                  //   left: 14,
                  //     child: Text('${(logic.progress * 100).toStringAsFixed(0)}%',
                  //         style: TextStyle(fontSize: 16,
                  //       color: Colors.white))),
                  Container(
                    child:
                    Text('${(logic.progress * 100).toStringAsFixed(0)}%',
                        style: const TextStyle(fontSize: 16,
                            color: Colors.white)),
                    width: 55,
                    height: 55,
                    // color: Colors.black12.withOpacity(0.6),
                    alignment: Alignment.center,
                  ),
                ],),
                Container(
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '笔记正在上传，请不要关闭app'.tr,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      Text('上传提示'.tr)
                    ],
                  ),
                )
              ],
            ),
          ),
          LinearProgressIndicator(
            value: logic.progress,
            backgroundColor: Colors.black12,
            valueColor: const AlwaysStoppedAnimation(Colors.green),
          )
        ],
      ),
    );
  }

  _tabBar() {
    return Expanded(
      child: UserTabView(),
    );
  }

  Future<void> _showMyDialog(context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {

        return AlertDialog(
          backgroundColor: Colors.white,
          elevation: 0,
          contentPadding:const EdgeInsets.fromLTRB(0, 0, 0, 0),
          shape:const RoundedRectangleBorder(borderRadius:BorderRadius.all(Radius.circular(20))),
          content: StatefulBuilder(

            builder: (BuildContext context, StateSetter setState) {
              return Container(
                //decoration: BoxDecoration(border: Border.all(width: 1,color: Colors.red)),
                height: 340,
                child: Column(
                  children: [
                    Container(
                      height: 66,

                      // padding: EdgeInsets.symmetric(vertical: 25, horizontal: 0),
                      alignment: const Alignment(0,0),
                      child: Text('赞和收藏'.tr),
                    ),
                    // Divider(height: 1.0,color: Color(0xffe4e4e4),),
                    Container(
                      margin: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                      //decoration: BoxDecoration(border: Border.all(width: 1,color: Colors.red)),
                      // padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                      child: Row(
                        mainAxisAlignment:MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.asset('assets/images/xiaoxi.png',width: 30,height: 30,),
                              const SizedBox(width: 10,),
                              Text('发布作品数'.tr,style: const TextStyle(fontSize: 15,color: Color(0xff999999)),)
                            ],
                          ),
                          Text(userLogic.userInfo?.works.toString() ?? 0.toString())
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                      //decoration: BoxDecoration(border: Border.all(width: 1,color: Colors.red)),
                      // padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                      child: Row(
                        mainAxisAlignment:MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.asset('assets/images/dianzan.png',width: 30,height: 30,),
                              const SizedBox(width: 10,),
                              Text('获得点赞数'.tr,style: const TextStyle(fontSize: 15,color: Color(0xff999999)),)
                            ],
                          ),
                          Text(userLogic.userInfo?.getLike.toString() ?? 0.toString())
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                      //decoration: BoxDecoration(border: Border.all(width: 1,color: Colors.red)),
                      // padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                      child: Row(
                        mainAxisAlignment:MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.asset('assets/images/shoucang.png',width: 30,height: 30,),
                              const SizedBox(width: 10,),
                              Text('获得收藏数'.tr,style: const TextStyle(fontSize: 15,color: Color(0xff999999)),)
                            ],
                          ),
                          Text(userLogic.userInfo?.getCollect.toString() ?? 0.toString())
                        ],
                      ),
                    ),
                    const SizedBox(height: 40,),
                    GestureDetector(child:Container(
                      decoration: BoxDecoration(
                        color:  Colors.black,
                        borderRadius: BorderRadius.circular(65),
                      ),
                      padding: const EdgeInsets.fromLTRB(40, 15, 40, 15),
                      child: Text("我知道了".tr,style: const TextStyle(color: Colors.white,fontWeight: FontWeight.w600),),
                    ) ,onTap: (){
                      Navigator.pop(context);
                    },)

                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  //查看大图

  Widget _buildPhotoView(img) {
    var _galleryItems = [
      'assets/images/icon_avatar_staff.png',
      'assets/images/icon_avatar_staff.png',
      'assets/images/icon_avatar_staff.png'
    ];
    return PhotoViewGallery.builder(
      scrollPhysics: const BouncingScrollPhysics(),
      builder: (BuildContext context, int index) {
        return PhotoViewGalleryPageOptions.customChild(
          child: Image(
            image: AssetImage(img),
          ),
          initialScale: PhotoViewComputedScale.contained * 0.9,
        );
      },
      itemCount: 1,
      backgroundDecoration: const BoxDecoration(color: Colors.white),
      // pageController: PageController(initialPage: _currentPageIndex),
      // onPageChanged: (i) {
      //   _currentPageIndex = i;
      //   _valueNotifier.notifyListeners();
      // },
    );
  }

}
