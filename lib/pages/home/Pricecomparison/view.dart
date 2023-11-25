import 'dart:convert';
import 'dart:ui';


import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lanla_flutter/common/Starrating.dart';
import 'package:lanla_flutter/models/commoditylistanalysis.dart';
import 'package:lanla_flutter/pages/home/start/detail_view/loading_widget.dart';
import 'package:lanla_flutter/services/Pricecomparison.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../common/controller/UserLogic.dart';

class Pricecomparisonpage extends StatefulWidget{
  @override
  PricecomparisonState createState() => PricecomparisonState();
}
class PricecomparisonState extends State<Pricecomparisonpage> with AutomaticKeepAliveClientMixin{

  final userController = Get.find<UserLogic>();

  final ScrollController pd_controller = ScrollController();

  final ScrollController sp_controller = ScrollController();

  TextEditingController mControll3= TextEditingController();

  final Pricemodules = Get.put(Pricemodule());
  late int sppage=1;
  late int lbpage=1;
  late int spchannel=1;
  late String spkeyword='';
  var commoditylist=[];
  var frequencylist=[];
  bool oneData = false; // 是否首次请求过-用于展示等待页面
  bool twoData =false;
  @override
  void initState() {
     super.initState();
     SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(statusBarColor: Colors.transparent,statusBarIconBrightness: Brightness.dark);
     SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
     ///商品
     pindaolist();
     parityRatiolist();
     FirebaseAnalytics.instance.logEvent(
       name: "Pricecomparisonpage",
       parameters: {
         "userid": userController.userId
       },
     );
     pd_controller.addListener(() {
       if (pd_controller.offset == pd_controller.position.maxScrollExtent) {
         pindaolist();
       }
     });

     sp_controller.addListener(() {
       if (sp_controller.offset == sp_controller.position.maxScrollExtent) {

         parityRatiolist();
       }
     });
  }
  ///商品
  parityRatiolist() async {
    // 如果页数为3 未登录的话 需要先登录
    if (sppage >= 3){
      if (!userController.checkUserLogin()) {
        Get.toNamed('/public/loginmethod');
        return;
      }
    }
    var res= await Pricemodules.parityRatiolist({"keyword":spkeyword,"channel":spchannel,"page":sppage});
    if(res.statusCode==200){
      if  (res.bodyString != '[]') {
        commoditylist.addAll(commoditylistanalysisFromJson(res.bodyString!));
        sppage++;
        setState(() {});
      }
    }
    setState(() {
      oneData=true;
      twoData=true;
    });
  }
  pindaolist() async {
    var pdres= await Pricemodules.parityRatiochannlelist(lbpage);
    if(pdres.statusCode==200){
      if  (pdres.bodyString != '[]') {
        frequencylist.addAll(pdres.body);
        lbpage++;
        //commoditylist.addAll(commoditylistanalysisFromJson(res.bodyString!));
        setState(() {});
      }

    }
  }

  void dispose() {
    super.dispose();
    sppage = 1;
    lbpage = 1;
    spkeyword='';
    pd_controller.dispose();
    mControll3.dispose();
    sp_controller.dispose();
  }

  Future<void> _onRefresh() async {
    if (!userController.checkUserLogin()) {
      Get.toNamed('/public/loginmethod');
      return;
    }
    if(spchannel!=0){
      sppage=1;
    }

    var res= await Pricemodules.parityRatiolist({"keyword":spkeyword,"channel":spchannel,"page":sppage});
    if(res.statusCode==200){
      if  (res.bodyString != '[]') {
        commoditylist=[];
        commoditylist.addAll(commoditylistanalysisFromJson(res.bodyString!));
        sppage++;
      }else{
        sppage=1;
      }
      setState(() {});
    }
  }
  bool get wantKeepAlive => true; // 是否开启缓存

