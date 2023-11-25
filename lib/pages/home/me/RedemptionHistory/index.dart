import 'dart:io';

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
  final ScrollController _scrollController = ScrollController(); //listview 的控制器
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
      if(st.isNotEmpty){
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
            contentPadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
            content: Container(
                width: double.infinity,
                clipBehavior: Clip.hardEdge,
                decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)),color: Colors.white,),
                constraints: const BoxConstraints(maxHeight: 375),
                child: Column(
                  crossAxisAlignment:CrossAxisAlignment.start,
                  children: [
                    GestureDetector(child: Container(width: 50,color: Colors.white,alignment: Alignment.centerRight,padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),child: SvgPicture.asset(
                      "assets/svg/cha.svg",
                      color: Colors.black,
                      width: 12,
                      height: 12,
                    ),),onTap: (){
                      Navigator.pop(context);
                    },),
                    Container(width: double.infinity,alignment: Alignment.center,child: Text('兑换成功'.tr,style: const TextStyle(fontSize: 20,fontWeight: FontWeight.w700),),),
                    const SizedBox(height: 25,),
                    Container(padding: const EdgeInsets.only(left: 20,right: 20),child: Column(crossAxisAlignment:CrossAxisAlignment.start,children: [
                      Text('您的卡密'.tr,style: const TextStyle(fontSize: 12,color: Color(0xff999999)),),
                      const SizedBox(height: 10,),
                      Text(pinCod,style: const TextStyle(fontSize: 20,fontWeight: FontWeight.w700),),
                      const SizedBox(height: 25,),
                      Text('你的卡密，关闭后可在奖品兑换中查看'.tr,style: const TextStyle(fontSize: 12,color: Color(0xffFF6565)))
                    ],),),
                    const SizedBox(height: 47,),
                    GestureDetector(child: Container(margin: const EdgeInsets.only(left: 20,right: 20),alignment: Alignment.center,height:50,width: double.infinity,
                      decoration: BoxDecoration(color: Colors.white,border: Border.all(width: 2,color: Colors.black),borderRadius: const BorderRadius.all(Radius.circular(50))),
                      child: Text('我知道了'.tr,style: const TextStyle(color: Colors.black,fontWeight: FontWeight.w700),),
                    ),onTap: (){
                      Navigator.pop(context);
                    },),
                    const SizedBox(height: 30,),

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
        backgroundColor: const Color(0xffF5F5F5),
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            '兑换历史'.tr,
            style: const TextStyle(fontSize: 16),
          ),
        ),
        body: Column(children: [
          !oneData ? StartDetailLoading():exchangelist.isNotEmpty?Expanded(child: Container(

            padding: const EdgeInsets.fromLTRB(20, 0, 20, 25),
            child: ListView(physics: const BouncingScrollPhysics(),controller: _scrollController,children: [
              const SizedBox(height: 25,),
              for(var i=0;i<exchangelist.length;i++)
              Container(
                margin: const EdgeInsets.only(bottom: 25),
                width: double.infinity,
                decoration:const BoxDecoration(color: Colors.white,borderRadius: BorderRadius.all(Radius.circular(8))),
                child: Column(children: [
                  const SizedBox(height: 15,),
                  Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children: [
                    Row(children: [
                      const SizedBox(width: 15,),
                      Container(width: 10,height:10,decoration: BoxDecoration(color: exchangelist[i].status==1?const Color(0xfff5f5f5):const Color(0xffD1FF34),borderRadius: const BorderRadius.all(Radius.circular(50))),),
                      const SizedBox(width: 8,),
                      Text(exchangelist[i].status==1?'审核中'.tr:'兑换成功'.tr,style: const TextStyle(fontSize: 14),),
                    ],),
                    if(exchangelist[i].type==2)GestureDetector(child: Container(margin: const EdgeInsets.only(left: 15),child: Text('点击查看'.tr,style: const TextStyle(fontSize: 14),),),onTap: (){
                      Redemptionsuccessfultwo(context,exchangelist[i].pinCode);
                    },)
                  ],),
                  const SizedBox(height: 10,),
                  Row(children: [
                  const SizedBox(width: 15,),
                  Text('兑换时间'.tr,style: const TextStyle(fontSize: 12,color: Color(0xff999999)),),
                  const SizedBox(width: 15,),
                  Text(exchangelist[i].createdAt,style: const TextStyle(fontSize: 12,color: Color(0xff999999)),),

                ],),
                  const SizedBox(height: 15,),
                  DottedLineDivider(
                    height: 1.0,
                    color: const Color(0xffF0F0F0),
                    indent: 20.0,
                    endIndent: 20.0,
                  ),
                  const SizedBox(height: 15,),
                  Row(children: [
                    const SizedBox(width: 15,),
                    Container(width: 60,height: 60,alignment: Alignment.center,decoration: const BoxDecoration(color: Color(0xfff5f5f5),borderRadius: BorderRadius.all(Radius.circular(8)),),child: Image.network(exchangelist[i].image,width: 40,height: 40,),),
                    const SizedBox(width: 10,),
                    Expanded(child: Container(height: 60,child: Column(crossAxisAlignment:CrossAxisAlignment.start,mainAxisAlignment:MainAxisAlignment.spaceEvenly,children: [
                      Text(exchangelist[i].title,style: const TextStyle(fontSize: 13),),
                      Row(children: [Image.asset('assets/images/beiketwo.png',width: 19,height: 17,),const SizedBox(width: 5,),Text(exchangelist[i].price.toString(),strutStyle: const StrutStyle(
                        forceStrutHeight: true,
                        leading: 0.5,
                      ),style: const TextStyle(fontSize: 18,fontWeight: FontWeight.w700),)],)
                    ],),)),
                    const SizedBox(width: 15,),
                  ],),
                  const SizedBox(height: 15,),
              ],),
              )
            ],),
          )):Nodatashuju()
        ],),

      );
  }
}


