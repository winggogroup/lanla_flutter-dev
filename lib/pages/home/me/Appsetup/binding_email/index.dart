import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lanla_flutter/common/controller/publicmethodes.dart';
import 'package:lanla_flutter/common/toast/view.dart';
import 'package:lanla_flutter/models/isemailbinding.dart';
import 'package:lanla_flutter/pages/home/me/Appsetup/binding_email/Forcedrebinding.dart';
import 'package:lanla_flutter/services/SetUp.dart';
import 'package:lanla_flutter/ulits/toast.dart';

class bindingemailoginPage extends StatefulWidget {
  @override
  createState() => bindingemailoginState();
}
class bindingemailoginState extends State<bindingemailoginPage>{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Publicmethodes Publicmethods = Get.put(Publicmethodes());
  SetUpProvider SetUprovider =  Get.put(SetUpProvider());
  String email='';
  late StreamSubscription _dynamicLinkSubscription;

  @override
  void initState() {
    shenlinkjt();
  }
  @override
  void dispose() {
    // 在页面销毁时取消监听 Firebase Dynamic Links 事件
    _cancelDynamicLinksListening();
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

  ///深层链接监听
  shenlinkjt() async {
    try {
      ///深层链接进来app在前台或者后台时触发
      _dynamicLinkSubscription= FirebaseDynamicLinks.instance.onLink.listen(
            (pendingDynamicLinkData) async {
          // Set up the `onLink` event listener next as it may be received here
          if (pendingDynamicLinkData != null) {
            Publicmethods.loades(context,'');
            final Uri deepLinkes = pendingDynamicLinkData.link;
            // Example of using the dynamic link to push the user to a different screen
            if (deepLinkes != null) {
              if(deepLinkes.queryParameters['apiKey']!=null && email!=''){
                if (FirebaseAuth.instance.isSignInWithEmailLink(deepLinkes.toString())) {
                  try {
                    final userCredential = await FirebaseAuth.instance.signInWithEmailLink(email: email, emailLink: deepLinkes.toString());
                    final user = userCredential.user;
                    print('换绑${deepLinkes}');
                    if(user!=null){
                      String? idToken = await user.getIdToken();
                      
                      var isbdemail=await SetUprovider.isAllowEmailBind(idToken,user.email);
                      if (isbdemail.statusCode == 200) {
                        print('出发借口啦');
                        if(isbdemail.body['allow_bind_email']&&isbdemail.body['have_email_user_info']!=null){
                          print('出发借口啦123');
                          Navigator.pop(context);
                           // Get.to(ForcedrebindingPage(),arguments: {'data':isbdemail.body,'idToken':idToken,email:user.email});
                          Get.to(()=>ForcedrebindingPage(),arguments: {...isbdemail.body,'idToken':idToken,"email":user.email})?.then((value) {
                            if (value != null) {
                              Get.back(result: true);
                              //此处可以获取从第二个页面返回携带的参数
                            }
                          });
                          return;
                        }else if(isbdemail.body['allow_bind_email']&&isbdemail.body['have_email_user_info']==null){
                          var BindingResults = await SetUprovider.bindEmailAccount( idToken,user.email,);
                          print('请求接口');
                          print(BindingResults.statusCode);
                          print(BindingResults.bodyString);
                          if (BindingResults.statusCode == 200) {
                            Navigator.pop(context);
                            Toast.toast(
                                context, msg: "绑定成功".tr, position: ToastPostion.center);
                            Get.back(result: true);
                          }else{
                            Navigator.pop(context);
                          }
                        }else if(!isbdemail.body['allow_bind_email']){
                          Toast.toast(context, msg: "绑定失败".tr, position: ToastPostion.center);
                        }
                        // if(isemailbindingFromJson(isbdemail.bodyString!))
                      }else{
                        Navigator.pop(context);
                      }
                    }else{
                      Navigator.pop(context);
                    }
                    // Navigator.pop(context);
                  } catch (error) {
                    Toast.toast(context, msg: "绑定失败".tr, position: ToastPostion.center);
                    Navigator.pop(context);
                    print('Error signing in with email link.${error}');
                  }
                }else{
                  Navigator.pop(context);
                  ToastInfo('邮箱验证失败'.tr);
                }
              }else{
                Navigator.pop(context);
                ToastInfo('邮箱验证失败'.tr);
              }

            }else{
              ToastInfo('邮箱验证失败'.tr);
              Navigator.pop(context);
            }
          }
        },
      );

    } catch (e) {}
  }
  ///取消监听
  void _cancelDynamicLinksListening() {
    // 取消监听，释放资源
    _dynamicLinkSubscription?.cancel();
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
        decoration: new BoxDecoration(color:Color(0xffFFFFFF)),
        child: ListView(
          //crossAxisAlignment:CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 60),
            Text('绑定邮箱号'.tr,style: TextStyle(fontSize: 30,),),
            const SizedBox(height: 100),
            Container(
              // padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              decoration: BoxDecoration(
                color: Colors.white,
                // border: Border(bottom: BorderSide(width: 1, color: Colors.black)),
                // // borderRadius:BorderRadius.circular((10)),
                // boxShadow: const [
                //   BoxShadow(
                //     color: Color.fromRGBO(68, 207, 5, 0.2),
                //     offset: Offset(0, 2),
                //     blurRadius: 5,
                //     spreadRadius: 0,
                //   ),
                // ],
              ),
              child:Row(
                  children: [
                    Expanded(flex: 1,child:
                    TextField(
                      keyboardType: TextInputType.emailAddress,
                      // inputFormatters: [
                      //   FilteringTextInputFormatter.allow(RegExp("[0-9]")),//数字
                      // ],
                      // scrollPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      cursorColor: Color(0xFF999999),
                      decoration: InputDecoration(
                        // focusedBorder: OutlineInputBorder(
                        //   // borderSide: BorderSide(color: Colors.blue)
                        // ),
                          border: InputBorder.none,
                          hintText: "请输入邮箱号".tr
                      ),
                      style: TextStyle(fontSize: 15),
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
            Container( decoration: BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(width: 1, color: Colors.black)),
              // borderRadius:BorderRadius.circular((10)),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(68, 207, 5, 0.2),
                  offset: Offset(0, 2),
                  blurRadius: 5,
                  spreadRadius: 0,
                ),
              ],
            ),),

            const SizedBox(height: 120),
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

                child: Text('绑定'.tr,style: const TextStyle(fontWeight: FontWeight.w700),),
                onPressed: () async {
                  if(isEmail(email)){
                    Publicmethods.loades(context,'');

                    FirebaseAuth.instance.sendSignInLinkToEmail(email: email, actionCodeSettings: acs)
                        .catchError((onError) => {
                      print('发送邮箱失败'),
                      ToastInfo('发送邮箱失败'.tr),
                      Navigator.pop(context),
                    })
                        .then((value) => {
                      print('发送邮箱成功'),
                      Navigator.pop(context),
                      ToastInfo('发送邮件成功'.tr)
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
            icon: Icon(Icons.arrow_back_ios),
            tooltip: "Search",
            onPressed: () {
              //print('menu Pressed');
              Navigator.of(context).pop();
            }),
      ),
    );
  }
}
