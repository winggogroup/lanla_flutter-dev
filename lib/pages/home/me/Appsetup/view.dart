import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lanla_flutter/pages/home/me/Appsetup/Aboutus.dart';
import 'package:lanla_flutter/pages/home/start/detail_view/logic.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../common/controller/UserLogic.dart';
import '../../../../common/toast/view.dart';
import '../../logic.dart';
import 'AccountSecurity.dart';
import 'Feedback.dart';

class AppsetupWidget extends StatelessWidget {
  final userLogic = Get.find<UserLogic>();
  final WebSocketes = Get.find<StartDetailLogic>();
  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
      appBar: AppBar(
        title: Text(
          '设置'.tr,
          style: TextStyle(fontSize: 16),
        ),
      ),
      body: Container(
        //decoration: BoxDecoration(border: Border.all(color: Colors.red,width: 1)),
        padding: EdgeInsets.fromLTRB(20, 23, 20, 0),
        color: Color(0xffF5F5F5),
        child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            decoration:BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            child: Column(
              children: [
                GestureDetector(child: Container(
                  padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                  child: Row(
                    mainAxisAlignment:MainAxisAlignment.spaceBetween,
                    children: [
                      Text('账号与安全'.tr),
                      Icon(Icons.chevron_right,)
                    ],
                  ) ,
                ),onTap: (){
                  Get.to(AccountSecurityWidget());
                },) ,
                Divider(height: 1.0,color: Color(0xffF1F1F1),),
                GestureDetector(child: Container(
                  padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                  child: Row(
                    mainAxisAlignment:MainAxisAlignment.spaceBetween,
                    children: [
                      Text('关于我们'.tr),
                      Icon(Icons.chevron_right,)
                    ],
                  ) ,
                ),onTap: (){
                  Get.to(AboutusWidget());
                },) ,
                Divider(height: 1.0,color: Color(0xffF1F1F1),),
                GestureDetector(child: Container(
                  padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                  child: Row(
                    mainAxisAlignment:MainAxisAlignment.spaceBetween,
                    children: [
                      Text('意见反馈'.tr),
                      Icon(Icons.chevron_right,)
                    ],
                  ) ,
                ),onTap: (){
                  Get.to(FeedbackWidget());
                },) ,
                Divider(height: 1.0,color: Color(0xffF1F1F1),),
                ///鼓励一下
                GestureDetector(child: Container(
                  padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                  child: Row(
                    mainAxisAlignment:MainAxisAlignment.spaceBetween,
                    children: [
                      Text('鼓励一下'.tr),
                      Icon(Icons.chevron_right,)
                    ],
                  ) ,
                ),onTap: (){

                  if (Platform.isAndroid) {
                    _launchUniversalLinkIos(Uri.parse("market://details?id=lanla.app"));
                  } else if (Platform.isIOS) {
                    _launchUniversalLinkIos(Uri.parse("itms-apps://apps.apple.com/tr/app/times-tables-lets-learn/id6443484359?l=tr"));
                  }



                  // Get.to(FeedbackWidget());
                },) ,
                Divider(height: 1.0,color: Color(0xffF1F1F1),),
                GestureDetector(child: Container(
                  padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                  child: Row(
                    mainAxisAlignment:MainAxisAlignment.spaceBetween,
                    children: [
                      Text('清除缓存'.tr),
                      Icon(Icons.chevron_right,)
                    ],
                  ) ,
                ),onTap: (){
                  Toast.toast(context,msg: "清除成功".tr,position: ToastPostion.center);
                },) ,
                Divider(height: 1.0,color: Color(0xffF1F1F1),),
                GestureDetector(child: Container(
                  padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                  child: Row(
                    mainAxisAlignment:MainAxisAlignment.spaceBetween,
                    children: [
                      Text('填写邀请码'.tr),
                      Icon(Icons.chevron_right,)
                    ],
                  ) ,
                ),onTap: (){
                  Get.toNamed('/verify/InvitationCode');
                  //Toast.toast(context,msg: "清除成功".tr,position: ToastPostion.center);
                },) ,
              ],
            ),
          ),
        ],)
      ),
      bottomNavigationBar: Container(
        color: Color(0xffF5F5F5),
        padding: EdgeInsets.all(50),
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Color(0xff000000)),
          ),
          onPressed: () async {
            userLogic.logout();
            Navigator.pop(context);
            WebSocketes.channel.sink.close();
            // userLogic.Chatdisconnected=false;
            Get.find<HomeLogic>().setNowPage(0);
          },
          child: Text('退出登录'.tr,style: TextStyle(
            fontSize: 17,
            color: Colors.white,
          ),textAlign: TextAlign.center,),
        ),
      ),
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
}