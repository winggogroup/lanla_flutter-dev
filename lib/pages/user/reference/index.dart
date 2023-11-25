import 'dart:ui';

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
     if(st.isNotEmpty){
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
    if(!followsid.contains(id)){
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
          Container(padding: const EdgeInsets.only(left: 20,right: 20),child: Column(
            children: [
              SizedBox(height: 40+MediaQueryData.fromWindow(window).padding.top,),
              Container(alignment: Alignment.centerRight,child: Text('关注TA们'.tr,style: const TextStyle(fontWeight: FontWeight.w600,fontSize: 30),),),
              const SizedBox(height: 25,),
              Container(alignment: Alignment.centerRight,child: Text('结交更多有趣的朋友'.tr,style: const TextStyle(fontWeight: FontWeight.w600),),),
              const SizedBox(height: 40,),
              Expanded(child: Container(child: ListView(children: [
                for(var i=0;i<Tobefollowedlist.length;i++)
                Container(margin: const EdgeInsets.only(bottom: 20),child:  Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children: [
                  Row(children: [
                    Container(clipBehavior: Clip.hardEdge,width: 60,height: 60,decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(50))),child: Image.network(Tobefollowedlist[i].headimg,fit:BoxFit.cover ,),),
                    const SizedBox(width: 10,),
                    Column(crossAxisAlignment:CrossAxisAlignment.start,children: [
                      Text(Tobefollowedlist[i].nickname,style: const TextStyle(fontWeight: FontWeight.w700),),
                      const SizedBox(height: 8,),
                      Text('${'粉丝'.tr} ${Tobefollowedlist[i].bgz}'),
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
              const SizedBox(height: 10,),
              Row(mainAxisAlignment:MainAxisAlignment.spaceEvenly,children: [
                GestureDetector(child:Container(alignment: Alignment.center,width: 160,height: 46,decoration: const BoxDecoration(color: Colors.black,borderRadius: BorderRadius.all(Radius.circular(40))),
                  child: Text('人'.tr+followsid.length.toString()+'关注了'.tr,style: const TextStyle(fontSize: 14,fontWeight: FontWeight.w700,color: Colors.white),),
                ) ,onTap: () async {
                  if(followsid.isNotEmpty){
                    userLogic.setFollowall(followsid.join(","));
                  }
                  if(userLogic.Invitationcodes!=''&&!userLogic.isshowFillincode){
                  Get.offAll(HomePage());
                  }else {
                  Get.offAll(InvitationPage());
                  }
                  },),
                GestureDetector(child: Container(alignment: Alignment.center,width: 160,height: 46,decoration: const BoxDecoration(color: Color(0xfff5f5f5),borderRadius: BorderRadius.all(Radius.circular(40))),
                  child: Text('取消关注'.tr,style: const TextStyle(fontSize: 14,fontWeight: FontWeight.w700,color: Colors.black),),
                ),onTap: (){
                  followsid=[];
                  setState(() {});
                },)
              ],),
              const SizedBox(height: 15,),
              GestureDetector(child: Container(alignment: Alignment.center,margin: const EdgeInsets.only(bottom: 20),child:Text('跳过'.tr,style: const TextStyle(
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
              const SizedBox(height: 20,),
            ],
          ),),
    );
  }
}