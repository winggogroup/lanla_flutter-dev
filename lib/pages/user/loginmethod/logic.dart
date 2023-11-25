import 'dart:async';
import 'dart:convert';

import 'package:adjust_sdk/adjust.dart';
import 'package:adjust_sdk/adjust_config.dart';
import 'package:adjust_sdk/adjust_event.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lanla_flutter/common/controller/UserLogic.dart';
import 'package:lanla_flutter/common/toast/view.dart';
import 'package:lanla_flutter/pages/home/view.dart';
import 'package:lanla_flutter/pages/publish/view.dart';
import 'package:lanla_flutter/pages/user/reference/index.dart';
import 'package:lanla_flutter/pages/user/set_information/view.dart';
import 'package:lanla_flutter/services/login.dart';
import 'package:lanla_flutter/services/user_home.dart';
import 'package:lanla_flutter/ulits/app_log.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'state.dart';


GoogleSignIn _googleSignIn = GoogleSignIn(
  //实例化
  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/userinfo.profile',
  ],
);
class LoginmethodLogic extends GetxController {
   @override
  void onReady() {
    // TODO: implement onReady
     FirebaseAnalytics.instance.logEvent(
       name: "login_view",
       parameters: {
       },
     );
    super.onReady();
  }
  final LoginmethodState state = LoginmethodState();
  //引入修改个人信息的文件
  final userLogic =  Get.find<UserLogic>();
  LoginProvider provider =  Get.put(LoginProvider());
  UserHomeProvider InvitationCodeprovider =  Get.put(UserHomeProvider());
   bool antishake=true;
  ///google
  Future<void> handleSignIn(context) async {
    var nowTime=DateTime.now().millisecondsSinceEpoch;
    FirebaseAnalytics.instance.logEvent(
      name: "login_google",
      parameters: {},
    );
     var information;
    try {
      load(context);
       information=await _googleSignIn.signIn();
      //var information=await _googleSignIn.signIn();
      AppLog('sgin_res',event: 'google',data: information?.id??'');
      if(information?.id!=null){
        final GoogleSignInAuthentication googleAuth = await information.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
        User? user = userCredential.user;
        if (user != null) {
          String? idToken = await user.getIdToken();
          // 将idToken发送给后端进行验证和处理
          print('谷歌数据${idToken}');
        var result = await provider.Googlelogin(information?.id,information?.displayName,information?.photoUrl,information?.email,information?.serverAuthCode,userLogic.sourcePlatform,idToken);


        AppLog('api_res',event: 'google',data: result.bodyString??"");
        Map<String, dynamic> responseData = jsonDecode(result?.bodyString.toString() ??'');
        FirebaseAnalytics.instance.logEvent(
          name: "login_google_user",
          parameters: {
            "statusCode":result.statusCode,
            'body':result.bodyString,
            "userId":responseData["userId"],
            "userStatus":responseData["userStatus"],
          },
        );
        if(result.statusCode==200){
          var sp = await SharedPreferences.getInstance();
          sp.setString("token", responseData["token"]["refreshToken"]);
          sp.setInt("userId", responseData["userId"]);
          sp.setString("userAvatar", responseData["userAvatar"]);
          sp.setString("userName", responseData["userName"]);
          userLogic.modify(responseData["token"]["refreshToken"],responseData["userId"],responseData["userAvatar"],responseData["userName"]);
          if(responseData["userStatus"]=='2'){
            FirebaseAnalytics.instance.logEvent(
              name: "adjust_token",
              parameters: {
                "userId": responseData["userId"],
                "sourcePlatform":userLogic.sourcePlatform,
                "deviceId":userLogic.deviceId,
              },
            );
            // FirebaseAnalytics.instance.logEvent(
            //   name: "google_sign_time",
            //   parameters: {
            //     "userId": responseData["userId"],
            //     "sourcePlatform":userLogic.sourcePlatform,
            //     "sec": DateTime.now().millisecondsSinceEpoch-nowTime,
            //   },
            // );
            AdjustEvent myAdjustEvent = AdjustEvent('6ykn6j');
            myAdjustEvent.addCallbackParameter('userId',responseData["userId"].toString());
            Adjust.trackEvent(myAdjustEvent);
            // Get.to(SetInformationPage());
            if(userLogic.Invitationcodes!=''){
              Fillinvitationcode(userLogic.Invitationcodes,context);
            }
            Get.offAll(ReferencePage());
            return ;
          }else if(responseData["userStatus"]=='1'){
            Get.offAll(HomePage());
            return ;
          }
          // var bean={'phone':Get.arguments["phone"],'area_code':Get.arguments["area_code"]};
        }
        Navigator.pop(context);
        }
      }else{
        Navigator.pop(context);
        Toast.toast(context,msg: "登录失败".tr,position: ToastPostion.center);
        return ;
      }

    } catch (error) {
      FirebaseAnalytics.instance.logEvent(
        name: "login_google_error",
        parameters: {
          'error':error
        },
      );
      AppLog('login_err',event: 'google',data: error.toString()??"");
      Navigator.pop(context);
      Toast.toast(context,msg: "登录失败".tr,position: ToastPostion.center);
      return ;
    }
  }

