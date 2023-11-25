import 'dart:async';
import 'dart:convert';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:lanla_flutter/pages/publish/view.dart';

import '../../../../../common/toast/view.dart';
import '../../../../../services/SetUp.dart';
import '../AccountSecurity.dart';
import '../change_binding/view.dart';
import 'state.dart';

class CellPhoneLogic extends GetxController {
  final CellPhoneState state = CellPhoneState();
  //实例化
  SetUpProvider provider = Get.put(SetUpProvider());

  //刷新
  AccountSecurityState Refresh = Get.put(AccountSecurityState());

  var status=true;
  //获取验证码
  // void SendVerificationCode () async{
  //   print('887799');
  //   // print(112233);
  //   //print(Get.arguments);
  //   var result = await provider.SendVerificationCodetwo(state.phonenumber,state.Areacode.value);
  //   print('请求接口');
  //   print(result.statusCode);
  //   print(result.bodyString);
  //   if(result.statusCode==200){
  //     startTimer();
  //   }else{
  //     state.clicks.value=true;
  //   }
  // }

  //获取验证码
  void SendVerificationCode (context) async{
    var phone=state.phonenumber;
    var area_code=state.Areacode.value;

    if(phone!=''&&area_code!='') {
      // firebase 登录
      FirebaseAuth auth = FirebaseAuth.instance;
      print(auth.verifyPhoneNumber);
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
    // }

    // AppLog('api_res',event:'res_verification_code',data:result?.bodyString ?? "",targetid: result?.statusCode??0);
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
    state.clicks.value=false;
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

  void verification(context,idToken) async{
    if (status == false) {
      // 防止重复请求
      return;
    }
    status = false;
    var result = await provider.GetupdatePhone('','',state.phonenumber, state.Areacode.value,state.Verification,idToken);
    print('请求接口');
    if(result.statusCode==200){
      EasyLoading.dismiss();
      Get.back(result: true);
      //Get.off(AccountSecurityWidget());
      Toast.toast(context,msg: "绑定成功".tr,position: ToastPostion.center);
      // Timer.periodic(Duration(milliseconds: 10000),(timer){
      //   //debugPrint("Socket is closed");
      //   Refresh.shuju();
      //  timer.cancel();//取消定时器
      //});

      // if(responseData["userStatus"]=='2'){
      //   Get.to(SetInformationPage());
      // }else{
      //   Get.offAll(HomePage());
      //   // Get.offAll(HomePage());
      // }
      // var bean={'phone':Get.arguments["phone"],'area_code':Get.arguments["area_code"]};
    }else{
      EasyLoading.dismiss();
    }
    // else{
    //   Toast.toast(context,msg: responseData['info'],position: ToastPostion.bottom);
    // }
    Future.delayed(const Duration(milliseconds: 2000), () {
      status = true;
    });
  }


  //验证身份
  void Authentication(context,idToken) async{
    if (status == false) {
      // 防止重复请求
      return;
    }
    var result = await  provider.verifyOldPhone(state.phonenumber,state.Areacode.value,idToken);
    if(result.statusCode==200){
      status = false;
      Get.to(ChangeBindingPage(),arguments: {'oldPhone':state.phonenumber,'oldAreaCode':state.Areacode.value});
    }
    EasyLoading.dismiss();
    Future.delayed(const Duration(milliseconds: 2000), () {
      status = true;
    });
  }
}
