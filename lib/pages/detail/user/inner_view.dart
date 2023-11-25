import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lanla_flutter/common/controller/UserLogic.dart';
import 'package:lanla_flutter/common/widgets/report.dart';
import 'package:lanla_flutter/common/widgets/round_underline_tabindicator.dart';
import 'package:lanla_flutter/models/UserInfo.dart';
import 'package:lanla_flutter/models/location.dart';
import 'package:lanla_flutter/models/topic.dart';
import 'package:lanla_flutter/pages/home/start/detail_view/loading_widget.dart';
import 'package:lanla_flutter/pages/home/start/detail_view/logic.dart';
import 'package:lanla_flutter/pages/home/start/detail_view/no_data_widget.dart';
import 'package:lanla_flutter/pages/home/start/detail_view/view.dart';
import 'package:lanla_flutter/services/user.dart';
import 'package:lanla_flutter/ulits/event.dart';
import 'package:lanla_flutter/ulits/toast.dart';
import 'package:lanla_flutter/pages/home/message/Chatpage/view.dart';
import '../../../ulits/hex_color.dart';
import '../../home/me/myfans/view.dart';
import '../../home/me/myfollow/view.dart';

/// 用户详情页
/// 用于视频和图片水平滑动时(PageView)进入的页面
class UserInnerView extends StatefulWidget {
  @override
  late int userId;

  UserInnerView(this.userId, {super.key});

  _UserInnerViewState createState() => _UserInnerViewState();
}

