import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lanla_flutter/common/controller/publicmethodes.dart';
import 'package:lanla_flutter/pages/home/start/detail_view/loading_widget.dart';
import 'package:lanla_flutter/pages/home/view.dart';

import 'package:lanla_flutter/pages/user/inputpassword/view.dart';
import 'package:lanla_flutter/services/content.dart';
import 'package:lanla_flutter/ulits/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
class SecurityverificationPage extends StatefulWidget {
  @override
  createState() => SecurityverificationState();
}

class SecurityverificationState extends State<SecurityverificationPage> {
  ContentProvider provider = ContentProvider();
  Publicmethodes Publicmethods = Get.put(Publicmethodes());
  int AuthenticationType =0;
  final ScrollController _scrollController = ScrollController();
  String phone='';
  String areaCode='';
  bool oneData = true; // 是否首次请求过-用于展示等待页面
  var presentationdata;
  String AuthenticationID='';
  int Randomdimension=4;
  int jumptype=2;
  bool antishake=true;
  void initState() {
    super.initState();
    phone=Get.arguments['phone'];
    areaCode=Get.arguments['areacode'];
    jumptype=Get.arguments['type'];
    shujudata();
  }

  void changeValue() {
    // 从0、1、2中随机选取一个与初始值不同的新值
    int newValue;
    do {
      newValue = Random().nextInt(Randomdimension);
    } while (newValue == AuthenticationType);

    setState(() {
      AuthenticationID = '';
      AuthenticationType = newValue;
    });
  }

  String formatTimestamp(BuildContext context, int timestamp) {
    print('$timestamp');
    // 根据用户的本地化设置来格式化时间戳
    final DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    final String formattedDateTime = DateFormat('yyyy-MM-dd').format(dateTime);
    return formattedDateTime;
  }

   shujudata() async {
    print('请求接口');
     var res=await provider.makeSecurityAuth(phone,areaCode);
     if(res.statusCode==200){
       print('我想要的数据');
       print(res.body["content"]);
       if(res.body["content"]['birthday'].length>0){
         Randomdimension=4;
       }else if(res.body["content"]['register_login_time'].length>0){
         Randomdimension=3;
       }else if(res.body["content"]['register_login_time'].length==0){
         Randomdimension=2;
       }
       presentationdata=res.body;
       oneData = false;
       setState(() {});
       AuthenticationType=Random().nextInt(Randomdimension);
       print('随机数$areaCode');
     }
  }

  testandverify() async {
    if(antishake){
      antishake=false;
      Publicmethods.loades(context,'');
      var type='';
      if(AuthenticationType==0){
        type="head_img";
      }else if(AuthenticationType==1){
        type="nickname";
      }else if(AuthenticationType==2){
        type="register_login_time";
      }else if(AuthenticationType==3){
        type="birthday";
      }
      var res= await provider.checkSecurityAuth(phone,areaCode,type,AuthenticationID);
      if(res.statusCode==200){
        print('返回的数据${res.body}');
        if(res.body['status']=="error"){
          changeValue();
          Navigator.pop(context);
          if(res.body['msg']==''){
            ToastInfo(res.body['msg']);
          }
        }else if(res.body['status']=="ok"){
            Navigator.pop(context);
            print('进来了$jumptype');
            Get.to(InputpasswordPage(),arguments: {'phone':phone,'areacode':areaCode,'type':type,'sec_val_token':AuthenticationID});
        }else if(res.body['status']=="security_authentication_forbidden"){
          Navigator.pop(context);
          Get.offAll(HomePage());
          customer(context);
        }

      }else{
        Navigator.pop(context);
      }

      antishake=true;
    }

  }

