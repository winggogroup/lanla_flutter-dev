import 'dart:io';

import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lanla_flutter/pages/home/me/authentication/Creatorcertification.dart';
import 'package:lanla_flutter/pages/home/me/authentication/Expertcertification.dart';
import 'package:lanla_flutter/pages/home/message/Dashedline/view.dart';
import 'package:lanla_flutter/pages/home/start/detail_view/loading_widget.dart';
import 'package:lanla_flutter/pages/home/start/detail_view/view.dart';
import 'package:lanla_flutter/services/SetUp.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';

class authentication extends StatefulWidget{
  @override
  State<authentication> createState() => _authentication();
}

class _authentication extends State<authentication>{
  Image image = Image.asset('assets/images/hqheight.png');
  SetUpProvider interface =  Get.put(SetUpProvider());
  var imageheight;
  var shujudata;
  void initState() {
    super.initState();
    initialrequest();
    image.image.resolve(ImageConfiguration()).addListener(ImageStreamListener((ImageInfo info, bool synchronousCall) {
      // 获取图片高度
      imageheight = info.image.height.toDouble();
      print('Image height: $imageheight');
    }));
  }
  initialrequest() async {
    var res = await interface.pageDescription();
    if(res.statusCode==200){
      shujudata=res.body;
      setState(() {

      });
    }
  }


  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body:shujudata==null
          ? StartDetailLoading()
          :  Container(
        // padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        decoration: new BoxDecoration(color:Color(0xfffffcd9)),
        child:
        ListView(
          //crossAxisAlignment:CrossAxisAlignment.start,
          children: [
            Stack(children: [

             Positioned(bottom: 0,left: 0,right: 0,child: Container(width: double.infinity,child: Image.asset('assets/images/renzhz.png',fit:BoxFit.cover ,),)),
             Positioned(child:Container(
               decoration: BoxDecoration(
                 color: Colors.white,
                 borderRadius: BorderRadius.all(Radius.circular(20)),
                   boxShadow: const [
                     BoxShadow(
                       ///颜色百分比
                         color: Color.fromRGBO(0, 0, 0, 0.05),
                         //color:Colors.black,
                         offset: Offset(0.0, 1), //阴影xy轴偏移量
                         blurRadius: 4, //阴影模糊程度
                         spreadRadius: 2 //阴影扩散程度
                     )
                   ],
               ),
               width: double.infinity,margin: EdgeInsets.fromLTRB(20, 46, 20, 0),padding: EdgeInsets.fromLTRB(20, 20, 20, imageheight ?? 138.0),child: Column(children: [
               Row(children: [

                 Container(clipBehavior: Clip.hardEdge,alignment: Alignment.center,width: 50,height: 50,decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(50))),child: Image.network(shujudata["label_high_quality_author"]["icon_link"],fit:BoxFit.cover ,),),
                 SizedBox(width: 15,),
                 Text(shujudata["label_high_quality_author"]["title"],style: TextStyle(fontSize: 14),)
               ],),
               SizedBox(height: 10,),
               Container(alignment: Alignment.centerRight,child: Text(shujudata["label_high_quality_author"]["description"],style: TextStyle(fontSize: 13,color: Color.fromRGBO(153, 153, 153, 1),height:2),),),
               SizedBox(height: 15,),
               GestureDetector(child: Container(
                 child: Container(
                   width: double.infinity,
                   alignment: Alignment.center,
                   padding: EdgeInsets.only(top: 15, bottom: 15),
                   decoration: BoxDecoration(
                       color: shujudata["label_high_quality_author"]["button_status"]==3?Color.fromRGBO(219, 255, 0, 1):Color.fromRGBO(245, 245, 245, 1),
                       borderRadius: BorderRadius.all(Radius.circular(170))
                   ),
                   margin: EdgeInsets.only(left: 28, right: 28),
                   child: Text(
                     shujudata["label_high_quality_author"]["button_status"]==3?'申请认证'.tr:shujudata["label_high_quality_author"]["button_status"]==2?'已申请'.tr:'已认证'.tr,
                     style: TextStyle(
                         fontSize: 13, fontWeight: FontWeight.w700),
                   ),
                 ),
               ),onTap: (){
                 if(shujudata["label_high_quality_author"]["button_status"]==3){
                   Get.to(CreatorcertificationPage(),arguments: shujudata)?.then((value) {
                     if (value != null) {
                       print('见来了人dsdasd ');
                       initialrequest();
                       Redemptionsuccessful(context);
                       //此处可以获取从第二个页面返回携带的参数
                     }
                   });
                 }
               },),
               SizedBox(height: 20,),
               DottedLineDivider(
                 height: 1.0,
                 color: Color.fromRGBO(225, 225, 225, 1),
                 // indent: 20.0,
                 // endIndent: 20.0,
               ),
               SizedBox(height: 20,),
               Row(children: [
                 Container(clipBehavior: Clip.hardEdge,alignment: Alignment.center,width: 50,height: 50,decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(50))),child: Image.network(shujudata["label_famous_user"]["icon_link"],fit:BoxFit.cover,),),
                 SizedBox(width: 15,),
                 Text(shujudata["label_famous_user"]["title"],style: TextStyle(fontSize: 14),)
               ],),
               SizedBox(height: 10,),
               Container(alignment: Alignment.centerRight,child: Text(shujudata["label_famous_user"]["description"],style: TextStyle(fontSize: 13,color: Color.fromRGBO(153, 153, 153, 1),height:2),),),
               SizedBox(height: 15,),
               GestureDetector(child: Container(
                 child: Container(
                   width: double.infinity,
                   alignment: Alignment.center,
                   padding: EdgeInsets.only(top: 15, bottom: 15),
                   decoration: BoxDecoration(
                       color: shujudata["label_famous_user"]["button_status"]==3?Color.fromRGBO(219, 255, 0, 1):Color.fromRGBO(245, 245, 245, 1),
                       borderRadius: BorderRadius.all(Radius.circular(170))
                   ),
                   margin: EdgeInsets.only(left: 28, right: 28),
                   child: Text(
                     shujudata["label_famous_user"]["button_status"]==3?'申请认证'.tr:shujudata["label_famous_user"]["button_status"]==2?'已申请'.tr:'已认证'.tr,
                     style: TextStyle(
                         fontSize: 13, fontWeight: FontWeight.w700),
                   ),
                 ),
               ),onTap: (){
                 // Redemptionsuccessful(context);
                 if(shujudata["label_famous_user"]["button_status"]==3){
                   Get.to(ExpertcertificationPage(),arguments: shujudata)?.then((value) {
                    if (value != null) {
                      initialrequest();
                      Redemptionsuccessful(context);
                      //此处可以获取从第二个页面返回携带的参数
                    }
                  });
                 }


               },)
             ],),),),
             Positioned(bottom: 0,left: 0,right: 0,child: Container(width: double.infinity,child:  Image.asset('assets/images/renzhztwo.png',fit:BoxFit.cover ,),))
           ],),
            SizedBox(height: 25,),
            Container(margin: EdgeInsets.only(left: 20,right: 20),child: Text('LanLa认证特权'.tr,style: TextStyle(fontSize: 15,fontWeight: FontWeight.w700),),),
            SizedBox(height: 10,),
            Container(width: double.infinity,child: Row(mainAxisAlignment:MainAxisAlignment.spaceEvenly,crossAxisAlignment:CrossAxisAlignment.start,children: [
              Container(width: MediaQuery.of(context).size.width/4,child: Column(children: [
                Image.asset('assets/images/renzhengbs1.png',width: 35,height: 35,),
                Text('达人标识'.tr,textAlign:TextAlign.center,style: TextStyle(fontSize: 10),)
              ],),),
              Container(width: MediaQuery.of(context).size.width/4,child: Column(children: [
                Image.asset('assets/images/renzhengbs2.png',width: 35,height: 35,),
                Text('流量扶持'.tr,textAlign:TextAlign.center,style: TextStyle(fontSize: 10),)
              ],),),
              Container(width: MediaQuery.of(context).size.width/4,child: Column(children: [
                Image.asset('assets/images/renzhengbs3.png',width: 35,height: 35,),
                Text('官号推荐'.tr,textAlign:TextAlign.center,style: TextStyle(fontSize: 10),)
              ],),),
              Container(width: MediaQuery.of(context).size.width/4,child: Column(children: [
                Image.asset('assets/images/renzhengbs4.png',width: 35,height: 35,),
                Text('资源位曝光'.tr,textAlign:TextAlign.center,style: TextStyle(fontSize: 10),)
              ],),)
            ],),)
          ],
        )
      
        ,
      ),
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            GestureDetector(child: Container(
              width: 19,
              height: 22,
              child: SvgPicture.asset(
                "assets/svg/youjiantou.svg",
              ),
            ), onTap: (){
              Get.back();
            },),
            Expanded(
                child: Center(
                  child: Text(
                    'LanLa认证申请'.tr,
                    style: const TextStyle(fontSize: 16,fontWeight: FontWeight.w700),
                  ),
                )),
            Container(
              width: 19,
            ),
          ],
        ),
      ),
    );

  }
  ///认证弹窗
  Redemptionsuccessful(context) async{
    // assets/images/qdtanc.png
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
            backgroundColor: Colors.transparent,
            contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
            content: Container(
                width: double.infinity,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)),color: Colors.white,),
                constraints: BoxConstraints(maxHeight: 400),
                child: Column(
                  crossAxisAlignment:CrossAxisAlignment.center,
                  children: [
                    // GestureDetector(child: Container(width: 50,color: Colors.white,alignment: Alignment.centerRight,padding: EdgeInsets.fromLTRB(20, 30, 20, 20),child: SvgPicture.asset(
                    //   "assets/svg/cha.svg",
                    //   color: Colors.black,
                    //   width: 12,
                    //   height: 12,
                    // ),),onTap: (){
                    //   Navigator.pop(context);
                    // },),
                    SizedBox(height: 30,),
                    Container(width: MediaQuery.of(context).size.width*0.4,alignment: Alignment.center,child: Image.asset('assets/images/renztctp.png',fit: BoxFit.cover,),),
                    SizedBox(height: 25,),
                    Container(width: double.infinity,alignment: Alignment.center,child: Text('认证申请已提交！'.tr,style: TextStyle(fontSize: 17,fontWeight: FontWeight.w700),),),
                    SizedBox(height: 8,),
                    Container(padding: EdgeInsets.only(left: 26,right: 26),child: Text('LanLa工作人员将在3日内审核后给你提示并给予你相应的头衔哟～'.tr,style: TextStyle(height: 1.8,fontSize: 14),),),
                    SizedBox(height: 25,),
                    GestureDetector(child: Container(margin: EdgeInsets.only(left: 20,right: 20),alignment: Alignment.center,height:50,width: double.infinity,
                      decoration: BoxDecoration(color: Color.fromRGBO(219, 255, 0, 1),borderRadius: BorderRadius.all(Radius.circular(50))),
                      child: Text('我知道了'.tr,style: TextStyle(color: Colors.black,fontWeight: FontWeight.w700),),
                    ),onTap: (){
                      Navigator.pop(context);
                    },),
                    SizedBox(height: 30,),
                  ],
                ))
        );
      },
    );
  }
}