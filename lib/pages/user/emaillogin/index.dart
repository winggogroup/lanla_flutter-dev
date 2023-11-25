import 'dart:async';
import 'dart:convert';

import 'package:adjust_sdk/adjust.dart';
import 'package:adjust_sdk/adjust_event.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lanla_flutter/common/controller/UserLogic.dart';
import 'package:lanla_flutter/common/controller/publicmethodes.dart';
import 'package:lanla_flutter/common/toast/view.dart';
import 'package:lanla_flutter/pages/home/view.dart';
import 'package:lanla_flutter/pages/user/reference/index.dart';
import 'package:lanla_flutter/services/login.dart';
import 'package:lanla_flutter/services/user_home.dart';
import 'package:lanla_flutter/ulits/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class emailoginPage extends StatefulWidget {
  @override
  createState() => emailoginState();
}
class emailoginState extends State<emailoginPage>{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Publicmethodes Publicmethods = Get.put(Publicmethodes());
  LoginProvider provider =  Get.put(LoginProvider());
  final userLogic = Get.find<UserLogic>();
  UserHomeProvider InvitationCodeprovider =  Get.put(UserHomeProvider());
  String email='';
  bool antishake=true;
  bool fsok=false;
  late StreamSubscription _dynamicLinkSubscription;
  final TextEditingController _textEditingController = TextEditingController();
  @override
  void initState() {
    shenlinkjt();
  }
  @override
  void dispose() {
    // 在页面销毁时取消监听 Firebase Dynamic Links 事件
    _cancelDynamicLinksListening();
    _textEditingController.dispose();
    super.dispose();
  }
  var acs = ActionCodeSettings(
    // URL you want to redirect back to. The domain (www.example.com) for this
    // URL must be whitelisted in the Firebase Console.
      url: 'https://lanla.page.link/email',
      // This must be true
      handleCodeInApp: true,
      iOSBundleId: 'lanla.app',
      androidPackageName: 'lanla.app',
      // installIfNotAvailable
      androidInstallApp: true,
      // minimumVersion
      androidMinimumVersion: '12');

  void _cancelDynamicLinksListening() {
    // 取消监听，释放资源
    _dynamicLinkSubscription?.cancel();
  }
  ///填写邀请码
  Fillinvitationcode(code,context) async {
    if(antishake){
      antishake=false;
      var result = await InvitationCodeprovider.getinviteCode(code);
      if(result ==200){
        Toast.toast(context, msg: "填写成功".tr, position: ToastPostion.bottom);
      }

      Timer.periodic(const Duration(milliseconds: 1000),(timer){
        antishake=true;
        timer.cancel();//取消定时器
      });
      //
    }
  }

  ///深层链接监听
  shenlinkjt() async {
    try {
      ///深层链接进来app在前台或者后台时触发
      _dynamicLinkSubscription =FirebaseDynamicLinks.instance.onLink.listen(
            (pendingDynamicLinkData) async {
          // Set up the `onLink` event listener next as it may be received here
          Publicmethods.loades(context,'');
          final Uri deepLinkes = pendingDynamicLinkData.link;
          // Example of using the dynamic link to push the user to a different screen
          if (deepLinkes != null) {
            print('邀请码链接$deepLinkes');
            if(deepLinkes.queryParameters['apiKey']!=null && email!=''){
              if (FirebaseAuth.instance.isSignInWithEmailLink(deepLinkes.toString())) {
                try {
                  // The client SDK will parse the code from the link for you.
                  final userCredential = await FirebaseAuth.instance
                      .signInWithEmailLink(email: email, emailLink: deepLinkes.toString());

                  // You can access the new user via userCredential.user.

                  final user = userCredential.user;
                  if(user!=null){
                    String? idToken = await user.getIdToken();
                    // 将idToken发送给后端进行验证和处理
                    print('邮箱email$idToken');
                    var result = await provider.emailLogin(userCredential.user?.email,userLogic.sourcePlatform,idToken);

                    Map<String, dynamic> responseData = jsonDecode(result?.bodyString.toString() ??'');
                    FirebaseAnalytics.instance.logEvent(
                      name: "login_email_user",
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
                  }
                  Navigator.pop(context);
                } catch (error) {
                  Navigator.pop(context);
                  print('Error signing in with email link.$error');
                }
              }else{
                ToastInfo('邮箱验证失败'.tr);
              }
            }else{
              ToastInfo('邮箱验证失败'.tr);
            }
          }else{
            ToastInfo('邮箱验证失败'.tr);
            Navigator.pop(context);
          }
        },
      );

    } catch (e) {}
  }

  bool isEmail(String input) {
    // 邮箱格式的正则表达式
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(input);
  }

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
            const SizedBox(height: 10),
            if(fsok)Text('我们将发送一个链接到你的邮箱，点击链接即可登录注册'.tr,style:const TextStyle(fontSize: 15,fontWeight: FontWeight.w400,height: 1.5),),
            const SizedBox(height: 80),
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
                    Expanded(flex: 1,child:
                    TextField(
                      controller: _textEditingController,
                      keyboardType: TextInputType.emailAddress,
                      // inputFormatters: [
                      //   FilteringTextInputFormatter.allow(RegExp("[0-9]")),//数字
                      // ],
                      scrollPadding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      cursorColor: const Color(0xFF999999),
                      decoration: InputDecoration(
                        // focusedBorder: OutlineInputBorder(
                        //   // borderSide: BorderSide(color: Colors.blue)
                        // ),
                          border: InputBorder.none,
                          hintText: "请输入邮箱号".tr
                      ),
                      style: const TextStyle(fontSize: 15),
                      onChanged: (text) {
                        email=text;
                        setState(() {

                        });
                      },
                    ),
                    ),
                  ]
              ),
            ),
            const Divider(height: 1.0,color: Color(0xFFf1f1f1),),
            const SizedBox(height: 120),
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
                  if(isEmail(email)){
                    Publicmethods.loades(context,'');
                    _textEditingController.text=email;
                      fsok=true;
                    setState(() {

                    });

                    FirebaseAuth.instance.sendSignInLinkToEmail(email: email, actionCodeSettings: acs)
                        .then((value) => {
                          print('发送邮箱成功'),
                          Navigator.pop(context),
                          ToastInfo('发送邮件成功'.tr)
                        }).catchError((onError) => {
                      print('发送邮箱失败'),
                      ToastInfo('发送邮箱失败'.tr),
                      Navigator.pop(context),
                    });
                  }else{
                    print('geshicele ');
                    ToastInfo('邮箱格式错误'.tr);
                  }
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
}
