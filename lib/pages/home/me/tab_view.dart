import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lanla_flutter/common/Starrating.dart';
import 'package:lanla_flutter/common/controller/UserLogic.dart';
import 'package:lanla_flutter/models/commoditylistanalysis.dart';
import 'package:lanla_flutter/models/location.dart';
import 'package:lanla_flutter/models/topic.dart';
import 'package:lanla_flutter/pages/home/start/detail_view/loading_widget.dart';
import 'package:lanla_flutter/pages/home/start/detail_view/no_data_widget.dart';
import 'package:lanla_flutter/pages/user/login/view.dart';
import 'package:lanla_flutter/services/user.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../common/widgets/round_underline_tabindicator.dart';
import '../../../ulits/hex_color.dart';
import '../../detail/share/share.dart';
import '../start/detail_view/view.dart';

class UserTabView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _UserTabViewState();
}

/// DefaultTabController (TabBar + TabBarView) 使用 (内部还是TabController实现)
class _UserTabViewState extends State<UserTabView> {
  final userLogic = Get.find<UserLogic>();
  ScrollController _scrollControllerls = ScrollController();
  UserProvider userProvider = Get.put<UserProvider>(UserProvider());
  final List<Tab> myTabs = <Tab>[
    Tab(text: '作品'.tr,),
    Tab(text: '收藏'.tr),
    Tab(text: '赞过'.tr)
  ];
  var note = 1;
  bool oneData = false;
  var labellist = [];
  var FavoriteLocation=[];
  var goodthinglist=[];
  var hwpage=1;
  @override
  void initState() {
    super.initState();
    _scrollControllerls.addListener(() {
      if (_scrollControllerls.offset == _scrollControllerls.position.maxScrollExtent) {
        Collectgooditems();
      }
    });
  }
  @override
  Future<void> topiclist() async {
    var result = await userProvider.conversation(0);
    print('请求接口');
    print(result.statusCode);
    setState(() {
      oneData = true;
      labellist=topicModelFromJson(result?.bodyString ?? "");
    });
    print(result.bodyString);
    print(labellist);
    //topicModelFromJson(result?.bodyString ?? "");

    // conversation
  }

  ///收藏地点
  Future<void> Collectionlocation() async {
    var result = await userProvider.location(0);
    print('请求接口');
    print(result.statusCode);
    setState(() {
      oneData = true;
      FavoriteLocation=LocationFromJson(result?.bodyString ?? "");
    });
  }