class _UserInnerViewState extends State<UserInnerView>
    with TickerProviderStateMixin {
  UserInfoMode? userInfo;
  UserProvider userProvider = Get.put<UserProvider>(UserProvider());
  final userController = Get.find<UserLogic>();
  final WebSocketes = Get.find<StartDetailLogic>();
  late TabController tabController;
  var note = 1;
  bool oneData = false;
  var labellist = [];
  var FavoriteLocation = [];

  @override
  void initState() {
    _initUserInfo();
    topiclist();
    tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  _initUserInfo() async {
    userInfo = await userProvider.getUserInfo(widget.userId);
    FirebaseAnalytics.instance.logEvent(
      name: "user_view",
      parameters: {
        "id": widget.userId
      },
    );
    if (userInfo == null) {
      ToastInfo('用户不存在'.tr);
    }
    setState(() {});
  }

  Future<void> topiclist() async {
    var result = await userProvider.conversation(widget.userId);
    setState(() {
      oneData = true;
      labellist = topicModelFromJson(result?.bodyString ?? "");
    });
  }

  ///收藏地点
  Future<void> Collectionlocation() async {
    var result = await userProvider.location(widget.userId);
    setState(() {
      oneData = true;
      FavoriteLocation = LocationFromJson(result?.bodyString ?? "");
    });
  }

  // 关注
  _onTapFocus() async {
    EasyLoading.show(status: 'loading...',maskType: EasyLoadingMaskType.black);
    Response res = await userProvider.setFollow(widget.userId);
    if (res.statusCode != 200 || res.bodyString == '') {
      ToastInfo("操作失败".tr);
    }
     userController.modifyFollow(widget.userId);
     _initUserInfo();
    // userController.setFollow(widget.userId);
    EasyLoading.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          GestureDetector(
            onTap: () {

              if (!userController.checkUserLogin()) {
                Get.toNamed('/public/loginmethod');
                return;
              }
              ReportDoglog(ReportType.user, widget.userId,0,'',  context,removeCallbak: () {
                _initUserInfo();
                eventBus.fire(UploadContentListEvent());
              });
            },
            child: Padding(
              padding: EdgeInsets.only(left: 15, right: 15),
              child: Icon(Icons.more_vert),
            ),
          ),
        ],
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: SvgPicture.asset(
            "assets/icons/fanhui.svg",
            width: 22,
            height: 22,
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/mytopBg.png"), // 设置背景图片路径
              fit: BoxFit.cover, // 填充方式
            ),
          ),
        ),
      ),
      body: NestedScrollView(
            headerSliverBuilder: (contex, _) {
              return [
                //sliver
                SliverToBoxAdapter(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(20, 25, 20, 20),
                    color: Colors.white,
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(right: 0),
                              child: Stack(children: [
                                CachedNetworkImage(
                                  width: 80,
                                  height: 80,
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(40),
                                          border: Border.all(color: Color(0xffF9F9F9), width: 1),
                                          image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                  placeholder: (context, url) =>
                                      Image.asset('assets/images/txzhanwei.png',fit: BoxFit.cover,),
                                  errorWidget: (context, url, error) =>
                                      Image.asset('assets/images/txzhanwei.png',fit: BoxFit.cover,),
                                  imageUrl: userInfo?.avatar ??
                                      'assets/images/txzhanwei.png',fit: BoxFit.cover,
                                ),
                                // CachedNetworkImage(
                                //   width: 80,
                                //   height: 80,
                                //   imageUrl: userInfo?.avatar ?? "",
                                //   placeholder: (context, url) => Image.asset('assets/images/txzhanwei.png'),
                                //   imageBuilder: (context, imageProvider) => Container(
                                //     decoration: BoxDecoration(
                                //       borderRadius: BorderRadius.circular(40),
                                //       image: DecorationImage(
                                //         image: imageProvider,
                                //         fit: BoxFit.cover,
                                //       ),
                                //     ),
                                //   ),
                                // ),
                                if(userInfo?.authImage!=null&&userInfo?.authImage!='')Positioned(child: Image.network(userInfo!.authImage,width: 23,height: 23,),bottom: 0,right: 0,)
                              ],),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                      padding:
                                      const EdgeInsets.only(bottom: 12),
                                      child: Row(children: [
                                        Text(
                                          userInfo?.userName ?? '...',
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ])),

                                 Row(children: [
                                    ///认证
                                    if(userInfo != null&&userInfo!.labelHighQualityAuthor.icon!='')Container(padding: EdgeInsets.fromLTRB(10, 2, 10, 2),decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(26)),color: Color.fromRGBO(245, 255, 210, 1)),child: Row(children: [
                                      Image.network(userInfo!.labelHighQualityAuthor.icon,width: 13,height: 13,),
                                      SizedBox(width: 5,),
                                      Text(userInfo!.labelHighQualityAuthor.desc,style: TextStyle(fontSize: 10,fontWeight: FontWeight.w700,height: 1,color:Color.fromRGBO(52, 199, 0, 1)),)
                                    ],),),
                                    if(userInfo != null&&userInfo!.labelFamousUser.icon!='')Container(padding: EdgeInsets.fromLTRB(10, 2, 10, 2),decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(26)),color: Color.fromRGBO(255, 251, 210, 1)),child: Row(children: [
                                      Image.network(userInfo!.labelFamousUser.icon,width: 13,height: 13,),
                                      SizedBox(width: 5,),
                                      Text(userInfo!.labelFamousUser.desc,style: TextStyle(fontSize: 10,fontWeight: FontWeight.w700,height: 1,color: Color.fromRGBO(255, 139, 48, 1)),)
                                    ],),),
                                    if(userInfo != null&&(userInfo!.labelHighQualityAuthor.icon!='' || userInfo!.labelHighQualityAuthor.icon!=''))SizedBox(width: 10,),
                                    ///等级
                                    if(userInfo?.level == 1)Container(alignment: Alignment.center,width: 40,height: 18,decoration:BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)),color: Color(0xfff5f5f5)),child: Row(mainAxisAlignment:MainAxisAlignment.center,
                                      children: [
                                        // Image.asset('assets/images/lv1.png',width: 10,height: 10,),SizedBox(width: 4,),
                                        Text('1',style: TextStyle(fontSize: 10,fontWeight: FontWeight.w700,fontFamily: 'Baloo Bhai 2',color: Color(0xffd9d9d9)),),Text('Lv',style: TextStyle(fontSize: 10,fontWeight: FontWeight.w700,fontFamily: 'Baloo Bhai 2',color: Color(0xffd9d9d9)),)],

                                    ),),
                                    if(userInfo?.level == 2)Container(alignment: Alignment.center,width: 40,height: 18,decoration:BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)),color: Color(0xfff5f5f5)),child: Row(mainAxisAlignment:MainAxisAlignment.center,
                                      children: [
                                        // Image.asset('assets/images/lv2.png',width: 10,height: 10,),SizedBox(width: 4,),
                                        Text('2',style: TextStyle(fontSize: 10,fontWeight: FontWeight.w700,fontFamily: 'Baloo Bhai 2',color: Color(0xffd9d9d9)),),Text('Lv',style: TextStyle(fontSize: 10,fontWeight: FontWeight.w700,fontFamily: 'Baloo Bhai 2',color: Color(0xffd9d9d9)),)],

                                    ),),
                                    if(userInfo?.level == 3)Container(alignment: Alignment.center,width: 40,height: 18,decoration:BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)),color: Color(0xfff5f5f5)),child: Row(mainAxisAlignment:MainAxisAlignment.center,
                                      children: [
                                        // Image.asset('assets/images/lv3.png',width: 10,height: 10,),SizedBox(width: 4,),
                                        Text('3',style: TextStyle(fontSize: 10,fontWeight: FontWeight.w700,fontFamily: 'Baloo Bhai 2',color: Color(0xffd9d9d9)),),Text('Lv',style: TextStyle(fontSize: 10,fontWeight: FontWeight.w700,fontFamily: 'Baloo Bhai 2',color: Color(0xffd9d9d9)),)],

                                    ),),
                                    if(userInfo?.level == 4)Container(alignment: Alignment.center,width: 40,height: 18,decoration:BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)),color: Color(0xfff5f5f5)),child: Row(mainAxisAlignment:MainAxisAlignment.center,
                                      children: [
                                        // Image.asset('assets/images/lv4.png',width: 10,height: 10,),SizedBox(width: 4,),
                                        Text('4',style: TextStyle(fontSize: 10,fontWeight: FontWeight.w700,fontFamily: 'Baloo Bhai 2',color: Color(0xffd9d9d9)),),Text('Lv',style: TextStyle(fontSize: 10,fontWeight: FontWeight.w700,fontFamily: 'Baloo Bhai 2',color: Color(0xffd9d9d9)),)],
                                    ),),
                                    if(userInfo?.level == 5)Container(alignment: Alignment.center,width: 40,height: 18,decoration:BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)),color: Color(0xfff5f5f5)),child: Row(mainAxisAlignment:MainAxisAlignment.center,
                                      children: [
                                        // Image.asset('assets/images/lv5.png',width: 10,height: 10,),SizedBox(width: 4,),
                                        Text('5',style: TextStyle(fontSize: 10,fontWeight: FontWeight.w700,fontFamily: 'Baloo Bhai 2',color: Color(0xffd9d9d9)),),Text('Lv',style: TextStyle(fontSize: 10,fontWeight: FontWeight.w700,fontFamily: 'Baloo Bhai 2',color: Color(0xffd9d9d9)),)],

                                    ),),
                                    ///性别
                                    // userInfo?.sex != 0
                                    //     ? Padding(
                                    //   padding: const EdgeInsets.only(
                                    //       right: 10),
                                    //   child: userInfo?.sex == 1
                                    //       ? Image.asset('assets/images/nanIcon.png',width: 17.0,
                                    //       height: 17.0) : Image.asset('assets/images/nvIcon.png',width: 17.0,
                                    //       height: 17.0),
                                    // )
                                    //     : Container()
                                  ]),
                                  SizedBox(height: 8,),
                                  Container(
                                    height: 60,
                                    width: 220,
                                    child: Text(
                                      userInfo?.slogan ?? '-',
                                      style: TextStyle(fontSize: 12),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),



                        Container(
                          margin: EdgeInsets.only(top: 25),
                          padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                          decoration: BoxDecoration(
                              color: Color(0xffffffff),

                              border: Border.all(color: Color(0xffF1F1F1),
                                  width: 1),
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: const [
                                BoxShadow(
                                    color: Color.fromRGBO(0, 0, 0, 0.05),
                                    //color:Colors.black,
                                    offset: Offset(0.0, 0.0), //阴影xy轴偏移量
                                    blurRadius: 5, //阴影模糊程度
                                    spreadRadius: 1 //阴影扩散程度
                                )
                              ]
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              // Expanded(
                              //   child: Container(
                              //     decoration: BoxDecoration(
                              //         border: Border(
                              //             left: BorderSide(
                              //                 width: 0.4, color: Colors.black12))),
                              //     alignment: Alignment.center,
                              //     child:
                              //     GestureDetector(child: Column(
                              //       mainAxisAlignment: MainAxisAlignment.center,
                              //       children: [
                              //         Text(
                              //           userInfo?.concern.toString() ?? '0',
                              //           style: TextStyle(
                              //               fontWeight: FontWeight.w600,
                              //               fontSize: 20),
                              //         ),
                              //         Text(
                              //           '关注'.tr,
                              //           style: TextStyle(color: Colors.black45),
                              //         ),
                              //       ],
                              //     ),onTap: (){ Get.to(MyfollowPage(),transition: Transition.leftToRight,arguments:userInfo?.userId);},)
                              //   ),
                              // ),
                              GestureDetector(child: Container(width: 80,child: Column(
                                children: [
                                  Text(
                                    userInfo?.concern.toString() ?? '0',
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 5,),
                                  Text(
                                      '关注'.tr,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0XFF999999),
                                      )
                                  ),
                                ],
                              ), color: Colors.white,),
                                  onTap: () {
                                    Get.to(MyfollowPage(),
                                        transition: Transition.leftToRight,
                                        arguments: userInfo?.userId);
                                  }
                              ),
                              // Expanded(
                              //   child:
                              //   GestureDetector(child:Container(
                              //     alignment: Alignment.center,
                              //     child: Column(
                              //       mainAxisAlignment: MainAxisAlignment.center,
                              //       children: [
                              //         Text(
                              //           userInfo?.fans.toString() ?? '0',
                              //           style: TextStyle(
                              //               fontWeight: FontWeight.w600,
                              //               fontSize: 20),
                              //         ),
                              //         Text(
                              //           '粉丝'.tr,
                              //           style: TextStyle(color: Colors.black45),
                              //         ),
                              //       ],
                              //     ),
                              //   ),onTap: (){
                              //     print('1111111');
                              //     Get.to(MyfansPage(), transition: Transition.leftToRight,arguments:userInfo?.userId);
                              //
                              //   },)
                              //
                              // ),
                              SizedBox(
                                width: 1,
                                height: 20,
                                child: DecoratedBox(
                                  decoration:  BoxDecoration(color: Color(0x16000000)),
                                ),
                              ),
                              GestureDetector(child: Container(
                                width: 80,
                                color: Colors.white,
                                child: Column(
                                  children: [
                                    Text(
                                      userInfo?.fans.toString() ?? '0',
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(height: 5,),
                                    Text(
                                      '粉丝'.tr,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0XFF999999),
                                        //fontFamily: 'PingFang SC',
                                      ),
                                    ),
                                  ],
                                ),
                              ), onTap: () {
                                Get.to(MyfansPage(),
                                    transition: Transition.leftToRight,
                                    arguments: userInfo?.userId);
                              },),
                              SizedBox(
                                width: 1,
                                height: 20,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(color: Color(0x16000000)),
                                ),
                              ),
                              // Expanded(
                              //   child: Container(
                              //     decoration: const BoxDecoration(
                              //         border: Border(
                              //             right: BorderSide(
                              //                 width: 0.4, color: Colors.black12))),
                              //     alignment: Alignment.center,
                              //     child:
                              //     GestureDetector(child:Column(
                              //         mainAxisAlignment: MainAxisAlignment.center,
                              //         children: [
                              //             Text(
                              //           userInfo != null
                              //             ? (userInfo!.getLike +
                              //             userInfo!.getCollect)
                              //                 .toString()
                              //                 : '0',
                              //             style: TextStyle(
                              //             fontWeight: FontWeight.w600,
                              //             fontSize: 20),
                              //             ),
                              //             Text(
                              //             '获赞和收藏'.tr,
                              //             style: TextStyle(color: Colors.black45),
                              //             ),
                              //             ],
                              //             ),onTap: (){
                              //       _showMyDialog(context);
                              //     },),
                              //   ),
                              // ),
                              GestureDetector(child: Container(
                                width: 110,
                                color: Colors.white, child: Column(
                                children: [
                                  Text(
                                    userInfo != null
                                        ? (userInfo!.getLike +
                                        userInfo!.getCollect)
                                        .toString()
                                        : '0',
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                      //fontFamily: 'PingFang SC',
                                    ),
                                  ),
                                  SizedBox(height: 5,),
                                  Text(
                                    '获赞和收藏'.tr,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0XFF999999),
                                      //fontFamily: 'PingFang SC',
                                    ),
                                  ),
                                ],
                              ),)
                                , onTap: () {
                                  _showMyDialog(context);
                                },),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),

                SliverPersistentHeader(
                  delegate: MyDelegate(tabController),
                  pinned: true,
                ),
              ];
            },
            body: userInfo?.isDisLike ?? false
                ? _disBlackView()
                : TabBarView(
              controller: tabController,
              children: [
                StartDetailPage(
                    type: ApiType.myPublish,
                    parameter: widget.userId.toString(), lasting: false
                ),
                // StartDetailPage(
                //   type: ApiType.myCollect,
                //   parameter: widget.userId.toString(),
                // ),
                Container(
                  //decoration: BoxDecoration(border: Border.all(width: 1,color: Colors.red)),
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 10, bottom: 10),
                        child: Row(
                          children: [
                            SizedBox(width: 10,),
                            GestureDetector(child: Container(
                              child: Text('笔记'.tr +
                                  ' · ${userInfo?.collect!=null?userInfo?.collect
                                      .toString():'0'}', style: TextStyle(
                                fontSize: 12,
                                color: note == 1 ? Color(0xff9000000) : Color(
                                    0xff999999),
                              ),),
                              padding: EdgeInsets.fromLTRB(12, 8, 12, 8),
                              decoration: BoxDecoration(
                                color: note == 1 ? Color(0xffF5F5F5) : Colors
                                    .transparent,
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ), onTap: () {
                              setState(() {
                                note = 1;
                                oneData = false;
                              });
                            },),
                            SizedBox(width: 10,),
                            GestureDetector(child: Container(
                              padding: EdgeInsets.fromLTRB(12, 8, 12, 8),
                              decoration: BoxDecoration(
                                color: note == 2 ? Color(0xffF5F5F5) : Colors
                                    .transparent,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Text('话题'.tr + ' · ${userInfo?.topics!=null?userInfo?.topics
                                  .toString():'0'}', style: TextStyle(
                                fontSize: 12,
                                color: note == 2 ? Color(0xff000000) : Color(
                                    0xff999999),
                              ),),
                            ), onTap: () {
                              setState(() {
                                note = 2;
                                topiclist();
                              });
                            },),
                            SizedBox(width: 10,),
                            GestureDetector(child: Container(
                              padding: EdgeInsets.fromLTRB(12, 8, 12, 8),
                              decoration: BoxDecoration(
                                color: note == 3 ? Color(0xffF5F5F5) : Colors
                                    .transparent,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Text('地点'.tr + ' · ${userInfo?.addressCollect!=null?userInfo?.addressCollect
                                  .toString():'0'}', style: TextStyle(
                                fontSize: 12,
                                color: note == 3 ? Color(0xff000000) : Color(
                                    0xff999999),
                              ),),
                            ), onTap: () {
                              setState(() {
                                note = 3;
                                Collectionlocation();
                              });
                            },)
                          ],
                        ),
                      ),
                      // Divider(height: 1.0,color: Color(0xffe4e4e4),),
                      ///分割线
                      Container(
                        height: 1.0,
                        decoration: BoxDecoration(
                          color: Color(0xfff1f1f1),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x0c00000),
                              offset: Offset(0, 2),
                              blurRadius: 5,
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                      ),
                      if(note == 1) Expanded(
                        child: StartDetailPage(
                            type: ApiType.myCollect,
                            parameter: widget.userId.toString(),
                            lasting: false),
                      ),
                      if(note == 2) !oneData ? StartDetailLoading() : Expanded(
                        child:
                        labellist.length > 0 ? ListView(
                            padding: EdgeInsets.only(left: 15, right: 15),
                            children: [
                              for(var i = 0; i < labellist.length; i++)
                                Column(children: [
                                  SizedBox(height: 20,),
                                  Row(
                                    children: [
                                      Container(
                                        width: 70,
                                        height: 47,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              10),
                                        ),
                                        child: Image.network(labellist[i].thumbnail,
                                          fit: BoxFit.cover,),
                                        clipBehavior: Clip.hardEdge,
                                      ),
                                      SizedBox(width: 10,),
                                      Container(height: 47, child: Column(
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceBetween,
                                        crossAxisAlignment:CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Image.asset(
                                                'assets/images/jinghao.png',
                                                width: 20, height: 20,),
                                              SizedBox(width: 7,),
                                              Text(labellist[i].title)
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(labellist[i].visits + ' 浏览'.tr,
                                                style: TextStyle(fontSize: 12,
                                                    color: Color(0xff999999)),)
                                            ],
                                          )
                                        ],
                                      ),)
                                    ],
                                  ),
                                  SizedBox(height: 20,),

                                  ///分割线
                                  Container(
                                    height: 1.0,
                                    decoration: BoxDecoration(
                                      color: Color(0xfff1f1f1),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color(0x0c00000),
                                          offset: Offset(0, 2),
                                          blurRadius: 5,
                                          spreadRadius: 0,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],)

                            ]
                        ) : NoDataWidgetNoShoucang(),
                      ),

                      ///位置列表
                      if(note == 3) !oneData ? StartDetailLoading() : Expanded(
                        child:
                        FavoriteLocation.length > 0 ? ListView(
                            padding: EdgeInsets.only(left: 15, right: 15),
                            children: [
                              for(var i = 0; i < FavoriteLocation.length; i++)
                                GestureDetector(child: Column(children: [
                                  SizedBox(height: 20,),
                                  Row(
                                    children: [
                                      Container(
                                        width: 78,
                                        height: 78,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              10),
                                        ),
                                        child: Image.network(
                                          FavoriteLocation[i].thumbnail,
                                          fit: BoxFit.cover,),
                                        clipBehavior: Clip.hardEdge,
                                      ),
                                      SizedBox(width: 10,),
                                      Container(height: 78, child: Column(
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(FavoriteLocation[i].name)
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              for(var r = 0; r <
                                                  FavoriteLocation[i].types
                                                      .length; r++)
                                                Row(
                                                  children: [
                                                    Text(
                                                      FavoriteLocation[i].types[r],
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 12),
                                                      overflow: TextOverflow
                                                          .ellipsis,),
                                                    if(r !=
                                                        FavoriteLocation[i].types
                                                            .length - 1)Container(
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            width: 0.5,
                                                            color: Colors.black),
                                                      ),
                                                      height: 10,
                                                      margin: EdgeInsets.fromLTRB(
                                                          10, 0, 10, 0),
                                                    )
                                                  ],
                                                )
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              GestureDetector(child: Text(
                                                FavoriteLocation[i].createdAt
                                                    .toString(), style: TextStyle(
                                                  color: Color(0xff999999)),),
                                                onTap: () {
                                                },)
                                            ],
                                          )
                                        ],
                                      ),)
                                    ],
                                  ),
                                  SizedBox(height: 20,),

                                  ///分割线
                                  Container(
                                    height: 1.0,
                                    decoration: BoxDecoration(
                                      color: Color(0xfff1f1f1),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color(0x0c00000),
                                          offset: Offset(0, 2),
                                          blurRadius: 5,
                                          spreadRadius: 0,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],), onTap: () {
                                  Get.toNamed('/public/geographical',
                                      arguments: FavoriteLocation[i]!.placeId);
                                },)

                            ]
                        ) : NoDataWidgetNoShoucang(),
                      )

                    ],
                  ),
                ),
                StartDetailPage(
                    type: ApiType.myLike,
                    parameter: widget.userId.toString(), lasting: false
                ),

              ],
            ),
          ),
      bottomNavigationBar: userController.userId !=
          userInfo?.userId?Container(
        height: 100,
        width: double.infinity,
        color: Colors.white,
        padding: EdgeInsets.only(left: 5,right: 5),
        child:
        Row(mainAxisAlignment:MainAxisAlignment.spaceEvenly,children: [
          GetBuilder<UserLogic>(
              builder: (logic) {
                return GestureDetector(child: Container(
                  height: 42,
                  width: 145,

                  padding: const EdgeInsets.fromLTRB(
                      15, 5, 45, 5),
                  child: Row(
                    children: [
                      Text('通信'.tr),
                      SizedBox(width: 7,),
                      Image.asset(
                        'assets/images/sixin_new.png',
                        width: 22,
                        height: 22,
                        fit: BoxFit.cover,),

                    ],
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                          40),
                      color: Colors.white,
                      border: Border.all(
                          width: 2, color: Colors.black)
                  ),), onTap: () {
                  if (!userController.checkUserLogin()) {
                    Get.toNamed('/public/loginmethod');
                    return;
                  }
                  if(userInfo?.userId==null || userController.userId==null){
                    return;
                  }
                  if (!userController.Chatdisconnected) {
                    WebSocketes.WebSocketconnection();
                  }
                  Get.to(ChatPage(), arguments: {
                    'uid': userInfo?.userId,
                    'id': userController.userId,
                    'uname': userInfo?.userName,
                    'Avatar': userInfo?.avatar
                  });
                },);
              }),
          // SizedBox(width: 15,),
          GestureDetector(child: Container(
            padding: EdgeInsets.fromLTRB(15, 2, 40, 2),
            height: 42,
            width: 145,
            child:
            Row(
              children: [
                Text(userInfo?.isMyFans ?? false
                      ? '已关注'.tr
                      : '关注'.tr, style: TextStyle(
                    color: userInfo?.isMyFans ?? false ? Color(
                        0xff999999) : Colors.white,
                  )),
                SizedBox(width: 7,),

            (userInfo?.isMyFans ?? false)
                    ?
                Image.asset(
                  'assets/images/yihuanzhuta.png',
                  width: 22,
                  height: 22,
                  fit: BoxFit.cover,)
        : Image.asset(
    'assets/images/guanzhuta.png',
    width: 22,
    height: 22,
    fit: BoxFit.cover,),

              ],
            ),
            // Text(userInfo?.isMyFans ?? false
            //     ? '已关注'.tr
            //     : '关注'.tr, style: TextStyle(
            //   color: userInfo?.isMyFans ?? false ? Color(
            //       0xff999999) : Colors.white,
            // ),
            // ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                color: userInfo?.isMyFans ?? false
                    ? Colors.white
                    : Colors.black,
                border: Border.all(width: 2,
                    color: userInfo?.isMyFans ?? false
                        ? Color(0xffe1e1e1)
                        : Colors.black)
            ),), onTap: () {
            if (!userController.checkUserLogin()) {
              Get.toNamed('/public/loginmethod');
              return;
            }
            _onTapFocus();
          },),
        ])
      ):null,
    );
  }

  _disBlackView() {
    return Center(
      child: Container(
        margin: EdgeInsets.only(top: 60),
        child: Column(
          children: [
            Text('已经加入黑名单,内容不可见'.tr),
            GestureDetector(
              onTap: () async {
                EasyLoading.show(status: 'loading...',maskType: EasyLoadingMaskType.black);
                await userProvider.setBlack(widget.userId, 2);
                await _initUserInfo();
                EasyLoading.dismiss();
              },
              child: Padding(
                padding: EdgeInsets.only(top: 30),
                child: Text('解除黑名单'.tr, style: TextStyle(color: Colors.green),),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///赞和收藏弹窗
  Future<void> _showMyDialog(context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          elevation: 0,
          contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
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
                      alignment: Alignment(0, 0),
                      child: Text('赞和收藏'.tr),
                    ),
                    // Divider(height: 1.0, color: Color(0xffe4e4e4),),
                    Container(
                      margin: EdgeInsets.fromLTRB(20, 10, 20, 0),
                      //decoration: BoxDecoration(border: Border.all(width: 1,color: Colors.red)),
                      // padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.asset('assets/images/xiaoxi.png', width: 30,
                                height: 30,),
                              SizedBox(width: 10,),
                              Text('发布作品数'.tr, style: TextStyle(
                                  fontSize: 15, color: Color(0xff999999)),)
                            ],
                          ),
                          Text(userInfo?.works.toString() ?? 0.toString())
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
                      //decoration: BoxDecoration(border: Border.all(width: 1,color: Colors.red)),
                      // padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                'assets/images/dianzan.png', width: 30,
                                height: 30,),
                              SizedBox(width: 10,),
                              Text('获得点赞数'.tr, style: TextStyle(
                                  fontSize: 15, color: Color(0xff999999)),)
                            ],
                          ),
                          Text(userInfo?.getLike.toString() ?? 0.toString())
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
                      //decoration: BoxDecoration(border: Border.all(width: 1,color: Colors.red)),
                      // padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                'assets/images/shoucang.png', width: 30,
                                height: 30,),
                              SizedBox(width: 10,),
                              Text('获得收藏数'.tr, style: TextStyle(
                                  fontSize: 15, color: Color(0xff999999)),)
                            ],
                          ),
                          Text(userInfo?.getCollect.toString() ?? 0.toString())
                        ],
                      ),
                    ),
                    SizedBox(height: 40,),
                    GestureDetector(child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(65),
                      ),
                      padding: EdgeInsets.fromLTRB(40, 15, 40, 15),
                      child: Text("我知道了".tr, style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w600),),
                    ), onTap: () {
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
}

