import 'dart:io';

import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lanla_flutter/pages/home/start/detail_view/view.dart';

class HomeGridAd extends StatefulWidget{
  int index;
  int userId;
  ApiType type;
  HomeGridAd(this.index, this.userId, this.type, {super.key});

  @override
  State<HomeGridAd> createState() => _HomeGridAd();
}

class _HomeGridAd extends State<HomeGridAd>{
  BannerAd? _anchoredAdaptiveAd;
  bool _isLoaded = false;
  var Advertisingname='';
  void initState() {
    super.initState();
    print('加载广告');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadAd();
  }
  @override
  void dispose() {
    super.dispose();
    _anchoredAdaptiveAd?.dispose();
  }


  Future<void> _loadAd() async {
    // Get an AnchoredAdaptiveBannerAdSize before loading the ad.
    final AnchoredAdaptiveBannerAdSize? size =
    await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
        MediaQuery.of(context).size.width.truncate());

    if (size == null) {
      print('Unable to get height of anchored banner.');
      return;
    }

    _anchoredAdaptiveAd = BannerAd(
      adUnitId: Platform.isAndroid
          ? 'ca-app-pub-3760009728541770/4856902282'
          : 'ca-app-pub-3760009728541770/1476894622',
      // size: AdSize(width: (context.width / 2 - 6).toInt(),height: ((context.width / 2 - 6)*1.5).toInt()),
      size: AdSize.largeBanner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          print('$ad loaded: ${ad.responseInfo}');
          if(ad.responseInfo?.mediationAdapterClassName=='com.google.ads.mediation.unity.UnityAdapter'){
            Advertisingname='com.google.ads.mediation.unity.UnityAdapter';
          }
          FirebaseAnalytics.instance.logEvent(
            name: "adLoad",
            parameters: {
              "userId":widget.userId,
              "type":widget.type.toString(),
              "index":widget.index,
            },
          );
          setState(() {
            _anchoredAdaptiveAd = ad as BannerAd;
            _isLoaded = true;
          });
        },
        // Called when an ad opens an overlay that covers the screen.
        onAdOpened: (Ad ad) {
          FirebaseAnalytics.instance.logEvent(
            name: "adOpen",
            parameters: {
              "userId":widget.userId,
              "type":widget.type.toString(),
              "index":widget.index,
            },
          );
        },
        // Called when an ad removes an overlay that covers the screen.
        onAdClosed: (Ad ad) {
          FirebaseAnalytics.instance.logEvent(
            name: "adClose",
            parameters: {
              "userId":widget.userId,
              "type":widget.type.toString(),
              "index":widget.index,
            },
          );
        },
        // Called when an impression occurs on the ad.

        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          FirebaseAnalytics.instance.logEvent(
            name: "adFailed",
            parameters: {
              "userId":widget.userId,
              "type":widget.type.toString(),
              "index":widget.index,
            },
          );
          print('Anchored adaptive banner failedToLoad: $error');
          ad.dispose();
        },
      ),
    );
    return _anchoredAdaptiveAd!.load();
  }
  @override
  Widget build(BuildContext context) {
    if(_anchoredAdaptiveAd != null && _isLoaded){
      return Container(
        color: const Color(0xffefefef),
        width: (context.width / 2 - 6),
        height: Advertisingname=='com.google.ads.mediation.unity.UnityAdapter'?_anchoredAdaptiveAd?.size.height.toDouble():(context.width / 2 - 6)*1.5,
        child: AdWidget(ad: _anchoredAdaptiveAd!),
      );
    }
    return Container(
      width: 0,
      height: 0,
      color: const Color(0xffefefef),
    );
    // return
    //   Container(
    //   // color: const Color(0xffefefef),
    //   // width: (context.width / 2 - 6),
    //   // height: (context.width / 2 - 6)*1.5,
    //   child: FacebookBannerAd(
    //     placementId: "776625517584154_776633887583317", // 替换为您的广告单元 ID
    //     bannerSize: BannerSize.STANDARD,
    //     listener: (result, value) {
    //       switch (result) {
    //         case BannerAdResult.ERROR:
    //           print("Errorfaceboook: $value");
    //           break;
    //         case BannerAdResult.CLICKED:
    //           print("Clicked");
    //           break;
    //         case BannerAdResult.LOGGING_IMPRESSION:
    //           print("Logging Impression");
    //           break;
    //       }
    //     },
    //   ),
    // );
  }

}