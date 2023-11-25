import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lanla_flutter/common/controller/UserLogic.dart';
import 'package:lanla_flutter/models/Tobefollowed.dart';
import 'package:lanla_flutter/pages/home/view.dart';
import 'package:lanla_flutter/pages/user/Invitationpage/index.dart';
import 'package:lanla_flutter/services/user_home.dart';

class ReferencePage extends StatefulWidget  {
  @override
  ReferenceState createState() => ReferenceState();
}

class ReferenceState extends State<ReferencePage> {
  final FocusNode _nodeText1 = FocusNode();
  UserHomeProvider InvitationCodeprovider =  Get.put(UserHomeProvider());
  final userLogic =  Get.find<UserLogic>();
  var Tobefollowedlist=[];
  var followsid=[];
  @override
  void initState() {
    super.initState();
    interface();
  }
  interface() async {
   var res=await InvitationCodeprovider.recommendedUsers();
   if(res?.statusCode==200){
     var st =(tobefollowedFromJson(res?.bodyString ?? ""));
     print('请求接口123${st.length}');
     if(st.length>0){
       followsid=st.map((number) => number.id).toList();
       setState(() {
         Tobefollowedlist.addAll(st);
       });
       // setBottomSheetState(() {
       //   giftItem=item[i];
       // });
     }
     // print(result.statusCode);
     // update();
   }
  }


  xuanstatle(id){
    if(followsid.indexOf(id)==-1){
      return false;
    }else{
      return true;
    }
  }
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
          Container(padding: EdgeInsets.only(left: 20,right: 20),child: Column(
            children: [
              SizedBox(height: 40+MediaQueryData.fromWindow(window).padding.top,),
              Container(alignment: Alignment.centerRight,child: Text('关注TA们'.tr,style: TextStyle(fontWeight: FontWeight.w600,fontSize: 30),),),
              SizedBox(height: 25,),
              Container(alignment: Alignment.centerRight,child: Text('结交更多有趣的朋友'.tr,style: TextStyle(fontWeight: FontWeight.w600),),),
              SizedBox(height: 40,),
              Expanded(child: Container(child: ListView(children: [
                for(var i=0;i<Tobefollowedlist.length;i++)
                Container(margin: EdgeInsets.only(bottom: 20),child:  Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children: [
                  Row(children: [
                    Container(clipBehavior: Clip.hardEdge,width: 60,height: 60,decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(50))),child: Image.network(Tobefollowedlist[i].headimg,fit:BoxFit.cover ,),),
                    SizedBox(width: 10,),
                    Column(crossAxisAlignment:CrossAxisAlignment.start,children: [
                      Text(Tobefollowedlist[i].nickname,style: TextStyle(fontWeight: FontWeight.w700),),
                      SizedBox(height: 8,),
                      Text('粉丝'.tr+' '+Tobefollowedlist[i].bgz.toString()),
                    ],)],),
                  GestureDetector(child: Image.asset(xuanstatle(Tobefollowedlist[i].id)?'assets/images/tjgz.png':'assets/images/qxtjgz.png',width: 25,height: 25,),onTap: (){
                    print('123333${followsid.indexOf(Tobefollowedlist[i].id)}');
                    if(xuanstatle(Tobefollowedlist[i].id)){
                      followsid.removeWhere((element) => element == Tobefollowedlist[i].id);
                    }else{
                      followsid.add(Tobefollowedlist[i].id);
                    }
                    setState(() {});
                  },),
                ],),),
              ],),)),
              SizedBox(height: 10,),
              Row(mainAxisAlignment:MainAxisAlignment.spaceEvenly,children: [
                GestureDetector(child:Container(alignment: Alignment.center,width: 160,height: 46,decoration: BoxDecoration(color: Colors.black,borderRadius: BorderRadius.all(Radius.circular(40))),
                  child: Text('人'.tr+followsid.length.toString()+'关注了'.tr,style: TextStyle(fontSize: 14,fontWeight: FontWeight.w700,color: Colors.white),),
                ) ,onTap: () async {
                  if(followsid.length>0){
                    userLogic.setFollowall(followsid.join(","));
                  }
                  if(userLogic.Invitationcodes!=''&&!userLogic.isshowFillincode){
                  Get.offAll(HomePage());
                  }else {
                  Get.offAll(InvitationPage());
                  }
                  },),
                GestureDetector(child: Container(alignment: Alignment.center,width: 160,height: 46,decoration: BoxDecoration(color: Color(0xfff5f5f5),borderRadius: BorderRadius.all(Radius.circular(40))),
                  child: Text('取消关注'.tr,style: TextStyle(fontSize: 14,fontWeight: FontWeight.w700,color: Colors.black),),
                ),onTap: (){
                  followsid=[];
                  setState(() {});
                },)
              ],),
              SizedBox(height: 15,),
              GestureDetector(child: Container(alignment: Alignment.center,margin: EdgeInsets.only(bottom: 20),child:Text('跳过'.tr,style: TextStyle(
                color: Color(0xff666666),
              ),) ,),onTap: () async {
                //Get.offAll(HomePage());
                //Get.to(ChooseTopicPage());
                if(userLogic.Invitationcodes!=''&&!userLogic.isshowFillincode){
                  Get.offAll(HomePage());
                }else {
                  Get.offAll(InvitationPage());
                }
              },),
              SizedBox(height: 20,),
            ],
          ),),
    );
  }
}