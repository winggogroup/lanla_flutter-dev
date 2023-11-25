import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lanla_flutter/common/controller/publicmethodes.dart';
import 'package:lanla_flutter/pages/home/me/Appsetup/binding_email/index.dart';
import 'package:lanla_flutter/pages/home/start/detail_view/logic.dart';
import '../../../../common/controller/UserLogic.dart';
import '../../../../common/toast/view.dart';
import '../../../../models/Binding.dart';
import '../../../../services/SetUp.dart';
import '../../logic.dart';
import '../../view.dart';
import 'Feedback.dart';
import 'cell_phone/view.dart';
GoogleSignIn _googleSignIn = GoogleSignIn(
  //实例化
  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/userinfo.profile',
  ],
);

class AccountSecurityWidget extends StatefulWidget {
  @override
  createState() => AccountSecurityState();
  final userLogic = Get.find<UserLogic>();
}
class AccountSecurityState extends State<AccountSecurityWidget> {
  final WebSocketes = Get.find<StartDetailLogic>();
  SetUpProvider SetUprovider =  Get.put(SetUpProvider());
  Publicmethodes Publicmethods = Get.put(Publicmethodes());
  var informationes=[];
  var antishake=true;
  late  Map mobile= {
    'name':'',
    "type":0
  };
  late Map facebook= {
    'name':'',
    "type":0
  };
  late Map google= {
    'name':'',
    "type":0
  };
  late Map apple= {
    'name':'',
    "type":0
  };
  late Map email= {
    'name':'',
    "type":0
  };
  /// fackbook绑定
  Future<void> signInWithFacebook(context) async {
    if(antishake){
      antishake=false;
    // Trigger the sign-in flow
    final LoginResult result = await FacebookAuth.instance.login(); // by default we request the email and the public profile
    if (result.status == LoginStatus.success) {
      print('____________________');
      print(result);
      var BindingResults = await SetUprovider.Thirdpartybinding(2,'','','',result.accessToken?.applicationId,result.accessToken?.token,'');
      print('请求接口');
      print(BindingResults.statusCode);
      print(BindingResults.bodyString);
      if(BindingResults.statusCode==200){
        shuju();
        Toast.toast(context,msg: "绑定成功".tr,position: ToastPostion.center);
      }
    } else {
      Toast.toast(context,msg: "绑定失败".tr,position: ToastPostion.center);
    }
      antishake=true;
    }
  }

  /// google绑定
  Future<void> handleSignIn(context) async {
    if(antishake){
      antishake=false;
      try {
        var information=await _googleSignIn.signIn();
        final GoogleSignInAuthentication googleAuth = await information!.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
        User? user = userCredential.user;
        if (user != null) {
          String? idToken = await user.getIdToken();
          // 将idToken发送给后端进行验证和处理
          print('谷歌数据$idToken');
          print(information);
          var BindingResults = await SetUprovider.Thirdpartybinding(
              1, information?.displayName, information?.photoUrl,
              information?.email, information?.id, '',idToken);
          print('请求接口');
          print(BindingResults.statusCode);
          print(BindingResults.bodyString);
          if (BindingResults.statusCode == 200) {
            shuju();
            Toast.toast(context, msg: "绑定成功".tr, position: ToastPostion.center);
          }
        }
      } catch (error) {
        Toast.toast(context,msg: "绑定失败".tr,position: ToastPostion.center);
      }
      antishake=true;
    }

  }

