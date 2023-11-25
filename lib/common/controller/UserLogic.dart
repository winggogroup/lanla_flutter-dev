import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:adjust_sdk/adjust.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lanla_flutter/common/toast/view.dart';
import 'package:lanla_flutter/models/signindatalist.dart';
import 'package:lanla_flutter/pages/home/logic.dart';
import 'package:lanla_flutter/pages/home/view.dart';
import 'package:lanla_flutter/pages/user/Loginmethod/view.dart';
import 'package:lanla_flutter/services/content.dart';
import 'package:lanla_flutter/services/content.dart';
import 'package:lanla_flutter/services/user.dart';
import 'package:lanla_flutter/services/user_home.dart';
import 'package:lanla_flutter/ulits/app_log.dart';
import 'package:lanla_flutter/ulits/base_provider.dart';
import 'package:lanla_flutter/ulits/toast.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:lanla_flutter/models/UserFocus.dart';
import 'package:lanla_flutter/models/UserInfo.dart';

class UserLogic extends GetxController {
  // final contentProvider = Get.put(ContentProvider());
  // ContentProvider contentProvider = Get.put(ContentProvider());
  // UserHomeProvider InvitationCodeprovider =  Get.put(UserHomeProvider());
  String token = '';
  String userAvatar = '';
  String userName = '';
  String slogan = '';
  String birthday = '';
  String appVersion = '';
  String appBuildNumber = '';
  int Sex = 1;
  int userId = 0;
  String Uuid = '';
  List<int> likes = [];
  List<int> collects = [];
  List<int> follows = []; // 所有关注的人
  List<int> blacklist = [];
  late final UserProvider provider=Get.put(UserProvider());
  UserInfoMode? userInfo = null;
  Map<String, dynamic> deviceData = <String, dynamic>{};
  bool isDeviceInfoReady = false;
  int NumberMessages = 0;
  var Chatrelated= {};
  String sourcePlatform='';
  var Realtimeconnection=false;
  var Chatdisconnected=false;
  var signindata;
  var gradedata;
  String Invitationcodes='';
  bool isshowFillincode=true;
  bool DurationTimer =false;
  var deviceId;
  var sourcePlatformall;
  bool isbindingopen=true;
  @override
  void onInit() async {
    super.onInit();
    var sp = await SharedPreferences.getInstance();
    PackageInfo info = await PackageInfo.fromPlatform();
    getReferrer();
    appVersion = info.version;
    appBuildNumber = info.buildNumber;
    if (Platform.isAndroid) {
      var build = await deviceInfoPlugin.androidInfo;
      deviceId = build.id;
      adid = build.id;
      // deviceId =  build.manufacturer;
    } else if (Platform.isIOS) {
      var iosbuild = await deviceInfoPlugin.iosInfo;
      deviceId = iosbuild.identifierForVendor;
      adid = iosbuild.identifierForVendor;
    }
    if (sp.getString("token") != null) {
      token = sp.getString("token")!;
      //token='';
    }
    if (sp.getString("userAvatar") != null) {
      userAvatar = sp.getString("userAvatar")!;
    }
    if (sp.getString("userName") != null) {
      userName = sp.getString("userName")!;
    }
    if (sp.getInt("userId") != null) {
      userId = sp.getInt("userId")!;
      if(userId != 0){
        await FirebaseAnalytics.instance.setUserId(id: userId.toString());
        getUserInfo();
        signinlist();
        Personallevel();
      }
    }
    if(sp.getString("sourcePlatform") != null){

      sourcePlatform=sp.getString("sourcePlatform")!;
    }

    if(sp.getString("Signinall") != null){
      Chatrelated=jsonDecode(sp.getString("Signinall")!);

    }

   // provider = Get.put(UserProvider());
    _setUserFocusOnData();
    _initDevice();
  }

  logout() async {
    var sp = await SharedPreferences.getInstance();
    sp.setString("token", '');
    sp.setString("userAvatar", '');
    sp.setString("userName", '');
    sp.setInt("userId", 0);
    token = '';
    userName = '';
    userAvatar = '';
    userId = 0;
    Chatdisconnected =false;
    userInfo = null;
    update();

    Get.offAll(HomePage());
  }
  ///问题用户
  Problemuser() async {
    var sp = await SharedPreferences.getInstance();
    sp.setString("token", '');
    sp.setString("userAvatar", '');
    sp.setString("userName", '');
    sp.setInt("userId", 0);
    token = '';
    userName = '';
    userAvatar = '';
    userId = 0;
    Chatdisconnected =false;
    update();
    Get.find<HomeLogic>().setNowPage(0);
    Get.offAll(LoginmethodPage());
}

