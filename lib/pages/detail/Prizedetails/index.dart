import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lanla_flutter/common/widgets/round_underline_tabindicator.dart';
import 'package:lanla_flutter/pages/home/me/TaskCenter/index.dart';
import 'package:lanla_flutter/services/GiftDetails.dart';
import 'package:lanla_flutter/ulits/hex_color.dart';
import 'package:lanla_flutter/ulits/toast.dart';

class PrizedetailsPage extends StatefulWidget  {
  @override
  PrizedetailsState createState() => PrizedetailsState();
}

class PrizedetailsState extends State<PrizedetailsPage>with SingleTickerProviderStateMixin {
  final FocusNode _nodeText1 = FocusNode();
  late TabController channelTabController;
  final Interface = Get.put(GiftDetails());
  var exchangeuser=[];
  int exchangenum=0;
  String pinCod='';
  bool antishake=true;
  var commoditylist=[];
  var beikebi;


  @override
  void initState() {
    super.initState();

    commoditylist=Get.arguments['data'];
    beikebi=Get.arguments['beibi'];
    ParticipationInformation(Get.arguments['data'][0].id);
    channelTabController = TabController(length: Get.arguments['data'].length, vsync: this)..addListener(() async {
      // or (tabController.indexIsChanging)
      // print(channelTabController.index);
      setState(() {
        exchangeuser=[];
        exchangenum=0;
      });
      ParticipationInformation(Get.arguments['data'][channelTabController.index].id);
    });
    // Future.delayed(Duration(milliseconds: 10), () async {
    //
    // });
  }
  ParticipationInformation(id) async {

    var res= await Interface.exchangeProductUserInfo(id);
    if(res.statusCode==200){
      exchangenum=res.body['count'];
      exchangeuser=res.body['user'];
    }

    setState(() {

    });
  }
  ///兑换
  Giftredemption(id) async {
    setState(() {
      pinCod='';
    });
    if(antishake){
      antishake=false;
      var res= await Interface.exchangeShellsGift(id);
      if(res.statusCode==200){
        beikebi=res.body['balance'].toString();
        if(res.body['type']==2){
          pinCod=res.body['pinCode'];

          Redemptionsuccessfultwo(context);
        }else{
          Redemptionsuccessful(context);
        }
        ParticipationInformation(id);
        setState(() {

        });
      }
      antishake=true;
    }

  }