  /// apple绑定
  Future<void> signInWithApple() async {
    if(antishake) {
      antishake=false;
      final appleProvider = AppleAuthProvider();
      var information = await FirebaseAuth.instance.signInWithProvider(
          appleProvider);
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String? idToken = await user.getIdToken();
        // 将idToken发送给后端进行验证和处理
        print('苹果数据$idToken');

        var BindingResults = await SetUprovider.Thirdpartybinding(3, '', '', '', information.user?.uid, '', idToken);

        if (BindingResults.statusCode == 200) {
          shuju();
          Toast.toast(
              context, msg: "绑定成功".tr, position: ToastPostion.center);
        }
      }
      antishake=true;
    }
  }

  Future<void> shuju() async {
    var resultes = await SetUprovider.BindingInformation();
    if(resultes.statusCode==200){

      informationes = BindingFromJson(resultes?.bodyString ?? "");

      for(var i=0;i<informationes.length;i++){
        if(informationes[i].type==4){
          //setState(() {
            mobile['type']=informationes[i].type;
            mobile['name']=informationes[i].name;
            mobile['areaCode']=informationes[i].areaCode;
         // });
        }
        if(informationes[i].type==1){
          //setState(() {
            google['type']=informationes[i].type;
            google['name']=informationes[i].name;
            google['areaCode']=informationes[i].areaCode;
          //});
        }
        if(informationes[i].type==2){
          //setState(() {
            facebook['type']=informationes[i].type;
            facebook['name']=informationes[i].name;
            facebook['areaCode']=informationes[i].areaCode;
         // });
        }if(informationes[i].type==3){
          //setState(() {
            apple['type']=informationes[i].type;
            apple['name']=informationes[i].name;
            apple['areaCode']=informationes[i].areaCode;
          //});
        }
        if(informationes[i].type==5){
          //setState(() {
          email['type']=informationes[i].type;
          email['name']=informationes[i].name;
          email['areaCode']=informationes[i].areaCode;
          //});
        }
        setState(() {});
      }

    }
  }

  @override
  void initState(){
    super.initState();
    shuju();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '账号与安全'.tr,
          style: const TextStyle(fontSize: 16),
        ),
      ),
      body: Container(
        //decoration: BoxDecoration(border: Border.all(color: Colors.red,width: 1)),
          padding: const EdgeInsets.fromLTRB(20, 23, 20, 0),
          color: const Color(0xffF5F5F5),
          child: Column(
            children: <Widget>[
              // Container(
              //   width: double.infinity,
              //   padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              //   decoration:BoxDecoration(
              //     color: Colors.white,
              //     borderRadius: BorderRadius.all(Radius.circular(10.0)),
              //   ),
              //   child: Column(
              //     children: [
              //       GestureDetector(child: Container(
              //         padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
              //         child: Row(
              //           mainAxisAlignment:MainAxisAlignment.spaceBetween,
              //           children: [
              //             Text('手机号'.tr),
              //             Row(
              //               children: [
              //                 Container(
              //                   constraints: BoxConstraints(
              //                     maxWidth: 200, // 最大宽度
              //                   ),
              //                   child:
              //                   mobile['type']!=0?Text(
              //                     mobile['name'].toString(),
              //                     style: TextStyle(
              //                       fontSize: 15,
              //                       color: Color(0xff000000),
              //                     ),
              //                     overflow: TextOverflow.ellipsis,
              //                   ):Text(
              //                     '未绑定'.tr,
              //                     style: TextStyle(
              //                       fontSize: 15,
              //                       color: Color(0xff999999),
              //                     ),
              //                     overflow: TextOverflow.ellipsis,
              //                   ),
              //                 ),
              //                 Icon(Icons.chevron_right,)
              //               ],
              //             )
              //           ],
              //         ) ,
              //       ),onTap: (){
              //         print(mobile['type']);
              //         if(mobile['type']==0){
              //           Get.to(CellPhonePage(),arguments: {'type':1,"phone":''})?.then((value) {
              //             if (value != null) {
              //               shuju();
              //               //此处可以获取从第二个页面返回携带的参数
              //             }
              //           });
              //         }else if(mobile['type']==4){
              //           Get.to(CellPhonePage(),arguments: {'type':2,"phone":mobile['name'].toString()})?.then((value) {
              //             if (value != null) {
              //               shuju();
              //               //此处可以获取从第二个页面返回携带的参数
              //             }
              //           });
              //         }
              //       },) ,
              //     ],
              //   ),
              // ),
              // SizedBox(height: 20,),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                decoration:const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                child: Column(
                  children: [
                    GestureDetector(child: Container(
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                      child: Row(
                        mainAxisAlignment:MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Facebook'),
                         Row(
                            children: [
                              Container(
                                constraints: const BoxConstraints(
                                  maxWidth: 200, // 最大宽度
                                ),
                                child:
                                facebook['type']!=0?Text(
                                  facebook['name'].toString()!=''?facebook['name'].toString():'绑定成功'.tr,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Color(0xff000000),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ):Text(
                                  '未绑定'.tr,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Color(0xff999999),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const Icon(Icons.chevron_right,)
                            ],
                          )
                        ],
                      ) ,
                    ),onTap: (){
                      print(facebook['type']);
                      if(facebook['type']==2){
                        print('22222222');
                        if(informationes.length>1) {
                          _showCupertinoAlertDialog2(
                              context, '解绑Facebook后将无法继续使用它登录该账号'.tr, 2);
                        }
                      }else if(facebook['type']==0){
                        signInWithFacebook(context);
                      }

                    },) ,
                    const Divider(height: 1.0,color: Color(0xffF1F1F1),),
                    GestureDetector(child: Container(
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                      child: Row(
                        mainAxisAlignment:MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Apple ID'),
                          Row(
                            children: [
                              Container(
                                constraints: const BoxConstraints(
                                  maxWidth: 200, // 最大宽度
                                ),
                                child:
                                apple['type']!=0?Text(
                                  apple['name'].toString()!=''?apple['name'].toString():'绑定成功'.tr,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Color(0xff000000),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ):Text(
                                  '未绑定'.tr,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Color(0xff999999),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const Icon(Icons.chevron_right,)
                            ],
                          )
                        ],
                      ) ,
                    ),onTap: (){
                      if(apple['type']==0){
                        signInWithApple();
                      }else if(apple['type']==3){
                        if(informationes.length>1){
                          _showCupertinoAlertDialog2(context,'解绑Apple ID后将无法继续使用它登录该账号'.tr,3);
                        }
                      }
                    },) ,
                    const Divider(height: 1.0,color: Color(0xffF1F1F1),),
                    GestureDetector(child: Container(
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                      child: Row(
                        mainAxisAlignment:MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Google'),
                          Row(
                            children: [
                              Container(
                                constraints: const BoxConstraints(
                                  maxWidth: 200, // 最大宽度
                                ),
                                child: google['type']!=0?Text(
                                  google['name'].toString()!=''?google['name'].toString():'绑定成功'.tr,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Color(0xff000000),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ):Text(
                                  '未绑定'.tr,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Color(0xff999999),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const Icon(Icons.chevron_right,)
                            ],
                          )
                        ],
                      ) ,
                    ),onTap: (){
                        if(google['type']==0){
                          handleSignIn(context);
                        }else if(google['type']==1){
                          if(informationes.length>1) {
                            _showCupertinoAlertDialog2(
                                context, '解绑Google后将无法继续使用它登录该账号'.tr, 1);
                          }
                        }
                    },),
                    const Divider(height: 1.0,color: Color(0xffF1F1F1),),
                    ///手机号
                    if(mobile['type']!=0)GestureDetector(child: Container(
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                      child: Row(
                        mainAxisAlignment:MainAxisAlignment.spaceBetween,
                        children: [
                          Text('手机号'.tr),
                          Row(
                            children: [
                              Container(
                                constraints: const BoxConstraints(
                                  maxWidth: 200, // 最大宽度
                                ),
                                child:
                                mobile['type']!=0?Text(
                                  mobile['name'].toString(),
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Color(0xff000000),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ):Text(
                                  '未绑定'.tr,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Color(0xff999999),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const Icon(Icons.chevron_right,)
                            ],
                          )
                        ],
                      ) ,
                    ),onTap: (){
                      // if(mobile['type']==0){
                      //   Get.to(CellPhonePage(),arguments: {'type':1,"phone":''})?.then((value) {
                      //     if (value != null) {
                      //       shuju();
                      //       //此处可以获取从第二个页面返回携带的参数
                      //     }
                      //   });
                      // }else if(mobile['type']==4){
                      //   Get.to(CellPhonePage(),arguments: {'type':2,"phone":mobile['name'].toString()})?.then((value) {
                      //     if (value != null) {
                      //       shuju();
                      //       //此处可以获取从第二个页面返回携带的参数
                      //     }
                      //   });
                      // }
                    },),
                    const Divider(height: 1.0,color: Color(0xffF1F1F1),),
                    ///邮箱绑定
                    GestureDetector(child: Container(
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                      child: Row(
                        mainAxisAlignment:MainAxisAlignment.spaceBetween,
                        children: [
                          Text('邮箱'.tr),
                          Row(
                            children: [
                              Container(
                                constraints: const BoxConstraints(
                                  maxWidth: 200, // 最大宽度
                                ),
                                child:
                                email['type']!=0?Text(
                                  email['name'].toString(),
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Color(0xff000000),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ):Text(
                                  '未绑定'.tr,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Color(0xff999999),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const Icon(Icons.chevron_right,)
                            ],
                          )
                        ],
                      ) ,
                    ),onTap: (){

                      if(email['type']==0){
                        Get.to(bindingemailoginPage())?.then((value) {
                          print('邮箱注册成功');
                          if (value != null) {
                            shuju();
                            //此处可以获取从第二个页面返回携带的参数
                          }
                            //此处可以获取从第二个页面返回携带的参数
                        });
                      }else if(email['type']==5){
                        if(informationes.length>1&&antishake){
                          _showCupertinoAlertDialog2(context,'解绑email后将无法继续使用它登录该账号'.tr,5);
                        }
                      }
                    },),
                  ],
                ),
              ),
            ],)
      ),
      bottomNavigationBar: Container(
        color: const Color(0xffF5F5F5),
        padding: const EdgeInsets.all(50),
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(const Color(0xff000000)),
          ),
          onPressed: ()  {
            if(antishake){
              confirmationofcancellation(context);
            }

          },
          child: Text('注销账户'.tr,style: const TextStyle(
            fontSize: 17,
            color: Colors.white,
          ),textAlign: TextAlign.center,),
        ),
      ),
    );
  }


///解绑弹窗
  _showCupertinoAlertDialog2(BuildContext context,text,index) async {
    bool? results = await showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text("确认解绑？".tr), // 标题
          content:  Container(margin: const EdgeInsets.fromLTRB(0, 15, 0, 15),
            child:Text(text),) , // 内容
          insetAnimationDuration: const Duration(
              milliseconds: 200), // 动画时间，默认为 const Duration(milliseconds: 100)
          insetAnimationCurve:
          Curves.bounceIn, // 动画效果，渐进渐出等等，默认为 Curves.decelerate
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text("取消".tr),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text("确定".tr),
            ),
          ],
        );
      },
    );

    if (results == null) {
      print("用户的选择111:'取消'");
    } else {
      if(results && antishake){
        antishake=false;
        var Unbindingresult = await SetUprovider.Unbinding(index);
        if(Unbindingresult.statusCode==200){
          if(index==2){
            setState(() {
              facebook= {
                'name':'',
                "type":0
              };
            });
          }
          if(index==1){
            setState(() {
              google= {
                'name':'',
                "type":0
              };
            });
          }
          if(index==3){
            setState(() {
              apple= {
                'name':'',
                "type":0
              };
            });
          }
          if(index==5){
            setState(() {
              email= {
                'name':'',
                "type":0
              };
            });
          }
          Toast.toast(context,msg: "解绑成功".tr,position: ToastPostion.center);
        }
        antishake=true;
      }
        print("用户的选择222:${results ? '确定' : '取消'}");
    }
  }

  ///注销弹窗

  confirmationofcancellation(BuildContext context) async {
    bool? result = await showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text("您确定要注销当前账号吗".tr), // 标题
          content:  Container(margin: const EdgeInsets.fromLTRB(0, 15, 0, 15),
            child:Text("账号注销后会永久删除所有数据".tr),) , // 内容
          insetAnimationDuration: const Duration(
              milliseconds: 200), // 动画时间，默认为 const Duration(milliseconds: 100)
          insetAnimationCurve:
          Curves.bounceIn, // 动画效果，渐进渐出等等，默认为 Curves.decelerate
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text("取消".tr,style: const TextStyle(color: Color(0xff999999)),),
            ),
            TextButton(
              onPressed: () async {
                if(antishake){
                  Publicmethods.loades(context,'');
                  antishake=false;
                  await widget.userLogic.cancelAccount();
                  WebSocketes.channel.sink.close();
                  widget.userLogic.Chatdisconnected=false;
                  widget.userLogic.update();
                  antishake=true;
                  Navigator.pop(context);
                  //Navigator.pop(context);
                  Get.offAll(HomePage());
                  Get.find<HomeLogic>().setNowPage(0);
                }

              },
              child: Text("确定".tr,style: const TextStyle(color: Colors.black),),
            ),
          ],
        );
      },
    );
  }
}