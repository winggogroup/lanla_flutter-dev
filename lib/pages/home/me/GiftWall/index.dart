import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:lanla_flutter/common/controller/UserLogic.dart';
import 'package:lanla_flutter/common/widgets/round_underline_tabindicator.dart';
import 'package:lanla_flutter/models/userGiftDetail.dart';
import 'package:lanla_flutter/pages/home/start/detail_view/loading_widget.dart';
import 'package:lanla_flutter/pages/home/start/detail_view/logic.dart';
import 'package:lanla_flutter/pages/home/start/detail_view/no_data_widget.dart';
import 'package:lanla_flutter/services/newes.dart';
import 'package:lanla_flutter/ulits/hex_color.dart';
import 'package:url_launcher/url_launcher.dart';
class GiftWallPage extends StatefulWidget  {
  @override
  GiftWallState createState() => GiftWallState();
}
class GiftWallState extends State<GiftWallPage>with SingleTickerProviderStateMixin {
  final userLogic = Get.find<UserLogic>();
  late TabController channelTabController;
  NewesProvider provider =  Get.put(NewesProvider());
  final ScrollController _scrollController = ScrollController(); //listview 的控制器
  var NoContent=false;
  var giftlist=[];
  var oneData=false;
  int scpage=1;
  @override
  void initState() {
    super.initState();
    channelTabController = TabController(length: 2, vsync: this);
    //   ..addListener(() async {
    //   // or (tabController.indexIsChanging)
    //   print(channelTabController.index);
    //   setState(() {
    //     oneData=false;
    //     giftlist=[];
    //     scpage=1;
    //   });
    //   Initial(channelTabController.index+1,1);
    //
    // });

    _scrollController.addListener(() {
      if(_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent){
        scpage++;
        DropdownLoad();
      }
    });

    Initial(1,1);
  }
  Initial(type,page) async {
    var res=await provider.userGiftDetail(type,page);
    if(res.statusCode==200){
      var st =(userGiftDetailFromJson(res?.bodyString ?? ""));
      print('请求接口123${st.length}');
      if(st.isNotEmpty){
        giftlist=st;
      }else{
        NoContent=true;

      }
      oneData=true;
      setState(() {

      });
    }
  }

