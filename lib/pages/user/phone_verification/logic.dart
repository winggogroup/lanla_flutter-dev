import 'dart:async';
import 'dart:convert';

import 'package:adjust_sdk/adjust.dart';
import 'package:adjust_sdk/adjust_event.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:lanla_flutter/pages/publish/view.dart';
import 'package:lanla_flutter/pages/user/phone_verification/view.dart';
import 'package:lanla_flutter/pages/user/reference/index.dart';
import 'package:lanla_flutter/services/user_home.dart';
import 'package:lanla_flutter/ulits/app_log.dart';

import '../../../common/controller/UserLogic.dart';
import '../../home/view.dart';
import 'state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../common/toast/view.dart';
import '../set_information/view.dart';
//接口管理的文件
import 'package:lanla_flutter/services/content.dart';
class PhoneVerificationLogic extends GetxController {
  final PhoneVerificationState state = PhoneVerificationState();
  //引入修改个人信息的文件
  final userLogic =  Get.find<UserLogic>();
  //实例化
  ContentProvider provider = Get.put(ContentProvider());
  UserHomeProvider InvitationCodeprovider =  Get.put(UserHomeProvider());
  bool antishake=true;
  var status=true;
  void onInit(){
    super.onInit();
    print(Get.arguments);
  }
  @override
  void onReady() {
    super.onReady();

    if(Get.arguments["verificationId"]!=''&&Get.arguments["verificationId"]!=null){
      state.clicks.value=false;
      startTimer();
    }else{
      print('aly验证');
      state.clicks.value=true;
      state.aly=true;
      state.ownyanzhneg.value=true;
    }
  }
  //获取验证码
  void SendVerificationCode (context) async{
    var phone=Get.arguments["phone"];
    var area_code=Get.arguments["area_code"];
    print('1122${state.aly}');
    // if(state.aly){
    //   load(context);
    //   var result = await provider.SendVerificationCode(phone, area_code);
    //   FirebaseAnalytics.instance.logEvent(
    //     name: "login_phone_resend_result",
    //     parameters: {
    //       "phone": phone,
    //       "area_code":area_code,
    //       'statusCode':result.statusCode,
    //       'body':result.bodyString
    //     },
    //   );
    //   if(result.statusCode==200){
    //     startTimer();
    //     state.ownyanzhneg.value=true;
    //     Navigator.pop(context);
    //   }else{
    //     state.clicks.value=true;
    //     Navigator.pop(context);
    //   }
    // }else{
    if(phone!=''&&area_code!='') {
      state.aly=true;
      // firebase 登录
      FirebaseAuth auth = FirebaseAuth.instance;
      print(auth.verifyPhoneNumber);
      load(context);
      AppLog('firebase_login_success',data:'+${area_code}__$phone');
      await auth.verifyPhoneNumber(
        phoneNumber: '+$area_code$phone',
        verificationCompleted: (PhoneAuthCredential credential) async {
          AppLog('firebase_login_callback',event: "verificationCompleted",data:'+${area_code}__$phone');
          Navigator.pop(context);
          // await auth.signInWithCredential(credential);
          await auth.signInWithCredential(credential).then((sha) async {
            if(sha.user?.uid!=''&&sha.user?.uid!=null){
              AppLog('firebase_login_callback',event: "success",data:'+${area_code}__$phone');
              FirebaseAnalytics.instance.logEvent(
                name: "login_firebase_login_callback_success_re",
                parameters: {
                  "uid": sha.user!.uid,
                },
              );
              User? user = sha.user;

              String? idToken = await user?.getIdToken();
              if (idToken != null) {
                // 将idToken发送给后端进行验证和处理
                print('手机号$idToken');
                firebaseverification(context,idToken);
              }else{
                Toast.toast(context,msg: "验证失败".tr,position: ToastPostion.center);
              }

            }else{
              FirebaseAnalytics.instance.logEvent(
                name: "login_firebase_login_callback_error_re",
                parameters: {
                  "error": '没有uid',
                },
              );
              Toast.toast(context,msg: "验证失败".tr,position: ToastPostion.center);
            }
          },onError: (e) {
            FirebaseAnalytics.instance.logEvent(
              name: "login_phone_tap_verify_error",
              parameters: {
                'error':e.code
              },
            );
            Toast.toast(context,msg: "验证失败".tr,position: ToastPostion.center);
          });

        },
        verificationFailed: (FirebaseAuthException e) {
          AppLog('firebase_login_callback',event: "verificationFailed",data:'+${area_code}__$phone error:${e.code}');
          FirebaseAnalytics.instance.logEvent(
            name: "login_firebase_login_callback_error_re",
            parameters: {
              "error": e.code,
            },
          );
          print('bbb$e');
          state.clicks.value=true;
          Navigator.pop(context);
          print(e.code);
          if(e.code=='invalid-phone-number'){
            Toast.toast(context,msg: "无效手机号".tr,position: ToastPostion.center);
          }else if(e.code=='too-many-requests'){
            Toast.toast(context,msg: "请求太多".tr,position: ToastPostion.center);
          }
          else{
            Toast.toast(context,msg: "程序出错".tr,position: ToastPostion.center);
          }
        },
        // 发送验证码
        codeSent: (String verificationId, int? resendToken) async {
          AppLog('firebase_login_callback',event: "codeSent",data:'+${area_code}__$phone');
          FirebaseAnalytics.instance.logEvent(
            name: "login_phone_codeSent_re",
            parameters: {
              "verificationId": verificationId,
              "resendToken":resendToken ?? ''
            },
          );
          //String smsCode = '111223';
          startTimer();
          Navigator.pop(context);
          state.verificationId=verificationId;
          // // Create a PhoneAuthCredential with the code
          // PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode);
          // var sha=await auth.signInWithCredential(credential);
          // print('ccc');
          // print(sha);
          //
          // print(verificationId);
          // print('token');
          // print(resendToken);
        },
        timeout: const Duration(seconds: 10),
        codeAutoRetrievalTimeout: (String verificationId) {
          print('ddd');
          print(verificationId);
          FirebaseAnalytics.instance.logEvent(
            name: "login_phone_code_timeout_re",
            parameters: {
              "verificationId": verificationId,
            },
          );
        },
      );
    }
    else{
      FirebaseAnalytics.instance.logEvent(
        name: "login_phone_code_nodata_re",
        parameters: {
          'phonenumber':phone,
          'areacode':area_code
        },
      );
      if(phone==''){
        Toast.toast(context,msg: "请输入手机号码".tr,position: ToastPostion.center);
      }else if(area_code==''){
        Toast.toast(context,msg: "请选择地区码".tr,position: ToastPostion.center);
      }

    }
    // }

    // AppLog('api_res',event:'res_verification_code',data:result?.bodyString ?? "",targetid: result?.statusCode??0);
  }
  //倒计时
  late  int timeCount=80 ;
  var timers;
  Timer  startTimer() {
    state.clicks.value=false;
    // ToastUtil.showTips('短信验证码已发送，请注意查收');
    timers= Timer.periodic(const Duration(seconds: 1), (Timer timer) => {
      if(state.timeCount <= 0){
        //state.VerificationCode = '获取验证码'.tr,
        timer.cancel(),
        state.timeCount = 80,
        state.clicks.value=true,
      }
      else {
        state.timeCount -= 1,
        state.VerificationCode.value = state.timeCount,
        // print('${state.VerificationCode}'),
      }
    });
    return timers;
  }
  ///离开页面
  LeavePage(){
    if(timers!=null){
      timers.cancel();
    }
    state.VerificationCode.value=0;
  }
  //验证验证码
  void verification(context) async{
    print(status);
    if (status == false) {
      // 防止重复请求
      return;
    }
    status = false;
    var result = await provider.VerificationCode(Get.arguments["phone"], Get.arguments["area_code"],state.Verification,userLogic.sourcePlatform);
    FirebaseAnalytics.instance.logEvent(
      name: "login_phone_resend_result",
      parameters: {
        "phone": Get.arguments["phone"],
        "area_code":Get.arguments["area_code"],
        'Verification':state.Verification,
        'statusCode':result.statusCode,
        'body':result.bodyString
      },
    );
    print('请求接口');
    print(result.statusCode);
    print(result.bodyString);
    Map<String, dynamic> responseData =  jsonDecode(result?.bodyString.toString() ??'');
    FirebaseAnalytics.instance.logEvent(
      name: "login_phone_code_VerificationCode",
      parameters: {
        'statusCode':result.statusCode,
        'body':result.bodyString,
        'uid':responseData["userId"],
        'userStatus':responseData["userStatus"],
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
        AdjustEvent myAdjustEvent = AdjustEvent('6ykn6j');
        myAdjustEvent.addCallbackParameter('userId',responseData["userId"].toString());
        Adjust.trackEvent(myAdjustEvent);
        // if(userLogic.Invitationcodes!=''){
        //   Fillinvitationcode(userLogic.Invitationcodes,context);
        // }
        // Get.to(SetInformationPage());
        if(userLogic.Invitationcodes!=''){
          Fillinvitationcode(userLogic.Invitationcodes,context);
        }
        Get.offAll(ReferencePage());
      }else{
        Get.offAll(HomePage());
        // Get.offAll(HomePage());
      }
      // var bean={'phone':Get.arguments["phone"],'area_code':Get.arguments["area_code"]};
    }
    AppLog('api_res',event:'phone_sgin_next',data:result.bodyString??'');
    // else{
    //   Toast.toast(context,msg: responseData['info'],position: ToastPostion.bottom);
    // }
    EasyLoading.dismiss();
    Future.delayed(const Duration(milliseconds: 2000), () {
      print('lai');
      status = true;
    });
  }

