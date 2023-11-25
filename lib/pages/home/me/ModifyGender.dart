import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:lanla_flutter/common/controller/UserLogic.dart';
import 'package:lanla_flutter/services/user.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../common/function.dart';
import '../../../ulits/aliyun_oss/client.dart';
import '../../../ulits/compress.dart';
import '../../../ulits/toast.dart';

class ModifyGenderWidget extends StatefulWidget {
  @override
  createState() => ModifyGenderState();
}

class ModifyGenderState extends State<ModifyGenderWidget> {
  final userLogic = Get.find<UserLogic>();
  final userProvider = Get.put<UserProvider>(UserProvider());

  var Sex=1;
  @override

  void initState() {
    Sex=Get.arguments;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '修改性别'.tr,
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
            var isSuccess =  userProvider.setUserInfo(userLogic.userName, userLogic.slogan, userLogic.userAvatar, Sex,userLogic.userInfo?.birthday) ;
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
                      Text('男'.tr),
                      Sex==1?Container(
                        width: 25,
                        height: 25,
                        child: SvgPicture.asset(
                          "assets/svg/xuanzhong.svg",
                        ),
                      ):Container(
                        width: 25,
                        height: 25,
                        child: SvgPicture.asset(
                          "assets/svg/weixuanzhong.svg",
                        ),
                      )
                    ],
                  ) ,
                ),onTap: (){
                  setState(() {
                    Sex=1;
                  });
                },) ,
                const Divider(height: 1.0,color: Color(0xffF1F1F1),),
                GestureDetector(child: Container(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                  child: Row(
                    mainAxisAlignment:MainAxisAlignment.spaceBetween,
                    children: [
                      Text('女'.tr),
                      Sex==2?Container(
                        width: 25,
                        height: 25,
                        child: SvgPicture.asset(
                          "assets/svg/xuanzhong.svg",
                        ),
                      ):Container(
                        width: 25,
                        height: 25,
                        child: SvgPicture.asset(
                          "assets/svg/weixuanzhong.svg",
                        ),
                      )
                    ],
                  ) ,
                ),onTap: (){
                  setState(() {
                    Sex=2 ;
                  });
                },) ,
                const Divider(height: 1.0,color: Color(0xffF1F1F1),),
                GestureDetector(child: Container(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                  child: Row(
                    mainAxisAlignment:MainAxisAlignment.spaceBetween,
                    children: [
                      Text('保密'.tr),
                      Sex==0?Container(
                        width: 25,
                        height: 25,
                        child: SvgPicture.asset(
                          "assets/svg/xuanzhong.svg",
                        ),
                      ):Container(
                        width: 25,
                        height: 25,
                        child: SvgPicture.asset(
                          "assets/svg/weixuanzhong.svg",
                        ),
                      )
                    ],
                  ) ,
                ),onTap: (){
                  setState(() {
                    Sex=0 ;
                  });
                },) ,
              ],
            ),
          ),

        ],
      ),
    );
  }
}