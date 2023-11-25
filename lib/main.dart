import 'dart:io';
import 'dart:math';

import 'package:adjust_sdk/adjust.dart';
import 'package:adjust_sdk/adjust_attribution.dart';
import 'package:adjust_sdk/adjust_config.dart';
import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lanla_flutter/routers.dart';
import 'package:lanla_flutter/translations_cn.dart';
import 'package:lanla_flutter/ulits/routing_callback.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'common/controller/UserLogic.dart';
import 'firebase_options.dart';
import 'global_bindings.dart';

String? uuid = "";
String afuid = "";

@pragma('vm:entry-point')
Future<void> myBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('监听到了');
  // return MyAppState()._showNotification(message);
}

Future<void> main() async {
// import Log
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize().then((initializationStatus) {
    initializationStatus.adapterStatuses.forEach((key, value) {
      print('Adapter status for $key: ${value.description}');
    });
  });

  ///初始化unity
  // UnityAds.init(
  //   gameId: '5358773',
  //   testMode:true,
  //   onComplete: () => print('Initialization Complete'),
  //   onFailed: (error, message) => print('Initialization Failed123: $error $message'),
  // );
  // UnityMediation.initialize(
  //   gameId: '5358773',
  //   onComplete: () => print('Initialization Complete'),
  //   onFailed: (error, message) => print('Initialization Failed: $error $message'),
  // );

  // MobileAds.instance.updateRequestConfiguration(
  //     RequestConfiguration(testDeviceIds: ['ED6849B5DCE8089C70BDE02C4F95CCC4']));

  ///初始化facebook广告
  // FacebookAudienceNetwork.init(
  //     // testingId: "fe93bf55-de60-4170-9730-07dec1ff8c1a", //optional
  //     // iOSAdvertiserTrackingEnabled: true //default false
  // );
  // ///初始化tt广告
  // await pangle.init(
  //   // iOS: IOSConfig(appId: kAppId),
  //   android: AndroidConfig(appId: '8148618'),
  // );
  //GOOGLE firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Pass all uncaught errors from the framework to Crashlytics.
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  // 优先处理用户信息
  UserLogic userLogic = Get.put(UserLogic(), permanent: true);
  await start(userLogic);
  print('go333');
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // 获取用户的唯一id
  var sp = await SharedPreferences.getInstance();
  uuid = sp.getString("uuid");
  if (uuid == null) {
    uuid = getRandom(16);
    await sp.setString('uuid', uuid!);
  }
  Dio().get(
      'https://app.log.lanla.app/?action=initApp&platform=${Platform.isIOS ? 'ios' : 'android'}&luuid=${uuid ?? "-"}');

  // /// 启动appsflyer
  // AppsFlyerOptions appsFlyerOptions = AppsFlyerOptions(
  //     afDevKey: 'bTAi489ddKHiRaKHujp7Z9',
  //     appId: '6443484359',
  //     showDebug: true,
  //     timeToWaitForATTUserAuthorization: 15, // for iOS 14.5
  // ); // Optional field
  // AppsflyerSdk appsflyerSdk = AppsflyerSdk(appsFlyerOptions);
  // appsflyerSdk.initSdk(
  //     registerConversionDataCallback: true,
  //     registerOnAppOpenAttributionCallback: true,
  //     registerOnDeepLinkingCallback: true
  // );
  // await initAppsflyer();
  /// 启动appsflyer结束
  await Adjustes(userLogic);
  Adjust.setPushToken(
      "AAAAiLqhZ1g:APA91bElS4lfd3VA45fdeYDwctsTsgwd3gPmwLMalTZHJXBr2TdnuW3l3C0UnNAW-9aTf4plXOG8itw9cxLzPtZ0m08zLOP51RlxEqU0Ye9b4pKHdvCTXU2F5j9EJTgA1LeYeAcu4RYW");
  final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

  await WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(myBackgroundHandler);
  runApp(GetMaterialApp(
    translations: TranslationsCNMap(),
    initialRoute: '/splash',
    locale: const Locale('ar', 'AR'),
    // 没有语言时将会按照此处指定的语言翻译
    fallbackLocale: const Locale('en', 'US'),
    // 添加一个回调语言选项，以备上面指定的语言翻译不存在
    getPages: Routers.getPages,
    initialBinding: GlobalBindings(),
    theme: ThemeData(
      //ThemeData.light
      fontFamily: 'DroidArabicKufi',
      platform: TargetPlatform.iOS,
      brightness: Brightness.light,
      useMaterial3: true,
      primaryColor: Colors.green,
    ),
    builder: EasyLoading.init(),
    navigatorObservers: [routeObserver],
    routingCallback: RoutingCallback,
  ));
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    //设置状态栏颜色
    statusBarColor: Colors.white,
  ));
}