  ///兑换成功弹窗
  ///签到奖励弹窗
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
                    Container(width: double.infinity,alignment: Alignment.center,child: Text('兑换申请已提交'.tr,style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700),),),
                    SizedBox(height: 28,),
                    Container(padding: EdgeInsets.only(left: 26,right: 26),child: Text('审核通过后，会有LanLa客服人员在3日内联系你的'.tr,style: TextStyle(height: 2.3),),),
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

  Redemptionsuccessfultwo(context) async{
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
    // TODO: implement build
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(
      //     '填写邀请码',
      //     style: TextStyle(fontSize: 16),
      //   ),
      // ),
      body:
      Container(decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,//渐变开始于上面的中间开始
              end: Alignment.bottomCenter,//渐变结束于下面的中间
              colors: [Color(0xFFFF328B), Color(0xFFFF77A6),Color(0x72CDFF40),Color(0x4cF5F5F5),Color(0xffFFFFFF)])),
        //padding: EdgeInsets.only(left: 20,right: 20),
        child: Column(
          children: [
            SizedBox(height: MediaQueryData.fromWindow(window).padding.top,),
            Container(width: double.infinity,height: 60,child: Stack(children: [
              Container(
                width: double.infinity,
                height: 60,
                alignment: Alignment.center,
                child: Text('贝币兑换'.tr,style: TextStyle(fontWeight: FontWeight.w600,color: Colors.white),),
              ),
              Positioned(top:20,right:20,child: GestureDetector(child: SvgPicture.asset(
                "assets/svg/youjiantou.svg",
                width: 20,
                height: 20,
                color: Colors.white,
              ),onTap: (){
                Get.back();
              },),)

            ],),),
            Container(
              height: 40,
             padding: EdgeInsets.only(right: 10),
             // color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                      child:
                      TabBar(
                        ///取消指示器
                          indicator: const BoxDecoration(),

                          //indicatorPadding: EdgeInsets.only(right: 10),
                          ///分割线颜色
                          dividerColor: Colors.transparent,
                          ///指示器高度
                          //indicatorWeight: 1,
                          ///指示器颜色
                          //indicatorColor: Colors.red,
                          ///是否可以滚动
                          isScrollable: true,
                          ///选中字体样式
                          labelStyle: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            height: 1,
                            fontFamily: 'DroidArabicKufi',
                          ),
                          ///选中颜色
                          labelColor: Colors.black,
                          ///未选中的选项卡文本的样式
                          unselectedLabelStyle: TextStyle(
                            fontSize: 14,
                            height: 1,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'DroidArabicKufi',
                          ),
                          ///未选中的选项卡文本的颜色
                          unselectedLabelColor: HexColor('CCCCCC'),
                          controller: channelTabController,
                          //labelPadding: EdgeInsets.symmetric(horizontal: 0), // 设置左右间距为 16
                          labelPadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          ///关闭登录验证
                          // onTap: (index){
                          //   if (!userLogic.checkUserLogin()) {
                          //     logic.state.channelTabController.index = logic.state.channelTabController.previousIndex;
                          //     Get.toNamed('/public/loginmethod');
                          //     return;
                          //   }
                          // },
                          // tabs: logic.state.channelDataSource
                          //     .map((item) => Tab(text: item.name))
                          //     .toList(),
                          tabs:[
                            for(var i=0;i<commoditylist.length;i++)
                              i==0?Tab(child: Row(children: [SizedBox(width: 10,),Text('进行中'.tr),SizedBox(width: 10,),],),):
                              Tab(child: Row(children: [Container(height: 14,width: 2,color: Color(0x7Fffffff)),SizedBox(width: 10,),Text('进行中'.tr),SizedBox(width: 10,),],),),

                          ]
                      )

                      ),

                  ///下拉按钮
                  // GestureDetector(
                  //   onTap: (){
                  //     ToastInfo('没有更多了'.tr);
                  //   },
                  //   child: Container(
                  //     alignment: Alignment.centerRight,
                  //     child: Icon(
                  //       Icons.expand_more,
                  //       color: HexColor('666666'),
                  //       size: 28,
                  //     ),
                  //     width: 40,
                  //   ),
                  // )
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: channelTabController,
                children: [
                  for(var i=0;i<commoditylist.length;i++)
                  Container(margin: EdgeInsets.only(top: 20),padding: EdgeInsets.only(left: 20,right: 20),child:
                    Column(children: [
                      Expanded(child: Container(padding: EdgeInsets.only(left: 15,right: 15),decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)),color: Colors.white,),
                        child: Column(children: [
                          SizedBox(height: 25,),
                          Container(alignment: Alignment.center,height: 178,child: Container(decoration: BoxDecoration(color: Color(0xfff5f5f5),borderRadius: BorderRadius.all(Radius.circular(8))),width: 178,height: 178,child:
                          Image.network(commoditylist[i].image,width: 148,height: 148,),),),
                          SizedBox(height: 25,),
                          Container(width: double.infinity,height: 1,color: Color(0xffF1F1F1),),
                          SizedBox(height: 25,),
                          Expanded(child: Column(mainAxisAlignment:MainAxisAlignment.spaceBetween,children: [
                            ///奖品名称
                            Column(children: [
                              Row(children: [
                                Container(width: 6,height: 6,decoration: BoxDecoration(color: Color(0xffA8F600),borderRadius: BorderRadius.all(Radius.circular(50))),),
                                SizedBox(width: 8,),
                                Text('奖品名称'.tr,style: TextStyle(color: Color(0xff666666),fontSize: 12),)
                              ],),
                              SizedBox(height: 10,),
                              Container(alignment: Alignment.centerRight,margin: EdgeInsets.only(right: 12),child: Text(commoditylist[i].title,style: TextStyle(fontSize: 13),),),
                            ],),

                            //SizedBox(height: 40,),
                            ///兑换说明
                            Column(children: [
                              Row(children: [
                                Container(width: 6,height: 6,decoration: BoxDecoration(color: Color(0xffA8F600),borderRadius: BorderRadius.all(Radius.circular(50))),),
                                SizedBox(width: 8,),
                                Text('兑换时间'.tr,style: TextStyle(color: Color(0xff666666),fontSize: 12),)
                              ],),
                              SizedBox(height: 10,),
                              Container(alignment: Alignment.centerRight,margin: EdgeInsets.only(right: 12),child: Text('兑完为止'.tr,style: TextStyle(fontSize: 13),),),
                            ],),

                            //SizedBox(height: 40,),

                            ///参与人数
                            Column(children: [
                              Row(children: [
                                Container(width: 6,height: 6,decoration: BoxDecoration(color: Color(0xffA8F600),borderRadius: BorderRadius.all(Radius.circular(50))),),
                                SizedBox(width: 8,),
                                Text('兑换进程'.tr,style: TextStyle(color: Color(0xff666666),fontSize: 12),)
                              ],),
                              SizedBox(height: 18,),
                              Container(
                                height: 4, // 进度条高度
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Color(0xffF5F5F5),
                                  borderRadius: BorderRadius.circular(5), // 圆角边框
                                ),
                                child: LayoutBuilder(builder:
                                    (BuildContext context,
                                    BoxConstraints constraints) {
                                  double boxWidth = constraints.maxWidth;
                                  return Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      FractionallySizedBox(
                                        alignment: Alignment.centerLeft,
                                        widthFactor: commoditylist[i].total==0?0:exchangenum/commoditylist[i].total,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Color(0xffD1FF34), // 进度条颜色
                                            borderRadius:
                                            BorderRadius.circular(
                                                5), // 圆角边框
                                          ),
                                        ),
                                      ),
                                      if(commoditylist[i].total!=0)Positioned(
                                        top: -6,
                                        right: boxWidth*(exchangenum/commoditylist[i].total)-8, // 控制指示器的水平位置
                                        child: Container(
                                          width: 16, // 指示器的宽度
                                          height: 16, // 指示器的高度
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white, // 指示器的颜色
                                            border: Border.all(
                                                color: Color(0xffD1FF34),
                                                width: 4), // 边框为蓝色，宽度为2
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }),
                              ),
                              SizedBox(height: 13,),
                              Container(height: 21,child:Stack(children: [
                                if(exchangenum>=3)Positioned(right: 32,child: Container(clipBehavior: Clip.hardEdge,width: 21,height: 21,child: Image.network(exchangeuser[2]['headimg'],fit: BoxFit.cover,),decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(50))),)),
                                if(exchangenum>=2)Positioned(right: 16,child: Container(clipBehavior: Clip.hardEdge,width: 21,height: 21,child: Image.network(exchangeuser[1]['headimg'],fit: BoxFit.cover,),decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(50))))),
                                if(exchangenum>=1)Positioned(right: 0,child: Container(clipBehavior: Clip.hardEdge,width: 21,height: 21,child: Image.network(exchangeuser[0]['headimg'],fit: BoxFit.cover,),decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(50))))),
                                Positioned(top: 3,right: exchangenum==0?0:exchangenum==1?27:exchangenum==2?43:59,child: Text(exchangenum.toString()+'人参与'.tr,style: TextStyle(fontSize: 12),)),
                                Positioned(top: 3,left: 0,child: Row(children: [Text('共'.tr,style: TextStyle(fontSize: 12,height: 1.2),),
                                  Text(commoditylist[i].total.toString(),style: TextStyle(fontSize: 12,height: 1.2,fontWeight: FontWeight.w700),),
                                  Text('份'.tr,style: TextStyle(fontSize: 12,height: 1.2),)],)),
                              ],),),
                            ],)
                          ],)),
                          SizedBox(height: 25,),



                          
                        ],),
                      ),),
                      SizedBox(height: 20,),
                      Container(
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Image.asset(
                                        'assets/images/beiketwo.png',
                                        width: 30,
                                        height: 30,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        commoditylist[i].price,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 29,
                                            height: 1),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  int.parse(beikebi) <
                                      int.parse(commoditylist[i].price=='???'?"0":commoditylist[i].price)
                                      ? Row(
                                          children: [
                                            Expanded(
                                                child: Container(
                                              alignment: Alignment.center,
                                              height: 45,
                                              decoration: BoxDecoration(
                                                  color: Color(0xffF5F5F5),
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topRight:
                                                              Radius.circular(
                                                                  30),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  30))),
                                              child: Text('贝壳不足'.tr,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color:
                                                          Color(0xff999999))),
                                            )),
                                            GestureDetector(
                                              child: Container(
                                                  alignment: Alignment.center,
                                                  height: 45,
                                                  width: 146,
                                                  decoration: BoxDecoration(
                                                      color: Color(0xffFF739D),
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              topLeft: Radius
                                                                  .circular(30),
                                                              bottomLeft: Radius
                                                                  .circular(
                                                                      30))),
                                                  child: Text(
                                                    '去赚取'.tr,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: Colors.white),
                                                  )),
                                              onTap: () {
                                                Get.to(TaskCenterPage());
                                              },
                                            )
                                          ],
                                        )
                                      : GestureDetector(child: Container(
                                      alignment: Alignment.center,
                                      height: 45,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          color: Color(0xffFF739D),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(30))),
                                      child: Text(
                                        '立即兑换'.tr,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white),
                                      )),onTap: (){
                                        if(commoditylist[i].stock!=0){
                                          Giftredemption(commoditylist[i].id);
                                        }else{
                                          // ToastInfo('没有库存了');
                                        }

                                  },),
                                  SizedBox(
                                    height: 50,
                                  ),
                                ],
                              ),
                            )
                          ],)

                  ),
                  // Container(margin: EdgeInsets.only(top: 20),color: Colors.red,),
                  // Container(margin: EdgeInsets.only(top: 20),color: Colors.red,),
                ],
              ),
            ),
          ],
        ),),

    );
  }
}