  @override

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: oneData
          ? StartDetailLoading():Container(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        decoration: const BoxDecoration(color:Color(0xffFFFFFF)),
        child: Column(
          //crossAxisAlignment:CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 60),
            Container(alignment: Alignment.centerRight,child: Text('安全验证'.tr,style:const TextStyle(fontSize: 25,fontWeight: FontWeight.w600),),),
            const SizedBox(height: 10,),
            if(AuthenticationType==0)Container(alignment: Alignment.centerRight,child: Text('下面哪一个是你当前账号的头像'.tr,style: const TextStyle(fontSize: 15),),),
            if(AuthenticationType==1)Container(alignment: Alignment.centerRight,child: Text('下面哪一个是你当前账号的昵称'.tr,style: const TextStyle(fontSize: 15),),),
            if(AuthenticationType==2)Container(alignment: Alignment.centerRight,child: Text('下面哪一个是你当前账号的注册时间'.tr,style: const TextStyle(fontSize: 15),),),
            if(AuthenticationType==3)Container(alignment: Alignment.centerRight,child: Text('下面哪一个是你所填的生日信息'.tr,style: const TextStyle(fontSize: 15),),),
            ///头像验证
            if(AuthenticationType==0)Expanded(
              flex: 1,
              child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.fromLTRB(15, 36, 15, 0),
                  child:
                  GridView.count(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                    crossAxisSpacing: 35.0,
                    //水平子 Widget 之间间距
                    mainAxisSpacing: 35.0,
                    //垂直子 Widget 之间间距
                    // padding: const EdgeInsets.all(10),
                    crossAxisCount: 3,
                    //一行的 Widget 数量
                    childAspectRatio: 1,
                    //宽度和高度的比例
                    children: [
                      for (var i = 0; i < presentationdata['content']['head_img'].length; i++)
                        GestureDetector(
                          child:
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                clipBehavior: Clip.hardEdge,
                                decoration: BoxDecoration(

                                  border: Border.all(
                                    color:
                                      AuthenticationID==presentationdata['content']['head_img'][i]['sec_val_token']?const Color.fromRGBO(209, 255, 52, 1):Colors.white, // 边框颜色
                                    width: 5, // 边框宽度
                                  ),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                alignment: Alignment.center,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(100), // 设置圆角半径
                                  child: Image.network(
                                    presentationdata['content']['head_img'][i]['val'],
                                    fit: BoxFit.cover,
                                    width: 80,
                                    height: 80,
                                  ),
                                ),
                              ),
                              if(AuthenticationID==presentationdata['content']['head_img'][i]['sec_val_token'])Positioned(
                                  bottom: -(25/2),
                                  left: 0,
                                  right: 0,
                                  child:  Container(child: Image.asset(
                                    'assets/images/yzxuanz.png',
                                    width: 25,
                                    height: 25,
                                  ),)

                              ),
                            ],
                          ),
                          onTap: () {
                            AuthenticationID=presentationdata['content']['head_img'][i]['sec_val_token'];
                            setState(() {

                            });
                          },
                        )
                    ],
                  )),
            ),
            ///姓名验证
            if (AuthenticationType == 1)
              Expanded(
                flex: 1,
                child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.fromLTRB(15, 36, 15, 0),
                    child: ListView.builder(
                        itemCount:
                            presentationdata['content']['nickname'].length,
                        controller: _scrollController,
                        itemBuilder: (context, i) {
                          return GestureDetector(
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 25),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    presentationdata['content']['nickname'][i]
                                        ['val'],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 15),
                                  ),
                                  AuthenticationID !=
                                          presentationdata['content']
                                              ['nickname'][i]['sec_val_token']
                                      ? Container(
                                          width: 21,
                                          height: 21,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(21),
                                            // border: Border.all(
                                            //     width: 3,
                                            //     color: Colors.white)
                                          ),
                                          child: Image.asset(
                                            'assets/images/yzweixz.png',
                                            fit: BoxFit.cover,
                                          ),
                                      )
                                      : Container(
                                          width: 21,
                                          height: 21,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(21),
                                          ),
                                          child: Image.asset(
                                            'assets/images/yzxuanz.png',
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                ],
                              ),
                            ),
                            onTap: () {
                              if (AuthenticationID ==
                                  presentationdata['content']['nickname'][i]
                                      ['sec_val_token']) {
                                AuthenticationID = '';
                              } else {
                                AuthenticationID = presentationdata['content']
                                    ['nickname'][i]['sec_val_token'];
                              }
                              setState(() {});
                            },
                          );
                        })),
              ),

            ///注册时间
            if (AuthenticationType == 2)
              Expanded(
                flex: 1,
                child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.fromLTRB(15, 36, 15, 0),
                    child: ListView.builder(
                        itemCount: presentationdata['content']
                                ['register_login_time']
                            .length,
                        controller: _scrollController,
                        itemBuilder: (context, i) {
                          return GestureDetector(
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 25),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    formatTimestamp(context, int.parse(presentationdata['content']['register_login_time'][i]['val']) ),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 15),
                                  ),
                                  AuthenticationID !=
                                          presentationdata['content']
                                                  ['register_login_time'][i]
                                              ['sec_val_token']
                                      ? Container(
                                    width: 21,
                                    height: 21,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.circular(21),
                                      // border: Border.all(
                                      //     width: 3,
                                      //     color: Colors.white)
                                    ),
                                    child: Image.asset(
                                      'assets/images/yzweixz.png',
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                      : Container(
                                    width: 21,
                                    height: 21,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.circular(21),
                                    ),
                                    child: Image.asset(
                                      'assets/images/yzxuanz.png',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
                              if (AuthenticationID ==
                                  presentationdata['content']
                                          ['register_login_time'][i]
                                      ['sec_val_token']) {
                                AuthenticationID = '';
                              } else {
                                AuthenticationID = presentationdata['content']
                                    ['register_login_time'][i]['sec_val_token'];
                              }
                              setState(() {});
                            },
                          );
                        })),
              ),

            ///生日
            if (AuthenticationType == 3)
              Expanded(
                flex: 1,
                child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.fromLTRB(15, 36, 15, 0),
                    child: ListView.builder(
                        itemCount:
                            presentationdata['content']['birthday'].length,
                        controller: _scrollController,
                        itemBuilder: (context, i) {
                          return GestureDetector(
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 25),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    presentationdata['content']['birthday'][i]
                                        ['val'],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 15),
                                  ),
                                  AuthenticationID !=
                                          presentationdata['content']
                                              ['birthday'][i]['sec_val_token']
                                      ? Container(
                                    width: 21,
                                    height: 21,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.circular(21),
                                      // border: Border.all(
                                      //     width: 3,
                                      //     color: Colors.white)
                                    ),
                                    child: Image.asset(
                                      'assets/images/yzweixz.png',
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                      : Container(
                                    width: 21,
                                    height: 21,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.circular(21),
                                    ),
                                    child: Image.asset(
                                      'assets/images/yzxuanz.png',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
                              if (AuthenticationID ==
                                  presentationdata['content']['birthday'][i]
                                      ['sec_val_token']) {
                                AuthenticationID = '';
                              } else {
                                AuthenticationID = presentationdata['content']
                                    ['birthday'][i]['sec_val_token'];
                              }
                              setState(() {});
                            },
                          );
                        })),
              ),
            const SizedBox(height: 20,),
            GestureDetector(child: Container(child: Text('换一个问题'.tr,style: const TextStyle(fontSize: 14,fontWeight: FontWeight.w700,color: Color.fromRGBO(168, 246, 0, 1)),),),onTap: (){
              changeValue();
            },),
            const SizedBox(height: 25,),
            Container(
              width: double.infinity,
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
                  if(phone!=''&&areaCode!=''&&AuthenticationID!=''){
                    print('请求接口');
                    testandverify();
                  }
                  // customer(context);
                },
              ),
            ),
            const SizedBox(height: 20,),
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

  deactivate() {
    print('页面销毁');
  }

  Future<void> customer(context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          elevation:0,
          contentPadding: const EdgeInsets.fromLTRB(35, 35, 35, 35),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(
              //color: Colors.transparent,
              //color: Colors.red,
              // height: 280,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      width: MediaQuery.of(context).size.width - 100,
                      //height: 311,

                      child: const Text('فشل التحقق الأمني ​​، يرجى اختيار طريقة تسجيل دخول أخرى. أو يمكنك أيضًا الاتصال بخدمة العملاء الرسمية لـ LanLa لاسترداد الحساب على whatsapp: +86 15256019084',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700),)
                  ),
                  const SizedBox(height: 25,),
                  GestureDetector(child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(top: 12, bottom: 12),
                    margin: const EdgeInsets.only(left: 10, right: 10),
                    decoration: BoxDecoration(
                        color: const Color.fromRGBO(209, 255, 52, 1),
                        borderRadius: BorderRadius.circular(30)),
                    width: double.infinity,
                    child: Text(
                      '我知道了'.tr,
                      style:
                      const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                  ),onTap: (){
                    Navigator.pop(context);
                  },)
                ],
              ),
            ),
          ]),
        );
      },
    ).then((value) {
      // 弹窗关闭后执行的操作

      print('弹窗已关闭');
    });
  }
}
//定义弹窗