  ///收藏好物接口
  Future<void> Collectgooditems() async {
    var result = await userProvider.getUserCollectGoodsList(0,hwpage);
    print('请求接口');
    if(result.statusCode==200){
      oneData = true;
      if(result?.bodyString!='[]'){
        goodthinglist.addAll(commoditylistanalysisFromJson(result.bodyString!));
        hwpage++;
      }
    }
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          TabBar(/// pym_
            tabs: myTabs,
            labelColor: Colors.black,
            labelPadding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
            isScrollable: true,
            indicator: CustomUnderlineTabIndicator(
                borderSide: BorderSide(
                  width: 4,
                  color: HexColor('#D1FF34'),
                )
            ),
            indicatorPadding: const EdgeInsets.only(bottom: 4),
            dividerColor: Colors.transparent,
            // labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          labelStyle: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            fontFamily: 'DroidArabicKufi',
          ),
            unselectedLabelColor: HexColor('#999999'),
            unselectedLabelStyle:
            // const TextStyle(fontWeight: FontWeight.w400,fontSize: 15,),
            const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              fontFamily: 'DroidArabicKufi',
            ),
          ),
          const Divider(height: 0, color: Color(0xffF1F1F1),),
          Expanded(
              child: GetBuilder<UserLogic>(builder: (logic) {
                return TabBarView(children: [
                  StartDetailPage(type: ApiType.myPublish, parameter: '0',lasting:false),
                  Container(
                    //decoration: BoxDecoration(border: Border.all(width: 1,color: Colors.red)),
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 10, bottom: 10),
                          child: Row(
                            children: [
                              SizedBox(width: 10,),
                              GestureDetector(child: Container(
                                child: Text('笔记'.tr +
                                    ' · ${userLogic.userInfo?.collect!=null?userLogic.userInfo?.collect
                                        .toString():'0'}', style: TextStyle(
                                  fontSize: 12,
                                  color: note==1 ? Color(0xff000000) : Color(
                                      0xff999999),
                                ),),
                                padding: EdgeInsets.fromLTRB(12, 8, 12, 8),
                                decoration: BoxDecoration(
                                  color: note==1 ? Color(0xffF5F5F5) : Colors
                                      .transparent,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ), onTap: () {
                                setState(() {
                                  note = 1;
                                  oneData=false;
                                });
                              },),
                              SizedBox(width: 10,),
                              GestureDetector(child: Container(
                                padding: EdgeInsets.fromLTRB(12, 8, 12, 8),
                                decoration: BoxDecoration(
                                  color: note==2 ? Color(0xffF5F5F5) : Colors
                                      .transparent,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Text('话题'.tr+' · ${userLogic.userInfo?.topics!=null?userLogic.userInfo?.topics
                                    .toString():'0'}', style: TextStyle(
                                  fontSize: 12,
                                  color: note==2 ? Color(0xff000000) : Color(
                                      0xff999999),
                                ),),
                              ), onTap: () {
                                setState(() {
                                  note = 2;
                                  oneData=false;
                                  topiclist();
                                });
                              },),
                              SizedBox(width: 10,),
                              GestureDetector(child: Container(
                                padding: EdgeInsets.fromLTRB(12, 8, 12, 8),
                                decoration: BoxDecoration(
                                  color: note==3 ? Color(0xffF5F5F5) : Colors
                                      .transparent,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Text('地点'.tr+' · ${userLogic.userInfo?.addressCollect!=null?userLogic.userInfo?.addressCollect
                                    .toString():'0'}', style: TextStyle(
                                  fontSize: 12,
                                  color: note==3 ? Color(0xff000000) : Color(
                                      0xff999999),
                                ),),
                              ), onTap: () {
                                setState(() {
                                  note=3;
                                  oneData=false;
                                  Collectionlocation();
                                });
                              },),
                              SizedBox(width: 10,),
                              GestureDetector(child: Container(
                                padding: EdgeInsets.fromLTRB(12, 8, 12, 8),
                                decoration: BoxDecoration(
                                  color: note==4 ? Color(0xffF5F5F5) : Colors
                                      .transparent,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Text('好物'.tr+' · ${userLogic.userInfo?.goodsCollectNum!=null?userLogic.userInfo?.goodsCollectNum
                                    .toString():'0'}', style: TextStyle(
                                  fontSize: 12,
                                  color: note==4 ? Color(0xff000000) : Color(
                                      0xff999999),
                                ),),
                              ), onTap: () {
                                // print(userLogic.userInfo);
                                // return;
                                setState(() {
                                  note=4;
                                  oneData = false;
                                  goodthinglist=[];
                                  hwpage=1;
                                  Collectgooditems();
                                });
                              },)
                            ],
                          ),
                        ),
                        // Divider(height: 1.0,color: Color(0xffe4e4e4),),
                        ///分割线
                        Container(
                          height: 1.0,
                          decoration: BoxDecoration(
                            color: Color(0xfff1f1f1),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0x0c00000),
                                offset: Offset(0, 2),
                                blurRadius: 5,
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                        ),
                        if(note==1) Expanded(
                          child: StartDetailPage(
                            type: ApiType.myCollect, parameter: '0',lasting:false),
                        ),
                        if(note==2) !oneData ? StartDetailLoading():Expanded(child:
                        labellist.length>0?ListView(
                            padding: EdgeInsets.only(left: 15, right: 15),
                            children: [
                              for(var i = 0; i < labellist.length; i++)
                                GestureDetector(
                                  onTap:(){
                                    Get.toNamed('/public/topic',arguments: labellist[i].id);
                                  },
                                  child: Column(children: [
                                    SizedBox(height: 20,),
                                    Row(
                                      children: [
                                        Container(
                                          width: 70,
                                          height: 47,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                                10),
                                          ),
                                          child: Image.network(labellist[i].thumbnail,fit: BoxFit.cover,),
                                          clipBehavior: Clip.hardEdge,
                                        ),
                                        SizedBox(width: 10,),
                                        Container(height: 47, child: Column(
                                          mainAxisAlignment: MainAxisAlignment
                                              .spaceBetween,
                                          crossAxisAlignment:CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Image.asset(
                                                  'assets/images/jinghao.png',
                                                  width: 20, height: 20,),
                                                SizedBox(width: 7,),
                                                Text(labellist[i].title)
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text(labellist[i].visits +' '+ '浏览'.tr,
                                                  style: TextStyle(fontSize: 12,
                                                      color: Color(0xff999999)),)
                                              ],
                                            )
                                          ],
                                        ),)
                                      ],
                                    ),
                                    SizedBox(height: 20,),

                                    ///分割线
                                    Container(
                                      height: 1.0,
                                      decoration: BoxDecoration(
                                        color: Color(0x06000000),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Color(0x0c00000),
                                            offset: Offset(0, 2),
                                            blurRadius: 5,
                                            spreadRadius: 0,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],),
                                )

                            ]
                        ):NoDataWidgetNoShoucang(),),
                        ///位置列表
                        if(note==3)  !oneData ? StartDetailLoading():Expanded(child:
                        FavoriteLocation.length>0?ListView(
                            padding: EdgeInsets.only(left: 15, right: 15),
                            children: [
                              for(var i = 0; i < FavoriteLocation.length; i++)
                                GestureDetector(child:Column(children: [
                                  SizedBox(height: 20,),
                                  Row(
                                    children: [
                                      Container(
                                        width: 78,
                                        height: 78,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              10),
                                        ),
                                        child: Image.network(FavoriteLocation[i].thumbnail,fit: BoxFit.cover,),
                                        clipBehavior: Clip.hardEdge,
                                      ),
                                      SizedBox(width: 10,),
                                      Container(height: 78, child: Column(
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceBetween,
                                        crossAxisAlignment:CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(FavoriteLocation[i].name)
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              for(var r=0;r<FavoriteLocation[i].types.length;r++)
                                                Row(
                                                  children: [
                                                    Text(FavoriteLocation[i].types[r],style: TextStyle(color: Colors.black,fontSize: 12),overflow: TextOverflow.ellipsis,),
                                                    if(r!=FavoriteLocation[i].types.length-1)Container(decoration: BoxDecoration(
                                                      border: Border.all(width: 0.5,color: Colors.black),
                                                    ),
                                                      height: 10,
                                                      margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                                    )
                                                  ],
                                                )
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(FavoriteLocation[i].createdAt,style: TextStyle(color: Color(0xff999999)),)
                                            ],
                                          )
                                        ],
                                      ),)
                                    ],
                                  ),
                                  SizedBox(height: 20,),

                                  ///分割线
                                  Container(
                                    height: 1.0,
                                    decoration: BoxDecoration(
                                      color: Color(0xfff1f1f1),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color(0x0c00000),
                                          offset: Offset(0, 2),
                                          blurRadius: 5,
                                          spreadRadius: 0,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],) ,onTap: (){
                                  print('885566');
                                  print(FavoriteLocation[i].createdAt.toString());
                                  print(FavoriteLocation[i].createdAt.toString());
                                  Get.toNamed('/public/geographical',arguments: FavoriteLocation[i]!.placeId);
                                },)
                            ]