  setUuid(context) async {}

  Future<void> showCustomTrackingDialog(BuildContext context) async =>
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('عزيزي المستخدم'),
          content: const Text(
              'نحن نهتم بخصوصيتك وأمان بياناتك. نحافظ على هذا التطبيق مجانيًا من خلال عرض الإعلانات. '
              'هل يمكننا الاستمرار في استخدام بياناتك لتخصيص الإعلانات لك؟ يمكنك تغيير اختيارك في أي وقت في إعدادات التطبيق. '),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('يكمل'),
            ),
          ],
        ),
      );

  cancelAccount() async {
    Response result = await provider.cancelAccount();
    if(result.statusCode != 200){
      return ;
    }
    await logout();
  }

  Future<void> modify(tokens, userIds, userAvatars, userNames) async {
    token = tokens;
    userAvatar = userAvatars;
    userName = userNames;
    userId = userIds;
    update();
    _setUserFocusOnData();
    signinlist();
    Personallevel();
    getUserInfo();
    final fcmToken = await FirebaseMessaging.instance.getToken();
    // print('pushtoken');
    // Adjust.setPushToken(fcmToken!);
    // print(fcmToken);
    await provider.pushtokentwo(fcmToken,await createDynamicLinkes(userIds));
    //_setUserFocusOnData();
    await FirebaseAnalytics.instance.setUserId(id: userIds.toString());
  }

  ///生成firebase深度链接
  Future<String>createDynamicLinkes(userid) async {
    final DynamicLinkParameters dynamicLinkParams = DynamicLinkParameters(
      uriPrefix: 'https://lanla.page.link',
      link: Uri.parse('http://lanla.app/testLink?Referrer=$userid'),
      androidParameters: const AndroidParameters(
        packageName: 'lanla.app',
      ),
      iosParameters: const IOSParameters(
        bundleId: 'lanla.app',
          appStoreId:'6443484359',
      ),
    );
    final dynamicLink =
    await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams);
    final dynamicUrl = dynamicLink.shortUrl.toString();
    // print('长动态链接：${dynamicUrl}');
    return dynamicUrl;
  }
  ///安装渠道
   getReferrer() async {
    try {
      ///深层链接进来app在初次启动的时候触发
      final PendingDynamicLinkData? data =
      await FirebaseDynamicLinks.instance.getInitialLink();
      final Uri? deepLink = data?.link;
      // print('监听到的深层链接${deepLink}');
      if (deepLink != null) {
        final referrerParam = deepLink.queryParameters['Referrer'];
        if(referrerParam!=null){
          Invitationcodes=referrerParam;
          isshowFillincode=false;
          update();
        }
        else if(deepLink.queryParameters["targetOther"]!=null){
          if(deepLink.queryParameters["targetOther"]=='/public/video' || deepLink.queryParameters["targetOther"]=='/public/picture'|| deepLink.queryParameters["targetOther"] == '/public/xiumidata'){
            Get.toNamed(deepLink.queryParameters["targetOther"]!,arguments:  {
              'data':  int.parse(deepLink.queryParameters['targetId']!),
              'isEnd': false
            });
          }else{
            Get.toNamed(deepLink.queryParameters["targetOther"]!,arguments: int.parse(deepLink.queryParameters['targetId']!));
          }
        }

      }
      ///深层链接进来app在前台或者后台时触发
      FirebaseDynamicLinks.instance.onLink.listen(
            (pendingDynamicLinkData) async {

          // Set up the `onLink` event listener next as it may be received here
          final Uri deepLinkes = pendingDynamicLinkData.link;
          // print('监听到的深层链接${deepLinkes}');
          // Example of using the dynamic link to push the user to a different screen
          final referrerParam = deepLinkes.queryParameters['Referrer'];
          // print('邀请码链接${deepLinkes}');
          if(referrerParam!=null) {
            Invitationcodes = referrerParam;
            isshowFillincode = false;
            update();
          } else if(deepLinkes.queryParameters["targetOther"]!=null){
            if(deepLinkes.queryParameters["targetOther"]=='/public/video' || deepLinkes.queryParameters["targetOther"]=='/public/picture'|| deepLinkes.queryParameters["targetOther"] == '/public/xiumidata'){
              Get.toNamed(deepLinkes.queryParameters["targetOther"]!,arguments:  {
                'data':  int.parse(deepLinkes.queryParameters['targetId']!),
                'isEnd': false
              });
            }else{
              Get.toNamed(deepLinkes.queryParameters["targetOther"]!,arguments: int.parse(deepLinkes.queryParameters['targetId']!));
            }
          }
        },
      );

    } catch (e) {}
  }

  void setToken(userToken) {
    token = userToken;
  }

  ///归因token
  Future<void> ascribeto(trackerName,sourcePlatforms,adid) async {
    var sp = await SharedPreferences.getInstance();
    sp.setString("sourcePlatform", '$trackerName''_$sourcePlatforms''_$adid');
    sourcePlatform = '$trackerName''_$sourcePlatforms''_$adid';
    // print('辊印来了${sourcePlatform}');
  }
  ///归因打点
  Future<void> ascribetoclick(trackerName,sourcePlatforms,adid,network,campaign,adgroup,creative,clickLabel,costType,costAmount,costCurrency,fbInstallReferrer) async {
    FirebaseAnalytics.instance.logEvent(
      name: "information_click",
      parameters: {
        'trackerName':trackerName,
        'sourcePlatforms':sourcePlatforms,
        'adid':adid,
        'network':network,
        'campaign':campaign,
        'adgroup':adgroup,
        'creative':creative,
        'clickLabel':clickLabel,
        'costType':costType,
        'costAmount':costAmount,
        'costCurrency':costCurrency,
        'fbInstallReferrer':fbInstallReferrer
      },
    );
    sourcePlatformall={
      'trackerName':trackerName,
      'sourcePlatforms':sourcePlatforms,
      'adid':adid,
      'network':network,
      'campaign':campaign,
      'adgroup':adgroup,
      'creative':creative,
      'clickLabel':clickLabel,
      'costType':costType,
      'costAmount':costAmount,
      'costCurrency':costCurrency,
      'fbInstallReferrer':fbInstallReferrer
    };
  }

  // 获取用户关注数据，点赞、收藏、关注人信息
  _setUserFocusOnData() async {
    if (userId == 0) {
      return;
    }
    Response res = await provider.getUserFocusOnData();

    if (res.statusCode != 200 && res.bodyString != null) {
      logout();
      ToastInfo('登录失效了,请重新登录'.tr);
      return;
    }
    UserFocus model = userFocusFromJson(res.bodyString!);
    likes = model.likes;
    collects = model.collects;
    follows = model.follows;
  }

  // 获取是否点赞
  bool getLike(int id) {
    return likes.contains(id);
  }

  // 获取是否关注
  bool getFollow(int id) {
    return follows.contains(id);
  }

  // 获取是否收藏
  bool getCollect(int id) {
    return collects.contains(id);
  }

  // 获取是否拉黑
  bool getBlack(int id) {
    return blacklist.contains(id);
  }

  // 将用户拉黑
  bool setBlack(int id) {
    provider.setBlack(id,1);
    if (!blacklist.contains(id)) {
      blacklist.add(id);
    }
    return true;
  }

  // 解除用户拉黑
  bool setNotBlack(int id) {
    provider.setBlack(id,2);
    blacklist.remove(id);
    return true;
  }

  // 设置最新状态：true为点赞，false取消点赞
  bool setLike(int id) {
    if (userId == 0) {
      // 登录
      Get.toNamed('/public/loginmethod');
      return false;
    }
    provider.setLike(id);
    if (likes.contains(id)) {
      likes.remove(id);
      return false;
    }
    likes.add(id);
    return true;
  }
  ///保存聊天信息
  SaveChat() async {
    var sp = await SharedPreferences.getInstance();
    sp.setString("Signinall", jsonEncode(Chatrelated));
  }
  ///清除未读消息数
  Clearunread(i){
    if(Chatrelated['$userId']['Unreadmessagezs']>0){
      Chatrelated['$userId']['Unreadmessagezs']=Chatrelated['$userId']['Unreadmessagezs']-Chatrelated['$userId']['Chatlist'][i]['Messagesnum'];
    }
    Chatrelated['$userId']['Chatlist'][i]['Messagesnum']=0;
    update();
    SaveChat();
  }

  /// TODO 未登录时候点一下，页面上会减一个 出现bug
  // 设置关注状态：true为已关注，false取消关注
   setFollow(int id)  {
    if (userId == 0) {
      // 登录
      Get.toNamed('/public/loginmethod');
      return false;
    }
    provider.setFollow(id);
    if (follows.contains(id)) {
      follows.remove(id);
      userInfo?.concern--;
      update();
      return false;
    }
    follows.add(id);
    userInfo?.concern++;
    update();
    return true;
  }
  ///修改关注列表
  modifyFollow(int id)  {
    if (userId == 0) {
      // 登录
      Get.toNamed('/public/loginmethod');
      return false;
    }
    if (follows.contains(id)) {
      follows.remove(id);
      userInfo?.concern--;
      update();
      return false;
    }
    follows.add(id);
    userInfo?.concern++;
    update();

    return true;
  }


  ///多关注
  setFollowall(id)  async {
    if (userId == 0) {
      // 登录
      Get.toNamed('/public/loginmethod');
      return false;
    }
    var res = await provider.batchFollow(id);
    if(res.statusCode==200){
      // follows.addAll(id.split(','));
      for(var i=0;i<id.split(',').length;i++){
        follows.add(int.parse(id.split(',')[i]));
        userInfo?.concern++;
      }
      update();
    }
    return true;
  }

  // 设置收藏状态：true为已关注，false取消关注
  bool setCollect(int id) {
    if (userId == 0) {
      // 登录
      Get.toNamed('/public/loginmethod');
      return false;
    }
    provider.setCollect(id);
    if (collects.contains(id)) {
      collects.remove(id);
      return false;
    }
    collects.add(id);
    return true;
  }

  bool checkUserLogin() {
    if (userId == 0) {
      return false;
    }
    return true;
  }

  ///消息数量
  operatioNews(num){
    NumberMessages=0;
    NumberMessages=num;
    update();
  }
  ///清空消息
  emptyNews(){
    NumberMessages=0;
    update();
  }
  getUserInfo() async {

    UserInfoMode? data = await provider.getUserInfo(userId);

    if (data != null) {
      userAvatar = data.avatar;
      userName = data.userName;
      slogan = data.slogan;
      birthday = data.birthday;
      Sex = data.sex;
      userInfo = data;
      update();
    }
  }

  ///签到列表
    signinlist() async {
     var res = await provider.dailyCheckInTaskList();
     if(res.statusCode==200){
       signindata=signindatalistFromJson(res.bodyString!) ;
       update();
     }
    }

    ///个人等级
  Personallevel() async {
    var res = await provider.dailyTaskUserInfo();
    if(res.statusCode==200){
      gradedata=res.body;
      update();
    }
  }



  _initDevice() async {
    provider.appRecord(99, '-');
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    AndroidDeviceInfo? androidInfo;
    IosDeviceInfo? iosInfo;
    if (Platform.isIOS) {
      iosInfo = await deviceInfoPlugin.iosInfo;
    } else {
      androidInfo = await deviceInfoPlugin.androidInfo;
    }
    isDeviceInfoReady = true;
    deviceData = _readDeviceInfo(androidInfo, iosInfo);
    BaseDeviceInfo infoa = await deviceInfoPlugin.deviceInfo;
    provider.appRecord(0, jsonEncode(infoa.data));
    AppLog('startApp');
  }


  _readDeviceInfo(
      AndroidDeviceInfo? androidInfo, IosDeviceInfo? iosInfo) {
    Map<String, dynamic> data = <String, dynamic>{
      //手机品牌加型号
      "brand": Platform.isIOS
          ? iosInfo?.name
          : "${androidInfo?.brand} ${androidInfo?.model}",
      //当前系统版本
      "systemVersion": Platform.isIOS
          ? iosInfo?.systemVersion
          : androidInfo?.version.release,
      //系统名称
      "Platform": Platform.isIOS ? iosInfo?.systemName : "Android",
      //是不是物理设备
      "isPhysicalDevice": Platform.isIOS
          ? iosInfo?.isPhysicalDevice
          : androidInfo?.isPhysicalDevice,
      //用户唯一识别码
      "uuid": Platform.isIOS
          ? iosInfo?.identifierForVendor
          : androidInfo?.id,
      //手机具体的固件型号/Ui版本
      "incremental": Platform.isIOS
          ? iosInfo?.systemVersion
          : androidInfo?.version.incremental,
    };
    return data;
  }
}