  ///facebook
  Future<void> signInWithFacebook(context) async {
    FirebaseAnalytics.instance.logEvent(
      name: "login_facebook",
      parameters: {},
    );
    load(context);
    // Trigger the sign-in flow
    final LoginResult result = await FacebookAuth.instance.login(); // by default we request the email and the public profile
    AppLog('sgin_res',event: 'fb',data: result.status.toString());
    if (result.status == LoginStatus.success) {
      var dataes = await provider.Facebooklogin(result.accessToken?.token,userLogic.sourcePlatform);
      AppLog('api_res',event: 'fb',data: dataes.bodyString??"");
      Map<String, dynamic> responseData = jsonDecode(dataes?.bodyString.toString() ??'');
      FirebaseAnalytics.instance.logEvent(
        name: "login_facebook_user_success",
        parameters: {
          "statusCode":dataes.statusCode,
          'body':dataes.bodyString,
          "userId":responseData["userId"],
          "userStatus":responseData["userStatus"],
        },
      );
      if(dataes.statusCode==200){
        var sp = await SharedPreferences.getInstance();
        sp.setString("token", responseData["token"]["refreshToken"]);
        sp.setInt("userId", responseData["userId"]);
        sp.setString("userAvatar", responseData["userAvatar"]);
        sp.setString("userName", responseData["userName"]);
        userLogic.modify(responseData["token"]["refreshToken"],responseData["userId"],responseData["userAvatar"],responseData["userName"]);
        AppLog('login_success',event: 'fb');
        if(responseData["userStatus"]=='2'){
          Navigator.pop(context);
          FirebaseAnalytics.instance.logEvent(
            name: "adjust_token",
            parameters: {
              "userId": responseData["userId"],
              "sourcePlatform":userLogic.sourcePlatform,
              "deviceId":userLogic.deviceId,
            },
          );
          AdjustEvent myAdjustEvent = AdjustEvent('6ykn6j');
          myAdjustEvent.addCallbackParameter('userId',responseData["userId"].toString());
          Adjust.trackEvent(myAdjustEvent);

          // Get.to(SetInformationPage());
          if(userLogic.Invitationcodes!=''){
            Fillinvitationcode(userLogic.Invitationcodes,context);
          }
          Get.offAll(ReferencePage());
        }else{
          Navigator.pop(context);
          Get.offAll(HomePage());
        }
        // var bean={'phone':Get.arguments["phone"],'area_code':Get.arguments["area_code"]};
      }else{
        Navigator.pop(context);
      }
    } else {
      AppLog('login_err',event: 'fb',data: result.status.toString()??"");
      FirebaseAnalytics.instance.logEvent(
        name: "login_facebook_error",
        parameters: {
          'error':result.status.toString()
        },
      );
      Navigator.pop(context);
      Toast.toast(context,msg: "登录失败".tr,position: ToastPostion.center);
    }

  }
  ///apple
  Future<void> signInWithApple(context) async {
    FirebaseAnalytics.instance.logEvent(
      name: "login_apple",
      parameters: {},
    );
    try {
      load(context);
      final appleProvider = AppleAuthProvider();
      var information=await FirebaseAuth.instance.signInWithProvider(appleProvider);
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String? idToken = await user.getIdToken();
        // 将idToken发送给后端进行验证和处理
        print('苹果数据${idToken}');

      AppLog('sgin_res',event: 'apple',data: information.user?.uid??'');
      FirebaseAnalytics.instance.logEvent(
        name: "login_apple_instance_result",
        parameters: {
          'uid':information.user?.uid??'nouser'
        },
      );
      var result = await provider.Applelogin(information.user?.uid??'',information.user?.displayName??'',information.user?.photoURL??'',information.user?.email??'',userLogic.sourcePlatform,idToken);
      AppLog('api_res',event: 'apple',data: result.bodyString??"");
      Map<String, dynamic> responseData =  jsonDecode(result?.bodyString.toString() ??'');
      FirebaseAnalytics.instance.logEvent(
        name: "login_apple_server_result",
        parameters: {
          "statusCode":result.statusCode,
          'body':result.bodyString,
          "userId":responseData["userId"],
          "userStatus":responseData["userStatus"],
        },
      );
      if(result.statusCode==200){
        var sp = await SharedPreferences.getInstance();
        sp.setString("token", responseData["token"]["refreshToken"]);
        sp.setInt("userId", responseData["userId"]);
        sp.setString("userAvatar", responseData["userAvatar"]);
        sp.setString("userName", responseData["userName"]);
        userLogic.modify(responseData["token"]["refreshToken"],responseData["userId"],responseData["userAvatar"],responseData["userName"]);
        if(responseData["userStatus"]=='2'){
          Navigator.pop(context);
          FirebaseAnalytics.instance.logEvent(
            name: "adjust_token",
            parameters: {
              "userId": responseData["userId"],
              "sourcePlatform":userLogic.sourcePlatform,
              "deviceId":userLogic.deviceId,
            },
          );
          AdjustEvent myAdjustEvent = AdjustEvent('6ykn6j');
          myAdjustEvent.addCallbackParameter('userId',responseData["userId"].toString());
          Adjust.trackEvent(myAdjustEvent);
          Future.delayed(Duration.zero, () {
            // Get.to(SetInformationPage());
            if(userLogic.Invitationcodes!=''){
              Fillinvitationcode(userLogic.Invitationcodes,context);
            }
            Get.offAll(ReferencePage());
          });
        }else{
          Navigator.pop(context);
          Future.delayed(Duration.zero, () {
            Get.offAll(HomePage());
          });
        }
        // var bean={'phone':Get.arguments["phone"],'area_code':Get.arguments["area_code"]};
      }else{
        Navigator.pop(context);
      }
      }

    } catch (error){
      FirebaseAnalytics.instance.logEvent(
        name: "login_apple_error",
        parameters: {'error':error.toString()},
      );
      Navigator.pop(context);
      Toast.toast(context,msg: "登录失败".tr,position: ToastPostion.center);
    }
    //load(context);
  }

   ///填写邀请码
   Fillinvitationcode(code,context) async {
     if(antishake){
       antishake=false;
       var result = await InvitationCodeprovider.getinviteCode(code);
       if(result ==200){
         Toast.toast(context, msg: "填写成功".tr, position: ToastPostion.bottom);
       }

       Timer.periodic(Duration(milliseconds: 1000),(timer){
         antishake=true;
         timer.cancel();//取消定时器
       });
       //
     }
   }

  ///弹窗
  Future<void> load(context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new LoadingDialog(text: '',
          );
        });
  }
   @override
   void onClose() {
     super.onClose();
     FirebaseAnalytics.instance.logEvent(
       name: "close_login",
       parameters: {},
     );
   }
}


