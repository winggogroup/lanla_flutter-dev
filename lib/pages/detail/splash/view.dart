import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lanla_flutter/common/controller/UserLogic.dart';
import 'package:lanla_flutter/models/splash.dart';
import 'package:lanla_flutter/pages/detail/splash/app_lifecycle_reactor.dart';
import 'package:lanla_flutter/pages/detail/splash/app_open_ad_manager.dart';
import 'package:lanla_flutter/services/splash.dart';
import 'package:lanla_flutter/ulits/app_log.dart';

/// 开屏页
class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final provider = Get.put(SplashProvider());
  SplashModel? adDataSource;
  Timer? time;
  final userLogic = Get.put(UserLogic());// 是否正在请求接口
  //
  // late AppLifecycleReactor _appLifecycleReactor;
  var _appOpenAd=null;
  String adUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/3419835294'
      : 'ca-app-pub-3940256099942544/5662855259';
  @override
  void initState() {
    super.initState();
    //loadAd();
    // AppOpenAdManager appOpenAdManager = AppOpenAdManager()..loadAd();
    // _appLifecycleReactor =
    //     AppLifecycleReactor(appOpenAdManager: appOpenAdManager);
    // _appLifecycleReactor.listenToAppStateChanges();
    AppLog('splash', event: 'start');
    // if(Platform.isIOS){
    //   time = Timer(const Duration(seconds: 3), () {
    //     AppLog('splash', event: 'end');
    //     //到时回调
    //     Get.offAllNamed('/public');
    //   });
    //   return ;
    // }
    time = Timer(const Duration(seconds: 5), () {
      AppLog('splash', event: 'end');
      //到时回调
      Get.offAllNamed('/public');
    });
    _getAd();
  }
  void dispose() {
    super.dispose();


  }

  void loadAd() {
    _appOpenAd =AppOpenAd.load(
      adUnitId: adUnitId,
      orientation: AppOpenAd.orientationPortrait,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          // _appOpenAd = ad;
          ad.show();

          // Future.delayed(Duration(seconds: 5), () {
          //   Navigator.of(context).pop();
          // });
          setState(() {

          });
        },
        onAdFailedToLoad: (error) {

        },
      ),
    );
    // _appOpenAd.load();

  }

  _getAd() async {
    List<SplashModel> re = await provider.getAd();
    if (re.isEmpty) {
      return;
    }
    adDataSource = re[0];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
        ),
        backgroundColor: Colors.white,
        body: adDataSource != null
            ? _ad()
            : Center(
                child: Image.asset(
                  'assets/images/splash/lanla.png',
                  fit: BoxFit.fill,
                ),
              ));
  }

  _ad() {
    return GestureDetector(
      onTap: (){
        FirebaseAnalytics.instance.logEvent(
          name: "spreaditstail_click",
          parameters: {
            'userId':userLogic.userId,
            'deviceId':userLogic.deviceId,
          },
        );
        time?.cancel();
        Get.offAllNamed('/public',arguments: adDataSource);
      },
      child: SizedBox(
        width: MediaQuery.of(context).size.width, // 屏幕宽度
        height: MediaQuery.of(context).size.height, // 屏幕高度
        child: CachedNetworkImage(
          imageUrl: adDataSource!.imagePath,
          fit: BoxFit.cover,
          placeholder: (context, url) => Padding(padding: const EdgeInsets.only(top: 80),
          child: Column(children: const [CircularProgressIndicator(color: Colors.black,)],)),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
      ),
    );
  }
}
