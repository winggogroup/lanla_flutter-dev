import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lanla_flutter/common/controller/UserLogic.dart';
import 'package:lanla_flutter/common/controller/publicmethodes.dart';
import 'package:lanla_flutter/common/toast/view.dart';
import 'package:lanla_flutter/services/SetUp.dart';
import 'package:lanla_flutter/ulits/toast.dart';

class ForcedrebindingPage extends StatefulWidget {
  @override
  createState() => ForcedrebindingState();
}
class ForcedrebindingState extends State<ForcedrebindingPage>{
  Publicmethodes Publicmethods = Get.put(Publicmethodes());
  SetUpProvider SetUprovider =  Get.put(SetUpProvider());
  final userLogic = Get.find<UserLogic>();
 bool isexpand=false;
  late StreamSubscription _dynamicLinkSubscription;
  var emaildata;

  @override
  void initState() {
    emaildata=Get.arguments;
    print('什么数据${emaildata['email']}');
  }
  @override
  void dispose() {
    // 在页面销毁时取消监听 Firebase Dynamic Links 事件
    super.dispose();
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
            const SizedBox(height: 50,),
            Container(child:Text('你的邮箱账号'.tr+emaildata['email']+'已被下方账号绑定'.tr,textAlign:TextAlign.center,style: const TextStyle(fontSize: 15),),margin: const EdgeInsets.fromLTRB(50, 0, 50, 0),),
            //Container(child:Row(children: [Text('你的邮箱账号'.tr,textAlign:TextAlign.center,style: TextStyle(fontSize: 15),),Text(emaildata['email'],textAlign:TextAlign.center,style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600),),Text('已被下方账号绑定'.tr,textAlign:TextAlign.center,style: TextStyle(fontSize: 15),)],),margin: EdgeInsets.fromLTRB(50, 0, 50, 0),),

            const SizedBox(height: 20,),
            Container(decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.05),
                      //color:Colors.black,
                      offset: Offset(0.0, 0.0), //阴影xy轴偏移量
                      blurRadius: 15, //阴影模糊程度
                      spreadRadius: 5 //阴影扩散程度
                  )
                ]
            ),margin: const EdgeInsets.only(left: 20,right: 20,),padding: const EdgeInsets.fromLTRB(20, 25, 20, 25),child: Row(children: [
              Container(width: 69,height: 69,clipBehavior: Clip.hardEdge,decoration: const BoxDecoration(  color: Color.fromRGBO(0, 0, 0, 0.05) ,borderRadius: BorderRadius.all(Radius.circular(50))),child:CachedNetworkImage(
                imageUrl: emaildata['have_email_user_info']['headimg'],
                fit: BoxFit.cover,
                placeholder: (context, url) => Image.asset('assets/images/zhanweitufont.png',fit: BoxFit.cover,),
              ) ,),
              const SizedBox(width: 10,),
              Expanded(child: Container(child: Column(crossAxisAlignment:CrossAxisAlignment.start,children: [
                Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children: [
                  Text(emaildata['have_email_user_info']['nickname'],style: const TextStyle(fontWeight: FontWeight.w600),),
                  Container(padding: const EdgeInsets.all(7),decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(2)),border: Border.all(width: 1,color: const Color.fromRGBO(255, 14, 57, 1))),child: Text(
                    '当前绑定'.tr,style: const TextStyle(fontSize: 9,color:Color.fromRGBO(255, 14, 57, 1)),),),

                ],),

                Row(
                  children: [
                    Text(
                      '${DateTime.fromMillisecondsSinceEpoch(emaildata['have_email_user_info']['first_login_timestamp'] * 1000).year}-${DateTime.fromMillisecondsSinceEpoch(emaildata['have_email_user_info']['first_login_timestamp'] * 1000).month.toString().padLeft(2, '0')}-${DateTime.fromMillisecondsSinceEpoch(emaildata['have_email_user_info']['first_login_timestamp'] * 1000).day.toString().padLeft(2, '0')}',
                      strutStyle: const StrutStyle(
                        forceStrutHeight: true,
                        leading: 0.5,
                      ),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color.fromRGBO(153, 153, 153, 1),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      '注册'.tr,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color.fromRGBO(153, 153, 153, 1),
                      ),
                      strutStyle: const StrutStyle(
                        forceStrutHeight: true,
                        leading: 0.5,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 6,),
                GestureDetector(child: Row(crossAxisAlignment: CrossAxisAlignment.center,children: [Text('账号绑定状态'.tr,style: const TextStyle(fontSize: 12,color: Color.fromRGBO(153, 153, 153, 1),height: 1),),const SizedBox(width: 5,),Image.asset(!isexpand?'assets/images/xiajiantou.png':'assets/images/shangjiantou.png',width: 12,height: 6,)],),
                  onTap: (){
                  setState(() {
                    isexpand=!isexpand;
                  });
                },)
              ],),)),
            ],),),
            if(isexpand)Container(decoration: BoxDecoration(
                color: Colors.white,
                // border: Border(
                //     bottom: BorderSide(width: 1,color: Color.fromRGBO(0, 0, 0, 0.05)),
                //     left: BorderSide(width: 1,color: Color.fromRGBO(0, 0, 0, 0.05)),
                //     right: BorderSide(width: 1,color: Color.fromRGBO(0, 0, 0, 1))
                // ),
                border: Border.all(width: 1,color: const Color.fromRGBO(0, 0, 0, 0.05)),
              borderRadius: const BorderRadius.all(Radius.circular(5))
            ),margin: const EdgeInsets.only(left: 30,right: 30,),padding: const EdgeInsets.all(20),child: Column(children: [
              for(var i=0;i<emaildata['have_email_user_info']['login_method_list'].length;i++)
              if(emaildata['have_email_user_info']['login_method_list'][i]['type']!=5)Row(children: [

                Image.asset(emaildata['have_email_user_info']['login_method_list'][i]['type']==1?'assets/images/bdgoogle.png':emaildata['have_email_user_info']['login_method_list'][i]['type']==2?'assets/images/bdfacebook.png':emaildata['have_email_user_info']['login_method_list'][i]['type']==3?'assets/images/bdapple.png':emaildata['have_email_user_info']['login_method_list'][i]['type']==4?'assets/images/bdphone.png':'',width: 15,height: 15,),
                const SizedBox(width: 5,),
                Text(emaildata['have_email_user_info']['login_method_list'][i]['name'],style: const TextStyle(fontSize: 12,color: Color.fromRGBO(153, 153, 153, 1)),),

              ],)
            ],),),
            SizedBox(height: isexpand?20:40,),
            if(!isexpand)Container(alignment: Alignment.center,child: Text('是否换绑至当前登录账号'.tr,textAlign:TextAlign.center,),),
            const SizedBox(height: 20,),
            Container(decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.05),
                      //color:Colors.black,
                      offset: Offset(0.0, 0.0), //阴影xy轴偏移量
                      blurRadius: 15, //阴影模糊程度
                      spreadRadius: 5 //阴影扩散程度
                  )
                ]
            ),margin: const EdgeInsets.only(left: 20,right: 20,),padding: const EdgeInsets.fromLTRB(20, 25, 20, 25),child: Row(children: [
              Container(width: 69,height: 69,clipBehavior: Clip.hardEdge,decoration: const BoxDecoration(  color: Color.fromRGBO(0, 0, 0, 0.05) ,borderRadius: BorderRadius.all(Radius.circular(50))),child:CachedNetworkImage(
                imageUrl: userLogic.userAvatar,
                fit: BoxFit.cover,
                placeholder: (context, url) => Image.asset('assets/images/zhanweitufont.png',fit: BoxFit.cover,),
              ) ,),
              const SizedBox(width: 10,),
              Expanded(child: Column(crossAxisAlignment:CrossAxisAlignment.start,children: [
                Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children: [
                  Text(userLogic.userName,style: const TextStyle(fontWeight: FontWeight.w600),),
                  Container(padding: const EdgeInsets.all(7),decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(2)),border: Border.all(width: 1,color: const Color.fromRGBO(238, 238, 238, 1))),child: Text(
                    '当前登录'.tr,style: const TextStyle(fontSize: 9,color:Color.fromRGBO(153, 153, 153, 1)),),),

                ],),
                const SizedBox(height: 8,),
                Row(
                  children: [
                    Text(
                      '${DateTime.fromMillisecondsSinceEpoch(emaildata['current_user_info']['first_login_timestamp'] * 1000).year}-${DateTime.fromMillisecondsSinceEpoch(emaildata['current_user_info']['first_login_timestamp'] * 1000).month.toString().padLeft(2, '0')}-${DateTime.fromMillisecondsSinceEpoch(emaildata['current_user_info']['first_login_timestamp'] * 1000).day.toString().padLeft(2, '0')}',
                      strutStyle: const StrutStyle(
                        forceStrutHeight: true,
                        leading: 0.5,
                      ),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color.fromRGBO(153, 153, 153, 1),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      '注册'.tr,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color.fromRGBO(153, 153, 153, 1),
                      ),
                      strutStyle: const StrutStyle(
                        forceStrutHeight: true,
                        leading: 0.5,
                      ),
                    )
                  ],
                )
              ],)),
            ],),),
            const SizedBox(height: 40,),
            ///换绑
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

                child: Text('换绑'.tr,style: const TextStyle(fontWeight: FontWeight.w700),),
                onPressed: () async {
                  Publicmethods.loades(context,'');
                  var BindingResults = await SetUprovider.bindEmailAccount( emaildata['idToken'],emaildata['email'],);
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
                },
              ),
            ),
            const SizedBox(height: 30,),
            ///暂不换绑
            GestureDetector(child: Container(
              height: 56,
              alignment: Alignment.center,
              decoration: const BoxDecoration(color: Color.fromRGBO(249, 249, 249, 1),borderRadius: BorderRadius.all(Radius.circular(37))),
              // child: ElevatedButton(
              //   style: ButtonStyle(
              //     backgroundColor:MaterialStateProperty.all(Color.fromRGBO(255, 255, 255, 1)),
              //     // foregroundColor: MaterialStateProperty.all(Color.fromRGBO(249, 249, 249, 1)),
              //     // elevation: MaterialStateProperty.all(20),
              //     shadowColor: MaterialStateProperty.all(Color.fromRGBO(0, 0, 0, 0.05)),
              //     elevation: MaterialStateProperty.all(5),
              //     shape: MaterialStateProperty.all(
              //         RoundedRectangleBorder(
              //             borderRadius: BorderRadius.circular(37))
              //     ),
              //   ),
              //
              //   child: Text('暂不换绑'.tr,style: const TextStyle(fontWeight: FontWeight.w700,color: Color.fromRGBO(153, 153, 153, 1)),),
              //   onPressed: () async {
              //     Get.back();
              //   },
              // ),
              child: Text('暂不换绑'.tr,style: const TextStyle(fontWeight: FontWeight.w700,color: Color.fromRGBO(153, 153, 153, 1)),),
            ),onTap: (){
              Get.back();
            },),
          ],
        ),
      ),
      appBar: AppBar(
        elevation: 0,//消除阴影
        backgroundColor: Colors.white,//设置背景颜色为白色
        title: Text('绑定失败'.tr,style:const TextStyle(fontSize: 16)),
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
