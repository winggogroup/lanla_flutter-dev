import 'dart:async';
import 'dart:convert';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lanla_flutter/pages/publish/view.dart';
import 'package:lanla_flutter/ulits/app_log.dart';

import '../../../common/toast/view.dart';
import '../../../services/content.dart';
//选择国家
import 'package:country_picker/country_picker.dart';
import 'logic.dart';

class LoginPage extends StatelessWidget {
  final logic = Get.put(LoginLogic());
  final state = Get.find<LoginLogic>().state;
  ContentProvider provider = ContentProvider();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        decoration: const BoxDecoration(color:Color(0xffFFFFFF)),
        child: ListView(
          //crossAxisAlignment:CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 60),
            Text('欢迎你的到来'.tr,style:const TextStyle(fontSize: 30,fontWeight: FontWeight.w600),),
            const SizedBox(height: 100),
            Container(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black,width: 2),
                borderRadius:BorderRadius.circular((10)),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(70, 223, 0, 0.2),
                    offset: Offset(0, 2),
                    blurRadius: 5,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child:Row(
                  children: [
                    Container(
                      // width: 50,
                      // height: 50,
                      // decoration: BoxDecoration(border: Border.all(color: Colors.red)),
                        child: GestureDetector(child:
                        Row(
                          children: [
                            Obx(()=>Text('+${state.Areacode.value}',textAlign:TextAlign.center,)
                              ,),

                            Container(
                              padding: const EdgeInsets.fromLTRB(4, 0,6, 0),
                              // child: Icon(Icons.arrow_drop_down),
                              // pym_
                              child: Image.asset(
                                'assets/images/Downarrow.png',
                                width: 9.0,
                                height: 5.0,
                                fit: BoxFit.scaleDown,
                              ),
                            ),
                            SizedBox(
                              width: 1.5,
                              height: 12,
                              child: DecoratedBox(

                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            )

                          ],
                        ),onTap: (){
                          showCountryPicker(
                            context: context,
                            //Optional.  Can be used to exclude(remove) one ore more country from the countries list (optional).
                            exclude: <String>['KN', 'MF'],
                            favorite: <String>[state.favorite.value],
                            //Optional. Shows phone code before the country name.
                            showPhoneCode: true,
                            onSelect: (Country country) {
                              state.Areacode.value=country.phoneCode;
                              state.favorite.value=country.countryCode;
                            },
                            // Optional. Sets the theme for the country list picker.
                            countryListTheme: CountryListThemeData(
                              // Optional. Sets the border radius for the bottomsheet.
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                topRight: Radius.circular(10.0),
                              ),
                              // 搜索框.
                              inputDecoration: InputDecoration(
                                labelText: '搜索国家'.tr,
                                hintText: '搜索国家'.tr,
                                // prefixIcon: const Icon(Icons.search),
                                // pym_
                                prefixIcon: SvgPicture.asset(
                                  'assets/icons/sousuo.svg',
                                  fit: BoxFit.scaleDown,
                                  color: const Color(0xff999999),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: const Color(0xFF8C98A8).withOpacity(0.2),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }
                        )

                    ),
                    Expanded(flex: 1,child:
                    TextField(
                      // inputFormatters: <TextInputFormatter>[
                      //   FilteringTextInputFormatter.allow(RegExp("[0-9].")),
                      // ],
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp("[0-9]")),//数字
                      ],
                      scrollPadding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      cursorColor: const Color(0xFF999999),
                      decoration: InputDecoration(
                        // focusedBorder: OutlineInputBorder(
                        //   // borderSide: BorderSide(color: Colors.blue)
                        // ),
                          border: InputBorder.none,
                          hintText: "请输入手机号码".tr
                      ),
                      style: const TextStyle(fontSize: 15),
                      onChanged: (text) {
                        logic.phonenumber = text;
                      },
                    ),
                    ),
                  ]
              ),
            ),
            const Divider(height: 1.0,color: Color(0xFFf1f1f1),),
            const SizedBox(height: 164),
            // Expanded(
            //   child:
            Container(
              height: 56,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:MaterialStateProperty.all(const Color(0xff000000)),
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                  // elevation: MaterialStateProperty.all(20),
                  shadowColor: MaterialStateProperty.all(Colors.black),
                  elevation: MaterialStateProperty.all(5),
                  shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(37))
                  ),
                ),

