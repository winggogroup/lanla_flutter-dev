import 'package:adjust_sdk/adjust.dart';
import 'package:adjust_sdk/adjust_event.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lanla_flutter/common/controller/UserLogic.dart';
import 'package:lanla_flutter/common/controller/publicmethodes.dart';
import 'package:lanla_flutter/pages/home/view.dart';
import 'package:lanla_flutter/pages/user/reference/index.dart';
import 'package:lanla_flutter/services/content.dart';
import 'package:lanla_flutter/ulits/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'logic.dart';
class InputpasswordPage extends StatefulWidget {
  @override
  createState() => InputpasswordState();
}

class InputpasswordState extends State<InputpasswordPage> {
//引入修改个人信息的文件
  final userLogic =  Get.find<UserLogic>();
  final logic = Get.put(InputpasswordLogic());
  final state = Get.find<InputpasswordLogic>().state;
  ContentProvider provider = ContentProvider();
  TextEditingController _textEditingController = TextEditingController();
  Publicmethodes Publicmethods = Get.put(Publicmethodes());
  FocusNode _focusNode = FocusNode();
  FocusNode _focusNodetwo = FocusNode();
  String szpassword='';
  String newpassword='';
  String phone='';
  String areaCode='';
  bool prompt=false;
  bool promptwo=false;
  String type='';
  String sec_val_token='';
  bool antishake=true;
  @override
  void initState() {
    super.initState();
    phone=Get.arguments['phone'];
    areaCode=Get.arguments['areacode'];
    type=Get.arguments['type'];
    sec_val_token=Get.arguments['sec_val_token'];
// 添加焦点监听器
    _focusNodetwo.addListener(() {
      if ( _focusNodetwo.hasFocus) {
        // 获得焦点时的操作
        promptwo=false;
      } else {
        if(szpassword!=newpassword){
          promptwo=true;
        }
        // 失去焦点时的操作
      }
      setState(() {});
    });

   _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        // 获得焦点时的操作
        prompt=false;
      } else {
        // 失去焦点时的操作
        if(szpassword.length<5){
          prompt=true;
        }
      }
      setState(() {});
    });
  }
  @override
  void dispose() {
    _focusNode.dispose();
    _focusNodetwo.dispose();
    _textEditingController.dispose();
    super.dispose();
  }

  ///设置密码
  shezPassword() async {
    if(antishake){
      antishake=false;
      Publicmethods.loades(context,'');
      var res= await provider.setPassword(phone,areaCode,type,sec_val_token,szpassword);
      if(res.statusCode==200){
        print('输出的数据${res.body}');

        var sp = await SharedPreferences.getInstance();
        sp.setString("token", res.body['userInfo']["token"]["refreshToken"]);
        sp.setInt("userId", res.body['userInfo']["userId"]);
        sp.setString("userAvatar", res.body['userInfo']["userAvatar"]);
        sp.setString("userName", res.body['userInfo']["userName"]);
        userLogic.modify(res.body['userInfo']["token"]["refreshToken"],res.body['userInfo']["userId"],res.body['userInfo']["userAvatar"],res.body['userInfo']["userName"]);
        if(res.body['userInfo']["userStatus"]=='2'){
          SharedPreferences prefs = await SharedPreferences.getInstance();
          FirebaseAnalytics.instance.logEvent(
            name: "Change_password",
            parameters: {
              "userId": res.body['userInfo']["userId"],
              "sourcePlatform":userLogic.sourcePlatform,
              "deviceId":userLogic.deviceId,
            },
          );
          AdjustEvent myAdjustEvent = AdjustEvent('6ykn6j');
          myAdjustEvent.addCallbackParameter('userId',res.body['userInfo']["userId"].toString());
          Adjust.trackEvent(myAdjustEvent);
          Navigator.pop(context);
          Get.offAll(ReferencePage());
        }else{
          userLogic.isbindingopen=false;
          Navigator.pop(context);
          Get.offAll(HomePage());
        }
      }else{
        Navigator.pop(context);
      }
      antishake=true;
    }

  }
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        decoration: new BoxDecoration(color:Color(0xffFFFFFF)),
        child: ListView(
          //crossAxisAlignment:CrossAxisAlignment.start,
          children: [
            SizedBox(height: 60),
            Text('设置账号密码'.tr,style: TextStyle(fontSize: 25,fontWeight: FontWeight.w600),),
            SizedBox(height: 10,),
            Text('由与lanla的功能升级，以后可用账号密码进行登录'.tr,style: TextStyle(fontSize: 15,fontWeight: FontWeight.w400),),
            SizedBox(height: 60),
            Row(
                children: [
                  Expanded(flex: 1,child:
                  TextField(
                      controller: _textEditingController,
                      focusNode: _focusNode, // 将FocusNode关联到TextField
                      obscureText: true,
                      keyboardType: TextInputType.visiblePassword,
                      // inputFormatters: [
                      //   FilteringTextInputFormatter.allow(RegExp("[0-9]")),//数字
                      // ],
                      scrollPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      cursorColor: Color(0xFF999999),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "请设置5位数及以上的密码".tr
                      ),
                      style: TextStyle(fontSize: 15),
                      onChanged: (text) {
                        szpassword=text;

                        setState(() {});
                      },
                    ),
                  ),
                ]
            ),
            ///分割线
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
            if(prompt)SizedBox(height: 15,),
            if(prompt)Text('您的密码少于5位，请重新输入'.tr,style: TextStyle(fontSize: 12,color: Color.fromRGBO(255, 0, 0, 1)),),
            SizedBox(height: 50),
            Row(
                children: [
                  Expanded(flex: 1,child:
                    TextField(
                      // controller: _textEditingController,
                      obscureText: true,
                      keyboardType: TextInputType.visiblePassword,
                      focusNode: _focusNodetwo, // 将FocusNode关联到TextField
                      // inputFormatters: [
                      //   FilteringTextInputFormatter.allow(RegExp("[0-9]")),//数字
                      // ],
                      scrollPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      cursorColor: Color(0xFF999999),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "请再次输入密码".tr
                      ),
                      style: TextStyle(fontSize: 15),
                      onChanged: (text) {
                        newpassword=text;
                        setState(() {});
                      },
                    ),
                  ),
                ]
            ),
            ///分割线
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
            if(promptwo)SizedBox(height: 15,),
            if(promptwo)Text('您的密码错误，请重新输入'.tr,style: TextStyle(fontSize: 12,color: Color.fromRGBO(255, 0, 0, 1)),),
            SizedBox(height: 51),
            // Expanded(
            //   child:
              Container(
                height: 46,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:MaterialStateProperty.all(Color(0xff000000)),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                    // elevation: MaterialStateProperty.all(20),
                    shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(37))
                    ),
                  ),

                  child: Text('完成'.tr,),
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    if(szpassword==newpassword){
                      if(phone!=''&&areaCode!=''&&!prompt&&!promptwo&&szpassword!=''&&newpassword!=""&&type!=''&&sec_val_token!=''){
                        shezPassword();
                      }else{
                        print('见来了1');
                        if(szpassword==''||newpassword==""){
                          print('见来了2');
                          ToastInfo('请输入您设置的密码'.tr);
                        }
                      }
                    }else{
                      ToastInfo('您两次输入的密码不一致'.tr);
                    }
                  },
                ),
              ),
            // )
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
              Get.offAll(HomePage());
              //print('menu Pressed');
              // Navigator.of(context).pop();
            }),
      ),
    );
  }
}
