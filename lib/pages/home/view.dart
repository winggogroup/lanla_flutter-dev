import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:adjust_sdk/adjust.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lanla_flutter/common/controller/PublishDataLogic.dart';
import 'package:lanla_flutter/common/controller/publicmethodes.dart';
import 'package:lanla_flutter/common/toast/view.dart';
import 'package:lanla_flutter/models/DailyTasks.dart';
import 'package:lanla_flutter/models/splash.dart';
import 'package:lanla_flutter/pages/detail/GlobalMask/index.dart';
import 'package:lanla_flutter/pages/detail/video/view.dart';
import 'package:lanla_flutter/pages/home/Pricecomparison/view.dart';
import 'package:lanla_flutter/pages/home/me/Appsetup/Feedback.dart';
import 'package:lanla_flutter/pages/home/me/Appsetup/binding_email/index.dart';
import 'package:lanla_flutter/pages/home/me/TaskCenter/index.dart';
import 'package:lanla_flutter/pages/home/me/authentication/index.dart';
import 'package:lanla_flutter/pages/home/shoppingmall/index.dart';
import 'package:lanla_flutter/pages/home/start/view.dart';
import 'package:lanla_flutter/pages/home/top/view.dart';
import 'package:lanla_flutter/pages/publish/Longraphicwriting.dart';
import 'package:lanla_flutter/pages/user/Loginmethod/logic.dart';
import 'package:lanla_flutter/pages/user/NewMobileverification/index.dart';
import 'package:lanla_flutter/pages/user/emaillogin/index.dart';
import 'package:lanla_flutter/pages/user/login/view.dart';
import 'package:lanla_flutter/services/SetUp.dart';
import 'package:lanla_flutter/services/content.dart';
import 'package:lanla_flutter/services/user.dart';
import 'package:lanla_flutter/ulits/app_log.dart';
import 'package:lanla_flutter/ulits/base_provider.dart';
import 'package:lanla_flutter/ulits/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';
import 'package:lanla_flutter/pages/user/loginmethod/view.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import '../../common/controller/UserLogic.dart';
import '../../ulits/hex_color.dart';
import '../../ulits/language/camera_picker_text_delegate.dart';
import 'friend/logic.dart';
import 'friend/view.dart';
import 'logic.dart';
import 'me/view.dart';
import 'message/view.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
  //实例化
  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/userinfo.profile',
  ],
);