// <<<<<<< HEAD
                        ):NoDataWidgetNoShoucang(),
                        ),
                        ///比价收藏
                        if(note==4)  !oneData ? StartDetailLoading():Expanded(child:
                        goodthinglist.length>0?ListView(
                            controller: _scrollControllerls,
                            //padding: EdgeInsets.only(left: 15, right: 15),
                            children: [
                              for(var i = 0; i < goodthinglist.length; i++)
                                GestureDetector(child:
                                Column(children: [
                                  Container(width: double.infinity,height: 10,color: Color(0xfff9f9f9),),
                                  SizedBox(height: 15,),
                                  Row(children: [SizedBox(width: 20,),Container(width: 50, height: 50,
                                    //超出部分，可裁剪
                                    clipBehavior: Clip.hardEdge,
                                    decoration: BoxDecoration(
                                      color:Color(0xfff5f5f5),
                                      borderRadius: BorderRadius.circular(5),
                                        border: Border.all(width: 0.5,color: Color(0xfff5f5f5))
                                    ),
                                    child: Image.network(
                                      goodthinglist[i].thumbnail,
                                      //fit: BoxFit.cover,
                                      fit: BoxFit.cover,
                                      width: 50,
                                      height: 50,
                                    ),
                                  ),SizedBox(width: 8,),Column(crossAxisAlignment:CrossAxisAlignment.start,children: [
                                    Container(constraints: BoxConstraints(maxWidth: 250,),child:
                                    Text(goodthinglist[i].title,overflow: TextOverflow.ellipsis,
                                      maxLines: 1,style: TextStyle(fontSize: 16),),),
                                      Row(children: [
                                        Container(height: 25,child: Text('评估'.tr,style: TextStyle(color: Color(0xff999999)),),),
                                        SizedBox(width: 5,),
                                        XMStartRating(rating: double.parse(goodthinglist[i].score) ,showtext:true)
                                      ],),
                                  ],)],),
                                  Container(height: 56,alignment: Alignment.centerRight,
                                    padding: EdgeInsets.fromLTRB(0, 10, 0,0),
                                    child: ListView(
                                        shrinkWrap: true,
                                        primary:false,
                                        scrollDirection: Axis.horizontal,
                                        children:[
                                          for(var j=0;j<jsonDecode(goodthinglist[i].priceOther).length;j++)
                                            GestureDetector(child:Container(margin:EdgeInsets.only(right: 10),width: 110,height: 56,decoration: BoxDecoration(border: Border.all(width: 0.5,color: Color((0xffF5F5F5))),
                                                color: Color(0xfff5f5f5),
                                                borderRadius: BorderRadius.all(Radius.circular(5))
                                            ),child: Column(mainAxisAlignment:MainAxisAlignment.center,children: [
                                              Row(mainAxisAlignment:MainAxisAlignment.center,children: [
                                                // Text("SAR",style: TextStyle(fontSize: 12,height: 1.1),),
                                                // SizedBox(width: 2,),
                                                Text(jsonDecode(goodthinglist[i].priceOther)[j]['price'].split(' ')[0],style: TextStyle(height: 1.3,fontSize: 15,fontWeight: FontWeight.w600),),
                                                SizedBox(width: 4,),
                                                Text(jsonDecode(goodthinglist[i].priceOther)[j]['price'].split(' ')[1],style: TextStyle(height: 1.3,fontSize: 12),)
                                              ],),
                                              Text(jsonDecode(goodthinglist[i].priceOther)[j]['platform'],style: TextStyle(fontSize: 12,color: Color(0xff999999)),)
                                            ],),) ,onTap: () async {
                                              await launchUrl(Uri.parse(jsonDecode(goodthinglist[i].priceOther)[j]['detailPath']), mode: LaunchMode.externalApplication,);
                                            },)
                                        ]),
                                  ),
                                  SizedBox(height: 15,),
                                ]),onTap: (){
                                  Get.toNamed('/public/Evaluationdetails',arguments: {'data':goodthinglist[i]} );
                                },)
                            ]
                        ):NoDataWidgetNoShoucang(),
                        ),
// =======
//                         ):NoDataWidgetNoShoucang(),
//                         )
// >>>>>>> 7aaba301624b1f32019baaaed8f0a16aa92a15b8
                      ],
                    ),
                  ),
                  // StartDetailPage( type: ApiType.myCollect, parameter: '0',),
                  StartDetailPage(type: ApiType.myLike, parameter: '0',lasting:false),
                ]);
              }))
        ],
      ),
    );
    // 1. 使用 DefaultTabController 作为外层控制器
    return DefaultTabController(
      length: myTabs.length, // 定义tab数量
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(tabs: myTabs // 定义TabWeight,若数量和定义不一致会报错
          ),
        ),
        // 3. 使用 TabBarView
        body: TabBarView(children: <Widget>[

          /// 全部订单
          Center(child: Text('全部订222单')),

          /// 已完成订单
          Center(child: Text('已完成')),

          /// 未完成订单
          Center(child: Text('未完成'))
        ]),
      ),
    );
  }
}






