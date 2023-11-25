import 'dart:async';
import 'dart:convert';

import 'package:adjust_sdk/adjust.dart';
import 'package:adjust_sdk/adjust_event.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

class PasswordmodificationPage extends StatefulWidget {
  @override
  createState() => PasswordmodificationState();
}
class PasswordmodificationState extends State<PasswordmodificationPage>{

  Publicmethodes Publicmethods = Get.put(Publicmethodes());
  LoginProvider provider =  Get.put(LoginProvider());
  final userLogic = Get.find<UserLogic>();
  UserHomeProvider InvitationCodeprovider =  Get.put(UserHomeProvider());

  bool antishake=true;
  String passwordnum='';


  final TextEditingController _textEditingController = TextEditingController();
  @override
  void initState() {
    super.initState();

  }
  @override
  void dispose() {

    _textEditingController.dispose();
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
            const SizedBox(height: 60),
            Text('密码登录'.tr,style:const TextStyle(fontSize: 25,fontWeight: FontWeight.w600),),
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
                    Expanded(flex: 1,child:
                    TextField(
                      controller: _textEditingController,

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
                          hintText: "请设置5位数及以上的密码".tr
                      ),
                      style: const TextStyle(fontSize: 15),
                      onChanged: (text) {
                        passwordnum=text;
                        setState(() {

                        });
                      },
                    ),
                    ),
                  ]
              ),
            ),
            const Divider(height: 1.0,color: Color(0xFFf1f1f1),),
            const SizedBox(height: 25),
            Text('您的密码错误，请重新输入'.tr,style:const TextStyle(fontSize: 12,color: Color.fromRGBO(255, 0, 0, 1)),),
            const SizedBox(height: 120),
            GestureDetector(child: Container(alignment: Alignment.center,child: Text('忘记密码'.tr,style: const TextStyle(fontSize: 14,fontWeight: FontWeight.w700,color: Color.fromRGBO(168, 246, 0, 1)),),),onTap: (){

            },),
            const SizedBox(height: 25,),
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
                child: Text('下一步'.tr,style: const TextStyle(fontWeight: FontWeight.w700),),
                onPressed: () async {

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
