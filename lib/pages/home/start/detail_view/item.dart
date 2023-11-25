import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:lanla_flutter/common/controller/UserLogic.dart';

import 'package:lanla_flutter/models/HomeItem.dart';
import 'package:lanla_flutter/pages/detail/ceshi/index.dart';
import 'package:lanla_flutter/pages/detail/picture/view.dart';
import 'package:lanla_flutter/pages/detail/webview/view.dart';
import 'package:lanla_flutter/pages/home/friend/ContentZoneList.dart';
import 'package:lanla_flutter/pages/home/friend/Planningpage.dart';
import 'package:lanla_flutter/pages/home/friend/logic.dart';
import 'package:lanla_flutter/pages/home/friend/view.dart';
import 'package:lanla_flutter/pages/home/logic.dart';
import 'package:lanla_flutter/pages/home/me/LevelDescription/index.dart';
import 'package:lanla_flutter/pages/home/me/authentication/index.dart';
import 'package:lanla_flutter/pages/home/shoppingmall/index.dart';
import 'package:lanla_flutter/pages/home/start/detail_view/Moretopics.dart';
import 'package:lanla_flutter/pages/home/start/detail_view/view.dart';
import 'package:lanla_flutter/pages/home/start/list_widget/ceshilist.dart';
import 'package:lanla_flutter/pages/user/Invitationpage/index.dart';
import 'package:lanla_flutter/pages/user/NewMobileverification/index.dart';
import 'package:lanla_flutter/pages/user/loginmethod/view.dart';
import 'package:lanla_flutter/pages/user/reference/index.dart';
import 'package:lanla_flutter/ulits/app_log.dart';
import 'package:lanla_flutter/ulits/base_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

// 首页中内容的组件
class IndexItemWidget extends StatelessWidget {
  final HomeItem data;
  final int index;
  final setLike;
  final bool like;
  final userLogic = Get.find<UserLogic>();
  bool isEnd = false;
  late ApiType type;
  late String parameter;
  late Function Delete;

  IndexItemWidget(this.data, this.index, this.like, this.setLike, this.isEnd,
      this.type, this.parameter, this.Delete,
      {super.key, isLoading = false});