// 用于监听整体app变化
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
  final provider = Get.put(ContentProvider());
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  bool shengjifetching = false;
  final userLogic = Get.find<UserLogic>(); // 是否正在请求接口
  final logic = Get.find<HomeLogic>();
  final logices = Get.put(LoginmethodLogic());
  final followlogic = Get.put(FriendLogic());
  final state = Get.find<HomeLogic>().state;
  final publishDataLogic = Get.find<PublishDataLogic>();
  SetUpProvider SetUprovider =  Get.put(SetUpProvider());
  Publicmethodes Publicmethods = Get.put(Publicmethodes());
  bool antishake=true;
  var zsdsf;
  /// 初始化控制器
  late PageController pageController;
  Widget _footIcon(int number, String tip) {
    bool isActive = state.nowPage.value == number;
    return Expanded(
        flex: 3,
        child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              if (number == 3) {
                if (!userLogic.checkUserLogin()) {
                  Get.toNamed('/public/loginmethod');
                  return;
                }
                FirebaseAnalytics.instance.logEvent(
                  name: "mepage",
                );
                userLogic.getUserInfo();
              }
              if(number == 2){
                FirebaseAnalytics.instance.logEvent(
                  // name: "priceparitypage",
                    name: " shoppingmall",

                );
              }
              if(number == 0){
                FirebaseAnalytics.instance.logEvent(
                  name: "homepage",
                );
              }
              // if (number == 2) {
              //   if (!userLogic.checkUserLogin()) {
              //     Get.toNamed('/public/loginmethod');
              //     return;
              //   }
              // }
              if (number == 1) {
                if (userLogic.token == '') {
                  Get.toNamed('/public/loginmethod');
                  return;
                }
                FirebaseAnalytics.instance.logEvent(
                  name: "friendpage",
                );
              }
              // _controller.jumpToPage(number);

              logic.setNowPage(number);
            },
            child: Center(
                child: Image.asset(
                  isActive
                      ? 'assets/images/home/${tip}_active.png'
                      : 'assets/images/home/$tip.png',
                  height: 42,
                )
            )
        )
    );
  }
  var laxinopen = false;
  bool isPopupopens = false;
  var taskdata;
  late final UserProvider userprovider=Get.put(UserProvider());
  bool closeRewardPopup = true;
  var PopupData;

  @override
  void initState() {
    shenji();
    dttcdata();

    super.initState();
    // mririrenwu();
    WidgetsBinding.instance.addObserver(this); //添加观察者
    SplashModel? ad = Get.arguments;
    Future.delayed(const Duration(milliseconds: 10), () async {
      var huancuns = await SharedPreferences.getInstance();
      if(huancuns.getBool("isopenApp") == null){
        FirebaseAnalytics.instance.logEvent(
          name: "isOpenApp",
          parameters: {
            "sourcePlatform":userLogic.sourcePlatform,
            "deviceId":userLogic.deviceId,
          },
        );
        huancuns.setBool("isopenApp", true);
      }
      // Wellreceived(context);
      // Signinpopup(context);

      ///app评价
      // if (userLogic.token != '')
      //   Timer.periodic(Duration(milliseconds: 60000), (timer) {
      //     print('定时结束');
      //     Localdata();
      //     timer.cancel(); //取消定时器
      //   });



// =======
//       //laxinDialoges(context);
//       if(userLogicone.token != ''){
//         newpopupmechanism();
//       }
//       if(userLogicone.token != '')Timer.periodic(
//           Duration(milliseconds: 60000),(timer){
//             print('定时结束');
//             Localdata();
//             timer.cancel();//取消定时器
//         }
//       );
// >>>>>>> 02a09d24ddd38ec8a20c8813d8b6218049a8ce25
      var resultone = await widget.provider.Newsquantity();
      if (resultone.statusCode == 200) {
        if (userLogic.NumberMessages != resultone.body['total']) {
          userLogic.operatioNews(resultone.body['total']);
        }
      }
      if(userLogic.token != ''){
        bindingPopup();
      }
      ///轮训全部消息
      if (userLogic.token != ''&&!userLogic.DurationTimer){
        userLogic.DurationTimer=true;
        // userLogic.update();
        Timer.periodic(const Duration(milliseconds: 60000), (timer) async {
          if (userLogic.token == '') {
            userLogic.DurationTimer=false;
            timer.cancel(); //取消定时器
            return;
          }
          var result = await widget.provider.Newsquantity();
          await widget.provider.dailyOnlineDurationTracker();
          if (result.statusCode == 200) {
            if (userLogic.NumberMessages != result.body['total']) {
              userLogic.operatioNews(result.body['total']);
            }
          }
        });
      }
      if (ad != null) {
        if (!Get.find<UserLogic>().checkUserLogin()) {
          // Get.toNamed('/public/loginmethod');
          return;
        }
        if (userLogic.token != '') {
          await FirebaseAnalytics.instance.logEvent(
            name: "spread_its_tail",
            parameters: {"router": ad?.targetType, "id": ad?.targetId},
          );
          if (ad?.targetId != '' && ad?.targetType == 1) {
            Get.toNamed('/public/topic', arguments: int.parse(ad.targetId));
          } else if (ad?.targetId != '' && ad?.targetType == 4) {
            Get.toNamed('/public/webview', arguments: ad?.targetId);
          } else if (ad?.targetId != '' && ad?.targetType == 10) {
            Get.toNamed('/public/user', arguments: int.parse(ad.targetId));
          } else if (ad?.targetId != '' && ad?.targetType == 5) {
            _launchUniversalLinkIos(Uri.parse(ad.targetOther));
          } else if (ad?.targetId != '' && ad?.targetType == 6) {
            _launchUniversalLinkIos(Uri.parse(ad.targetOther));
          } else if (ad?.targetId != '' && ad?.targetType == 11) {
            if (ad?.targetOther == '/public/video' ||
                ad?.targetOther == '/public/picture'|| ad?.targetOther == '/public/xiumidata') {
              Get.toNamed(ad.targetOther,
                  arguments: {'data': int.parse(ad.targetId), 'isEnd': false});
            }else if(ad?.targetId=='share/invite/index'){
              FirebaseAnalytics.instance.logEvent(
                name: "jumpwebh5",
                parameters: {
                  "userid": userLogic.userId,
                  "uuid":userLogic.deviceData['uuid'],
                },
              );
              Get.toNamed('/public/webview',arguments: '$BASE_DOMAIN${ad.targetId}?token=${userLogic.token}&uuid='+userLogic.deviceData['uuid']);
            } else if(ad?.targetOther == '/public/Planningpage'){
              Get.toNamed(ad.targetOther,
                  arguments: {'id': int.parse(ad.targetId), 'title': ''});
            } else {
              Get.toNamed(
                ad.targetOther,
                arguments: int.parse(ad.targetId),
              );
            }
          } else if (ad.targetId != '' && ad.targetType == 12) {
            await launchUrl(
              Uri.parse(ad.targetId),
              mode: LaunchMode.externalApplication,
            );
          }
        }
      }
    });
    // Future.delayed(Duration(milliseconds: 6000), (){
    //   Signinpopup(context);
    // });
  }

  mririrenwu() async {
    if (userLogic.token != '') {
      var res = await userprovider.dailyTaskList();
      if (res.statusCode == 200) {
        taskdata = dailyTasksFromJson(res.bodyString!);
        setState(() {});
        ///弹窗触发位置
        whole();
      }
    }
  }

  ///全部弹窗机制
  whole(){
    DateTime now = DateTime.now();
    // 判断今天是星期几
    bool isWednesday = now.weekday == DateTime.wednesday;
    bool isFriday = now.weekday == DateTime.friday;
    bool isMonday = now.weekday == DateTime.monday;
    bool isThursday = now.weekday == DateTime.thursday;
    bool isTuesday = now.weekday == DateTime.tuesday;
    bool isSunday = now.weekday == DateTime.sunday;
    ///签到弹窗
    Timer.periodic(const Duration(milliseconds: 1000), (timer) {
      if(!isPopupopens){
        Signmechanism();
      }
      timer.cancel(); //取消定时器
    });
    ///动态弹窗
    ///
    for(var i=0;i<PopupData.length;i++){
      Timer.periodic(Duration(seconds: PopupData[i]['delay_show_second']), (timer) {
        if(!isPopupopens){
          Activeopen(i);
        }
        timer.cancel(); //取消定时器
      });
    }
    // if((isTuesday||isFriday)&&now.isBefore(DateTime(now.year, 8, 6))){
    //   print('弹窗活动1');
    //   // Timer.periodic(Duration(milliseconds: 180000), (timer) {
    //   //   if(!isPopupopens){
    //   //     Activeopen();
    //   //   }
    //   //   timer.cancel(); //取消定时器
    //   // });
    // }
    // if((isMonday||isThursday)&&now.isBefore(DateTime(now.year, 8, 17))){
    //   print('弹窗活动2');
    //   Timer.periodic(Duration(milliseconds: 180000), (timer) {
    //     if(!isPopupopens){
    //       Activeopentwo();
    //     }
    //     timer.cancel(); //取消定时器
    //   });
    // }

    ///活动弹窗3
    // if((isWednesday||isSunday)&&now.isBefore(DateTime(now.year, 8, 7))){
    //   print('弹窗活动3');
    //   Timer.periodic(Duration(milliseconds: 180000), (timer) {
    //     if(!isPopupopens){
    //       Activeopenthree();
    //     }
    //     timer.cancel(); //取消定时器
    //   });
    // }
    ///活动弹窗


    // ///h5邀请弹窗计时器
    // Timer.periodic(Duration(milliseconds: 300000), (timer) {
    //   print('定时结束');
    //   if(!isPopupopens){
    //     newpopupmechanism();
    //   }
    //   timer.cancel(); //取消定时器
    // });

    ///app评价弹窗计时器
    Timer.periodic(const Duration(milliseconds: 1800000), (timer) {
      if(!isPopupopens){
        Localdata();
      }
      timer.cancel(); //取消定时器
    });
  }

  newpopupmechanism() async {
    var huancun = await SharedPreferences.getInstance();
    if (huancun.getInt("LaxinOpeningtime") == null) {
      huancun.setInt(
          "LaxinOpeningtime", DateTime.now().millisecondsSinceEpoch);
      laxinDialoges(context);
    } else if (DateTime.now()
            .difference(DateTime.fromMillisecondsSinceEpoch(
                huancun.getInt("LaxinOpeningtime")!))
            .inDays >
        1) {
      huancun.setInt(
          "LaxinOpeningtime", DateTime.now().millisecondsSinceEpoch);
      laxinDialoges(context);
    }
  }
  /// s升级提示
  shenji() async {

    if (shengjifetching) {
      return;
    }
    shengjifetching = true;
    var result = await widget.provider.isUpgrade();
    if (result.statusCode == 200) {
      //var result = await provider.GetHomeList(page, widget.parameter);
      //延迟1秒请求，防止速率过快
      Future.delayed(const Duration(milliseconds: 1000), () {
        shengjifetching = false;
      });
      if (result.body["ok"] == 1 || result.body["ok"] == 2) {
        if (userLogic.token != '') {
          if(result.body["ok"] == 1){
            toupdateDialog(context, result.body["ok"]);
          }
          if(result.body["ok"] == 2){
            Timer.periodic(const Duration(milliseconds: 300000), (timer) {
              if(!isPopupopens) {
                toupdateDialog(context, result.body["ok"]);
              }
              timer.cancel(); //取消定时器
            });

          }
        }
      }
    } else {
      setState(() {
        shengjifetching = false;
      });
    }
  }

  ///动态弹窗
  dttcdata() async {
    var res=await widget.provider.DynamicPopup();
    if(res.statusCode==200){
      PopupData=res.body;

    }
    mririrenwu();
  }
  ///绑定弹窗
  bindingPopup() async {
    var res=await SetUprovider.isNeedBindAccount();
    if(res.statusCode==200){
      if(res.body['need_bind_account_right_now']){
        Timer.periodic(const Duration(seconds: 40), (timer) {
          if(!isPopupopens){
            BindPopupopen(res.body);
          }
          timer.cancel(); //取消定时器
        });
      }
    }
  }

  Future<void> toupdateDialog(context, type) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: type == 2 ? true : false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          elevation:0,
          contentPadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(
              //color: Colors.transparent,
              //color: Colors.red,
              // height: 280,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      width: MediaQuery.of(context).size.width - 100,
                      //height: 311,
                      // decoration: BoxDecoration(
                      //   image: DecorationImage(
                      //     image: AssetImage('assets/images/gengxtc.png'),
                      //     fit: BoxFit.fill, // 完全填充
                      //   ),
                      // ),
                      child: Stack(
                        children: [
                          Image.asset(
                            'assets/images/gengxtc.png',
                            width: MediaQuery.of(context).size.width - 100,
                          ),
                          Positioned(
                            bottom: 0,
                            left: 10,
                            right: 10,
                            child: Column(
                              children: [
                                Container(child: Text('新版本优化啦，快来体验吧'.tr,textAlign: TextAlign.center,),),
                                GestureDetector(
                                  child: Container(
                                    alignment: Alignment.center,
                                    padding:
                                        const EdgeInsets.only(top: 12, bottom: 12),
                                    width:
                                        MediaQuery.of(context).size.width - 180,
                                    margin: const EdgeInsets.fromLTRB(40, 32, 40, 13),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(40),
                                      color: Colors.black,
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Color(0xFF55D200),
                                          offset: Offset(0, 1),
                                          blurRadius: 1,
                                          spreadRadius: 0,
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      '立刻升级'.tr,
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  onTap: () {
                                    if (Platform.isAndroid) {
                                      _launchUniversalLinkIos(Uri.parse(
                                          "market://details?id=lanla.app"));
                                    } else if (Platform.isIOS) {
                                      _launchUniversalLinkIos(Uri.parse(
                                          "itms-apps://apps.apple.com/tr/app/times-tables-lets-learn/id6443484359?l=tr"));
                                    }
                                  },
                                ),
                                if (type == 2)
                                  GestureDetector(
                                    child: Text('以后再说'.tr),
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                const SizedBox(
                                  height: 18,
                                ),
                              ],
                            ),
                          )
                        ],
                      ))
                ],
              ),
            ),
          ]),
        );
      },
    ).then((value) {
      // 弹窗关闭后执行的操作
      isPopupopens=false;
    });
  }

  ///好评弹窗
  ///
  Localdata() async {
    var shuju = await SharedPreferences.getInstance();
    if (shuju.getInt("pjOpeningtime") == null &&
        shuju.getBool("isevaluate") == null &&
        !laxinopen) {
      shuju.setInt("pjOpeningtime", DateTime.now().millisecondsSinceEpoch);
      Wellreceived(context);
    } else if (DateTime.now()
        .difference(DateTime.fromMillisecondsSinceEpoch(
        shuju.getInt("pjOpeningtime")!))
        .inDays >
        3 &&
        shuju.getBool("isevaluate") == null &&
        shuju.getInt("Numberdetails")! > 50 &&
        !laxinopen) {
      shuju.setInt("pjOpeningtime", DateTime.now().millisecondsSinceEpoch);
      Wellreceived(context);
    }
  }
  Future<void> Wellreceived(context) async {

    isPopupopens=true;
    var sp = await SharedPreferences.getInstance();
    sp.setInt("Numberdetails", 0);
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          elevation:0,
          contentPadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(
              //color: Colors.transparent,
              //color: Colors.red,
              // height: 280,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      width: MediaQuery.of(context).size.width - 100,
                      //height: 311,
                      // decoration: BoxDecoration(
                      //   image: DecorationImage(
                      //     image: AssetImage('assets/images/gengxtc.png'),
                      //     fit: BoxFit.fill, // 完全填充
                      //   ),
                      // ),
                      child: Stack(
                        children: [
                          Image.asset(
                            'assets/images/dianzanbj.png',
                            width: MediaQuery.of(context).size.width - 100,
                          ),
                          Positioned(
                            bottom: 10,
                            left: 0,
                            right: 0,
                            child: Column(
                              children: [
                                Text(
                                  '喜欢LanLa吗？'.tr,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width - 140,
                                  margin: const EdgeInsets.fromLTRB(40, 15, 40, 0),
                                  child: Text(
                                      'LanLa的成长需要你的支持，我们诚恳希望能得到你的鼓励与评价，因为你的每一次鼓励能让我们做得更好。'
                                          .tr,
                                      maxLines: 4,
                                      style: const TextStyle(
                                          fontSize: 12,
                                          color: Color(0xff999999))),
                                ),
                                GestureDetector(
                                  child: Container(
                                    alignment: Alignment.center,
                                    padding:
                                        const EdgeInsets.only(top: 12, bottom: 12),
                                    width:
                                        MediaQuery.of(context).size.width - 180,
                                    margin: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(40),
                                      color: Colors.black,
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Color(0xFF55D200),
                                          offset: Offset(0, 1),
                                          blurRadius: 1,
                                          spreadRadius: 0,
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      '五星好评'.tr,
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  onTap: () async {
                                    var shuju =
                                        await SharedPreferences.getInstance();
                                    shuju.setBool("isevaluate", true);
                                    Navigator.pop(context);
                                    if (Platform.isAndroid) {
                                      _launchUniversalLinkIos(Uri.parse(
                                          "market://details?id=lanla.app"));
                                    } else if (Platform.isIOS) {
                                      _launchUniversalLinkIos(Uri.parse(
                                          "itms-apps://apps.apple.com/tr/app/times-tables-lets-learn/id6443484359?l=tr"));
                                    }
                                  },
                                ),
                                GestureDetector(
                                  child: Text(
                                    '我要反馈与建议'.tr,
                                    style: const TextStyle(
                                        color: Color(0xff999999), fontSize: 12),
                                  ),
                                  onTap: () async {
                                    var shuju = await SharedPreferences.getInstance();
                                    shuju.setBool("isevaluate", true);
                                    Navigator.pop(context);
                                    //Get.toNamed('/public/loginmethod');
                                    Get.to(FeedbackWidget());
                                  },
                                ),
                                const SizedBox(
                                  height: 25,
                                ),
                              ],
                            ),
                          )
                        ],
                      ))
                ],
              ),
            ),
          ]),
        );
      },
    ).then((value) {
      // 弹窗关闭后执行的操作
      isPopupopens=false;

    });
  }

  ///活动弹窗
  Activeopen(index) async {
    var huancun = await SharedPreferences.getInstance();
    if (huancun.getInt("Activeopentime${PopupData[index]['id']}") == null) {
      huancun.setInt(
          "Activeopentime${PopupData[index]['id']}", DateTime.now().millisecondsSinceEpoch);
      ActivePopup(context,index);
    } else if (DateTime.now()
            .difference(DateTime.fromMillisecondsSinceEpoch(
                huancun.getInt("Activeopentime${PopupData[index]['id']}")!))
            .inDays >
        1) {
      huancun.setInt(
          "Activeopentime${PopupData[index]['id']}", DateTime.now().millisecondsSinceEpoch);
      ActivePopup(context,index);
    }
  }
  Activeopentwo() async {
    var huancun = await SharedPreferences.getInstance();
    if (huancun.getInt("Activeopentimetwo") == null) {
      huancun.setInt(
          "Activeopentimetwo", DateTime.now().millisecondsSinceEpoch);
      ActivePopuptwo(context);
    } else if (DateTime.now()
        .difference(DateTime.fromMillisecondsSinceEpoch(
        huancun.getInt("Activeopentimetwo")!))
        .inDays >
        1) {
      huancun.setInt(
          "Activeopentimetwo", DateTime.now().millisecondsSinceEpoch);
      ActivePopuptwo(context);
    }
  }
  BindPopupopen(data) async {

    if(userLogic.isbindingopen){

    var huancun = await SharedPreferences.getInstance();
    if (huancun.getInt("BindPopuptime${userLogic.userId}") == null) {
      huancun.setInt(
          "BindPopuptime${userLogic.userId}", DateTime.now().millisecondsSinceEpoch);
      BindPopup(context,data);
    } else if (DateTime.now()
        .difference(DateTime.fromMillisecondsSinceEpoch(
        huancun.getInt("BindPopuptime${userLogic.userId}")!))
        .inDays >
        1) {
      huancun.setInt(
          "BindPopuptime${userLogic.userId}", DateTime.now().millisecondsSinceEpoch);
      BindPopup(context,data);
    }
    }
  }
  Future<void> ActivePopup(context,index) async {
    isPopupopens=true;
    return
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.transparent,
            elevation:0,
            contentPadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))),
            content: Column(mainAxisSize: MainAxisSize.min, children: [
              Container(
                  width: MediaQuery.of(context).size.width - 50,
                  child: Stack(
                    children: [
                      GestureDetector(
                        child:  Container(margin: const EdgeInsets.only(top: 10),child: Image.network(
                          PopupData[index]['pic'],
                          fit: BoxFit.cover,
                        ),),
                        onTap: () async {
                          if (userLogic.token != '') {
                            await FirebaseAnalytics.instance.logEvent(
                              name: "DynamicPopup",
                              parameters: {"target_path": PopupData[index]['target_path'], "target_type": PopupData[index]['target_type']},
                            );
                            Navigator.pop(context);
                            // Get.toNamed('/public/picture', preventDuplicates: false,arguments: {"data": 38156, "isEnd": false,});
                            if (PopupData[index]['target_path']!= '' && PopupData[index]['target_type'] == 'app') {

                              if (PopupData[index]['target_path'] == '/public/video' ||
                                  PopupData[index]['target_path'] == '/public/picture' || PopupData[index]['target_path'] == '/public/xiumidata') {
                                Get.toNamed(PopupData[index]['target_path'],
                                    arguments: {'data': int.parse(PopupData[index]['target_id']), 'isEnd': false});
                              } else {
                                Get.toNamed(
                                  PopupData[index]['target_path'],
                                  arguments: int.parse(PopupData[index]['target_id']),
                                );
                              }
                            }else if(PopupData[index]['target_path']!= '' && PopupData[index]['target_type'] == 'outside_app'){
                              _launchUniversalLinkIos(Uri.parse(PopupData[index]['target_path']));
                            }else if(PopupData[index]['target_path']!= '' && PopupData[index]['target_type'] == 'web'){
                              await launchUrl(
                                Uri.parse(PopupData[index]['target_path']),
                                mode: LaunchMode.externalApplication,
                              );
                            }
                          } else {
                            FirebaseAnalytics.instance.logEvent(
                              name: "DynamicPopuperroe",
                              parameters: {

                              },
                            );
                            Navigator.pop(context);
                            Get.toNamed('/public/loginmethod');
                            return;
                          }},
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: GestureDetector(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: SvgPicture.asset(
                              "assets/svg/cha.svg",
                              color: Colors.white,
                              width: 12,
                              height: 12,
                            ),
                          ),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ))
            ]),
          );
        },
      ).then((value) {
        isPopupopens=false;
    });
  }

  Future<void> ActivePopuptwo(context) async {
    isPopupopens=true;
    return
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.transparent,
            elevation:0,
            contentPadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))),
            content: Column(mainAxisSize: MainAxisSize.min, children: [
              Container(
                  width: MediaQuery.of(context).size.width - 50,
                  child: Stack(
                    children: [
                      GestureDetector(
                        child:  Container(margin: const EdgeInsets.only(top: 10),child: Image.asset(
                          'assets/images/huodong2.png',
                          fit: BoxFit.cover,
                        ),),
                        onTap: () {
                          if (userLogic.token != '') {
                            Navigator.pop(context);
                            Get.toNamed('/public/picture', preventDuplicates: false,arguments: {"data": 39999, "isEnd": false,});
                          } else {
                            FirebaseAnalytics.instance.logEvent(
                              name: "pop_up_click",
                              parameters: {
                                'pop_upId':2,
                                'userId':userLogic.userId,
                                'deviceId':userLogic.deviceId,
                              },
                            );
                            Navigator.pop(context);
                            Get.toNamed('/public/loginmethod');
                            return;
                          }},
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: GestureDetector(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: SvgPicture.asset(
                              "assets/svg/cha.svg",
                              color: Colors.white,
                              width: 12,
                              height: 12,
                            ),
                          ),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ))
            ]),
          );
        },
      ).then((value) {
        isPopupopens=false;
      });
  }

  Future<void> BindPopup(context,data) async {
    isPopupopens=true;
    return
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            elevation:0,
            contentPadding: const EdgeInsets.fromLTRB(20, 22, 20, 40),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))),
            content: Column(mainAxisSize: MainAxisSize.min, children: [
              Container(
                  width: double.infinity,
                  child: Stack(
                    children: [
                      Column(children: [
                        const SizedBox(height: 35,),
                        Text('由于LanLa登录系统的优化，请绑定其他的登录方式'.tr,style: const TextStyle(fontSize: 18,fontWeight: FontWeight.w700,height: 1.8),textAlign: TextAlign.center,),
                        const SizedBox(height: 20,),
                        if(data['bind_list'][1]['bind_type']==2&&!data['bind_list'][1]['already_bind'])GestureDetector(
                          child: Container(
                            height: 43,
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(209, 255, 52, 1),
                              borderRadius:BorderRadius.circular((46)),
                              // boxShadow:const [
                              //   BoxShadow(
                              //     color: Color(0x33000000),
                              //     offset: Offset(0, 5),
                              //     blurRadius: 10,
                              //     spreadRadius: 1,
                              //   ),
                              // ],
                            ),
                            child: Stack(
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: 43,
                                  // decoration: BoxDecoration(border: Border.all(color: Colors.red),color: Colors.red),
                                  child: Row(
                                    mainAxisAlignment:MainAxisAlignment.center,
                                    children: [
                                      Text('Facebook'.tr,style:const TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        decoration:TextDecoration.none,
                                        fontWeight:  FontWeight.w600,
                                      )),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  bottom: 10,
                                  right: 60,
                                  child: SvgPicture.asset(
                                    "assets/svg/facebookbd.svg",
                                    width: 22,
                                    height: 22,
                                  ),
                                )
                              ],
                            ),
                          ),
                          onTap: () async {

                              signInWithFacebook(context);

                          },
                        ),
                        if(data['bind_list'][1]['bind_type']==2&&!data['bind_list'][1]['already_bind'])const SizedBox(height: 20,),
                        if(data['bind_list'][2]['bind_type']==3&&!data['bind_list'][2]['already_bind'])GestureDetector(
                          child: Container(
                            height: 43,
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(209, 255, 52, 1),
                              borderRadius:BorderRadius.circular((46)),
                              // boxShadow:const [
                              //   BoxShadow(
                              //     color: Color(0x33000000),
                              //     offset: Offset(0, 5),
                              //     blurRadius: 10,
                              //     spreadRadius: 1,
                              //   ),
                              // ],
                            ),
                            child:  Stack(
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: 43,
                                  // decoration: BoxDecoration(border: Border.all(color: Colors.red),color: Colors.red),
                                  child: Row(
                                    mainAxisAlignment:MainAxisAlignment.center,
                                    children: const [
                                      Text('Apple',style:TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        decoration:TextDecoration.none,
                                        fontWeight:  FontWeight.w600,
                                      )),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  bottom: 10,
                                  right: 60,
                                  child: SvgPicture.asset(
                                    "assets/svg/applebd.svg",
                                    width: 22,
                                    height: 22,
                                  ),
                                )
                              ],
                            ),
                          ),
                          onTap: () async {

                              signInWithApple();

                          },
                        ),
                        if(data['bind_list'][2]['bind_type']==3&&!data['bind_list'][2]['already_bind'])const SizedBox(height: 20,),
                        if(data['bind_list'][0]['bind_type']==1&&!data['bind_list'][0]['already_bind'])GestureDetector(
                          child: Container(
                            height: 43,
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(209, 255, 52, 1),
                              borderRadius:BorderRadius.circular((46)),
                              // boxShadow:const [
                              //   BoxShadow(
                              //     color: Color(0x33000000),
                              //     offset: Offset(0, 5),
                              //     blurRadius: 10,
                              //     spreadRadius: 1,
                              //   ),
                              // ],
                            ),
                            child: Stack(
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: 43,
                                  // decoration: BoxDecoration(border: Border.all(color: Colors.red),color: Colors.red),
                                  child: Row(
                                    mainAxisAlignment:MainAxisAlignment.center,
                                    children: const [
                                      Text('Google',style:TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        decoration:TextDecoration.none,
                                        fontWeight:  FontWeight.w600,
                                      )),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  bottom: 10,
                                  right: 60,
                                  child: SvgPicture.asset(
                                    "assets/svg/googlebd.svg",
                                    width: 22,
                                    height: 22,
                                  ),
                                )
                              ],
                            )
                          ),
                          onTap: () async {

                              handleSignIn(context);

                          },
                        ),
                        if(data['bind_list'][0]['bind_type']==1&&!data['bind_list'][0]['already_bind'])const SizedBox(height: 20,),
                        if(data['bind_list'][3]['bind_type']==5&&!data['bind_list'][3]['already_bind'])GestureDetector(
                          child: Container(
                            height: 43,
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(209, 255, 52, 1),
                              borderRadius:BorderRadius.circular((46)),
                              // boxShadow:const [
                              //   BoxShadow(
                              //     color: Color(0x33000000),
                              //     offset: Offset(0, 5),
                              //     blurRadius: 10,
                              //     spreadRadius: 1,
                              //   ),
                              // ],
                            ),
                            child: Stack(
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: 43,
                                  // decoration: BoxDecoration(border: Border.all(color: Colors.red),color: Colors.red),
                                  child: Row(
                                    mainAxisAlignment:MainAxisAlignment.center,
                                    children: const [
                                      Text('Email',style:TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        decoration:TextDecoration.none,
                                        fontWeight:  FontWeight.w600,
                                      )),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  bottom: 10,
                                  right: 60,
                                  child: SvgPicture.asset(
                                    "assets/svg/emailbd.svg",
                                    width: 22,
                                    height: 22,
                                  ),
                                )
                              ],
                            )
                          ),
                          onTap: () async {
                            Get.to(bindingemailoginPage())?.then((value) {
                              if (value != null) {
                                Navigator.pop(context);
                                //此处可以获取从第二个页面返回携带的参数
                              }
                              //此处可以获取从第二个页面返回携带的参数
                            });
                          },
                        ),
                      ],),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: GestureDetector(
                          child: Padding(
                            padding: const EdgeInsets.all(0),
                            child: SvgPicture.asset(
                              "assets/svg/cha.svg",
                              color: Colors.black,
                              width: 12,
                              height: 12,
                            ),
                          ),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  )
              )
            ]),
          );
        },
      ).then((value) {
        isPopupopens=false;
      });
  }
  /// fackbook绑定
  Future<void> signInWithFacebook(context) async {
    if(antishake){
      antishake=false;
      Publicmethods.loades(context,'');
      final LoginResult result = await FacebookAuth.instance.login(); // by default we request the email and the public profile
      if (result.status == LoginStatus.success) {
        var BindingResults = await SetUprovider.Thirdpartybinding(2,'','','',result.accessToken?.applicationId,result.accessToken?.token,'');
        if(BindingResults.statusCode==200){
          Navigator.pop(context);
          Navigator.pop(context);
          Toast.toast(context,msg: "绑定成功".tr,position: ToastPostion.center);
        }else{
          Navigator.pop(context);
        }
      } else {
        Navigator.pop(context);
        Toast.toast(context,msg: "绑定失败".tr,position: ToastPostion.center);
      }
      antishake=true;
    }
  }

  /// google绑定
  Future<void> handleSignIn(context) async {
    if(antishake){
      antishake=false;
      Publicmethods.loades(context,'');
      try {
        var information=await _googleSignIn.signIn();
        final GoogleSignInAuthentication googleAuth = await information!.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
        User? user = userCredential.user;
        if (user != null) {
          String? idToken = await user.getIdToken();
          // 将idToken发送给后端进行验证和处理
          var BindingResults = await SetUprovider.Thirdpartybinding(
              1, information?.displayName, information?.photoUrl,
              information?.email, information?.id, '',idToken);
          if (BindingResults.statusCode == 200) {
            Navigator.pop(context);
            Navigator.pop(context);
            Toast.toast(context, msg: "绑定成功".tr, position: ToastPostion.center);
          }else{
            Navigator.pop(context);
          }
        }
      } catch (error) {
        Navigator.pop(context);
        Toast.toast(context,msg: "绑定失败".tr,position: ToastPostion.center);
      }
      antishake=true;
    }

  }

  /// apple绑定
  Future<void> signInWithApple() async {
    if(antishake) {
      antishake=false;
      Publicmethods.loades(context,'');
      final appleProvider = AppleAuthProvider();
      var information = await FirebaseAuth.instance.signInWithProvider(
          appleProvider);
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String? idToken = await user.getIdToken();
        // 将idToken发送给后端进行验证和处理
        // print('苹果数据${idToken}');
        var BindingResults = await SetUprovider.Thirdpartybinding(3, '', '', '', information.user?.uid, '', idToken);
        if (BindingResults.statusCode == 200) {
          Navigator.pop(context);
          Navigator.pop(context);
          Toast.toast(context, msg: "绑定成功".tr, position: ToastPostion.center);
        }else{
          Navigator.pop(context);
        }
      }else{
        Navigator.pop(context);
      }
      antishake=true;
    }
  }

  ///拉新弹窗
  laxinDialoges(context) async {
    setState(() {
      laxinopen = true;
    });
    isPopupopens=true;
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          elevation:0,
          contentPadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(
                width: MediaQuery.of(context).size.width - 100,
                constraints: const BoxConstraints(
                  minHeight: 372,
                ),
                // decoration: BoxDecoration(
                //   image: DecorationImage(
                //     image: AssetImage('assets/images/gengxtc.png'),
                //     fit: BoxFit.fill, // 完全填充
                //   ),
                // ),

                child: Stack(
                  children: [
                    GestureDetector(
                      child: Image.asset(
                        'assets/images/laxintct.png',
                        fit: BoxFit.cover,
                      ),
                      onTap: () {
                        if (userLogic.token != '') {
                          FirebaseAnalytics.instance.logEvent(
                            name: "jumpwebh5",
                            parameters: {
                              "userid": userLogic.userId,
                              "uuid": userLogic.deviceData['uuid'],
                            },
                          );
                          Navigator.pop(context);
                          Get.toNamed('/public/webview',
                              arguments: '${BASE_DOMAIN}share/invite/index?token=${userLogic.token}&uuid=' +
                                  userLogic.deviceData['uuid']);
                        } else {
                          Get.toNamed('/public/loginmethod');
                          return;
                        }
                        //Get.toNamed('/public/webview',arguments: 'https://app.lanla.fun/share/invite/index?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJkeWhjIiwiYXVkIjoiIiwiaWF0IjoxNjg0MTE5MzQ5LCJuYmYiOjE2ODQxMTkzNDksImV4cCI6MTY4OTMwMzM0OSwidXNlckluZm8iOnsidXNlcl9pZCI6MTE3ODAsInRlbCI6bnVsbH19.t9f6ytFaWxxCJwxQQH5aKVcckKUTulSKNMq-M1l255I');
                      },
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: GestureDetector(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: SvgPicture.asset(
                            "assets/svg/cha.svg",
                            color: Colors.black,
                            width: 12,
                            height: 12,
                          ),
                        )
                        //,)
                        ,
                        onTap: () {
                          if (userLogic.token != '') {
                            Navigator.pop(context);
                          } else {
                            Get.toNamed('/public/loginmethod');
                            return;
                          }
                        },
                      ),
                    ),
                  ],
                ))
          ]),
        );
      },
    ).then((value) {
      // 弹窗关闭后执行的操作
      isPopupopens=false;
    });

    // return showDialog<void>(
    //   context: context,
    //   barrierDismissible: true, // user must tap button!
    //   builder: (BuildContext context) {
    //
    //     return AlertDialog(
    //       backgroundColor: Colors.transparent,
    //       contentPadding:EdgeInsets.fromLTRB(0, 0, 0, 0),
    //       shape:RoundedRectangleBorder(borderRadius:BorderRadius.all(Radius.circular(20))),
    //       content: Column(
    //           mainAxisSize: MainAxisSize.min,
    //           children: [
    //             Container(
    //               //color: Colors.transparent,
    //               //color: Colors.red,
    //               // height: 280,
    //               child:Column(
    //                 mainAxisAlignment:MainAxisAlignment.center,
    //                 children: [
    //                   Container(
    //                       width: MediaQuery.of(context).size.width-100,
    //                       //height: 311,
    //                       // decoration: BoxDecoration(
    //                       //   image: DecorationImage(
    //                       //     image: AssetImage('assets/images/gengxtc.png'),
    //                       //     fit: BoxFit.fill, // 完全填充
    //                       //   ),
    //                       // ),
    //                       child: Stack(children: [
    //                         Image.asset('assets/images/dianzanbj.png',width: MediaQuery.of(context).size.width-100,),
    //                         Positioned(
    //                           bottom: 10,
    //                           left: 0,
    //                           right: 0,
    //                           child: Column(
    //                             children: [
    //                               Text('喜欢LanLa吗？'.tr,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600),),
    //                               Container(
    //                                 width: MediaQuery.of(context).size.width-140,
    //                                 margin: EdgeInsets.fromLTRB(40, 15, 40, 0),
    //                                 child: Text('LanLa的成长需要你的支持，我们诚恳希望能得到你的鼓励与评价，因为你的每一次鼓励能让我们做得更好。'.tr,maxLines: 4,style: TextStyle(
    //                                     fontSize: 12,
    //                                     color: Color(0xff999999)
    //                                 )),
    //                               ),
    //
    //                               GestureDetector(child:Container(
    //                                 alignment: Alignment.center,
    //                                 padding: EdgeInsets.only(top: 12,bottom: 12),
    //                                 width: MediaQuery.of(context).size.width-180,
    //                                 margin: EdgeInsets.fromLTRB(40, 10, 40, 10),
    //                                 decoration: BoxDecoration(
    //                                   borderRadius: BorderRadius.circular(40),
    //                                   color: Colors.black,
    //                                   boxShadow: [
    //                                     BoxShadow(
    //                                       color: Color(0xFF55D200),
    //                                       offset: Offset(0, 1),
    //                                       blurRadius: 1,
    //                                       spreadRadius: 0,
    //                                     ),
    //                                   ],
    //                                 ),
    //
    //                                 child: Text('五星好评'.tr,style: TextStyle(color: Colors.white,),),
    //                               ),onTap: () async {
    //                                 var shuju = await SharedPreferences.getInstance();
    //                                 shuju.setBool("isevaluate", true);
    //                                 Navigator.pop(context);
    //                                 if (Platform.isAndroid) {
    //                                   _launchUniversalLinkIos(Uri.parse("market://details?id=lanla.app"));
    //                                 } else if (Platform.isIOS) {
    //                                   _launchUniversalLinkIos(Uri.parse("itms-apps://apps.apple.com/tr/app/times-tables-lets-learn/id6443484359?l=tr"));
    //                                 }
    //
    //                               },),
    //                               GestureDetector(child:Text('我要反馈与建议'.tr,style: TextStyle(color: Color(0xff999999),fontSize: 12),),onTap: () async {
    //                                 var shuju = await SharedPreferences.getInstance();
    //                                 shuju.setBool("isevaluate", true);
    //                                 Navigator.pop(context);
    //                                 //Get.toNamed('/public/loginmethod');
    //                                 Get.to(FeedbackWidget());
    //                               },),
    //                               SizedBox(height: 25,),
    //                             ],
    //                           ),
    //                         )
    //                       ],)
    //                   )
    //                 ],),),
    //           ]),
    //     );
    //   },
    // );
  }

  ///签到弹窗
  ///
  bool isAfterToday(time) {
    // 获取当前日期
    int currentTimeStamp = DateTime.now().millisecondsSinceEpoch;
    DateTime recordDate = DateTime.fromMillisecondsSinceEpoch(time);
    DateTime tomorrow = DateTime(recordDate.year, recordDate.month, recordDate.day + 1);
    int tomorrowTimeStamp = tomorrow.millisecondsSinceEpoch;
    return currentTimeStamp > tomorrowTimeStamp;

  }
  Signmechanism() async {
    var Cache = await SharedPreferences.getInstance();
    if (userLogic.token != '' && userLogic.signindata!=null){
        // if (Cache.getInt("Signintime") == null){
        //   Cache.setInt("Signintime", new DateTime.now().millisecondsSinceEpoch);
        //   Signinpopup(context);
        // }else if(isAfterToday(Cache.getInt("Signintime"))){
        //   Cache.setInt("Signintime", new DateTime.now().millisecondsSinceEpoch);
        //   Signinpopup(context);
        // }
      if (Cache.getString("Signintime")==null){
        Cache.setString("Signintime", jsonEncode({'${userLogic.userId}':DateTime.now().millisecondsSinceEpoch}));
        // Cache.setInt("Signintime", new DateTime.now().millisecondsSinceEpoch);
        Signinpopup(context);
      }else if(jsonDecode(Cache.getString("Signintime")!)['${userLogic.userId}']==null){
        Cache.setString("Signintime", jsonEncode({...jsonDecode(Cache.getString("Signintime")!),'${userLogic.userId}':DateTime.now().millisecondsSinceEpoch}));
        Signinpopup(context);
      }
      // else if(isAfterToday(Cache.getInt("Signintime"))){
      //   Cache.setInt("Signintime", new DateTime.now().millisecondsSinceEpoch);
      //   Signinpopup(context);
      // }
      else if(isAfterToday(jsonDecode(Cache.getString("Signintime")!)['${userLogic.userId}'])){
        var xinqddata=jsonDecode(Cache.getString("Signintime")!);
        xinqddata['${userLogic.userId}']=DateTime.now().millisecondsSinceEpoch;
        Cache.setString("Signintime", jsonEncode(xinqddata));
        Signinpopup(context);
      }
    }
  }
  Future<void> Signinpopup(context) async {
    isPopupopens=true;

    // assets/images/qdtanc.png
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async {
          // 在这里根据条件判断是否允许关闭对话框

          return antishake;
        },child: AlertDialog(
            backgroundColor: Colors.transparent,
            elevation:0,
            contentPadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
            content: Container(
                width: double.infinity,
                height: 400,
                child: Column(
                  children: [
                    Image.asset('assets/images/qdtanc.png', fit: BoxFit.cover,),
                    Expanded(child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(20),
                            bottomLeft: Radius.circular(20)),
                      ),
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(15, 16, 15, 16),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  ///第一天
                                  Container(
                                    width: 60,
                                    height: 60,
                                    clipBehavior: Clip.hardEdge,
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                            begin: Alignment
                                                .topCenter, //渐变开始于上面的中间开始
                                            end: Alignment
                                                .bottomCenter, //渐变结束于下面的中间
                                            colors: [
                                              userLogic.signindata.userIndex==1?const Color(0x00FFFFFF):const Color(0xFFF5F5F5),
                                              userLogic.signindata.userIndex==1?const Color(0xFFD1FF34):const Color(0xFFF5F5F5)
                                            ]),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(8))),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [

                                        Image.network(
                                          userLogic.signindata.task[0].imagePath,
                                          width: 32,
                                          height: 30,
                                        ),
                                        if((userLogic.signindata.userIndex>=1&&userLogic.signindata.userDailySignIn)||userLogic.signindata.userIndex>1)Positioned(top: 0,left: 0,right: 0,bottom:0,child: Container( alignment: Alignment.center, color: const Color.fromRGBO(0, 0, 0, 0.30),child: Image.asset('assets/images/sigindg.png',width: 30,height: 30,),)),
                                        Positioned(
                                            left: 0,
                                            top: 0,
                                            child: Container(
                                              alignment: Alignment.center,
                                              width: 20,
                                              height: 20,
                                              decoration: const BoxDecoration(
                                                  color: Colors.black,
                                                  borderRadius:
                                                  BorderRadius.only(
                                                      bottomRight:
                                                      Radius.circular(
                                                          50))),
                                              child: const Text(
                                                '1',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 11,
                                                    fontWeight:
                                                    FontWeight.w700),
                                              ),
                                            )),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 15,),
                                  ///第四天
                                  Container(
                                    width: 60,
                                    height: 60,
                                    clipBehavior: Clip.hardEdge,
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                            begin: Alignment
                                                .topCenter, //渐变开始于上面的中间开始
                                            end: Alignment
                                                .bottomCenter, //渐变结束于下面的中间
                                            colors: [
                                              userLogic.signindata.userIndex==4?const Color(0x00FFFFFF):const Color(0xFFF5F5F5),
                                              userLogic.signindata.userIndex==4?const Color(0xFFD1FF34):const Color(0xFFF5F5F5)
                                            ]),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(8))),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Image.network(
                                          userLogic.signindata.task[3].imagePath,
                                          width: 32,
                                          height: 30,
                                        ),
                                        if((userLogic.signindata.userIndex>=4&&userLogic.signindata.userDailySignIn)||userLogic.signindata.userIndex>4)Positioned(top: 0,left: 0,right: 0,bottom:0,child: Container( alignment: Alignment.center, color: const Color.fromRGBO(0, 0, 0, 0.30),child: Image.asset('assets/images/sigindg.png',width: 30,height: 30,),)),
                                        Positioned(
                                            left: 0,
                                            top: 0,
                                            child: Container(
                                              alignment: Alignment.center,
                                              width: 20,
                                              height: 20,
                                              decoration: const BoxDecoration(
                                                  color: Colors.black,
                                                  borderRadius:
                                                  BorderRadius.only(
                                                      bottomRight:
                                                      Radius.circular(
                                                          50))),
                                              child: const Text(
                                                '4',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 11,
                                                    fontWeight:
                                                    FontWeight.w700),
                                              ),
                                            )),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              Column(
                                children: [
                                  ///第二天
                                  Container(
                                    width: 60,
                                    height: 60,
                                    clipBehavior: Clip.hardEdge,
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                            begin: Alignment
                                                .topCenter, //渐变开始于上面的中间开始
                                            end: Alignment
                                                .bottomCenter, //渐变结束于下面的中间
                                            colors: [
                                              userLogic.signindata.userIndex==2?const Color(0x00FFFFFF):const Color(0xFFF5F5F5),
                                              userLogic.signindata.userIndex==2?const Color(0xFFD1FF34):const Color(0xFFF5F5F5)
                                            ]),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(8))),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Image.network(
                                          userLogic.signindata.task[1].imagePath,
                                          width: 32,
                                          height: 30,
                                        ),
                                        if((userLogic.signindata.userIndex>=2&&userLogic.signindata.userDailySignIn)||userLogic.signindata.userIndex>2)Positioned(
                                            top: 0,left: 0,right: 0,bottom:0,
                                            child: Container(
                                              alignment: Alignment.center,
                                              color: const Color.fromRGBO(0, 0, 0, 0.30),
                                              child: Image.asset('assets/images/sigindg.png',width: 30,height: 30,),)),

                                        Positioned(
                                            left: 0,
                                            top: 0,
                                            child: Container(
                                              alignment: Alignment.center,
                                              width: 20,
                                              height: 20,
                                              decoration: const BoxDecoration(
                                                  color: Colors.black,
                                                  borderRadius:
                                                  BorderRadius.only(
                                                      bottomRight:
                                                      Radius.circular(
                                                          50))),
                                              child: const Text(
                                                '2',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 11,
                                                    fontWeight:
                                                    FontWeight.w700),
                                              ),
                                            )),

                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 15,),
                                  ///第五天
                                  Container(
                                    width: 60,
                                    height: 60,
                                    clipBehavior: Clip.hardEdge,
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                            begin: Alignment.topCenter, //渐变开始于上面的中间开始
                                            end: Alignment.bottomCenter, //渐变结束于下面的中间
                                            colors: [
                                              userLogic.signindata.userIndex==5?const Color(0x00FFFFFF):const Color(0xFFF5F5F5),
                                              userLogic.signindata.userIndex==5?const Color(0xFFD1FF34):const Color(0xFFF5F5F5)
                                            ]),
                                        borderRadius: const BorderRadius.all(Radius.circular(8))),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Image.network(
                                          userLogic.signindata.task[4].imagePath,
                                          width: 32,
                                          height: 30,
                                        ),
                                        if((userLogic.signindata.userIndex>=5&&userLogic.signindata.userDailySignIn)||userLogic.signindata.userIndex>5)Positioned(top: 0,left: 0,right: 0,bottom:0,child: Container( alignment: Alignment.center, color: const Color.fromRGBO(0, 0, 0, 0.30),child: Image.asset('assets/images/sigindg.png',width: 30,height: 30,),)),
                                        Positioned(
                                            left: 0,
                                            top: 0,
                                            child: Container(
                                              alignment: Alignment.center,
                                              width: 20,
                                              height: 20,
                                              decoration: const BoxDecoration(
                                                  color: Colors.black,
                                                  borderRadius:
                                                  BorderRadius.only(
                                                      bottomRight:
                                                      Radius.circular(
                                                          50))),
                                              child: const Text(
                                                '5',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 11,
                                                    fontWeight:
                                                    FontWeight.w700),
                                              ),
                                            )),

                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              Column(
                                children: [
                                  ///第三天
                                  Container(
                                    width: 60,
                                    height: 60,
                                    clipBehavior: Clip.hardEdge,
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                            begin: Alignment
                                                .topCenter, //渐变开始于上面的中间开始
                                            end: Alignment
                                                .bottomCenter, //渐变结束于下面的中间
                                            colors: [
                                              userLogic.signindata.userIndex==3?const Color(0x00FFFFFF):const Color(0xFFF5F5F5),
                                              userLogic.signindata.userIndex==3?const Color(0xFFD1FF34):const Color(0xFFF5F5F5)
                                            ]),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(8))),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Image.network(
                                          userLogic.signindata.task[2].imagePath,
                                          width: 36,
                                          height: 36,
                                        ),
                                        if((userLogic.signindata.userIndex>=3&&userLogic.signindata.userDailySignIn)||userLogic.signindata.userIndex>3)Positioned(top: 0,left: 0,right: 0,bottom:0,child: Container( alignment: Alignment.center, color: const Color.fromRGBO(0, 0, 0, 0.30),child: Image.asset('assets/images/sigindg.png',width: 30,height: 30,),)),
                                        Positioned(
                                            left: 0,
                                            top: 0,
                                            child: Container(
                                              alignment: Alignment.center,
                                              width: 20,
                                              height: 20,
                                              decoration: const BoxDecoration(
                                                  color: Colors.black,
                                                  borderRadius:
                                                  BorderRadius.only(
                                                      bottomRight:
                                                      Radius.circular(
                                                          50))),
                                              child: const Text(
                                                '3',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 11,
                                                    fontWeight:
                                                    FontWeight.w700),
                                              ),
                                            )),

                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 15,),
                                  ///第六天
                                  Container(
                                    width: 60,
                                    height: 60,
                                    clipBehavior: Clip.hardEdge,
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                            begin: Alignment
                                                .topCenter, //渐变开始于上面的中间开始
                                            end: Alignment
                                                .bottomCenter, //渐变结束于下面的中间
                                            colors: [
                                              userLogic.signindata.userIndex==6?const Color(0x00FFFFFF):const Color(0xFFF5F5F5),
                                              userLogic.signindata.userIndex==6?const Color(0xFFD1FF34):const Color(0xFFF5F5F5)
                                            ]),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(8))),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Image.network(
                                          userLogic.signindata.task[5].imagePath,
                                          width: 32,
                                          height: 30,
                                        ),
                                        if((userLogic.signindata.userIndex>=6&&userLogic.signindata.userDailySignIn)||userLogic.signindata.userIndex>6)Positioned(top: 0,left: 0,right: 0,bottom:0,child: Container( alignment: Alignment.center, color: const Color.fromRGBO(0, 0, 0, 0.30),child: Image.asset('assets/images/sigindg.png',width: 30,height: 30,),)),
                                        Positioned(
                                            left: 0,
                                            top: 0,
                                            child: Container(
                                              alignment: Alignment.center,
                                              width: 20,
                                              height: 20,
                                              decoration: const BoxDecoration(
                                                  color: Colors.black,
                                                  borderRadius:
                                                  BorderRadius.only(
                                                      bottomRight:
                                                      Radius.circular(
                                                          50))),
                                              child: const Text(
                                                '6',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 11,
                                                    fontWeight:
                                                    FontWeight.w700),
                                              ),
                                            )),

                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              ///第七天
                              Container(
                                height: 130,
                                width: 60,
                                clipBehavior: Clip.hardEdge,
                                decoration: BoxDecoration(gradient: LinearGradient(
                                    begin: Alignment
                                        .topCenter, //渐变开始于上面的中间开始
                                    end: Alignment
                                        .bottomCenter, //渐变结束于下面的中间
                                    colors: [
                                      userLogic.signindata.userIndex==7?const Color(0x00FFFFFF):const Color(0xFFF5F5F5),
                                      userLogic.signindata.userIndex==7?const Color(0xFFD1FF34):const Color(0xFFF5F5F5)
                                    ]), borderRadius: const BorderRadius.all(Radius.circular(8))),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Column(mainAxisAlignment:MainAxisAlignment.center,children: [
                                      Image.network(
                                        userLogic.signindata.task[6].imagePath,
                                        width: 54,
                                        height: 51,
                                      ),
                                      const SizedBox(height: 5,),
                                      Text('惊喜'.tr,style: const TextStyle(fontSize: 10,color: Color(0xff666666)),)
                                    ],),
                                    if((userLogic.signindata.userIndex>=7&&userLogic.signindata.userDailySignIn)||userLogic.signindata.userIndex>7)Positioned(top: 0,left: 0,right: 0,bottom:0,child: Container( alignment: Alignment.center, color: const Color.fromRGBO(0, 0, 0, 0.30),child: Image.asset('assets/images/sigindg.png',width: 30,height: 30,),)),
                                    Positioned(
                                        left: 0,
                                        top: 0,
                                        child: Container(
                                          alignment: Alignment.center,
                                          width: 20,
                                          height: 20,
                                          decoration: const BoxDecoration(
                                              color: Colors.black,
                                              borderRadius:
                                              BorderRadius.only(
                                                  bottomRight:
                                                  Radius.circular(
                                                      50))),
                                          child: const Text(
                                            '7',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 11,
                                                fontWeight:
                                                FontWeight.w700),
                                          ),
                                        )),
                                  ],
                                ),
                              )
                            ],
                          ),
                          Expanded(child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              userLogic.signindata.userIndex>1 || userLogic.signindata.userDailySignIn?Row(mainAxisAlignment:MainAxisAlignment.center,children: [
                                Text('连续签到'.tr, style: const TextStyle(fontSize: 12, color: Color(0xff999999)),),
                                Text(userLogic.signindata.userIndex.toString(), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),),
                                Text('天得贝壳'.tr, style: const TextStyle(fontSize: 12, color: Color(0xff999999)),),
                              ],):Text(
                                '连续签到7天得贝壳'.tr,
                                style: const TextStyle(
                                    fontSize: 12, color: Color(0xff999999)),
                              ),
                              GestureDetector(child: Container(
                                decoration: const BoxDecoration(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(50)),
                                  color: Colors.black,
                                ),
                                width: 166,
                                height: 40,
                                alignment: Alignment.center,
                                child: Text(
                                  userLogic.signindata.userDailySignIn?'签到成功'.tr:'签到'.tr,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),onTap: (){
                                if(!userLogic.signindata.userDailySignIn){

                                  signbutton();
                                }else{
                                  Navigator.pop(context);
                                }
                              },)
                            ],
                          ))
                        ],
                      ),
                    )),
                    const SizedBox(height: 10,),
                    GestureDetector(child: Image.asset('assets/images/chatwo.png',width: 23,height: 23,),onTap: (){
                      Navigator.pop(context);
                    },)
                  ],
                ))
        ),);
      },
    ).then((value) {
      // 弹窗关闭后执行的操作
      isPopupopens=false;
    });
  }

  ///签到奖励弹窗
  Signinreward(context) async{
    isPopupopens=true;
    // assets/images/qdtanc.png
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
            backgroundColor: Colors.transparent,
            elevation:0,
            contentPadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
            content: Container(
                width: double.infinity,
                height: 375,
                child: Column(
                  children: [
                    Image.asset('assets/images/qdtanc.png', fit: BoxFit.cover,),
                    Expanded(child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(20),
                            bottomLeft: Radius.circular(20)),
                      ),
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                      child: Column(
                        mainAxisAlignment:MainAxisAlignment.spaceEvenly,
                        children: [
                          Image.asset('assets/images/jinglibk.png',width: 165,),

                          Row(mainAxisAlignment:MainAxisAlignment.center,children: [ Text('你获得了'.tr,), Text(Rewardamount(userLogic.signindata.task[userLogic.signindata.userIndex-1].taskRewards),style: const TextStyle(fontSize: 20,fontWeight: FontWeight.w700,color: Color(0xffFF789B)),), Text('个贝币'.tr)],)
                        ],
                      ),
                    ))
                  ],
                ))
        );
      },
    ).then((value) {
      closeRewardPopup=true;
      // 弹窗关闭后执行的操作
      isPopupopens=false;
      Future.delayed(const Duration(milliseconds: 1000), () async {
        Dailytasks(context);
      });
    });
  }

  ///奖励金额
  Rewardamount(data){
    for(var i=0;i<data.length;i++){
      if(data[i].rewardType==1&&data[i].showType==1){
        return data[i].rewardAmount;
      }
    }

  }

  ///签到
  signbutton() async{
    if(antishake){
      setState(() {
        antishake=false;
      });
      var res = await userprovider.signbutton();
      if(res.statusCode==200){
        Navigator.pop(context);
        closeRewardPopup=false;
        Signinreward(context);
        if(!closeRewardPopup){
          Timer.periodic(const Duration(milliseconds: 1000), (timer) {
            Navigator.pop(context);
            timer.cancel(); //取消定时器
          });
        }
        userLogic.signinlist();
      }
      setState(() {
        antishake=true;
      });
    }
  }


  ///每日活动
  Future<void> Dailytasks(context) async {
    isPopupopens=true;
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
            backgroundColor: Colors.transparent,
            elevation:0,
            contentPadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
            content: Container(
                width: double.infinity,
                height: 495,
                child: Column(
                  children: [
                    Image.asset('assets/images/qdtanc.png', fit: BoxFit.cover,),
                    Expanded(child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(20),
                            bottomLeft: Radius.circular(20)),
                      ),
                      width: double.infinity,
                      clipBehavior: Clip.hardEdge,
                      // padding: EdgeInsets.fromLTRB(15, 0, 15, 16),
                      child: Column(
                        children: [
                          if(taskdata.newData.length>=4)
                          for(var i=0;i<4;i++)
                            Container(padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),child: Row(
                              mainAxisAlignment:MainAxisAlignment.spaceBetween,
                              children: [
                                Row(children: [
                                  Container(width: 30,height: 30,child: Image.network(taskdata.newData[i].image,width: 30,height: 30,),),
                                  const SizedBox(width: 15,),
                                  Column(crossAxisAlignment:CrossAxisAlignment.start,children: [
                                    Text(taskdata.newData[i].summary,style: const TextStyle(fontSize: 12),),
                                    const SizedBox(height: 8,),
                                    Row(children: [
                                      Row(children: [Image.asset('assets/images/beiketwo.png',width: 16,height: 16,),const SizedBox(width: 5,),Text('${taskdata.newData[i].rewardBeans}+',strutStyle: const StrutStyle(forceStrutHeight: true, leading: 0.5,),style: const TextStyle(fontWeight: FontWeight.w700,color: Color(0xffFF789B)),)],),
                                    ],)
                                  ],)],),
                                GestureDetector(child:
                                  Container(
                                    alignment: Alignment.center,
                                    decoration: const BoxDecoration(color: Colors.black,borderRadius: BorderRadius.all(Radius.circular(50))),
                                    width: 64,height: 28,
                                    child: const Text('إكمال',style: TextStyle(fontWeight: FontWeight.w700,fontSize: 12,color: Colors.white),),
                                  ),onTap: (){
                                  if(taskdata.newData[i].jumpType==1){
                                    Navigator.of(context).pop();
                                    Future.delayed(const Duration(milliseconds: 100), (){
                                      _publishtwo(context);
                                    });
                                  }
                                  if(taskdata.newData[i].jumpType==2){
                                    Navigator.of(context).pop();
                                  }
                                },)
                              ],
                            ),),
                          if(taskdata.newData.length<4)
                          for(var i=0;i<taskdata.newData.length;i++)
                            Container(padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),child: Row(
                            mainAxisAlignment:MainAxisAlignment.spaceBetween,
                            children: [
                              Row(children: [
                                Container(width: 30,height: 30,child: Image.network(taskdata.newData[i].image,width: 30,height: 30,),),
                                const SizedBox(width: 15,),
                                Column(crossAxisAlignment:CrossAxisAlignment.start,children: [
                                  Text(taskdata.newData[i].summary,style: const TextStyle(fontSize: 12),),
                                  const SizedBox(height: 8,),
                                  Row(children: [
                                    Row(children: [Image.asset('assets/images/beiketwo.png',width: 16,height: 16,),const SizedBox(width: 5,),Text('${taskdata.newData[i].rewardBeans}+',strutStyle: const StrutStyle(forceStrutHeight: true, leading: 0.5,),style: const TextStyle(fontWeight: FontWeight.w700,color: Color(0xffFF789B)),)],),

                                  ],)
                                ],)],),
                              GestureDetector(child: Container(alignment: Alignment.center,decoration: const BoxDecoration(color: Colors.black,borderRadius: BorderRadius.all(Radius.circular(50))),width: 64,height: 28,child: const Text('إكمال',style: TextStyle(fontWeight: FontWeight.w700,fontSize: 12,color: Colors.white),),)
                                ,onTap: (){
                                if(taskdata.newData[i].jumpType==1){
                                  Navigator.of(context).pop();
                                  Future.delayed(const Duration(milliseconds: 100), (){
                                    _publishtwo(context);
                                  });
                                }
                                if(taskdata.newData[i].jumpType==2){
                                  Navigator.of(context).pop();
                                }
                              },)],
                          ),),
                          if(taskdata.newData.length<4)
                            for(var i=0;i<4-taskdata.newData.length;i++)
                              Container(padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),child: Row(
                                mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(children: [
                                    Container(width: 30,height: 30,child: Image.network(taskdata.data[i].image,width: 30,height: 30,),),
                                    const SizedBox(width: 15,),
                                    Column(crossAxisAlignment:CrossAxisAlignment.start,children: [
                                      Text(taskdata.data[i].summary,style: const TextStyle(fontSize: 12),),
                                      const SizedBox(height: 8,),
                                      Row(children: [
                                        Row(children: [Image.asset('assets/images/beiketwo.png',width: 16,height: 16,),const SizedBox(width: 5,),Text('${taskdata.data[i].rewardBeans}+',strutStyle: const StrutStyle(forceStrutHeight: true, leading: 0.5,),style: const TextStyle(fontWeight: FontWeight.w700,color: Color(0xffFF789B)),)],),
                                      ],)
                                    ],)],),
                                  GestureDetector(child:
                                  Container(alignment: Alignment.center,
                                    decoration: const BoxDecoration(color: Colors.black,borderRadius: BorderRadius.all(Radius.circular(50))),width: 64,height: 28,
                                    child: const Text('إكمال',style: TextStyle(fontWeight: FontWeight.w700,fontSize: 12,color: Colors.white),),)
                                    ,onTap: (){
                                      if(taskdata.data[i].jumpType==1){
                                        Navigator.of(context).pop();
                                        Future.delayed(const Duration(milliseconds: 100), (){
                                          _publishtwo(context);
                                        });
                                      }
                                      if(taskdata.data[i].jumpType==2){
                                        Navigator.of(context).pop();
                                      }
                                    },)
                                ],
                              ),),
                          Expanded(child:
                            GestureDetector(child: Container(
                              color: const Color(0xffF5F5F5),
                              alignment: Alignment.center,
                              child: Text(
                                '前往'.tr,style: const TextStyle(fontSize: 12,fontWeight: FontWeight.w600,color: Color(0xff666666)),),),onTap: (){
                              Navigator.of(context).pop();
                              Get.to(TaskCenterPage());
                            },))
                        ],
                      ),
                    )),
                    const SizedBox(height: 10,),
                    GestureDetector(child: Image.asset('assets/images/chatwo.png',width: 23,height: 23,),onTap: (){
                      Navigator.pop(context);
                    },)
                  ],
                ))
        );
      },
    ).then((value) {
      // 弹窗关闭后执行的操作
      isPopupopens=false;
    });
  }
    _publishtwo(context) {
    // Map<String, String> topicObject = {
    //   "name": _dataSource!.title,
    //   "id": _dataSource!.id.toString()
    // };
    Get.bottomSheet(Container(
      color: Colors.white,
      child: Wrap(
        children: [
          GestureDetector(
            onTap: () async {
              AppLog('tap', event: 'publish-camera');
              Get.back();
              final AssetEntity? result = await CameraPicker.pickFromCamera(
                context,
                pickerConfig: const CameraPickerConfig(
                    textDelegate: ArabCameraPickerTextDelegate(),
                    enableRecording: true,
                    shouldAutoPreviewVideo: true),
              );
              // 选择图片后跳转到发布页
              if (result != null) {
                Get.toNamed('/verify/publish', arguments: {"asset": result});
              }
            },
            child: Container(
              height: 70,
              alignment: Alignment.center,
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '拍摄'.tr,
                    style: const TextStyle(fontSize: 17),
                  ),
                ],
              ),
            ),
          ),
          Container(
            color: Colors.black12,
            height: 0.5,
          ),
          GestureDetector(
            onTap: () async {
              AppLog('tap', event: 'publish-picker');
              Get.back();
              final List<AssetEntity>? result = await AssetPicker.pickAssets(
                context,
                pickerConfig: const AssetPickerConfig(
                    textDelegate: ArabicAssetPickerTextDelegate()),
              );
              // 选择图片后跳转到发布页
              if (result != null && result.isNotEmpty) {
                Get.toNamed('/verify/publish',
                    arguments: {"asset": result,});
              }
            },
            child: Container(
              height: 70,
              alignment: Alignment.center,
              color: Colors.white,
              child: Text(
                '从相册选择'.tr,
                style: const TextStyle(fontSize: 17),
              ),
            ),
          ),
          Container(
            color: Colors.black12,
            height: 0.5,
          ),
          Container(
            color: Colors.black12,
            height: 8,
          ),
          GestureDetector(
            onTap: () async {
              Get.back();
            },
            child: Container(
              height: 70,
              color: Colors.white,
              child: Center(
                child: Text(
                  '取消'.tr,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    ));
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
  @override
  Widget build(BuildContext context) {
    userLogic.setUuid(context);
    DateTime? _lastTime; //上次点击时间
    return WillPopScope(
      onWillPop: () async {
        if (_lastTime == null) {
          ToastInfo("再点一次退出应用".tr);
          _lastTime = DateTime.now();
          return false;
        } else {
          if (DateTime.now().difference(_lastTime!) > const Duration(seconds: 1)) {
            _lastTime = DateTime.now();
            return false;
          }
          return true;
        }
      },
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: Colors.white,
            body: PageView(
              controller: logic.controller,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                StartPage(),
                FriendPage(),
                //MessagePage(),
                //TopPage(),
                // Pricecomparisonpage(),
                shoppingPage(),
                MePage(),
              ],
            ),
            bottomNavigationBar: SafeArea(
              child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      top: BorderSide(width: 1.0, color: HexColor('#eeeeee')),
                    ),
                  ),
                  width: 110,
                  height: 50,
                  child: Row(
                    children: [
                      Obx(() => _footIcon(0, 'home')),
                      Obx(() => _footIcon(1, 'friend')),
                       _publish(context),
                      Obx(() => _footIcon(2, 'top')),
                      Obx(() => _footIcon(3, 'me')),
                    ],
                  )),
            ),
          ),
          if (userLogic.token == '')
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              right: 0,
              child: Container(
              decoration: const BoxDecoration(
                color:Colors.white,
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(0, 54, 0, 30),
                    width: double.infinity,
                    height: 150,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.fitWidth,
                        image: AssetImage(
                            'assets/images/bjtwo.png'
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),
                  Text('您的美好生活指南！'.tr,style:const TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight:  FontWeight.w600,
                      decoration:TextDecoration.none
                  )),
                  Expanded(
                    flex: 1, child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom:20,
                        child: Column(
                          children: [
                            // GestureDetector(
                            //   child: Container(
                            //     margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                            //     height: 56,
                            //     decoration: BoxDecoration(
                            //       color: Colors.black,
                            //       borderRadius:BorderRadius.circular((46)),
                            //       boxShadow:const [
                            //         BoxShadow(
                            //           color: Color(0x33000000),
                            //           offset: Offset(0, 5),
                            //           blurRadius: 10,
                            //           spreadRadius: 1,
                            //         ),
                            //       ],
                            //     ),
                            //     child:
                            //     Stack(
                            //       children: [
                            //         Container(
                            //           width: double.infinity,
                            //           height: 56,
                            //           // decoration: BoxDecoration(border: Border.all(color: Colors.red),color: Colors.red),
                            //           child: Row(
                            //             mainAxisAlignment:MainAxisAlignment.center,
                            //             children: [
                            //               Text('Phone'.tr,style:const TextStyle(
                            //                 color: Colors.white,
                            //                 fontSize: 16,
                            //                 decoration:TextDecoration.none,
                            //                 fontWeight:  FontWeight.w600,
                            //               )),
                            //             ],
                            //           ),
                            //         ),
                            //         Positioned(
                            //           bottom: 17,
                            //           left: 60,
                            //           child: Image.asset(
                            //             'assets/images/shoujitwo.png',
                            //             width: 26,
                            //             height: 26,),
                            //         )
                            //       ],
                            //     ),
                            //   ),
                            //   onTap: (){
                            //     AppLog('tap',event:'phone_sgin');
                            //     FirebaseAnalytics.instance.logEvent(
                            //       name: "login_tap_phone",
                            //       parameters: {},
                            //     );
                            //     Get.to(LoginPage());
                            //   },
                            // ),
                            ///facebook
                            GestureDetector(
                              child: Container(
                                margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                height: 56,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius:BorderRadius.circular((46)),
                                  boxShadow:const [
                                    BoxShadow(
                                      color: Color(0x33000000),
                                      offset: Offset(0, 5),
                                      blurRadius: 10,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                                child:
                                Stack(
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      height: 56,
                                      // decoration: BoxDecoration(border: Border.all(color: Colors.red),color: Colors.red),
                                      child: Row(
                                        mainAxisAlignment:MainAxisAlignment.center,
                                        children: [
                                          Text('Facebook'.tr,style:const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            decoration:TextDecoration.none,
                                            fontWeight:  FontWeight.w600,
                                          )),
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 17,
                                      right: 60,
                                      child: Image.asset(
                                        'assets/images/facebooklogin.png',
                                        width: 22,
                                        height: 22,),
                                    )
                                  ],
                                ),
                              ),
                              onTap: () async {
                                if(antishake) {
                                  antishake=false;
                                  AppLog('tap', event: 'fb_sgin');
                                  FirebaseAnalytics.instance.logEvent(
                                    name: "login_tap_facebook",
                                    parameters: {
                                    },
                                  );
                                  await logices.signInWithFacebook(context);
                                  antishake=true;
                                }
                              },
                            ),
                            const SizedBox(height: 20),
                            Platform.isIOS?GestureDetector(
                              child: Container(
                                margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                height: 56,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius:BorderRadius.circular((46)),
                                  boxShadow:const [
                                    BoxShadow(
                                      color: Color(0x33000000),
                                      offset: Offset(0, 5),
                                      blurRadius: 10,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                                child:
                                Stack(
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      height: 56,
                                      // decoration: BoxDecoration(border: Border.all(color: Colors.red),color: Colors.red),
                                      child: Row(
                                        mainAxisAlignment:MainAxisAlignment.center,
                                        children: [
                                          Text('Apple'.tr,style:const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            decoration:TextDecoration.none,
                                            fontWeight:  FontWeight.w600,
                                          )),
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 17,
                                      right: 60,
                                      child: Image.asset(
                                        'assets/images/applelogin.png',
                                        width: 22,
                                        height: 22,),
                                    )
                                  ],
                                ),
                              ),
                              onTap: () async {
                                if(antishake) {
                                  antishake=false;
                                  AppLog('tap', event: 'apple_sgin');
                                  FirebaseAnalytics.instance.logEvent(
                                    name: "login_tap_apple",
                                    parameters: {
                                    },
                                  );
                                  await logices.signInWithApple(context);
                                  antishake=true;
                                }
                              },
                            ):GestureDetector(
                              child: Container(
                                margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                height: 56,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius:BorderRadius.circular((46)),
                                  boxShadow:const [
                                    BoxShadow(
                                      color: Color(0x33000000),
                                      offset: Offset(0, 5),
                                      blurRadius: 10,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                                child:
                                Stack(
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      height: 56,
                                      // decoration: BoxDecoration(border: Border.all(color: Colors.red),color: Colors.red),
                                      child: Row(
                                        mainAxisAlignment:MainAxisAlignment.center,
                                        children: [
                                          Text('Google'.tr,style:const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            decoration:TextDecoration.none,
                                            fontWeight:  FontWeight.w600,
                                          )),
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 17,
                                      right: 60,
                                      child: Image.asset(
                                        'assets/images/googlelogin.png',
                                        width: 22,
                                        height: 22,),
                                    )
                                  ],
                                ),
                              ),
                              onTap: () async {
                                if(antishake) {
                                  antishake=false;
                                  AppLog('tap', event: 'google_sgin');
                                  FirebaseAnalytics.instance.logEvent(
                                    name: "login_tap_google",
                                    parameters: {
                                    },
                                  );
                                  await logices.handleSignIn(context);
                                  antishake=true;
                                }
                              },
                            ),
                            const SizedBox(height: 40),
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    height: 0.5,
                                    margin: const EdgeInsets.fromLTRB(20, 0, 7, 0),
                                    color: const Color.fromRGBO(0, 0, 0, 0.5),
                                  ),
                                ),
                                Text('或'.tr,style:const TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    //fontFamily: 'PingFang SC-Regular',
                                    fontWeight:  FontWeight.w400,
                                    decoration:TextDecoration.none
                                )),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    height: 0.5,
                                    margin: const EdgeInsets.fromLTRB(7, 0, 20, 0),
                                    color: const Color.fromRGBO(0, 0, 0, 0.5),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            Row(
                              mainAxisAlignment:MainAxisAlignment.spaceEvenly,
                              children: [
                                ///apple
                                !Platform.isIOS?GestureDetector(child:Image.asset('assets/images/appleicontwo.png',width: 40,height: 40,),onTap: () async {
                                  if(antishake) {
                                    antishake=false;
                                    AppLog('tap', event: 'apple_sgin');
                                    FirebaseAnalytics.instance.logEvent(
                                      name: "login_tap_apple",
                                      parameters: {
                                      },
                                    );
                                    await logices.signInWithApple(context);
                                    antishake=true;
                                  }
                                },):
                                GestureDetector(child:Image.asset('assets/images/googicontwo.png',width: 40,height: 40,),onTap: () async {
                                  if(antishake) {
                                    antishake=false;
                                    AppLog('tap', event: 'google_sgin');
                                    FirebaseAnalytics.instance.logEvent(
                                      name: "login_tap_google",
                                      parameters: {
                                      },
                                    );
                                    await logices.handleSignIn(context);
                                    antishake=true;
                                  }
                                },),
                                // GestureDetector(child:Image.asset('assets/images/facebookicontwo.png',width: 40,height: 40,),onTap: () async {
                                //   if(antishake) {
                                //     antishake=false;
                                //     AppLog('tap', event: 'fb_sgin');
                                //     FirebaseAnalytics.instance.logEvent(
                                //       name: "login_tap_facebook",
                                //       parameters: {
                                //       },
                                //     );
                                //     await logices.signInWithFacebook(context);
                                //     antishake=true;
                                //   }
                                // },),
                                ///手机号
                                GestureDetector(child:Image.asset('assets/images/phonebottom.png',width: 40,height: 40,),onTap: () async {
                                  if(antishake) {
                                    antishake=false;
                                    // FirebaseAnalytics.instance.logEvent(
                                    //   name: "login_tap_phone",
                                    //   parameters: {},
                                    // );
                                    // Get.to(LoginPage());
                                    Get.to(MobileverificationPage());
                                    antishake=true;
                                  }
                                },),
                                ///邮箱
                                GestureDetector(child:Image.asset('assets/images/emailogin.png',width: 40,height: 40,),onTap: () async {
                                  if(antishake) {
                                    antishake=false;
                                    FirebaseAnalytics.instance.logEvent(
                                      name: "login_tap_email",
                                      parameters: {
                                      },
                                    );
                                    // await logices.signInWithFacebook(context);
                                    Get.to(emailoginPage());
                                    antishake=true;
                                  }
                                },)
                              ],
                            ),
                            const SizedBox(height: 15),
                            Container(
                              width: 280,
                              // decoration: BoxDecoration(border: Border.all(color: Colors.red)),
                              child: Column(
                                children: [
                                  Text('登录或注册意味着您同意'.tr,style:const TextStyle(
                                      color: Color(0xff999999),
                                      fontSize: 12,
                                      //fontFamily: 'PingFang SC-Regular',
                                      fontWeight:  FontWeight.w400,
                                      decoration:TextDecoration.none
                                  )),
                                  const SizedBox(height: 5,),
                                  Row(
                                    mainAxisAlignment:MainAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        child:Text('隐私政策'.tr,style:const TextStyle(
                                            color: Color(0xff000000),
                                            fontSize: 12,
                                            fontWeight:  FontWeight.w400,
                                            decoration:TextDecoration.none
                                        )),
                                        onTap: () {
                                          launchUrl(Uri.parse("https://www.lanla.app/ys.html"),mode: LaunchMode.externalApplication,);
                                        },
                                      ),
                                      Text('与'.tr,style:const TextStyle(
                                          color: Color(0xff999999),
                                          fontSize: 12,
                                          fontWeight:  FontWeight.w400,
                                          decoration:TextDecoration.none
                                      )),
                                      GestureDetector(
                                        child:Text('用户协议'.tr,style:const TextStyle(
                                            color: Color(0xff000000),
                                            fontSize: 12,
                                            fontWeight:  FontWeight.w400,
                                            decoration:TextDecoration.none
                                        )),
                                        onTap: () {
                                          launchUrl(Uri.parse("https://www.lanla.app/UserAgreement.html"), mode: LaunchMode.externalApplication,);
                                        },
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  ),


                ],
              ),
            ),)




          // if (userLogic.token == '')
          //   Positioned(
          //     left: 20,
          //     bottom: 100,
          //     right: 20,
          //     child:
          //     // Opacity(
          //     //   opacity: 0.8,
          //     //   child:
          //     Container(
          //       height: 90,
          //       decoration: BoxDecoration(
          //         //color:Colors.white70,
          //           color: Colors.white,
          //           border: Border.all(width: 3, color: Colors.black),
          //           borderRadius: BorderRadius.all(Radius.circular(20))),
          //       child: Stack(
          //         clipBehavior: Clip.none,
          //         children: [
          //           Positioned(
          //               top: -(55 / 2),
          //               child: Image.asset(
          //                 'assets/images/biaoqing.png',
          //                 width: 80,
          //                 height: 55,
          //               )),
          //           Container(
          //             height: 90,
          //             padding: EdgeInsets.only(left: 20, right: 20),
          //             child: Row(
          //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //               children: [
          //                 Expanded(
          //                     child: Text(
          //                       '登录发现更多精彩内容'.tr,
          //                       style: TextStyle(
          //                           fontWeight: FontWeight.w600, fontSize: 14),
          //                     )),
          //                 SizedBox(
          //                   width: 8,
          //                 ),
          //                 GestureDetector(
          //                   child: Container(
          //                     alignment: Alignment.center,
          //                     height: 36,
          //                     padding: EdgeInsets.only(left: 10, right: 10),
          //                     decoration: BoxDecoration(
          //                         color: Color(0xffD1FF34),
          //                         borderRadius:
          //                         BorderRadius.all(Radius.circular(50))),
          //                     child: Text(
          //                       '前往登陆'.tr,
          //                       style: TextStyle(
          //                           fontWeight: FontWeight.w600,
          //                           fontSize: 14,
          //                           color: Colors.black),
          //                     ),
          //                   ),
          //                   onTap: () {
          //                     if (!userLogic.checkUserLogin()) {
          //                       Get.toNamed('/public/loginmethod');
          //                       return;
          //                     }
          //                   },
          //                 ),
          //               ],
          //             ),
          //           )
          //         ],
          //       ),
          //     ),
          //   ),
          //),
        ],
      ),
    );
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive: // 处于这种状态的应用程序应该假设它们可能在任何时候暂停。
        break;
      case AppLifecycleState.resumed: //从后台切换前台，界面可见
        Adjust.onResume();
        AppPausedTimeTotal = DateTime.now().millisecondsSinceEpoch - AppPausedTime;
        AppPausedTime = 0;
        FirebaseAnalytics.instance.logEvent(
          name: "UserAppStatus",
          parameters: {
            "userId": userLogic.userId,
            "type":'SwitchAppBackground',
            "deviceId":userLogic.deviceId,
          },
        );
        break;
      case AppLifecycleState.paused: // 界面不可见，后台
        FirebaseAnalytics.instance.logEvent(
          name: "UserAppStatus",
          parameters: {
            "userId": userLogic.userId,
            "type":'AppEntersBackend',
            "deviceId":userLogic.deviceId,
          },
        );
        Adjust.onPause();
        AppPausedTime = DateTime.now().millisecondsSinceEpoch;
        break;
      case AppLifecycleState.detached: // APP结束时调用
        FirebaseAnalytics.instance.logEvent(
          name: "UserAppStatus",
          parameters: {
            "userId": userLogic.userId,
            "type":'AppEnd',
            "deviceId":userLogic.deviceId,
          },
        );
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Widget _publish(context) {
    return Expanded(
        flex: 4,
        child: GestureDetector(
          onTap: () {
            if (!userLogic.checkUserLogin()) {
              AppLog('tap', event: 'publish-nologin');
              Get.toNamed('/public/loginmethod');
              return;
            }
            AppLog('tap', event: 'publish');
            if (publishDataLogic.isBeingPublished) {
              AppLog('tap', event: 'publish_err_now_publish');
              ToastInfo("请等待当前发布完成".tr);
              return;
            }

            //Get.toNamed('/verify/publish');
            Get.bottomSheet(Container(
              color: Colors.white,
              child: Wrap(
                children: [
                  GestureDetector(
                    onTap: () async {
                      AppLog('tap', event: 'publish-camera');
                      FirebaseAnalytics.instance.logEvent(
                        name: "capture",
                      );
                      Get.back();
                      final AssetEntity? result =
                      await CameraPicker.pickFromCamera(
                        context,
                        pickerConfig: const CameraPickerConfig(
                            textDelegate: ArabCameraPickerTextDelegate(),
                            enableRecording: true,
                            shouldAutoPreviewVideo: true),
                      );
                      // 选择图片后跳转到发布页
                      if (result != null) {
                        Get.toNamed('/verify/publish',
                            arguments: {"asset": result});
                      }

                      SystemChrome.setSystemUIOverlayStyle(
                          const SystemUiOverlayStyle(
                            //设置状态栏颜色
                            statusBarColor: Colors.transparent,
                            statusBarIconBrightness: Brightness.dark,
                          ));
                    },
                    child: Container(
                      height: 70,
                      alignment: Alignment.center,
                      color: Colors.white,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '拍摄'.tr,
                            style: const TextStyle(fontSize: 17),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.black12,
                    height: 0.5,
                  ),
                  GestureDetector(
                    onTap: () async {
                      AppLog('tap', event: 'publish-picker');
                      FirebaseAnalytics.instance.logEvent(
                        name: "album",
                      );
                      Get.back();
                      final List<AssetEntity>? result =
                      await AssetPicker.pickAssets(
                        context,
                        pickerConfig: const AssetPickerConfig(
                            textDelegate: ArabicAssetPickerTextDelegate()),
                      );
                      // 选择图片后跳转到发布页
                      if (result != null && result.isNotEmpty) {
                        Get.toNamed('/verify/publish',
                            arguments: {"asset": result});
                      }
                    },
                    child: Container(
                      height: 70,
                      alignment: Alignment.center,
                      color: Colors.white,
                      child: Text(
                        '从相册选择'.tr,
                        style: const TextStyle(fontSize: 17),
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.black12,
                    height: 0.5,
                  ),
                  GestureDetector(
                    onTap: () async {
                      Get.back();
                      Get.to(LongraphicwritingPage());
                    },
                    child: Container(
                      height: 70,
                      alignment: Alignment.center,
                      color: Colors.white,
                      child: Text(
                        '长图文'.tr,
                        style: const TextStyle(fontSize: 17),
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.black12,
                    height: 0.5,
                  ),
                  Container(
                    color: Colors.black12,
                    height: 8,
                  ),
                  GestureDetector(
                    onTap: () async {
                      Get.back();
                    },
                    child: Container(
                      height: 70,
                      color: Colors.white,
                      child: Center(
                        child: Text(
                          '取消'.tr,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ));
          },
          child: Center(
            child: Image.asset(
              'assets/images/home/publish.png',
              fit: BoxFit.fill,
              height: 40,
            ),
          ),
        ));
  }
}


// class HomePageInner extends StatelessWidget {
//   final logic = Get.find<HomeLogic>();
//   final logices = Get.put(LoginmethodLogic());
//   final followlogic = Get.put(FriendLogic());
//   final state = Get.find<HomeLogic>().state;
//   final userLogic = Get.find<UserLogic>();
//   final publishDataLogic = Get.find<PublishDataLogic>();
//
//   /// 初始化控制器
//   late PageController pageController;
//
//   Widget _footIcon(int number, String tip) {
//     bool isActive = state.nowPage.value == number;
//     return Expanded(
//         flex: 3,
//         child: GestureDetector(
//             behavior: HitTestBehavior.translucent,
//             onTap: () {
//               if (number == 3) {
//                 if (!userLogic.checkUserLogin()) {
//                   Get.toNamed('/public/loginmethod');
//                   return;
//                 }
//                 userLogic.getUserInfo();
//               }
//               // if (number == 2) {
//               //   if (!userLogic.checkUserLogin()) {
//               //     Get.toNamed('/public/loginmethod');
//               //     return;
//               //   }
//               // }
//               if (number == 1) {
//                 if (userLogic.token == '') {
//                   Get.toNamed('/public/loginmethod');
//                   return;
//                 }
//               }
//               // _controller.jumpToPage(number);
//
//               logic.setNowPage(number);
//             },
//             child: Center(
//                 child: Image.asset(
//               isActive
//                   ? 'assets/images/home/${tip}_active.png'
//                   : 'assets/images/home/${tip}.png',
//               height: 42,
//             ))));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     userLogic.setUuid(context);
//     DateTime? _lastTime; //上次点击时间
//     return WillPopScope(
//       onWillPop: () async {
//         if (_lastTime == null) {
//           ToastInfo("再点一次退出应用".tr);
//           _lastTime = DateTime.now();
//           return false;
//         } else {
//           if (DateTime.now().difference(_lastTime!) > Duration(seconds: 1)) {
//             _lastTime = DateTime.now();
//             return false;
//           }
//           return true;
//         }
//       },
//       child: Stack(
//         children: [
//           Scaffold(
//             backgroundColor: Colors.white,
//             body: PageView(
//               controller: logic.controller,
//               physics: const NeverScrollableScrollPhysics(),
//               children: [
//                 StartPage(),
//                 FriendPage(),
//                 //MessagePage(),
//                 //TopPage(),
//                 Pricecomparisonpage(),
//                 MePage(),
//               ],
//             ),
//             bottomNavigationBar: SafeArea(
//               child: Container(
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     border: Border(
//                       top: BorderSide(width: 1.0, color: HexColor('#eeeeee')),
//                     ),
//                   ),
//                   width: 110,
//                   height: 50,
//                   child: Row(
//                     children: [
//                       Obx(() => _footIcon(0, 'home')),
//                       Obx(() => _footIcon(1, 'friend')),
//                       _publish(context),
//                       Obx(() => _footIcon(2, 'top')),
//                       Obx(() => _footIcon(3, 'me')),
//                     ],
//                   )),
//             ),
//           ),
//
//
//         // TransparentOverlay(
//         //
//         //   visible: mask,
//         //   onClose: ()=>{
//         //
//         //   },
//         // ),
//           // if (userLogic.token == '')Positioned(
//           // left: 0,
//           // top: 0,
//           // bottom: 0,
//           // right: 0,
//           // child:
//           // // Opacity(
//           // //   opacity: 0.8,
//           // //   child:
//           //   Container(
//           //     decoration: BoxDecoration(
//           //        //color:Colors.white70,
//           //     ),
//           //     child:StartPage(),
//           //
//           //   ),
//           // ),
//
//           if (userLogic.token == '')
//             Positioned(
//               left: 20,
//               bottom: 100,
//               right: 20,
//               child:
//                   // Opacity(
//                   //   opacity: 0.8,
//                   //   child:
//                   Container(
//                 height: 90,
//                 decoration: BoxDecoration(
//                     //color:Colors.white70,
//                     color: Colors.white,
//                     border: Border.all(width: 3, color: Colors.black),
//                     borderRadius: BorderRadius.all(Radius.circular(20))),
//                 child: Stack(
//                   clipBehavior: Clip.none,
//                   children: [
//                     Positioned(
//                         top: -(55 / 2),
//                         child: Image.asset(
//                           'assets/images/biaoqing.png',
//                           width: 80,
//                           height: 55,
//                         )),
//                     Container(
//                       height: 90,
//                       padding: EdgeInsets.only(left: 20, right: 20),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Expanded(
//                               child: Text(
//                             '登录发现更多精彩内容'.tr,
//                             style: TextStyle(
//                                 fontWeight: FontWeight.w600, fontSize: 14),
//                           )),
//                           SizedBox(
//                             width: 8,
//                           ),
//                           GestureDetector(
//                             child: Container(
//                               alignment: Alignment.center,
//                               height: 36,
//                               padding: EdgeInsets.only(left: 10, right: 10),
//                               decoration: BoxDecoration(
//                                   color: Color(0xffD1FF34),
//                                   borderRadius:
//                                       BorderRadius.all(Radius.circular(50))),
//                               child: Text(
//                                 '前往登陆'.tr,
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.w600,
//                                     fontSize: 14,
//                                     color: Colors.black),
//                               ),
//                             ),
//                             onTap: () {
//                               if (!userLogic.checkUserLogin()) {
//                                 Get.toNamed('/public/loginmethod');
//                                 return;
//                               }
//                             },
//                           ),
//                         ],
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             ),
//           //),
//         ],
//       ),
//     );
//   }
//
//   Widget _publish(context) {
//     return Expanded(
//         flex: 4,
//         child: GestureDetector(
//           onTap: () {
//             if (!userLogic.checkUserLogin()) {
//               AppLog('tap', event: 'publish-nologin');
//               Get.toNamed('/public/loginmethod');
//               return;
//             }
//             AppLog('tap', event: 'publish');
//             if (publishDataLogic.isBeingPublished) {
//               AppLog('tap', event: 'publish_err_now_publish');
//               ToastInfo("请等待当前发布完成".tr);
//               return;
//             }
//
//             //Get.toNamed('/verify/publish');
//             Get.bottomSheet(Container(
//               color: Colors.white,
//               child: Wrap(
//                 children: [
//                   GestureDetector(
//                     onTap: () async {
//                       AppLog('tap', event: 'publish-camera');
//                       Get.back();
//                       final AssetEntity? result =
//                           await CameraPicker.pickFromCamera(
//                         context,
//                         pickerConfig: CameraPickerConfig(
//                             textDelegate: ArabCameraPickerTextDelegate(),
//                             enableRecording: true,
//                             shouldAutoPreviewVideo: true),
//                       );
//                       // 选择图片后跳转到发布页
//                       if (result != null) {
//                         Get.toNamed('/verify/publish',
//                             arguments: {"asset": result});
//                       }
//                       print('退出页面');
//
//                       SystemChrome.setSystemUIOverlayStyle(
//                           const SystemUiOverlayStyle(
//                         //设置状态栏颜色
//                         statusBarColor: Colors.transparent,
//                         statusBarIconBrightness: Brightness.dark,
//                       ));
//                     },
//                     child: Container(
//                       height: 70,
//                       alignment: Alignment.center,
//                       color: Colors.white,
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           Text(
//                             '拍摄'.tr,
//                             style: TextStyle(fontSize: 17),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   Container(
//                     color: Colors.black12,
//                     height: 0.5,
//                   ),
//                   GestureDetector(
//                     onTap: () async {
//                       AppLog('tap', event: 'publish-picker');
//                       Get.back();
//                       final List<AssetEntity>? result =
//                           await AssetPicker.pickAssets(
//                         context,
//                         pickerConfig: const AssetPickerConfig(
//                             textDelegate: ArabicAssetPickerTextDelegate()),
//                       );
//                       print('选择照片');
//                       // 选择图片后跳转到发布页
//                       if (result != null && result.isNotEmpty) {
//                         Get.toNamed('/verify/publish',
//                             arguments: {"asset": result});
//                       }
//                     },
//                     child: Container(
//                       height: 70,
//                       alignment: Alignment.center,
//                       color: Colors.white,
//                       child: Text(
//                         '从相册选择'.tr,
//                         style: TextStyle(fontSize: 17),
//                       ),
//                     ),
//                   ),
//                   Container(
//                     color: Colors.black12,
//                     height: 0.5,
//                   ),
//                   Container(
//                     color: Colors.black12,
//                     height: 8,
//                   ),
//                   GestureDetector(
//                     onTap: () async {
//                       Get.back();
//                     },
//                     child: Container(
//                       height: 70,
//                       color: Colors.white,
//                       child: Center(
//                         child: Text(
//                           '取消'.tr,
//                           style: TextStyle(fontSize: 16),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ));
//           },
//           child: Center(
//             child: Image.asset(
//               'assets/images/home/publish.png',
//               fit: BoxFit.fill,
//               height: 40,
//             ),
//           ),
//         ));
//   }
// }