class MyDelegate extends SliverPersistentHeaderDelegate {
  TabController? controller;

  MyDelegate(this.controller);

  @override
  Widget build(BuildContext context, double shrinkOffset,
      bool overlapsContent) {
    return controller == null
        ? Container()
        : Container(
      height: 66,
      padding: EdgeInsets.only(left: 15, right: 15),
      // decoration: BoxDecoration(
      //   color: Colors.white,
      //   //设置四周圆角 角度
      //   borderRadius: BorderRadius.only(
      //     topLeft: Radius.circular(6),
      //     topRight: Radius.circular(6),
      //   ),
      //   border: Border(
      //     top: BorderSide(color: Colors.black12, width: 0.5),
      //     bottom: BorderSide(color: Colors.black12, width: 0.5),
      //     left: BorderSide(color: Colors.black12, width: 0.5),
      //     right: BorderSide(color: Colors.black12, width: 0.5),
      //   ),
      // ),
      decoration:  BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Colors.black12,
            width: 0.5,
            style: BorderStyle.solid,
          ),
        ),
      ),
      alignment: Alignment.center,
      child: TabBar(
        controller: controller,
        labelColor: Colors.black,
        labelPadding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
        isScrollable: true,
        // indicatorColor: HexColor('#D1FF34'),
        // indicatorWeight: 3,
        indicator: CustomUnderlineTabIndicator(
            borderSide: BorderSide(
              width: 4,
              color: HexColor('#D1FF34'),
            )
        ),
        dividerColor: Colors.transparent,
        indicatorSize: TabBarIndicatorSize.label,
        tabs: [
          Text('发布'.tr),
          Text('收藏'.tr),
          Text('赞过'.tr),

        ],
      ),
    );
  }

  @override
  double get maxExtent => 66;

  @override
  double get minExtent => 66;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
