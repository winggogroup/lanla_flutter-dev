import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:lanla_flutter/common/Starrating.dart';
import 'package:lanla_flutter/common/controller/UserLogic.dart';
import 'package:lanla_flutter/models/HomeItem.dart';
import 'package:lanla_flutter/models/ProductDetails.dart';
import 'package:lanla_flutter/pages/home/Pricecomparison/Allcomments.dart';
import 'package:lanla_flutter/pages/home/start/detail_view/item.dart';
import 'package:lanla_flutter/pages/home/start/detail_view/view.dart';
import 'package:lanla_flutter/services/Pricecomparison.dart';
import 'package:lanla_flutter/services/content.dart';
import 'package:lanla_flutter/services/topic.dart';
import 'package:lanla_flutter/ulits/image_cache.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:url_launcher/url_launcher.dart';

class EvaluationdetailsPage extends StatefulWidget{
  @override
  EvaluationdetailState createState() => EvaluationdetailState();
}
class EvaluationdetailState extends State<EvaluationdetailsPage>{
  final Pricemodules = Get.put(Pricemodule());
  final userController = Get.find<UserLogic>();
  final userLogic = Get.find<UserLogic>();
  final ScrollController _controller = ScrollController();
  int pageType = 1;
  int page=1;
  var Dataday=1;
  List<HomeItem> contentList = [];
  var Productdetails;
  var ParentData;
  List<ChartData> Linechartday=[];
  bool oneData = false; // 是否首次请求过-用于展示等待页面
  @override
  void initState() {
    super.initState();
    FirebaseAnalytics.instance.logEvent(
      name: "EvaluationdetailsPage",
      parameters: {
        "userid": userController.userId
      },
    );
    print('jinlaile${Get.arguments.runtimeType.toString()}');
    if(Get.arguments.runtimeType.toString()!='int'){
      ParentData=Get.arguments['data'];
    }
    spdetail();
    _getData();

    _controller.addListener(() {
      if (_controller.offset == _controller.position.maxScrollExtent) {
        _getData();
      }
    });
  }
  ///商品详情
  spdetail() async{
    var res=await Pricemodules.parityRatiodetail(ParentData!=null?ParentData.id:Get.arguments,3,1);
    if(res.statusCode==200){
      Productdetails=spDetailsFromJson(res.bodyString!);
      for(var i=0;i<7;i++){
        if(jsonDecode(Productdetails.historyPrice).length>i){
          Linechartday.add(ChartData(jsonDecode(Productdetails.historyPrice)[i]['date'],double.parse(jsonDecode(Productdetails.historyPrice)[i]['price'])));
        }
      };
      print('我要的数据${(jsonDecode(Productdetails.historyPrice).length)}');
      setState(() {});
    }
  }
  ///商品收藏
  collect() async {
    var res=await Pricemodules.parityRatiocollect(Productdetails.id);
    if(res.statusCode==200){
      setState(() {
        Productdetails.isCollect=!Productdetails.isCollect;
      });
    }
  }
  _getData() async {
    var result = await Pricemodules.Relatedworks(ParentData!=null?ParentData.id:Get.arguments,page);
    if(result.isNotEmpty){
      contentList.addAll(result);
      page++;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return
      ParentData!=null || Productdetails!=null?Container(color: const Color(0xffF5F5F5),child: SingleChildScrollView(physics: const BouncingScrollPhysics(),controller: _controller,child:
      Column(children: [
        Stack(children: [
          Container(color: Colors.white,child: Productdetails==null||Productdetails.images==''? _swiper(context,ParentData.images.split('|'),0.3):_swiper(context,Productdetails.images.split('|'),0.3),),
          Positioned(right: 10,top:MediaQuery.of(context).padding.top,child:GestureDetector(child:  Image.asset('assets/images/bjfanhui.png',width: 30,height: 30,),onTap: (){
            Get.back();
          },)),
          ///收藏
          if(Productdetails!=null)Positioned(left: 55,top:MediaQuery.of(context).padding.top,child:GestureDetector(child: Image.asset(Productdetails.isCollect?'assets/images/spshoucang.png':'assets/images/bjshouc.png',width: 30,height: 30,),onTap: (){
            collect();
          },)),
          ///分享
          if(Productdetails!=null)Positioned(left: 10,top:MediaQuery.of(context).padding.top,child:GestureDetector(child: Image.asset('assets/images/bjfenxiang.png',width: 30,height: 30,),onTap: (){
            if (!userLogic.checkUserLogin()) {
              Get.toNamed('/public/loginmethod');
              return;
            }
            Get.put<ContentProvider>(ContentProvider()).ForWard(Productdetails.id ,11);
            Share.share('https://api.lanla.app/share?g=${Productdetails.id}');
          },),)

        ],),
        Container(width: double.infinity,height: 2,color: const Color(0xffD1FF34),),
        Container(width: double.infinity,padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),child:
        Column(children: [
          ///商品名称
          Container(width: double.infinity,padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),decoration: const BoxDecoration(color: Colors.white,borderRadius: BorderRadius.all(Radius.circular(5))),child: Text(
            Productdetails==null?ParentData.title:Productdetails.title,style: const TextStyle(fontSize: 16,fontWeight: FontWeight.w600),maxLines: 4,overflow: TextOverflow.ellipsis,
          ),),
          const SizedBox(height: 10,),
          ///比价部分
          Productdetails!=null?Container(padding: const EdgeInsets.all(15),decoration: const BoxDecoration(color: Colors.white,borderRadius: BorderRadius.all(Radius.circular(5))),
            child: Column(children: [
              Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children: [Text('lanla全网比价'.tr,style: const TextStyle(fontSize: 14),)],),
              const SizedBox(height: 10,),
              ///商品选择
              Container(height: 110,alignment: Alignment.centerRight,
                padding: const EdgeInsets.fromLTRB(0, 10, 0,0),
                child: ListView(
                    shrinkWrap: true,
                    primary:false,
                    scrollDirection: Axis.horizontal,
                    children:[
                      for(var i=0;i<jsonDecode(Productdetails.priceOther).length;i++)
                        GestureDetector(child: Column(children: [
                          Container(margin:const EdgeInsets.only(left: 10),width: 110,height: 56,decoration: BoxDecoration(border: Border.all(width:1,color: const Color((0xffF5F5F5))),
                              color: const Color(0xfff5f5f5),
                              borderRadius: const BorderRadius.all(Radius.circular(5))
                          ),child: Column(mainAxisAlignment:MainAxisAlignment.center,children: [
                            Row(mainAxisAlignment:MainAxisAlignment.center,children: [
                              // Text("SAR",style: TextStyle(fontSize: 12,height: 1.1),),
                              // SizedBox(width: 2,),
                              Text(jsonDecode(Productdetails.priceOther)[i]['price'].split(' ')[0],style: const TextStyle(height: 1.3,fontSize: 15,fontWeight: FontWeight.w600),),
                              const SizedBox(width: 4,),
                              Text(jsonDecode(Productdetails.priceOther)[i]['price'].split(' ')[1],style: const TextStyle(height: 1.3,fontSize: 12),)
                            ],),
                            Text(jsonDecode(Productdetails.priceOther)[i]['platform'],style: const TextStyle(fontSize: 12,color: Color(0xff999999)),)
                          ],),),
                          const SizedBox(height: 5,),
                          Container(alignment: Alignment.center,margin:const EdgeInsets.only(left: 10),width: 110,height: 35,decoration: BoxDecoration(border: Border.all(width: 0.5,color: const Color((0xffE1E1E1))),

                              borderRadius: const BorderRadius.all(Radius.circular(5))
                          ),child: Text('跳转购买'.tr,style: const TextStyle(fontSize: 13),),),
                        ],),onTap: () async {
                          ///跳转购买
                          await launchUrl(Uri.parse(jsonDecode(Productdetails.priceOther)[i]['detailPath']), mode: LaunchMode.externalApplication,);
                        },)

                    ]),
              ),
              const SizedBox(height: 20,),
              ///折线图
              if(Productdetails!=null)Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children: [
                GestureDetector(child: Column(children: [Text('7天'.tr,style: TextStyle(fontWeight:Dataday==1? FontWeight.w600:FontWeight.w400),),const SizedBox(height: 2,),Container(height: 2,width: 12,color: Dataday==1?Colors.black:Colors.white,)],),onTap: (){
                  Linechartday=[];
                  for(var i=0;i<7;i++){
                    if(jsonDecode(Productdetails.historyPrice).length>i){
                      print('tiao${jsonDecode(Productdetails.historyPrice)[0]['date']}');
                      Linechartday.add(ChartData(jsonDecode(Productdetails.historyPrice)[i]['date'],double.parse(jsonDecode(Productdetails.historyPrice)[i]['price'])));
                    }
                  };
                  Dataday=1;
                  setState(() {
                  });
                },),
                GestureDetector(onTap: (){
                  Linechartday=[];
                  for(var i=0;i<30;i++){
                    if(jsonDecode(Productdetails.historyPrice).length>i){
                      Linechartday.add(ChartData(jsonDecode(Productdetails.historyPrice)[i]['date'],double.parse(jsonDecode(Productdetails.historyPrice)[i]['price'])));
                    }
                  };
                  Dataday=2;
                  setState(() {
                    // Linechartday=30;
                  });
                },child: Column(children: [Text('30天'.tr,style: TextStyle(fontWeight:Dataday==2? FontWeight.w600:FontWeight.w400),),const SizedBox(height: 2,),Container(height: 2,width: 12,color: Dataday==2?Colors.black:Colors.white,)],),),

                GestureDetector(child: Column(children: [Text('60天'.tr,style: TextStyle(fontWeight: Dataday==3?FontWeight.w600:FontWeight.w400),),const SizedBox(height: 2,),Container(height: 2,width: 12,color: Dataday==3?Colors.black:Colors.white,)],),onTap: (){
                  Linechartday=[];
                  for(var i=0;i<60;i++){
                    if(jsonDecode(Productdetails.historyPrice).length>i){
                      Linechartday.add(ChartData(jsonDecode(Productdetails.historyPrice)[i]['date'],double.parse(jsonDecode(Productdetails.historyPrice)[i]['price'])));
                    }
                  };
                  Dataday=3;
                  setState(() {
                    //Linechartday=60;
                  });
                },),
                GestureDetector(child:Column(children: [Text('180天'.tr,style: TextStyle(fontWeight: Dataday==4?FontWeight.w600:FontWeight.w400),),const SizedBox(height: 2,),Container(height: 2,width: 12,color: Dataday==4?Colors.black:Colors.white,)],),
                  onTap: (){
                    Linechartday=[];
                    for(var i=0;i<180;i++){
                      if(jsonDecode(Productdetails.historyPrice).length>i){
                        Linechartday.add(ChartData(jsonDecode(Productdetails.historyPrice)[i]['date'],double.parse(jsonDecode(Productdetails.historyPrice)[i]['price'])));
                      }
                    };
                    Dataday=4;
                    setState(() {});
                  },),
                ///设置价格提醒
                //Container(padding: EdgeInsets.fromLTRB(10, 7, 10, 7),decoration: BoxDecoration(color: Color(0xffE7FFD8),borderRadius: BorderRadius.all(Radius.circular(5))),child: Text('设置价格提醒'.tr,style: TextStyle(color: Color(0xff00B507),fontSize: 12,height: 1),),)
                Container(width: 100,)
              ],),
              if(Productdetails!=null)Container(
                  height: 130,
                  child: SfCartesianChart(
                      enableAxisAnimation: true,
                      primaryXAxis: CategoryAxis(
                        //isVisible: true,
                        //显示时间轴置顶
                        //opposedPosition: false,
                        //时间轴反转
                        isInversed: true,
                      ),
                      primaryYAxis: NumericAxis( opposedPosition: true,),
                      series: <ChartSeries>[
                        AreaSeries<ChartData, String>(
                          //markerSettings: MarkerSettings(isVisible: true),
                            dataSource: Linechartday,

                            gradient: const LinearGradient(begin:Alignment.bottomCenter,end:Alignment.topCenter,colors: [Color(0x0070FF00),Color(0x33DEFF99)], stops: [0.0,1]),
                            //borderMode: AreaBorderMode.excludeBottom,
                            borderColor: const Color(0xff9BE400),
                            borderWidth: 2,
                            xValueMapper: (data, _) => data.x,
                            yValueMapper: (ChartData data, _) => data.y,
                            //name: 'Gold',
                            color: const Color(0x009BE400)
                        )
                      ])
              ),
            ],),
          ):Container(padding: const EdgeInsets.all(15),decoration: const BoxDecoration(color: Colors.white,borderRadius: BorderRadius.all(Radius.circular(5))),
            child: Column(children: [
              Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children: [Text('lanla全网比价'.tr,style: const TextStyle(fontSize: 14),)],),
              const SizedBox(height: 10,),
              ///商品选择
              Container(height: 110,alignment: Alignment.centerRight,
                padding: const EdgeInsets.fromLTRB(0, 10, 0,0),
                child: ListView(
                    shrinkWrap: true,
                    primary:false,
                    scrollDirection: Axis.horizontal,
                    children:[
                      for(var i=0;i<jsonDecode(ParentData.priceOther).length;i++)
                        GestureDetector(child: Column(children: [
                          Container(margin:const EdgeInsets.only(left: 10),width: 110,height: 56,decoration: BoxDecoration(border: Border.all(width:1,color: const Color((0xffF5F5F5))),
                              color: const Color(0xfff5f5f5),
                              borderRadius: const BorderRadius.all(Radius.circular(5))
                          ),child: Column(mainAxisAlignment:MainAxisAlignment.center,children: [
                            Row(mainAxisAlignment:MainAxisAlignment.center,children: [
                              // Text("SAR",style: TextStyle(fontSize: 12,height: 1.1),),
                              // SizedBox(width: 2,),
                              Text(jsonDecode(ParentData.priceOther)[i]['price'].split(' ')[0],style: const TextStyle(height: 1.3,fontSize: 15,fontWeight: FontWeight.w600),),
                              const SizedBox(width: 4,),
                              Text(jsonDecode(ParentData.priceOther)[i]['price'].split(' ')[1],style: const TextStyle(height: 1.3,fontSize: 12),)
                            ],),
                            Text(jsonDecode(ParentData.priceOther)[i]['platform'],style: const TextStyle(fontSize: 12,color: Color(0xff999999)),)
                          ],),),
                          const SizedBox(height: 5,),
                          Container(alignment: Alignment.center,margin:const EdgeInsets.only(left: 10),width: 110,height: 35,decoration: BoxDecoration(border: Border.all(width: 0.5,color: const Color((0xffE1E1E1))),

                              borderRadius: const BorderRadius.all(Radius.circular(5))
                          ),child: Text('跳转购买'.tr,style: const TextStyle(fontSize: 13),),),
                        ],),onTap: () async {
                          ///跳转购买
                          await launchUrl(Uri.parse(jsonDecode(ParentData.priceOther)[i]['detailPath']), mode: LaunchMode.externalApplication,);
                        },)

                    ]),
              ),
              const SizedBox(height: 20,),
              ///折线图
              if(ParentData!=null)Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children: [
                GestureDetector(child: Column(children: [Text('7天'.tr,style: TextStyle(fontWeight:Dataday==1? FontWeight.w600:FontWeight.w400),),const SizedBox(height: 2,),Container(height: 2,width: 12,color: Dataday==1?Colors.black:Colors.white,)],),onTap: (){
                  Linechartday=[];
                  for(var i=0;i<7;i++){
                    if(jsonDecode(ParentData.historyPrice).length>i){
                      print('tiao${jsonDecode(ParentData.historyPrice)[0]['date']}');
                      Linechartday.add(ChartData(jsonDecode(ParentData.historyPrice)[i]['date'],double.parse(jsonDecode(ParentData.historyPrice)[i]['price'])));
                    }
                  };
                  Dataday=1;
                  setState(() {
                  });
                },),
                GestureDetector(onTap: (){
                  Linechartday=[];
                  for(var i=0;i<30;i++){
                    if(jsonDecode(ParentData.historyPrice).length>i){
                      Linechartday.add(ChartData(jsonDecode(ParentData.historyPrice)[i]['date'],double.parse(jsonDecode(ParentData.historyPrice)[i]['price'])));
                    }
                  };
                  Dataday=2;
                  setState(() {
                    // Linechartday=30;
                  });
                },child: Column(children: [Text('30天'.tr,style: TextStyle(fontWeight:Dataday==2? FontWeight.w600:FontWeight.w400),),const SizedBox(height: 2,),Container(height: 2,width: 12,color: Dataday==2?Colors.black:Colors.white,)],),),

                GestureDetector(child: Column(children: [Text('60天'.tr,style: TextStyle(fontWeight: Dataday==3?FontWeight.w600:FontWeight.w400),),const SizedBox(height: 2,),Container(height: 2,width: 12,color: Dataday==3?Colors.black:Colors.white,)],),onTap: (){
                  Linechartday=[];
                  for(var i=0;i<60;i++){
                    if(jsonDecode(ParentData.historyPrice).length>i){
                      Linechartday.add(ChartData(jsonDecode(ParentData.historyPrice)[i]['date'],double.parse(jsonDecode(ParentData.historyPrice)[i]['price'])));
                    }
                  };
                  Dataday=3;
                  setState(() {
                    //Linechartday=60;
                  });
                },),
                GestureDetector(child:Column(children: [Text('180天'.tr,style: TextStyle(fontWeight: Dataday==4?FontWeight.w600:FontWeight.w400),),const SizedBox(height: 2,),Container(height: 2,width: 12,color: Dataday==4?Colors.black:Colors.white,)],),
                  onTap: (){
                    Linechartday=[];
                    for(var i=0;i<180;i++){
                      if(jsonDecode(ParentData.historyPrice).length>i){
                        Linechartday.add(ChartData(jsonDecode(ParentData.historyPrice)[i]['date'],double.parse(jsonDecode(ParentData.historyPrice)[i]['price'])));
                      }
                    };
                    Dataday=4;
                    setState(() {});
                  },),
                ///设置价格提醒
                //Container(padding: EdgeInsets.fromLTRB(10, 7, 10, 7),decoration: BoxDecoration(color: Color(0xffE7FFD8),borderRadius: BorderRadius.all(Radius.circular(5))),child: Text('设置价格提醒'.tr,style: TextStyle(color: Color(0xff00B507),fontSize: 12,height: 1),),)
                Container(width: 100,)
              ],),
              if(ParentData!=null)Container(
                  height: 130,
                  child: SfCartesianChart(
                      enableAxisAnimation: true,
                      primaryXAxis: CategoryAxis(
                        //isVisible: true,
                        //显示时间轴置顶
                        //opposedPosition: false,
                        //时间轴反转
                        isInversed: true,
                      ),
                      primaryYAxis: NumericAxis( opposedPosition: true,),
                      series: <ChartSeries>[
                        AreaSeries<ChartData, String>(
                          //markerSettings: MarkerSettings(isVisible: true),
                            dataSource: Linechartday,

                            gradient: const LinearGradient(begin:Alignment.bottomCenter,end:Alignment.topCenter,colors: [Color(0x0070FF00),Color(0x33DEFF99)], stops: [0.0,1]),
                            //borderMode: AreaBorderMode.excludeBottom,
                            borderColor: const Color(0xff9BE400),
                            borderWidth: 2,
                            xValueMapper: (data, _) => data.x,
                            yValueMapper: (ChartData data, _) => data.y,
                            //name: 'Gold',
                            color: const Color(0x009BE400)
                        )
                      ])
              ),
            ],),
          ),
          const SizedBox(height: 10,),
          ///评价
          if(Productdetails!=null)Container(padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),width: double.infinity,decoration: const BoxDecoration(color: Colors.white,borderRadius: BorderRadius.all(Radius.circular(5))),
            child: Column(children: [
              Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children: [Text('用户评测'.tr,style: const TextStyle(fontSize: 16)),
                GestureDetector(onTap: (){
                  ///跳转全部评论
                  Get.to(allcommentsPage(),arguments:Productdetails.id )?.then((value) async {
                    print('数据');
                    var res=await Pricemodules.parityRatiodetail(Productdetails.id,3,1);
                    if(res.statusCode==200){
                      Productdetails=spDetailsFromJson(res.bodyString!);
                      setState(() {});
                    }
                  });
                },child:Container(padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)),color: Color(0xff000000)),child: Text('我也要评测'.tr,style: const TextStyle(color: Colors.white,fontSize: 12,height: 1),),) ,)],),
              const SizedBox(height: 20,),
              Container(child: Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children: [
                Container(height:90,child: Column(mainAxisAlignment:MainAxisAlignment.spaceBetween,children: [Text(Productdetails.score,style: const TextStyle(color: Color(0xff9BE400),fontSize: 35,fontWeight: FontWeight.w600,height: 1),),XMStartRating(rating: 9,showtext:false),const SizedBox(height: 10,),Text('已评分'.tr+' (${Productdetails.commentNum})'.tr,style: const TextStyle(fontSize: 12,color: Color(0xff999999)),)],),),
                Container(child: Column(crossAxisAlignment:CrossAxisAlignment.end,children: [
                  ///5星
                  Row(children: [
                    const Icon(Icons.star, size: 12, color: Color(0xFF9BE400),),
                    const Icon(Icons.star, size: 12, color: Color(0xFF9BE400),),
                    const Icon(Icons.star, size: 12, color: Color(0xFF9BE400),),
                    const Icon(Icons.star, size: 12, color: Color(0xFF9BE400),),
                    const Icon(Icons.star, size: 12, color: Color(0xFF9BE400),),
                    const SizedBox(width: 10,),
                    ///进度条
                    CustomProgressBar(value: (Productdetails.fiveStarNum)/100,
                      backgroundColor: const Color(0xffF5F5F5),
                      color: const Color(0xff9BE400),borderRadius: 10,),
                    const SizedBox(width: 10,),
                    Container(alignment: Alignment.centerRight,width: 30,child: Text('${Productdetails.fiveStarNum}%',style: const TextStyle(fontSize: 10,color: Color(0xff999999)),),)
                  ],),
                  const SizedBox(height: 5,),
                  ///4星
                  Row(children: [
                    const Icon(Icons.star, size: 12, color: Color(0xFF9BE400),),
                    const Icon(Icons.star, size: 12, color: Color(0xFF9BE400),),
                    const Icon(Icons.star, size: 12, color: Color(0xFF9BE400),),
                    const Icon(Icons.star, size: 12, color: Color(0xFF9BE400),),
                    const SizedBox(width: 10,),
                    ///进度条
                    CustomProgressBar(value: (Productdetails.fourStarNum)/100,
                      backgroundColor: const Color(0xffF5F5F5),
                      color: const Color(0xff9BE400),borderRadius: 10,),
                    const SizedBox(width: 10,),
                    Container(alignment: Alignment.centerRight,width: 30,child: Text('${Productdetails.fourStarNum}%',style: const TextStyle(fontSize: 10,color: Color(0xff999999)),),)
                  ],),
                  const SizedBox(height: 5,),
                  ///3星
                  Row(children: [
                    const Icon(Icons.star, size: 12, color: Color(0xFF9BE400),),
                    const Icon(Icons.star, size: 12, color: Color(0xFF9BE400),),
                    const Icon(Icons.star, size: 12, color: Color(0xFF9BE400),),
                    const SizedBox(width: 10,),
                    ///进度条
                    CustomProgressBar(value: (Productdetails.threeStarNum)/100,
                      backgroundColor: const Color(0xffF5F5F5),
                      color: const Color(0xff9BE400),borderRadius: 10,),
                    const SizedBox(width: 10,),
                    Container(alignment: Alignment.centerRight,width: 30,child: Text('${Productdetails.threeStarNum}%',style: const TextStyle(fontSize: 10,color: Color(0xff999999)),),)
                  ],),
                  const SizedBox(height: 5,),
                  ///2星
                  Row(children: [
                    const Icon(Icons.star, size: 12, color: Color(0xFF9BE400),),
                    const Icon(Icons.star, size: 12, color: Color(0xFF9BE400),),
                    const SizedBox(width: 10,),
                    ///进度条
                    CustomProgressBar(value: (Productdetails.twoStarNum)/100, backgroundColor: const Color(0xffF5F5F5), color: const Color(0xff9BE400),borderRadius: 10,),
                    const SizedBox(width: 10,),
                    Container(alignment: Alignment.centerRight,width: 30,child: Text('${Productdetails.twoStarNum}%',style: const TextStyle(fontSize: 10,color: Color(0xff999999)),),)

                  ],),
                  const SizedBox(height: 5,),
                  ///1星
                  Row(children: [
                    const Icon(Icons.star, size: 12, color: Color(0xFF9BE400),),
                    const SizedBox(width: 10,),
                    ///进度条
                    CustomProgressBar(value: (Productdetails.oneStarNum)/100, backgroundColor: const Color(0xffF5F5F5), color: const Color(0xff9BE400),borderRadius: 10,),
                    const SizedBox(width: 10,),
                    Container(alignment: Alignment.centerRight,width: 30,child: Text('${Productdetails.oneStarNum}%',style: const TextStyle(fontSize: 10,color: Color(0xff999999)),),)

                  ],)
                ],),)
              ],),),
              const SizedBox(height: 20,),
              for(var i=0;i<Productdetails.commentList.length;i++)
                Column(children: [
                  ///分割线
                  Container(height: 1.0, decoration: const BoxDecoration(color: Color(0xfff1f1f1), boxShadow: [BoxShadow(color: Color(0x0c00000), offset: Offset(0, 2), blurRadius: 5, spreadRadius: 0,),],
                  ),),
                  const SizedBox(height: 10,),
                  Row(children: [
                    ///头像
                    GestureDetector(child:Container(
                        width: 40, height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(Productdetails.commentList[i].avatar),
                          ),
                        )
                    ),onTap: (){
                      // 进入个人主页
                      if(Productdetails.commentList[i].userId!=0){
                        Get.toNamed('/public/user', arguments: Productdetails.commentList[i].userId);
                      }
                    },),
                    const SizedBox(width: 10,),
                    Column(crossAxisAlignment:CrossAxisAlignment.start,mainAxisAlignment:MainAxisAlignment.spaceBetween,children: [Text(Productdetails.commentList[i].username,style: const TextStyle(),),const SizedBox(height: 8,),Row(children: [Text(Productdetails.commentList[i].score,style: const TextStyle(color: Color(0xff9BE400),fontSize: 12,fontWeight: FontWeight.w600),),const SizedBox(width: 10,),Text(Productdetails.commentList[i].createdAt,style: const TextStyle(fontSize: 12,color: Color(0XFF999999)),)],)],),
                  ],),
                  if(Productdetails.commentList[i].text!='')const SizedBox(height: 5,),
                  ///评论
                  if(Productdetails.commentList[i].text!='')Container(width: double.infinity,margin: const EdgeInsets.only(right: 50),child: Text(Productdetails.commentList[i].text, overflow: TextOverflow.ellipsis, //长度溢出后显示省略号
                    maxLines: 8,
                    style: const TextStyle(
                        fontWeight: FontWeight.w500, fontSize: 13,color: Color(0XFF666666),height: 1.3),
                  ),),
                  const SizedBox(height: 10,),
                  if( Productdetails.commentList[i].images!='')Container(margin: const EdgeInsets.only(right: 50),width: double.infinity,child: Row(children: [
                    for(var r=0;r<Productdetails.commentList[i].images.split(',').length;r++)
                      if(r<5)Container(margin: const EdgeInsets.only(left: 10),width: 45,height: 45,decoration: BoxDecoration(
                        color: const Color(0xffd9d9d9),borderRadius: const BorderRadius.all(Radius.circular(5)),image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(Productdetails.commentList[i].images.split(',')[r]),
                      ),),),
                  ],),)
                ],),
              const SizedBox(height: 10,),
              ///分割线
              Container(height: 1.0, decoration: const BoxDecoration(color: Color(0xfff1f1f1), boxShadow: [BoxShadow(color: Color(0x0c00000), offset: Offset(0, 2), blurRadius: 5, spreadRadius: 0,),],
              ),),
              const SizedBox(height: 15,),
              GestureDetector(child: Text('查看全部评论'.tr,style: const TextStyle(color: Color(0xff999999)),),onTap: (){
                ///跳转全部评论
                Get.to(allcommentsPage(),arguments:Productdetails.id )?.then((value) async {
                  print('数据');
                  var res=await Pricemodules.parityRatiodetail(Productdetails.id,3,1);
                  if(res.statusCode==200){
                    Productdetails=spDetailsFromJson(res.bodyString!);
                    setState(() {});
                  }
                });
              },),
            ],),
          ),
        ],),),
        if(contentList.isNotEmpty)Container(padding: const EdgeInsets.only(right: 10,top: 10),width: double.infinity,color: Colors.white,child: Column(children: [
          Row(children: [
            Image.asset('assets/images/zhongcao.png',width: 25,height: 25,),
            const SizedBox(width: 5,),
            Text('种草'.tr,style: const TextStyle(fontWeight: FontWeight.w600,fontSize: 15),),
          ],),
          const SizedBox(height: 10,),
          // Row(children: [
          //   GestureDetector(child:Column(children: [Text('精选'.tr,style: TextStyle(fontWeight: FontWeight.w600,fontSize: 14)),SizedBox(height: 3,),Container(height: 3,width: 30,color:pageType==1? Colors.black:Colors.white,)],),onTap: (){
          //     setState(() {
          //       pageType=1;
          //     });
          //   },) ,
          //   SizedBox(width: 20,),
          //   GestureDetector(child: Column(children: [Text('最新'.tr,style: TextStyle(fontWeight: FontWeight.w600,fontSize: 14)),SizedBox(height: 3,),Container(height: 3,width: 30,color: pageType==2? Colors.black:Colors.white,)],),onTap: (){
          //     setState(() {
          //       pageType=2;
          //     });
          //   },)
          // ],),
        ],),),
        if(Productdetails!=null&& contentList.isNotEmpty)
          Container(padding: const EdgeInsets.only(bottom: 20),color: Colors.white,child: MasonryGridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(), //禁止滚动
            crossAxisCount: 2,
            mainAxisSpacing: 6,
            // 上下间隔
            crossAxisSpacing: 6,
            //左右间隔
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            // 总数
            itemCount: contentList.length,
            itemBuilder: (context, index) {
              return IndexItemWidget(
                contentList[index],
                index,
                userController.getLike(contentList[index].id),
                    (index) {
                  bool status = userController.setLike(contentList[index].id);
                  status ? contentList[index].likes++ : contentList[index].likes--;
                  setState(() {});
                },
                false,
                ApiType.topicHot,
                "1",
                isLoading: false,
                    () {},
              );
            },
          ),),

      ],),

      ),):Container();
  }
  ///顶部轮播图
  Widget _swiper(BuildContext context, imageList, attaImageScale) {
    //double defultHeight = MediaQuery.of(context).size.width * attaImageScale;
    //if (defultHeight > 340) {
    double  defultHeight = 340;
    // }
    bool isOne = imageList.length == 1 ? true : false;
    return ConstrainedBox(
        constraints: BoxConstraints.loose(Size(
            MediaQuery.of(context).size.width,
            defultHeight)),
        child: isOne
            ? ImageCacheWidget(imageList[0],defultHeight)
            :
        Swiper(
          //outer: true,
          itemBuilder: (c, i) {
            return CachedNetworkImage(imageUrl: imageList[i],progressIndicatorBuilder: (context, url, downloadProgress) =>
                Container(
                  width:  MediaQuery.of(context).size.width,
                  height: defultHeight,
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xffD1FF34),
                      strokeWidth: 4,
                    ),
                  ),
                ),);
            return ImageCacheWidget(imageList[i],defultHeight);
          },
          pagination: SwiperPagination(
            //margin: EdgeInsets.zero,
              builder: SwiperCustomPagination(builder: (context, config) {
                return ConstrainedBox(
                  child: Container(

                      child:Stack(children: [
                        Positioned(child: Container(decoration: BoxDecoration(color: const Color(0x66000000), borderRadius: BorderRadius.circular(30)),padding: const EdgeInsets.fromLTRB(10, 6, 10, 4),child: Text(
                          '${config.activeIndex + 1}/${config.itemCount}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 14,fontWeight: FontWeight.w600,color: Colors.white,height: 1),
                        ),), right: 15,)
                      ],)
                  ),
                  constraints: const BoxConstraints.expand(height: 30.0),
                );
              })),
          // pagination: const SwiperPagination(
          //   margin: EdgeInsets.all(10),
          //   builder: DotSwiperPaginationBuilder(
          //     color: Colors.black12,
          //     activeColor: Colors.black,
          //     size: 5,
          //     activeSize: 6,
          //   )),
          itemCount: imageList.length,
        )
    );
  }

}

class ChartData {
  ChartData(this.x, this.y);
  final String x;
  final double y;
}

class CustomProgressBar extends StatelessWidget {
  final double value;
  final Color backgroundColor;
  final Color color;
  final double borderRadius;

  const CustomProgressBar({
    Key? key,
    required this.value,
    required this.backgroundColor,
    required this.color,
    this.borderRadius = 10.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 6,
      width: 100,
      alignment: Alignment.centerRight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        color: backgroundColor,
      ),
      child: FractionallySizedBox(
        widthFactor: value,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            color: color,
          ),
        ),
      ),
    );
  }
}