  Widget build(BuildContext context) {
    return
      Scaffold(
        // appBar: AppBar(
        //   systemOverlayStyle: SystemUiOverlayStyle.light,
        // ),
        body: GestureDetector(child:!oneData ? StartDetailLoading():Container(color: Colors.white,child: Column(
          children: [
            Container(width: double.infinity,height: 170,decoration: BoxDecoration(gradient: LinearGradient(
                begin: Alignment.topCenter,//渐变开始于上面的中间开始
                end: Alignment.bottomCenter,//渐变结束于下面的中间
                colors: [Color(0xffC5FF00),Color(0x00C5FF00)//开始颜色和结束颜色
                ])),
              child: Column(children: [
                SizedBox(height: MediaQueryData.fromWindow(window).padding.top+20,),
                ///搜索
                Container(padding:EdgeInsets.fromLTRB(20, 0, 20, 0),child:TextField(
                    controller: mControll3,
                  //focusNode: _searchFocus,
                    decoration: InputDecoration(
                      hintStyle:
                      const TextStyle(color: Color(0xffD9D9D9),fontSize: 13),
                      contentPadding:
                      const EdgeInsets.only(top: 0, bottom: 0),
                      enabledBorder: OutlineInputBorder(
                        ///设置边框四个角的弧度
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        ///用来配置边框的样式
                        // borderSide: BorderSide(
                        //   ///设置边框的颜色
                        //   color: Colors.black,
                        //   ///设置边框的粗细
                        //   width: 2.0,
                        // )
                        borderSide: BorderSide.none,),
                      focusedBorder: OutlineInputBorder(
                        // borderSide: BorderSide(
                        //   color: Colors.black, //边框颜色为白色
                        //   width: 2, //宽度为5
                        // ),
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(
                          Radius.circular(30), //边角为30
                        ),
                      ),
                      hintText: '输入搜索内容'.tr,
                      fillColor: Color(0xffffffff),
                      filled: true,
                      prefixIcon: Padding(                        padding: const EdgeInsets.only(
                            top: 12, bottom: 12, right: 5),
                        child: SvgPicture.asset(
                          'assets/icons/sousuo.svg',
                          width: 20,
                          height: 20,
                        ),
                      ),
                    ),
                    enableInteractiveSelection: true,
                    onChanged: (v) {
                      if(v==''){
                        spkeyword=v;
                        spchannel=1;
                        sppage=1;
                        commoditylist=[];
                        parityRatiolist();
                        return;
                      }
                      //_searchText = v;
                      spkeyword=v;
                      sppage=1;
                      spchannel=0;
                      commoditylist=[];
                      parityRatiolist();
                    },
                    onTap: (){
                      if (!userController.checkUserLogin()) {
                        Get.toNamed('/public/loginmethod');
                        return;
                      }
                          },
                    onSubmitted: (value) {

                      // _search();
                    }),),
                ///
                SizedBox(height: 10,),
                Expanded(child: Column(mainAxisAlignment:MainAxisAlignment.center,children: [Text('全网比价'.tr,style: TextStyle(color: Colors.black,fontSize: 13,),),SizedBox(height: 1,),Text('你的LanLa时尚购物指南'.tr,style: TextStyle(color: Colors.black,fontSize: 13,))],))
              ],),
            ),
            Expanded(child: Column(children: [
              Row(children: [
                Expanded(child: Container(height: 105,alignment: Alignment.center,
                  padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                  child: ListView(
                      shrinkWrap: true,
                      primary:false,
                      controller:  pd_controller,
                      scrollDirection: Axis.horizontal,
                      children:[
                        for(var item in frequencylist)
                          GestureDetector(child:Container(
                            color: Colors.white,
                            margin: EdgeInsets.only(right: 20),
                            child: Column(
                              children: [
                                Container(
                                  width: 45,
                                  height: 45,
                                  //超出部分，可裁剪
                                  clipBehavior: Clip.hardEdge,
                                  //padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1, color: spchannel==item['id']? Colors.black:Color(0xfff1f1f1)),
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Image.network(
                                    item['thumbnail'],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(height:5,),
                                Container(constraints: BoxConstraints(maxWidth: 60,),child: Text(item['title'],overflow: TextOverflow.ellipsis,
                                  maxLines: 1,style: TextStyle(fontSize: 12,color: spchannel==item['id']? Colors.black:Color(0xffD9D9D9)),),)
                              ],
                            ),
                          ),onTap: (){
                            if(!twoData){
                              return;
                            }
                            if(spchannel!=item['id']){
                              if (!userController.checkUserLogin()) {
                                Get.toNamed('/public/loginmethod');
                                return;
                              }

                              setState(() {
                                twoData=false;
                                spchannel=item['id'];
                              });
                              mControll3.clear();
                              spkeyword='';
                              sppage=1;
                              commoditylist=[];

                              parityRatiolist();
                            }
                            // Get.toNamed('/public/Evaluationdetails');
                          },),
                        SizedBox(width: 20,)
                      ]),
                )),
              ],),
              !twoData ? StartDetailLoading():Expanded(child: Container(child: RefreshIndicator(onRefresh: _onRefresh,
                child: commoditylist.length>0?ListView.builder(shrinkWrap: true,primary:false,controller:  sp_controller,padding:EdgeInsets.zero,itemCount: commoditylist.length,itemBuilder: (context, i) {
                return GestureDetector(onTap: (){
                  if (!userController.checkUserLogin()) {
                    Get.toNamed('/public/loginmethod');
                    return;
                  }

                  Get.toNamed('/public/Evaluationdetails',arguments: {'data':commoditylist[i]} );
                  //Get.toNamed('/public/Evaluationdetails',arguments: 15454 );
                },child: Column(children: [
                  Container(width: double.infinity,height: 10,color: Color(0xfff9f9f9),),
                  SizedBox(height: 15,),
                  Row(children: [
                    SizedBox(width: 20,),
                    Stack(children: [Container(width: 80, height: 80,
                      //超出部分，可裁剪
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                          color:Color(0xfff5f5f5),
                          borderRadius: BorderRadius.circular(5),
                          border:Border.all(width: 0.5,color: Color(0xfff5f5f5))
                      ),
                      child: Image.network(
                        commoditylist[i].thumbnail,
                        //fit: BoxFit.fill,
                        fit: BoxFit.cover,
                        width: 50, height: 50,
                      ),
                    ),
                      if(commoditylist[i].sort>0&&spchannel!=0)Positioned(top: 0,right:5,child: Container(alignment: Alignment.center,width: 16,height: 23,decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(i+1<4?'assets/images/shanginaiming.png':'assets/images/shangpinpxhui.png'),
                        fit: BoxFit.cover,
                      ),
                    ),child: Text((i+1).toString(),style: TextStyle(color: (i+1)<4?Colors.black:Colors.white,fontSize: 10,fontWeight: FontWeight.w700),),))],),
                    SizedBox(width: 10,),
                    Column(crossAxisAlignment:CrossAxisAlignment.start,children: [
                    Container(width: MediaQuery.of(context).size.width-120,child:
                    Text(commoditylist[i].title,overflow: TextOverflow.ellipsis,
                      maxLines: 1,style: TextStyle(fontSize: 14),),),

                      // Container(constraints: BoxConstraints(maxWidth: 250,),child:
                      // Text(commoditylist[i].title,overflow: TextOverflow.ellipsis,
                      //   maxLines: 1,style: TextStyle(fontSize: 14),),),
                    SizedBox(height: 8,),
                    Row(children: [
                      Container(height: 25,child: Text('评估'.tr,style: TextStyle(color: Color(0xff999999)),),),
                      SizedBox(width: 5,),
                      XMStartRating(rating: double.parse(commoditylist[i].score) ,showtext:true)
                    ],),
                  ],)],),
                  Container(height: 56,alignment: Alignment.centerRight,
                    padding: EdgeInsets.fromLTRB(0, 10, 10,0),
                    child: ListView(
                        shrinkWrap: true,
                        primary:false,
                        scrollDirection: Axis.horizontal,
                        children:[
                          for(var j=0;j<jsonDecode(commoditylist[i].priceOther).length;j++)
                            //GestureDetector(child:
                            Container(margin:EdgeInsets.only(right: 10),width: 110,height: 56,decoration: BoxDecoration(border: Border.all(width: 0.5,color: Color((0xffF5F5F5))),
                                color:Color(0xfff5f5f5),
                                borderRadius: BorderRadius.all(Radius.circular(5))
                            ),child: Column(mainAxisAlignment:MainAxisAlignment.center,children: [
                              Row(mainAxisAlignment:MainAxisAlignment.center,children: [
                                // Text("SAR",style: TextStyle(fontSize: 12,height: 1.1),),
                                // SizedBox(width: 2,),
                                Text(jsonDecode(commoditylist[i].priceOther)[j]['price'].split(' ')[0],style: TextStyle(height: 1.3,fontSize: 15,fontWeight: FontWeight.w600),),
                                SizedBox(width: 4,),
                                Text(jsonDecode(commoditylist[i].priceOther)[j]['price'].split(' ')[1],style: TextStyle(height: 1.3,fontSize: 12),)
                              ],),
                              Text(jsonDecode(commoditylist[i].priceOther)[j]['platform'],style: TextStyle(fontSize: 12,color: Color(0xff999999)),)
                            ],),)
                              //,onTap: () async {
                              // if (!userController.checkUserLogin()) {
                              //   Get.toNamed('/public/loginmethod');
                              //   return;
                              // }
                              // await launchUrl(Uri.parse(jsonDecode(commoditylist[i].priceOther)[j]['detailPath']), mode: LaunchMode.externalApplication,);
                            //},)
                        ]),
                  ),
                  SizedBox(height: 15,),
                ]),);
              }):ListView.builder(
                    itemCount: 1,
                    itemBuilder: (context, i) {
                      return Container(
                        // decoration: BoxDecoration(border:Border.all(color: Colors.red,width:1)),
                        child: Column(
                          // mainAxisAlignment:MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 60,
                            ),
                            Image.asset(
                              'assets/images/noGuanzhuBg.png',
                              width: 200,
                              height: 200,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              '没有更多数据'.tr,
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xff999999),
                                //fontFamily: 'PingFang SC-Regular, PingFang SC'
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),

                          ],
                        ),
                      );
                    }),
              )),),]),)
          ],
        ),),onPanDown: (details){
          // print('出发了吗???');
          FocusScope.of(context).unfocus();
        },),
      )
    ;
  }
}