                child: Text('登录/注册'.tr,style: const TextStyle(fontWeight: FontWeight.w700),),
                onPressed: () async {
                  print('+${state.Areacode.value}${logic.phonenumber}');
                  AppLog('firebase_login',data:'+${state.Areacode.value}__${logic.phonenumber}');

                  FirebaseAnalytics.instance.logEvent(
                    name: "login_tap_phone_sendcode",
                    parameters: {
                      "areacode": state.Areacode.value,
                      "phonenumber":logic.phonenumber
                    },
                  );
                  var close=false;
                  if(logic.phonenumber!=''&&state.Areacode.value!='') {

                    // firebase 登录
                    FirebaseAuth auth = FirebaseAuth.instance;
                    print(auth.verifyPhoneNumber);
                    load(context);
                    AppLog('firebase_login_success',data:'+${state.Areacode.value}__${logic.phonenumber}');

                    await auth.verifyPhoneNumber(
                      // phoneNumber: '+8613426102397',
                      phoneNumber: '+${state.Areacode.value}${logic.phonenumber}',
                      ///一键登录不用验证码
                      verificationCompleted: (PhoneAuthCredential credential) async {
                        AppLog('firebase_login_callback',event: "verificationCompleted",data:'+${state.Areacode.value}__${logic.phonenumber}');
                        Navigator.pop(context);
                        close=true;
                        //await auth.signInWithCredential(credential);
                        await auth.signInWithCredential(credential).then((sha) async {
                          if(sha.user?.uid!=''&&sha.user?.uid!=null){
                            User? user = sha.user;
                            String? idToken = await user!.getIdToken();
                            print('手机号$idToken');
                            print(user.providerData);
                            logic.firebaseverification(context,logic.phonenumber, state.Areacode.value,idToken);
                          }else{
                            AppLog('firebase_login_callback',event: "error",data:'+${state.Areacode.value}__${logic.phonenumber}');
                            FirebaseAnalytics.instance.logEvent(
                              name: "login_firebase_login_callback_error",
                              parameters: {
                                "error": '没有uid',
                              },
                            );
                            Toast.toast(context,msg: "验证失败".tr,position: ToastPostion.center);
                          }
                        },onError: (e) {
                          Toast.toast(context,msg: "验证失败".tr,position: ToastPostion.center);
                        });

                      },
                      verificationFailed: (FirebaseAuthException e) {
                        AppLog('firebase_login_callback',event: "verificationFailed",data:'+${state.Areacode.value}__${logic.phonenumber} error:${e.code}');
                        FirebaseAnalytics.instance.logEvent(
                          name: "login_firebase_login_callback_error",
                          parameters: {
                            "error": e.code,
                          },
                        );
                        print('bbb${e.code}');
                        Navigator.pop(context);
                        close=true;
                        print(e.code);

                        if(e.code=='invalid-phone-number'){
                          Toast.toast(context,msg: "无效手机号".tr,position: ToastPostion.center);
                        }else if(e.code=='too-many-requests'){
                          Toast.toast(context,msg: "请求太多".tr,position: ToastPostion.center);
                        }
                        else if (e.code == 'quota-exceeded') {
                          logic.ajverification(logic.phonenumber, state.Areacode.value);
                        }
                        else{
                          Toast.toast(context,msg: "程序出错".tr,position: ToastPostion.center);
                        }
                      },
                      // 发送验证码
                      codeSent: (String verificationId, int? resendToken) async {
                        AppLog('firebase_login_callback',event: "codeSent",data:'+${state.Areacode.value}__${logic.phonenumber}');
                        FirebaseAnalytics.instance.logEvent(
                          name: "login_phone_codeSent",
                          parameters: {
                            "verificationId": verificationId,
                            "resendToken":resendToken ?? ''
                          },
                        );
                        //String smsCode = '111223';
                        print('ccc');
                        Navigator.pop(context);
                        close=true;

                        logic.verification(logic.phonenumber, state.Areacode.value,verificationId);
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
                      timeout: const Duration(seconds: 5),
                      codeAutoRetrievalTimeout: (String verificationId) {
                        print('ddd');
                        print(verificationId);
                        FirebaseAnalytics.instance.logEvent(
                          name: "login_phone_code_timeout",
                          parameters: {
                            "verificationId": verificationId,
                          },
                        );
                      },
                    );
                    const timeout = Duration(seconds: 40);
                    Timer(timeout, () {
                      print('时间结束$close');
                      if(close==false){
                        FirebaseAnalytics.instance.logEvent(
                          name: "login_phone_code_noresponse",
                          parameters: {

                          },
                        );
                        Navigator.pop(context);//callback function
                        logic.ajverification(logic.phonenumber, state.Areacode.value);
                      }
                    });
                  }
                  else{
                    FirebaseAnalytics.instance.logEvent(
                      name: "login_phone_code_nodata",
                      parameters: {
                        'phonenumber':logic.phonenumber,
                        'areacode':state.Areacode.value
                      },
                    );
                    if(logic.phonenumber==''){
                      Toast.toast(context,msg: "请输入手机号码".tr,position: ToastPostion.center);
                    }else if(state.Areacode.value==''){
                      Toast.toast(context,msg: "请选择地区码".tr,position: ToastPostion.center);
                    }

                  }




                  // if(logic.phonenumber!=''&&state.Areacode.value!='') {
                  //   AppLog('tap',event:'login',data:"${state.Areacode.value}___${logic.phonenumber}");
                  //   logic.verification(logic.phonenumber, state.Areacode.value);
                  //   print(logic.phonenumber);
                  // }
                  // else{
                  //   if(logic.phonenumber==''){
                  //     Toast.toast(context,msg: "请输入手机号码".tr,position: ToastPostion.center);
                  //   }else if(state.Areacode.value==''){
                  //     Toast.toast(context,msg: "请选择地区码".tr,position: ToastPostion.center);
                  //   }
                  //
// <<<<<<< HEAD
//                     // }
// =======
                  //     print('ccc');
                  //     print(verificationId);
                  //     print(resendToken);
                  //     },
                  //   codeAutoRetrievalTimeout: (String verificationId) {
                  //     print('ddd');
                  //     print(verificationId);
                  //     },
                  // );


                  // if(logic.phonenumber!=''&&state.Areacode.value!='') {
                  //   AppLog('tap',event:'login',data:"${state.Areacode.value}___${logic.phonenumber}");
                  //   logic.verification(logic.phonenumber, state.Areacode.value);
                  //   print(logic.phonenumber);
                  // } else{
                  //   if(logic.phonenumber==''){
                  //     Toast.toast(context,msg: "请输入手机号码".tr,position: ToastPostion.center);
                  //   }else if(state.Areacode.value==''){
                  //     Toast.toast(context,msg: "请选择地区码".tr,position: ToastPostion.center);
                  //   }
                  // }
// >>>>>>> bfe6309cc3522fa3d6ecc3e9830b2dcc4b587a2f
                },
              ),
            ),
            //)
          ],
        ),
      ),
      appBar: AppBar(
        elevation: 0,//消除阴影
        backgroundColor: Colors.white,//设置背景颜色为白色
        leading: IconButton(
            color: Colors.black,
            icon: const Icon(Icons.arrow_back_ios),
            tooltip: "Search",
            onPressed: () {
              //print('menu Pressed');
              Navigator.of(context).pop();
            }),
      ),
    );
  }

  deactivate() {
    print('页面销毁');
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
//定义弹窗

