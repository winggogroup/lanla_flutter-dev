import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lanla_flutter/common/controller/UserLogic.dart';
import 'package:lanla_flutter/ulits/base_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  @override
  _WebViePageState createState() => _WebViePageState();
}

class _WebViePageState extends State<WebViewPage> {
  String Url = '';
  WebViewController? _webViewController;
  bool _canGoBack = false;
  final userLogic = Get.find<UserLogic>();
  @override
  void initState() {
    super.initState();
    // Enable virtual display.
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
    Url = Get.arguments;
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        //消除阴影
        backgroundColor: Colors.white,
        //设置背景颜色为白色
        centerTitle: true,
        leading: IconButton(
            color: Colors.black,
            icon: Icon(Icons.arrow_back_ios),
            tooltip: "Search",
            onPressed: () {
              //print('menu Pressed');
              //Navigator.of(context).pop();
              if (_canGoBack) {
                _webViewController?.goBack();
              } else {
                Navigator.of(context).pop();
              }
            }),
        title: Text('邀请奖励'.tr, style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          //fontFamily: ' PingFang SC-Semibold, PingFang SC',
        ),),
      ),
      body: Url == '' ? const Text('loading') : WebView(
        onProgress:(int a){

        },
        initialUrl: Url,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (controller) {
          _webViewController = controller;
          _webViewController!.canGoBack().then((value) {
            setState(() {
              _canGoBack = value ?? false;
            });
          });
        },
        navigationDelegate: (NavigationRequest request) {
          // 拦截WebView的跳转事件
          var url=BASE_DOMAIN+"share/invite/Sharingpage?InvitationCode="+userLogic.userId.toString();
          ///whatsapp
          if (request.url.startsWith('https://api.whatsapp.com/')) {
            // 执行你的逻辑
            _launchUniversalLinkIos(Uri.parse('whatsapp://send?text=$url'),Uri.parse('https://api.whatsapp.com/send?text=$url'));
            // 可以通过return NavigationDecision.prevent可以阻止WebView的跳转
            return NavigationDecision.prevent;
          }
          ///tiktok
          if (request.url.startsWith('https://www.tiktok.com/share')) {
            // 执行你的逻辑

            _launchUniversalLinkIos(Uri.parse('tiktok://share?text=$url'),Uri.parse('https://www.tiktok.com'));
            // 可以通过return NavigationDecision.prevent可以阻止WebView的跳转
            return NavigationDecision.prevent;
          }
          ///Facebook
          if (request.url.startsWith('https://www.facebook.com/sharer/sharer.php')) {
            // 执行你的逻辑

            _launchUniversalLinkIos(Uri.parse('fb-messenger://share/?link=$url'),Uri.parse('https://m.me/share?url=$url'));
            // 可以通过return NavigationDecision.prevent可以阻止WebView的跳转
            return NavigationDecision.prevent;
          }
          ///Snapchat
          if (request.url.startsWith('https://www.snapchat.com/share')) {
            // 执行你的逻辑


            _launchUniversalLinkIos(Uri.parse('snapchat://share'),Uri.parse('https://www.snapchat.com/share'));
            // 可以通过return NavigationDecision.prevent可以阻止WebView的跳转
            return NavigationDecision.prevent;
          }
          ///Telegram
          if (request.url.startsWith('https://t.me/share/url')) {
            // 执行你的逻辑

            _launchUniversalLinkIos(Uri.parse('tg://msg_url?url=$url'),Uri.parse('https://t.me/share/url?url=$url'));
            // 可以通过return NavigationDecision.prevent可以阻止WebView的跳转
            return NavigationDecision.prevent;
          }
          ///Instagram
          if (request.url.startsWith('https://www.instagram.com/share')) {
            // 执行你的逻辑

            _launchUniversalLinkIos(Uri.parse('https://www.instagram.com/'),Uri.parse('https://www.instagram.com'));
            // 可以通过return NavigationDecision.prevent可以阻止WebView的跳转
            return NavigationDecision.prevent;
          }
          ///whatsapp群聊
          if (request.url.startsWith('https://chat.whatsapp.com/JOkTwPHR1OvIgRu2uUjokW')) {
            // 执行你的逻辑
            _launchUniversalLinkIos(Uri.parse('https://chat.whatsapp.com/JOkTwPHR1OvIgRu2uUjokW'),Uri.parse('https://chat.whatsapp.com/JOkTwPHR1OvIgRu2uUjokW'));
            // 可以通过return NavigationDecision.prevent可以阻止WebView的跳转
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
        onPageFinished: (_) {
          _webViewController?.canGoBack().then((value) {
            setState(() {
              _canGoBack = value ?? false;
            });
          });
        },
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     if (_canGoBack) {
      //       _webViewController?.goBack();
      //     } else {
      //       Navigator.of(context).pop();
      //     }
      //   },
      //   child: Icon(_canGoBack ? Icons.arrow_back : Icons.close),
      // ),
    );
  }
  Future<void> _launchUniversalLinkIos(Uri url,Uri httpurl) async {
    try {
      final bool nativeAppLaunchSucceeded = await launchUrl(
        url,
        mode: LaunchMode.externalNonBrowserApplication,
      );
      // 失败后使用浏览器打开,未捕捉到异常时
      if(!nativeAppLaunchSucceeded){
        bool isUrl = await launchUrl(httpurl,mode: LaunchMode.externalApplication,);
        if(!isUrl){
        }
      }


    } catch(e) {

      // 失败后使用浏览器打开,未捕捉到异常时
      await launchUrl(httpurl,mode: LaunchMode.externalApplication,);
      // await launchUrl(
      //   httpurl,
      //   mode: LaunchMode.inAppWebView,
      // );
    }

    //启动APP 功能。可以带参数，如果启动原生的app 失败


    //启动失败的话就使用应用内的webview 打开
  }
}
