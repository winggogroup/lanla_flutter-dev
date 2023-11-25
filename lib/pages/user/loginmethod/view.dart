import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lanla_flutter/pages/user/NewMobileverification/index.dart';
import 'package:lanla_flutter/pages/user/emaillogin/index.dart';
import 'package:lanla_flutter/pages/user/login/view.dart';
import 'package:lanla_flutter/ulits/app_log.dart';
//跳转的页面
import 'logic.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginmethodPage extends StatelessWidget {
  final logic = Get.put(LoginmethodLogic());
  final state = Get.find<LoginmethodLogic>().state;
  bool antishake=true;

  @override
  Widget build(BuildContext context) {
    print('见来了');
    return Container(
        decoration: BoxDecoration(
             color:Colors.white,
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(0, 54, 0, 30),
              width: double.infinity,
              height: 150,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fitWidth,
                  image: AssetImage(
                      'assets/images/bjtwo.png'
                  ),
                ),
              ),
              // color: Colors.black,
              // height: 300,
              // decoration: BoxDecoration(border: Border.all(color: Colors.red)),
              // child:Image.asset('assets/images/logothree.png',width: 88, height: 88,),
            ),
            // Container(
            //   width: 102,
            //   height: 102,
            //   // decoration: BoxDecoration(border: Border.all(color: Colors.red)),
            //   child: Image.asset('assets/images/logo.png',fit: BoxFit.fill),
            // ),
            const SizedBox(height: 40),
            // Text('LanLa',style:TextStyle(
            //   color: Colors.white,
            //   fontSize: 30,
            //   fontFamily: 'PingFang SC-Semibold',
            //   fontWeight:  FontWeight.w600,
            //     decoration:TextDecoration.none
            // )),
            // SizedBox(height: 15),
            Text('您的美好生活指南！'.tr,style:TextStyle(
                color: Colors.black,
                fontSize: 22,
                fontWeight:  FontWeight.w600,
                decoration:TextDecoration.none
            )),
            Expanded(
             flex: 1, child: Stack(
              children: [
                Positioned(
                  left: 0,
                  right: 0,
                  bottom:20,
                  child: Column(
                    children: [
                      // GestureDetector(
                      //   child: Container(
                      //     margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      //     height: 56,
                      //     decoration: BoxDecoration(
                      //       color: Colors.black,
                      //       borderRadius:BorderRadius.circular((46)),
                      //       boxShadow:const [
                      //         BoxShadow(
                      //           color: Color(0x33000000),
                      //           offset: Offset(0, 5),
                      //           blurRadius: 10,
                      //           spreadRadius: 1,
                      //         ),
                      //       ],
                      //     ),
                      //     child:
                      //     Stack(
                      //       children: [
                      //         Container(
                      //           width: double.infinity,
                      //           height: 56,
                      //           // decoration: BoxDecoration(border: Border.all(color: Colors.red),color: Colors.red),
                      //           child: Row(
                      //             mainAxisAlignment:MainAxisAlignment.center,
                      //             children: [
                      //               Text('Phone'.tr,style:const TextStyle(
                      //                 color: Colors.white,
                      //                 fontSize: 16,
                      //                 decoration:TextDecoration.none,
                      //                 fontWeight:  FontWeight.w600,
                      //               )),
                      //             ],
                      //           ),
                      //         ),
                      //         Positioned(
                      //           bottom: 17,
                      //           left: 60,
                      //           child: Image.asset(
                      //             'assets/images/shoujitwo.png',
                      //             width: 26,
                      //             height: 26,),
                      //         )
                      //       ],
                      //     ),
                      //
                      //   ),
                      //   onTap: (){
                      //     AppLog('tap',event:'phone_sgin');
                      //     FirebaseAnalytics.instance.logEvent(
                      //       name: "login_tap_phone",
                      //       parameters: {
                      //
                      //       },
                      //     );
                      //     Get.to(LoginPage());
                      //   },
                      // ),
                      ///facebook
                      GestureDetector(
                        child: Container(
                          margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                          height: 56,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius:BorderRadius.circular((46)),
                            boxShadow:const [
                              BoxShadow(
                                color: Color(0x33000000),
                                offset: Offset(0, 5),
                                blurRadius: 10,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child:
                          Stack(
                            children: [
                              Container(
                                width: double.infinity,
                                height: 56,
                                // decoration: BoxDecoration(border: Border.all(color: Colors.red),color: Colors.red),
                                child: Row(
                                  mainAxisAlignment:MainAxisAlignment.center,
                                  children: [
                                    Text('Facebook'.tr,style:const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      decoration:TextDecoration.none,
                                      fontWeight:  FontWeight.w600,
                                    )),
                                  ],
                                ),
                              ),
                              Positioned(
                                bottom: 17,
                                right: 60,
                                child: Image.asset(
                                  'assets/images/facebooklogin.png',
                                  width: 26,
                                  height: 26,),
                              )
                            ],
                          ),
                        ),
                        onTap: () async {
                          if(antishake){
                            antishake=false;
                            AppLog('tap',event: 'fb_sgin');
                            FirebaseAnalytics.instance.logEvent(
                              name: "login_tap_facebook",
                              parameters: {
                              },
                            );
                            await logic.signInWithFacebook(context);
                            antishake=true;
                          }
                        },
                      ),
                      SizedBox(height: 20),
                      Platform.isIOS?GestureDetector(
                        child: Container(
                          margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                          height: 56,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius:BorderRadius.circular((46)),
                            boxShadow:const [
                              BoxShadow(
                                color: Color(0x33000000),
                                offset: Offset(0, 5),
                                blurRadius: 10,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child:
                          Stack(
                            children: [
                              Container(
                                width: double.infinity,
                                height: 56,
                                // decoration: BoxDecoration(border: Border.all(color: Colors.red),color: Colors.red),
                                child: Row(
                                  mainAxisAlignment:MainAxisAlignment.center,
                                  children: [
                                    Text('Apple'.tr,style:const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      decoration:TextDecoration.none,
                                      fontWeight:  FontWeight.w600,
                                    )),
                                  ],
                                ),
                              ),
                              Positioned(
                                bottom: 17,
                                right: 60,
                                child: Image.asset(
                                  'assets/images/applelogin.png',
                                  width: 26,
                                  height: 26,),
                              )
                            ],
                          ),
                        ),
                        onTap: () async {
                          if(antishake) {
                            antishake=false;
                            print('88888888888');
                            AppLog('tap', event: 'apple_sgin');
                            FirebaseAnalytics.instance.logEvent(
                              name: "login_tap_apple",
                              parameters: {
                              },
                            );
                            await logic.signInWithApple(context);
                            antishake=true;
                          }
                        },
                      ):GestureDetector(
                        child: Container(
                          margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                          height: 56,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius:BorderRadius.circular((46)),
                            boxShadow:const [
                              BoxShadow(
                                color: Color(0x33000000),
                                offset: Offset(0, 5),
                                blurRadius: 10,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child:
                          Stack(
                            children: [
                              Container(
                                width: double.infinity,
                                height: 56,
                                // decoration: BoxDecoration(border: Border.all(color: Colors.red),color: Colors.red),
                                child: Row(
                                  mainAxisAlignment:MainAxisAlignment.center,
                                  children: [
                                    Text('Google'.tr,style:const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      decoration:TextDecoration.none,
                                      fontWeight:  FontWeight.w600,
                                    )),
                                  ],
                                ),
                              ),
                              Positioned(
                                bottom: 17,
                                right: 60,
                                child: Image.asset(
                                  'assets/images/googlelogin.png',
                                  width: 26,
                                  height: 26,),
                              )
                            ],
                          ),
                        ),
                        onTap: () async {
                          if(antishake){
                            antishake=false;
                            AppLog('tap',event: 'google_sgin');
                            FirebaseAnalytics.instance.logEvent(
                              name: "login_tap_google",
                              parameters: {

                              },
                            );
                            await logic.handleSignIn(context);
                            antishake=true;
                          }
                        },
                      ),
                      // const SizedBox(height: 20),
                      // GestureDetector(
                      //   child: Container(
                      //     margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      //     height: 56,
                      //     decoration: BoxDecoration(
                      //       color: Colors.black,
                      //       borderRadius:BorderRadius.circular((46)),
                      //       boxShadow: const [
                      //         BoxShadow(
                      //           color: Color(0x33000000),
                      //           offset: Offset(0, 5),
                      //           blurRadius: 10,
                      //           spreadRadius: 1,
                      //         ),
                      //       ],
                      //     ),
                      //     child:
                      //     Stack(
                      //       children: [
                      //         Container(
                      //           width: double.infinity,
                      //           height: 56,
                      //           // decoration: BoxDecoration(border: Border.all(color: Colors.red),color: Colors.red),
                      //           child: Row(
                      //             mainAxisAlignment:MainAxisAlignment.center,
                      //             children: const [
                      //                Text('Apple',style: TextStyle(
                      //                 color: Colors.white,
                      //                 fontSize: 16,
                      //                 //fontFamily: 'PingFang SC-Semibold',
                      //                 decoration:TextDecoration.none,
                      //                 fontWeight:  FontWeight.w600,
                      //               ),)
                      //             ],
                      //           ),
                      //         ),
                      //         Positioned(
                      //             bottom: 19,
                      //             left: 60,
                      //             child: GestureDetector(child:Image.asset(
                      //               'assets/images/appletwo.png',
                      //               width: 22,
                      //               height: 22,) , onTap: (){
                      //
                      //             },)
                      //         )
                      //       ],
                      //     ),
                      //   ),
                      //     onTap: (){
                      //       print('88888888888');
                      //       AppLog('tap',event: 'apple_sgin');
                      //       FirebaseAnalytics.instance.logEvent(
                      //         name: "login_tap_apple",
                      //         parameters: {
                      //
                      //         },
                      //       );
                      //       logic.signInWithApple(context);
                      //     }
                      // ),
                      const SizedBox(height: 40),
                      Row(
                        children: [
                          Expanded(
                          flex: 1,
                          child: Container(
                            height: 0.5,
                            margin: const EdgeInsets.fromLTRB(20, 0, 7, 0),
                            color: const Color.fromRGBO(0, 0, 0, 0.5),
                          ),
                         ),
                          Text('或'.tr,style:const TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              //fontFamily: 'PingFang SC-Regular',
                              fontWeight:  FontWeight.w400,
                              decoration:TextDecoration.none
                          )),
                          Expanded(
                            flex: 1,
                            child: Container(
                              height: 0.5,
                              margin: const EdgeInsets.fromLTRB(7, 0, 20, 0),
                              color: const Color.fromRGBO(0, 0, 0, 0.5),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment:MainAxisAlignment.spaceEvenly,
                        children: [
                          // Container(
                          //   width: 40,
                          //   height: 40,
                          //   decoration: BoxDecoration(border: Border.all(color: Colors.red)),
                          // ),



                          ///apple
                          !Platform.isIOS?GestureDetector(child:Image.asset('assets/images/appleicontwo.png',width: 40,height: 40,),onTap: () async {
                            if(antishake) {
                              antishake=false;
                              print('88888888888');
                              AppLog('tap', event: 'apple_sgin');
                              FirebaseAnalytics.instance.logEvent(
                                name: "login_tap_apple",
                                parameters: {
                                },
                              );
                              await logic.signInWithApple(context);
                              antishake=true;
                            }
                          },):


                          GestureDetector(child:Image.asset('assets/images/googicontwo.png',width: 40,height: 40,),onTap: () async {
                            if(antishake){
                              antishake=false;
                              AppLog('tap',event: 'google_sgin');
                              FirebaseAnalytics.instance.logEvent(
                                name: "login_tap_google",
                                parameters: {

                                },
                              );
                              await logic.handleSignIn(context);
                              antishake=true;
                            }

                          },),
                          // GestureDetector(child:Image.asset('assets/images/facebookicontwo.png',width: 40,height: 40,),onTap: () async {
                          //   if(antishake){
                          //     antishake=false;
                          //     AppLog('tap',event: 'fb_sgin');
                          //     FirebaseAnalytics.instance.logEvent(
                          //       name: "login_tap_facebook",
                          //       parameters: {
                          //
                          //       },
                          //     );
                          //     await logic.signInWithFacebook(context);
                          //     antishake=true;
                          //   }
                          //
                          // },)

                          ///手机号
                          GestureDetector(child:Image.asset('assets/images/phonebottom.png',width: 40,height: 40,),onTap: () async {
                            if(antishake) {
                              antishake=false;
                              // FirebaseAnalytics.instance.logEvent(
                              //   name: "login_tap_phone",
                              //   parameters: {},
                              // );
                              // Get.to(LoginPage());
                              Get.to(MobileverificationPage());
                              antishake=true;
                            }
                          },),
                          ///邮箱
                          GestureDetector(child:Image.asset('assets/images/emailogin.png',width: 40,height: 40,),onTap: () async {
                            if(antishake) {
                              antishake=false;
                              FirebaseAnalytics.instance.logEvent(
                                name: "login_tap_email",
                                parameters: {
                                },
                              );
                              // await logices.signInWithFacebook(context);
                              Get.to(emailoginPage());
                              antishake=true;
                            }
                          },)
                        ],
                      ),
                      const SizedBox(height: 15),
                      Container(
                        width: 280,
                        // decoration: BoxDecoration(border: Border.all(color: Colors.red)),
                        child: Column(
                          children: [
                            Text('登录或注册意味着您同意'.tr,style:TextStyle(
                            color: Color(0xff999999),
                            fontSize: 12,
                            //fontFamily: 'PingFang SC-Regular',
                            fontWeight:  FontWeight.w400,
                            decoration:TextDecoration.none
                            )),
                            SizedBox(height: 5,),
                            Row(
                              mainAxisAlignment:MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                child:Text('隐私政策'.tr,style:TextStyle(
                                    color: Color(0xff000000),
                                    fontSize: 12,
                                    fontWeight:  FontWeight.w400,
                                    decoration:TextDecoration.none
                                )),
                                  onTap: () {
                                    launchUrl(Uri.parse("https://www.lanla.app/ys.html"),mode: LaunchMode.externalApplication,);
                                  },
                                ),
                                Text('与'.tr,style:TextStyle(
                                    color: Color(0xff999999),
                                    fontSize: 12,
                                    fontWeight:  FontWeight.w400,
                                    decoration:TextDecoration.none
                                )),
                                GestureDetector(
                                  child:Text('用户协议'.tr,style:TextStyle(
                                      color: Color(0xff000000),
                                      fontSize: 12,
                                      fontWeight:  FontWeight.w400,
                                      decoration:TextDecoration.none
                                  )),
                                  onTap: () {
                                    launchUrl(Uri.parse("https://www.lanla.app/UserAgreement.html"), mode: LaunchMode.externalApplication,);
                                  },
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            ),


          ],
        ),
    );
  }
}
