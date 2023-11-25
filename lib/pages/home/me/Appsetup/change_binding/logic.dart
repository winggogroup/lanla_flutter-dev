import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lanla_flutter/pages/publish/view.dart';
import 'package:lanla_flutter/ulits/app_log.dart';

import '../../../../../common/toast/view.dart';
import '../../../../../services/SetUp.dart';
import '../AccountSecurity.dart';
import 'state.dart';

class ChangeBindingLogic extends GetxController {
  final ChangeBindingState state = ChangeBindingState();
  //实例化
  SetUpProvider provider = Get.put(SetUpProvider());

  //刷新
  AccountSecurityState Refresh = Get.put(AccountSecurityState());

  var status=true;
  //获取验证码
  void SendVerificationCode (context) async{
    var phone=state.phonenumber;
    var area_code=state.Areacode.value;
    if(phone!=''&&area_code!='') {
      // firebase 登录
      FirebaseAuth auth = FirebaseAuth.instance;
      load(context);
      await auth.verifyPhoneNumber(
        phoneNumber: '+$area_code$phone',
        verificationCompleted: (PhoneAuthCredential credential) async {
          Navigator.pop(context);
        },
        verificationFailed: (FirebaseAuthException e) {
          state.clicks.value=true;
          Navigator.pop(context);
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
          FirebaseAnalytics.instance.logEvent(
            name: "login_phone_codeSent",
            parameters: {
              "verificationId": verificationId,
              "resendToken":resendToken ?? ''
            },
          );
          startTimer();
          Navigator.pop(context);
          state.verificationId=verificationId;
        },
        timeout: const Duration(seconds: 10),
        codeAutoRetrievalTimeout: (String verificationId) {
          print('ddd');
          print(verificationId);
        },
      );
    }
    else{
      if(phone==''){
        Toast.toast(context,msg: "请输入手机号码".tr,position: ToastPostion.center);
      }else if(area_code==''){
        Toast.toast(context,msg: "请选择地区码".tr,position: ToastPostion.center);
      }
    }
  }

  ///弹窗
  Future<void> load(context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return LoadingDialog(text: '',);
        });
  }
  //倒计时
  late  int timeCount=60 ;
  Timer  startTimer() {
    // ToastUtil.showTips('短信验证码已发送，请注意查收');
    var timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) => {
      if(state.timeCount <= 0){
        //state.VerificationCode = '获取验证码'.tr,
        timer.cancel(),
        state.timeCount = 60,
        state.clicks.value=true,
      }
      else {
        state.timeCount -= 1,
        state.VerificationCode.value = state.timeCount,
        // print('${state.VerificationCode}'),
      }
    });
    return timer;
  }

  //验证验证码
  void verification(context,idToken) async{
    if (status == false) {
      // 防止重复请求
      return;
    }
    status = false;
    var result = await provider.GetupdatePhone(Get.arguments["oldPhone"],Get.arguments["oldAreaCode"],state.phonenumber, state.Areacode.value,state.Verification,idToken);
    print('请求接口');
    if(result.statusCode==200){
      Refresh.shuju();
      Get.to(AccountSecurityWidget());
      // Get.back();
      // Get.back();
      //Get.off(AccountSecurityWidget());
      Toast.toast(context,msg: "绑定成功".tr,position: ToastPostion.center);
      // if(responseData["userStatus"]=='2'){
      //   Get.to(SetInformationPage());
      // }else{
      //   Get.offAll(HomePage());
      //   // Get.offAll(HomePage());
      // }
      // var bean={'phone':Get.arguments["phone"],'area_code':Get.arguments["area_code"]};
    }
    else{
      if(result.body['code']==40001){
        Get.back();
      }
    }
    Future.delayed(const Duration(milliseconds: 2000), () {
      status = true;
    });
  }
}
