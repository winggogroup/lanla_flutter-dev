import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:lanla_flutter/common/controller/UserLogic.dart';
import 'package:lanla_flutter/pages/home/view.dart';
import 'package:lanla_flutter/services/user.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import '../../../common/function.dart';
import '../../../common/toast/view.dart';
import '../../../services/user_home.dart';
import '../../../ulits/aliyun_oss/client.dart';
import '../../../ulits/compress.dart';
import '../../../ulits/toast.dart';


class InvitationPage extends StatefulWidget  {
  @override
  _SecondWidgetState createState() => _SecondWidgetState();
  UserHomeProvider InvitationCodeprovider =  Get.put(UserHomeProvider());
}

class _SecondWidgetState extends State<InvitationPage> {
  String code = '';
  bool antishake=true;

  // InvitationPage({super.key}) {
  //   //ToastInfo('测试版提示：此页面未经设计');
  // }
  final FocusNode _nodeText1 = FocusNode();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      // appBar: AppBar(
      //   // title: Text(
      //   //   '填写邀请码'.tr,
      //   //   style: TextStyle(fontSize: 16),
      //   // ),
      // ),
      body:
      ListView(
        children: [
          SizedBox(height: 23+MediaQueryData.fromWindow(window).padding.top,),
          Container(width: double.infinity,child: Image.asset('assets/images/yqmbj.png',fit: BoxFit.cover,),),
          Container(alignment: Alignment.centerRight,padding:const EdgeInsets.all(20),child: Text('填写好友邀请码'.tr,style: const TextStyle(fontWeight: FontWeight.w600),),),
          KeyboardActions(
            autoScroll:false,
            config: KeyboardActionsConfig(
                keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
                keyboardBarColor: Colors.white,
                nextFocus: false,
                //nextFocus: true,
                defaultDoneWidget: Text("完成".tr),

                actions: [
                  KeyboardActionsItem(
                    focusNode: _nodeText1,
                  ),

                ]),
            child:Container(
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              height: 56,
              decoration: BoxDecoration(
                border: Border.all(width: 2,color: Colors.black),
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x3347B000),
                    offset: Offset(0, 2),
                    blurRadius: 5,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child:TextField(
                focusNode: _nodeText1,
                keyboardType: TextInputType.number,
                cursorColor: const Color(0xff666666),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                  hintText: "填写好友邀请码（非必填项）".tr,
                  hintStyle: const TextStyle(color: Color(0xff666666)),
                  border: InputBorder.none,
                  // enabledBorder: OutlineInputBorder(
                  //   borderSide: BorderSide(color: Color(0xff666666)),
                  // ),
                  // focusedBorder: OutlineInputBorder(
                  //   borderSide: BorderSide(color: Color(0xff666666)),
                  // ),
                ),
                onChanged: (text) {

                  setState(() {
                    code = text;
                  });
                },
              ),
            ),


          ),
          Container(width: double.infinity,child: Padding(
            padding: const EdgeInsets.only(left: 20,top: 50,right: 20,bottom: 20),
            child:
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(const Color(0xff000000)),
              ),
              onPressed: () async {
                if(antishake){
                  antishake=false;
                  if (code != '') {
                    var result =
                    await widget.InvitationCodeprovider.getinviteCode(code);
                    print('8888888888888');
                    if (result?.statusCode == 200) {
                      Get.offAll(HomePage());
                      Toast.toast(context,
                          msg: "填写成功".tr, position: ToastPostion.bottom);
                    }
                  }
                  Timer.periodic(const Duration(milliseconds: 1000),(timer){
                    antishake=true;
                    timer.cancel();//取消定时器
                  }
                  );
                  //
                }

              },
              child: Text(
                '确定'.tr,
                style: const TextStyle(
                  fontSize: 17,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),),
          GestureDetector(child: Container(alignment: Alignment.center,margin: const EdgeInsets.only(bottom: 20),child:Text('跳过'.tr,style: const TextStyle(
            color: Color(0xff666666),

          ),) ,),onTap: (){
            Get.offAll(HomePage());
            //Get.to(ChooseTopicPage());
          },),
        ],
      ),
      // bottomNavigationBar: Column(children: [
      //   Text('123'),
      //   Text('123'),
      // ],)


      // Padding(
      //   padding: EdgeInsets.all(50),
      //   child:
      //   ElevatedButton(
      //     style: ButtonStyle(
      //       backgroundColor: MaterialStateProperty.all(Color(0xff000000)),
      //     ),
      //     onPressed: () async {
      //       if(code!=''){
      //         var result = await widget.InvitationCodeprovider.getinviteCode(code);
      //         print('8888888888888');
      //         if(result?.statusCode==200){
      //
      //           Toast.toast(context,msg: "填写成功".tr,position: ToastPostion.bottom);
      //         }
      //       }
      //
      //     },
      //     child: Text('确定'.tr,style: TextStyle(
      //       fontSize: 17,
      //       color: Colors.white,
      //     ),textAlign: TextAlign.center,),
      //   ),
      // ),
    );
  }
}