  bool isTimeBetween(DateTime startTime, DateTime endTime) {
    DateTime now = DateTime.now();
    return now.isAfter(startTime) && now.isBefore(endTime);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        // Get.to(shoppingPage());
        // return;
        if (data.id != 0) {
          var sp = await SharedPreferences.getInstance();
          if (sp.getInt("Numberdetails") != null) {
            sp.setInt("Numberdetails", sp.getInt("Numberdetails")! + 1);
          } else {
            sp.setInt("Numberdetails", 1);
          }

          ///关闭登录验证
          if (!userLogic.checkUserLogin()) {
            Get.toNamed('/public/loginmethod');
            return;
          }
          FirebaseAnalytics.instance.logEvent(
            name: "works_click",
            parameters: {
              "type": data.type,
              "id": data.id,
              "userId": userLogic.userId,
              'deviceId': userLogic.deviceId
            },
          );
          if (data.type == 1) {
            Get.toNamed('/public/video',
                preventDuplicates: false,
                arguments: {"data": data.id, "isEnd": isEnd, 'Detailed': data});
          } else if (data.type == 2) {
            Get.toNamed('/public/picture',
                preventDuplicates: false,
                arguments: {"data": data.id, "isEnd": isEnd, 'Detailed': data});
          } else if (data.type == 3) {
            Get.toNamed('/public/xiumidata',
                preventDuplicates: false,
                arguments: {"data": data.id, "isEnd": isEnd, 'Detailed': data});
          }
        } else {
          if (!Get.find<UserLogic>().checkUserLogin()) {
            Get.toNamed('/public/loginmethod');
            return;
          }
        }
      },
      // 长按删除
      onLongPress: () {
        if (type == ApiType.myPublish &&
            data.userId == userLogic.userId &&
            data.id != 0) {
          Get.defaultDialog(
              titlePadding: EdgeInsets.only(top: 20, bottom: 20),
              contentPadding: EdgeInsets.only(bottom: 20, left: 20, right: 20),
              backgroundColor: Colors.white.withOpacity(1),
              buttonColor: Colors.black,
              title: "删除".tr,
              middleText: "您确定删除本条内容?".tr,
              textConfirm: "确定".tr,
              confirmTextColor: Colors.white,
              textCancel: "取消".tr,
              cancelTextColor: Colors.black,
              onConfirm: () {
                Get.back();
                Delete(index);
              });
        }
      },
      child: Stack(children: [
        data.id != 0
            ? Container(
                //margin: const EdgeInsets.fromLTRB(2, 2, 2, 2),
                padding: EdgeInsets.fromLTRB(0, 0, 0, 10),

                // padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  border: new Border.all(
                      width: 0.2, color: Color.fromRGBO(0, 0, 1, 0.2)),
                ),
                width: double.infinity,
                child: Column(children: [
                  Stack(
                    children: [
                      Container(
                        //超出部分，可裁剪
                        width: double.infinity,
                        clipBehavior: Clip.hardEdge,
                        height:
                            (context.width / 2 - 6) * data.attaImageScale > 260
                                ? 260
                                : (context.width / 2 - 6) * data.attaImageScale,
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8),
                                topRight: Radius.circular(8))
                            // borderRadius: BorderRadius.circular(10),
                            ),
                        child: CachedNetworkImage(
                          imageUrl: data.thumbnail,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: Color(0xffF5F5F5),
                            padding: EdgeInsets.only(left: 20, right: 20),
                            width: double.infinity,
                            child:
                                Image.asset('assets/images/LanLazhanwei.png'),
                          ),
                          errorWidget: (context, url, error) {
                            // 网络图片加载失败时显示本地图片
                            return Container(
                              color: Color(0xffF5F5F5),
                              padding: EdgeInsets.only(left: 20, right: 20),
                              width: double.infinity,
                              child:
                              Image.asset('assets/images/LanLazhanwei.png',),
                            );
                          },
                        ),
                      ),
                      // if(type == ApiType.myPublish)Positioned(
                      //   bottom: 10,
                      //   left: 10,
                      //   child: Container(padding:EdgeInsets.only(left: 10,right: 10),height: 26,decoration: BoxDecoration(borderRadius: BorderRadius.circular(100),color: Color(0x66000000)),child: Row(mainAxisAlignment:MainAxisAlignment.center,children: [
                      //     Container(
                      //       width: 14,
                      //       height: 14,
                      //       child: SvgPicture.asset(
                      //         "assets/svg/yanjing.svg",
                      //       ),
                      //     ),
                      //     SizedBox(width: 3,),
                      //     Text(data.visits.toString(),style: TextStyle(fontSize: 12,color: Colors.white),),
                      //     //Text('1233',style: TextStyle(fontSize: 12,color: Colors.white),),
                      //   ],),),
                      // )
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    alignment: Alignment.centerRight,
                    margin: const EdgeInsets.only(top: 8),
                    child: Text(
                      data.title,
                      overflow: TextOverflow.ellipsis, //长度溢出后显示省略号
                      maxLines: 3,
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 11),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    margin: const EdgeInsets.only(top: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              /// 头像
                              GestureDetector(
                                child: Container(
                                  height: 18,
                                  width: 18,
                                  clipBehavior: Clip.hardEdge,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(18),
                                    // color: Colors.black12,
                                    // image: DecorationImage(
                                    //     image: NetworkImage(data.userAvatar),
                                    //     fit: BoxFit.cover),
                                  ),
                                  margin: const EdgeInsets.only(left: 3),
                                  child: CachedNetworkImage(
                                    imageUrl: data.userAvatar,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Container(
                                      color: Color(0xffF5F5F5),
                                       padding: EdgeInsets.only(left: 2, right: 2),
                                      width: double.infinity,
                                       child: Image.asset('assets/images/LanLazhanwei.png'),
                                    ),
                                    errorWidget: (context, url, error) {
                                      // 网络图片加载失败时显示本地图片
                                      return Container(
                                        color: Color(0xffF5F5F5),
                                         padding: EdgeInsets.only(left: 2, right: 2),
                                        width: double.infinity,
                                        child: Image.asset('assets/images/LanLazhanwei.png',),
                                      );
                                    },
                                  ),
                                  // child: Image.network(data.userAvatar,fit:BoxFit.cover),
                                ),
                                onTap: () {
                                  ///关闭登录验证
                                  if (!userLogic.checkUserLogin()) {
                                    Get.toNamed('/public/loginmethod');
                                    return;
                                  }
                                  Get.toNamed('/public/user',
                                      arguments: data.userId);
                                },
                              ),
                              const SizedBox(
                                width: 3,
                              ),
                              Expanded(
                                child: SizedBox(
                                  //height: 14,
                                  child: Text(
                                    data.userName,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        color: Color.fromRGBO(153, 153, 153, 1),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (!userLogic.checkUserLogin()) {
                              Get.toNamed('/public/loginmethod');
                              return;
                            }
                            setLike(index);
                          },
                          child: Row(
                            children: [
                              // Icon(
                              //   like ? Icons.favorite : Icons.favorite_border,
                              //   size: 16,
                              //   color: like ? Colors.red : Colors.black38,
                              // ),
                              Container(
                                height: 14,
                                alignment: Alignment.center,
                                padding: const EdgeInsets.only(right: 3),
                                child: Text(
                                  data.likes.toString(),
                                  style: const TextStyle(
                                      color: Color.fromRGBO(153, 153, 153, 1),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                              const SizedBox(
                                width: 2,
                              ),
                              like
                                  ? SvgPicture.asset(
                                      'assets/svg/heart_sel_new.svg')
                                  : SvgPicture.asset(
                                      'assets/svg/heart_nor_new.svg'),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ]))
            : data.contentArea.length != 0
                ? Container(
                    margin: const EdgeInsets.fromLTRB(2, 7, 2, 7),
                    // padding: EdgeInsets.all(2),
                    clipBehavior: Clip.hardEdge,
                    constraints: BoxConstraints(
                      minHeight: 210,
                    ),
                    //height: (context.width / 2 - 6) * data.attaImageScale>260?260:(context.width / 2 - 6) * data.attaImageScale,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: new Border.all(
                            width: 0.2, color: Color.fromRGBO(0, 0, 1, 0.2)),
                        color: Colors.white),
                    width: double.infinity,
                    child: Column(children: [
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.fromLTRB(15, 12, 15, 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('内容专区'.tr, style: TextStyle(fontSize: 13)),
                            GestureDetector(
                              child: Text(
                                '更多'.tr,
                                style: TextStyle(
                                    fontSize: 11, color: Color(0xff999999)),
                              ),
                              onTap: () async {
                                await Get.find<FriendLogic>().renew();
                                Get.find<HomeLogic>().setNowPage(1);
                              },
                            ),
                          ],
                        ),
                      ),
                      Container(
                          constraints: BoxConstraints(
                            minHeight: 170,
                          ),
                          //超出部分，可裁剪
                          width: double.infinity,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              for (var i = 0; i < data.contentArea.length; i++)
                                GestureDetector(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                      border: Border.all(
                                          width: 0.2,
                                          color: Color.fromRGBO(0, 0, 1, 0.2)),
                                    ),
                                    width: double.infinity,
                                    constraints: BoxConstraints(
                                      maxHeight: 70,
                                    ),
                                    clipBehavior: Clip.hardEdge,
                                    margin: EdgeInsets.all(5),
                                    child: CachedNetworkImage(
                                      imageUrl: data.contentArea[i].cover,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  onTap: () async {
                                    Get.to(Planningpage(), arguments: {
                                      "id": data.contentArea[i].id,
                                      "title": data.contentArea[i].title,
                                    });
                                  },
                                ),
                            ],
                          )),
                    ]))
                : data.activity.length != 0
                    ? Container(
                        margin: const EdgeInsets.fromLTRB(2, 7, 2, 7),
                        // padding: EdgeInsets.all(2),
                        clipBehavior: Clip.hardEdge,
                        constraints: BoxConstraints(
                          minHeight: 210,
                        ),
                        //height: (context.width / 2 - 6) * data.attaImageScale>260?260:(context.width / 2 - 6) * data.attaImageScale,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: new Border.all(
                                width: 0.2,
                                color: Color.fromRGBO(0, 0, 1, 0.2)),
                            color: Colors.white),
                        width: double.infinity,
                        child: Column(children: [
                          if (data.activity.length > 1)
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.fromLTRB(15, 12, 15, 12),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('热门话题'.tr,
                                      style: TextStyle(fontSize: 13)),
                                  GestureDetector(
                                    child: Text(
                                      '更多'.tr,
                                      style: TextStyle(
                                          fontSize: 11,
                                          color: Color(0xff999999)),
                                    ),
                                    onTap: () {
                                      Get.to(MoretopicsPage());
                                    },
                                  ),
                                ],
                              ),
                            ),
                          Container(
                              constraints: BoxConstraints(
                                minHeight: 170,
                              ),
                              //超出部分，可裁剪
                              width: double.infinity,
                              child: data.activity.length > 1
                                  ? Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        for (var i = 0;
                                            i < data.activity.length;
                                            i++)
                                          GestureDetector(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(10),
                                                ),
                                                border: Border.all(
                                                    width: 0.2,
                                                    color: Color.fromRGBO(
                                                        0, 0, 1, 0.2)),
                                              ),
                                              width: double.infinity,
                                              constraints: BoxConstraints(
                                                maxHeight: 70,
                                              ),
                                              clipBehavior: Clip.hardEdge,
                                              margin: EdgeInsets.all(5),
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    data.activity[i].imagePath,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            onTap: () async {
                                              FirebaseAnalytics.instance
                                                  .logEvent(
                                                name: "Advertisingspace",
                                                parameters: {
                                                  "event": data
                                                      .activity[i].targetType,
                                                  "targetid":
                                                      data.activity[i].id,
                                                  "data":
                                                      data.activity[i].targetId,
                                                  'targetOther': data
                                                      .activity[i].targetOther,
                                                  'deviceId': userLogic.deviceId
                                                },
                                              );
                                              if (data.activity[i].targetId != '' &&
                                                  data.activity[i].targetType ==
                                                      1) {
                                                Get.toNamed('/public/topic',
                                                    arguments: int.parse(data
                                                        .activity[i].targetId));
                                              } else if (data.activity[i].targetId !=
                                                      '' &&
                                                  data.activity[i].targetType ==
                                                      4) {
                                                Get.toNamed('/public/webview',
                                                    arguments: data
                                                        .activity[i].targetId);
                                              } else if (data.activity[i]
                                                          .targetId !=
                                                      '' &&
                                                  data.activity[i].targetType ==
                                                      10) {
                                                Get.toNamed('/public/user',
                                                    arguments: int.parse(data
                                                        .activity[0].targetId));
                                              } else if (data.activity[i]
                                                          .targetId !=
                                                      '' &&
                                                  data.activity[i].targetType ==
                                                      5) {
                                                _launchUniversalLinkIos(
                                                    Uri.parse(data.activity[i]
                                                        .targetOther),
                                                    Uri.parse(data
                                                        .activity[i].targetId));
                                              } else if (data.activity[i]
                                                          .targetId !=
                                                      '' &&
                                                  data.activity[i].targetType ==
                                                      6) {
                                                _launchUniversalLinkIos(
                                                    Uri.parse(data.activity[i]
                                                        .targetOther),
                                                    Uri.parse(data
                                                        .activity[i].targetId));
                                              } else if (data.activity[i]
                                                          .targetId !=
                                                      '' &&
                                                  data.activity[i].targetType ==
                                                      11) {
                                                if (data.activity[i]
                                                            .targetOther ==
                                                        '/public/video' ||
                                                    data.activity[i]
                                                            .targetOther ==
                                                        '/public/picture' ||
                                                    data.activity[i]
                                                            .targetOther ==
                                                        '/public/xiumidata') {
                                                  Get.toNamed(
                                                      data.activity[i]
                                                          .targetOther,
                                                      arguments: {
                                                        'data': int.parse(data
                                                            .activity[i]
                                                            .targetId),
                                                        'isEnd': false
                                                      });
                                                } else if (data.activity[i].targetId == 'share/invite/index') {
                                                  FirebaseAnalytics.instance
                                                      .logEvent(
                                                    name: "jumpwebh5",
                                                    parameters: {
                                                      "userid":
                                                          userLogic.userId,
                                                      "uuid": userLogic
                                                          .deviceData['uuid'],
                                                    },
                                                  );
                                                  //if(int.parse(data.activity[i].targetId)==1){
                                                  Get.toNamed('/public/webview',
                                                      arguments: BASE_DOMAIN +
                                                          data.activity[i]
                                                              .targetId +
                                                          '?token=' +
                                                          userLogic.token +
                                                          '&uuid=' +
                                                          userLogic.deviceData[
                                                              'uuid']);
                                                  //}
                                                } else {
                                                  Get.toNamed(
                                                    data.activity[i]
                                                        .targetOther,
                                                    arguments: int.parse(data
                                                        .activity[i].targetId),
                                                  );
                                                }
                                              } else if (data.activity[i]
                                                          .targetId !=
                                                      '' &&
                                                  data.activity[i].targetType ==
                                                      12) {
                                                //Get.toNamed('/public/webview',arguments: data.activity[i].targetId);
                                                await launchUrl(
                                                  Uri.parse(data
                                                      .activity[i].targetId),
                                                  mode: LaunchMode
                                                      .externalApplication,
                                                );
                                              }
                                            },
                                          ),
                                      ],
                                    )
                                  : GestureDetector(
                                      child: Container(
                                        constraints: BoxConstraints(
                                          minHeight: 220,
                                        ),
                                        child: CachedNetworkImage(
                                          imageUrl: data.activity[0].imagePath,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      onTap: () async {
                                        FirebaseAnalytics.instance.logEvent(
                                          name: "Advertisingspace",
                                          parameters: {
                                            "event":
                                                data.activity[0].targetType,
                                            "targetid": data.activity[0].id,
                                            "data": data.activity[0].targetId,
                                            'targetOther':
                                                data.activity[0].targetOther,
                                            'deviceId': userLogic.deviceId
                                          },
                                        );
                                        if (data.activity[0].targetId != '' &&
                                            data.activity[0].targetType == 1) {
                                          Get.toNamed('/public/topic',
                                              arguments: int.parse(
                                                  data.activity[0].targetId));
                                        } else if (data.activity[0].targetId !=
                                                '' &&
                                            data.activity[0].targetType == 4) {
                                          Get.toNamed('/public/webview',
                                              arguments:
                                                  data.activity[0].targetId);
                                        } else if (data.activity[0].targetId !=
                                                '' &&
                                            data.activity[0].targetType == 10) {
                                          Get.toNamed('/public/user',
                                              arguments: int.parse(
                                                  data.activity[0].targetId));
                                        } else if (data.activity[0].targetId !=
                                                '' &&
                                            data.activity[0].targetType == 5) {
                                          _launchUniversalLinkIos(
                                              Uri.parse(
                                                  data.activity[0].targetOther),
                                              Uri.parse(
                                                  data.activity[0].targetId));
                                        } else if (data.activity[0].targetId !=
                                                '' &&
                                            data.activity[0].targetType == 6) {
                                          _launchUniversalLinkIos(
                                              Uri.parse(
                                                  data.activity[0].targetOther),
                                              Uri.parse(
                                                  data.activity[0].targetId));
                                        } else if (data.activity[0].targetId != '' && data.activity[0].targetType == 11) {
                                          if (data.activity[0].targetOther ==
                                                  '/public/video' ||
                                              data.activity[0].targetOther ==
                                                  '/public/picture' ||
                                              data.activity[0].targetOther ==
                                                  '/public/xiumidata') {
                                            Get.toNamed(
                                                data.activity[0].targetOther,
                                                arguments: {
                                                  'data': int.parse(data
                                                      .activity[0].targetId),
                                                  'isEnd': false
                                                });
                                          } else if (data
                                                  .activity[0].targetId ==
                                              'share/invite/index') {
                                            FirebaseAnalytics.instance.logEvent(
                                              name: "jumpwebh5",
                                              parameters: {
                                                "userid": userLogic.userId,
                                                "uuid": userLogic
                                                    .deviceData['uuid'],
                                              },
                                            );
                                            Get.toNamed('/public/webview',
                                                arguments: BASE_DOMAIN +
                                                    data.activity[0].targetId +
                                                    '?token=' +
                                                    userLogic.token +
                                                    '&uuid=' +
                                                    userLogic
                                                        .deviceData['uuid']);
                                          }else if(data.activity[0].targetOther == '/public/Planningpage'){
                                            Get.toNamed(
                                                data.activity[0].targetOther,
                                                arguments: {
                                                  'id': int.parse(data
                                                      .activity[0].targetId),
                                                  'title': ''
                                                });
                                          } else {
                                            Get.toNamed(
                                              data.activity[0].targetOther,
                                              arguments: int.parse(
                                                  data.activity[0].targetId),
                                            );
                                          }
                                        } else if (data.activity[0].targetId !=
                                                '' &&
                                            data.activity[0].targetType == 12) {
                                          await launchUrl(
                                            Uri.parse(
                                                data.activity[0].targetId),
                                            mode:
                                                LaunchMode.externalApplication,
                                          );
                                        }
                                      },
                                    )),
                        ]))
                    : Container(),

        /// 播放小图标-luo pym_
        Positioned(
            top: 10,
            left: 10,
            child: data.type == 1 && data.isFireTag == 0
                ?
                // const Icon(
                //     Icons.linked_camera,
                //     color: Colors.white70,
                //     size: 22,
                //   )
                SvgPicture.asset('assets/svg/play_new.svg')
                : Container()),

        ///音频提示
        Positioned(
            top: 10,
            left: 10,
            child: data.type == 2 &&
                    data.recordingPath != '' &&
                    data.isFireTag == 0
                ?
                // Icon(
                //   Icons.mic,
                //   color: Colors.white70,
                //   size: 18,
                // )
                SvgPicture.asset('assets/svg/mic_new.svg')
                : Container()),
        Positioned(
            top: 10,
            left: 10,
            child: data.type == 3 && data.isFireTag == 0
                ?
                // const Icon(
                //     Icons.linked_camera,
                //     color: Colors.white70,
                //     size: 22,
                //   )
                SvgPicture.asset('assets/svg/longpvbj.svg')
                : Container()),

        ///绿色火焰
        Positioned(
            top: 10,
            left: 10,
            child: data.isFireTag == 1
                ?
                // const Icon(
                //     Icons.linked_camera,
                //     color: Colors.white70,
                //     size: 22,
                //   )
                SvgPicture.asset('assets/svg/greenflame.svg')
                : Container()),
      ]),
    );
  }

  final Uri _url =
      Uri.parse('https://chat.whatsapp.com/D7PpZaUOGOf3DmKC60uUSo');

  // Future<void> _launchUrl() async {
  //   if (!await launchUrl(_url)) {
  //     throw 'Could not launch $_url';
  //   }
  // }
  Future<void> _launchUrl() async {
    //直接对指定号码发送消息
    // 参考: https://api.whatsapp.com/send?phone=$phone&text=${URLEncoder.encode(message, "UTF-8")}
    const url = 'whatsapp://send';
    //const url = "https://wa.me/?text=Your Message here";
    var encoded = Uri.encodeFull(url);

    if (await canLaunch(encoded)) {
      await launch(encoded);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _launchUniversalLinkIos(Uri url, Uri httpurl) async {
    try {
      final bool nativeAppLaunchSucceeded = await launchUrl(
        url,
        mode: LaunchMode.externalNonBrowserApplication,
      );
      // 失败后使用浏览器打开,未捕捉到异常时
      if (!nativeAppLaunchSucceeded) {
        bool isUrl = await launchUrl(
          httpurl,
          mode: LaunchMode.externalApplication,
        );
        if (!isUrl) {

        }
      }

    } catch (e) {

      // 失败后使用浏览器打开,未捕捉到异常时
      await launchUrl(
        httpurl,
        mode: LaunchMode.externalApplication,
      );
      // await launchUrl(
      //   httpurl,
      //   mode: LaunchMode.inAppWebView,
      // );
    }
  }
}