  ///firebase验证验证码
  void firebaseverification(context,idToken) async{
    if (status == false) {
      // 防止重复请求
      return;
    }
    status = false;
    var result = await provider.firebaseVerificationCode(Get.arguments["phone"], Get.arguments["area_code"],userLogic.sourcePlatform,idToken);
    print('请求接口');
    print(result.statusCode);
    print(result.bodyString);
    Map<String, dynamic> responseData =  jsonDecode(result?.bodyString.toString() ??'');
    FirebaseAnalytics.instance.logEvent(
      name: "login_phone_code_firebaseVerificationCode",
      parameters: {
        'statusCode':result.statusCode,
        'body':result.bodyString,
        'uid':responseData["userId"],
        'userStatus':responseData["userStatus"],
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
        AdjustEvent myAdjustEvent = AdjustEvent('6ykn6j');
        myAdjustEvent.addCallbackParameter('userId',responseData["userId"].toString());
        Adjust.trackEvent(myAdjustEvent);
        // if( userLogic.Invitationcodes!=''){
        //   Fillinvitationcode(userLogic.Invitationcodes,context);
        // }
        // Get.to(SetInformationPage());
        if(userLogic.Invitationcodes!=''){
          Fillinvitationcode(userLogic.Invitationcodes,context);
        }
        Get.offAll(ReferencePage());
      }else{
        Get.offAll(HomePage());
        // Get.offAll(HomePage());
      }
      // var bean={'phone':Get.arguments["phone"],'area_code':Get.arguments["area_code"]};
    }
    EasyLoading.dismiss();
    AppLog('api_res',event:'phone_sgin_next',data:result.bodyString??'');
    // else{
    //   Toast.toast(context,msg: responseData['info'],position: ToastPostion.bottom);
    // }
    Future.delayed(const Duration(milliseconds: 2000), () {
      status = true;
    });

  }

  ///填写邀请码
  Fillinvitationcode(code,context) async {
    if(antishake){
      antishake=false;
      var result = await InvitationCodeprovider.getinviteCode(code);
      if(result ==200){
        Toast.toast(context,
            msg: "填写成功".tr, position: ToastPostion.bottom);
      }
      Timer.periodic(const Duration(milliseconds: 1000),(timer){
        antishake=true;
        timer.cancel();//取消定时器
      }
      );
      //
    }
  }

  ///弹窗
  Future<void> load(context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return LoadingDialog(text: '',
          );
        });
  }
}
