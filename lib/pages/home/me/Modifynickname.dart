import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:lanla_flutter/common/controller/UserLogic.dart';
import 'package:lanla_flutter/services/user.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import '../../../common/function.dart';
import '../../../ulits/aliyun_oss/client.dart';
import '../../../ulits/compress.dart';
import '../../../ulits/toast.dart';
import 'Modifynickname.dart';

class ModifynicknameWidget extends StatefulWidget {
  @override
  createState() => ModifynicknameState();
}
class ModifynicknameState extends State<ModifynicknameWidget> {
  final userLogic = Get.find<UserLogic>();
  final userProvider = Get.put<UserProvider>(UserProvider());
  String username = '';
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: userLogic.userName);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '修改昵称'.tr,
          style: const TextStyle(fontSize: 17,fontWeight: FontWeight.w600,),
        ),
        actions: [
          GestureDetector(child:  Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 0, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[Text('保存'.tr,style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),)],
              )
          ),onTap: () async {
            print(username);
            FocusScope.of(context).unfocus();
            Future<bool> isSuccess;
            if(username==''){
              isSuccess =  userProvider.setUserInfo(userLogic.userName, userLogic.slogan, userLogic.userAvatar, userLogic.Sex,userLogic.birthday) ;
            }else{
              isSuccess =  userProvider.setUserInfo(username, userLogic.slogan, userLogic.userAvatar, userLogic.Sex,userLogic.birthday) ;
            }

            if(await isSuccess){
              ToastInfo('更新成功'.tr);
              userLogic.getUserInfo();
              Get.back();
            }else{
              ToastErr('更新失败'.tr);
            }
          },)
        ],

      ),
      body: Column(
        children: [
          const SizedBox(height: 23,),
          Container(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            height: 56,
            child:TextField(
              maxLength: 15,
              controller: _controller,
              // keyboardType: TextInputType.number,
              // cursorColor: Color(0xffffffff),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                hintText: "请输入你的昵称".tr,
                hintStyle: const TextStyle(color: Color(0xff666666)),
                border: InputBorder.none, // 隐藏边框
                fillColor: Colors.white,

                filled: true,
                enabledBorder: const OutlineInputBorder(
                  /*边角*/
                  borderRadius: BorderRadius.all(
                    Radius.circular(20), //边角为5
                  ),
                  borderSide: BorderSide(
                    color: Colors.white,
                    width: 0.5,
                  ),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white,
                    width: 0.5,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
              ),

              onChanged: (text) {
                if (text == '') {
                  ToastInfo('名称不能为空'.tr);
                  return;
                }
                username=text;
              },
            ),
          )

        ],
      ),
    );
  }
}