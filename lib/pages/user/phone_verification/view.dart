import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:lanla_flutter/ulits/app_log.dart';import '../../../common/controller/UserLogic.dart';


import 'logic.dart';
import '../../../common/toast/view.dart';
class PhoneVerificationPage extends StatefulWidget {
  @override
  createState() => PhoneVerificationStates();

}

class PhoneVerificationStates extends State<PhoneVerificationPage> {
  final logic = Get.put(PhoneVerificationLogic());
  final state = Get.find<PhoneVerificationLogic>().state;


  @override
  void dispose() {
    super.dispose();
    logic.LeavePage();
    print('离开页面了ssss');
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,//消除阴影
        backgroundColor: Colors.white,//设置背景颜色为白色
        leading: IconButton(
            color: Colors.black,
            icon: Icon(Icons.arrow_back_ios),
            tooltip: "Search",
            onPressed: () {
              //print('menu Pressed');
              Navigator.of(context).pop();
            }),
      ),
      body:  Container(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        decoration: new BoxDecoration(color:Color(0xffFFFFFF)),
        child: ListView(
          //crossAxisAlignment:CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 60),
            Text('验证码验证'.tr,style: const TextStyle(fontSize: 30,fontWeight: FontWeight.w600),),
            const SizedBox(height: 105),
            Container(
              height: 55,
              padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
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
                    Expanded(flex: 1,child:
                    TextField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp("[0-9]")),//数字
                      ],
                      scrollPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      cursorColor: Color(0xFF999999),
                      decoration: InputDecoration(
                        // focusedBorder: OutlineInputBorder(
                        //   borderSide: BorderSide(color: Colors.blue)
                        // ),

                          border: InputBorder.none,
                          hintText: "请输入验证码".tr
                      ),
                      style: TextStyle(fontSize: 15),
                      onChanged: (text) {
                        state.Verification = text;
                        print(state.Verification);
                      },
                    ),
                    ),
                    Container(
                      // width: 50,
                      // height: 50,

                      // decoration: BoxDecoration(border: Border.all(color: Colors.red)),
                        margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
                        child: GestureDetector(
                          child: Obx(() => Text(state.VerificationCode.value==0? '获取验证码'.tr:'重新发送'.tr+'（${state.VerificationCode}）',
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w700,
                                color: state.VerificationCode.value==0?Colors.black:Color(0xff999999),
                              ))),
                          onTap: () {
                            AppLog('tap',event:'verification_code',data:"${Get.arguments["phone"]}___${Get.arguments["area_code"]}");
                            FirebaseAnalytics.instance.logEvent(
                              name: "login_phone_resend",
                              parameters: {
                                "phone": Get.arguments["phone"],
                                "area_code":Get.arguments["area_code"]
                              },
                            );
                            print('yanzhengma${state.clicks.value},${Get.arguments["phone"]},${Get.arguments["area_code"]}');
                            if(state.clicks.value &&Get.arguments["phone"]!='' && Get.arguments["area_code"]!=''){
                              state.clicks.value=false;
                              AppLog('tap',event:'verification_code_success',data:"${Get.arguments["phone"]}___${Get.arguments["area_code"]}");
                              logic.SendVerificationCode(context);
                            }else{
                              if(Get.arguments["phone"]==''){
                                Toast.toast(context,msg: "手机号错误".tr,position: ToastPostion.center);
                              }
                              else if(Get.arguments["area_code"]==''){
                                Toast.toast(context,msg: "地区编号错误".tr,position: ToastPostion.center);
                              }
                            }
                          },
                        )


                    ),
                  ]
              ),
            ),
            Divider(height: 1.0,color: Color(0xFFf1f1f1),),
            const SizedBox(height: 164),
            // Expanded(
            //   child:
              Container(
                height: 56,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:MaterialStateProperty.all(Color(0xff000000)),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                    // elevation: MaterialStateProperty.all(20),
                    shadowColor: MaterialStateProperty.all(Colors.black),
                    elevation: MaterialStateProperty.all(5),
                    shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(37))
                    ),
                  ),

                  child:Text('下一步'.tr, style: const TextStyle(fontWeight: FontWeight.w700,fontSize: 16),),
                  onPressed: () async {
                    FirebaseAnalytics.instance.logEvent(
                      name: "login_phone_tap_verify",
                      parameters: {
                       'ownyanzhneg':state.ownyanzhneg.value
                      },
                    );
                    print('是啥');
                    print(state.ownyanzhneg.value);
                    if(!state.ownyanzhneg.value){
                      if(state.Verification!=''&&Get.arguments["phone"]!='' && Get.arguments["area_code"]!=''){
                        EasyLoading.show(status: 'loading...',maskType: EasyLoadingMaskType.black);
                        AppLog('tap',event:'phone_sgin_next');
                        FirebaseAuth auth = FirebaseAuth.instance;
                          PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: state.verificationId==''?Get.arguments["verificationId"]:state.verificationId, smsCode: state.Verification);
                             await FirebaseAuth.instance.signInWithCredential(credential).then((userCredential) async {
                               print('shadddddd${userCredential}');
                               User? user = userCredential.user;
                                 String? idToken = await user?.getIdToken();
                               if (idToken != null) {
                                 // 将idToken发送给后端进行验证和处理
                                 print('手机号${idToken}');
                                 logic.firebaseverification(context,idToken);
                               }else{
                                 EasyLoading.dismiss();
                                 Toast.toast(context,msg: "验证失败".tr,position: ToastPostion.center);
                               }
                             }, onError: (e) {
                              FirebaseAnalytics.instance.logEvent(
                                name: "login_phone_tap_verify_error",
                                parameters: {
                                  'error':e.code
                                },
                              );
                              EasyLoading.dismiss();
                              Toast.toast(context,msg: "验证失败".tr,position: ToastPostion.center);
                            });


                          // await auth.signInWithCredential(credential).then((sha) {
                          //   print('我要的数据${sha}');
                          //   FirebaseAnalytics.instance.logEvent(
                          //     name: "login_phone_tap_verify_result",
                          //     parameters: {
                          //       'uid':sha.user?.uid??'no'
                          //     },
                          //   );
                          //   if(sha.user?.uid!=''&&sha.user?.uid!=null){
                          //     logic.firebaseverification(context,idToken);
                          //   }else{
                          //     FirebaseAnalytics.instance.logEvent(
                          //       name: "login_phone_tap_verify_error",
                          //       parameters: {
                          //         'error':'验证失败'
                          //       },
                          //     );
                          //     EasyLoading.dismiss();
                          //     Toast.toast(context,msg: "验证失败".tr,position: ToastPostion.center);
                          //
                          //   }
                          // }, onError: (e) {
                          //   FirebaseAnalytics.instance.logEvent(
                          //     name: "login_phone_tap_verify_error",
                          //     parameters: {
                          //       'error':e.code
                          //     },
                          //   );
                          //   EasyLoading.dismiss();
                          //   Toast.toast(context,msg: "验证失败".tr,position: ToastPostion.center);
                          // });
                        }


                        // if(sha.user?.uid!=''&&sha.user?.uid!=null){
                        //   logic.firebaseverification(context);
                        // }else{
                        //   Toast.toast(context,msg: "验证失败".tr,position: ToastPostion.center);
                        // }
                        //
                        // print('验证');
                        // print(sha.user?.uid);
                        // print(sha.user?.phoneNumber);
                      // }
                      else{
                        FirebaseAnalytics.instance.logEvent(
                          name: "login_phone_tap_verify_nodata",
                          parameters: {
                            'verification':state.Verification,
                            'phone':Get.arguments["phone"],
                            'area_code':Get.arguments["area_code"]
                          },
                        );
                        if(state.Verification==''){
                          Toast.toast(context,msg: "请填写验证码".tr,position: ToastPostion.center);
                        }else if(Get.arguments["phone"]==''){
                          Toast.toast(context,msg: "手机号错误".tr,position: ToastPostion.center);
                        }
                        else if(Get.arguments["area_code"]==''){
                          Toast.toast(context,msg: "地区编号错误".tr,position: ToastPostion.center);
                        }
                      }
                    }else{
                      FirebaseAnalytics.instance.logEvent(
                        name: "login_phone_tap_verify_ali_cloud",
                        parameters: {
                          'verification':state.Verification,
                          'phone':Get.arguments["phone"],
                          'area_code':Get.arguments["area_code"]
                        },
                      );
                      if(state.Verification!=''&&Get.arguments["phone"]!='' && Get.arguments["area_code"]!=''){
                        EasyLoading.show(status: 'loading...',maskType: EasyLoadingMaskType.black);
                        AppLog('tap',event:'phone_sgin_next');
                        logic.verification(context);
                      }
                      else{
                        FirebaseAnalytics.instance.logEvent(
                          name: "login_phone_tap_verify_nodata",
                          parameters: {
                            'verification':state.Verification,
                            'phone':Get.arguments["phone"],
                            'area_code':Get.arguments["area_code"]
                          },
                        );
                        if(state.Verification==''){
                          Toast.toast(context,msg: "请填写验证码".tr,position: ToastPostion.center);
                        }else if(Get.arguments["phone"]==''){
                          Toast.toast(context,msg: "手机号错误".tr,position: ToastPostion.center);
                        }
                        else if(Get.arguments["area_code"]==''){
                          Toast.toast(context,msg: "地区编号错误".tr,position: ToastPostion.center);
                        }
                      }
                    }
                    //UserCredential(additionalUserInfo: AdditionalUserInfo(isNewUser: true, profile: {}, providerId: null, username: null), credential: null, user: User(displayName: null, email: null, emailVerified: false, isAnonymous: false, metadata: UserMetadata(creationTime: 2022-11-29 02:20:11.634Z, lastSignInTime: 2022-11-29 02:20:11.634Z), phoneNumber: +447893920061, photoURL: null, providerData, [UserInfo(displayName: null, email: null, phoneNumber: +447893920061, photoURL: null, providerId: phone, uid: null)], refreshToken: , tenantId: null, uid: 9sKPGyFRHVU2pUjfT9qvu49EMml1))
                    // Toast.toast(context,msg: "居中显示",position: ToastPostion.bottom);
                  },
                ),
              ),
            // )
          ],
        ),
      ),
    );
  }
}
