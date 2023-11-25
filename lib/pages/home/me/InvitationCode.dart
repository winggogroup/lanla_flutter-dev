import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:lanla_flutter/common/controller/UserLogic.dart';
import 'package:lanla_flutter/services/user.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import '../../../common/function.dart';
import '../../../common/toast/view.dart';
import '../../../services/user_home.dart';
import '../../../ulits/aliyun_oss/client.dart';
import '../../../ulits/compress.dart';
import '../../../ulits/toast.dart';


class InvitationCodePage extends StatefulWidget  {
  @override
  _SecondWidgetState createState() => _SecondWidgetState();
  UserHomeProvider InvitationCodeprovider =  Get.put(UserHomeProvider());
}

class _SecondWidgetState extends State<InvitationCodePage> {
  String code = '';

  // InvitationCodePage({super.key}) {
  //   //ToastInfo('测试版提示：此页面未经设计');
  // }
  final FocusNode _nodeText1 = FocusNode();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '填写邀请码'.tr,
          style: const TextStyle(fontSize: 16),
        ),
      ),
      body:
      Column(
        children: [
          const SizedBox(height: 23,),

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
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                height: 56,
                child:TextField(
                  focusNode: _nodeText1,
                  keyboardType: TextInputType.number,
                  cursorColor: const Color(0xff666666),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                    hintText: "请输入你的邀请码".tr,
                    hintStyle: const TextStyle(color: Color(0xff666666)),
                    border:const OutlineInputBorder(),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xff666666)),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xff666666)),
                    ),
                  ),
                  onChanged: (text) {

                    setState(() {
                      code = text;
                    });
                  },
                ),
              ),


          ),



          
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(50),
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(const Color(0xff000000)),
          ),
          onPressed: () async {
            if(code!=''){
              var result = await widget.InvitationCodeprovider.getinviteCode(code);
              print('8888888888888');
              if(result?.statusCode==200){
                Get.back();
                Toast.toast(context,msg: "填写成功".tr,position: ToastPostion.bottom);
              }
            }

          },
          child: Text('确定'.tr,style: const TextStyle(
            fontSize: 17,
            color: Colors.white,
          ),textAlign: TextAlign.center,),
        ),
      ),
    );
  }
}