  DropdownLoad() async {
    var res=await provider.userGiftDetail(2,scpage);
    if(res.statusCode==200){
      var st =(userGiftDetailFromJson(res?.bodyString ?? ""));
      print('请求接口123${st.length}');
      if(st.isNotEmpty){
        giftlist.addAll(st);
      }else{
        scpage--;

      }
      oneData=true;
      setState(() {

      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            '礼物墙'.tr,
            style: const TextStyle(fontSize: 16),
          ),
        ),
        body: Column(children: [
          Container(
            height: 40,
            //padding: EdgeInsets.only(right: 10),
            // color: Colors.white,
            child: Row(
              children: [
                Expanded(
                    child:
                    TabBar(
                        labelColor: Colors.black,
                        //labelPadding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                        isScrollable: false,
                        indicator: CustomUnderlineTabIndicator(
                            borderSide: BorderSide(
                              width: 4,
                              color: HexColor('#000000'),
                            )
                        ),
                        // indicator: UnderlineTabIndicator(
                        //   borderSide: BorderSide(width: 4,  color: HexColor('#000000')), // 设置指示器的宽度和颜色
                        // ),
                        indicatorPadding: const EdgeInsets.only(left: 20,right: 20,bottom: 0),
                        dividerColor: const Color(0xffF1F1F1),
                        // labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                        labelStyle: const TextStyle(
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
                        controller: channelTabController,
                        //labelPadding: EdgeInsets.symmetric(horizontal: 0), // 设置左右间距为 16
                        //labelPadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        ///关闭登录验证
                        onTap: (index){
                          setState(() {
                            oneData=false;
                            giftlist=[];
                            scpage=1;
                          });
                          Initial(channelTabController.index+1,1);
                        },
                        // tabs: logic.state.channelDataSource
                        //     .map((item) => Tab(text: item.name))
                        //     .toList(),
                        tabs:[
                          Tab(text: '我收到的'.tr,),
                          Tab(text: '我送出的'.tr),

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
          !oneData ? StartDetailLoading():giftlist.isNotEmpty?Expanded(
            child: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              controller: channelTabController,
              children: [
                Container(child: Column(
                  //mainAxisAlignment:MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 35,),

                  //   Wrap(
                  //     spacing: 30.0, // 子组件之间的水平间距
                  //     runSpacing: 40.0, // 子组件之间的垂直间距
                  //   children: [
                  //     Container(
                  //       width: 85,
                  //       child: Column(children: [
                  //         Container(alignment: Alignment.center,width: 85,height: 85,decoration: BoxDecoration(color: Color(0xffF9F9F9),borderRadius: BorderRadius.all(Radius.circular(50))),child: Image.network('https://dayuhaichuang-dev2.oss-me-east-1.aliyuncs.com/gift/snowman.png',width: 60,height: 60,),),
                  //         SizedBox(height: 10,),
                  //         Text('x '+'22',style: TextStyle(fontWeight: FontWeight.w600),)
                  //       ],),
                  //
                  //     ),
                  //   ],
                  // ),
                    MasonryGridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      // controller:
                      // widget.type == ApiType.myPublish ? null : _controller,
                      //key: PageStorageKey(item.id),
                      crossAxisCount: 3,
                      mainAxisSpacing: 40,
                      // 上下间隔
                      // crossAxisSpacing: 10,
                      //左右间隔
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      // 总数
                      itemCount: giftlist.length,

                      itemBuilder: (context, index) {

                        //return Container(height:(index % 5 + 1) * 100, child: GestureDetector(onTap: (){Get.toNamed('/setting');},child: Text('第${index}个'),));
                        return Container(
                              width: 85,
                              child: Column(children: [
                                Container(alignment: Alignment.center,width: 85,height: 85,decoration: const BoxDecoration(color: Color(0xffF9F9F9),borderRadius: BorderRadius.all(Radius.circular(50))),child: Image.network(giftlist[index].imagePath,width: 60,height: 60,),),
                                const SizedBox(height: 10,),
                                Text('x '+giftlist[index].giftCount,style: const TextStyle(fontWeight: FontWeight.w600),)
                              ],),

                            );
                      },
                    )
                  ],
                ),),
                Container(padding: const EdgeInsets.only(left: 20,right: 20),child: ListView(physics: const BouncingScrollPhysics(),controller: _scrollController,children: [
                  for(var i=0;i<giftlist.length;i++)
                  Container(padding: const EdgeInsets.only(top: 20,bottom: 20,),
                    decoration: const BoxDecoration(border: Border(top: BorderSide(width: 1, color: Color(0xffF1F1F1)))),
                    child: Column(crossAxisAlignment:CrossAxisAlignment.start,children: [
                      Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children: [
                        Text(giftlist[i].nickname,style: const TextStyle(fontSize: 14),),
                        Row(children: [Text(giftlist[i].giftCount, strutStyle: const StrutStyle(
                          forceStrutHeight: true,
                          leading: 0.5,
                        ),),const SizedBox(width: 5,),const Text('x',strutStyle: StrutStyle(
                          forceStrutHeight: true,
                          leading: 0.5,
                        ),),const SizedBox(width: 5,),Image.network(giftlist[i].imagePath,width: 20,height: 20,)],)
                        
                      ],),
                      const SizedBox(height: 8,),
                      Text(giftlist[i].createdAt,style: const TextStyle(fontSize: 12,color: Color(0xff999999)),)
                    ],),
                  ),
                ],),),
              ],
            ),
          ):Nodatashuju(),
        ],),

      );
  }
}