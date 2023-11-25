import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lanla_flutter/common/controller/UserLogic.dart';
import 'package:lanla_flutter/models/exchangedata.dart';
import 'package:lanla_flutter/pages/home/message/Dashedline/view.dart';
import 'package:lanla_flutter/pages/home/start/detail_view/loading_widget.dart';
import 'package:lanla_flutter/pages/home/start/detail_view/no_data_widget.dart';
import 'package:lanla_flutter/services/newes.dart';
class exchangelistPage extends StatefulWidget  {
  @override
  exchangelistState createState() => exchangelistState();
}
class exchangelistState extends State<exchangelistPage>with SingleTickerProviderStateMixin {
  final userLogic = Get.find<UserLogic>();
  NewesProvider provider =  Get.put(NewesProvider());
  var oneData=false;
  int page=1;
  var exchangelist=[];
  ScrollController _scrollController = ScrollController(); //listview 的控制器
  @override
  void initState() {
    super.initState();
    Initial();
    _scrollController.addListener(() {
      if(_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent){
        Initial();
      }
    });
  }
  Initial() async {
    var res=await provider.getRedemptionDetails(page);
    if(res.statusCode==200){
      var st =(exchangedataFromJson(res?.bodyString ?? ""));
      print('请求接口123${st.length}');
      if(st.length>0){
        page++;
        exchangelist.addAll(st);
      }
      oneData=true;
      setState(() {

      });
    }
  }
  ///查看卡密
  Redemptionsuccessfultwo(context,pinCod) async{
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
                constraints: BoxConstraints(maxHeight: 375),
                child: Column(
                  crossAxisAlignment:CrossAxisAlignment.start,
                  children: [
                    GestureDetector(child: Container(width: 50,color: Colors.white,alignment: Alignment.centerRight,padding: EdgeInsets.fromLTRB(20, 30, 20, 20),child: SvgPicture.asset(
                      "assets/svg/cha.svg",
                      color: Colors.black,
                      width: 12,
                      height: 12,
                    ),),onTap: (){
                      Navigator.pop(context);
                    },),
                    Container(width: double.infinity,alignment: Alignment.center,child: Text('兑换成功'.tr,style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700),),),
                    SizedBox(height: 25,),
                    Container(padding: EdgeInsets.only(left: 20,right: 20),child: Column(crossAxisAlignment:CrossAxisAlignment.start,children: [
                      Text('您的卡密'.tr,style: TextStyle(fontSize: 12,color: Color(0xff999999)),),
                      SizedBox(height: 10,),
                      Text(pinCod,style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700),),
                      SizedBox(height: 25,),
                      Text('你的卡密，关闭后可在奖品兑换中查看'.tr,style: TextStyle(fontSize: 12,color: Color(0xffFF6565)))
                    ],),),
                    SizedBox(height: 47,),
                    GestureDetector(child: Container(margin: EdgeInsets.only(left: 20,right: 20),alignment: Alignment.center,height:50,width: double.infinity,
                      decoration: BoxDecoration(color: Colors.white,border: Border.all(width: 2,color: Colors.black),borderRadius: BorderRadius.all(Radius.circular(50))),
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
  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        backgroundColor: Color(0xffF5F5F5),
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            '兑换历史'.tr,
            style: TextStyle(fontSize: 16),
          ),
        ),
        body: Column(children: [
          !oneData ? StartDetailLoading():exchangelist.length>0?Expanded(child: Container(

            padding: EdgeInsets.fromLTRB(20, 0, 20, 25),
            child: ListView(physics: BouncingScrollPhysics(),controller: _scrollController,children: [
              SizedBox(height: 25,),
              for(var i=0;i<exchangelist.length;i++)
              Container(
                margin: EdgeInsets.only(bottom: 25),
                width: double.infinity,
                decoration:BoxDecoration(color: Colors.white,borderRadius: BorderRadius.all(Radius.circular(8))),
                child: Column(children: [
                  SizedBox(height: 15,),
                  Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children: [
                    Row(children: [
                      SizedBox(width: 15,),
                      Container(width: 10,height:10,decoration: BoxDecoration(color: exchangelist[i].status==1?Color(0xfff5f5f5):Color(0xffD1FF34),borderRadius: BorderRadius.all(Radius.circular(50))),),
                      SizedBox(width: 8,),
                      Text(exchangelist[i].status==1?'审核中'.tr:'兑换成功'.tr,style: TextStyle(fontSize: 14),),
                    ],),
                    if(exchangelist[i].type==2)GestureDetector(child: Container(margin: EdgeInsets.only(left: 15),child: Text('点击查看'.tr,style: TextStyle(fontSize: 14),),),onTap: (){
                      Redemptionsuccessfultwo(context,exchangelist[i].pinCode);
                    },)
                  ],),
                  SizedBox(height: 10,),
                  Row(children: [
                  SizedBox(width: 15,),
                  Text('兑换时间'.tr,style: TextStyle(fontSize: 12,color: Color(0xff999999)),),
                  SizedBox(width: 15,),
                  Text(exchangelist[i].createdAt,style: TextStyle(fontSize: 12,color: Color(0xff999999)),),

                ],),
                  SizedBox(height: 15,),
                  DottedLineDivider(
                    height: 1.0,
                    color: Color(0xffF0F0F0),
                    indent: 20.0,
                    endIndent: 20.0,
                  ),
                  SizedBox(height: 15,),
                  Row(children: [
                    SizedBox(width: 15,),
                    Container(width: 60,height: 60,alignment: Alignment.center,decoration: BoxDecoration(color: Color(0xfff5f5f5),borderRadius: BorderRadius.all(Radius.circular(8)),),child: Image.network(exchangelist[i].image,width: 40,height: 40,),),
                    SizedBox(width: 10,),
                    Expanded(child: Container(height: 60,child: Column(crossAxisAlignment:CrossAxisAlignment.start,mainAxisAlignment:MainAxisAlignment.spaceEvenly,children: [
                      Text(exchangelist[i].title,style: TextStyle(fontSize: 13),),
                      Row(children: [Image.asset('assets/images/beiketwo.png',width: 19,height: 17,),SizedBox(width: 5,),Text(exchangelist[i].price.toString(),strutStyle: StrutStyle(
                        forceStrutHeight: true,
                        leading: 0.5,
                      ),style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700),)],)
                    ],),)),
                    SizedBox(width: 15,),
                  ],),
                  SizedBox(height: 15,),
              ],),
              )
            ],),
          )):Nodatashuju()
        ],),

      );
  }
}