Future<int> start(UserLogic controller) async {
  print('go1111');
  var sp = await SharedPreferences.getInstance();
  var userToken = sp.get("token");
  controller.setToken(userToken ?? "");
  print('go222');
  return 1;
}

initAppsflyer() async {
  print('请求权限');
  if (await Permission.appTrackingTransparency.request().isGranted) {
    print('成功授权');
  } else {
    print('不成功授权');
  }

  final AppsFlyerOptions options = AppsFlyerOptions(
    afDevKey: 'bTAi489ddKHiRaKHujp7Z9',
    appId: '6443484359',
    showDebug: true,
    timeToWaitForATTUserAuthorization: 15,
  );
  AppsflyerSdk _appsflyerSdk = AppsflyerSdk(options);
  _appsflyerSdk.initSdk(
      registerConversionDataCallback: true,
      registerOnAppOpenAttributionCallback: true,
      registerOnDeepLinkingCallback: true);
  _appsflyerSdk.onAppOpenAttribution((res) {
    print("onAppOpenAttribution res: $res");
  });
  _appsflyerSdk.onInstallConversionData((res) {
    print("onInstallConversionData res: $res");
  });
  _appsflyerSdk.onDeepLinking((res) {
    print("onDeepLinking res: $res");
  });
  var af_uid = await _appsflyerSdk.getAppsFlyerUID();
  print("af_uid$af_uid");
  if (af_uid != null) {
    afuid = af_uid;
  }
}

/// Adjust
Adjustes(userLogic) async {
  AdjustConfig config =
      AdjustConfig('pk97eiez4glc', AdjustEnvironment.production);
  config.attributionCallback = (AdjustAttribution attributionChangedData) {
    print(
        '顺么数据${attributionChangedData.fbInstallReferrer}，${attributionChangedData.trackerToken}，${attributionChangedData.adid}');
    //if (attributionChangedData.trackerToken != null) {
    userLogic.ascribeto(attributionChangedData.trackerName,
        attributionChangedData.trackerToken, attributionChangedData.adid);
    userLogic.ascribetoclick(
      attributionChangedData.trackerName,
      attributionChangedData.trackerToken,
      attributionChangedData.adid,
      attributionChangedData.network,
      attributionChangedData.campaign,
      attributionChangedData.adgroup,
      attributionChangedData.creative,
      attributionChangedData.clickLabel,
      attributionChangedData.costType,
      attributionChangedData.costAmount,
      attributionChangedData.costCurrency,
      attributionChangedData.fbInstallReferrer,
    );
    // print('[Adjust]: Tracker token: ' + attributionChangedData.trackerToken);
    //}
  };
  config.logLevel = AdjustLogLevel.error;
  // config.defaultTracker= 'pk97eiez4glc';
  Adjust.start(config);
}

/*
  * 生成固定长度的随机字符串
  * */
String getRandom(int num) {
  String alphabet = 'qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM';
  String left = '';
  for (var i = 0; i < num; i++) {
    left = left + alphabet[Random().nextInt(alphabet.length)];
  }
  return left;
}
